# The Next Steps - Summary

I decided to draft another formal document. Calling it the 'System and Design Specifications', for reference below.
The problem was that there were gaps in bridging this document with the previous Business Requirements Doc. I also went off tangent as the project progressed.
**Lesson Learned**: Ensure the document makes sense - i.e enough to behonored as a map for developing the app.

**What I'll do next time I'm drafting a SDS**
- Have specific references to previous documents (BRD), which means that the documents must all have a structure that's globally aligned.... somehow...
- I'll add a success metrics section where I reference the BRD's metrics to each technical implementation.
  - i.e: automation of scheduling: from estimated 5 hours per week to under 2 hours.
- Include risk mitigation strategies.
  - for each technical implementation, ensure a risk mitigation subheader is included. referencing the risks from the BRD.
  - i.e: if incorrect job scheduling, include supervisor override ability via......
- MAP THE IMPLEMENTATION - try to list in order what's going to be built first.
- Data migration! Consider that data will need to be migrated into this new system. address the state of current data and how it'll be migrated.
- Include what you think each view for each stakeholder will look like.
- Add test criteria, tie this in with the BRD.
  - i.e: must reduce x time per day/week. stakeholders must not have to do x admin activities anymore.
- Include training considerations. address the risks adressed in the BRD.

---

## **System Design & Specification**
This phase ensures that the **functional requirements** outlined in the BRD are **mapped to system features, architecture, and workflows**.

## **1. Define System Architecture**
- Salesforce Objects & Relationships
- Data Model & Custom Fields
- Automation & Integration Plan
- User Roles & Permissions

### Key Questions
1. How will users interact with the system (desktop, mobile, external portal)?

## 2. Map Workflows to System Logic
Each **business process** from the BRD needs to be **translated into an automated workflow**.

### **Example: Job Scheduling Workflow**
1. **Trigger**: New job request or recurring job generated from contract or ad-hoc request
2. **System Action**: Check **team availability + assign the best fit**. what is the criteria for best fit?
3. **Notification**: Supervisor receives assignment via **Salesforce Mobile App**.
4. **Tracking**: **Operatives log job completion** + attach photos.
5. **Client Communication**: Auto-generate **service completion report** + email it to the client.
6. **Billing**: If applicable, trigger **invoice creation + sync to accounting software**.

## **3. Define Data Model & Object Relationships**
Each system feature requires **data storage & relationships**.

| **Object**      | **Key Fields**                               | **Relationships**                                     |
| --------------- | -------------------------------------------- | ----------------------------------------------------- |
| **Schedule**    | ID, Assigned Team, Inventory Status, Date    | Connected to **Clients, Inventory, Expense Tracking** |
| **Inventory**   | Item Name, SKU, Quantity, Supplier,          | Linked to **Work Orders, Procurement Requests**       |
| **Expense Log** | Job ID, Labor Hours, Materials Used          | Connected to **Financial Reports**                    |

## **4. Automations & Integrations**

To reduce manual work, we will define:
- **What should be automated?** (e.g., scheduling, reporting, client emails)
- **What needs to integrate?** (e.g., finance tools, supplier order systems)

Example:
- **Automate Work Orders** → Auto-assign jobs based on availability.
- **Inventory Alerts** → Low stock → Auto-generate purchase request.
- **Client Communication** → Job completion → Auto-send report.

**Which automations should be prioritized first?**

## **5. Security & User Access**

Define **who can access what**:
- **Supervisors:** Assign work, approve inventory requests.
- **Operatives:** View tasks, log job completion.
- **Managers:** Oversee financials, reporting.
```
