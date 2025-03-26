---
layout: default
title: "Material Stock Capacity Fields"
parent: "Capacity Management Implementation"
grand_parent: "Implementation Guides"
nav_order: 2
---

# Material Stock Capacity Fields Implementation Guide

This guide provides detailed specifications for implementing the capacity consumption fields on the Material_Stock__c object to support the Theory of Constraints approach.

## Overview

In the BoxFresh app's TOC implementation, materials stored in containers consume a defined amount of capacity. The Material_Stock__c object tracks how much capacity each material consumes and monitors its status relative to the container's buffer zones.

Key concepts in this implementation:
- Each material type consumes a specific number of capacity units per quantity
- Total capacity consumption is calculated based on quantity and consumption rate
- Materials inherit buffer status from their parent container
- Priority flags help identify critical materials in buffer management

## Field Specifications

### Material_Stock__c Object

| Field Label | API Name | Data Type | Description | Formula | Default Value |
|-------------|----------|-----------|-------------|---------|---------------|
| Units Consumed | Units_Consumed__c | Number(18, 2) | Capacity units consumed by this stock | N/A | 0 |
| Capacity Status | Capacity_Status__c | Formula (Text) | Status relative to buffer thresholds | Based on parent container's buffer status | N/A |
| Units Per Quantity | Units_Per_Quantity__c | Number(18, 2) | Capacity units consumed per unit of quantity | N/A | 1 |
| Total Capacity Required | Total_Capacity_Required__c | Formula (Number) | Total capacity required for this stock | Quantity__c * Units_Per_Quantity__c | N/A |
| Buffer Priority | Buffer_Priority__c | Picklist | Priority for buffer management | N/A | "Normal" |

## Capacity Consumption Model

Material stock capacity consumption follows these principles:

1. **Unit-Based Consumption**: Each material type has a defined capacity consumption rate (Units_Per_Quantity__c)
2. **Flexible Allocation**: Different materials can consume different amounts of capacity based on their characteristics
3. **Container Inheritance**: Material stock inherits buffer status from its container
4. **Priority Monitoring**: High-priority materials in below-buffer containers receive special attention

## Implementation Steps

### 1. Create Custom Fields

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c**
2. Click **Fields & Relationships** > **New**
3. Create each field according to the specifications below

#### Units_Per_Quantity__c (Number)

- **Data Type**: Number
- **Field Label**: Units Per Quantity
- **Length**: 18
- **Decimal Places**: 2
- **Field Name**: Units_Per_Quantity__c
- **Description**: Number of capacity units consumed per unit of quantity
- **Required**: Checked
- **Default Value**: 1
- **Help Text**: The number of capacity units a single unit of this material consumes in inventory

#### Units_Consumed__c (Number)

- **Data Type**: Number
- **Field Label**: Units Consumed
- **Field Name**: Units_Consumed__c
- **Length**: 18
- **Decimal Places**: 2
- **Description**: Total capacity units consumed by this stock
- **Required**: Checked
- **Default Value**: 0
- **Help Text**: The total capacity units this stock consumes in the container

#### Total_Capacity_Required__c (Formula)

- **Data Type**: Formula
- **Field Label**: Total Capacity Required
- **Field Name**: Total_Capacity_Required__c
- **Formula Return Type**: Number
- **Decimal Places**: 2
- **Formula**: `Quantity__c * Units_Per_Quantity__c`
- **Description**: Total capacity required based on quantity and units per quantity

#### Capacity_Status__c (Formula)

- **Data Type**: Formula
- **Field Label**: Capacity Status
- **Field Name**: Capacity_Status__c
- **Formula Return Type**: Text
- **Formula**:
  ```
  TEXT(Inventory__c.Buffer_Status__c)
  ```
- **Description**: Reflects the buffer status of the parent container

#### Buffer_Priority__c (Picklist)

- **Data Type**: Picklist
- **Field Label**: Buffer Priority
- **Field Name**: Buffer_Priority__c
- **Values**:
  - High
  - Normal
  - Low
- **Default Value**: Normal
- **Description**: Priority level for buffer management decisions

### 2. Create Validation Rule

Create a validation rule to ensure capacity is available:

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c** > **Validation Rules** > **New**
2. Configure as follows:
   - **Rule Name**: Enforce_Capacity_Limit
   - **Active**: Checked
   - **Error Condition Formula**: 
     ```
     Inventory__c.Available_Units__c < Units_Consumed__c
     ```
   - **Error Message**: "This material would exceed the container's available capacity."
   - **Error Location**: Field: Units_Consumed__c

### 3. Page Layout Updates

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c** > **Page Layouts**
2. Add a new section called "Capacity Consumption"
3. Add the following fields to this section:
   - Units Per Quantity
   - Units Consumed
   - Total Capacity Required
   - Capacity Status
   - Buffer Priority

### 4. Field Dependencies

Create a field dependency to highlight high-priority items in below-buffer containers:

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c** > **Fields & Relationships**
2. Click on **Buffer_Priority__c** > **Field Dependencies** > **New**
3. Configure as follows:
   - **Controlling Field**: Capacity_Status__c
   - **Dependent Field**: Buffer_Priority__c
   - For "Below Buffer" status, make "High" priority bold/highlighted

### 5. Set up Quick Action

Create a quick action to adjust capacity consumption:

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c** > **Buttons, Links, and Actions** > **New Action**
2. Configure as follows:
   - **Action Type**: Update a Record
   - **Label**: Adjust Consumption
   - **Name**: Adjust_Consumption
   - **Fields to Include**:
     - Units_Consumed__c
     - Buffer_Priority__c
   - **Predefined Field Values**: None
   - **Success Message**: "Capacity consumption updated successfully"

### 6. Automation for Capacity Calculation

Create a flow or trigger to automatically update Units_Consumed__c when Quantity__c changes:

1. Create a record-triggered flow:
   - **Object**: Material_Stock__c
   - **Trigger**: After update
   - **Condition**: Quantity__c is changed
   - **Action**: Update Units_Consumed__c to Quantity__c * Units_Per_Quantity__c

## Testing Steps

1. Create a new Material_Stock__c record with:
   - Inventory__c linked to a container with capacity
   - Quantity__c = 10
   - Units_Per_Quantity__c = 2

2. Verify that:
   - Units_Consumed__c is updated to 20
   - The container's Total_Units_Consumed__c increases by 20
   - The container's Available_Units__c decreases by 20
   - Capacity_Status__c correctly reflects the container's buffer status

3. Test the validation rule by attempting to create a material that would exceed the container's capacity

## Related Implementation Guides

- [Inventory Capacity Fields](./inventory.md) - Implementing container capacity fields
- [Assignment Junction Relationship](./junction.md) - Creating the junction relationship between inventory and assignments
- [Capacity Management Flows](./flows.md) - Implementing flows for capacity management

## Considerations

- Different material types may need different Units_Per_Quantity__c values based on size, weight, or other factors
- Review Buffer_Priority__c assignments regularly to ensure critical materials are properly identified
- Consider creating a custom report to highlight high-priority materials in below-buffer containers

## Documentation Consolidation

This content has been migrated as part of the [Documentation Consolidation Initiative](../../project/consolidation-status.md) (April 3-11, 2025). 