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
| **Python EDA Notebook** | Data Science| Python (pandas, matplotlib)    | In Progress                     |
| **PySpark Aggregation** | Big Data    | Spark (PySpark), Parquet       | In Progress                     |
| **Kafka Streaming**     | Streaming   | Kafka, PostgreSQL              | In Progress                     |

---

## 🚀 Roadmap (30-Day Sprint)
- [x] Day 1: Repo + README setup  
- [x] Day 2–5: SQL + ETL projects published (Customer Analytics)  
- [ ] Day 6–7: BI dashboards integration  
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


---

## Day 4 — PostgreSQL Metadata & ERD

**Goal:** Build SQL toolkit to query database metadata (table/column search, PK/FK, row counts) and generate ERDs.  

**Deliverables:**
- SQL scripts: `projects/sql/meta_*.sql`
- Bash wrappers: `run_metadata_sql.sh`, `meta_runsqls_day4.sh`
- CSV exports under `artifacts/day4/`
- ERD template: `docs/models/erd_template.md`

**Notes:**  
Day 4 demonstrated ability to explore relational schemas, generate diagrams, and prep for modeling.

---

## Day 5 — Customer Analytics ETL (Staging → Star Schema)

**Goal:** Load ecommerce sales data into Postgres staging, normalize into a star schema (dim_date, dim_customer, dim_product, fact_sales), and export analytics-ready artifacts.

**Deliverables (in repo):**
- Staging: `stage.raw_ecommerce` (541,909 rows)
- DWH: `dwh.dim_date`, `dwh.dim_customer`, `dwh.dim_product`, `dwh.fact_sales`
- CSVs:  
  - `artifacts/day5/sales_by_country_summary.csv`  
  - `artifacts/day5/top_products_by_revenue.csv`
- Scripts:  
  - Autoloader: `scripts/sql/day5_autoload_csv.py`  
  - DWH schema: `scripts/sql/day5_create_tables.sql`  
  - Populate ETL: `scripts/sql/day5_populate_dim_fact.sql`  
  - Artifact exports: `scripts/sql/day5_export_artifacts.sh`

**Results:**
- dim_customer: 4,373  
- dim_date: 305  
- dim_product: 4,071  
- fact_sales: 1,083,818  

**Notes:**
- Transitioned development to Visual Studio Code (WSL).
- Implemented robust ETL pipeline: CSV → staging → star schema → analytics.
- Demonstrates end-to-end data engineering workflow.

---

## Next Steps

- Build BI dashboards (Day 6–7).  
- Add Python EDA notebooks (Week 2).  
- Extend to Spark (PySpark) and Kafka streaming demos.  
- Document results with screenshots, CSV artifacts, and logs in `docs/`.

**Prereqs (WSL):**
- Python venv: `sudo apt install -y python3-venv` (or `python3.12-venv`)
- Postgres client: `sudo apt install -y postgresql-client`
- `.env` set for local socket auth (no host):  
  ```ini
  PGUSER=arval
  PGDATABASE=de_commerce
  # PGHOST unset to prefer Unix socket; set PGSSLMODE=prefer or comls -l 

