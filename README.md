# Project Overview

This project involves a multi-step process aimed at loading, transforming and analyzing 
superstore data using Snowflake and dbt. The key stages include loading raw data, cleansing it, 
establishing a star schema, and executing queries.

## Table of Contents
- [Loading Data through Snowflake](#loading-data-through-snowflake)
- [Explanation of Data Columns and Conducted Tests](#explanation-of-data-columns-and-conducted-tests)
- [Data Cleansing and Preparation with Conducted Tests](#data-cleansing-and-preparation-with-conducted-tests)
- [Star Schema](#star-schema)
  - [Sales Fact Table](#sales-fact-table)
  - [Customer Dimension](#customer-dimension)
  - [Region Dimension](#region-dimension)
  - [Date Dimension](#date-dimension)
  - [Order Dimension](#order-dimension)
  - [Product Dimension](#product-dimension)
- [Analytics](#analytics)
  - [Query 1 (Monthly Customer Sales)](#query-1)
- [Project File Structure](#project-file-structure)
- [Data Source and Dictionary](#data-source-and-dictionary)

## Loading Data through Snowflake

**Databases Creation:**
- Two databases were created within Snowflake—one for raw data and another for analytics.

**Data Loading:**
- A file format was created to address issues such as data trimming, handling commas within fields, 
  implementing date format, and setting encoding to 'iso-8859-1' for characters that cannot be handled 
  when encoded by utf-8.
- A named stage was established to copy raw data locally to a table in the raw database.

## Explanation of Data Columns and Conducted Tests

- **row_id**
  - *Description:* Unique ID for each row.
  - *Tests:*
    - unique
    - not_null

- **order_id**
  - *Description:* Unique Order ID for each Customer.
  - *Tests:*
    - not_null

- **order_date**
  - *Description:* Order Date of the product.

- **ship_date**
  - *Description:* Shipping Date of the Product.

- **ship_mode**
  - *Description:* Shipping Mode specified by the Customer.
  - *Tests:*
    - accepted_values:
      - Standard Class
      - Second Class
      - First Class
      - Same Day
      

- **customer_id**
  - *Description:* Unique ID to identify each Customer.
  - *Tests:*
    - not_null

- **customer_name**
  - *Description:* Name of the Customer.

- **segment**
  - *Description:* The segment where the Customer belongs.
  - *Tests:*
    - accepted_values:
      - Consumer
      - Corporate
      - Home Office

- **country**
  - *Description:* Country of residence of the Customer.

- **city**
  - *Description:* City of residence of the Customer.

- **state**
  - *Description:* State of residence of the Customer.

- **postal_code**
  - *Description:* Postal Code of every Customer.

- **region**
  - *Description:* Region where the Customer belongs.

- **product_id**
  - *Description:* ID of the Product.
  - *Tests:*
    - not_null

- **category**
  - *Description:* Category of the product ordered.

- **subcategory**
  - *Description:* Sub-Category of the product ordered.

- **product_name**
  - *Description:* Name of the Product.

- **sales**
  - *Description:* Sales of the Product.

- **quantity**
  - *Description:* Quantity of the Product.

- **discount**
  - *Description:* Discount provided.

- **profit**
  - *Description:* Profit/Loss incurred.

## Data Cleansing and Preparation with Conducted Tests

- In the cleanup process, no issues required attention except for situations where it was observed
  that, in instances where a customer, order, product, and region were identical, there might be several 
  rows, each depicting the same product within the same order. In such cases, the sales, quantity, 
  and profit values for that product in that order were aggregated, while the discount remained unchanged.

- Tests were carried out to ensure the presence of non-null values for attributes such as 
  `order_date`, `ship_date`, `ship_mode`, `customer_name`, `segment`, `country`, `city`, 
  `state`, `postal_code`, `region`, `category`, `subcategory`, and `product_name`.

  These attributes are crucial for dimensions, and having descriptive values is considered optimal.

- Additionally, examinations were conducted on `sales` to ensure they consistently maintain positive values, 
  on `quantity` to guarantee a minimum of one, and on `discount` to confirm values are greater than or equal 
  to zero and less than one.

## Star Schema 

![Alt Text](https://drive.google.com/uc?export=download&id=1RCPzwLtc5Xa6YByY5yAfYiUIbZNLyrM_)

The star schema is composed of the following key elements:

### Sales Fact Table

A sales fact table in which each row corresponds to an item per order, with the combined foreign keys of 
customer ID, region iterative key, order ID, and product iterative key serving as the primary key. The 
attributes encompassed by this fact table are:

- row_id
- sales
- quantity
- discount
- profit
- customer_id
- region_iterative_key
- order_id
- product_iterative_key

Tests were conducted on this fact table to verify the uniqueness of the combination of foreign keys
and to ensure referential integrity between the fact table and each of the dimensions.

### Customer Dimension

A customer dimension containing details related to customers, with customer ID serving as the primary key. 
The attributes included in this dimension are:

- customer_id
- customer_name
- segment

While it is generally advisable to utilize an incremental key as the primary key, 
particularly when merging multiple tables, the small size of the dataset has led to 
the decision to use the customer ID as the primary key.

Tests were also carried out on this dimension to validate the uniqueness of customer IDs.

### Region Dimension

A region dimension containing details related to customers' locations with an iterative key 
serving as the primary key. The attributes included in this dimension are:

- country
- region
- state 
- city
- postal_code
- region_iterative_key

Tests were carried out on this dimension to validate the uniqueness of the region key.

### Date Dimension

A date dimension comprising date values ranging from "2014-01-03" to "2018-01-06" with a 
numeric key corresponding to the date serving as the primary key. The attributes encompassed are:

- date_value
- year_value
- quarter_value
- month_value
- day_value
- date_key

Tests were carried out on this dimension to validate the uniqueness of the date key.

### Order Dimension

An order dimension containing details related to orders, with order ID serving as the primary key.
The attributes included in this dimension are:

- order_id
- order_date
- ship_date
- ship_mode

While it is generally advisable to utilize an incremental key as the primary key, 
particularly when merging multiple tables, the small size of the dataset has led to 
the decision to use the order ID as the primary key.

Even though integrating order ID, order date, ship date, and ship mode directly into the fact table
would necessitate only one join for accessing date values, the decision was made to preserve a 
distinct Order dimension. This choice is driven by the small dataset, and the need for a clearer 
understanding of the business case. Additionally, in the event of changes to order-related attributes, 
maintaining a separate Order dimension proves to be more straightforward, as updates only need to 
be made within that specific dimension.

Tests were also carried out on this dimension to validate the uniqueness of order IDs and 
to ensure referential integrity between this dimension's date fields and the date dimension.

### Product Dimension

A product dimension containing details related to products, with an iterative key 
serving as the primary key. The attributes included in this dimension are:

- product_id
- product_name
- category
- subcategory
- product_iterative_key

The uniqueness of the product ID is compromised, as it is estimated that certain products, 
upon becoming extinct, had their IDs repurposed for newer products. The absence of specific 
dates indicating these changes makes incorporation into a slowly changing dimension impractical. 
As a result, the current approach adopts an iterative key to handle this situation.

Tests were also carried out on this dimension to validate the uniqueness of the product key.

## Analytics 

Multiple queries were run to conduct analyses on the data.

### Query 1 (Monthly Customer Sales)
- This query aims to retrieve the monthly sales data for each customer.

## Project File Structure:

The project files are organized as follows:

- **Staging Folder:**
  - Contains data cleansing processes.
  - Located within the Models folder.

- **DWH Folder:**
  - Houses the sales fact table and dimensions.
  - Located within the Models folder.

- **Analytics Folder:**
  - Contains queries.
  - Located within the Models folder.

- **tests Folder:**
  - Contains singular tests.

## Data Source and Dictionary

For data retrieval and obtaining additional information on data fields, please refer to [this](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final?resource=download).
