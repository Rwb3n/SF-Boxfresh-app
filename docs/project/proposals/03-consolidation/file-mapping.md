---
layout: default
title: "Documentation File Mapping"
parent: "Project Management"
nav_order: 7
---

# Documentation File Mapping

*Last Updated: April 10, 2025*

This document provides a map of the file migrations carried out during the Documentation Consolidation Initiative. It shows where each documentation file was moved from its original location to its new location within the restructured documentation.

## Completed File Migrations

### Core Files

| Original Location | New Location | Status |
|-------------------|--------------|--------|
| `/docs/core_abstraction/schema.md` | `/docs/overview/schema.md` | ✅ Completed |
| `/docs/design.md` | `/docs/overview/architecture.md` | ✅ Completed |
| N/A (new file) | `/docs/overview/concepts.md` | ✅ Completed |

### Implementation Guides

| Original Location | New Location | Status |
|-------------------|--------------|--------|
| `/docs/implementation/inventory_fields.md` | `/docs/implementation/capacity/inventory.md` | ✅ Completed |
| `/docs/implementation/material_stock_fields.md` | `/docs/implementation/capacity/stock.md` | ✅ Completed |
| `/docs/implementation/assignment_junction.md` | `/docs/implementation/capacity/junction.md` | ✅ Completed |
| `/docs/implementation/capacity_check_flow.md` | `/docs/implementation/capacity/flows.md` (merged) | ✅ Completed |
| `/docs/implementation/container_update_flow.md` | `/docs/implementation/capacity/flows.md` (merged) | ✅ Completed |
| N/A (new file) | `/docs/implementation/capacity/validation.md` | ✅ Completed |

### Project Management

| Original Location | New Location | Status |
|-------------------|--------------|--------|
| `/docs/Status.md` | `/docs/project/status.md` | ✅ Completed |
| `/docs/next-phase/Status.md` | `/docs/project/status.md` (information merged) | ✅ Completed |
| `/docs/Sprint-Plan.md` | `/docs/project/sprints/capacity-sprint.md` | ✅ Completed |
| `/docs/next-phase/Sprint-Plan.md` | `/docs/project/sprints/next-phase-sprint.md` | ✅ Completed |
| `/docs/consolidation/Sprint-Plan.md` | `/docs/project/sprints/consolidation-sprint.md` | ✅ Completed |
| `/docs/Proposal.md` | `/docs/project/proposals/toc-proposal.md` | ✅ Completed |
| `/docs/next-phase/Proposal.md` | `/docs/project/proposals/next-phase-proposal.md` | ✅ Completed |
| `/docs/consolidation/Status.md` | `/docs/project/consolidation-status.md` | ✅ Completed |
| `/docs/consolidation/consolidation-plan.md` | `/docs/project/consolidation-plan.md` | ✅ Completed |
| `/docs/consolidation/file-mapping.md` | `/docs/project/file-mapping.md` | ✅ Completed |

### Design Patterns

| Original Location | New Location | Status |
|-------------------|--------------|--------|
| `/docs/design_pattern/structure.md` | `/docs/reference/patterns/structure.md` | ✅ Completed |
| `/docs/design_pattern/workflow.md` | `/docs/reference/patterns/workflow.md` | ✅ Completed |
| `/docs/design_pattern/communication.md` | `/docs/reference/patterns/communication.md` | ✅ Completed |
| `/docs/design_pattern/agent.md` | `/docs/reference/patterns/agent.md` | ✅ Completed |

### Utility Functions

| Original Location | New Location | Status |
|-------------------|--------------|--------|
| `/docs/utility_function/llm.md` | `/docs/reference/utilities/llm.md` | ✅ Completed |
| `/docs/utility_function/reporting.md` | `/docs/reference/utilities/reporting.md` | ✅ Completed |
| `/docs/utility_function/resources.md` | `/docs/reference/utilities/resources.md` | ✅ Completed |
| `/docs/utility_function/inventory.md` | `/docs/reference/utilities/inventory.md` | ✅ Completed |

## Pruned Directories

After migration, the following directories were pruned:

| Directory | Status | Notes |
|-----------|--------|-------|
| `/docs/design_pattern/` | ✅ Removed | All files migrated to `/docs/reference/patterns/` |
| `/docs/utility_function/` | ✅ Removed | All files migrated to `/docs/reference/utilities/` |
| `/docs/next-phase/` | ✅ Removed | All files migrated to appropriate locations in `/docs/project/` |

## Files Pending Migration/Reconciliation

| Original Location | Planned Destination | Status | Notes |
|-------------------|---------------------|--------|-------|
| `/docs/consolidation/` | `/docs/project/` | 🔄 In Progress | Final files being migrated |
| `/docs/Changelog.md` | `/docs/project/changelog.md` | ⏳ Planned | To be migrated |
| `/docs/Minimal-Consolidation.md` | To be determined | ⏳ Planned | May be deprecated |

## Technical Notes

- All migrated files contain a Documentation Consolidation notice at the bottom indicating their original location
- Files that were merged (like the capacity flows) preserve all unique content from the original files
- Original files contain deprecation notices with links to their new locations
- All migration activities are tracked in the [consolidation status document](consolidation-status.md)

## Documentation Consolidation

*This document was created as part of the Documentation Consolidation Initiative (April 3-11, 2025) based on content from the original `/docs/consolidation/file-mapping.md`.* 