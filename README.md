# BoxFresh App

A Salesforce-native solution for service scheduling, inventory management, and customer communication, built using Theory of Constraints principles and [Pocket Flow Framework](https://github.com/The-Pocket-World/Pocket-Flow-Framework)'s Design Philosophy.

## Latest Update: Documentation Consolidation Complete (April 11, 2025)
All documentation has been successfully reorganized and consolidated, preparing the project for Phase 2 implementation. The documentation now features improved navigation, streamlined information flow, and consolidated content. See our [Documentation Home](docs/index.md) for complete details.

## Core Documentation

- **Overview**: Core concepts, architecture, and schema
  - [System Architecture](docs/overview/architecture.md)
  - [Object Schema](docs/overview/schema.md)
  - [Core Concepts](docs/overview/concepts.md)

- **Implementation**: Technical guides and documentation
  - [Capacity Management](docs/implementation/capacity/)
  - [Flow Management](docs/implementation/capacity/flows.md)
  - [Validation Rules](docs/implementation/capacity/validation.md)

- **Project Management**: Status and planning
  - [Project Status](docs/project/status.md)
  - [Implementation Proposals](docs/project/proposals/)

## Features & Capabilities

- ✅ Theory of Constraints Implementation
  - Inventory capacity management
  - Buffer tracking
  - Throughput optimization
- ✅ Service Cloud Configuration
  - Custom Case Lifecycle
  - Automated status tracking
- ✅ Flow Automation
  - Resource allocation
  - Capacity management
- ✅ Reports & Dashboards
  - Real-time insights
  - Performance analysis
- ✅ Security Model
  - Custom profiles
  - Permission sets
  - Sharing rules

## Technical Implementation

### Custom Schema
- Custom Objects: Material SKU, Inventory, Custom Contract, Resource, Asset
- Standard Objects: Case, Account, Contact
- Capacity Management: Inventory containers with capacity constraints

### Automation
- Flow Builder: Case Routing, Escalation, Capacity Management
- Approval Processes: Purchase Order Approvals
- Validation Rules: Capacity limits, inventory allocation

### Analytics & Insights
- Inventory Analysis
- Job Completion Rate
- Technician Performance
- Capacity Utilization

## Project Background

BoxFresh Gardens started as a small gardening business that needed better systems for resource management and service delivery. This Salesforce implementation represents a complete rebuild of those systems, focusing on structured automation, resource control, and precision execution.

The project serves two purposes:
1. A practical demonstration of Salesforce administration capabilities
2. A case study in applying Theory of Constraints principles to service business operations

## Current Focus

The project is implementing inventory management based on the Theory of Constraints (TOC), treating inventory containers as capacity-constrained resources to optimize:
- Resource Utilization
- Buffer Management
- Allocation Efficiency

For detailed documentation, please visit our [Documentation Site](docs/index.md). 