-- 1. Git Integration
CREATE OR REPLACE API INTEGRATION SNOWFLAKE_DBT_WORKSPACE_GIT_INTEGRATION
    API_PROVIDER = git_https_api
    API_ALLOWED_PREFIXES = ('https://github.com/arudsekaberne/snowflake-dbt-workspace')
    API_USER_AUTHENTICATION = (type = SNOWFLAKE_GITHUB_APP )
    ENABLED = true
;

-- 2. Create NETWORK RULE for external access integration
CREATE OR REPLACE NETWORK RULE DBT_NETWORK_TOOL
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    'hub.getdbt.com',
    'codeload.github.com'
);

-- 3. Create EXTERNAL ACCESS INTEGRATION for dbt access to external dbt package locations
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION DBT_EXT_ACCESS
  ALLOWED_NETWORK_RULES = (DBT_NETWORK_TOOL)
  ENABLED = TRUE
;