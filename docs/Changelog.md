---
layout: default
title: "Changelog"
nav_order: 8
---

# Changelog

This document tracks significant changes to the BoxFresh App documentation and implementations.

## March 27, 2025
- Renamed object 'Schedule__c' to 'Scheduler__c' to better reflect it's utility
## March 26, 2025

### Documentation Updates
- Updated `workflow.md` to incorporate Eliyahu Goldratt's Theory of Constraints principles
- Removed material expiry tracking from core workflows
- Added container capacity management concepts to inventory management
- Refocused on Assignment as a junction object connecting Contract, Inventory, and Resource Unit
- Updated diagrams to represent new relationships defined in schema

### Schema Changes
- Refined inventory object model to emphasize capacity constraints
- Updated Material_Stock relationships to reflect capacity consumption
- Clarified Assignment as the central junction object in the system
- Adjusted Schedule-Assignment relationships for clearer service tracking

## March 25, 2025

### Documentation Additions
- Created initial structure for BoxFresh App documentation
- Added core abstraction documentation:
  - `schema.md`: Object schema description
  - `flows.md`: Data flow documentation
  - `batch.md`: Batch processing patterns
  - `communication.md`: System communication patterns
- Added design pattern documentation:
  - `workflow.md`: Workflow automation patterns
  - `structure.md`: Structured output patterns
  - `agent.md`: Agent-based automation
  - `communication.md`: Customer communication patterns

### Implementation Notes
- Established basic schema structure in Salesforce
- Created foundational objects and relationships
- Implemented initial assignments process flow

## March 22, 2025

### Project Initialization
- Completed Business Requirements Document (BRD)
- Established project structure
- Defined initial object model and relationships
- Created schema diagram draft
- Documented lessons learned from initial project phase

## Upcoming Changes

### Documentation Planned
- New `inventory_management.md` focusing on container capacity
- New `constraint_identification.md` covering bottleneck analysis
- Updated `schema.md` with complete relationship model
- Revised `flows.md` showing optimized data flow

### Implementation Planned
- Capacity limit tracking for Inventory containers
- Buffer management automation for inventory
- Throughput monitoring dashboards
- Constraint identification reports

[Back to ReadMe](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/README.md)

#### 25/03/25
- More additions to the process documentation. Took a break to spruce up on Service Cloud - After the custom inventory schema I'll use the standard service objects.
#### 19/03/25 
- I'm going to start on this repo now, take a break from the building of the app, time is of the essense and I want to be able to showcase the work I've done **so far**.
- Created "start here" folder, uploaded and refined documents from the first batch of logs
- Uploaded and fixed  up the initial docs I drafted. Continued with development of the app
- Uploaded 'latest schema' and began writing the overview
#### 18/03/25
- Polishing up more parts of the overall boxfresh app design.
- 'Custom_Contract' custom object is now broken into modular sub-objects:
  - 'Core Contract', Parent Junction Object; references SLA, obligations, and holds high-level agreement terms
  - 'Order', Child of Core; looks up the planned services, materials, assets. Used to forecast inventory and Resources
  - 'Service Agreement', Child of Core; records specific renewal terms, penalties, service conditions, etc.. specific to the contract.
- This way multiple 'order' and 'service agreement' records can be connected with one 'core contract' as required without confusion.
#### 17/03/25
- Going to transfer Obsidian Notes, screenshots, etc... onto Github to being sharing progress.
