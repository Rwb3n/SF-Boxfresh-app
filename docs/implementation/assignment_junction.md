---
layout: default
title: "Assignment Junction Relationship"
parent: "Implementation Guides"
nav_order: 3
---

# Assignment Junction Relationship Implementation Guide

This guide provides detailed specifications for enhancing the Assignment__c object to serve as a junction between contracts, inventory containers, and resources, in line with the Theory of Constraints approach.

## Field Specifications

### Assignment__c Object

| Field Label | API Name | Data Type | Description | Default Value |
|-------------|----------|-----------|-------------|---------------|
| Assigned Inventory | Assigned_Inventory__c | Lookup (Inventory__c) | Links to the inventory container used for this assignment | None |
| Total Capacity Required | Total_Capacity_Required__c | Number(18, 2) | Total capacity units needed for this assignment | 0 |
| Capacity Allocated | Capacity_Allocated__c | Number(18, 2) | Capacity units successfully allocated | 0 |
| Capacity Status | Capacity_Status__c | Formula (Text) | Status of capacity allocation | Based on allocation percentage |
| Material Status | Material_Status__c | Formula (Text) | Overall material status for this assignment | Based on related material stock |

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
   - **Rule Name**: Validate_Capacity_Allocation
   - **Active**: Checked
   - **Error Condition Formula**: 
     ```
     AND(
       NOT(ISBLANK(Assigned_Inventory__c)),
       Capacity_Allocated__c > Assigned_Inventory__c.Available_Units__c
     )
     ```
   - **Error Message**: "The capacity allocated exceeds the available capacity in the assigned inventory container."
   - **Error Location**: Field: Capacity_Allocated__c

## Automation: Capacity Allocation Flow

Create a flow to automatically calculate and allocate capacity:

1. Navigate to **Setup** > **Flow Builder** > **New Flow**
2. Create a Record-Triggered Flow on the Assignment__c object
3. Trigger when a record is created or updated, and when Assigned_Inventory__c or Total_Capacity_Required__c changes
4. Implement this logic:
   - Check if Assigned_Inventory__c has sufficient Available_Units__c
   - If yes, set Capacity_Allocated__c = Total_Capacity_Required__c
   - If no, set Capacity_Allocated__c to the maximum available (or leave unchanged if reducing would lose allocation)
   - Create a Task if capacity can't be fully allocated

## Testing Steps

Once implemented, verify the following:

1. Create a new Assignment__c record:
   - Link to a Core_Contract__c
   - Link to a Resource_Unit__c
   - Link to an Inventory__c with available capacity
   - Set Total_Capacity_Required__c = 50
2. Verify that:
   - Capacity_Allocated__c is updated via the flow
   - Capacity_Status__c shows the correct allocation status
   - Material_Status__c reflects the assigned inventory's buffer status
   - The assignment appears in the related list on the Inventory__c record

## Considerations

- The junction relationship allows you to track material assignments across contracts and resources
- Consider creating a visual indicator on Assignment__c records to highlight capacity issues
- Ensure proper security settings so that only authorized users can modify capacity allocations
- The automated flow helps maintain data integrity but can be overridden for special cases
- Consider adding rollup summaries on Core_Contract__c to show total capacity required across all assignments 