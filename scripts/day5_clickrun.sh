cat > .vscode/launch.json <<'JSON'
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Day5: Autoload CSV → stage.raw_ecommerce",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/scripts/sql/day5_autoload_csv.py",
      "args": [
        "--csv", "datasets/ecommerce_sales.csv",
        "--schema", "stage",
        "--table", "raw_ecommerce"
      ],
      "console": "integratedTerminal",
      "envFile": "${workspaceFolder}/.env"
    },
    {
      "name": "Day5: Spark agg (sales by category)",
      "type": "python",
      "request": "launch",
      "program": "${workspaceFolder}/scripts/pyspark/spark_agg_sales.py",
      "args": [
        "--input", "datasets/ecommerce_sales.csv",
        "--output", "data/processed/day5/sales_by_category"
      ],
      "console": "integratedTerminal",
      "envFile": "${workspaceFolder}/.env"
    },
    {
      "name": "Day4: Build dictionaries (from columns_*.csv)",
      "type": "python",
      "request": "launch",
      "module": "runpy",
      "pythonArgs": ["-c"],
      "args": [
        "import csv,glob,pathlib;out=pathlib.Path('artifacts/day4');out.mkdir(parents=True,exist_ok=True);"
        "import sys;"
        "import builtins;"
        "import csv,glob,pathlib;"
        "out=pathlib.Path('artifacts/day4');"
        "import csv,glob,pathlib;"
        "for p in glob.glob('artifacts/day4/columns_*.csv'):"
        "  t=pathlib.Path(p).stem.replace('columns_','');"
        "  rows=list(csv.DictReader(open(p,newline='',encoding='utf-8')));"
        "  rows.sort(key=lambda r:int(r.get('ordinal_position',0) or 0));"
        "  md=out/f'dictionary_{t}.md';"
        "  w=open(md,'w',encoding='utf-8');"
        "  w.write(f'# Data Dictionary — {t}\\n\\n| # | column | data_type | nullable | default |\\n|---:|---|---|:--:|---|\\n');"
        "  [w.write(f\"| {r.get('ordinal_position','')} | {r.get('column_name','')} | {r.get('data_type','')} | {r.get('is_nullable','')} | {r.get('column_default','')} |\\n\") for r in rows];"
        "  w.close();"
        "print('done')"
      ],
      "console": "integratedTerminal",
      "envFile": "${workspaceFolder}/.env"
    }
  ]
}
JSON
