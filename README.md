# Project Overview

This project involves a multi-step process aimed at loading, transforming and analyzing data using Snowflake and dbt. The key stages include loading raw data, cleansing it, establishing a star schema, and executing queries.

## Table of Contents
- [Loading Data through Snowflake](#loading-data-through-snowflake)
- [Data Cleansing and Preparation](#data-cleansing-and-preparation)
  - [Column Details](#column-details)
  - [Observations in Data Formats](#observations-in-data-formats)
- [Star Schema](#star-schema)
  - [Sales Fact Table](#sales-fact-table)
  - [Location Dimension](#location-dimension)
  - [Property Specs at Sale Dimension](#property-specs-at-sale-dimension)
  - [Property Specs at Present Dimension](#property-specs-at-present-dimension)
  - [Date Dimension](#date-dimension)
- [Analytics](#analytics)
  - [Query 1](#query-1)
  - [Query 2](#query-2)
  - [Query 3](#query-3)
  - [Query 4](#query-4)
  - [Query 5](#query-5)
  - [Query 6](#query-6)
  - [Query 7](#query-7)
  - [Query 8](#query-8)
  - [Query 9](#query-9)
  - [Query 10](#query-10)
  - [Query 11](#query-11)
- [Project File Structure](#project-file-structure)
- [Data Dictionary](#data-dictionary)

## Loading Data through Snowflake

**Databases Creation:**
- Two databases were created within Snowflake—one for raw data and another for analytics.

**Data Loading:**
- A storage integration object was crafted to facilitate loading raw data from an S3 bucket.
- Two file formats were designed for 2016 sale files and 2017/2018 files, addressing issues like data trimming and handling commas within fields.
- Distinct format adjustments were applied. For the 2016 format, 22 lines were removed, serving as headers. In contrast, the 2017/2018 format omitted 20 lines and introduced a specific date format.
- A stage was established to copy raw data from the S3 bucket to a table in the raw database. The `sale_year` column was updated after loading each file to reflect the source year.

## Data Cleansing and Preparation

- The meticulous data cleansing process aimed to ensure uniformity and resolve various issues, including null values, data type alterations, and removal of commas and other characters from numerical fields. Additionally, more fields were added to enhance the dataset's comprehensibility.

### Column Details

- **borough_name**
  - No data cleansing was required for that field.

- **borough_code**
  - No data cleansing was required for that field.

- **neighborhood**
  - No data cleansing was required for that field.

- **building_class_category**
  - No data cleansing was required for that field.

- **tax_class_at_present**
  - Transformed tax classes at present to only include the main class and do not encompass any subclasses.
  - Also, replaced any null values with a descriptive string 'Unknown'.

- **tax_subclass_at_present**
  - Added tax subclass at present field to encompass both the main class and its associated subclass.
  - Also, replaced any null values with a descriptive string 'Unknown'.

- **block**
  - No data cleansing was required for that field.

- **lot**
  - No data cleansing was required for that field.

- **easement**
  - Replaced any null values with a descriptive string 'No Easement'.

- **building_class_at_present**
  - Replaced any null values with a descriptive string 'Unknown'.

- **address**
  - Updated addresses by relocating apartment numbers from the address field to incorporate them into the apartment number field.

- **apartment_number**
  - The apartment numbers now include those that were initially within the address field but were not originally assigned to their designated column.
  - Also, replaced any null values with a descriptive string 'Not Applicable'.

- **zip_code**
  - Since there are no valid zero zip codes in the USA, they have been substituted with the descriptive string 'Unknown,' as well as any null values.

- **residential_units**
  - This field was reformatted to establish consistency across multiple files, aligning them with the 2018 format.
  - Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to a small integer.
  - See [Observations in Data Formats](#observations-in-data-formats) for more details on data variations.

- **commercial_units**
  - This field was reformatted to establish consistency across multiple files, aligning them with the 2018 format.
  - Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to a small integer.
  - See [Observations in Data Formats](#observations-in-data-formats) for more details on data variations.

- **total_units**
  - This field was reformatted to establish consistency across multiple files, aligning them with the 2018 format.
  - Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to a small integer.
  - See [Observations in Data Formats](#observations-in-data-formats) for more details on data variations.

- **land_square_feet**
  - This field was reformatted to establish consistency across multiple files, aligning them with the 2018 format.
  - Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to an integer.
  - See [Observations in Data Formats](#observations-in-data-formats) for more details on data variations.

- **gross_square_feet**
  - This field was reformatted to establish consistency across multiple files, aligning them with the 2018 format.
  - Furthermore, commas were eliminated from this field to ease data aggregations, and the field's type was changed to an integer.
  - See [Observations in Data Formats](#observations-in-data-formats) for more details on data variations.

- **year_built**
  - If this field contained a value of 0, it was set to null, especially in cases where aggregations, including the calculation of minimum values, were needed.
  - Furthermore, the field's type was changed to a small integer.

- **decade_built**
  - Added this field to indicate the decade of construction.

- **tax_class_at_time_of_sale**
  - No data cleansing was required for that field.

- **building_class_at_time_of_sale**
  - No data cleansing was required for that field.

- **sales_price**
  - Removed commas and other extraneous characters from this field to facilitate aggregations on the data.
  - Furthermore, the field's type was changed to an integer.

- **sale_date**
  - No data cleansing was required for that field.

- **sale_day**
  - This field was extracted from the sale_date field.

- **sale_month**
  - This field was extracted from the sale_date field.

- **sale_quarter**
  - This field was extracted from the sale_date field.

- **sale_year**
  - Cleansing wasn't necessary for that field since the source year of the data aligns with the year value indicated in the sale_date field.

### Observations in Data Formats

The 2018 format, being devoid of dashes, served as a benchmark. 

In this format, it was observed that fields related to units and square feets were null when certain dimensions, 
like the building_class_column, were also null. Despite this, instances occurred where residential and commercial 
units equaled zero while total units did not. Furthermore, there were situations where all units were registered 
as zero, yet the land square feet were not. 

To address these variations, a decision was made to assign null values 
to all units and feets when fields like building_class were null. This adjustment was considered necessary upon 
recognizing a pattern in the 2016 format, where, in the absence of data in that column, all units and square feets 
were represented as dashes. While in the 2017 format, units were zeros, and square feets were represented as dashes.

## Star Schema 

The star schema is composed of the following key elements:

### Sales Fact Table

Every row in this fact table signifies a sales transaction associated with a building. The attributes encompassed by this fact table are:
- sales_price
- residential_units 
- commercial_units
- total_units
- land_square_feet
- gross_square_feet
- address
- apartment_number
- location_key
- property_specs_at_sale_key
- property_specs_at_present_key
- date_key

The address and apartment number fields have been incorporated as degenerate dimensions, 
serving as descriptive fields. These fields are not employed for grouping or filtering, 
and adding them to any dimension would only lead to an increase in its size.

### Location Dimension

This dimension contains details related to location and comprises the following attributes:
- borough_name
- borough_code 
- neighborhood 
- block
- lot
- zip_code
- location_key

While the addition of block, lot, and zip_code results in a greater number of rows within this dimension, 
their incorporation was motivated by the recognition that these attributes might be utilized for grouping and filtering 
in future analyses. 

### Property Specs at Sale Dimension

This dimension encompasses building properties, excluding those pertaining to the present. The attributes encompassed are:
- building_class_category
- building_class_at_time_of_sale 
- tax_class_at_time_of_sale
- easement
- year_built
- decade_built
- property_specs_at_sale_key

It is crucial to maintain a separation between present and at sale properties as combining them 
would inevitably result in a higher row count.

### Property Specs at Present Dimension

This dimension encompasses only those building properties that are pertinent to the present. These attributes are:
- building_class_at_present
- tax_class_at_present
- tax_subclass_at_present
- property_specs_at_present_key

The present values shouldn't be considered as slowly changing dimensions since they only change once with each 
sale occurrence. Thus, it is suitable to include them as dimensions associated with the sales fact table, 
given that these values experience changes solely in correlation with each sale.

### Date Dimension

This dimension contains all information related to sale dates and spans from '2016-01-01' to '2019-01-01'. The attributes encompassed are:
- date_value
- year_value
- month_value
- day_value
- quarter_value
- date_key

## Analytics 

Multiple queries were run to conduct analyses on the data.

### Query 1:
- This query is designed to compute the average sale price for each borough.

### Query 2:
- This query is designed to identify the neighborhood with the most total units.

### Query 3:
- This query aims to determine the building class category with the highest average land square feet.

### Query 4:
- This query involved tallying the number of buildings based on various dimensions. 

- This entailed counting buildings in each neighborhood, borough, and block, 
  and subsequently combining all the data through a union operation.

- It was noted that multiple records for the same building may exist due to occasional missing or 
  incorrectly entered zip codes. To ensure the unique identification of buildings in such instances, 
  distinctive combinations of borough, neighborhood, block, and lot were chosen.

### Query 5:
- This query entailed calculating total sales figures across different date intervals.

- The analysis was conducted on a yearly, monthly, and quarterly basis, avoiding daily breakdowns to 
  enhance result readability. Subsequently, the data was consolidated using a union operation.

### Query 6:
- This query involved  grouping the data by the current tax class and the tax class at the time of sale, 
  followed by comparing the average sale prices for each combination, determining whether they were greater, lesser, or equal. 

- The unknown class category was excluded due to its status as a missing data value.

### Query 7:
- This query is designed to identify the top 5 most expensive buildings based on sale price.

- The identification process focuses on factors such as borough, neighborhood, block, and lot, 
  rather than the address. This approach is taken due to variations in address representation, 
  where the same location might be expressed differently (e.g., "street" or "st" and "3rd" or "3").

- It has been observed that multiple records for the same building may exist, 
  primarily due to occasional missing or incorrectly entered zip codes. To ensure the unique identification of 
  buildings in such instances, distinctive combinations of borough, neighborhood, block, and lot were 
  grouped together, disregarding the zip code.

### Query 8:
- This query involved utilizing a window function to calculate the running total of sales prices.

- The computation was executed on a yearly and monthly basis, with a deliberate decision to 
  avoid daily breakdowns for enhanced result clarity.

### Query 9:
- This query involved grouping the data based on a column representing the difference in 
  years between the sale date and the year built, and subsequently 
  analyzing the distribution of sale prices.

- The analysis included obtaining the maximum, minimum, average, median, and 
  standard deviation for each group based on the year difference column.

- The data was filtered to exclude cases where the year built was null, indicating missing data, 
  and the sale price was zero, suggesting a transfer of ownership without a cash consideration.

### Query 10:
- This query serves the purpose of identifying the sales linked to a building, 
  particularly when the building has been involved in multiple sales transactions.

- The identification process focuses on factors such as borough, neighborhood, block, and lot, 
  rather than the address. This approach is taken due to variations in address representation, 
  where the same location might be expressed differently (e.g., "street" or "st" and "3rd" or "3").

- It has been observed that multiple records for the same building may exist, 
  primarily due to occasional missing or incorrectly entered zip codes. To ensure the unique identification of 
  buildings in such instances, distinctive combinations of borough, neighborhood, block, and lot were 
  grouped together, disregarding the zip code and location key. Thus, buildings sold multiple times 
  had to be reconnected with the location dimension to retrieve the location key.

### Query 11:
- This query is aimed at analyzing sale prices based on the year built and the decade built. 
  The process involves grouping the data by year and decade and then analyzing the distribution of sale prices.

- The analysis included obtaining the maximum, minimum, average, median, and 
  standard deviation for each group.

- The data was filtered to exclude cases where the year built was null, indicating missing data, 
  and the sale price was zero, suggesting a transfer of ownership without a cash consideration.

## Project File Structure:

The project files are organized as follows:

- **Staging Folder:**
  - Contains data cleansing processes and dimensions.
  - Located within the Models folder.

- **Marts Folder:**
  - Houses the sales fact table.
  - Located inside the Models folder.

- **Analytics Folder:**
  - Contains queries.
  - Located within the Models folder.

## Data Dictionary

For additional information on data fields, please refer to the [data dictionary](https://www.nyc.gov/assets/finance/downloads/pdf/07pdf/glossary_rsf071607.pdf).