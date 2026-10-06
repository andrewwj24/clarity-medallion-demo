-- ============================================================================
-- Silver Layer: Cleaned Patient Demographics
-- Standardizes names to proper case, pads ZIP codes, and enforces
-- data quality requiring valid patient ID and MRN.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW silver_patients (
  CONSTRAINT valid_pat_id  EXPECT (PAT_ID IS NOT NULL)     ON VIOLATION DROP ROW,
  CONSTRAINT valid_mrn     EXPECT (PAT_MRN_ID IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT 'Cleaned and standardized patient demographics with quality enforcement'
AS
SELECT
  PAT_ID,
  PAT_MRN_ID,
  INITCAP(NAME_PREFIX)       AS name_prefix,
  INITCAP(PAT_FIRST_NAME)    AS pat_first_name,
  INITCAP(PAT_LAST_NAME)     AS pat_last_name,
  INITCAP(NAME_SUFFIX)       AS name_suffix,
  INITCAP(PAT_MAIDEN_NAME)   AS pat_maiden_name,
  MARITAL_STATUS_C,
  SEX_C,
  INITCAP(RACE_C)            AS race,
  INITCAP(ETHNIC_GROUP_C)    AS ethnicity,
  CAST(BIRTH_DATE AS DATE)   AS birth_date,
  CAST(DEATH_DATE AS DATE)   AS death_date,
  ADD_LINE_1,
  INITCAP(CITY)              AS city,
  UPPER(STATE_C)             AS state,
  LPAD(CAST(ZIP AS STRING), 5, '0') AS zip,
  BIRTHPLACE,
  ingested_at
FROM bronze_patients;
