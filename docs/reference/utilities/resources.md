---
layout: default
title: "Resource Allocation"
parent: "Utility Functions"
grand_parent: "Reference Documentation"
nav_order: 3
---

# Resource Allocation

The BoxFresh App includes utility functions for managing and allocating resources to service jobs. These functions provide a consistent interface for interacting with the resource objects.

## Resource Availability Functions

### get_resource_availability

Retrieves the availability of resources for a specified date range.

```apex
public static Map<Id, ResourceAvailability> get_resource_availability(Date startDate, Date endDate) {
    Map<Id, ResourceAvailability> results = new Map<Id, ResourceAvailability>();
    
    // Query resource units
    List<Resource_Unit__c> units = [
        SELECT Id, Name, Capacity__c,
               (SELECT Id, Start_Time__c, End_Time__c 
                FROM Assignments__r 
                WHERE Start_Time__c >= :startDate 
                AND End_Time__c <= :endDate)
        FROM Resource_Unit__c
        WHERE Is_Active__c = true
    ];
    
    // Calculate availability for each resource unit
    for (Resource_Unit__c unit : units) {
        // Create a map of date to assignments for that date
        Map<Date, List<Assignment__c>> assignmentsByDate = new Map<Date, List<Assignment__c>>();
        
        for (Assignment__c assign : unit.Assignments__r) {
            Date assignDate = assign.Start_Time__c.date();
            if (!assignmentsByDate.containsKey(assignDate)) {
                assignmentsByDate.put(assignDate, new List<Assignment__c>());
            }
            assignmentsByDate.get(assignDate).add(assign);
        }
        
        // Calculate available capacity for each date
        Map<Date, Decimal> availableCapacityByDate = new Map<Date, Decimal>();
        
        Date currentDate = startDate;
        while (currentDate <= endDate) {
            Decimal dailyCapacity = unit.Capacity__c;
            
            if (assignmentsByDate.containsKey(currentDate)) {
                Integer assignmentsCount = assignmentsByDate.get(currentDate).size();
                dailyCapacity -= assignmentsCount;
            }
            
            availableCapacityByDate.put(currentDate, Math.max(0, dailyCapacity));
            currentDate = currentDate.addDays(1);
        }
        
        // Create ResourceAvailability object
        results.put(unit.Id, new ResourceAvailability(
            unit.Id,
            unit.Name,
            unit.Capacity__c,
            availableCapacityByDate
        ));
    }
    
    return results;
}
```

### find_available_resources

Finds resources that are available for a specific date and time range.

```apex
public static List<Resource_Unit__c> find_available_resources(
    Date serviceDate, 
    Time startTime, 
    Time endTime, 
    String serviceLocation,
    List<String> requiredSkills
) {
    // Query resource units with their assignments and associated resources
    List<Resource_Unit__c> units = [
        SELECT Id, Name, Primary_Location__c, Travel_Radius__c,
               (SELECT Id, Start_Time__c, End_Time__c 
                FROM Assignments__r 
                WHERE Scheduled_Date__c = :serviceDate),
               (SELECT Id, Skill_Set__c
                FROM Resources__r)
        FROM Resource_Unit__c
        WHERE Is_Active__c = true
    ];
    
    // Filter units based on availability, location, and skills
    List<Resource_Unit__c> availableUnits = new List<Resource_Unit__c>();
    
    for (Resource_Unit__c unit : units) {
        // Check for time conflicts
        Boolean hasConflict = false;
        for (Assignment__c assign : unit.Assignments__r) {
            // Convert DateTime to Time for comparison
            Time assignStart = assign.Start_Time__c.time();
            Time assignEnd = assign.End_Time__c.time();
            
            // Check for overlap
            if (!(endTime <= assignStart || startTime >= assignEnd)) {
                hasConflict = true;
                break;
            }
        }
        
        if (hasConflict) {
            continue;
        }
        
        // Check location constraints
        if (serviceLocation != null && unit.Primary_Location__c != null) {
            // This is a simplified location check
            // In a real implementation, you would calculate distance
            if (unit.Primary_Location__c != serviceLocation) {
                // Check if within travel radius (simplified)
                // In a real implementation, you would use geolocation
                continue;
            }
        }
        
        // Check required skills
        if (requiredSkills != null && !requiredSkills.isEmpty()) {
            Boolean hasRequiredSkills = false;
            
            for (Resource__c resource : unit.Resources__r) {
                Set<String> resourceSkills = new Set<String>();
                if (resource.Skill_Set__c != null) {
                    resourceSkills.addAll(resource.Skill_Set__c.split(';'));
                }
                
                Boolean resourceHasAllSkills = true;
                for (String skill : requiredSkills) {
                    if (!resourceSkills.contains(skill)) {
                        resourceHasAllSkills = false;
                        break;
                    }
                }
                
                if (resourceHasAllSkills) {
                    hasRequiredSkills = true;
                    break;
                }
            }
            
            if (!hasRequiredSkills) {
                continue;
            }
        }
        
        availableUnits.add(unit);
    }
    
    return availableUnits;
}
```

## Resource Assignment Functions

### create_assignment

Creates a new assignment for a resource unit.

```apex
public static Assignment__c create_assignment(
    Id resourceUnitId,
    Id serviceOrderId,
    Date scheduledDate,
    Time startTime,
    Time endTime,
    Decimal estimatedDuration
) {
    // Validate resource availability
    validateResourceAvailability(resourceUnitId, scheduledDate, startTime, endTime);
    
    // Create new assignment
    Assignment__c assignment = new Assignment__c(
        Resource_Unit__c = resourceUnitId,
        Order__c = serviceOrderId,
        Scheduled_Date__c = scheduledDate,
        Start_Time__c = DateTime.newInstance(
            scheduledDate, 
            startTime
        ),
        End_Time__c = DateTime.newInstance(
            scheduledDate,
            endTime
        ),
        Estimated_Duration__c = estimatedDuration,
        Status__c = 'Scheduled'
    );
    
    insert assignment;
    return assignment;
}

private static void validateResourceAvailability(
    Id resourceUnitId, 
    Date scheduledDate,
    Time startTime,
    Time endTime
) {
    // Check for existing assignments that would conflict
    List<Assignment__c> conflictingAssignments = [
        SELECT Id
        FROM Assignment__c
        WHERE Resource_Unit__c = :resourceUnitId
        AND Scheduled_Date__c = :scheduledDate
        AND ((Start_Time__c.time() <= :endTime AND End_Time__c.time() >= :startTime))
        AND Status__c != 'Cancelled'
    ];
    
    if (!conflictingAssignments.isEmpty()) {
        throw new ResourceException('Resource has conflicting assignments for the specified time');
    }
}
```

### update_assignment_status

Updates the status of an assignment.

```apex
public static Assignment__c update_assignment_status(Id assignmentId, String newStatus) {
    // Get the assignment
    Assignment__c assignment = [
        SELECT Id, Status__c, Start_Time__c, End_Time__c
        FROM Assignment__c
        WHERE Id = :assignmentId
    ];
    
    // Validate status transition
    validateStatusTransition(assignment.Status__c, newStatus);
    
    // Update the assignment
    assignment.Status__c = newStatus;
    
    // If completing the assignment, set the actual end time
    if (newStatus == 'Completed') {
        assignment.Actual_End_Time__c = DateTime.now();
        
        // Calculate actual duration
        if (assignment.Start_Time__c != null) {
            Long durationMs = assignment.Actual_End_Time__c.getTime() - assignment.Start_Time__c.getTime();
            assignment.Actual_Duration__c = durationMs / (1000.0 * 60 * 60); // Convert to hours
        }
    }
    
    update assignment;
    return assignment;
}

private static void validateStatusTransition(String currentStatus, String newStatus) {
    // Define valid status transitions
    Map<String, Set<String>> validTransitions = new Map<String, Set<String>>{
        'Scheduled' => new Set<String>{'In Progress', 'Cancelled'},
        'In Progress' => new Set<String>{'Completed', 'On Hold'},
        'On Hold' => new Set<String>{'In Progress', 'Cancelled'},
        'Completed' => new Set<String>{},
        'Cancelled' => new Set<String>{}
    };
    
    // Check if the transition is valid
    if (!validTransitions.containsKey(currentStatus) || 
        !validTransitions.get(currentStatus).contains(newStatus)) {
        throw new ResourceException('Invalid status transition from ' + currentStatus + ' to ' + newStatus);
    }
}
```

## Resource Scheduling Functions

### optimize_schedule

Optimizes the schedule for a set of assignments.

```apex
public static List<Assignment__c> optimize_schedule(Date targetDate) {
    // Get all assignments for the target date
    List<Assignment__c> assignments = [
        SELECT Id, Resource_Unit__c, Order__r.Service_Location__c,
               Scheduled_Date__c, Start_Time__c, End_Time__c, Status__c
        FROM Assignment__c
        WHERE Scheduled_Date__c = :targetDate
        AND Status__c = 'Scheduled'
        ORDER BY Start_Time__c ASC
    ];
    
    // Group assignments by resource
    Map<Id, List<Assignment__c>> assignmentsByResource = new Map<Id, List<Assignment__c>>();
    
    for (Assignment__c assignment : assignments) {
        if (!assignmentsByResource.containsKey(assignment.Resource_Unit__c)) {
            assignmentsByResource.put(assignment.Resource_Unit__c, new List<Assignment__c>());
        }
        assignmentsByResource.get(assignment.Resource_Unit__c).add(assignment);
    }
    
    // Optimize each resource's schedule
    List<Assignment__c> optimizedAssignments = new List<Assignment__c>();
    
    for (Id resourceId : assignmentsByResource.keySet()) {
        List<Assignment__c> resourceAssignments = assignmentsByResource.get(resourceId);
        
        // Sort by location to minimize travel time (simplified)
        // In a real implementation, you would use a more sophisticated algorithm
        resourceAssignments.sort(new AssignmentLocationComparator());
        
        // Update start and end times to create an efficient schedule
        Time currentTime = Time.newInstance(9, 0, 0, 0); // Start at 9 AM
        
        for (Assignment__c assignment : resourceAssignments) {
            // Get estimated duration from the difference between start and end time
            Long durationMs = assignment.End_Time__c.getTime() - assignment.Start_Time__c.getTime();
            Integer durationMinutes = (Integer)(durationMs / (1000 * 60));
            
            // Set new start time
            assignment.Start_Time__c = DateTime.newInstance(
                targetDate,
                currentTime
            );
            
            // Calculate new end time
            Integer endHour = currentTime.hour();
            Integer endMinute = currentTime.minute() + durationMinutes;
            
            // Adjust for minute overflow
            while (endMinute >= 60) {
                endHour++;
                endMinute -= 60;
            }
            
            Time endTime = Time.newInstance(endHour, endMinute, 0, 0);
            assignment.End_Time__c = DateTime.newInstance(targetDate, endTime);
            
            // Add travel time for next assignment (simplified: 30 minutes)
            endMinute += 30;
            while (endMinute >= 60) {
                endHour++;
                endMinute -= 60;
            }
            
            currentTime = Time.newInstance(endHour, endMinute, 0, 0);
            
            optimizedAssignments.add(assignment);
        }
    }
    
    update optimizedAssignments;
    return optimizedAssignments;
}

private class AssignmentLocationComparator implements Comparator<Assignment__c> {
    public Integer compare(Assignment__c a, Assignment__c b) {
        // Simple string comparison of locations
        // In a real implementation, you would use geolocation
        return a.Order__r.Service_Location__c.compareTo(b.Order__r.Service_Location__c);
    }
}
```

## Helper Classes

### ResourceAvailability

Structure to hold resource availability information.

```apex
public class ResourceAvailability {
    public Id resourceUnitId;
    public String name;
    public Decimal totalCapacity;
    public Map<Date, Decimal> availableCapacityByDate;
    
    public ResourceAvailability(
        Id resourceUnitId,
        String name,
        Decimal totalCapacity,
        Map<Date, Decimal> availableCapacityByDate
    ) {
        this.resourceUnitId = resourceUnitId;
        this.name = name;
        this.totalCapacity = totalCapacity;
        this.availableCapacityByDate = availableCapacityByDate;
    }
    
    public Decimal getAvailableCapacity(Date date) {
        return availableCapacityByDate.containsKey(date) ?
               availableCapacityByDate.get(date) : 0;
    }
}
```

### ResourceException

Custom exception for resource-related errors.

```apex
public class ResourceException extends Exception {
    // Custom exception for resource allocation errors
}
```

## Documentation Consolidation

*This document was migrated as part of the Documentation Consolidation Initiative (April 3-11, 2025) from the original `utility_function/resources.md` file.* 