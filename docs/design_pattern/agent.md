---
layout: default
title: "Field Agent System"
parent: "Design Pattern"
nav_order: 4
---

# Field Agent System

The BoxFresh App implements an agent-based pattern for field technicians, optimizing service delivery through intelligent routing, real-time updates, and automated decision-making.

## Agent Structure

Each field technician operates as an autonomous agent within the system:

### 1. Resource Unit Model

Each technician is represented as a Resource_Unit__c record with:

- **Skills and Certifications**: Specific service capabilities
- **Equipment Access**: Tools and machinery available
- **Geographic Zones**: Primary and secondary service areas
- **Time Availability**: Working hours and blackout periods

### 2. Agent States

Technicians transition through defined states during operations:

- **Available**: Ready for assignment
- **En Route**: Traveling to service location
- **On Site**: Performing service at location
- **On Break**: Temporarily unavailable
- **Off Duty**: Not available for assignment

## Intelligent Routing

The system uses a sophisticated routing algorithm to match service requirements with technician capabilities:

### Location-Based Assignment

```apex
public static List<Resource_Unit__c> findNearbyTechnicians(Id propertyId, Date serviceDate) {
    Property__c property = [
        SELECT Id, Geolocation__Latitude__s, Geolocation__Longitude__s
        FROM Property__c
        WHERE Id = :propertyId
    ];
    
    // Find technicians within 50 miles who are available on the service date
    return [
        SELECT Id, Name, 
               Geolocation__Latitude__s, Geolocation__Longitude__s,
               Skills__c, Certifications__c
        FROM Resource_Unit__c
        WHERE Status__c = 'Available'
        AND CALENDAR_MONTH(serviceDate) = CALENDAR_MONTH(Available_Date__c)
        AND CALENDAR_DAY(serviceDate) = CALENDAR_DAY(Available_Date__c)
        AND DISTANCE(Geolocation__c, 
                    GEOLOCATION(:property.Geolocation__Latitude__s, 
                               :property.Geolocation__Longitude__s), 'mi') < 50
        ORDER BY DISTANCE(Geolocation__c, 
                         GEOLOCATION(:property.Geolocation__Latitude__s, 
                                    :property.Geolocation__Longitude__s), 'mi')
    ];
}
```

### Skill-Based Matching

```apex
public static List<Resource_Unit__c> findQualifiedTechnicians(Id serviceId, List<Resource_Unit__c> nearbyTechnicians) {
    Service_Item__c service = [
        SELECT Id, Service_Type__c, Required_Skills__c, Required_Certifications__c
        FROM Service_Item__c
        WHERE Id = :serviceId
    ];
    
    List<Resource_Unit__c> qualifiedTechnicians = new List<Resource_Unit__c>();
    
    for (Resource_Unit__c tech : nearbyTechnicians) {
        // Parse comma-separated skills and certifications
        Set<String> techSkills = new Set<String>(tech.Skills__c.split(','));
        Set<String> techCerts = new Set<String>(tech.Certifications__c.split(','));
        Set<String> requiredSkills = new Set<String>(service.Required_Skills__c.split(','));
        Set<String> requiredCerts = new Set<String>(service.Required_Certifications__c.split(','));
        
        // Check if technician has all required skills and certifications
        Boolean hasRequiredSkills = techSkills.containsAll(requiredSkills);
        Boolean hasRequiredCerts = techCerts.containsAll(requiredCerts);
        
        if (hasRequiredSkills && hasRequiredCerts) {
            qualifiedTechnicians.add(tech);
        }
    }
    
    return qualifiedTechnicians;
}
```

### Optimization Factors

The routing engine considers multiple factors:

1. **Travel Efficiency**: Minimize travel time between appointments
2. **Skill Matching**: Optimal technician skill allocation
3. **Time Window Compliance**: Meet customer scheduling preferences
4. **Workload Balancing**: Distribute work evenly across the team

## Real-Time Operations

The system enables real-time monitoring and adjustments:

### Location Tracking

```apex
public static void updateTechnicianLocation(Id resourceUnitId, Decimal latitude, Decimal longitude) {
    Resource_Unit__c technician = [
        SELECT Id, Geolocation__Latitude__s, Geolocation__Longitude__s
        FROM Resource_Unit__c
        WHERE Id = :resourceUnitId
    ];
    
    technician.Geolocation__Latitude__s = latitude;
    technician.Geolocation__Longitude__s = longitude;
    
    // Calculate ETA for current assignment if exists
    Assignment__c currentAssignment = [
        SELECT Id, Status__c, Property__r.Geolocation__Latitude__s, 
               Property__r.Geolocation__Longitude__s
        FROM Assignment__c
        WHERE Resource_Unit__c = :resourceUnitId
        AND Status__c = 'En Route'
        LIMIT 1
    ];
    
    if (currentAssignment != null) {
        // Calculate distance to destination
        Double distance = calculateDistance(
            latitude, longitude,
            currentAssignment.Property__r.Geolocation__Latitude__s,
            currentAssignment.Property__r.Geolocation__Longitude__s
        );
        
        // Update ETA based on distance and average speed
        Integer estimatedMinutes = (Integer)(distance / AVERAGE_SPEED_MPH * 60);
        currentAssignment.Estimated_Arrival_Time__c = Datetime.now().addMinutes(estimatedMinutes);
        
        update currentAssignment;
    }
    
    update technician;
}
```

### Status Updates

```apex
public static void updateAssignmentStatus(Id assignmentId, String newStatus, String notes) {
    Assignment__c assignment = [
        SELECT Id, Status__c, Resource_Unit__c, Order__c
        FROM Assignment__c
        WHERE Id = :assignmentId
    ];
    
    assignment.Status__c = newStatus;
    assignment.Status_Notes__c = notes;
    assignment.Status_Updated_Time__c = Datetime.now();
    
    // Update resource unit status based on assignment status
    Resource_Unit__c tech = [SELECT Id FROM Resource_Unit__c WHERE Id = :assignment.Resource_Unit__c];
    
    switch on newStatus {
        when 'En Route' {
            tech.Status__c = 'En Route';
            // Notify customer that technician is on the way
            notifyCustomerOfStatus(assignment.Order__c, 'en_route');
        }
        when 'On Site' {
            tech.Status__c = 'On Site';
            // Notify customer that technician has arrived
            notifyCustomerOfStatus(assignment.Order__c, 'arrived');
        }
        when 'Completed' {
            tech.Status__c = 'Available';
            // Notify customer that service is complete
            notifyCustomerOfStatus(assignment.Order__c, 'completed');
        }
    }
    
    update assignment;
    update tech;
}
```

## Decision Automation

The system automates key decisions to optimize daily operations:

### Rescheduling Logic

```apex
public static void handleReschedulingRequest(Id assignmentId, Date requestedDate) {
    Assignment__c assignment = [
        SELECT Id, Order__c, Resource_Unit__c, Service_Date__c,
               Order__r.Service_Item__r.Required_Skills__c,
               Order__r.Property__c
        FROM Assignment__c
        WHERE Id = :assignmentId
    ];
    
    // Find available technicians for the new date with required skills
    List<Resource_Unit__c> availableTechs = [
        SELECT Id, Name
        FROM Resource_Unit__c
        WHERE Status__c = 'Available'
        AND CALENDAR_MONTH(requestedDate) = CALENDAR_MONTH(Available_Date__c)
        AND CALENDAR_DAY(requestedDate) = CALENDAR_DAY(Available_Date__c)
        AND Skills__c INCLUDES (:assignment.Order__r.Service_Item__r.Required_Skills__c)
    ];
    
    if (!availableTechs.isEmpty()) {
        // Get closest technician to property
        Resource_Unit__c newTech = findClosestTechnician(availableTechs, assignment.Order__r.Property__c);
        
        // Reschedule assignment
        assignment.Resource_Unit__c = newTech.Id;
        assignment.Service_Date__c = requestedDate;
        assignment.Status__c = 'Scheduled';
        
        update assignment;
        
        // Notify customer of successful rescheduling
        notifyCustomerOfReschedule(assignment.Order__c, requestedDate, newTech.Name);
    } else {
        // Create task for manual handling if no automatic reschedule possible
        Task rescheduleTask = new Task(
            Subject = 'Manual Reschedule Required',
            WhatId = assignment.Order__c,
            Status = 'Not Started',
            Priority = 'High',
            Description = 'Customer requested reschedule to ' + requestedDate + 
                         ' but no qualified technicians are available.'
        );
        
        insert rescheduleTask;
        
        // Notify customer of pending reschedule
        notifyCustomerOfPendingReschedule(assignment.Order__c);
    }
}
```

### Service Prioritization

```yaml
service_priority_rules:
  - condition: "Service_Type__c = 'Emergency'"
    priority: 1
    override_existing: true
    
  - condition: "Account_Tier__c = 'Platinum'"
    priority: 2
    override_existing: false
    
  - condition: "Days_Since_Last_Service__c > 30"
    priority: 3
    override_existing: false
    
  - condition: "Weather_Risk__c = 'High'"
    priority: 2
    override_existing: true
    
  - default_priority: 5
```

## Mobile Agent Interface

Field technicians interact with the system through a dedicated mobile application:

### Core Features

1. **Daily Schedule View**: Visualize appointments in chronological order
2. **Navigation Integration**: Turn-by-turn directions to service locations
3. **Service Protocols**: Step-by-step guides for different service types
4. **Inventory Management**: Track material usage and stock levels
5. **Signature Capture**: Record customer approvals and feedback

### Data Synchronization

```apex
public static void synchronizeMobileData(Id resourceUnitId, String jsonData) {
    // Parse incoming JSON data
    Map<String, Object> dataMap = (Map<String, Object>) JSON.deserializeUntyped(jsonData);
    
    // Process completed assignments
    List<Map<String, Object>> completedAssignments = 
        (List<Map<String, Object>>) dataMap.get('completed_assignments');
    
    for (Map<String, Object> assignmentData : completedAssignments) {
        Id assignmentId = (Id) assignmentData.get('id');
        
        // Update assignment status
        Assignment__c assignment = new Assignment__c(
            Id = assignmentId,
            Status__c = 'Completed',
            Completion_Notes__c = (String) assignmentData.get('notes'),
            Actual_Duration__c = (Decimal) assignmentData.get('duration')
        );
        
        update assignment;
        
        // Process service items
        List<Map<String, Object>> serviceItems = 
            (List<Map<String, Object>>) assignmentData.get('service_items');
        
        List<Service_Delivery__c> deliveriesToInsert = new List<Service_Delivery__c>();
        
        for (Map<String, Object> item : serviceItems) {
            Service_Delivery__c delivery = new Service_Delivery__c(
                Assignment__c = assignmentId,
                Service_Item__c = (Id) item.get('service_item_id'),
                Quantity__c = (Decimal) item.get('quantity'),
                Notes__c = (String) item.get('notes')
            );
            
            deliveriesToInsert.add(delivery);
        }
        
        insert deliveriesToInsert;
        
        // Process material usage
        List<Map<String, Object>> materials = 
            (List<Map<String, Object>>) assignmentData.get('materials');
        
        List<Material_Usage__c> usagesToInsert = new List<Material_Usage__c>();
        
        for (Map<String, Object> material : materials) {
            Material_Usage__c usage = new Material_Usage__c(
                Assignment__c = assignmentId,
                Inventory_Item__c = (Id) material.get('inventory_item_id'),
                Quantity__c = (Decimal) material.get('quantity')
            );
            
            usagesToInsert.add(usage);
        }
        
        insert usagesToInsert;
    }
    
    // Update technician status and location
    Map<String, Object> techData = (Map<String, Object>) dataMap.get('technician');
    
    Resource_Unit__c tech = new Resource_Unit__c(
        Id = resourceUnitId,
        Status__c = (String) techData.get('status'),
        Geolocation__Latitude__s = (Decimal) techData.get('latitude'),
        Geolocation__Longitude__s = (Decimal) techData.get('longitude')
    );
    
    update tech;
}
```

## Benefits of Agent System

1. **Optimized Service Delivery**: Efficient routing reduces travel time and increases service capacity
2. **Improved Customer Experience**: Real-time updates and accurate ETAs enhance satisfaction
3. **Balanced Workloads**: Equitable distribution of assignments based on skills and location
4. **Adaptability**: System automatically adjusts to changing conditions (weather, traffic, cancellations)
5. **Data-Driven Improvements**: Performance analytics identify optimization opportunities

## Agent Performance Metrics

The system tracks key performance indicators for field technicians:

### Individual Metrics

- **On-Time Arrival Rate**: Percentage of services started within scheduled window
- **Service Completion Time**: Average time to complete services by type
- **Customer Satisfaction**: Average rating from post-service surveys
- **Service Efficiency**: Number of services completed per day
- **Material Usage Accuracy**: Variance between estimated and actual material usage

### Team Metrics

- **Geographic Coverage**: Heat map of service locations and technician distribution
- **Skill Utilization**: Allocation of specialized skills across team
- **Fleet Efficiency**: Total miles driven per service completed
- **Schedule Adherence**: Percentage of completed services as scheduled
- **Overtime Usage**: Distribution of work hours vs. standard schedules 