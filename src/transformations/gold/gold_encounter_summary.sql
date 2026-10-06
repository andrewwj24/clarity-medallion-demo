-- ============================================================================
-- Gold Layer: Encounter Summary
-- Enriched encounter-level view with patient demographics and clinical metrics.
-- All patient-like values in this demo are synthetic.
--
-- For aggregate analytics (monthly volume, avg LOS, avg charges by encounter
-- type), layer a simple GROUP BY on top of this table.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW gold_encounter_summary
COMMENT 'Encounter summary with clinical metrics and synthetic patient demographics'
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
