-- Synthetic Synthea CSV mapped directly to a Clarity-shaped bronze view.
CREATE OR REFRESH MATERIALIZED VIEW bronze_diagnoses (
  CONSTRAINT valid_patient EXPECT (PAT_ID IS NOT NULL) ON VIOLATION DROP ROW,
  CONSTRAINT valid_dx_code EXPECT (DX_ID IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT 'Raw Epic Clarity DIAGNOSIS table. SNOMED-coded encounter diagnoses. Sourced from Synthea conditions.csv.'
TBLPROPERTIES ('quality' = 'bronze')
AS SELECT
  CODE                                    AS DX_ID,
  PATIENT                                 AS PAT_ID,
  ENCOUNTER                               AS PAT_ENC_CSN_ID,
  DESCRIPTION                             AS REF_BILL_CODE_NAME,
  CAST(START AS DATE)                     AS DX_DATE,
  CAST(STOP AS DATE)                      AS RESOLVED_DATE,
  current_timestamp()                     AS _LOAD_TIMESTAMP,
  _metadata.file_path                     AS _SOURCE_FILE_PATH,
  current_timestamp()                     AS ingested_at
FROM read_files(
  '/databricks-datasets/rwe/ehr/csv/conditions.csv',
  format => 'csv',
  header => true
);
