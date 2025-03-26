---
layout: default
title: "Material Stock Capacity Fields"
parent: "Implementation Guides"
nav_order: 2
---

# Material Stock Capacity Fields Implementation Guide

This guide provides detailed specifications for implementing the capacity consumption fields on the Material_Stock__c object to support the Theory of Constraints approach.

## Field Specifications

### Material_Stock__c Object

| Field Label | API Name | Data Type | Description | Formula | Default Value |
|-------------|----------|-----------|-------------|---------|---------------|
| Units Consumed | Units_Consumed__c | Number(18, 2) | Capacity units consumed by this stock | N/A | 0 |
| Capacity Status | Capacity_Status__c | Formula (Text) | Status relative to buffer thresholds | Based on parent container's buffer status | N/A |
| Units Per Quantity | Units_Per_Quantity__c | Number(18, 2) | Capacity units consumed per unit of quantity | N/A | 1 |
| Total Capacity Required | Total_Capacity_Required__c | Formula (Number) | Total capacity required for this stock | Quantity__c * Units_Per_Quantity__c | N/A |
| Buffer Priority | Buffer_Priority__c | Picklist | Priority for buffer management | N/A | "Normal" |

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
   - **Label**: Adjust Capacity
   - **Name**: Adjust_Capacity
   - **Include standard fields**: Units_Consumed__c, Units_Per_Quantity__c
   - **Success Message**: "Capacity consumption updated successfully"

## Testing Steps

Once implemented, verify the following:

1. Create a new Material_Stock__c record with:
   - Quantity__c = 10
   - Units_Per_Quantity__c = 2
2. Verify that:
   - Total_Capacity_Required__c calculates to 20
   - Units_Consumed__c can be manually set to match the required capacity
   - The validation rule prevents setting Units_Consumed__c to a value that would exceed container capacity
   - Capacity_Status__c reflects the parent container's buffer status

## Additional Workflows

### Automatic Units Consumed Update

To keep Units_Consumed__c in sync with Total_Capacity_Required__c:

1. Create a Flow that updates Units_Consumed__c whenever Quantity__c or Units_Per_Quantity__c changes
2. Trigger the flow when a Material_Stock__c record is created or updated
3. Use the following logic:
   ```
   UPDATE Material_Stock__c
   SET Units_Consumed__c = Quantity__c * Units_Per_Quantity__c
   WHERE Id = [record ID]
   ```

## Considerations

- Units_Consumed__c is manually adjustable to account for special cases where consumption doesn't directly correlate with quantity
- Material_Stock__c records directly impact container capacity through the roll-up relationship
- Consider creating a process to regularly review and optimize storage based on Buffer_Priority__c
- Ensure units of measurement are consistently applied across all materials 