---
layout: default
title: "Reporting Tools"
parent: "Utility Function"
nav_order: 3
---

# Reporting Tools

The BoxFresh App includes utility functions for generating reports and analytics. These functions provide insights into business performance and resource utilization.

## Performance Metrics

### generate_performance_report

Generates a performance report for a specified time period.

```apex
public static PerformanceReport generate_performance_report(Date startDate, Date endDate) {
    // Calculate job statistics
    List<AggregateResult> jobStats = [
        SELECT COUNT(Id) jobCount, Status__c
        FROM Order__c
        WHERE Service_Date__c >= :startDate 
        AND Service_Date__c <= :endDate
        GROUP BY Status__c
    ];
    
    Integer totalJobs = 0;
    Integer completedJobs = 0;
    Integer cancelledJobs = 0;
    
    for (AggregateResult ar : jobStats) {
        String status = (String)ar.get('Status__c');
        Integer count = (Integer)ar.get('jobCount');
        totalJobs += count;
        
        if (status == 'Completed') {
            completedJobs = count;
        } else if (status == 'Cancelled') {
            cancelledJobs = count;
        }
    }
    
    // Calculate average job completion time
    List<AggregateResult> timeStats = [
        SELECT AVG(Actual_Duration__c) avgDuration, 
               AVG(Planned_Duration__c) avgPlanned
        FROM Assignment__c
        WHERE Completion_Date__c >= :startDate 
        AND Completion_Date__c <= :endDate
        AND Status__c = 'Completed'
    ];
    
    Decimal avgDuration = 0;
    Decimal avgPlanned = 0;
    Decimal timeEfficiency = 0;
    
    if (!timeStats.isEmpty()) {
        avgDuration = (Decimal)timeStats[0].get('avgDuration') ?? 0;
        avgPlanned = (Decimal)timeStats[0].get('avgPlanned') ?? 0;
        timeEfficiency = avgPlanned > 0 ? avgPlanned / avgDuration : 0;
    }
    
    // Calculate resource utilization
    List<AggregateResult> resourceStats = [
        SELECT Resource_Unit__c, 
               COUNT(Id) assignmentCount,
               SUM(Actual_Duration__c) totalHours
        FROM Assignment__c
        WHERE Start_Time__c >= :startDate 
        AND Start_Time__c <= :endDate
        GROUP BY Resource_Unit__c
    ];
    
    // Get all resource units for the period
    List<Resource_Unit__c> allResources = [
        SELECT Id, Name
        FROM Resource_Unit__c
        WHERE Is_Active__c = true
    ];
    
    Map<Id, ResourceStatistics> resourceStatistics = new Map<Id, ResourceStatistics>();
    
    // Initialize statistics for all resources
    for (Resource_Unit__c unit : allResources) {
        resourceStatistics.put(unit.Id, new ResourceStatistics(
            unit.Id,
            unit.Name,
            0,
            0
        ));
    }
    
    // Update statistics for resources with assignments
    for (AggregateResult ar : resourceStats) {
        Id resourceId = (Id)ar.get('Resource_Unit__c');
        Integer assignmentCount = (Integer)ar.get('assignmentCount');
        Decimal totalHours = (Decimal)ar.get('totalHours') ?? 0;
        
        if (resourceStatistics.containsKey(resourceId)) {
            ResourceStatistics stats = resourceStatistics.get(resourceId);
            stats.assignmentCount = assignmentCount;
            stats.totalHours = totalHours;
        }
    }
    
    // Calculate material usage
    List<AggregateResult> materialStats = [
        SELECT Material_SKU__c, Material_SKU__r.Name,
               SUM(Quantity_Used__c) totalUsed
        FROM Material_Usage__c
        WHERE Usage_Date__c >= :startDate 
        AND Usage_Date__c <= :endDate
        GROUP BY Material_SKU__c, Material_SKU__r.Name
    ];
    
    Map<Id, MaterialUsage> materialUsage = new Map<Id, MaterialUsage>();
    
    for (AggregateResult ar : materialStats) {
        Id materialId = (Id)ar.get('Material_SKU__c');
        String materialName = (String)ar.get('Material_SKU__r.Name');
        Decimal totalUsed = (Decimal)ar.get('totalUsed') ?? 0;
        
        materialUsage.put(materialId, new MaterialUsage(
            materialId,
            materialName,
            totalUsed
        ));
    }
    
    // Calculate customer satisfaction
    List<AggregateResult> satisfactionStats = [
        SELECT AVG(Customer_Rating__c) avgRating
        FROM Assignment__c
        WHERE Completion_Date__c >= :startDate 
        AND Completion_Date__c <= :endDate
        AND Customer_Rating__c != null
    ];
    
    Decimal avgCustomerRating = 0;
    
    if (!satisfactionStats.isEmpty()) {
        avgCustomerRating = (Decimal)satisfactionStats[0].get('avgRating') ?? 0;
    }
    
    // Create the performance report
    return new PerformanceReport(
        startDate,
        endDate,
        totalJobs,
        completedJobs,
        cancelledJobs,
        avgDuration,
        avgPlanned,
        timeEfficiency,
        resourceStatistics.values(),
        materialUsage.values(),
        avgCustomerRating
    );
}
```

### generate_resource_efficiency_report

Generates an efficiency report for resources.

```apex
public static List<ResourceEfficiency> generate_resource_efficiency_report(Date startDate, Date endDate) {
    // Query assignment data
    List<Assignment__c> assignments = [
        SELECT Id, Resource_Unit__c, Resource_Unit__r.Name,
               Start_Time__c, End_Time__c, 
               Actual_Duration__c, Planned_Duration__c,
               Customer_Rating__c
        FROM Assignment__c
        WHERE Completion_Date__c >= :startDate 
        AND Completion_Date__c <= :endDate
        AND Status__c = 'Completed'
    ];
    
    // Group assignments by resource
    Map<Id, List<Assignment__c>> assignmentsByResource = new Map<Id, List<Assignment__c>>();
    
    for (Assignment__c assignment : assignments) {
        Id resourceId = assignment.Resource_Unit__c;
        
        if (!assignmentsByResource.containsKey(resourceId)) {
            assignmentsByResource.put(resourceId, new List<Assignment__c>());
        }
        
        assignmentsByResource.get(resourceId).add(assignment);
    }
    
    // Calculate efficiency metrics for each resource
    List<ResourceEfficiency> results = new List<ResourceEfficiency>();
    
    for (Id resourceId : assignmentsByResource.keySet()) {
        List<Assignment__c> resourceAssignments = assignmentsByResource.get(resourceId);
        String resourceName = resourceAssignments[0].Resource_Unit__r.Name;
        
        Decimal totalActualHours = 0;
        Decimal totalPlannedHours = 0;
        Decimal sumRatings = 0;
        Integer ratingCount = 0;
        
        for (Assignment__c assignment : resourceAssignments) {
            if (assignment.Actual_Duration__c != null) {
                totalActualHours += assignment.Actual_Duration__c;
            }
            
            if (assignment.Planned_Duration__c != null) {
                totalPlannedHours += assignment.Planned_Duration__c;
            }
            
            if (assignment.Customer_Rating__c != null) {
                sumRatings += assignment.Customer_Rating__c;
                ratingCount++;
            }
        }
        
        // Calculate metrics
        Decimal timeEfficiency = totalPlannedHours > 0 ? totalActualHours / totalPlannedHours : 0;
        Decimal avgRating = ratingCount > 0 ? sumRatings / ratingCount : 0;
        Integer assignmentCount = resourceAssignments.size();
        
        // Add to results
        results.add(new ResourceEfficiency(
            resourceId,
            resourceName,
            assignmentCount,
            totalActualHours,
            timeEfficiency,
            avgRating
        ));
    }
    
    // Sort by efficiency (highest to lowest)
    results.sort((a, b) => a.timeEfficiency > b.timeEfficiency ? -1 : 1);
    
    return results;
}
```

## Financial Reports

### generate_revenue_report

Generates a revenue report for a specified time period.

```apex
public static RevenueReport generate_revenue_report(Date startDate, Date endDate) {
    // Query order data
    List<Order__c> orders = [
        SELECT Id, Total_Amount__c, Service_Date__c,
               Core_Contract__r.Account__c, Core_Contract__r.Account__r.Name
        FROM Order__c
        WHERE Service_Date__c >= :startDate 
        AND Service_Date__c <= :endDate
        AND Status__c = 'Completed'
    ];
    
    // Calculate total revenue
    Decimal totalRevenue = 0;
    for (Order__c order : orders) {
        if (order.Total_Amount__c != null) {
            totalRevenue += order.Total_Amount__c;
        }
    }
    
    // Group revenue by customer
    Map<Id, CustomerRevenue> revenueByCustomer = new Map<Id, CustomerRevenue>();
    
    for (Order__c order : orders) {
        Id accountId = order.Core_Contract__r.Account__c;
        String accountName = order.Core_Contract__r.Account__r.Name;
        
        if (!revenueByCustomer.containsKey(accountId)) {
            revenueByCustomer.put(accountId, new CustomerRevenue(
                accountId,
                accountName,
                0,
                0
            ));
        }
        
        CustomerRevenue revenue = revenueByCustomer.get(accountId);
        revenue.orderCount++;
        
        if (order.Total_Amount__c != null) {
            revenue.totalRevenue += order.Total_Amount__c;
        }
    }
    
    // Group revenue by month
    Map<String, Decimal> revenueByMonth = new Map<String, Decimal>();
    
    for (Order__c order : orders) {
        String monthKey = order.Service_Date__c.year() + '-' + order.Service_Date__c.month();
        
        if (!revenueByMonth.containsKey(monthKey)) {
            revenueByMonth.put(monthKey, 0);
        }
        
        if (order.Total_Amount__c != null) {
            revenueByMonth.put(monthKey, revenueByMonth.get(monthKey) + order.Total_Amount__c);
        }
    }
    
    // Query material costs
    List<AggregateResult> materialCosts = [
        SELECT SUM(Quantity_Used__c * Material_SKU__r.Unit_Cost__c) totalCost
        FROM Material_Usage__c
        WHERE Usage_Date__c >= :startDate 
        AND Usage_Date__c <= :endDate
    ];
    
    Decimal totalCosts = materialCosts.isEmpty() ? 0 : (Decimal)materialCosts[0].get('totalCost') ?? 0;
    
    // Calculate profit
    Decimal grossProfit = totalRevenue - totalCosts;
    Decimal profitMargin = totalRevenue > 0 ? (grossProfit / totalRevenue) * 100 : 0;
    
    // Create the revenue report
    return new RevenueReport(
        startDate,
        endDate,
        totalRevenue,
        totalCosts,
        grossProfit,
        profitMargin,
        revenueByCustomer.values(),
        revenueByMonth
    );
}
```

### generate_cost_analysis_report

Generates a detailed cost analysis report.

```apex
public static CostAnalysisReport generate_cost_analysis_report(Date startDate, Date endDate) {
    // Query material usage data
    List<Material_Usage__c> usages = [
        SELECT Id, Quantity_Used__c, 
               Material_SKU__c, Material_SKU__r.Name, 
               Material_SKU__r.Unit_Cost__c,
               Assignment__r.Order__c
        FROM Material_Usage__c
        WHERE Usage_Date__c >= :startDate 
        AND Usage_Date__c <= :endDate
    ];
    
    // Calculate material costs by category
    Map<Id, MaterialCost> costsByMaterial = new Map<Id, MaterialCost>();
    
    for (Material_Usage__c usage : usages) {
        Id materialId = usage.Material_SKU__c;
        String materialName = usage.Material_SKU__r.Name;
        Decimal unitCost = usage.Material_SKU__r.Unit_Cost__c ?? 0;
        Decimal quantity = usage.Quantity_Used__c ?? 0;
        Decimal totalCost = unitCost * quantity;
        
        if (!costsByMaterial.containsKey(materialId)) {
            costsByMaterial.put(materialId, new MaterialCost(
                materialId,
                materialName,
                0,
                0
            ));
        }
        
        MaterialCost cost = costsByMaterial.get(materialId);
        cost.totalQuantity += quantity;
        cost.totalCost += totalCost;
    }
    
    // Calculate total materials cost
    Decimal totalMaterialsCost = 0;
    for (MaterialCost cost : costsByMaterial.values()) {
        totalMaterialsCost += cost.totalCost;
    }
    
    // Calculate labor costs
    List<Assignment__c> assignments = [
        SELECT Id, Actual_Duration__c, Resource_Unit__r.Hourly_Rate__c
        FROM Assignment__c
        WHERE Completion_Date__c >= :startDate 
        AND Completion_Date__c <= :endDate
        AND Status__c = 'Completed'
    ];
    
    Decimal totalLaborCost = 0;
    for (Assignment__c assignment : assignments) {
        Decimal hours = assignment.Actual_Duration__c ?? 0;
        Decimal rate = assignment.Resource_Unit__r.Hourly_Rate__c ?? 0;
        totalLaborCost += hours * rate;
    }
    
    // Calculate equipment costs
    List<AggregateResult> equipmentCosts = [
        SELECT SUM(Usage_Hours__c * Hourly_Cost__c) totalCost
        FROM Equipment_Usage__c
        WHERE Usage_Date__c >= :startDate 
        AND Usage_Date__c <= :endDate
    ];
    
    Decimal totalEquipmentCost = equipmentCosts.isEmpty() ? 0 : (Decimal)equipmentCosts[0].get('totalCost') ?? 0;
    
    // Calculate total costs
    Decimal totalCosts = totalMaterialsCost + totalLaborCost + totalEquipmentCost;
    
    // Calculate cost breakdown percentages
    Decimal materialsCostPercentage = totalCosts > 0 ? (totalMaterialsCost / totalCosts) * 100 : 0;
    Decimal laborCostPercentage = totalCosts > 0 ? (totalLaborCost / totalCosts) * 100 : 0;
    Decimal equipmentCostPercentage = totalCosts > 0 ? (totalEquipmentCost / totalCosts) * 100 : 0;
    
    // Create the cost analysis report
    return new CostAnalysisReport(
        startDate,
        endDate,
        totalCosts,
        totalMaterialsCost,
        materialsCostPercentage,
        totalLaborCost,
        laborCostPercentage,
        totalEquipmentCost,
        equipmentCostPercentage,
        costsByMaterial.values()
    );
}
```

## Helper Classes

### PerformanceReport

Structure to hold performance report data.

```apex
public class PerformanceReport {
    public Date startDate;
    public Date endDate;
    public Integer totalJobs;
    public Integer completedJobs;
    public Integer cancelledJobs;
    public Decimal completionRate;
    public Decimal avgDuration;
    public Decimal avgPlanned;
    public Decimal timeEfficiency;
    public List<ResourceStatistics> resourceStats;
    public List<MaterialUsage> materialUsage;
    public Decimal avgCustomerRating;
    
    public PerformanceReport(Date startDate, Date endDate, Integer totalJobs,
                            Integer completedJobs, Integer cancelledJobs,
                            Decimal avgDuration, Decimal avgPlanned, Decimal timeEfficiency,
                            List<ResourceStatistics> resourceStats, List<MaterialUsage> materialUsage,
                            Decimal avgCustomerRating) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalJobs = totalJobs;
        this.completedJobs = completedJobs;
        this.cancelledJobs = cancelledJobs;
        this.completionRate = totalJobs > 0 ? (completedJobs / (Decimal)totalJobs) * 100 : 0;
        this.avgDuration = avgDuration;
        this.avgPlanned = avgPlanned;
        this.timeEfficiency = timeEfficiency;
        this.resourceStats = resourceStats;
        this.materialUsage = materialUsage;
        this.avgCustomerRating = avgCustomerRating;
    }
}
```

### ResourceStatistics

Structure to hold resource statistics.

```apex
public class ResourceStatistics {
    public Id resourceId;
    public String resourceName;
    public Integer assignmentCount;
    public Decimal totalHours;
    
    public ResourceStatistics(Id resourceId, String resourceName,
                             Integer assignmentCount, Decimal totalHours) {
        this.resourceId = resourceId;
        this.resourceName = resourceName;
        this.assignmentCount = assignmentCount;
        this.totalHours = totalHours;
    }
}
```

### MaterialUsage

Structure to hold material usage data.

```apex
public class MaterialUsage {
    public Id materialId;
    public String materialName;
    public Decimal totalUsed;
    
    public MaterialUsage(Id materialId, String materialName, Decimal totalUsed) {
        this.materialId = materialId;
        this.materialName = materialName;
        this.totalUsed = totalUsed;
    }
}
```

### ResourceEfficiency

Structure to hold resource efficiency data.

```apex
public class ResourceEfficiency {
    public Id resourceId;
    public String resourceName;
    public Integer assignmentCount;
    public Decimal totalHours;
    public Decimal timeEfficiency;
    public Decimal customerRating;
    
    public ResourceEfficiency(Id resourceId, String resourceName,
                             Integer assignmentCount, Decimal totalHours,
                             Decimal timeEfficiency, Decimal customerRating) {
        this.resourceId = resourceId;
        this.resourceName = resourceName;
        this.assignmentCount = assignmentCount;
        this.totalHours = totalHours;
        this.timeEfficiency = timeEfficiency;
        this.customerRating = customerRating;
    }
}
```

### RevenueReport

Structure to hold revenue report data.

```apex
public class RevenueReport {
    public Date startDate;
    public Date endDate;
    public Decimal totalRevenue;
    public Decimal totalCosts;
    public Decimal grossProfit;
    public Decimal profitMargin;
    public List<CustomerRevenue> customerRevenue;
    public Map<String, Decimal> revenueByMonth;
    
    public RevenueReport(Date startDate, Date endDate,
                        Decimal totalRevenue, Decimal totalCosts,
                        Decimal grossProfit, Decimal profitMargin,
                        List<CustomerRevenue> customerRevenue,
                        Map<String, Decimal> revenueByMonth) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalRevenue = totalRevenue;
        this.totalCosts = totalCosts;
        this.grossProfit = grossProfit;
        this.profitMargin = profitMargin;
        this.customerRevenue = customerRevenue;
        this.revenueByMonth = revenueByMonth;
    }
}
```

### CustomerRevenue

Structure to hold customer revenue data.

```apex
public class CustomerRevenue {
    public Id accountId;
    public String accountName;
    public Integer orderCount;
    public Decimal totalRevenue;
    
    public CustomerRevenue(Id accountId, String accountName,
                          Integer orderCount, Decimal totalRevenue) {
        this.accountId = accountId;
        this.accountName = accountName;
        this.orderCount = orderCount;
        this.totalRevenue = totalRevenue;
    }
}
```

### CostAnalysisReport

Structure to hold cost analysis data.

```apex
public class CostAnalysisReport {
    public Date startDate;
    public Date endDate;
    public Decimal totalCosts;
    public Decimal totalMaterialsCost;
    public Decimal materialsCostPercentage;
    public Decimal totalLaborCost;
    public Decimal laborCostPercentage;
    public Decimal totalEquipmentCost;
    public Decimal equipmentCostPercentage;
    public List<MaterialCost> materialCosts;
    
    public CostAnalysisReport(Date startDate, Date endDate,
                             Decimal totalCosts, Decimal totalMaterialsCost,
                             Decimal materialsCostPercentage, Decimal totalLaborCost,
                             Decimal laborCostPercentage, Decimal totalEquipmentCost,
                             Decimal equipmentCostPercentage, List<MaterialCost> materialCosts) {
        this.startDate = startDate;
        this.endDate = endDate;
        this.totalCosts = totalCosts;
        this.totalMaterialsCost = totalMaterialsCost;
        this.materialsCostPercentage = materialsCostPercentage;
        this.totalLaborCost = totalLaborCost;
        this.laborCostPercentage = laborCostPercentage;
        this.totalEquipmentCost = totalEquipmentCost;
        this.equipmentCostPercentage = equipmentCostPercentage;
        this.materialCosts = materialCosts;
    }
}
```

### MaterialCost

Structure to hold material cost data.

```apex
public class MaterialCost {
    public Id materialId;
    public String materialName;
    public Decimal totalQuantity;
    public Decimal totalCost;
    
    public MaterialCost(Id materialId, String materialName,
                       Decimal totalQuantity, Decimal totalCost) {
        this.materialId = materialId;
        this.materialName = materialName;
        this.totalQuantity = totalQuantity;
        this.totalCost = totalCost;
    }
}
``` 