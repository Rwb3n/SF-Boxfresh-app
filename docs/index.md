---
layout: default
title: "Home"
nav_order: 1
---

# BoxFresh App Documentation

**Current Initiative: [Documentation Consolidation](consolidation/index.md) (April 3-11, 2025)**

Welcome to the BoxFresh App documentation! This site contains comprehensive information about the BoxFresh application, a Salesforce-native solution for service scheduling and inventory management.

## Documentation Sections

### [Overview](overview/index.md)
Understanding the core concepts and architecture of the BoxFresh App.
- [System Architecture](overview/architecture.md)
- [Object Schema](overview/schema.md)
- [Core Concepts](overview/concepts.md)

### [Implementation Guides](implementation/index.md)
Step-by-step instructions for implementing and configuring the BoxFresh App.
- **Capacity Management** - Instructions for setting up inventory, stock, and assignment management
- **User Access** - Configuration guides for security and permissions
- **Cases** - Setup for customer case management
- **Reporting** - Implementation of standard and custom reports
- **Future Implementations** - Planned expansion areas

### [Project Documentation](project/index.md)
Information related to the project management of the BoxFresh App.
- **Sprint Plans** - Current and past sprint documentation
- **Proposals** - Feature proposals and specification documents
- Current implementation status

### [Reference Documentation](reference/index.md)
Technical reference materials for the BoxFresh App.
- **Patterns** - Design patterns used in the application
- **Utilities** - Utility functions and tools

## Documentation Updates

The documentation site is undergoing a comprehensive reorganization as part of our [Documentation Consolidation Initiative](consolidation/index.md). Key improvements include:

- **Improved Navigation Structure** - Logical grouping of related documentation
- **Streamlined Information Flow** - Better progression from concepts to implementation
- **Consolidated Content** - Reduced duplication and centralized information
- **Gap Analysis** - Identification and filling of documentation gaps

See the [consolidation progress](consolidation/progress.md) for the current status of this effort.

## Getting Started

New to BoxFresh? Start with these key documents:

1. [Core Concepts](overview/concepts.md) - Understand the Theory of Constraints approach
2. [System Architecture](overview/architecture.md) - Learn about system design
3. [Object Schema](overview/schema.md) - Explore the data model

## Recently Updated

- **April 5, 2025**: Added core overview documents (Architecture, Schema, Concepts) and capacity implementation guides ([Inventory](implementation/capacity/inventory.md), [Stock](implementation/capacity/stock.md), [Junction](implementation/capacity/junction.md))
- **April 4, 2025**: Created directory structure and organizational framework
- **April 3, 2025**: Launched Documentation Consolidation Initiative

## Current Focus: Theory of Constraints Implementation

The BoxFresh App is currently implementing inventory management based on the Theory of Constraints (TOC), treating inventory containers as capacity-constrained resources. This approach improves:

- **Resource Utilization**: Optimizing the use of containers and materials
- **Buffer Management**: Maintaining appropriate capacity buffers
- **Allocation Efficiency**: Ensuring materials are allocated where needed most

## Documentation Consolidation Initiative

**April 3-11, 2025**: We are currently undergoing a documentation consolidation initiative to improve organization and navigation.

**Progress Update (April 4)**: The directory structure and navigation framework have been completed. Content migration will begin on April 5. During this period:

- All documentation remains accessible via the existing links
- Some content will be gradually moved to new locations
- Links will be updated to point to the new structure

See the [Documentation Consolidation](consolidation/) section for details on this effort.

## Recent Updates

- **April 4, 2025**: Completed directory structure and navigation for doc consolidation
- **April 3, 2025**: Documentation consolidation initiative launched
- **March 27, 2025**: Completed sprint planning for TOC implementation
- **March 25, 2025**: Added capacity fields to inventory schema

## Previous Update: Theory of Constraints Implementation

The BoxFresh App has implemented Eliyahu Goldratt's Theory of Constraints principles for inventory management, treating inventory containers as capacity-constrained resources, with the Assignment object serving as a central junction between contracts, inventory, and resources.

## Core Documentation

- [Object Schema](./core_abstraction/schema.md) - Object model definitions with capacity tracking fields
- [Flow Management](./core_abstraction/flows.md) - Data flow through the system
- [Communication](./core_abstraction/communication.md) - Communication patterns
- [Batch Processing](./core_abstraction/batch.md) - Handling large data volumes

## Design Patterns

- [Workflow Automation](./design_pattern/workflow.md) - Constraint-based workflow automation
- [Structure](./design_pattern/structure.md) - Structured data patterns
- [Communication](./design_pattern/communication.md) - Customer communication patterns
- [Agent](./design_pattern/agent.md) - Agent-based automation

## Implementation Guides

- [Inventory Capacity Fields](./implementation/inventory_fields.md) - Implementing Inventory__c capacity fields
- [Material Stock Capacity Fields](./implementation/material_stock_fields.md) - Implementing Material_Stock__c capacity fields
- [Assignment Junction Relationship](./implementation/assignment_junction.md) - Enhancing Assignment__c as a junction object
- [Capacity Check Flow](./implementation/capacity_check_flow.md) - Implementing capacity validation flows
- [Container Update Flow](./implementation/container_update_flow.md) - Implementing container update automation

## Project Management

- [Changelog](./Changelog.md) - Recent and upcoming changes
- [Implementation Proposal](./Proposal.md) - TOC implementation proposal
- [Project Status](./Status.md) - Current project status
- [Sprint Plan](./Sprint-Plan.md) - Current sprint plan
- [Documentation Consolidation](./consolidation/index.md) - Documentation restructuring initiative
- [Next Phase Planning](./next-phase/Proposal.md) - Planning for user access, cases, and reporting

## Additional Resources

- [GitHub Repository](https://github.com/Rwb3n/SF-Boxfresh-app)
- [Implementation Guide](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/03_real-build/01_mid-way_model.md) 