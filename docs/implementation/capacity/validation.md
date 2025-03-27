---
layout: default
title: "Validation Rules"
parent: "Capacity Management Implementation"
grand_parent: "Implementation Guides"
nav_order: 5
---

# Capacity Validation Rules Implementation Guide

This guide provides detailed specifications for implementing validation rules that enforce capacity constraints in the BoxFresh app's Theory of Constraints implementation.

## Overview

Validation rules provide an additional layer of protection to ensure data integrity and capacity constraints are maintained. While the automated flows handle most capacity management logic, validation rules provide immediate feedback to users when actions would violate capacity constraints.

The BoxFresh capacity management system uses validation rules on three key objects:

1. **Inventory__c**: Prevent invalid capacity configurations
2. **Material_Stock__c**: Prevent capacity overallocation when adding/modifying stock
3. **Assignment__c**: Ensure assignment capacity requirements can be met

## Inventory__c Validation Rules

### 1. Prevent_Negative_Capacity

This rule prevents setting a container's capacity to a value that would result in negative available capacity.

- **Rule Name**: Prevent_Negative_Capacity
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  Available_Units__c < 0
  ```
- **Error Message**: "This container would exceed its capacity. Please increase capacity or remove materials."
- **Error Location**: Top of Page

### 2. Minimum_Capacity_Value

This rule ensures that capacity units are always set to a positive value.

- **Rule Name**: Minimum_Capacity_Value
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  Capacity_Units__c <= 0
  ```
- **Error Message**: "Capacity must be a positive number greater than zero."
- **Error Location**: Field: Capacity_Units__c

## Material_Stock__c Validation Rules

### 1. Enforce_Capacity_Limit

This rule prevents setting Units_Consumed__c to a value that would exceed the container's available capacity.

- **Rule Name**: Enforce_Capacity_Limit
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  Inventory__c.Available_Units__c < Units_Consumed__c
  ```
- **Error Message**: "This material would exceed the container's available capacity."
- **Error Location**: Field: Units_Consumed__c

### 2. Validate_Consumption_Rate

This rule ensures that Units_Per_Quantity__c is always a positive value.

- **Rule Name**: Validate_Consumption_Rate
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  Units_Per_Quantity__c <= 0
  ```
- **Error Message**: "Units per quantity must be a positive number greater than zero."
- **Error Location**: Field: Units_Per_Quantity__c

### 3. Ensure_Container_Assigned

This rule ensures that a container is always specified for material stock.

- **Rule Name**: Ensure_Container_Assigned
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  ISBLANK(Inventory__c)
  ```
- **Error Message**: "A container must be specified for this material stock."
- **Error Location**: Field: Inventory__c

## Assignment__c Validation Rules

### 1. Check_Capacity_Available

This rule prevents assigning more capacity than is available in the container.

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

### 2. Validate_Capacity_Required

This rule ensures that Total_Capacity_Required__c is non-negative.

- **Rule Name**: Validate_Capacity_Required
- **Active**: Checked
- **Error Condition Formula**: 
  ```
  Total_Capacity_Required__c < 0
  ```
- **Error Message**: "Total capacity required cannot be negative."
- **Error Location**: Field: Total_Capacity_Required__c

## Implementation Steps

### 1. Create Inventory__c Validation Rules

1. Navigate to **Setup** > **Object Manager** > **Inventory__c** > **Validation Rules** > **New**
2. Create each validation rule according to the specifications above
3. Activate each rule

### 2. Create Material_Stock__c Validation Rules

1. Navigate to **Setup** > **Object Manager** > **Material_Stock__c** > **Validation Rules** > **New**
2. Create each validation rule according to the specifications above
3. Activate each rule

### 3. Create Assignment__c Validation Rules

1. Navigate to **Setup** > **Object Manager** > **Assignment__c** > **Validation Rules** > **New**
2. Create each validation rule according to the specifications above
3. Activate each rule

## Testing the Validation Rules

### Test Scenario 1: Inventory Capacity

1. Create an Inventory__c record with:
   - Capacity_Units__c = 100
2. Create Material_Stock__c records that consume 80 units in total
3. Try to update Capacity_Units__c to 75
4. Expected result:
   - Error message: "This container would exceed its capacity. Please increase capacity or remove materials."

### Test Scenario 2: Material Stock Consumption

1. Using the Inventory__c record from Scenario 1 (100 capacity, 80 consumed)
2. Create a new Material_Stock__c record with:
   - Units_Consumed__c = 30
3. Expected result:
   - Error message: "This material would exceed the container's available capacity."

### Test Scenario 3: Assignment Capacity

1. Create an Assignment__c record
2. Set Assigned_Inventory__c to the container from Scenario 1
3. Set Total_Capacity_Required__c to 30
4. Expected result:
   - Error message: "The selected inventory container doesn't have enough available capacity for this assignment."

## Considerations

- Validation rules provide immediate feedback at the UI level, while flows handle more complex validations
- Test the interaction between validation rules and flows to ensure they work together properly
- Consider creating custom error messages based on user roles or profiles
- Use validation rules in combination with field-level required settings for complete validation coverage

## Related Implementation Guides

- [Inventory Capacity Fields](./inventory.md) - Implementing the container capacity fields
- [Material Stock Capacity Fields](./stock.md) - Implementing capacity consumption fields
- [Assignment Junction Relationship](./junction.md) - Creating the junction relationship
- [Capacity Management Flows](./flows.md) - Implementing flows for capacity management

## Documentation Consolidation

This guide was created as part of the [Documentation Consolidation Initiative](../../project/consolidation-status.md) (April 3-11, 2025) to consolidate validation rules that were previously scattered across multiple implementation guides. 