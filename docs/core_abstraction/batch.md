---
layout: default
title: "Batch Processing"
parent: "Core Abstraction"
nav_order: 4
---

# Batch Processing

The BoxFresh App includes batch processing capabilities to efficiently handle large volumes of data and repeated operations. These batch processes are implemented using Salesforce's batch Apex and scheduled jobs.

## 1. Daily Schedule Generation

This batch process creates daily schedules for resource units based on pending assignments.

### Process Details:

- **Execution Frequency**: Daily at 6:00 PM for the next day's schedule
- **Batch Size**: 50 Resource_Unit__c records per batch
- **Input Data**: Active Resource_Unit__c records with pending assignments
- **Output Data**: Updated Assignment__c records with optimized schedules

### Implementation:

```apex
global class DailyScheduleGenerationBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all active resource units with pending assignments
        return Database.getQueryLocator([
            SELECT Id, Name, (SELECT Id FROM Assignments__r WHERE Status__c = 'Pending')
            FROM Resource_Unit__c
            WHERE Is_Active__c = true
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Resource_Unit__c> scope) {
        // Process each resource unit and optimize its schedule
        List<Assignment__c> assignmentsToUpdate = new List<Assignment__c>();
        
        for (Resource_Unit__c unit : scope) {
            // Calculate optimized schedule
            assignmentsToUpdate.addAll(
                ScheduleOptimizer.generateSchedule(unit.Assignments__r)
            );
        }
        
        update assignmentsToUpdate;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Send completion notification
        System.scheduleBatch(new CustomerNotificationBatch(), 'Customer Notification', 0);
    }
}
```

## 2. Inventory Level Check

This batch process checks inventory levels and generates reorder recommendations.

### Process Details:

- **Execution Frequency**: Weekly on Sunday at 8:00 AM
- **Batch Size**: 100 Material_Stock__c records per batch
- **Input Data**: All Material_Stock__c records
- **Output Data**: Reorder_Recommendation__c records for low stock items

### Implementation:

```apex
global class InventoryCheckBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all material stock records
        return Database.getQueryLocator([
            SELECT Id, Material_SKU__c, Quantity__c, 
                   Material_SKU__r.Reorder_Threshold__c,
                   Material_SKU__r.Reorder_Quantity__c
            FROM Material_Stock__c
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Material_Stock__c> scope) {
        // Check inventory levels and create reorder recommendations
        List<Reorder_Recommendation__c> recommendations = new List<Reorder_Recommendation__c>();
        
        for (Material_Stock__c stock : scope) {
            if (stock.Quantity__c < stock.Material_SKU__r.Reorder_Threshold__c) {
                recommendations.add(new Reorder_Recommendation__c(
                    Material_SKU__c = stock.Material_SKU__c,
                    Quantity_Needed__c = stock.Material_SKU__r.Reorder_Quantity__c,
                    Current_Stock__c = stock.Quantity__c
                ));
            }
        }
        
        insert recommendations;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Send notification to inventory manager
        NotificationUtil.sendInventoryAlert();
    }
}
```

## 3. Performance Analytics

This batch process analyzes completed assignments and generates performance metrics.

### Process Details:

- **Execution Frequency**: Monthly on the 1st at 2:00 AM
- **Batch Size**: 200 Assignment__c records per batch
- **Input Data**: Completed Assignment__c records from the previous month
- **Output Data**: Performance_Metric__c records for each resource

### Implementation:

```apex
global class PerformanceAnalyticsBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query completed assignments from previous month
        Date startDate = Date.today().toStartOfMonth().addMonths(-1);
        Date endDate = Date.today().toStartOfMonth().addDays(-1);
        
        return Database.getQueryLocator([
            SELECT Id, Resource_Unit__c, Start_Time__c, End_Time__c,
                   Actual_Duration__c, Planned_Duration__c,
                   Customer_Rating__c, Materials_Used__c
            FROM Assignment__c
            WHERE Status__c = 'Completed'
            AND Completion_Date__c >= :startDate
            AND Completion_Date__c <= :endDate
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Assignment__c> scope) {
        // Calculate performance metrics
        Map<Id, List<Assignment__c>> assignmentsByResource = new Map<Id, List<Assignment__c>>();
        
        for (Assignment__c assignment : scope) {
            if (!assignmentsByResource.containsKey(assignment.Resource_Unit__c)) {
                assignmentsByResource.put(assignment.Resource_Unit__c, new List<Assignment__c>());
            }
            assignmentsByResource.get(assignment.Resource_Unit__c).add(assignment);
        }
        
        List<Performance_Metric__c> metrics = new List<Performance_Metric__c>();
        
        for (Id resourceId : assignmentsByResource.keySet()) {
            List<Assignment__c> resourceAssignments = assignmentsByResource.get(resourceId);
            
            // Calculate metrics
            Decimal avgRating = calculateAverageRating(resourceAssignments);
            Decimal efficiencyScore = calculateEfficiencyScore(resourceAssignments);
            
            metrics.add(new Performance_Metric__c(
                Resource_Unit__c = resourceId,
                Month__c = Date.today().toStartOfMonth().addMonths(-1),
                Average_Rating__c = avgRating,
                Efficiency_Score__c = efficiencyScore,
                Jobs_Completed__c = resourceAssignments.size()
            ));
        }
        
        insert metrics;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Generate performance report
        System.scheduleBatch(new PerformanceReportGenerationBatch(), 'Performance Report', 0);
    }
}
```

## 4. Scheduled Maintenance Check

This batch process identifies resources that require maintenance based on usage and schedules.

### Process Details:

- **Execution Frequency**: Bi-weekly on Monday at 7:00 AM
- **Batch Size**: 50 Resource_Asset__c records per batch
- **Input Data**: All active Resource_Asset__c records
- **Output Data**: Maintenance_Request__c records for assets needing service

### Implementation:

```apex
global class MaintenanceCheckBatch implements Database.Batchable<SObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // Query all active assets
        return Database.getQueryLocator([
            SELECT Id, Name, Type__c, Last_Maintenance_Date__c,
                   Hours_Since_Maintenance__c, Maintenance_Interval_Hours__c
            FROM Resource_Asset__c
            WHERE Status__c != 'Inactive'
        ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Resource_Asset__c> scope) {
        // Check maintenance requirements
        List<Maintenance_Request__c> requests = new List<Maintenance_Request__c>();
        
        for (Resource_Asset__c asset : scope) {
            if (asset.Hours_Since_Maintenance__c >= asset.Maintenance_Interval_Hours__c) {
                requests.add(new Maintenance_Request__c(
                    Resource_Asset__c = asset.Id,
                    Type__c = 'Scheduled',
                    Requested_Date__c = Date.today(),
                    Status__c = 'Pending'
                ));
            }
        }
        
        insert requests;
    }
    
    global void finish(Database.BatchableContext BC) {
        // Notify maintenance department
        NotificationUtil.sendMaintenanceAlerts();
    }
}
``` 