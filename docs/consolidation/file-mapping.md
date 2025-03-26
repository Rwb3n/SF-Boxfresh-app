---
layout: default
title: "File Mapping"
parent: "Documentation Consolidation"
nav_order: 4
---

> **DEPRECATION NOTICE**: This document has been moved to [Documentation File Mapping](../project/file-mapping.md) as part of the Documentation Consolidation Initiative. Please update your bookmarks.
{: .warning }

# File Mapping Plan

*Last Updated: April 3, 2025*

This document outlines the file mapping plan for the documentation consolidation effort, showing which files will be moved from their current location to their new location within the restructured documentation.

## Core Files

| Current Location | New Location | Status |
|------------------|--------------|--------|
| `core_abstraction/schema.md` | `overview/schema.md` | Pending |
| `design.md` | `overview/architecture.md` | Pending |

## Implementation Guides

| Current Location | New Location | Status |
|------------------|--------------|--------|
| `implementation/inventory_fields.md` | `implementation/capacity/inventory.md` | Pending |
| `implementation/material_stock_fields.md` | `implementation/capacity/stock.md` | Pending |
| `implementation/assignment_junction.md` | `implementation/capacity/junction.md` | Pending |
| `implementation/capacity_check_flow.md` | `implementation/capacity/flows.md` (merge) | Pending |
| `implementation/container_update_flow.md` | `implementation/capacity/flows.md` (merge) | Pending |
| N/A (new file) | `implementation/capacity/validation.md` | Pending |

## Project Management

| Current Location | New Location | Status |
|------------------|--------------|--------|
| `Status.md` | `project/status.md` | Pending |
| `N/A (new file)` | `project/roadmap.md` | Pending |
| `Sprint-Plan.md` | `project/sprints/capacity-sprint.md` | Pending |
| `next-phase/Sprint-Plan.md` | `project/sprints/next-phase-sprint.md` | Pending |
| `Proposal.md` | `project/proposals/toc-proposal.md` | Pending |
| `next-phase/Proposal.md` | `project/proposals/next-phase-proposal.md` | Pending |

## Design Patterns

| Current Location | New Location | Status |
|------------------|--------------|--------|
| `design_pattern/workflow.md` | `reference/patterns/workflow.md` | Pending |
| `design_pattern/structure.md` | `reference/patterns/structure.md` | Pending |
| `design_pattern/communication.md` | `reference/patterns/communication.md` | Pending |
| `design_pattern/agent.md` | `reference/patterns/agent.md` | Pending |

## Utility Functions

| Current Location | New Location | Status |
|------------------|--------------|--------|
| `utility_function/llm.md` | `reference/utilities/llm.md` | Pending |
| `utility_function/reporting.md` | `reference/utilities/reporting.md` | Pending |
| `utility_function/resources.md` | `reference/utilities/resources.md` | Pending |
| `utility_function/inventory.md` | `reference/utilities/inventory.md` | Pending |

## Files to be Deprecated

After consolidation is complete and content has been migrated:

| File | Reason | Status |
|------|--------|--------|
| `Minimal-Consolidation.md` | Superseded by the consolidation initiative | Pending |
| `Changelog.md` | Content will be merged into roadmap | Pending |
| `core_abstraction/communication.md` | Content will be merged with design_pattern/communication.md | Pending |
| `core_abstraction/flows.md` | Content will be merged with implementation/capacity/flows.md | Pending |
| `core_abstraction/batch.md` | Content will be migrated to utilities | Pending |

## Implementation Plan

1. **Copy Phase**: 
   - First, copy all files to their new location
   - Update internal links in the copied files

2. **Testing Phase**:
   - Verify all new files are accessible
   - Check all internal links work correctly

3. **Deprecation Phase**:
   - Add deprecation notices to original files directing to new locations
   - Eventually remove deprecated files once all references are updated

## Mapping Principles

- Files are moved based on their primary function and content
- Implementation-specific content is moved to the implementation directory
- Reference material that spans multiple implementations is moved to reference
- Project management content is consolidated in the project directory
- High-level architecture and schema information is moved to overview 