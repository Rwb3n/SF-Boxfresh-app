---
layout: default
title: "Documentation Consolidation Plan"
parent: "Documentation Consolidation"
nav_order: 3
---

> **DEPRECATION NOTICE**: This document has been moved to [Documentation Consolidation Plan](../project/consolidation-plan.md) as part of the Documentation Consolidation Initiative. Please update your bookmarks.
{: .warning }

# Documentation Consolidation Plan

*Last Updated: April 4, 2025*

## Overview

The BoxFresh app documentation is being consolidated and restructured to improve organization, accessibility, and maintainability. This document outlines the plan for this consolidation effort.

## Progress Update

**April 4, 2025**: The planning phase and directory structure setup are now complete. All index files have been created, establishing the navigation hierarchy for the documentation. The next phase is content migration, which will begin on April 5, 2025.

## Goals

1. **Improve Navigation**: Create a logical hierarchy with consistent navigation
2. **Enhance Discoverability**: Make it easier to find relevant documentation
3. **Standardize Format**: Ensure consistent formatting and structure across all docs
4. **Reduce Duplication**: Identify and merge duplicate content
5. **Close Gaps**: Identify and fill documentation gaps

## New Documentation Structure

The documentation has been reorganized into the following structure:

```
docs/
├── index.md                  # Home page and main navigation
├── overview/                 # High-level project overview
│   ├── index.md              # Section navigation
│   ├── architecture.md       # System architecture
│   ├── schema.md             # Object schema
│   └── concepts.md           # Core concepts
├── implementation/           # Implementation guides
│   ├── index.md              # Section navigation
│   ├── capacity/             # Capacity management implementation
│   │   ├── index.md          # Subsection navigation
│   │   ├── inventory.md      # Inventory capacity fields
│   │   ├── stock.md          # Material stock capacity fields
│   │   ├── junction.md       # Assignment junction implementation
│   │   ├── flows.md          # Capacity management flows
│   │   └── validation.md     # Validation rules
│   ├── security/             # Security implementation
│   │   └── index.md          # Security implementation overview
│   ├── cases/                # Case management implementation
│   │   └── index.md          # Case management implementation overview
│   ├── reporting/            # Reporting implementation
│   │   └── index.md          # Reporting implementation overview
│   └── future/               # Future implementation areas
│       └── index.md          # Placeholder for future areas
├── project/                  # Project management
│   ├── index.md              # Section navigation
│   ├── status.md             # Current project status
│   ├── roadmap.md            # Project roadmap
│   ├── sprints/              # Sprint plans
│   │   ├── index.md          # Sprint plans overview
│   │   ├── capacity-sprint.md
│   │   └── next-phase-sprint.md
│   └── proposals/            # Implementation proposals
│       ├── index.md          # Implementation proposals overview
│       ├── toc-proposal.md
│       └── next-phase-proposal.md
├── reference/                # Reference documentation
│   ├── index.md              # Section navigation
│   ├── patterns/             # Design patterns
│   │   ├── index.md          # Design patterns overview
│   │   ├── workflow.md
│   │   ├── structure.md
│   │   ├── communication.md
│   │   └── agent.md
│   └── utilities/            # Utility functions
│       ├── index.md          # Utility functions overview
│       ├── reporting.md
│       ├── resources.md
│       └── inventory.md
└── consolidation/            # Consolidation documentation
    ├── index.md              # Consolidation overview
    ├── consolidation-plan.md # This document
    ├── file-mapping.md       # File mapping plan
    └── progress.md           # Consolidation progress tracking
```

## Timeline

| Date | Milestone | Tasks | Status |
|------|-----------|-------|--------|
| April 3, 2025 | Planning | Create consolidation plan<br>Create file mapping<br>Set up directory structure | ✅ Completed |
| April 4, 2025 | Index Files | Create index.md files for each section<br>Set up navigation hierarchy | ✅ Completed |
| April 5-7, 2025 | Content Migration | Copy files to new locations<br>Update internal links | ⏳ Not Started |
| April 8, 2025 | Content Review | Review all migrated content<br>Standardize formatting | ⏳ Not Started |
| April 9, 2025 | Gap Analysis | Identify missing documentation<br>Create placeholder files | ⏳ Not Started |
| April 10, 2025 | Deprecation | Add deprecation notices to original files | ⏳ Not Started |
| April 11, 2025 | Final Review | Final review of consolidated documentation<br>Update references in code | ⏳ Not Started |

## Task Assignment

| Task | Description | Assigned To | Due Date | Status |
|------|-------------|-------------|----------|--------|
| Create Directory Structure | Set up new directory hierarchy | Documentation Team | April 3, 2025 | ✅ Completed |
| Create Index Files | Create navigation index files for each section | Documentation Team | April 4, 2025 | ✅ Completed |
| Migrate Core Files | Move schema.md and design.md to overview section | Documentation Team | April 5, 2025 | ⏳ Not Started |
| Migrate Implementation Guides | Move implementation guides to capacity section | Implementation Team | April 6, 2025 | ⏳ Not Started |
| Migrate Project Files | Move status and sprint plans to project section | Project Management | April 7, 2025 | ⏳ Not Started |
| Migrate Reference Files | Move design patterns and utility docs to reference | Documentation Team | April 7, 2025 | ⏳ Not Started |
| Review & Standardize | Review all content for consistency and standards | All Teams | April 8, 2025 | ⏳ Not Started |
| Update Internal Links | Fix links between documents in the new structure | Documentation Team | April 9, 2025 | ⏳ Not Started |
| Add Deprecation Notices | Mark original files with deprecation notices | Documentation Team | April 10, 2025 | ⏳ Not Started |
| Final Validation | Verify all docs are accessible and correctly linked | Project Management | April 11, 2025 | ⏳ Not Started |

## Next Steps

1. Begin content migration according to the file mapping plan (April 5)
2. Start with core files (schema.md and architecture.md) in the overview section
3. Continue with implementation guides, focusing on capacity implementation
4. Track progress in the [Consolidation Progress](progress.md) document

## References

- [File Mapping Plan](file-mapping.md)
- [Consolidation Progress](progress.md) 