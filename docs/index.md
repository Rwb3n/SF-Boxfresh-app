---
layout: default
title: "Home"
nav_order: 1
---

# BoxFresh App Documentation

Welcome to the BoxFresh App documentation. This guide provides comprehensive information about the app's architecture, implementation patterns, and utility functions.

## Latest Update: Documentation Consolidation Initiative

The BoxFresh App documentation is undergoing a consolidation effort (April 3-11, 2025) to improve navigation, reduce redundancy, and enhance the overall documentation experience. During this period, all documentation remains accessible, but you may encounter "Work in Progress" notifications on documents being updated.

See the [Documentation Consolidation Initiative](./consolidation/index.md) for more details.

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