---
layout: default
title: "Implementation Plan"
parent: "Sprint1: Complete Schema Implementation"
grand_parent: "Project Proposals"
nav_order: 1
---

# Implementation Plan

This document outlines the detailed implementation plan for the BoxFresh App schema in a fresh developer org, following the specifications in the [Object Schema](../../../overview/schema.md) document.

## Implementation Sequence

To respect object dependencies, we'll implement objects in the following order:

### Phase 1: Foundation Objects (Days 1-4)
1. **Material_Category__c** - No dependencies
2. **Resource__c** - No dependencies
3. **Resource_Asset__c** - No dependencies
4. **Resource_Gear__c** - No dependencies (New)
5. **Service_Location__c** - No dependencies
6. **Material_SKU__c** - Depends on Material_Category__c (Master-Detail)
7. **Resource_Unit__c** - Depends on Resource__c and Resource_Asset__c (Lookups)

### Phase 2: Intermediate Objects (Days 5-7)
8. **Inventory__c** - Depends on Resource_Asset__c (Lookup)
9. **Material_Stock__c** - Depends on Material_SKU__c and Inventory__c (Lookups)
10. **Material_Budget__c** - Depends on Material_Category__c (Lookup)
11. **Core_Contract__c** - Depends on Service_Location__c (Lookup)
12. **Service_Agreement_Core__c** - Depends on Core_Contract__c (Lookup)
13. **Service_Agreement_Element__c** - Depends on Service_Agreement_Core__c (Master-Detail)
14. **Resource_Budget__c** - Depends on Service_Agreement_Core__c (Master-Detail)
15. **Order__c** - Depends on Core_Contract__c (Lookup)

### Phase 3: Complex Objects (Days 8-9)
16. **Assignment__c** - Depends on Core_Contract__c (Master-Detail), Order__c, Resource_Unit__c, and Inventory__c (Lookups)
17. **Schedule__c** - Depends on Assignment__c (Lookup)
18. **Material_Usage__c** - Depends on Schedule__c and Material_Stock__c (Lookups)

### Phase 4: Formulas and Validation Rules (Days 10-12)
19. Configure formula fields across all objects
20. Implement validation rules
21. Configure roll-up summary fields

### Phase 5: Testing and Finalization (Days 13-14)
22. Create test data
23. Verify all relationships and validations
24. Document implementation notes and decisions

## Detailed Tasks Breakdown

### Material_Category__c
- Create custom object
- Add fields:
  - Name (Text) 
  - Material_Code__c (Auto Number)
  - Unit_of_Measure__c (Picklist)
  - Total_SKUs_in_Category__c (Roll-Up Summary) - Will be configured after Material_SKU__c creation

### Material_SKU__c
- Create custom object
- Add fields:
  - Name (Text)
  - Description__c (Text Area)
  - Unit_of_Measure__c (Picklist)
  - Unit_of_Measure_Quantity__c (Number)
  - Unit_Cost__c (Currency)
  - Material_SKU_Category__c (Master-Detail to Material_Category__c)
  - Capacity_Units_Per_Unit__c (Number)
- Configure page layouts

### Material_Stock__c
- Create custom object
- Add fields:
  - Material_SKU__c (Lookup)
  - Material_Stock_ID__c (Auto Number, format: INV-{0000})
  - Quantity__c (Number)
  - Quantity_Remaining__c (Formula)
  - Purchase_Date__c (Date)
  - Received_Date__c (Date)
  - Days_Since_Received__c (Formula)
  - Material_SKU_Category__c (Formula)
  - Budget_Source__c (Lookup to Material_Budget__c)
  - Status__c (Picklist)
  - Status_Change_Date__c (Date)
  - Assignment_Status__c (Picklist)
  - Maximum_Capacity__c (Number)
  - Available_Capacity__c (Number)
- Configure page layouts

### Inventory__c
- Create custom object
- Add fields:
  - Name (Text)
  - Inventory_ID__c (Auto Number)
  - Resource_Asset__c (Lookup to location)
  - Capacity_Units__c (Number)
  - Available_Capacity__c (Formula)
  - Buffer_Status__c (Formula)
  - Is_Constraint__c (Checkbox)
- Configure page layouts

### Resource_Gear__c (New)
- Create custom object
- Add fields:
  - Name (Text)
  - Resource_Unit__c (Lookup)
  - Type__c (Picklist: Equipment, Tools, Uniform)
  - Additional fields based on type
- Configure page layouts

### Service_Agreement_Core__c
- Create custom object
- Add fields:
  - Name (Text)
  - Core_Contract__c (Lookup)
  - Additional core agreement fields
- Configure page layouts

### Service_Agreement_Element__c
- Create custom object
- Add fields:
  - Name (Text)
  - Service_Agreement_Core__c (Master-Detail)
  - Element specific fields
- Configure page layouts

### Resource_Budget__c
- Create custom object
- Add fields:
  - Name (Text)
  - Service_Agreement_Core__c (Master-Detail)
  - Budget specific fields
- Configure page layouts

### Validation Rules

#### Material_Usage__c Validation Rules
- Prevent Over-Allocation:
  ```
  Quantity_Used__c > Material_Stock__c.Quantity__c
  ```
- Prevent Zero/Negative Usage:
  ```
  Quantity_Used__c <= 0
  ```
- Prevent Usage After Schedule Completion:
  ```
  ISPICKVAL(Schedule__c.Status__c, "Completed") && ISCHANGED(Quantity_Used__c)
  ```

#### Material_Stock__c Validation Rules
- Prevent Negative Stock:
  ```
  Quantity__c < 0
  ```

#### Material_Budget__c Validation Rules
- Ensure Budget Period Validity:
  ```
  Date_Range_End__c < Date_Range_Start__c
  ```
- Prevent Negative Budget:
  ```
  Budgeted_Quantity__c <= 0 || Budgeted_Cost__c <= 0
  ```

## Test Data Creation
1. Create at least 3 Material Categories
2. Create 2-3 SKUs per category
3. Create stock records for each SKU
4. Create test resources, assets, and gear
5. Create test contracts and assignments
6. Create test budgets at the category level
7. Create test usage records

## Success Metrics
- All objects created with proper fields and relationships
- All validation rules functioning correctly
- Roll-up summaries calculating properly
- Formula fields displaying correct values
- Test data demonstrates proper object relationships

## Future Considerations
- Unit of measure normalization function needed for Material_Category__c and Material_SKU__c
- Consider adding "bf_" prefix to all custom objects for better namespace management 