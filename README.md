# SF-Boxfresh-app
A mini app built in my Salesforce dev Org for my old small gardening business.

## [Changelog here](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/docs/Changelog.md)

## 🌿BoxFresh Gardens
Automated Service Scheduling, Inventory & Resource Management, and Customer Communication
A showcase of ADM201 Salesforce Administration skills: Service Cloud, Flow Automation, Data Management & Security.

## 🏵️ Overview
This project is a Salesforce native prototype for a app designed to demonstrate the skills gained ADM certification and independent problem solving ability.
It simulates a end-to-end service planning system. Optimizing workflow using elegant Schema design, Flow automation, Reports & Dashbords, following best practices.

## 🔶 Scenario
A small service-based business (Boxfresh Gardens) needs a Salesforce-powered service management system that automates inventory & resource management, job assignment, and reporting. This prototype solves that problem using a declarative based Salesforce customization, ensuring a scalable, effective CRM solution.

## Features & Capabilities
✅ Service Cloud Configuration – Custom Case Lifecycle, automated status tracking
✅ Flow Automation – Auto-assign requests to resource units based on availability
✅ Reports & Dashboards – Real-time insights for job & inventory tracking, and performance analysis
✅ User & Data Security – Custom profiles, permission sets, and sharing rules
✅ Lightning UI Customization – Page layouts, paths, quick actions, and record types

## 🔨 Technical Breakdown
This POC includes Salesforce-native features without custom code:
### 🔹 Custom Schema
    - Custom Objects: Material SKU, Inventory, Custom Contract, Resource, Asset, Resource Unit, Assignment, Work Order
    - Standard Objects Used: Case, Account, Contact
### 🔹 Automation
    - Flow Builder: Case Routing Flow, Escalation Flow
    - Approval Processes: Purchase Order Approvals
    - Validation Rules: Ensuring required fields for Inventory & job record creation
### 🔹 Security & Access
    - Profiles & Permission Sets: Role-based access for Admins, Technicians, and Managers
    - Sharing Rules: Restricting job visibility to assigned teams only
### 🔹 Analytics & Insights
    - Reports & Dashboards: Inventory Analysis, Job Completion Rate, Technician Performance

## 🛣️ Roadmap
- [x] Initial Schema Design
- [x] Schema Builder Implementation
- [x] Validation Rules
- [ ] Page Layouts
- [ ] Flow Builder
- [ ] Reports
- [ ] Dashboards
- [ ] Users & Permission sets
- [ ] More TBD... (AI, Experience Cloud...)
