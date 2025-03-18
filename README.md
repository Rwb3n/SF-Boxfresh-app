# SF-Boxfresh-app
A mini app built in my Salesforce dev Org for my old small gardening business.

## [Changelog here](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/docs/Changelog.md)

## [🌿BoxFresh Gardens]
Automated Service Scheduling, Inventory & Resource Management, and Customer Communication
A showcase of ADM201 Salesforce Administration skills: Service Cloud, Flow Automation, Data Management & Security.

## [🏵️ Overview]
This project is a Salesforce native prototype for a app designed to demonstrate the skills gained ADM certification and independent problem solving ability.
It simulates a end-to-end service planning system. Optimizing workflow using elegant Schema design, Flow automation, Reports & Dashbords, following best practices.

### Why? let's recap what happened on the previous episode of 'Ruben is a stubborn goat..." Or if you want [Skip the Cutscene](#scenario)
I had a dream: Working outdoors, basking in the sun amongst nature, grafting away to my heart's content. 
Being based in the centre of London should've been a clear indicator that this would be an uphill battle (fun fact: London is considered a forest from the amount of trees in it).
I was given, breathing room, a chance to try it out with some savings after COVID, so I did.

I started freelance gardening private properties, middle-upper class families where one partner would be out getting the bacon, while the other took care of HQ. 
In these classic units, the stay at home member of the team is tested with their own challenges. 
They are usually the chief executive, manager, supervisor, and hands-on operative of the busyness. 
At some point they realise that outsourcing the more technical, and physically demanding, activities to sub-contractors is a essential energy-saving tactic.

Enter Ruben. Gardening cowboy, stinging nettles' worst nightmare, the secateur wielding spectre of topiary.

But.

While I was hacking away at hedges, inneficiencies were slicing through my margins!

Then came the turning point. 

The visionary in me wasn't happy with the grind forever, I was driven by ambitions of big contracts, gated residencies, commercial spaces, business parks! 
The itch for bigger fried fish wasn't being tickled. So I looked in the mirror, and accepted my limitations. Or so I thought. Little did I know I was about to a financial and emotional disaster (again!).

This is what happened...

Systems were needed, the systems being used had to be developed. Years of self-directed studying were finally being tested. Rewind a few years, I stumbled across [Process Street](https://www.process.st/). 
In my curiosity I read Atul Gawande's [Checklist Manifesto](https://atulgawande.com/book/the-checklist-manifesto/). It was great! This is what I needed! So simple! aircraft pilots used checklists, they were used in hospitals, no matter the complexity, the humble checklist was a powerful tool.
- [37 Signal's Rework](https://basecamp.com/books#rework) explained the need to "KEEP IT SIMPLE..."(stupid)...

If I start listing all the books I ravaged in my naive years I will lose the plot. The point is I had been somehow aiming unconsciously towards a discipline centered in the concept of systems and organisation. Something I was actually horrible at. At the people around me also sucked miserably at it - I witness the moments of frustration from mediocre systems, causing these people to vent blindly at other people rather than opening their eyes, admiting that things should work better, and get working at making things work better.


## 🔶 [Scenario]
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
