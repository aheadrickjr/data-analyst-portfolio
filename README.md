# data-analyst-portfolio

# Data Analyst Portfolio  

**Arval Daniel Headrick Jr.**  
*Data Analyst | SQL • Python • BI Dashboards | Transitioning to Data Engineering*  

---

## 📊 About Me  
I am a Data Analyst with a strong foundation in SQL, Python, and Business Intelligence.  
I specialize in turning raw data into actionable insights, building dashboards, and optimizing reports.  
Currently building hands-on projects to demonstrate data storytelling, technical problem-solving, and readiness for consulting and analyst roles. 

Hands-on Data Analytics portfolio featuring SQL queries, Power BI dashboards, and Python data analysis projects. Built to demonstrate business insights and technical skills.
---

## 📂 Portfolio Projects  

| Project | Type | Tools | Link / Status |
|---------|------|-------|---------------|
| **Customer Analytics** | SQL | SQL Server, PostgreSQL | 🔄 In Progress |
| **Sales & Revenue Trends Dashboard** | BI | Power BI | 🔄 In Progress |
| **Financial Trends SQL Project** | SQL | SQL Server, PostgreSQL | 🔄 In Progress |
| **Customer Churn Dashboard** | BI | Power BI | 🔄 In Progress |
| **Public Health Data Exploration** | Python EDA | Python (pandas, matplotlib, seaborn) | 🔄 In Progress |

---

## 🚀 Roadmap (30-Day Sprint)
- [x] Day 1: Repo + README setup  
- [ ] Day 2–7: SQL + BI projects published  
- [ ] Week 2: Python EDA notebook uploaded  
- [ ] Week 3–4: Portfolio polish + job applications  

---

## 📬 Connect with Me  
- **LinkedIn:** [linkedin.com/in/arval-headrick-jr](https://linkedin.com/in/arval-headrick-jr)  
- **GitHub:** [github.com/aheadrickjr](https://github.com/aheadrickjr)  

---

## 📁 Repo Layout

data-analyst-portfolio/
├─ datasets/ # CSVs and raw data
├─ projects/
│ ├─ sql/ # .sql files + READMEs
│ ├─ bi/ # .pbix exports + images
│ └─ python/ # notebooks (.ipynb) and scripts
└─ assets/
└─ screenshots/ # dashboard & chart images for README

## Day 4 — PostgreSQL Metadata & ERD

**Goal:** Capture database metadata (tables, columns, keys, sizes), export CSVs, and produce a lightweight ERD + per-table data dictionaries.

**Deliverables (in repo):**
- CSVs: `artifacts/day4/` → `tables.csv`, `tables_like.csv`, `columns_<table>.csv`, `indexes_<table>.csv`, `pkeys_<table>.csv`, `rowcount_<table>.csv`, `fkeys.csv`
- ERD:
  - Template: `docs/models/ERD_Template.md`
  - Auto-generated (from FKs): `artifacts/day4/ERD_from_metadata.md`
- Data dictionaries: `artifacts/day4/dictionary_<table>.md`
- Runners:
  - SQL exports: `scripts/sql/run_metadata_sql.sh`
  - Day-4 convenience: `scripts/day4/meta_runsqls_day4.sh` *(if present)*

**Prereqs (WSL):**
- Python venv: `sudo apt install -y python3-venv` (or `python3.12-venv`)
- Postgres client: `sudo apt install -y postgresql-client`
- `.env` set for local socket auth (no host):  
  ```ini
  PGUSER=arval
  PGDATABASE=postgres
  # PGHOST unset to prefer Unix socket; set PGSSLMODE=prefer or comment it out

