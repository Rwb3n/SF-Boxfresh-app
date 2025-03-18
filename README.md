# SF-Boxfresh-app
A mini app built in my Salesforce dev Org for my old small gardening business.

#Navigation:
## [Changelog](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/docs/Changelog.md)
## Docs
## --- Schema ERP Diagrams
## --- Flow Diagrams
## --- Reports & Dashboards
## --- Additional Documentation

## 🌿BoxFresh Gardens
Automated Service Scheduling, Inventory & Resource Management, and Customer Communication
A showcase of ADM201 Salesforce Administration skills: Service Cloud, Flow Automation, Data Management & Security.

## 🏵️ Overview
This project is a Salesforce native prototype for a app designed to demonstrate the skills gained ADM certification and independent problem solving ability.
It simulates a end-to-end service planning system. Optimizing workflow using elegant Schema design, Flow automation, Reports & Dashbords, following best practices.

### Why? let's recap what happened on the previous episode of:
### 'Ruben is a stubborn goat..." Or if you're impatient *[Skip the Cutscene](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/README.md#-scenario)*

I had a dream: **Working outdoors, basking in the sun amongst nature, grafting away to my heart's content.**
Being based in the centre of London should've been a clear indicator that this would be an uphill battle (fun fact: London is considered a forest from the amount of trees in it).
I was given breathing room, a chance to try it out with some savings after COVID. So I did.

I started freelance gardening private properties, middle-upper class families where one partner would be out getting the bacon, while the other took care of HQ. 
In these classic units, the stay at home member of the team is tested with their own challenges. 
They are usually the chief executive, manager, supervisor, and hands-on operative in the business of running a household. 
At some point they realise that outsourcing the more technical, and physically demanding, activities to sub-contractors is a essential energy-saving tactic.

### *Enter Ruben. Gardening cowboy, stinging nettles' worst nightmare, the secateur wielding spectre of topiary.*

But.

While I was hacking away at hedges, inneficiencies were slicing through my margins!

**Then came the turning point.**

The visionary in me wasn't happy with the forever grind. I was driven by ambitions of Big Contracts. Gated Residentials. Commercial Spaces. Business Parks! 
The itch for bigger fried fish wasn't being tickled. 

So I looked in the mirror, and accepted my limitations. Or so I thought. "You're not as sharp as you think, young padawan. Keep seeking help."

Little did I know I was about to a financial and emotional disaster (again!).

**This is what happened...**

Systems were needed, the systems being used had to be developed. Years of self-directed studying were finally being tested. 

### Rewind a few years back...

I stumbled across [Process Street](https://www.process.st/). 
In my curiosity I read Atul Gawande's [Checklist Manifesto](https://atulgawande.com/book/the-checklist-manifesto/). Aircraft pilots and brain surgeons use checklists, no matter the complexity, the humble checklist was a powerful tool.
- [37 Signal's Rework](https://basecamp.com/books#rework) explained the need to "KEEP IT SIMPLE..."(stupid)...

Listing all the books I thought would give me an edge would be a distraction. My point is the skills I should've focused on were always being suggested in the places I looked. These were systems, automation, organisation, etc.. thing I'm terrible at these things!

What really affected me was watching my bosses, the individuals I appointed as my mentors. Because of the broken systems they built and were blind to, were constantly driven to frustration at themselves and others around them! Instead of sitting down and looking for the root cause, they would vent their anger and the nearest target, and refuse to admit that things could work better. But I always. **ALWAYS**. knew they could.

So in that present moment, I reached for what I was familiar with. In the hustle between restaurant, door to door sales gigs I had always strived to improve my community. I worked under charities, tenant managed associations, NHS researchers, local gyms, cafes. Everywhere and Anywhere. During those periods of hustle I would use 'Airtable' because Excel was too lame. I was like a magpie - attracted to the shiniest entry on **Product Hunt**.

With Airtable and Zapier I set up a basic automation system to keep track my hours and expenses back in the day. So i brought that forward to


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
