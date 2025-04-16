# Capacity Management Implementation Log

## [2024-06-11] Architectural Note: Capacity_Status__c on Material_Stock__c

**Author:** AI Supervisor (per user request)

### Context
- The original design called for a formula field on Material_Stock__c (`Capacity_Status__c`) to reference the parent Inventory__c's `Buffer_Status__c` formula field.
- Salesforce does not allow a formula on the detail side to reference a master formula if that formula references a roll-up summary field.

### Decision
- Instead of a formula, a custom text field `Capacity_Status__c` will be created on Material_Stock__c.
- A record-triggered Flow will be implemented to copy the value of `Inventory__c.Buffer_Status__c` to each related Material_Stock__c record whenever the parent or child is updated.

### Rationale
- This approach ensures that the buffer status is always available on Material_Stock__c for reporting, validation, and UI logic, while remaining compliant with Salesforce platform limitations.
- The documentation in `stock.md` and the Flows Guide has been annotated to reflect this architectural decision.

### References
- [Material Stock Capacity Fields Guide](./stock.md#capacity_status__c-formula)
- [Capacity Management Flows Guide](./flows.md#container-update-flow)

## [2024-06-11] Progress Update: Inventory & Material Stock Schema Implementation

**Author:** Implementation Lead (per user update)

### Completed Tasks
- Inventory__c object:
  - Defined object label, API name, and description
  - Set object permissions (tab, search, reporting)
  - Added fields:
    - Capacity_Units__c (Number, required, default 100)
    - Total_Units_Consumed__c (Roll-Up Summary: SUM of Material_Stock__c.Units_Consumed__c)
    - Available_Units__c (Formula: Capacity_Units__c - Total_Units_Consumed__c)
    - Buffer_Status__c (Formula: Buffer zone logic)
    - Is_Constraint__c (Checkbox)
    - Capacity_Utilization_Percent__c (Formula: % utilization)
- Material_Stock__c object:
  - Defined object label, API name, and description
  - Set object permissions (tab, search, reporting)
  - Created master-detail relationship to Inventory__c
  - Added fields:
    - Units_Consumed__c (Number)
    - Quantity__c (Number)
    - Units_Per_Quantity__c (Number)
    - Capacity_Status__c (Text, to be populated by Flow)
  - Implemented formula/flow: Units_Consumed__c = Quantity__c * Units_Per_Quantity__c

### Notes
- Remaining tasks include building the record-triggered Flow for Capacity_Status__c, testing, and validation rule/flow implementation.
- See `todo.md` for the current checklist and next steps.

## [2024-06-11] Validation Rule Review: Material_Stock__c Capacity Enforcement

**Author:** AI Supervisor

**Context:**
Reviewed the validation rule for Material_Stock__c that prevents exceeding the parent Inventory__c's available capacity.

**Rule:**
`Inventory__c.Available_Units__c < Units_Consumed__c`

**Analysis:**
- Salesforce allows cross-object validation rules on the detail to reference formula and roll-up summary fields on the master.
- This is permitted even if the master's formula references a roll-up summary.
- This is not subject to the same limitations as formula fields on the detail.

**Decision:**
- The validation rule as documented is valid and does not require a flow.
- No change to the implementation is needed.

**References:**
- [Material Stock Capacity Fields Guide](./stock.md#2-create-validation-rule)
- Salesforce Help: [Validation Rules and Cross-Object References](https://help.salesforce.com/s/articleView?id=sf.fields_validation_rules_cross_object.htm&type=5)

## [2024-06-11] Validation Rules Complete

**Author:** Implementation Lead (per user update)

### Summary
- All validation rules for Inventory__c and Material_Stock__c have been implemented as per the checklist in todo.md.
- Rules implemented:
  - Inventory__c: Prevent_Negative_Capacity (Available_Units__c < 0)
  - Material_Stock__c: Prevent adding stock that would exceed container capacity (Inventory__c.Available_Units__c < Units_Consumed__c)
- Both rules were implemented as standard Salesforce validation rules; no flows were required.

### References
- [todo.md](./todo.md#3-validation-rules-complexity-2)
- [Validation Guide](./validation.md)

## [2024-06-11] Inventory__c Tab Created and Assigned to App

**Author:** Implementation Lead (per user update)

### Summary
- Created a custom tab for the Inventory__c object and assigned it to the relevant app.
- This is a logical prerequisite for making page layout changes and for UI-based testing, as the tab provides direct access to Inventory__c records in the app interface.

### Rationale
- Without a tab, it is not possible to easily navigate to Inventory__c records, assign or preview page layouts, or perform end-to-end UI testing.

## [2024-06-11] UI & Validation Enhancements, Buffer Priority Dependency Review

**Author:** Implementation Lead (per user update)

### Summary
- Added tabs for both Inventory__c and Material_Stock__c to the app for easier navigation and testing.
- Added the related list of Material_Stock__c to the Inventory__c page layout to facilitate direct testing and record management.
- Discovered that creation of Material_Stock__c records with Units_Consumed__c = 0 should be prevented (null is acceptable). Need to add a validation rule to enforce this.
- Noted that Buffer_Priority__c field dependency must be reviewed and possibly updated, since Capacity_Status__c is now populated by Flow rather than formula.

### Next Steps
- Implement validation rule to prevent Units_Consumed__c = 0 on Material_Stock__c.
- Evaluate and update Buffer_Priority__c field dependency logic as needed.

### References
- [todo.md](./todo.md)

--- 