# Clarity medallion SDP demo

One Lakeflow Spark Declarative Pipeline builds a small, Clarity-shaped healthcare demo from **synthetic Synthea data**. The three source mappings used to seed the original demo are folded into its bronze definitions. No customer data is included.

```
Databricks sample CSVs (patients, encounters, conditions)
  -> 3 Clarity-shaped bronze views
  -> 3 silver views
  -> 4 gold views (two with column masks)
```

The source files are pre-staged in Databricks at `/databricks-datasets/rwe/ehr/csv/`. The repo does not contain those CSVs. Check that your workspace can read that path before running the pipeline.

## Run it

1. In a Databricks SQL editor, run [setup.sql](setup.sql). It creates the schema and two mask functions used by the gold views. If your catalog is not `main`, change `USE CATALOG main` in that file and pass the same catalog to the bundle commands below.
2. Deploy and run the pipeline from this directory:

   ```bash
   databricks bundle validate -t dev --profile <profile> --var 'catalog=main'
   databricks bundle deploy -t dev --profile <profile> --var 'catalog=main'
   databricks bundle run clarity_medallion -t dev --profile <profile> --var 'catalog=main'
   ```

The pipeline writes to `main.clarity_medallion_demo` by default. To use another schema, change `setup.sql` and pass `--var 'schema=<schema>'` to each command.

## What generated the initial data?

The original demo pipeline read three pre-existing, Clarity-shaped tables. A separate pipeline created those tables from Databricks' pre-staged **Synthea** CSVs:

| Clarity-shaped view | Synthetic input |
| --- | --- |
| `clarity_raw_patient` | `patients.csv` |
| `clarity_raw_pat_enc` | `encounters.csv` |
| `clarity_raw_diagnosis` | `conditions.csv` |

The three mappings are in `src/transformations/bronze/`. Each bronze view reads its Synthea CSV directly, so this repo has no dependency on the original source pipeline. It creates the same ten user-facing views as the demo.

## Scope

This is a demonstration using synthetic records shaped like a subset of Epic Clarity. It is not an Epic export or a production ingestion design. The included mask functions always hide protected values in the masked gold views; the unmasked views remain separate for comparison.
