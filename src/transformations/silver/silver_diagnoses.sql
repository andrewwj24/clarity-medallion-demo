-- ============================================================================
-- Silver Layer: Cleaned Diagnosis Data
-- Standardizes diagnosis records and enforces a valid billing code constraint.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW silver_diagnoses (
  CONSTRAINT valid_billing_code EXPECT (DX_ID IS NOT NULL AND REF_BILL_CODE_NAME IS NOT NULL) ON VIOLATION DROP ROW
)
COMMENT 'Cleaned diagnosis records with billing code validation'
AS
SELECT
  DX_ID,
  PAT_ID,
  PAT_ENC_CSN_ID,
  REF_BILL_CODE_NAME,
  DX_DATE,
  RESOLVED_DATE,
  CASE
    WHEN RESOLVED_DATE IS NULL THEN TRUE
    ELSE FALSE
  END AS is_active,
  ingested_at
FROM bronze_diagnoses;
