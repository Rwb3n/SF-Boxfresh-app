---
layout: default
title: "Core Concepts"
parent: "Overview"
nav_order: 3
---

# Core Concepts

This document outlines the fundamental concepts underlying the BoxFresh app's implementation of the Theory of Constraints (TOC) for inventory management.

## Theory of Constraints

The BoxFresh app implements Eliyahu Goldratt's Theory of Constraints (TOC) for inventory management. TOC is a methodology for identifying the most important limiting factor (constraint) that stands in the way of achieving a goal and then systematically improving that constraint until it is no longer the limiting factor.

### Key TOC Principles

1. **Identify the Constraint**: Locate the bottleneck in the system that limits overall throughput
2. **Exploit the Constraint**: Make the most efficient use of the constraint without major changes
3. **Subordinate Everything Else**: Adjust all other activities to support maximum effectiveness of the constraint
4. **Elevate the Constraint**: If necessary, make major changes to break the constraint
5. **Repeat the Process**: Once a constraint is broken, identify the next constraint and repeat

## Constraint-Based Inventory Management

In the BoxFresh app, inventory containers are treated as capacity-constrained resources. The system tracks:

1. **Container Capacity**: Each inventory container (Inventory__c) has a maximum capacity measured in capacity units
2. **Material Consumption**: Each material stock item (Material_Stock__c) consumes a portion of its container's capacity
3. **Buffer Management**: The system maintains buffer zones to prevent constraints from impacting service delivery

### Buffer Management

The BoxFresh app uses a three-zone buffer system:

<div align="center">
  <img src="https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/buffer-zones.png?raw=true" width="400"/>
</div>

- **Red Zone (0-30%)**: Danger zone indicating critical capacity shortage
- **Yellow Zone (31-70%)**: Buffer zone providing optimal protection against disruptions
- **Green Zone (71-100%)**: Excess capacity that may indicate inefficient resource allocation

The buffer status for each container is tracked in the `Buffer_Status__c` field on the Inventory__c object.

## Junction-Based Resource Allocation

The Assignment__c object serves as a central junction between:

1. **Contracts**: Core_Contract__c and Order__c objects representing customer agreements
2. **Resources**: Resource_Unit__c and Resource__c objects representing service delivery resources
3. **Inventory**: Inventory__c and Material_Stock__c objects representing available materials

<div align="center">
  <img src="https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/junction-model.png?raw=true" width="500"/>
</div>

## Capacity Check Flow

When an assignment is created or modified, the Capacity Check Flow validates whether the necessary inventory capacity is available:

1. **Capacity Requirement Calculation**: Determines how much container capacity the assignment needs
2. **Availability Check**: Verifies if the requested capacity can be allocated from the assigned container
3. **Buffer Impact Assessment**: Evaluates how the allocation will impact the container's buffer status
4. **Assignment Status Update**: Updates the assignment's status based on the capacity check results

## Application in BoxFresh Operations

The TOC implementation helps BoxFresh Gardens optimize operations by:

1. **Identifying Bottlenecks**: Clearly showing which inventory containers are constraints
2. **Prioritizing Resources**: Ensuring critical materials are available for high-priority jobs
3. **Proactive Management**: Using buffer status to anticipate and prevent capacity issues
4. **Continuous Improvement**: Regularly re-evaluating constraints and elevating them

## Documentation Consolidation

This document was created as part of the [Documentation Consolidation Initiative](../consolidation/index.md) (April 3-11, 2025) to document core Theory of Constraints concepts applied in the BoxFresh app. 