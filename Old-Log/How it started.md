# How It Started: The BoxFresh App Journey

## Introduction & Motivation

The BoxFresh App began as a response to the need for efficient service scheduling and inventory management within BoxFresh Gardens, my old business.

The goal was to create a Salesforce-native solution that would optimize resource utilization, streamline operations, and provide robust support for both field staff and management.

This was something I always aspired to, but before Salesforce, I struggled with it due to the fragmentation of tools.

Early on, it became clear that basing the app around inventory systems was important.

## Early Vision & Conceptualization

The project adopted Eliyahu Goldratt's Theory of Constraints (TOC) as its guiding methodology.

I set out to practice identifying operational bottlenecks, optimize inventory flows, and ensure that critical resources were always available where needed most.

This approach was not only an attempt to improve efficiency but also a proactive stance on material management and resource allocation.

## Initial Data Model & Architecture

The first phase focused on designing a data model that I thought reflected the operations.

Early schema diagrams were complicated and convoluted. I tried to capture all the relationships between inventory containers, material stock, assignments, contracts, and resources.

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-19%20first_data_model.png

As the model evolved, complexity increased even more to accommodate real-world scenarios.

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-19%20complex_schema_1.png

## Prototyping & UI Drafts

Parallel to data modeling, I developed UI prototypes to visualize user flows. These drafts helped clarify requirements and informed iterative improvements.

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-21%20draft_ui_director_dashboard.png

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-21%20draft_ui_service_completion.png

## Implementation Milestones

Key milestones included:
- Implementing capacity fields and buffer management on Inventory and Material Stock objects
- Establishing the Assignment object as a junction for contracts, resources, and inventory
- Building validation and error handling flows

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-04-16%20latest_inventory_page_section.png

@https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-04-16%20latest_error_validation.png

A major turning point was the Documentation Consolidation Initiative, which reorganized and centralized all project documentation, making it easier for new contributors to onboard and for the team to maintain alignment.

I also adopted a new philosophy to accompany the Theory of Constraints: Pocket Flow (https://pocketflow.dev/).

## Challenges & Lessons Learned

At each stage, adjustments had to be made, and assumptions evaluated and adapted to Salesforce's constraints.

I addressed these through phased implementation, validation stages, and continuous feedback.

Documentation played a crucial role in surfacing and resolving ambiguities.

## Current State & Next Steps
As of April 2025, the project is in Phase 1: Core Capacity Management. The focus is on completing capacity fields, validation rules, and dashboard components. The next phase will address user access, case management, and advanced reporting.

## Visual Timeline
- March 2025: Initial schema sketches
  @https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-19%20first_data_model.png
- Late March: Complex schema iteration
  @https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-19%20complex_schema_1.png
- Early April: UI drafts
  @https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-03-21%20draft_ui_director_dashboard.png
- Mid-April: Inventory and validation screenshots
  @https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-04-16%20latest_inventory_page_section.png
  @https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/historical-images/Screenshot%202025-04-16%20latest_error_validation.png

## Closing Reflection
The BoxFresh App journey demonstrates the value of combining strong methodology (TOC), iterative design, and comprehensive documentation. Each challenge has led to a more resilient and effective system, and the project continues to evolve with every sprint. The documentation and visual history ensure that lessons learned are preserved and shared as the team moves forward.
