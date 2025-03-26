---
layout: default
title: "Container Update Flow"
parent: "Implementation Guides"
nav_order: 5
---

# Container Update Flow Implementation Guide

This guide provides detailed instructions for implementing a Container Update Flow that keeps the Inventory__c capacity metrics current by recalculating field values based on related Material_Stock__c records.

## Flow Overview

The Container Update Flow is triggered when:
1. A Material_Stock__c record is created, updated, or deleted
2. The Units_Consumed__c field is changed
3. The Inventory__c (container) relationship is changed

The flow recalculates the container's capacity metrics:
- Total Units Consumed
- Available Units
- Capacity Utilization %
- Buffer Status

## Implementation Steps

### 1. Create the Flow

1. Navigate to **Setup** > **Flow Builder** > **New Flow**
2. Select **Record-Triggered Flow**
3. Configure trigger:
   - **Object**: Material_Stock__c
   - **Trigger When**: A record is created, updated, or deleted
   - **Condition Requirements**: 
     - Created: No conditions
     - Updated: [Units_Consumed__c] is changed OR [Inventory__c] is changed
     - Deleted: No conditions
   - **Run Asynchronously**: Unchecked (to maintain data consistency)
   - **Trigger Timing For Update**: After the record is saved (to capture final values)
   - **Trigger Timing For Create**: After the record is saved
   - **Trigger Timing For Delete**: Before the record is deleted

### 2. Add Variables

1. Create these flow variables:
   - **containerIdOld** (Text)
   - **containerIdNew** (Text)
   - **recordUnitsConsumed** (Number)
   - **isDeleted** (Boolean)
   - **isCreated** (Boolean)
   - **isUpdated** (Boolean)

### 3. Add Assignment Element for Context Variables

1. Add an **Assignment** element:
   - **API Name**: Set_Context_Variables
   - **Assignments**:
     - isDeleted = {!$Record__Prior} = null ? false : {!$Record} = null
     - isCreated = {!$Record__Prior} = null ? true : false
     - isUpdated = {!$Record__Prior} != null AND {!$Record} != null
     - containerIdOld = {!isUpdated} ? {!$Record__Prior.Inventory__c} : null
     - containerIdNew = {!isDeleted} ? null : {!$Record.Inventory__c}
     - recordUnitsConsumed = {!isDeleted} ? 0 : {!$Record.Units_Consumed__c}

### 4. Add Decision Element for Container Change

1. Add a **Decision** element:
   - **API Name**: Container_Change_Decision
   - **Default Outcome**: Single Container Update
   - **Rule 1**:
     - **Label**: Container Change
     - **Condition**: {!containerIdOld} != null AND {!containerIdNew} != null AND {!containerIdOld} != {!containerIdNew}

### 5. Add Get Records Elements for Container Data

1. First Get Records element (for new container):
   - **API Name**: Get_Container_New
   - **Connect after**: Container_Change_Decision - Single Container Update OR Container Change outcomes
   - **Object**: Inventory__c
   - **Filter Condition**: Id Equals {!containerIdNew}
   - **Store Output**: Single record with all fields

2. Second Get Records element (for old container, only needed for container changes):
   - **API Name**: Get_Container_Old
   - **Connect after**: Container_Change_Decision - Container Change outcome
   - **Object**: Inventory__c
   - **Filter Condition**: Id Equals {!containerIdOld}
   - **Store Output**: Single record with all fields

### 6. Add Get Records Elements for Related Material Stocks

1. First Get Records element (for new container's stocks):
   - **API Name**: Get_Related_Stocks_New
   - **Connect after**: Get_Container_New
   - **Object**: Material_Stock__c
   - **Filter Condition**: Inventory__c Equals {!containerIdNew}
   - **Store Output**: All records with all fields

2. Second Get Records element (for old container's stocks, only for container changes):
   - **API Name**: Get_Related_Stocks_Old
   - **Connect after**: Get_Container_Old
   - **Object**: Material_Stock__c
   - **Filter Condition**: Inventory__c Equals {!containerIdOld}
   - **Store Output**: All records with all fields

### 7. Add Loop and Collection Elements for New Container

1. Add a **Collection Sort** element:
   - **API Name**: Sort_Stocks_New
   - **Connect after**: Get_Related_Stocks_New
   - **Collection Variable**: {!Get_Related_Stocks_New}
   - **Sort By**: Units_Consumed__c (Descending)

2. Add a **Loop** element:
   - **API Name**: Loop_New_Stocks
   - **Connect after**: Sort_Stocks_New
   - **Collection Variable**: {!Sort_Stocks_New}
   - **Iterator Variable**: currentStock

3. Add a **Decision** element inside the loop:
   - **API Name**: Skip_Current_Record
   - **Default Outcome**: Process Record
   - **Rule 1**:
     - **Label**: Skip Current Record
     - **Condition**: {!isCreated} = false AND {!isUpdated} = true AND {!$Record.Id} = {!currentStock.Id}

4. Add an **Assignment** element after the Decision (Process Record outcome):
   - **API Name**: Update_New_Container_Totals
   - **Assignments**:
     - {!newContainerTotal} = {!newContainerTotal} + {!currentStock.Units_Consumed__c}

### 8. Add Similar Loop for Old Container (if Changed)

1. Add similar loop elements for the old container, connecting after Get_Related_Stocks_Old

### 9. Add Update Records Elements

1. Add an **Update Records** element for the new container:
   - **API Name**: Update_New_Container
   - **Connect after**: Loop_New_Stocks
   - **Object**: Inventory__c
   - **Field Values**:
     - Id = {!Get_Container_New.Id}
     - Total_Units_Consumed__c = {!newContainerTotal}
     - Available_Units__c = {!Get_Container_New.Capacity_Units__c} - {!newContainerTotal}
     - Capacity_Utilization_Percent__c = {!Get_Container_New.Capacity_Units__c} > 0 ? ({!newContainerTotal} / {!Get_Container_New.Capacity_Units__c} * 100) : 0
     - Buffer_Status__c = 
       CASE(
         TRUE,
         {!newContainerTotal} / {!Get_Container_New.Capacity_Units__c} * 100 > 70, "Critical",
         {!newContainerTotal} / {!Get_Container_New.Capacity_Units__c} * 100 > 30, "Normal",
         "Low"
       )

2. Add a similar Update Records element for the old container (if container changed)

### 10. Connect All Elements Together

1. Create the complete flow by connecting elements:
   - Start → Set_Context_Variables → Container_Change_Decision
   - Container_Change_Decision (Single Container Update) → Get_Container_New → Get_Related_Stocks_New → Sort_Stocks_New → Loop_New_Stocks → Update_New_Container → End
   - Container_Change_Decision (Container Change) → Get_Container_New + Get_Container_Old → (continue both paths) → Update both containers → End

### 11. Activate the Flow

1. Click **Save** and name the flow "Container_Update_Flow"
2. Click **Activate**

## Testing the Flow

Test the flow with these scenarios:

### Scenario 1: Creating a New Material Stock

1. Create an Inventory__c record with:
   - Capacity_Units__c = 100
   - Total_Units_Consumed__c = 0
2. Create a Material_Stock__c record with:
   - Inventory__c = the inventory you created
   - Units_Consumed__c = 40
3. Expected result:
   - Inventory__c record updates:
     - Total_Units_Consumed__c = 40
     - Available_Units__c = 60
     - Capacity_Utilization_Percent__c = 40
     - Buffer_Status__c = "Normal"

### Scenario 2: Updating a Material Stock

1. Update the Material_Stock__c record:
   - Change Units_Consumed__c from 40 to 75
2. Expected result:
   - Inventory__c record updates:
     - Total_Units_Consumed__c = 75
     - Available_Units__c = 25
     - Capacity_Utilization_Percent__c = 75
     - Buffer_Status__c = "Critical"

### Scenario 3: Moving Between Containers

1. Create a second Inventory__c record with:
   - Capacity_Units__c = 200
   - Total_Units_Consumed__c = 0
2. Update the Material_Stock__c record:
   - Change Inventory__c to the second inventory
3. Expected results:
   - First Inventory__c updates:
     - Total_Units_Consumed__c = 0
     - Available_Units__c = 100
     - Capacity_Utilization_Percent__c = 0
     - Buffer_Status__c = "Low"
   - Second Inventory__c updates:
     - Total_Units_Consumed__c = 75
     - Available_Units__c = 125
     - Capacity_Utilization_Percent__c = 37.5
     - Buffer_Status__c = "Normal"

### Scenario 4: Deleting a Material Stock

1. Delete the Material_Stock__c record
2. Expected result:
   - Second Inventory__c updates:
     - Total_Units_Consumed__c = 0
     - Available_Units__c = 200
     - Capacity_Utilization_Percent__c = 0
     - Buffer_Status__c = "Low"

## Considerations

- This flow handles the logic for a single Material_Stock__c change, but multiple simultaneous changes might require optimization
- For high-volume operations, consider implementing as an Apex trigger for better performance
- The buffer threshold values (30% and 70%) are hardcoded but could be made configurable
- Consider adding error handling for cases where a container's Capacity_Units__c is zero
- For very complex relationships, you might need to supplement the flow with additional validations 