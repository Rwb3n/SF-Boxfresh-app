---
layout: default
title: "Next Phase Sprint Plan"
nav_order: 6
---

# Next Phase Sprint Plan

*April 2 - May 6, 2025*

## Sprint Goal

Implement a comprehensive user access, communication, and reporting framework to support the Theory of Constraints (TOC) capacity management system.

## Focus Areas

- User profiles and permission sets for role-based access control
- Case management and communication workflows for constraint issues
- Reports and dashboards for constraint visibility and analysis

## Sprint Backlog

### Sprint 1: Design & Foundation (April 2 - April 15)

| ID | Task | Priority | Effort | Owner | Dependencies |
|----|------|----------|--------|-------|--------------|
| 1.1 | Define permission matrix for all user roles | High | M | Admin | None |
| 1.2 | Document field-level security requirements | High | M | Admin | 1.1 |
| 1.3 | Create base profile specifications | High | M | Admin | 1.1 |
| 1.4 | Document TOC permission set requirements | High | S | Admin | 1.1 |
| 1.5 | Create case process flow diagrams | Medium | M | Analyst | None |
| 1.6 | Define case record types for constraint issues | Medium | S | Analyst | 1.5 |
| 1.7 | Document communication template requirements | Medium | M | Analyst | 1.5 |
| 1.8 | Gather stakeholder reporting requirements | Medium | L | Analyst | None |
| 1.9 | Create dashboard wireframes for key roles | Medium | L | Analyst | 1.8 |
| 1.10 | Develop report specifications for constraint tracking | Medium | M | Analyst | 1.8 |

### Sprint 2: User Security Implementation (April 16 - April 29)

| ID | Task | Priority | Effort | Owner | Dependencies |
|----|------|----------|--------|-------|--------------|
| 2.1 | Create standard user profiles | High | M | Admin | 1.3 |
| 2.2 | Implement field-level security settings | High | L | Admin | 1.2 |
| 2.3 | Build TOC Management permission set | High | M | Admin | 1.4 |
| 2.4 | Build Capacity Viewer permission set | High | M | Admin | 1.4 |
| 2.5 | Build Assignment Manager permission set | High | M | Admin | 1.4 |
| 2.6 | Create case record types | Medium | S | Developer | 1.6 |
| 2.7 | Implement case page layouts by record type | Medium | M | Developer | 2.6 |
| 2.8 | Create email templates for capacity alerts | Medium | M | Developer | 1.7 |
| 2.9 | Build case assignment rules | Medium | M | Developer | 1.5 |
| 2.10 | Create standard TOC reports | Medium | L | Analyst | 1.10 |

### Sprint 3: Automation & Dashboards (April 30 - May 6)

| ID | Task | Priority | Effort | Owner | Dependencies |
|----|------|----------|--------|-------|--------------|
| 3.1 | Build process for automated case creation | High | L | Developer | 2.6 |
| 3.2 | Implement case escalation rules | High | M | Developer | 2.9 |
| 3.3 | Create email alerts for threshold crossings | High | M | Developer | 2.8 |
| 3.4 | Create Inventory Manager dashboard | High | L | Analyst | 2.10 |
| 3.5 | Create Operations Manager dashboard | High | L | Analyst | 2.10 |
| 3.6 | Create Field Technician dashboard | Medium | M | Analyst | 2.10 |
| 3.7 | Build constraint tracking report | Medium | M | Analyst | 2.10 |
| 3.8 | Create capacity trend analysis report | Medium | M | Analyst | 2.10 |
| 3.9 | Implement dashboard refresh schedules | Low | S | Admin | 3.4, 3.5, 3.6 |
| 3.10 | Create user documentation and training materials | High | L | Analyst | All |

## Effort Legend
- S: Small (1-2 days)
- M: Medium (3-5 days)
- L: Large (5-8 days)

## Definition of Done

Sprint deliverables will be considered complete when:

1. **User Access Controls**
   - All custom profiles are created and tested
   - Permission sets are implemented and assigned
   - Field-level security is configured according to requirements
   - Role hierarchy is established
   - Users can access only appropriate capacity management functions

2. **Case Management**
   - Case record types for constraint issues are configured
   - Automated case creation is functioning for threshold violations
   - Email alerts are sending properly
   - Case assignment and escalation rules are working
   - Users can effectively manage constraint-related cases

3. **Reports & Dashboards**
   - Standard TOC reports are available and accurate
   - Role-specific dashboards are accessible to appropriate users
   - Dashboard components correctly display capacity data
   - Trend analysis reports show meaningful patterns
   - Dashboard refresh schedules are appropriate

## Success Metrics

The sprint will be considered successful if:

1. 100% of user roles have appropriate access to TOC functionality
2. Case management process captures and routes 95% of constraint issues correctly
3. Dashboards provide visibility to 100% of system constraints
4. User adoption of dashboards reaches 80% by end of sprint

## Dependencies

- Completion of core capacity management implementation
- Access to test data representing realistic inventory scenarios
- Stakeholder availability for reporting requirements and dashboard reviews

## Risk Management

| Risk | Mitigation |
|------|------------|
| User resistance to new security model | Early involvement in design, focused training |
| Case volume overwhelming users | Carefully designed filters and views, clear escalation paths |
| Dashboard performance issues | Optimize report structure, consider summary tables |
| Complexity of permission model | Favor permission sets over custom profiles |

## Sprint Review Schedule

- Sprint 1 Review: April 15, 2025
- Sprint 2 Review: April 29, 2025
- Sprint 3 Review: May 6, 2025 