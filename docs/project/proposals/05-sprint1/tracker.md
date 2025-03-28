---
layout: default
title: "Implementation Tracker"
parent: "Sprint1: Complete Schema Implementation"
grand_parent: "Project Proposals"
nav_order: 2
---

# Implementation Tracker

This document tracks the progress of the BoxFresh App schema implementation in our developer org.

## Object Implementation Status

| Object                   | Object Created | Fields Added | Relationships Configured | Page Layout | Status      | Notes                                                       |
| ------------------------ | -------------- | ------------ | ------------------------ | ----------- | ----------- | ----------------------------------------------------------- |
| **Material_Category__c** | - [x ]         | - [x ]       | - [ x]                   | - [ ]       | Not Started | is a lookup for material SKU & material budget              |
| **Material_SKU__c**      | - [x ]         | - [ x]       | - [x ]                   | - [ ]       | Not Started | **material_sku**lookup** changed to **material_sku_source** |
| **Material_Stock__c**    | - [ x]         | - [ x]       | - [x ]                   | - [ ]       | Not Started | added extra fields (see changes section)                    |
| **Inventory__c**         | - [ x]         | - [x ]       | - [ x]                   | - [ ]       | Not Started |                                                             |
| **Material_Budget__c**   | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Resource__c**          | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Resource_Asset__c**    | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Resource_Unit__c**     | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Core_Contract__c**     | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Order__c**             | - [x ]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Service_Agreement__c** | - [x ]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Assignment__c**        | - [x ]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Property__c**          | - [x ]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Service_Location__c**  | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Schedule__c**          | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
| **Material_Usage__c**    | - [ x]         | - [ ]        | - [ ]                    | - [ ]       | Not Started |                                                             |
## Changes

- Added **Resource_Gear__c** - to segregate assets such as physical space and vehicle records with equipment and tools and uniform because these have very different field requirements. scheduled blitz stand up to realign.
	- added lookup to **resource-unit**

- changed **service_agreement__c** - changed to service_agreement_core and added **resource_budget__c** and **service_agreement_element__c** child objects

- removed **property** as that is the same as **service location__c**

- **material_stock** has various additions added to it: 
	- **received_date(date):** date that the stock unit actually arrived at the inventory location
	- material sku category(formula): for reference of the category, to use for reporting? ==advise please==
	- **days since received** for future calculations; (TODAY() -  (date_received__c))
	- **budget source**(lookup): used to connect material unit records (in this case the budget) 
		- which means relationship for **material_stock:material_budget** = **many:1**
	- **material stock ID**: I decided we want a unique ID code, INV-{0000}
	- **quantity_remaining**(formula): for easy reference of total-used=remaining
	- **status**: A time based status tracker, to be used for a path, which i think would be a cool visual indicator, list includes: 
		- **Planned** (when a record is created created, no physical existence)
		- **Requested** (added to order queue)
		- **Ordered** (purchase order submitted)
		- **Received** (physically present)
		- **Allocated** (assigned to specific schedule)
		- **Consumed** (used in operations)
		- **Expired** (past shelf life)
		- **Damaged** (unusable condition)
	- **status change date**(date): to track when the status changed last.
	- **capacity_units** changed to **maximum capacity**
	- **available units** changed to **available capacity**
	- added **assignment status**: inactive, active, pending transfer (i.e the instance, with it's stock units, being moved to a different resource_asset).

- **Inventory_c**: made some adaptations and changes
	- removed **location_c** as **resource_asset_c** will be the lookup to the location this inventory is instanced in. changing the lookup to have description detailing this.


## Future Considerations

- **material_category** & **material_sku** both have their own unit of measure. reason is because material category is used to measure the quantity of materials in the material_budget. should there be a unit of measure normaliser function? why i ask: let's say the budget requires 2000 kg ( 2 ton ) of compost. I will buy a 1000kg (1 ton ) load, they arrives loose via lorry. The next 1 ton however will be interspersed in separate small bags of compost which have a different unit of measure -- litres -- so there needs to be a function that approximates, let's say 100 litres to kg which then allows us to account the usage vs budget in the same unit of measurement.

- **Big Lesson Learned:** In the future, for any other custom apps, or even objects. Add up to 3 letter prefix. **Why?** Because I wanted to change **Resource Asset** to **Asset**, but of course Asset is a standard object name already, which makes sense for a platform like salesforce. What I shouldve done from the start was to have **bf_** at the start of all objects i created - i.e: **bf_Asset__c**, or **bf_Assignment__c** or **bf_Inventory__c**. You live and you learn.


## Validation Rules Implementation Status

| Object | Validation Rule | Implemented | Tested | Status | Notes |
|--------|----------------|------------|--------|--------|-------|
| **Material_Usage__c** | Prevent Over-Allocation | - [ ] | - [ ] | Not Started | |
| **Material_Usage__c** | Prevent Zero/Negative Usage | - [ ] | - [ ] | Not Started | |
| **Material_Usage__c** | Prevent Usage After Schedule Completion | - [ ] | - [ ] | Not Started | |
| **Material_Stock__c** | Prevent Negative Stock | - [ ] | - [ ] | Not Started | |
| **Material_Budget__c** | Ensure Budget Period Validity | - [ ] | - [ ] | Not Started | |
| **Material_Budget__c** | Prevent Negative Budget | - [ ] | - [ ] | Not Started | |

## Formula Fields Implementation Status

| Object                | Formula Field      | Implemented | Tested | Status      | Notes |
| --------------------- | ------------------ | ----------- | ------ | ----------- | ----- |
| **Material_Stock__c** | Units_Consumed__c  | - [ ]       | - [ ]  | Not Started |       |
| **Inventory__c**      | Available_Units__c | - [ ]       | - [ ]  | Not Started |       |
| **Inventory__c**      | Buffer_Status__c   | - [ ]       | - [ ]  | Not Started |       |

## Roll-Up Summary Fields Implementation Status

| Object | Roll-Up Summary Field | Implemented | Tested | Status | Notes |
|--------|----------------------|------------|--------|--------|-------|
| **Material_Category__c** | Total_SKUs_in_Category__c | - [ ] | - [ ] | Not Started | |

## Test Data Creation Status

| Data Type | Created | Verified | Status | Notes |
|-----------|---------|----------|--------|-------|
| Material Categories | - [ ] | - [ ] | Not Started | |
| Material SKUs | - [ ] | - [ ] | Not Started | |
| Material Stock | - [ ] | - [ ] | Not Started | |
| Resources & Assets | - [ ] | - [ ] | Not Started | |
| Contracts & Orders | - [ ] | - [ ] | Not Started | |
| Assignments & Schedules | - [ ] | - [ ] | Not Started | |
| Material Budgets | - [ ] | - [ ] | Not Started | |
| Material Usage | - [ ] | - [ ] | Not Started | |

## Implementation Notes

- **Date Started:** 28/03/2025
- **Current Phase:** Setup
- **Blockers:** None currently identified
- **Next Steps:** Begin implementation of foundation objects