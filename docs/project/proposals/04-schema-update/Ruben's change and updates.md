
# Ruben's change and updates

*27th March 2025*
## Overview

The recently consolidated documentation is missing some of the later updates i've done to the schema in the actual salesforce org. I've changed some objects around and also made some updates.
## Business Justification

Makes sense to me
## Approach

Objects, fields, and others to be added to docs/overview/schema.md

- **New object**: Material_Category__c ==need to add to docs/overview/schema.md==
	- Why: 
		material_budget__c object will use the material category instead of material_sku to create records. Because in a real world scenario specific sku availibility may change from when a contract is planned to when it's time to execute the activities of ordering materials. 
		It will be less complicated to budget at the category level. And when it's time to order the materials, those materials_sku that also have the same category lookup will be displayed readily for a fast process too.
	- Fields:
		- Name(text): name of category
		- Material Code(autonum): numerical identifier of category
		- Unit of measure(text): ==Not sure if this is relevant at the category level, please advise==; to budget quantity
		- Total SKU in category (rollup summary): to count the SKU in each category? ==advise is it's got any use here==

- changes to ***Material_SKU__C** : see docs/overview/schema

- changes to **Inventory__C**: 
	- added inventory ID (auto number) for easy identification in certain displays.

- added missing fields to **Inventory__c**:
	- capacity units & capacity available (formula not yet implemented, not sure what it is yet!)
	- 




