-- Synthetic Synthea CSV mapped directly to a Clarity-shaped bronze view.
CREATE OR REFRESH MATERIALIZED VIEW bronze_patients (
  CONSTRAINT valid_pat_id EXPECT (PAT_ID IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_birth_date EXPECT (BIRTH_DATE IS NOT NULL)
)
COMMENT 'Raw Epic Clarity PATIENT table. Demographics, vitals identity, deceased status. Sourced from Synthea patients.csv.'
TBLPROPERTIES ('quality' = 'bronze')
AS SELECT
  Id                                      AS PAT_ID,
  REGEXP_REPLACE(COALESCE(SSN,''),'-','') AS PAT_MRN_ID,
  PREFIX                                  AS NAME_PREFIX,
  FIRST                                   AS PAT_FIRST_NAME,
  LAST                                    AS PAT_LAST_NAME,
  SUFFIX                                  AS NAME_SUFFIX,
  MAIDEN                                  AS PAT_MAIDEN_NAME,
  MARITAL                                 AS MARITAL_STATUS_C,
  GENDER                                  AS SEX_C,
  RACE                                    AS RACE_C,
  ETHNICITY                               AS ETHNIC_GROUP_C,
  CAST(BIRTHDATE AS DATE)                 AS BIRTH_DATE,
  CAST(DEATHDATE AS DATE)                 AS DEATH_DATE,
  ADDRESS                                 AS ADD_LINE_1,
  CITY                                    AS CITY,
  STATE                                   AS STATE_C,
  ZIP                                     AS ZIP,
  BIRTHPLACE                              AS BIRTHPLACE,
  current_timestamp()                     AS _LOAD_TIMESTAMP,
  _metadata.file_path                     AS _SOURCE_FILE_PATH,
  current_timestamp()                     AS ingested_at
FROM read_files(
  '/databricks-datasets/rwe/ehr/csv/patients.csv',
  format => 'csv',
  header => true
);
