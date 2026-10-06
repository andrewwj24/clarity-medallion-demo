-- ============================================================================
-- Gold Layer: Diagnosis Trends (Unmasked)
-- Enriched diagnosis-level view joining to silver_patients for demographics.
-- Includes PHI columns in cleartext — toggle with gold_diagnosis_trends_masked
-- to demonstrate column-level governance.
--
-- For aggregate analytics (monthly diagnosis counts, top diagnoses by volume),
-- layer a simple GROUP BY on top of this table.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW gold_diagnosis_trends
COMMENT 'Diagnosis trends with patient demographics (unmasked)'
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
