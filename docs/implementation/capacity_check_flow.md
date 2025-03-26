---
layout: default
title: "Capacity Check Flow"
parent: "Implementation Guides"
nav_order: 4
---

> **DEPRECATION NOTICE**: This document has been moved to [Capacity Management Flows](capacity/flows.md) as part of the Documentation Consolidation Initiative. Please use the new location for the most up-to-date information.
{: .warning }

# Capacity Check Flow Implementation Guide

This guide provides detailed instructions for implementing a Capacity Check Flow that validates material stock creation/updates against container capacity constraints, following the Theory of Constraints principles.

## Flow Overview

The Capacity Check Flow is triggered when:
1. A new Material_Stock__c record is created
2. An existing Material_Stock__c record's Units_Consumed__c or Inventory__c fields are updated

The flow checks if the material would exceed the container's capacity and:
- Prevents the change if it would exceed capacity
- Updates the container's buffer status
- Creates alerts when containers cross buffer thresholds

## Implementation Steps

### 1. Create the Flow

1. Navigate to **Setup** > **Flow Builder** > **New Flow**
2. Select **Record-Triggered Flow**
3. Configure trigger:
   - **Object**: Material_Stock__c
   - **Trigger When**: A record is created or updated
   - **Entry Criteria**: [Units_Consumed__c] > 0 OR [Inventory__c] CHANGES
   - **Optimization**: Run only when specified changes are made
   - **Run Asynchronously**: Unchecked

### 2. Add Variables

1. Create these flow variables:
   - **containerAvailableBefore** (Number)
   - **containerAvailableAfter** (Number)
   - **stockUnitsBeforeChange** (Number)
   - **newUnitsConsumed** (Number)
   - **inventoryId** (Text)
   - **wasOverThreshold** (Boolean)
   - **isOverThreshold** (Boolean)
   - **wasUnderThreshold** (Boolean)
   - **isUnderThreshold** (Boolean)

### 3. Add Get Records Element for Old Material Stock

1. Add a **Get Records** element:
   - **API Name**: Get_Old_Stock
   - **Object**: Material_Stock__c
   - **Filter Condition**: Id Equals {!$Record.Id}
   - **Store Output**: Select "Choose fields and assign variables"
   - **Field Storage**:
     - Units_Consumed__c → stockUnitsBeforeChange
     - Inventory__c → inventoryId (if this is a record change)

### 4. Add Get Records Element for Inventory

1. Add a **Get Records** element:
   - **API Name**: Get_Inventory
   - **Object**: Inventory__c
   - **Filter Condition**: Id Equals {!$Record.Inventory__c}
   - **Store Output**: Single record with all fields

### 5. Add Assignment Elements for Buffer Calculations

1. Add an **Assignment** element:
   - **API Name**: Calculate_Available_Units
   - **Assignments**:
     - containerAvailableBefore = {!Get_Inventory.Available_Units__c} + {!stockUnitsBeforeChange}
     - newUnitsConsumed = {!$Record.Units_Consumed__c}
     - containerAvailableAfter = {!containerAvailableBefore} - {!newUnitsConsumed}
     - wasOverThreshold = {!Get_Inventory.Capacity_Utilization_Percent__c} >= 70
     - isOverThreshold = ({!Get_Inventory.Total_Units_Consumed__c} - {!stockUnitsBeforeChange} + {!newUnitsConsumed}) / {!Get_Inventory.Capacity_Units__c} * 100 >= 70
     - wasUnderThreshold = {!Get_Inventory.Capacity_Utilization_Percent__c} <= 30
     - isUnderThreshold = ({!Get_Inventory.Total_Units_Consumed__c} - {!stockUnitsBeforeChange} + {!newUnitsConsumed}) / {!Get_Inventory.Capacity_Units__c} * 100 <= 30

### 6. Add Decision Element for Capacity Check

1. Add a **Decision** element:
   - **API Name**: Check_Capacity
   - **Default Outcome**: Has Capacity
   - **Rule 1**:
     - **Label**: Exceeds Capacity
     - **Condition**: {!containerAvailableAfter} < 0

### 7. Add Screen Flow (Error Message)

1. Add a **Screen** element:
   - **API Name**: Show_Error
   - **Connect after**: Check_Capacity - Exceeds Capacity outcome
   - **Type**: Faulted Screen
   - **Heading**: Capacity Limit Exceeded
   - **Text**: The material would exceed the container's capacity by {!containerAvailableAfter * -1} units. The container has {!containerAvailableBefore} units available.
   - **Add Actions**: Add a "Back" button

### 8. Add Decision Element for Threshold Crossing

1. Add a **Decision** element:
   - **API Name**: Check_Threshold_Crossing
   - **Connect after**: Check_Capacity - Has Capacity outcome
   - **Default Outcome**: No Change
   - **Rule 1**:
     - **Label**: Crossed Upper Threshold
     - **Condition**: {!wasOverThreshold} = false AND {!isOverThreshold} = true
   - **Rule 2**:
     - **Label**: Crossed Lower Threshold
     - **Condition**: {!wasUnderThreshold} = false AND {!isUnderThreshold} = true

### 9. Add Create Records Element for Buffer Alerts

1. Add a **Create Records** element:
   - **API Name**: Create_Upper_Alert
   - **Connect after**: Check_Threshold_Crossing - Crossed Upper Threshold outcome
   - **Object**: Task
   - **Field Values**:
     - Subject = "Container Above Buffer: " + {!Get_Inventory.Name}
     - Description = "Container " + {!Get_Inventory.Name} + " has reached " + TEXT(ROUND({!isOverThreshold}, 1)) + "% capacity utilization, crossing the upper buffer threshold (70%)."
     - Priority = "High"
     - Status = "Not Started"
     - OwnerId = {!Get_Inventory.OwnerId}

2. Add another **Create Records** element:
   - **API Name**: Create_Lower_Alert
   - **Connect after**: Check_Threshold_Crossing - Crossed Lower Threshold outcome
   - **Object**: Task
   - **Field Values**:
     - Subject = "Container Below Buffer: " + {!Get_Inventory.Name}
     - Description = "Container " + {!Get_Inventory.Name} + " has reached " + TEXT(ROUND({!isUnderThreshold}, 1)) + "% capacity utilization, crossing the lower buffer threshold (30%)."
     - Priority = "Medium"
     - Status = "Not Started"
     - OwnerId = {!Get_Inventory.OwnerId}

### 10. Connect All Elements Together

1. Connect the elements in the following order:
   - Start → Get_Old_Stock → Get_Inventory → Calculate_Available_Units → Check_Capacity
   - Check_Capacity (Exceeds Capacity) → Show_Error → End
   - Check_Capacity (Has Capacity) → Check_Threshold_Crossing
   - Check_Threshold_Crossing (Crossed Upper Threshold) → Create_Upper_Alert → End
   - Check_Threshold_Crossing (Crossed Lower Threshold) → Create_Lower_Alert → End
   - Check_Threshold_Crossing (No Change) → End

### 11. Activate the Flow

1. Click **Save** and name the flow "Capacity_Check_Flow"
2. Click **Activate**

## Testing the Flow

Test the flow with these scenarios:

### Scenario 1: Within Capacity

1. Create an Inventory__c record with:
   - Capacity_Units__c = 100
   - Total_Units_Consumed__c = 0
2. Create a Material_Stock__c record with:
   - Inventory__c = the inventory you created
   - Units_Consumed__c = 60
3. Expected result:
   - Record is created successfully
   - A task is created for crossing the upper buffer threshold

### Scenario 2: Exceeds Capacity

1. Using the same Inventory__c record (now with 60 units consumed)
2. Create another Material_Stock__c record with:
   - Inventory__c = the same inventory
   - Units_Consumed__c = 50
3. Expected result:
   - Error screen appears showing capacity would be exceeded by 10 units
   - Record is not created

### Scenario 3: Update Existing Record

1. Update the first Material_Stock__c record:
   - Change Units_Consumed__c from 60 to 25
2. Expected result:
   - Record is updated successfully
   - A task is created for crossing the lower buffer threshold (now at 25% capacity)

## Considerations

- This flow focuses on a single Material_Stock__c record and may need optimization for bulk operations
- Consider adding scheduled flows to regularly review container utilization
- The threshold values (30% and 70%) are hardcoded but could be made configurable via custom settings
- For complex capacity calculations, consider using an Apex trigger instead of a flow
- Additional flows can be created to handle automatic reallocation when containers exceed thresholds 