---
layout: default
title: "Inventory Management"
parent: "Utility Functions"
grand_parent: "Reference Documentation"
nav_order: 2
---

# Inventory Management

The BoxFresh App includes utility functions for tracking and managing inventory. These functions provide a consistent interface for interacting with the inventory objects.

## Inventory Status Functions

### get_inventory_status

Retrieves the current status of inventory items.

```apex
public static Map<Id, InventoryStatus> get_inventory_status(List<Id> inventoryIds) {
    Map<Id, InventoryStatus> results = new Map<Id, InventoryStatus>();
    
    // Query inventory records
    List<Inventory__c> inventories = [
        SELECT Id, Name, Location__c, Capacity__c, 
               (SELECT Id, Material_SKU__c, Material_SKU__r.Name, Quantity__c 
                FROM Material_Stocks__r)
        FROM Inventory__c
        WHERE Id IN :inventoryIds
    ];
    
    // Calculate total used capacity and available capacity
    for (Inventory__c inv : inventories) {
        Decimal usedCapacity = 0;
        Map<Id, Decimal> stockLevels = new Map<Id, Decimal>();
        
        for (Material_Stock__c stock : inv.Material_Stocks__r) {
            usedCapacity += stock.Quantity__c;
            stockLevels.put(stock.Material_SKU__c, stock.Quantity__c);
        }
        
        results.put(inv.Id, new InventoryStatus(
            inv.Id,
            inv.Name,
            inv.Location__c,
            inv.Capacity__c,
            usedCapacity,
            inv.Capacity__c - usedCapacity,
            stockLevels
        ));
    }
    
    return results;
}
```

### check_material_availability

Checks if specific materials are available in sufficient quantities.

```apex
public static Map<Id, Boolean> check_material_availability(Map<Id, Decimal> materialsNeeded) {
    Map<Id, Boolean> results = new Map<Id, Boolean>();
    
    // Query current stock levels
    List<Material_Stock__c> stocks = [
        SELECT Material_SKU__c, SUM(Quantity__c) totalQuantity
        FROM Material_Stock__c
        WHERE Material_SKU__c IN :materialsNeeded.keySet()
        GROUP BY Material_SKU__c
    ];
    
    // Create a map of material ID to total quantity
    Map<Id, Decimal> availableStock = new Map<Id, Decimal>();
    for (Material_Stock__c stock : stocks) {
        availableStock.put(stock.Material_SKU__c, stock.get('totalQuantity'));
    }
    
    // Check if each material is available in sufficient quantity
    for (Id materialId : materialsNeeded.keySet()) {
        Decimal needed = materialsNeeded.get(materialId);
        Decimal available = availableStock.containsKey(materialId) ? availableStock.get(materialId) : 0;
        results.put(materialId, available >= needed);
    }
    
    return results;
}
```

## Inventory Update Functions

### update_material_usage

Records the usage of materials for a job.

```apex
public static void update_material_usage(Id assignmentId, Map<Id, Decimal> materialsUsed) {
    // Create material usage records
    List<Material_Usage__c> usages = new List<Material_Usage__c>();
    
    for (Id materialId : materialsUsed.keySet()) {
        usages.add(new Material_Usage__c(
            Assignment__c = assignmentId,
            Material_SKU__c = materialId,
            Quantity_Used__c = materialsUsed.get(materialId),
            Usage_Date__c = Date.today()
        ));
    }
    
    // Insert usage records
    insert usages;
    
    // Update material stock
    updateMaterialStock(materialsUsed);
}

private static void updateMaterialStock(Map<Id, Decimal> materialsUsed) {
    // Query material stock records
    List<Material_Stock__c> stocksToUpdate = new List<Material_Stock__c>();
    
    for (Id materialId : materialsUsed.keySet()) {
        Decimal quantityUsed = materialsUsed.get(materialId);
        
        // Find stock records for this material
        List<Material_Stock__c> stocks = [
            SELECT Id, Quantity__c
            FROM Material_Stock__c
            WHERE Material_SKU__c = :materialId
            AND Quantity__c > 0
            ORDER BY Expiration_Date__c ASC NULLS LAST
        ];
        
        // Deduct from stock records
        for (Material_Stock__c stock : stocks) {
            if (quantityUsed <= 0) break;
            
            if (stock.Quantity__c >= quantityUsed) {
                stock.Quantity__c -= quantityUsed;
                quantityUsed = 0;
            } else {
                quantityUsed -= stock.Quantity__c;
                stock.Quantity__c = 0;
            }
            
            stocksToUpdate.add(stock);
        }
    }
    
    // Update stock records
    update stocksToUpdate;
}
```

## Inventory Planning Functions

### forecast_inventory_needs

Forecasts inventory requirements based on upcoming jobs.

```apex
public static List<PurchaseRecommendation> forecast_inventory_needs(Integer daysAhead) {
    // Get upcoming assignments
    List<Assignment__c> assignments = [
        SELECT Id, Scheduled_Date__c, Order__r.Core_Contract__c,
               (SELECT Id, Material_SKU__c, Estimated_Quantity__c
                FROM Required_Materials__r)
        FROM Assignment__c
        WHERE Scheduled_Date__c >= TODAY
        AND Scheduled_Date__c <= :Date.today().addDays(daysAhead)
        AND Status__c != 'Completed'
        AND Status__c != 'Cancelled'
    ];
    
    // Calculate total material needs
    Map<Id, Decimal> forecastedNeeds = new Map<Id, Decimal>();
    
    for (Assignment__c assignment : assignments) {
        for (Required_Material__c rm : assignment.Required_Materials__r) {
            Decimal currentNeed = forecastedNeeds.containsKey(rm.Material_SKU__c) ?
                                 forecastedNeeds.get(rm.Material_SKU__c) : 0;
            forecastedNeeds.put(rm.Material_SKU__c, currentNeed + rm.Estimated_Quantity__c);
        }
    }
    
    // Get current inventory levels
    Map<Id, Decimal> currentStock = new Map<Id, Decimal>();
    
    List<AggregateResult> stockResults = [
        SELECT Material_SKU__c, SUM(Quantity__c) totalQuantity
        FROM Material_Stock__c
        WHERE Material_SKU__c IN :forecastedNeeds.keySet()
        AND Expiration_Date__c = null OR Expiration_Date__c > TODAY
        GROUP BY Material_SKU__c
    ];
    
    for (AggregateResult ar : stockResults) {
        Id materialId = (Id)ar.get('Material_SKU__c');
        Decimal quantity = (Decimal)ar.get('totalQuantity');
        currentStock.put(materialId, quantity);
    }
    
    // Get material details
    Map<Id, Material_SKU__c> materials = new Map<Id, Material_SKU__c>([
        SELECT Id, Name, Unit_Cost__c, Reorder_Threshold__c, Reorder_Quantity__c
        FROM Material_SKU__c
        WHERE Id IN :forecastedNeeds.keySet()
    ]);
    
    // Create purchase recommendations
    List<PurchaseRecommendation> recommendations = new List<PurchaseRecommendation>();
    
    for (Id materialId : forecastedNeeds.keySet()) {
        Decimal needed = forecastedNeeds.get(materialId);
        Decimal available = currentStock.containsKey(materialId) ? currentStock.get(materialId) : 0;
        Material_SKU__c material = materials.get(materialId);
        
        if (available < needed || available < material.Reorder_Threshold__c) {
            Decimal recommendedQuantity = Math.max(needed - available, material.Reorder_Quantity__c);
            Decimal estimatedCost = recommendedQuantity * material.Unit_Cost__c;
            
            recommendations.add(new PurchaseRecommendation(
                materialId,
                material.Name,
                available,
                needed,
                recommendedQuantity,
                estimatedCost
            ));
        }
    }
    
    return recommendations;
}
```

## Helper Classes

### InventoryStatus

Structure to hold inventory status information.

```apex
public class InventoryStatus {
    public Id inventoryId;
    public String name;
    public String location;
    public Decimal totalCapacity;
    public Decimal usedCapacity;
    public Decimal availableCapacity;
    public Map<Id, Decimal> stockLevels;
    
    public InventoryStatus(Id inventoryId, String name, String location, 
                           Decimal totalCapacity, Decimal usedCapacity, 
                           Decimal availableCapacity, Map<Id, Decimal> stockLevels) {
        this.inventoryId = inventoryId;
        this.name = name;
        this.location = location;
        this.totalCapacity = totalCapacity;
        this.usedCapacity = usedCapacity;
        this.availableCapacity = availableCapacity;
        this.stockLevels = stockLevels;
    }
}
```

### PurchaseRecommendation

Structure to hold purchase recommendation information.

```apex
public class PurchaseRecommendation {
    public Id materialId;
    public String materialName;
    public Decimal currentStock;
    public Decimal projectedNeed;
    public Decimal recommendedPurchase;
    public Decimal estimatedCost;
    
    public PurchaseRecommendation(
        Id materialId, String materialName, Decimal currentStock,
        Decimal projectedNeed, Decimal recommendedPurchase, Decimal estimatedCost
    ) {
        this.materialId = materialId;
        this.materialName = materialName;
        this.currentStock = currentStock;
        this.projectedNeed = projectedNeed;
        this.recommendedPurchase = recommendedPurchase;
        this.estimatedCost = estimatedCost;
    }
}
```

## Documentation Consolidation

*This document was migrated as part of the Documentation Consolidation Initiative (April 3-11, 2025) from the original `utility_function/inventory.md` file.* 