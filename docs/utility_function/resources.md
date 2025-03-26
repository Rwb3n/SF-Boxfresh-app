---
layout: default
title: "Resource Allocation"
parent: "Utility Function"
nav_order: 2
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
public static List<Resource_Unit__c> find_available_resources(DateTime startTime, DateTime endTime, Set<String> requiredSkills) {
    // Get the date for the assignment
    Date assignmentDate = startTime.date();
    
    // Query resource units that are not already fully booked
    List<Resource_Unit__c> units = [
        SELECT Id, Name, Capacity__c,
               (SELECT Id FROM Assignments__r WHERE Start_Time__c.date() = :assignmentDate),
               (SELECT Id, Skill_Set__c FROM Resources__r)
        FROM Resource_Unit__c
        WHERE Is_Active__c = true
    ];
    
    // Filter units based on capacity and skills
    List<Resource_Unit__c> availableUnits = new List<Resource_Unit__c>();
    
    for (Resource_Unit__c unit : units) {
        // Check capacity
        if (unit.Assignments__r.size() >= unit.Capacity__c) {
            continue;
        }
        
        // Check for time conflicts
        Boolean hasConflict = false;
        for (Assignment__c assign : [
            SELECT Id, Start_Time__c, End_Time__c
            FROM Assignment__c
            WHERE Resource_Unit__c = :unit.Id
            AND ((Start_Time__c <= :startTime AND End_Time__c > :startTime)
                OR (Start_Time__c < :endTime AND End_Time__c >= :endTime)
                OR (Start_Time__c >= :startTime AND End_Time__c <= :endTime))
        ]) {
            hasConflict = true;
            break;
        }
        
        if (hasConflict) {
            continue;
        }
        
        // Check skills if required
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
public static Assignment__c create_assignment(Id orderId, Id resourceUnitId, DateTime startTime, DateTime endTime) {
    // Validate that the resource is available
    List<Assignment__c> conflictingAssignments = [
        SELECT Id
        FROM Assignment__c
        WHERE Resource_Unit__c = :resourceUnitId
        AND ((Start_Time__c <= :startTime AND End_Time__c > :startTime)
            OR (Start_Time__c < :endTime AND End_Time__c >= :endTime)
            OR (Start_Time__c >= :startTime AND End_Time__c <= :endTime))
    ];
    
    if (!conflictingAssignments.isEmpty()) {
        throw new ResourceException('Resource is not available at the requested time');
    }
    
    // Create the assignment
    Assignment__c assignment = new Assignment__c(
        Order__c = orderId,
        Resource_Unit__c = resourceUnitId,
        Start_Time__c = startTime,
        End_Time__c = endTime,
        Status__c = 'Scheduled'
    );
    
    insert assignment;
    return assignment;
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
public static List<Assignment__c> optimize_schedule(List<Assignment__c> assignments) {
    // Sort assignments by priority and duration
    assignments.sort((a, b) => {
        // Sort by priority (high to low)
        Integer priorityA = getPriorityValue(a.Priority__c);
        Integer priorityB = getPriorityValue(b.Priority__c);
        
        if (priorityA != priorityB) {
            return priorityA > priorityB ? -1 : 1;
        }
        
        // Then sort by duration (short to long)
        Decimal durationA = a.Planned_Duration__c;
        Decimal durationB = b.Planned_Duration__c;
        
        if (durationA != durationB) {
            return durationA < durationB ? -1 : 1;
        }
        
        return 0;
    });
    
    // Create a map of resource unit ID to its assignments
    Map<Id, List<Assignment__c>> assignmentsByResource = new Map<Id, List<Assignment__c>>();
    for (Assignment__c a : assignments) {
        if (!assignmentsByResource.containsKey(a.Resource_Unit__c)) {
            assignmentsByResource.put(a.Resource_Unit__c, new List<Assignment__c>());
        }
        assignmentsByResource.get(a.Resource_Unit__c).add(a);
    }
    
    // For each resource, schedule its assignments
    List<Assignment__c> scheduledAssignments = new List<Assignment__c>();
    
    for (Id resourceId : assignmentsByResource.keySet()) {
        List<Assignment__c> resourceAssignments = assignmentsByResource.get(resourceId);
        List<Assignment__c> optimizedAssignments = scheduleResourceAssignments(resourceAssignments);
        scheduledAssignments.addAll(optimizedAssignments);
    }
    
    return scheduledAssignments;
}

private static Integer getPriorityValue(String priority) {
    switch on priority {
        when 'High' { return 3; }
        when 'Medium' { return 2; }
        when 'Low' { return 1; }
        when else { return 0; }
    }
}

private static List<Assignment__c> scheduleResourceAssignments(List<Assignment__c> assignments) {
    // Get the date for these assignments
    Date assignmentDate = assignments[0].Start_Time__c.date();
    
    // Get the resource's availability hours
    Resource_Unit__c unit = [
        SELECT Id, (SELECT Availability_Start__c, Availability_End__c FROM Resources__r)
        FROM Resource_Unit__c
        WHERE Id = :assignments[0].Resource_Unit__c
    ];
    
    // Calculate the earliest start time and latest end time
    Time earliestStart = Time.newInstance(8, 0, 0, 0); // Default to 8 AM
    Time latestEnd = Time.newInstance(18, 0, 0, 0); // Default to 6 PM
    
    for (Resource__c resource : unit.Resources__r) {
        if (resource.Availability_Start__c != null && resource.Availability_Start__c < earliestStart) {
            earliestStart = resource.Availability_Start__c;
        }
        if (resource.Availability_End__c != null && resource.Availability_End__c > latestEnd) {
            latestEnd = resource.Availability_End__c;
        }
    }
    
    // Create a datetime for the start of the day
    DateTime currentTime = DateTime.newInstance(assignmentDate, earliestStart);
    DateTime endOfDay = DateTime.newInstance(assignmentDate, latestEnd);
    
    // Schedule each assignment
    for (Assignment__c assignment : assignments) {
        // Add a 30-minute gap between assignments
        if (currentTime > DateTime.newInstance(assignmentDate, earliestStart)) {
            currentTime = currentTime.addMinutes(30);
        }
        
        // Calculate end time based on planned duration
        DateTime endTime = currentTime.addMinutes((Integer)(assignment.Planned_Duration__c * 60));
        
        // Check if this would go past the end of the day
        if (endTime > endOfDay) {
            // Not enough time left today
            break;
        }
        
        // Update the assignment
        assignment.Start_Time__c = currentTime;
        assignment.End_Time__c = endTime;
        
        // Move current time to the end of this assignment
        currentTime = endTime;
    }
    
    return assignments;
}
```

## Helper Classes

### ResourceAvailability

Structure to hold resource availability information.

```apex
public class ResourceAvailability {
    public Id resourceId;
    public String name;
    public Decimal totalCapacity;
    public Map<Date, Decimal> availableCapacityByDate;
    
    public ResourceAvailability(Id resourceId, String name, Decimal totalCapacity,
                               Map<Date, Decimal> availableCapacityByDate) {
        this.resourceId = resourceId;
        this.name = name;
        this.totalCapacity = totalCapacity;
        this.availableCapacityByDate = availableCapacityByDate;
    }
    
    public Decimal getAvailableCapacity(Date date) {
        return availableCapacityByDate.containsKey(date) ? 
               availableCapacityByDate.get(date) : totalCapacity;
    }
}
```

### ResourceException

Custom exception class for resource-related errors.

```apex
public class ResourceException extends Exception {
    // Default constructor
}
``` 