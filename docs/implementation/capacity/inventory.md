---
layout: default
title: "Inventory Capacity Fields"
parent: "Capacity Management Implementation"
grand_parent: "Implementation Guides"
nav_order: 1
---

# Inventory Capacity Fields Implementation Guide

This guide provides detailed specifications for implementing the capacity fields on the Inventory__c object to support the Theory of Constraints approach.

## Overview

In the BoxFresh app, inventory containers are treated as capacity-constrained resources. Each container has a defined capacity, and materials stored within consume a portion of that capacity. The capacity management system allows you to:

- Track total and available capacity
- Monitor buffer zones (red/yellow/green)
- Identify system constraints
- Prevent capacity overallocation

## Field Specifications

### Inventory__c Object

| Field Label | API Name | Data Type | Description | Formula | Default Value |
|-------------|----------|-----------|-------------|---------|---------------|
| Capacity Units | Capacity_Units__c | Number(18, 0) | Total capacity units available in this container | N/A | 100 |
| Available Units | Available_Units__c | Formula (Number) | Calculated available capacity units remaining | Capacity_Units__c - Total_Units_Consumed__c | N/A |
| Total Units Consumed | Total_Units_Consumed__c | Roll-Up Summary | Sum of Units_Consumed__c from all related Material_Stock__c records | SUM(Material_Stock__c.Units_Consumed__c) | 0 |
| Buffer Status | Buffer_Status__c | Formula (Text) | Current buffer zone status | IF(Available_Units__c / Capacity_Units__c <= 0.3, "Below Buffer", IF(Available_Units__c / Capacity_Units__c >= 0.7, "Above Buffer", "Within Buffer")) | N/A |
| Is Constraint | Is_Constraint__c | Checkbox | Flag indicating if this container is a current system constraint | N/A | False |
| Capacity Utilization % | Capacity_Utilization_Percent__c | Formula (Percent) | Percentage of capacity currently utilized | (Total_Units_Consumed__c / Capacity_Units__c) * 100 | N/A |

## Buffer Management Zones

The Buffer Status field implements a three-zone buffer management system based on TOC principles:

- **Below Buffer (Red Zone)** - Less than 30% of capacity available. Considered at risk and requires immediate attention.
- **Within Buffer (Yellow Zone)** - Between 30% and 70% of capacity available. Normal operating range.
- **Above Buffer (Green Zone)** - More than 70% of capacity available. Capacity is underutilized.

![Buffer Management Zones](../../assets/buffer-zones.png)

## Implementation Steps

### 1. Create Custom Fields

1. Navigate to **Setup** > **Object Manager** > **Inventory__c**
2. Click **Fields & Relationships** > **New**
3. Create each field according to the specifications below

#### Capacity_Units__c (Number)

- **Data Type**: Number
- **Field Label**: Capacity Units
- **Length**: 18
- **Decimal Places**: 0
- **Field Name**: Capacity_Units__c
- **Description**: Total capacity units available in this container
- **Required**: Checked
- **Default Value**: 100
- **Help Text**: The maximum number of capacity units this container can hold

#### Total_Units_Consumed__c (Roll-Up Summary)

- **Data Type**: Roll-Up Summary
- **Field Label**: Total Units Consumed
- **Field Name**: Total_Units_Consumed__c
- **Summarized Object**: Material_Stock__c
- **Roll-Up Type**: SUM
- **Field to Aggregate**: Units_Consumed__c
- **Filter Criteria**: None (sum all related records)
- **Description**: Total capacity units currently consumed by all material stock in this container

#### Available_Units__c (Formula)

- **Data Type**: Formula
- **Field Label**: Available Units
- **Field Name**: Available_Units__c
- **Formula Return Type**: Number
- **Decimal Places**: 0
- **Formula**: `Capacity_Units__c - Total_Units_Consumed__c`
- **Description**: Calculated available capacity units remaining

#### Buffer_Status__c (Formula)

- **Data Type**: Formula
- **Field Label**: Buffer Status
- **Field Name**: Buffer_Status__c
- **Formula Return Type**: Text
- **Formula**:
  ```
  IF(Available_Units__c / Capacity_Units__c <= 0.3, "Below Buffer", 
    IF(Available_Units__c / Capacity_Units__c >= 0.7, "Above Buffer", 
      "Within Buffer"))
  ```
- **Description**: Current buffer zone status based on TOC principles

#### Is_Constraint__c (Checkbox)

- **Data Type**: Checkbox
- **Field Label**: Is Constraint
- **Field Name**: Is_Constraint__c
- **Default Value**: Unchecked
- **Description**: Flag indicating if this container is a current system constraint

#### Capacity_Utilization_Percent__c (Formula)

- **Data Type**: Formula
- **Field Label**: Capacity Utilization %
- **Field Name**: Capacity_Utilization_Percent__c
- **Formula Return Type**: Percent
- **Decimal Places**: 1
- **Formula**: `(Total_Units_Consumed__c / Capacity_Units__c) * 100`
- **Description**: Percentage of capacity currently utilized

### 2. Page Layout Updates

1. Navigate to **Setup** > **Object Manager** > **Inventory__c** > **Page Layouts**
2. Add a new section called "Capacity Management"
3. Add the following fields to this section:
   - Capacity Units
   - Total Units Consumed
   - Available Units
   - Capacity Utilization %
   - Buffer Status
   - Is Constraint

### 3. Field-Level Security

1. Navigate to **Setup** > **Object Manager** > **Inventory__c** > **Fields & Relationships**
2. For each field, click the field name, then click **Set Field-Level Security**
3. Configure as follows:
   - System Administrator: Visible and Editable for all fields (Read-Only for formula fields)
   - Standard User: Visible for all fields, Editable only for Capacity_Units__c and Is_Constraint__c

### 4. Validation Rule

Create a validation rule to prevent negative available capacity:

1. Navigate to **Setup** > **Object Manager** > **Inventory__c** > **Validation Rules** > **New**
2. Configure as follows:
   - **Rule Name**: Prevent_Negative_Capacity
   - **Active**: Checked
   - **Error Condition Formula**: `Available_Units__c < 0`
   - **Error Message**: "This container would exceed its capacity. Please increase capacity or remove materials."
   - **Error Location**: Top of Page

## Testing Steps

Once implemented, verify the following:

1. Create a new Inventory__c record with Capacity_Units__c = 100
2. Create several Material_Stock__c records related to this inventory with various Units_Consumed__c values
3. Verify that:
   - Total_Units_Consumed__c correctly sums all Units_Consumed__c values
   - Available_Units__c correctly calculates remaining capacity
   - Buffer_Status__c shows the correct status based on utilization
   - Validation prevents total consumption exceeding capacity

## Related Implementation Guides

- [Material Stock Capacity Fields](./stock.md) - Implementing the capacity consumption fields for materials
- [Assignment Junction Relationship](./junction.md) - Creating the junction relationship between inventory and assignments
- [Capacity Management Flows](./flows.md) - Implementing the flows that ensure capacity constraints are maintained

## Considerations

- The default capacity of 100 units can be adjusted based on your specific business needs
- Buffer thresholds (30% and 70%) are implemented directly in the formula and may need adjustment
- The Is_Constraint__c field is manually set and should be updated during regular constraint reviews

## Documentation Consolidation

This content has been migrated as part of the [Documentation Consolidation Initiative](../../project/consolidation-status.md) (April 3-11, 2025). 