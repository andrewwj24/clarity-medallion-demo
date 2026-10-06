-- ============================================================================
-- Silver Layer: Cleaned Encounter Data
-- Joins to silver_patients for demographic enrichment, derives length of stay,
-- and enforces quality constraints on contact dates and charges.
-- ============================================================================

CREATE OR REFRESH MATERIALIZED VIEW silver_encounters (
  CONSTRAINT valid_contact_date   EXPECT (CONTACT_DATE IS NOT NULL)                              ON VIOLATION DROP ROW,
  CONSTRAINT contact_before_end   EXPECT (CONTACT_DATE <= ENC_END_DATE OR ENC_END_DATE IS NULL),
  CONSTRAINT non_negative_charges EXPECT (ENC_TOT_CHG >= 0)
)
COMMENT 'Cleaned encounters enriched with patient demographics and derived length of stay'
AS
SELECT
  e.PAT_ENC_CSN_ID,
  e.PAT_ID,
  e.VISIT_PROV_ID,
  e.ENC_TYPE_C,
  e.ENC_REASON_CODE,
  e.ENC_REASON_DESC,
  e.DX_PRIMARY_CODE,
  e.DX_PRIMARY_DESC,
  e.CONTACT_DATE,
  e.ENC_END_DATE,
  e.ENC_TOT_CHG,
  ROUND(TIMESTAMPDIFF(HOUR, e.CONTACT_DATE, e.ENC_END_DATE) / 24.0, 2) AS length_of_stay_days,

  -- Patient demographics (stream-static join)
  p.pat_first_name || ' ' || p.pat_last_name AS patient_name,
  p.PAT_MRN_ID,
  p.birth_date,
  p.death_date,
  p.ADD_LINE_1 AS address,

  e.ingested_at
FROM bronze_encounters e
JOIN silver_patients p ON e.PAT_ID = p.PAT_ID;
