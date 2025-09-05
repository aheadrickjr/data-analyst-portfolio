python3 - <<'PY'
import csv, pathlib, sys
fk_csv = pathlib.Path("artifacts/day4/fkeys.csv")
out = pathlib.Path("artifacts/day4/ERD_from_metadata.md")
if not fk_csv.exists():
    sys.exit("Missing artifacts/day4/fkeys.csv — run your fkeys export first.")

# maps to (src_schema, src_table, src_column, tgt_schema, tgt_table, tgt_column)
aliases = {
  "src_schema": ["src_schema","source_schema","table_schema","schema","from_schema"],
  "src_table":  ["src_table","source_table","table_name","from_table"],
  "src_column": ["src_column","source_column","column_name","fk_column","from_column"],
  "tgt_schema": ["tgt_schema","target_schema","ref_schema","to_schema"],
  "tgt_table":  ["tgt_table","target_table","ref_table","to_table"],
  "tgt_column": ["tgt_column","target_column","ref_column","to_column"]
}
def pick(row, keys): 
    for k in keys:
        if k in row and row[k]: return row[k]
    return ""

rels=[]; tables=set()
with fk_csv.open(encoding="utf-8") as f:
    r=csv.DictReader(f)
    for row in r:
        ssch=pick(row,aliases["src_schema"]); stab=pick(row,aliases["src_table"]); scol=pick(row,aliases["src_column"])
        tsch=pick(row,aliases["tgt_schema"]); ttab=pick(row,aliases["tgt_table"]); tcol=pick(row,aliases["tgt_column"])
        if not (ssch and stab and scol and tsch and ttab): 
            continue
        src=f"{ssch}.{stab}"; tgt=f"{tsch}.{ttab}"
        rels.append((src,tgt,scol))
        tables.update([src,tgt])

with out.open("w",encoding="utf-8") as w:
    w.write("# ERD (auto-generated from foreign keys)\n\n```mermaid\nerDiagram\n")
    for src,tgt,col in rels:
        w.write(f"  {src.replace('.','_')} ||--o{{ {tgt.replace('.','_')} : {col}\n")
    for t in sorted(tables):
        w.write(f"\n  {t.replace('.','_')} {{\n    -- columns omitted (see dictionaries) --\n  }}\n")
    w.write("\n```\n")
print("Wrote", out)
PY
