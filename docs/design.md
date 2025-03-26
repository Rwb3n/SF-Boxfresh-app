---
layout: default
title: "BoxFresh App Design"
---

# BoxFresh App System Design

## 1. Project Requirements

BoxFresh Gardens needs a Salesforce-native app to manage:
- Service scheduling and job tracking
- Inventory and resource management
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
- `get_inventory_status(inventory_id)`: Retrieves current inventory levels
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
  - Purpose: Check current inventory levels
  - Type: Regular node
  - `exec`: `get_inventory_status()`

- **Node B: Depletion Forecast**
  - Purpose: Predict future inventory needs
  - Type: Regular node
  - `exec`: `forecast_inventory_needs()`

- **Node C: Reorder Decision**
  - Purpose: Determine if reordering is needed
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
    "material_skus": [...],  // Catalog of materials
    "material_stock": [...],  // Current stock levels
    "locations": [...]        // Storage locations
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
  }
}
```

### Data Flow

- **Service Request Flow**:
  - `prep`: Read customer and resource data
  - `post`: Update jobs and resource availability

- **Inventory Flow**:
  - `prep`: Read current inventory and usage history
  - `post`: Update inventory status and orders

- **Job Completion Flow**:
  - `prep`: Read job details and resource assignments
  - `post`: Update job status, performance metrics, and customer billing

## 5. Implementation

The implementation will begin with:
1. Creating custom objects in Salesforce
   - Material_SKU__c, Material_Stock__c, Inventory__c
   - Resource__c, Assignment__c, Job__c
   - Contract__c, Property__c

2. Implementing core automation flows
   - Job assignment and scheduling
   - Inventory tracking and alerts
   - Reporting and dashboards

3. Building the user interface
   - Custom Lightning pages
   - Mobile optimization

## 6. Optimization

Initial optimization will focus on:
- Streamlining job assignment process
- Improving inventory forecasting accuracy
- Enhancing user experience for field staff

## 7. Reliability

Reliability measures will include:
- Data validation rules
- Comprehensive test cases
- Error handling and notifications
- Backup and recovery procedures 