python3 - <<'PY'
import csv, glob, pathlib
out_dir = pathlib.Path("artifacts/day4"); out_dir.mkdir(parents=True, exist_ok=True)
def pick(row,*keys,default=""): 
    for k in keys:
        if k in row: return row[k]
    return default
wrote=[]
for path in glob.glob("artifacts/day4/columns_*.csv"):
    table = pathlib.Path(path).stem.replace("columns_","")
    md = out_dir / f"dictionary_{table}.md"
    with open(path, newline='', encoding='utf-8') as f, md.open("w", encoding="utf-8") as w:
        r = csv.DictReader(f)
        rows=list(r)
        # best-effort sort by ordinal_position when present
        def pos(x):
            v=pick(x,"ordinal_position","position","col_position",default="0")
            try: return int(v)
            except: return 0
        rows.sort(key=pos)
        w.write(f"# Data Dictionary — {table}\n\n")
        w.write("| # | column | data_type | nullable | default |\n|---:|---|---|:--:|---|\n")
        for row in rows:
            w.write(f"| {pick(row,'ordinal_position','position')} | "
                    f"{pick(row,'column_name','col_name','name')} | "
                    f"{pick(row,'data_type','udt_name','type')} | "
                    f"{pick(row,'is_nullable','nullable')} | "
                    f"{pick(row,'column_default','default')} |\n")
    wrote.append(str(md))
print("Wrote:", *wrote, sep="\n  ")
PY
