---
layout: default
title: "Capacity Management Flows"
parent: "Capacity Management Implementation"
grand_parent: "Implementation Guides"
nav_order: 4
---

# Capacity Management Flows Implementation Guide

This guide provides detailed instructions for implementing the automated flows that enforce capacity constraints and maintain buffer management in the BoxFresh app's Theory of Constraints implementation.

## Overview

Capacity management requires two key automated flows:

1. **Capacity Check Flow**: Validates material stock changes against container capacity constraints
2. **Container Update Flow**: Recalculates container capacity metrics when material stocks change

Together, these flows ensure:
- Containers never exceed their defined capacity
- Buffer zones (red/yellow/green) are properly maintained
- Alerts are created when containers cross buffer thresholds
- Container capacity metrics remain accurate and up-to-date

## Flow 1: Capacity Check Flow

### Purpose
The Capacity Check Flow verifies that material stock changes won't exceed container capacity constraints and generates alerts when buffer thresholds are crossed.

### Trigger Points
- When a new Material_Stock__c record is created
- When an existing Material_Stock__c record's Units_Consumed__c or Inventory__c fields are updated

### Flow Logic

![Capacity Check Flow](../../assets/capacity-check-flow.png)

1. **Capacity Validation**:
   - Calculate the container's available capacity
   - Check if the material stock change would exceed capacity
   - Block the change if capacity would be exceeded

2. **Buffer Threshold Monitoring**:
   - Track if container crosses buffer thresholds (30% and 70%)
   - Create alerts when thresholds are crossed

### Implementation Steps

#### 1. Create the Flow

1. Navigate to **Setup** > **Flow Builder** > **New Flow**
2. Select **Record-Triggered Flow**
3. Configure trigger:
   - **Object**: Material_Stock__c
   - **Trigger When**: A record is created or updated
   - **Entry Criteria**: [Units_Consumed__c] > 0 OR [Inventory__c] CHANGES
   - **Optimization**: Run only when specified changes are made
   - **Run Asynchronously**: Unchecked

#### 2. Add Variables

Create these flow variables:
- **containerAvailableBefore** (Number)
- **containerAvailableAfter** (Number)
- **stockUnitsBeforeChange** (Number)
- **newUnitsConsumed** (Number)
- **inventoryId** (Text)
- **wasOverThreshold** (Boolean)
- **isOverThreshold** (Boolean)
- **wasUnderThreshold** (Boolean)
- **isUnderThreshold** (Boolean)

#### 3. Set Up Data Access and Calculations

1. **Get Old Stock Data** (Get Records element)
   - Object: Material_Stock__c
   - Filter: Id Equals {!$Record.Id}
   - Store Units_Consumed__c and Inventory__c values

2. **Get Container Data** (Get Records element)
   - Object: Inventory__c
   - Filter: Id Equals {!$Record.Inventory__c}
   - Store all fields

3. **Calculate Available Capacity** (Assignment element)
   - containerAvailableBefore = Current container available units + Units consumed before change
   - newUnitsConsumed = New units consumed value
   - containerAvailableAfter = Available before - New units consumed
   - Calculate threshold crossing flags:
     - wasOverThreshold = Current utilization >= 70%?
     - isOverThreshold = New utilization >= 70%?
     - wasUnderThreshold = Current utilization <= 30%?
     - isUnderThreshold = New utilization <= 30%?

#### 4. Add Decision Elements

1. **Check Capacity** (Decision element)
   - Rule: containerAvailableAfter < 0
   - If true, show error screen
   - If false, proceed to threshold check

2. **Check Threshold Crossing** (Decision element)
   - Rule 1: wasOverThreshold = false AND isOverThreshold = true (crossed upper threshold)
   - Rule 2: wasUnderThreshold = false AND isUnderThreshold = true (crossed lower threshold)
   - Default: No threshold crossed

#### 5. Add Alert Creation Logic

1. **Create Upper Alert** (Create Records element)
   - Object: Task
   - Subject: "Container Above Buffer: " + Container Name
   - Description: Details about reaching upper threshold
   - Priority: High

2. **Create Lower Alert** (Create Records element)
   - Object: Task
   - Subject: "Container Below Buffer: " + Container Name
   - Description: Details about reaching lower threshold
   - Priority: Medium

#### 6. Error Handling

Add a Screen element to display when capacity would be exceeded:
- Heading: Capacity Limit Exceeded
- Message: The material would exceed the container's capacity by {amount} units
- Back button to allow user to revise their input

## Flow 2: Container Update Flow

### Purpose
The Container Update Flow keeps container capacity metrics synchronized with the actual material stock stored within the container.

### Trigger Points
- When a Material_Stock__c record is created, updated, or deleted
- When the Units_Consumed__c field is changed
- When the Inventory__c relationship is changed

### Flow Logic

![Container Update Flow](../../assets/container-update-flow.png)

1. **Context Determination**:
   - Determine if this is a container change or single container update
   - Identify the affected container(s)

2. **Capacity Recalculation**:
   - Recalculate total units consumed
   - Update available units, capacity utilization, and buffer status

### Implementation Steps

#### 1. Create the Flow

1. Navigate to **Setup** > **Flow Builder** > **New Flow**
2. Select **Record-Triggered Flow**
3. Configure trigger:
   - **Object**: Material_Stock__c
   - **Trigger When**: A record is created, updated, or deleted
   - **Condition Requirements**:
     - Created: No conditions
     - Updated: [Units_Consumed__c] is changed OR [Inventory__c] is changed
     - Deleted: No conditions
   - **Run Asynchronously**: Unchecked
   - **Trigger Timing For Update/Create**: After the record is saved
   - **Trigger Timing For Delete**: Before the record is deleted

#### 2. Add Variables

Create flow variables:
- **containerIdOld** (Text)
- **containerIdNew** (Text)
- **recordUnitsConsumed** (Number)
- **isDeleted** (Boolean)
- **isCreated** (Boolean)
- **isUpdated** (Boolean)

#### 3. Set Up Context Detection

1. **Context Variables** (Assignment element)
   - Determine operation type (create/update/delete)
   - For updates, capture old and new container IDs
   - Track units consumed value

2. **Container Change Decision** (Decision element)
   - Check if this is a container change or single container update
   - Branch flow accordingly

#### 4. Data Access Elements

1. **Get Container Data** (Get Records elements)
   - Get container details (new container, and old container if changed)
   - For each container, get all related material stocks

#### 5. Process Stock Data

1. **Sort and Loop** (Loop elements)
   - Sort material stocks by priority
   - Calculate total consumption for each container
   - Prepare values for container updates

#### 6. Update Container(s)

1. **Update Container Records** (Update Records elements)
   - Update each affected container with:
     - Total_Units_Consumed__c = Sum of all Units_Consumed__c
     - Available_Units__c = Capacity_Units__c - Total_Units_Consumed__c
     - Capacity_Utilization_Percent__c = (Total/Capacity) * 100
     - Buffer_Status__c = Based on utilization percent thresholds

## Testing the Flows

### Test Scenario 1: Within Capacity Limits

1. Create an Inventory__c record with Capacity_Units__c = 100
2. Create a Material_Stock__c record with Units_Consumed__c = 60
3. Expected results:
   - Record created successfully
   - Container updated with 60% utilization
   - Alert created for crossing into yellow zone

### Test Scenario 2: Exceeds Capacity

1. Try to create a second Material_Stock__c with Units_Consumed__c = 50
2. Expected results:
   - Error shown (exceeds capacity by 10 units)
   - Change blocked

### Test Scenario 3: Container Change

1. Create a second Inventory__c with Capacity_Units__c = 200
2. Move the Material_Stock__c to the second container
3. Expected results:
   - First container updated to 0% utilization
   - Second container updated to 30% utilization
   - Both containers' metrics recalculated correctly

## Optimization Considerations

- For high-volume operations, consider Apex triggers for better performance
- Make threshold values (30%/70%) configurable via custom settings
- Add appropriate error handling for edge cases
- Consider batch processing for handling large volumes of records

## Related Implementation Guides

- [Inventory Capacity Fields](./inventory.md) - Implementing the container capacity fields
- [Material Stock Capacity Fields](./stock.md) - Implementing capacity consumption fields
- [Assignment Junction Relationship](./junction.md) - Creating the junction relationship
- [Validation Rules](./validation.md) - Additional validation rules for capacity management

## Documentation Consolidation

This guide was consolidated from the original implementation guides `capacity_check_flow.md` and `container_update_flow.md` as part of the [Documentation Consolidation Initiative](../../project/consolidation-status.md) (April 3-11, 2025). 