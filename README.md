# Project Overview

This project involves a multi-step process aimed at loading, transforming and analyzing data using Snowflake and dbt. The key stages include loading raw data, cleansing it, establishing a star schema, and executing queries.

## Snowflake Setup

**Databases Creation:**
- Two databases were created within Snowflake—one for raw data and another for analytics.

**Data Loading:**
- A storage integration object was crafted to facilitate loading raw data from an S3 bucket.
- Two file formats were designed for 2016 sale files and 2017/2018 files, addressing issues like data trimming and handling commas within fields.
- Distinct format adjustments were applied. For the 2016 format, 22 lines were removed, serving as headers. In contrast, the 2017/2018 format omitted 20 lines and introduced a specific date format.
- A stage was established to copy raw data from the S3 bucket to a table in the raw database. The `sale_year` column was updated after loading each file to reflect the source year.

## Data Cleansing and Preparation

- Detailed data cleansing ensured accuracy and consistency.
- Format-specific adjustments were made, such as skipping headers and specifying date formats.

## Star Schema Creation

The project involved designing and implementing a star schema to optimize analytics. This structured the data into a star-like format, enhancing query performance.

## Analytics with dbt

The project concluded with the execution of multiple queries using dbt (data build tool). dbt transformed the prepared data, providing valuable insights.

This README provides an overview of the comprehensive approach to handling data—from loading raw information into Snowflake to executing refined queries using dbt.