# Clarity medallion SDP demo

One Lakeflow Spark Declarative Pipeline builds a small, Clarity-shaped healthcare demo from synthetic records generated in SQL. No customer data or source files are included.

```
SQL-generated patients, encounters, and diagnoses
  -> 3 Clarity-shaped bronze materialized views
  -> 3 silver views
  -> 2 gold views
```

The bronze SQL creates 200 patients, 400 encounters, and 400 diagnoses. Patient and encounter IDs match across views. The pipeline does not read `/databricks-datasets`, a volume, or any pre-existing table. It creates the source records in the destination workspace when it runs.

## Run it

1. Clone this public repo on a computer with the Databricks CLI:

   ```bash
   git clone https://github.com/andrewwj24/clarity-medallion-demo.git
   cd clarity-medallion-demo
   ```

2. Create the target schema once in a Databricks SQL editor (skip this if it already exists):

   ```sql
   CREATE SCHEMA IF NOT EXISTS main.clarity_medallion_demo;
   ```

3. Deploy and run the pipeline from this directory:

   ```bash
   databricks bundle validate -t dev --profile <profile>
   databricks bundle deploy -t dev --profile <profile>
   databricks bundle run clarity_medallion -t dev --profile <profile>
   ```

The pipeline writes to `main.clarity_medallion_demo` by default. For another catalog or schema, use those names in the `CREATE SCHEMA` statement and pass `--var 'catalog=<catalog>' --var 'schema=<schema>'` to each bundle command. No custom functions or source datasets are required.

The local `git clone` and bundle commands do not require a Databricks Git folder. Databricks also supports cloning a public repo into a Git folder without Git credentials. If the Git folder dialog selects an expired linked GitHub credential, deselect it for an anonymous clone or relink it using **View/edit your Git credentials**. Git credentials are needed to push changes back to GitHub. See [Databricks Git integration](https://docs.databricks.com/aws/en/repos/repos-setup).

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
