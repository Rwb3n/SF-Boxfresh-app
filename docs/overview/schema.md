---
layout: default
title: "Object Schema"
parent: "Overview"
nav_order: 2
---

# Object Schema

The BoxFresh App is built on a foundation of custom Salesforce objects that model the business domain. The schema is divided into functional groups to organize the different aspects of the business.

<div align="center">
  <img src="https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/19-3-25-latest.png?raw=true" width="600"/>
</div>

## 1. Inventory Objects

Inventory objects manage the materials and supplies used in landscaping services, implementing capacity constraints following Eliyahu Goldratt's Theory of Constraints principles.

### Material_SKU__c

This is the catalog of unique stock items in the inventory.

**Key Fields:**
- `Name`: The SKU identifier
- `Description__c`: Detailed description of the item
- `Unit_of_Measure__c`: How the item is measured (e.g., kg, liter, piece)
- `Unit_Cost__c`: Cost per unit
- `Category__c`: The category of material
- `Capacity_Units_Per_Unit__c`: How many capacity units each unit of this SKU consumes

**Relationships:**
- Has many `Material_Stock__c` records

### Material_Stock__c

Tracks the quantity of each material batch and its capacity consumption.

**Key Fields:**
- `Material_SKU__c`: Lookup to the material catalog
- `Quantity__c`: The amount available
- `Purchase_Date__c`: When the stock was acquired
- `Units_Consumed__c`: How many capacity units this stock consumes in its container
- `Capacity_Status__c`: Current status relative to buffer thresholds

**Relationships:**
- Belongs to one `Material_SKU__c`
- Belongs to one `Inventory__c`

### Inventory__c

Manages storage locations and capacity constraints, representing physical containers.

**Key Fields:**
- `Name`: Identifier for the inventory location
- `Location__c`: Physical location
- `Capacity_Units__c`: Maximum capacity units available in this container
- `Available_Units__c`: Formula field showing remaining capacity
- `Resource_Asset__c`: Lookup to associated resource asset
- `Buffer_Status__c`: Current buffer zone status (Below Buffer/Within Buffer/Above Buffer)
- `Is_Constraint__c`: Boolean indicating if this container is a current system constraint

**Relationships:**
- Has many `Material_Stock__c` records
- Belongs to one `Resource_Asset__c`
- Referenced by many `Assignment__c` records

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
- Has many `Assignment__c` records (Master-Detail)

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

Key junction object linking contracts, resources, and inventory.

**Key Fields:**
- `Order__c`: Related service order
- `Resource_Unit__c`: Assigned resource unit
- `Start_Time__c`: Assignment start time
- `End_Time__c`: Assignment end time
- `Status__c`: Current assignment status
- `Assigned_Inventory__c`: Lookup to inventory container
- `Total_Capacity_Required__c`: Total capacity units needed
- `Capacity_Allocated__c`: Capacity units successfully allocated

**Relationships:**
- Belongs to one `Order__c`
- Belongs to one `Resource_Unit__c`
- Belongs to one `Inventory__c` (Assigned_Inventory__c)
- Child of `Core_Contract__c` (Master-Detail)
- Has many `Schedule__c` records

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
- Has many `Core_Contract__c` records

### Service_Location__c

Represents specific areas within a property.

**Key Fields:**
- `Property__c`: Parent property
- `Name`: Location identifier
- `Type__c`: Location type
- `Size__c`: Location size

**Relationships:**
- Belongs to one `Property__c`

## 5. Schedule Objects

These objects manage the execution of services.

### Schedule__c

Represents a specific scheduled service execution.

**Key Fields:**
- `Assignment__c`: Parent assignment
- `Scheduled_Date__c`: When the service is scheduled
- `Status__c`: Current schedule status
- `Duration__c`: Expected duration
- `Notes__c`: Schedule notes

**Relationships:**
- Belongs to one `Assignment__c`
- Has many `Material_Usage__c` records

### Material_Usage__c

Tracks materials used during service execution.

**Key Fields:**
- `Schedule__c`: Parent schedule
- `Material_Stock__c`: Source material stock
- `Quantity_Used__c`: Amount used
- `Usage_Date__c`: When the material was used

**Relationships:**
- Belongs to one `Schedule__c`
- Belongs to one `Material_Stock__c`

## Documentation Consolidation

This content has been migrated as part of the [Documentation Consolidation Initiative](../consolidation/index.md) (April 3-11, 2025) from its original location at `core_abstraction/schema.md`. 