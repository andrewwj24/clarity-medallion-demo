# Clarity medallion SDP demo

One Lakeflow Spark Declarative Pipeline builds a small, Clarity-shaped healthcare demo from synthetic records generated in SQL. No customer data or source files are included.

```
SQL-generated patients, encounters, and diagnoses
  -> 3 Clarity-shaped bronze materialized views
  -> 3 silver views
  -> 4 gold views (two with column masks)
```

The bronze SQL creates 200 patients, 400 encounters, and 400 diagnoses. Patient and encounter IDs match across views. The pipeline does not read `/databricks-datasets`, a volume, or any pre-existing table. It creates the source records in the destination workspace when it runs.

## Run it

1. Clone this public repo on a computer with the Databricks CLI:

   ```bash
   git clone https://github.com/andrewwj24/clarity-medallion-demo.git
   cd clarity-medallion-demo
   ```

2. In a Databricks SQL editor, run [setup.sql](setup.sql). It creates the schema and two mask functions used by the gold views. If your catalog is not `main`, change `USE CATALOG main` in that file and pass the same catalog to the bundle commands below.
3. Deploy and run the pipeline from this directory:

   ```bash
   databricks bundle validate -t dev --profile <profile> --var 'catalog=main'
   databricks bundle deploy -t dev --profile <profile> --var 'catalog=main'
   databricks bundle run clarity_medallion -t dev --profile <profile> --var 'catalog=main'
   ```

The pipeline writes to `main.clarity_medallion_demo` by default. To use another schema, change `setup.sql` and pass `--var 'schema=<schema>'` to each command.

The local `git clone` and bundle commands do not require a Databricks Git folder. Databricks also supports cloning a public repo into a Git folder without Git credentials. If the Git folder dialog selects an expired linked GitHub credential, deselect it for an anonymous clone or relink it using **View/edit your Git credentials**. Git credentials are needed to push changes back to GitHub. See [Databricks Git integration](https://docs.databricks.com/aws/en/repos/repos-setup).

## What generated the initial data?

The original FEVM demo read three pre-existing, Clarity-shaped tables. A separate pipeline seeded them from Databricks' pre-staged **Synthea** CSVs:

| Clarity-shaped view | Synthetic input |
| --- | --- |
| `clarity_raw_patient` | `patients.csv` |
| `clarity_raw_pat_enc` | `encounters.csv` |
| `clarity_raw_diagnosis` | `conditions.csv` |

This portable version generates representative synthetic records in `src/transformations/bronze/`. It keeps the same ten-view bronze, silver, and gold graph, but its records are not copies of the original Synthea data.

## Scope

This is a demonstration using synthetic records shaped like a subset of Epic Clarity. It is not an Epic export or a production ingestion design. The included mask functions always hide protected values in the masked gold views; the unmasked views remain separate for comparison.
