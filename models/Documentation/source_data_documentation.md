{% docs raw_data_description %}

This table encompasses Annualized Sales files from the New York City Department of Finance, 
cataloging properties sold within the years 2016 to 2018 in New York City. 

{% enddocs %}

{% docs building_class_category_description %}

A field that is included so that similar properties by broad usage can be 
easily identified without looking up individual Building Classes.

{% enddocs %}

{% docs tax_class_description %}

Every property in the city is assigned to one of four tax classes (Classes 1, 2, 3, and 4), 
based on the use of the property. 

| Class          | Description                                                 |
|----------------|-------------------------------------------------------------|
| 1              | Includes most residential property of up to three units (such as one-, two-, and three-family homes and small stores or offices with one or two attached apartments), vacant land that is zoned for residential use, and most condominiums that are not more than three stories.|
| 2              | Includes all other property that is primarily residential, such as cooperatives and condominiums.|
| 3              | Includes property with equipment owned by a gas, telephone or electric company.|
| 4              | Includes all other properties not included in class 1,2, and 3, such as offices, factories, warehouses, garage buildings, etc.|
  

{% enddocs %}

{% docs tax_subclass_description %}

Every property in the city is assigned to one of four tax classes (Classes 1, 2, 3, and 4), 
based on the use of the property. 

| Class          | Description                                                 |
|----------------|-------------------------------------------------------------|
| 1              | Includes most residential property of up to three units (such as one-, two-, and three-family homes and small stores or offices with one or two attached apartments), vacant land that is zoned for residential use, and most condominiums that are not more than three stories.|
| 2              | Includes all other property that is primarily residential, such as cooperatives and condominiums.|
| 3              | Includes property with equipment owned by a gas, telephone or electric company.|
| 4              | Includes all other properties not included in class 1,2, and 3, such as offices, factories, warehouses, garage buildings, etc.|
  
This field also encompasses the subcategories of tax classes

For example:

| Class 2 Subclasses                  | Description                                                 |
|-------------------------------------|-------------------------------------------------------------|
| Sub-Class 2a                        | (4 -  6)  unit rental building                              |
| Sub-Class 2b                        | (7 -  10) unit rental building                              |
| Sub-Class 2c                        | (2 -  10) unit cooperative or condominium                   |
| Class 2                             | 11 units or more                                            |


{% enddocs %}

{% docs block_description %}

A Tax Block is a sub-division of the borough on which real properties are located. 
The Department of Finance uses a Borough-Block-Lot classification to label all real 
property in the City. “Whereas” addresses describe the street location of a property, the 
block and lot distinguishes one unit of real property from another, such as the different 
condominiums in a single building. Also, block and lots are not subject to name changes 
based on which side of the parcel the building puts its entrance on.

{% enddocs %}

{% docs easement_description %}

An easement is a right, such as a right of way, which allows an entity to make limited use of 
another real property. For example: MTA railroad tracks that run across a portion of another 
property.

{% enddocs %}

{% docs building_class_description %}

The Building Classification is used to describe a property’s constructive use. 
The first position of the Building Class is a letter that is used to describe a general class of properties.

For example:

| Building Class First Letter         | Description                                                 |
|-------------------------------------|-------------------------------------------------------------|
| “A”                                 | one-family homes                                            |
| “O”                                 | office buildings                                            |
| “R”                                 | condominiums                                                |

   
The second position, a number, adds more specific information about the property’s use or construction style.

For example:

| Building Class                      | Description                                                 |
|-------------------------------------|-------------------------------------------------------------|
| “A0”                                | cape Cod style one family home                              |
| “O4”                                | tower type office building                                  |
| “R5”                                | commercial condominium unit

The term Building Class used by the Department of Finance is interchangeable with the 
term Building Code used by the Department of Buildings. See [NYC Building Classifications](https://www.nyc.gov/assets/finance/jump/hlpbldgcode.html)
for more classifications.
{% enddocs %}

{% docs address_description %}

The street address of the property as listed on the Sales File. Coop sales 
include the apartment number in the address field. 

{% enddocs %}

{% docs gross_square_feet_description %}

The total area of all the floors of a building as measured from the exterior surfaces of the 
outside walls of the building, including the land area and space within any building or structure 
on the property. 

{% enddocs %}

{% docs sales_price_description %}

Price paid for the property. 

$0 Sales Price: 
A $0 sale indicates that there was a transfer of ownership without a cash consideration. 
There can be a number of reasons for a $0 sale including transfers of ownership from 
parents to children. 

{% enddocs %}