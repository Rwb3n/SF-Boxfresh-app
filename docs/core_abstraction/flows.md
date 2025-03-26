---
layout: default
title: "Process Flows"
parent: "Core Abstraction"
nav_order: 2
---

# Process Flows

The BoxFresh App uses Salesforce Flows to automate business processes. These flows connect the different objects in the system to enable efficient service delivery and resource management.

## 1. Service Request Flow

This flow manages the process of receiving and fulfilling service requests.

<div align="center">
  <img src="https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/initial-workflow.png?raw=true" width="600"/>
</div>

### Process Steps:

1. **Request Intake**
   - Triggered when a new Order__c record is created
   - Validates the request details
   - Creates related records as needed

2. **Resource Assignment**
   - Determines available Resource_Unit__c records
   - Creates Assignment__c records
   - Updates resource availability

3. **Schedule Creation**
   - Organizes assignments into an efficient schedule
   - Updates Order__c with schedule details

4. **Customer Notification**
   - Sends confirmation to the customer
   - Provides schedule details and service information

### Flow Diagram:

```mermaid
flowchart TD
    A[New Order Created] --> B{Contract Valid?}
    B -->|Yes| C[Check Resource Availability]
    B -->|No| D[Reject Order & Notify]
    C --> E{Resources Available?}
    E -->|Yes| F[Create Assignments]
    E -->|No| G[Reschedule Request]
    F --> H[Schedule Resources]
    H --> I[Notify Customer]
    G --> J[Propose Alternative Date]
    J --> K[Update Order]
```

## 2. Inventory Management Flow

This flow manages the inventory tracking and reordering process.

### Process Steps:

1. **Stock Check**
   - Triggered by a scheduled job or manual request
   - Checks current inventory levels

2. **Inventory Update**
   - Updates inventory levels based on recent usage
   - Calculates remaining capacity

3. **Reorder Evaluation**
   - Determines if reordering is needed
   - Identifies items below threshold

4. **Reorder Process**
   - Creates purchase orders for required items
   - Routes for approval if needed

### Flow Diagram:

```mermaid
flowchart TD
    A[Stock Check Initiated] --> B[Check Inventory Levels]
    B --> C{Items Below Threshold?}
    C -->|Yes| D[Generate Reorder List]
    C -->|No| E[Update Last Check Date]
    D --> F[Create Purchase Orders]
    F --> G{Approval Required?}
    G -->|Yes| H[Route for Approval]
    G -->|No| I[Process Orders]
    H --> J{Approved?}
    J -->|Yes| I
    J -->|No| K[Cancel Purchase Order]
    I --> L[Update Inventory Planning]
```

## 3. Job Completion Flow

This flow manages the process of completing service jobs and related follow-up actions.

### Process Steps:

1. **Status Update**
   - Triggered when an Assignment__c status is updated to 'Completed'
   - Updates related Order__c status

2. **Material Usage**
   - Records materials used during the job
   - Updates inventory levels

3. **Performance Analysis**
   - Calculates performance metrics
   - Updates resource statistics

4. **Billing Preparation**
   - Prepares billing information
   - Routes for approval if needed

### Flow Diagram:

```mermaid
flowchart TD
    A[Assignment Marked Complete] --> B[Update Order Status]
    B --> C[Record Material Usage]
    C --> D[Update Inventory]
    B --> E[Calculate Performance Metrics]
    E --> F[Update Resource Stats]
    B --> G{All Assignments Complete?}
    G -->|Yes| H[Prepare Billing]
    G -->|No| I[Monitor Remaining Assignments]
    H --> J{Additional Charges?}
    J -->|Yes| K[Route for Approval]
    J -->|No| L[Generate Invoice]
    K --> M{Approved?}
    M -->|Yes| L
    M -->|No| N[Adjust Charges]
    N --> L
```

## 4. Customer Communication Flow

This flow manages communications with customers throughout the service lifecycle.

### Process Steps:

1. **Initial Confirmation**
   - Sends confirmation of service booking
   - Provides service details and instructions

2. **Reminder Notifications**
   - Sends reminders before scheduled service
   - Provides opportunity to reschedule if needed

3. **Completion Notification**
   - Notifies when service is completed
   - Provides summary of work performed

4. **Feedback Request**
   - Requests customer feedback
   - Routes feedback for review

### Flow Diagram:

```mermaid
flowchart TD
    A[Service Booked] --> B[Send Booking Confirmation]
    C[24 Hours Before Service] --> D[Send Service Reminder]
    E[Service Completed] --> F[Send Completion Notice]
    F --> G[Request Feedback]
    G --> H{Feedback Received?}
    H -->|Yes| I[Process Feedback]
    H -->|No| J[Send Reminder]
    I --> K{Rating < 4?}
    K -->|Yes| L[Route for Follow-up]
    K -->|No| M[Update Customer Record]
``` 