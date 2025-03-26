---
layout: default
title: "Object Schema"
parent: "Core Abstraction"
nav_order: 1
---

# Object Schema

The BoxFresh App is built on a foundation of custom Salesforce objects that model the business domain. The schema is divided into functional groups to organize the different aspects of the business.

<div align="center">
  <img src="https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/19-3-25-latest.png?raw=true" width="600"/>
</div>

## 1. Inventory Objects

Inventory objects manage the materials and supplies used in landscaping services.

### Material_SKU__c

This is the catalog of unique stock items in the inventory.

**Key Fields:**
- `Name`: The SKU identifier
- `Description__c`: Detailed description of the item
- `Unit_of_Measure__c`: How the item is measured (e.g., kg, liter, piece)
- `Unit_Cost__c`: Cost per unit
- `Category__c`: The category of material

**Relationships:**
- Has many `Material_Stock__c` records

### Material_Stock__c

Tracks the quantity of each material batch.

**Key Fields:**
- `Material_SKU__c`: Lookup to the material catalog
- `Quantity__c`: The amount available
- `Purchase_Date__c`: When the stock was acquired
- `Expiration_Date__c`: When the stock expires (if applicable)

**Relationships:**
- Belongs to one `Material_SKU__c`
- Belongs to one `Inventory__c`

### Inventory__c

Manages storage locations and capacity limits.

**Key Fields:**
- `Name`: Identifier for the inventory location
- `Location__c`: Physical location
- `Capacity__c`: Maximum storage capacity
- `Resource_Asset__c`: Lookup to associated resource asset

**Relationships:**
- Has many `Material_Stock__c` records
- Belongs to one `Resource_Asset__c`

## 2. Resource & Asset Objects

These objects manage the staff, equipment, and other resources needed for service delivery.

### Resource__c

Represents a person who performs services.

**Key Fields:**
- `Name`: Resource identifier
- `Type__c`: Type of resource (Staff, Contractor)
- `Skill_Set__c`: Multi-select picklist of skills
- `Availability_Start__c`: Daily availability start time
- `Availability_End__c`: Daily availability end time

**Relationships:**
- Has many `Assignment__c` records
- Belongs to many `Resource_Unit__c` records

### Resource_Asset__c

Represents equipment, vehicles, or other physical assets.

**Key Fields:**
- `Name`: Asset identifier
- `Type__c`: Type of asset
- `Has_Storage__c`: Whether the asset can store inventory
- `Status__c`: Current status (Available, In Use, Maintenance)

**Relationships:**
- Has one `Inventory__c` (if `Has_Storage__c` is true)
- Belongs to many `Resource_Unit__c` records

### Resource_Unit__c

Groups resources and assets into functional units.

**Key Fields:**
- `Name`: Unit identifier
- `Capacity__c`: Maximum number of assignments per day

**Relationships:**
- Has many `Resource__c` records
- Has many `Resource_Asset__c` records
- Has many `Assignment__c` records

## 3. Contract & Job Objects

These objects manage customer agreements and service execution.

### Core_Contract__c

Represents the master agreement with a customer.

**Key Fields:**
- `Name`: Contract identifier
- `Account__c`: Customer account
- `Start_Date__c`: Contract start date
- `End_Date__c`: Contract end date
- `Status__c`: Current contract status

**Relationships:**
- Belongs to one `Account` (standard object)
- Has many `Order__c` records
- Has many `Service_Agreement__c` records

### Order__c

Represents a specific service order under a contract.

**Key Fields:**
- `Core_Contract__c`: Parent contract
- `Service_Date__c`: Scheduled service date
- `Status__c`: Current order status
- `Total_Amount__c`: Order total

**Relationships:**
- Belongs to one `Core_Contract__c`
- Has many `Assignment__c` records

### Service_Agreement__c

Details specific terms and conditions of the contract.

**Key Fields:**
- `Core_Contract__c`: Parent contract
- `Type__c`: Type of agreement
- `Terms__c`: Detailed terms

**Relationships:**
- Belongs to one `Core_Contract__c`

### Assignment__c

Links resources to specific jobs/orders.

**Key Fields:**
- `Order__c`: Related service order
- `Resource_Unit__c`: Assigned resource unit
- `Start_Time__c`: Assignment start time
- `End_Time__c`: Assignment end time
- `Status__c`: Current assignment status

**Relationships:**
- Belongs to one `Order__c`
- Belongs to one `Resource_Unit__c`

## 4. Property & Location Objects

These objects manage the service locations and properties.

### Property__c

Represents a physical location where services are performed.

**Key Fields:**
- `Name`: Property identifier
- `Account__c`: Customer account
- `Address__c`: Physical address
- `Size__c`: Property size
- `Type__c`: Property type

**Relationships:**
- Belongs to one `Account` (standard object)
- Has many `Service_Location__c` records

### Service_Location__c

Represents specific areas within a property.

**Key Fields:**
- `Property__c`: Parent property
- `Name`: Location identifier
- `Type__c`: Location type
- `Size__c`: Location size

**Relationships:**
- Belongs to one `Property__c` 