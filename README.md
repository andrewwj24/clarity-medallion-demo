# Clarity medallion SDP demo

One Lakeflow Spark Declarative Pipeline builds a small, Clarity-shaped healthcare demo from synthetic records generated in SQL. No customer data or source files are included.

```
SQL-generated patients, encounters, and diagnoses
  -> 3 Clarity-shaped bronze materialized views
  -> 3 silver views
  -> 2 gold views
```

The bronze SQL creates 200 patients, 400 encounters, and 400 diagnoses. Patient and encounter IDs match across views. The pipeline does not read `/databricks-datasets`, a volume, or any pre-existing table. It creates the source records in the destination workspace when it runs.

## Run it in the Databricks UI

1. In **Workspace**, create a **Git folder** from `https://github.com/andrewwj24/clarity-medallion-demo.git`. Databricks recognizes the `databricks.yml` file at the root as a bundle. A public repo can be cloned for reading without a GitHub credential.
2. Choose an existing Unity Catalog catalog and schema. If you need a new schema, create one in **Catalog Explorer** first.
3. In the Git folder, open `databricks.yml`. Under `variables`, change the `catalog` and `schema` **default** values to the names you chose, then save the file. The checked-in values, `main` and `clarity_medallion_demo`, are examples; each workspace can use its own values.
4. Click the **Deployments** icon, select the `dev` target, click **Deploy**, and confirm. Databricks validates the bundle as part of deployment.
5. In **Bundle resources**, click the **Run** (play) icon for **Clarity Medallion Demo**. After it completes, find the eight materialized views in your chosen catalog and schema in **Catalog Explorer**.

The pipeline generates its own synthetic source records. No file upload, custom function, or command-line setup is needed. See [Databricks' workspace bundle instructions](https://docs.databricks.com/aws/en/dev-tools/bundles/workspace-deploy) for screenshots of the Deployments and Bundle resources controls.

## What generated the initial data?

The original FEVM demo read three pre-existing, Clarity-shaped tables. A separate pipeline seeded them from Databricks' pre-staged **Synthea** CSVs:

| Clarity-shaped view | Synthetic input |
| --- | --- |
| `clarity_raw_patient` | `patients.csv` |
| `clarity_raw_pat_enc` | `encounters.csv` |
| `clarity_raw_diagnosis` | `conditions.csv` |

This portable version generates representative synthetic records in `src/transformations/bronze/`. It builds eight bronze, silver, and gold materialized views, but its records are not copies of the original Synthea data.

## Scope

This is a demonstration using synthetic records shaped like a subset of Epic Clarity. It is not an Epic export or a production ingestion design. The gold views contain synthetic patient names, record numbers, birth dates, and addresses; do not use these definitions with real patient data without adding appropriate access controls.
