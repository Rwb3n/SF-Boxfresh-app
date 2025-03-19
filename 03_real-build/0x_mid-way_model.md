## Latest Schema Overview
Below is the latest schema. I've labeleld each batch of objects based on their collective function.
  ### 1. Inventory
  #### - Material_SKU__c
  The catalogue of unique stock items, these include records like *"Large Compost Bag"*, *"Small Compost Bag"*, *"Mahonia 'Soft Caress'"*, etc...
  #### - Material_Stock__c 
  This object looks up a **Material_SKU** record, and is used to record the quantity of each item batch, a capacity unit of measure is calculated from the **quantity + units of measure**
  #### - Inventory__c 
  Is for managing capacity limits of the purchased stock. It is a sort of "container" that each **Material_Stock** will be allocated.
                    it will be allocated to a **Resource_Asset** record that has the field boolean **hasStorage** as **TRUE**

![Latest Schema](https://github.com/Rwb3n/SF-Boxfresh-app/blob/main/img/19-3-25-latest.png)
