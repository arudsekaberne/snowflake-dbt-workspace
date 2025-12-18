# snowflake-dbt-workspace

## 🚀 Overview
The `snowflake-dbt-workspace` project is designed to orchestrate an end-to-end ELT (Extract, Load, Transform) pipeline using dbt and Snowflake. It provides a structured approach to data transformation across multiple layers—from raw landing data through intermediate staging to refined gold-layer analytics tables. This project is ideal for data engineers and analytics professionals building scalable data warehouses on Snowflake.

## ✨ Features
- **Multi-Layer Architecture**: Structured ELT pipeline from landing to gold layers
- **dbt Integration**: Leverage dbt for scalable and maintainable data transformations
- **Snowflake Native**: Optimized for Snowflake's cloud data warehouse capabilities
- **Modular Design**: Easily extend and customize transformation logic

## 🛠️ Tech Stack
- **Transformation Tool**: dbt
- **Data Warehouse**: Snowflake
- **SQL Dialect**: Snowflake SQL

## 📦 Installation

### Prerequisites
- Snowflake account with appropriate permissions

### Quick Start

#### 1. Clone the Repository
```bash
git clone https://github.com/arudsekaberne/snowflake-dbt-workspace.git
cd snowflake-dbt-workspace
```

#### 2. Set Up Snowflake Initial Objects
Before running dbt, execute the first 3 SQL setup files in Snowflake to initialize required objects and schemas:

```bash
# Navigate to the SQL setup directory
cd snowflake_sql/elt_pipeline

# Run these three files in order in your Snowflake account:
# 1-git-integration.sql
# 2-snowflake-setup.sql
# 3-dbt-integration.sql
```

This creates the necessary warehouse, database, schemas, and role configurations for the pipeline.

#### 3. Configure dbt Profile
Update your `~/.dbt/profiles.yml` file with Snowflake connection details:

```yaml
snowflake_workspace:
  target: dev
  outputs:
    dev:
      type: snowflake
      account: [your-account-id]
      role: [your-role]
      warehouse: [your-warehouse]
      database: [your-database]
      schema: dev
```

#### 4. Run dbt Models
```bash
# Build all models
dbt run

# Test data quality
dbt test

# Generate documentation
dbt docs generate
```

## 📁 Project Structure
```
snowflake-dbt-workspace/
├── README.md
├── datahub_refinery/
│   ├── dbt_project.yml
│   ├── profiles.yml
│   ├── analysis/
│   │   └── (ad-hoc analysis SQL files)
│   ├── macros/
│   │   └── (custom macros for schema & policy management)
│   ├── models/
│   │   ├── bronze/
│   │   │   └── source/
│       |       └── (table models, e.g., bronze_source_listings.sql)
│   │   └── gold/
│   │   │   └── source/
│       |       └── (incremental models, e.g., gold_source_listings.sql)
│   ├── seeds/
│   │   └── (static data CSV files)
│   ├── snapshots/
│   │   ├── silver/
│   │   │   └── source/
│       |       └── (snapshot models, e.g., silver_source_listings.sql)
│   ├── tests/
│   │   └── (custom test cases)
│   └── packages.yml
├── snowflake_sql/
│   └── elt_pipeline/
│       ├── (setup scripts)
│       └── (additional validation scripts)
└── .gitignore
```

## 🏗️ ELT Pipeline Architecture

The project follows a standard medallion architecture with clearly defined layers:

- **Landing Layer**: Source data is ingested as-is with audit columns using a truncate-and-load strategy.
- **Bronze Layer**: Data is moved from landing to bronze with basic data type casting applied using truncate-and-load.
- **Silver Layer**: Data is transformed from bronze to silver using Slowly Changing Dimension (SCD) Type 2 to maintain historical changes.
- **Gold Layer**: Data is curated from silver to gold with dimension and fact tables using SCD Type 1 for analytics-ready consumption.

## 🔧 Configuration

### dbt Configuration
Modify `dbt_project.yml` to customize:
- Project name and version
- Model materialization strategies (table, view, incremental)

### Data Testing
```bash
# Run all data quality tests
dbt test

# Run specific tests
dbt test --select model_name
```
