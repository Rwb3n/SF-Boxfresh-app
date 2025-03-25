# 🌳☑️SF-Boxfresh-app☑️🌳
- A mini app built in my Salesforce dev Org for my old small gardening business.
- Trailhead is great to learn in, but I don't get to "figure it out". This is an exercise in discovering and defining unknown unknowns. In my journey through the 'Salesforce'

# 🚧Under construction🚧
## [Changelog](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/docs/Changelog.md)

Documentation Navigation:
### - [Start Here](https://github.com/Rwb3n/SF-Boxfresh-app/tree/main/01_start-here) # The clueless phase, first struggles and first attempts
#### |----- You'll find my first initial information capture, my analysis and the business requirement document
#### |----- A system design and specification skeleton document is also there.
#### |----- This folder mostly covers my initial attempts at initing a technical project in salesforce

### Coming Soon:
```
--- Diving In # Where I started to see the gaps
|----- This folder showcases my initial attemps at mapping out the custom objects
|----- A lot of the objects evolved over time as I grappled with the Salesforce Schema
|----- I would return to the drawing board more then once...

--- Diagrams
|----- ERD_Diagrams
|----- Flow_diagrams

--- Reports
|----- Job_Performance_Report
|----- Inventory_Usage_Report

--- Reference_Docs
|----- Security_Model
|----- Automation_Design

--- Config
|----- Objects
|----- Flows
|----- Permission_Sets
```

# Readme Sections:
### Overview | Scenario | Features & Capabilities | Technical Breakdown | Roadmap

## 🌿[BoxFresh Gardens]
Automated Service Scheduling, Inventory & Resource Management, and Customer Communication
A showcase of ADM201 Salesforce Administration skills: Service Cloud, Flow Automation, Data Management & Security.

## 🏵️ [Overview]
This project is a Salesforce-native prototype designed to showcase the skills gained from my ADM certification and my independent problem-solving ability. It optimizes workflow through elegant schema design, flow automation, and real-time reporting, following Salesforce best practices.

### Why
**This is how it began:** 
### "Alright. I passed ADM201. Now what?"

I see people applying for Salesforce roles with stacked credentials—papers. I get it. If nothing else, those certs show tenacity. So how do I counter that? I need to prove the same thing—but in my own way, I have no choice.

A portfolio. But not just some vague automation flow. That won’t show initiative. If I want to stand out, I need something real—something that proves I can build, problem-solve, and execute.

So I’ll do this: I’ll go back. Back to BoxFresh Gardens, my old business, where I lost the game because I lacked systems, amongst other aspects. And I’ll rebuild it—not in the real world, but in Salesforce. 
Everything I think was missing, every blind spot, every inefficiency—I’ll attempt to fix it.

If I had this back then, would I have survived? Maybe. That’s not the point. The point is I’ll prove I can do what actually matters in this space. Design. Build. Solve. Execute. Get hired!

### Let's rewind for a moment...

Back then I set out to build a life in the sun, hands in the earth, scaling from private gardens to high-end contracts. 
I recruited a team of workhorses who took me further than ever before, but my grip wasn’t strong enough. Systems failed, cracks widened, and I collapsed under the weight of my own ambition.

This project is my autopsy, a reconstruction of what was missing—structured automation, resource control, and precision execution. 
My failures sharpened my insights, and now, this portfolio is proof of the value I might bring to ambitious teams in the Salesforce space.🚀

---

## 🔶 [Scenario]
A small service-based business (Boxfresh Gardens) needs a Salesforce-powered service management system that automates inventory & resource management, job assignment, and reporting. This prototype solves that problem using a declarative based Salesforce customization, ensuring a scalable, effective CRM solution.

## [Features & Capabilities]
- ✅ Service Cloud Configuration – Custom Case Lifecycle, automated status tracking
- ✅ Flow Automation – Automatically assigns requests to resource units based on availability
- ✅ Reports & Dashboards – Provides real-time insights into job tracking, inventory, and performance analysis
- ✅ User & Data Security – Custom profiles, permission sets, and sharing rules
- ✅ Lightning UI Customization – Page layouts, paths, quick actions, and record types

## 🔨 [Technical Breakdown]
This POC includes Salesforce-native features without custom code:
### 🔹 Custom Schema
    - Custom Objects: Material SKU, Inventory, Custom Contract, 
      Resource, Asset, Resource Unit, Assignment, Work Order
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

## 🛣️ [Roadmap]
- [x] Initial Schema Design
- [x] Schema Builder Implementation
- [x] Validation Rules
- [ ] Page Layouts
- [ ] Flow Builder
- [ ] Reports
- [ ] Dashboards
- [ ] Users & Permission sets
- [ ] Potential Future Features coming soon... (AI, Experience Cloud...)
