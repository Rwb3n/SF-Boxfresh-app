# Changelog

[Back to ReadMe](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/README.md)

#### 19/03/25 
- I'm going to start on this repo now, take a break from the building of the app, time is of the essense and I want to be able to showcase the work I've done **so far**.
- Created "start here" folder, uploaded and refined documents from the first batch of logs
- Uploaded and fixed  up the initial docs I drafted. Continued with development of the app
#### 18/03/25
- Polishing up more parts of the overall boxfresh app design.
- 'Custom_Contract' custom object is now broken into modular sub-objects:
  - 'Core Contract', Parent Junction Object; references SLA, obligations, and holds high-level agreement terms
  - 'Order', Child of Core; looks up the planned services, materials, assets. Used to forecast inventory and Resources
  - 'Service Agreement', Child of Core; records specific renewal terms, penalties, service conditions, etc.. specific to the contract.
- This way multiple 'order' and 'service agreement' records can be connected with one 'core contract' as required without confusion.
#### 17/03/25
- Going to transfer Obsidian Notes, screenshots, etc... onto Github to being sharing progress.
