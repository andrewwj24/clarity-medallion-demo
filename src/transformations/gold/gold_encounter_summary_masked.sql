-- ============================================================================
-- Gold Layer: Encounter Summary (PHI Masked)
-- Identical to gold_encounter_summary but applies column-level masking on
-- PHI fields. the included mask functions hide protected values for every viewer.
--
-- Toggle between this and the unmasked version during the demo to showcase
-- Databricks column-level governance capabilities.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW gold_encounter_summary_masked (
  year_month          DATE,
  encounter_type      STRING,
  encounter_id        STRING,
  patient_name        STRING      MASK phi_mask_string,
  PAT_MRN_ID          STRING      MASK phi_mask_string,
  birth_date          DATE        MASK phi_mask_date,
  address             STRING      MASK phi_mask_string,
  length_of_stay_days DECIMAL(24,2),
  total_charges       DECIMAL(12,2),
  mortality_flag      INT,
  encounter_reason    STRING,
  primary_diagnosis   STRING
)
COMMENT 'Encounter summary with PHI column masking for governance demo'
CLUSTER BY (year_month, encounter_type)
AS
SELECT
  CAST(DATE_TRUNC('month', CONTACT_DATE) AS DATE) AS year_month,
  ENC_TYPE_C                         AS encounter_type,
  PAT_ENC_CSN_ID                     AS encounter_id,
  patient_name,
  PAT_MRN_ID,
  birth_date,
  address,
  length_of_stay_days,
  ENC_TOT_CHG                        AS total_charges,
  CASE WHEN death_date IS NOT NULL
       THEN 1 ELSE 0
  END                                AS mortality_flag,
  ENC_REASON_DESC                    AS encounter_reason,
  DX_PRIMARY_DESC                    AS primary_diagnosis
FROM silver_encounters;
