# Per-table data dictionaries from columns_*.csv
python3 - <<'PY'
import csv, glob, pathlib
out = pathlib.Path("artifacts/day4"); out.mkdir(parents=True, exist_ok=True)
for p in glob.glob("artifacts/day4/columns_*.csv"):
  t = pathlib.Path(p).stem.replace("columns_","")
  md = out / f"dictionary_{t}.md"
  rows = list(csv.DictReader(open(p, newline='', encoding='utf-8')))
  rows.sort(key=lambda r: int(r.get('ordinal_position',0) or 0))
  with md.open("w", encoding="utf-8") as w:
    w.write(f"# Data Dictionary — {t}\n\n| # | column | data_type | nullable | default |\n|---:|---|---|:--:|---|\n")
    for r in rows:
      w.write(f"| {r.get('ordinal_position','')} | {r.get('column_name','')} | {r.get('data_type','')} | {r.get('is_nullable','')} | {r.get('column_default','')} |\n")
print("ok")
PY

# Mermaid ERD from foreign keys
python3 - <<'PY'
import csv, pathlib
fk = pathlib.Path("artifacts/day4/fkeys.csv"); out = pathlib.Path("artifacts/day4/ERD_from_metadata.md")
rels=[]; tables=set()
for r in csv.DictReader(open(fk, encoding="utf-8")):
  s=f"{r['src_schema']}.{r['src_table']}"; t=f"{r['tgt_schema']}.{r['tgt_table']}"; c=r['src_column']
  rels.append((s,t,c)); tables.update([s,t])
with out.open("w", encoding="utf-8") as w:
  w.write("# ERD (auto-generated from foreign keys)\n\n```mermaid\nerDiagram\n")
  for s,t,c in rels: w.write(f"  {s.replace('.','_')} ||--o{{ {t.replace('.','_')} : {c}\n")
  for t in sorted(tables): w.write(f"\n  {t.replace('.','_')} {{\n    -- columns omitted (see dictionaries) --\n  }}\n")
  w.write("\n```\n")
print("ok")
PY
