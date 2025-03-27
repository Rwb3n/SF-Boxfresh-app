---
layout: default
title: "Assignment Junction Relationship"
parent: "Capacity Management Implementation"
grand_parent: "Implementation Guides"
nav_order: 3
---

# Assignment Junction Relationship Implementation Guide

This guide provides detailed specifications for enhancing the Assignment__c object to serve as a junction between contracts, inventory containers, and resources, in line with the Theory of Constraints approach.

## Overview

In the BoxFresh capacity management system, the Assignment__c object acts as a crucial junction point that connects three key entities:

1. **Core_Contract__c** - The service contract or job
2. **Resource_Unit__c** - The resource assigned to fulfill the contract
3. **Inventory__c** - The inventory container providing materials for the job

This junction relationship enables capacity checks and material allocation as part of the TOC implementation, ensuring that inventory constraints are respected when making assignments.

![Junction Relationship](../../assets/junction-model.png)

## Field Specifications

### Assignment__c Object

| Field Label | API Name | Data Type | Description | Default Value |
|-------------|----------|-----------|-------------|---------------|
| Assigned Inventory | Assigned_Inventory__c | Lookup (Inventory__c) | Links to the inventory container used for this assignment | None |
| Total Capacity Required | Total_Capacity_Required__c | Number(18, 2) | Total capacity units needed for this assignment | 0 |
| Capacity Allocated | Capacity_Allocated__c | Number(18, 2) | Capacity units successfully allocated | 0 |
| Capacity Status | Capacity_Status__c | Formula (Text) | Status of capacity allocation | Based on allocation percentage |
| Material Status | Material_Status__c | Formula (Text) | Overall material status for this assignment | Based on related material stock |

## Junction Model in TOC Implementation

The junction design enables:

1. **Capacity Verification**: Before finalizing assignments, the system can verify sufficient capacity exists
2. **Resource-Inventory Association**: Links resources to specific inventory containers
3. **Contract Material Requirements**: Tracks capacity needs for each contract/job
4. **Status Monitoring**: Provides visibility into allocation status

## Implementation Steps

### 1. Enhance Existing Assignment Object

First, ensure that Assignment__c already has the proper master-detail relationship to Core_Contract__c and lookup relationships to Resource_Unit__c:

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Fields & Relationships**
2. Verify the following fields exist (if not, create them):
   - **Core_Contract__c**: Master-Detail relationship to Core_Contract__c
   - **Resource_Unit__c**: Lookup relationship to Resource_Unit__c

### 2. Create New Fields for Inventory Junction

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Fields & Relationships** > **New**
2. Create each field according to the specifications below

#### Assigned_Inventory__c (Lookup)

- **Data Type**: Lookup Relationship
- **Related To**: Inventory__c
- **Field Label**: Assigned Inventory
- **Field Name**: Assigned_Inventory__c
- **Child Relationship Name**: Assignments
- **Description**: The inventory container allocated to this assignment
- **Required**: Optional
- **Help Text**: The inventory container from which materials will be drawn for this assignment

#### Total_Capacity_Required__c (Number)

- **Data Type**: Number
- **Field Label**: Total Capacity Required
- **Field Name**: Total_Capacity_Required__c
- **Length**: 18
- **Decimal Places**: 2
- **Description**: Total capacity units needed for this assignment
- **Required**: False
- **Default Value**: 0
- **Help Text**: The total capacity units required for all materials in this assignment

#### Capacity_Allocated__c (Number)

- **Data Type**: Number
- **Field Label**: Capacity Allocated
- **Field Name**: Capacity_Allocated__c
- **Length**: 18
- **Decimal Places**: 2
- **Description**: Capacity units successfully allocated to this assignment
- **Required**: False
- **Default Value**: 0
- **Help Text**: The total capacity units that have been allocated to this assignment

#### Capacity_Status__c (Formula)

- **Data Type**: Formula
- **Field Label**: Capacity Status
- **Field Name**: Capacity_Status__c
- **Formula Return Type**: Text
- **Formula**:
  ```
  IF(Total_Capacity_Required__c == 0, "Not Required",
    IF(Capacity_Allocated__c >= Total_Capacity_Required__c, "Fully Allocated",
      IF(Capacity_Allocated__c > 0, "Partially Allocated", "Not Allocated")))
  ```
- **Description**: Status of capacity allocation for this assignment

#### Material_Status__c (Formula)

- **Data Type**: Formula
- **Field Label**: Material Status
- **Field Name**: Material_Status__c
- **Formula Return Type**: Text
- **Formula**:
  ```
  IF(Assigned_Inventory__c = null, "No Inventory Assigned",
    IF(Assigned_Inventory__r.Buffer_Status__c = "Below Buffer", "At Risk",
      "Ready"))
  ```
- **Description**: Overall material status based on inventory buffer status

### 3. Create Related List on Inventory__c

1. Navigate to **Setup** > **Object Manager** > **Inventory__c** > **Page Layouts**
2. Add a related list for "Assignments" to show assignments using this inventory
3. Configure columns to show:
   - Assignment Name
   - Core Contract
   - Total Capacity Required
   - Capacity Allocated
   - Capacity Status

### 4. Page Layout Updates for Assignment__c

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Page Layouts**
2. Add a new section called "Material & Capacity"
3. Add the following fields to this section:
   - Assigned Inventory
   - Total Capacity Required
   - Capacity Allocated
   - Capacity Status
   - Material Status

### 5. Create Validation Rule

Create a validation rule to ensure the assignment doesn't exceed available capacity:

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Validation Rules** > **New**
2. Configure as follows:
   - **Rule Name**: Check_Capacity_Available
   - **Active**: Checked
   - **Error Condition Formula**:
     ```
     AND(
       NOT(ISBLANK(Assigned_Inventory__c)),
       Total_Capacity_Required__c > 0,
       Assigned_Inventory__r.Available_Units__c < Total_Capacity_Required__c - Capacity_Allocated__c
     )
     ```
   - **Error Message**: "The selected inventory container doesn't have enough available capacity for this assignment."
   - **Error Location**: Top of Page

### 6. Create Quick Action for Inventory Assignment

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Buttons, Links, and Actions** > **New Action**
2. Configure as follows:
   - **Action Type**: Update a Record
   - **Label**: Assign Inventory
   - **Name**: Assign_Inventory
   - **Fields to Include**:
     - Assigned_Inventory__c
     - Total_Capacity_Required__c

## Testing Steps

1. Create a test Core_Contract__c record
2. Create a test Resource_Unit__c record
3. Create a test Inventory__c record with 100 capacity units
4. Create an Assignment__c record connecting the contract and resource
5. Use the quick action to assign inventory and set capacity required to 50
6. Verify that:
   - Assigned_Inventory__c is set correctly
   - Capacity_Status__c shows "Not Allocated" initially
   - The validation rule prevents setting Total_Capacity_Required__c higher than available capacity

## Related Implementation Guides

- [Inventory Capacity Fields](./inventory.md) - Implementing container capacity fields
- [Material Stock Capacity Fields](./stock.md) - Implementing capacity consumption fields for materials
- [Capacity Management Flows](./flows.md) - Implementing flows that handle capacity allocation and verification
- [Validation Rules](./validation.md) - Additional validation rules for capacity management

## Considerations

- The junction model allows for flexibility in assignment and inventory allocation
- Consider using custom list views to monitor assignments with capacity issues
- Assignments with "At Risk" material status may require attention and potential reallocation

## Documentation Consolidation

This guide was migrated as part of the [Documentation Consolidation Initiative](../../project/consolidation-status.md) (April 3-11, 2025). 