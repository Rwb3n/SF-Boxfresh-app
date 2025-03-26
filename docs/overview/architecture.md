---
layout: default
title: "System Architecture"
parent: "Overview"
nav_order: 1
---

# BoxFresh App System Architecture

## 1. Project Requirements

BoxFresh Gardens needs a Salesforce-native app to manage:
- Service scheduling and job tracking
- Inventory and resource management using Theory of Constraints principles
- Customer communication and contract management
- Reporting and performance analysis

### Use Case Assessment

The BoxFresh app is suitable for an LLM system because:
- It involves routine tasks that require common sense (scheduling, resource allocation)
- It requires structured information processing (inventory tracking, job status updates)
- The data schema and processing rules can be clearly defined

## 2. Utility Functions

The BoxFresh app requires the following core utilities:

### Data Access Functions
- `get_inventory_status(inventory_id)`: Retrieves current inventory levels and capacity constraints
- `get_resource_availability(date_range)`: Checks resource availability in a given period
- `update_job_status(job_id, status)`: Updates the status of a job
- `create_contract(customer_id, service_details)`: Creates a new service contract

### External Tools
- `generate_schedule_recommendation(resources, jobs, constraints)`: LLM-powered scheduling optimization
- `classify_customer_request(request_text)`: Auto-categorizes incoming service requests
- `summarize_job_performance(job_history)`: Generates performance summaries

## 3. Flow Design (Compute)

### Main Application Flows

#### 1. Service Request Processing Flow
- **Node A: Request Intake**
  - Purpose: Capture and validate incoming service requests
  - Type: Regular node
  - `exec`: `classify_customer_request()`

- **Node B: Resource Assignment**
  - Purpose: Assign appropriate resources to the job
  - Type: Batch node (handles multiple resource assignments)
  - `exec`: `get_resource_availability()`

- **Node C: Schedule Creation**
  - Purpose: Create optimal service schedule
  - Type: Regular node
  - `exec`: `generate_schedule_recommendation()`

- **Node D: Notification**
  - Purpose: Notify staff and customers of assignments
  - Type: Async node
  - `exec`: `send_notifications()`

#### 2. Inventory Management Flow
- **Node A: Stock Check**
  - Purpose: Check current inventory levels against capacity constraints
  - Type: Regular node
  - `exec`: `get_inventory_status()`

- **Node B: Depletion Forecast**
  - Purpose: Predict future inventory needs
  - Type: Regular node
  - `exec`: `forecast_inventory_needs()`

- **Node C: Reorder Decision**
  - Purpose: Determine if reordering is needed based on buffer status
  - Type: Regular node (with branching)
  - `exec`: `evaluate_reorder_decision()`

#### 3. Job Completion Flow
- **Node A: Status Update**
  - Purpose: Record job completion status
  - Type: Regular node
  - `exec`: `update_job_status()`

- **Node B: Performance Analysis**
  - Purpose: Analyze job performance metrics
  - Type: Regular node
  - `exec`: `summarize_job_performance()`

- **Node C: Invoice Generation**
  - Purpose: Generate customer invoice
  - Type: Regular node
  - `exec`: `create_invoice()`

## 4. Data Schema (Data)

### Core Data Structure

```
shared = {
  "inventory": {
    "material_skus": [...],   // Catalog of materials
    "material_stock": [...],  // Current stock levels with capacity consumption
    "locations": [...],       // Storage locations with capacity constraints
    "buffer_status": [...]    // Buffer status for each container
  },
  "resources": {
    "staff": [...],           // Staff resources
    "equipment": [...],       // Equipment resources
    "availability": {...}     // Availability calendar
  },
  "jobs": {
    "scheduled": [...],       // Upcoming jobs
    "in_progress": [...],     // Jobs currently being worked
    "completed": [...],       // Finished jobs
    "performance_metrics": {...} // Job analytics
  },
  "customers": {
    "accounts": [...],        // Customer accounts
    "contracts": [...],       // Service contracts
    "properties": [...]       // Service locations
  },
  "assignments": {
    "resources": [...],       // Resource assignments
    "inventory": [...],       // Inventory allocations with capacity tracking
    "schedule": [...]         // Schedule details
  }
}
```

### Data Flow

- **Service Request Flow**:
  - `prep`: Read customer and resource data
  - `post`: Update jobs and resource availability

- **Inventory Flow**:
  - `prep`: Read current inventory, capacity constraints, and buffer status
  - `post`: Update inventory status, buffer zones, and orders

- **Job Completion Flow**:
  - `prep`: Read job details and resource assignments
  - `post`: Update job status, performance metrics, and customer billing

## 5. Implementation

The implementation follows a phased approach:

### Phase 1: Core Capacity Management (Current)
1. Creating custom objects in Salesforce with capacity constraints
   - Material_SKU__c, Material_Stock__c, Inventory__c
   - Resource__c, Assignment__c, Job__c
   - Contract__c, Property__c
2. Implementing capacity tracking and buffer management
   - Capacity fields on Inventory__c and Material_Stock__c
   - Junction relationship through Assignment__c
   - Buffer status visualization and alerts

### Phase 2: User Access, Cases, and Reporting
1. User Security Implementation
   - Role configuration and permission sets
   - Field-level security and sharing rules
2. Case Management Implementation
   - Case creation and assignment processes
   - Escalation and SLA enforcement
3. Reporting Implementation
   - Capacity dashboards and operational metrics
   - Client-facing reports

## 6. Optimization

Initial optimization focuses on:
- Streamlining job assignment process
- Improving inventory forecasting accuracy based on buffer status
- Enhancing user experience for field staff

## 7. Reliability

Reliability measures include:
- Data validation rules for capacity constraints
- Comprehensive test cases for allocation scenarios
- Error handling and notifications for buffer violations
- Backup and recovery procedures

## Documentation Consolidation

This content has been migrated as part of the [Documentation Consolidation Initiative](../consolidation/index.md) (April 3-11, 2025) from its original location at `design.md`. 