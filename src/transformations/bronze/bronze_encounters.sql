-- Synthetic Synthea CSV mapped directly to a Clarity-shaped bronze view.
CREATE OR REFRESH MATERIALIZED VIEW bronze_encounters (
  CONSTRAINT valid_csn EXPECT (PAT_ENC_CSN_ID IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_patient EXPECT (PAT_ID IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_contact_date EXPECT (CONTACT_DATE IS NOT NULL)
)
COMMENT 'Raw Epic Clarity PAT_ENC table. One row per patient encounter (any care setting). Sourced from Synthea encounters.csv.'
TBLPROPERTIES ('quality' = 'bronze')
AS SELECT
  Id                                      AS PAT_ENC_CSN_ID,
  PATIENT                                 AS PAT_ID,
  PROVIDER                                AS VISIT_PROV_ID,
  ENCOUNTERCLASS                          AS ENC_TYPE_C,
  CODE                                    AS ENC_REASON_CODE,
  DESCRIPTION                             AS ENC_REASON_DESC,
  REASONCODE                              AS DX_PRIMARY_CODE,
  REASONDESCRIPTION                       AS DX_PRIMARY_DESC,
  CAST(START AS TIMESTAMP)                AS CONTACT_DATE,
  CAST(STOP AS TIMESTAMP)                 AS ENC_END_DATE,
  CAST(COST AS DECIMAL(12,2))             AS ENC_TOT_CHG,
  current_timestamp()                     AS _LOAD_TIMESTAMP,
  _metadata.file_path                     AS _SOURCE_FILE_PATH,
  current_timestamp()                     AS ingested_at
FROM read_files(
  '/databricks-datasets/rwe/ehr/csv/encounters.csv',
  format => 'csv',
  header => true
);
