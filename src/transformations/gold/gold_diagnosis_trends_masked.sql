-- ============================================================================
-- Gold Layer: Diagnosis Trends (PHI Masked)
-- Identical to gold_diagnosis_trends but applies column-level masking on
-- PHI fields. the included mask functions hide protected values for every viewer.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW gold_diagnosis_trends_masked (
  year_month          DATE,
  diagnosis_name      STRING,
  diagnosis_code      BIGINT,
  patient_name        STRING      MASK phi_mask_string,
  PAT_MRN_ID          STRING      MASK phi_mask_string,
  birth_date          DATE        MASK phi_mask_date,
  encounter_id        STRING,
  DX_DATE             DATE,
  RESOLVED_DATE       DATE,
  is_active           BOOLEAN
)
COMMENT 'Diagnosis trends with PHI column masking for governance demo'
CLUSTER BY (year_month, diagnosis_name)
AS
SELECT
  CAST(DATE_TRUNC('month', d.DX_DATE) AS DATE) AS year_month,
  d.REF_BILL_CODE_NAME                AS diagnosis_name,
  d.DX_ID                            AS diagnosis_code,
  p.pat_first_name || ' ' || p.pat_last_name AS patient_name,
  p.PAT_MRN_ID,
  p.birth_date,
  d.PAT_ENC_CSN_ID                   AS encounter_id,
  d.DX_DATE,
  d.RESOLVED_DATE,
  d.is_active
FROM silver_diagnoses d
JOIN silver_patients p ON d.PAT_ID = p.PAT_ID;
