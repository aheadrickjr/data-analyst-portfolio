# projects/bi/sales_dashboard/src/db.py
from __future__ import annotations
import os
from urllib.parse import quote_plus
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
import pandas as pd

# Load .env from repo root if present
repo_root = Path(__file__).resolve().parents[2]
env_path = repo_root / ".env"
if env_path.exists():
    load_dotenv(env_path)

PG_HOST = os.getenv("PG_HOST", "localhost")
PG_PORT = int(os.getenv("PG_PORT", "5432"))
PG_DB   = os.getenv("PG_DB", "de_portfolio")
PG_USER = os.getenv("PG_USER", "arval")
PG_PASSWORD = os.getenv("PG_PASSWORD", "")
PG_CONNECT_VIA_SOCKET = os.getenv("PG_CONNECT_VIA_SOCKET", "false").lower() == "true"
PG_UNIX_SOCKET_DIR = os.getenv("PG_UNIX_SOCKET_DIR", "/tmp")

def engine():
    if PG_CONNECT_VIA_SOCKET:
        dsn = (
            f"postgresql+psycopg2://{quote_plus(PG_USER)}:{quote_plus(PG_PASSWORD)}@"
            f"/{quote_plus(PG_DB)}?host={quote_plus(PG_UNIX_SOCKET_DIR)}&port={PG_PORT}"
        )
    else:
        dsn = (
            f"postgresql+psycopg2://{quote_plus(PG_USER)}:{quote_plus(PG_PASSWORD)}@"
            f"{PG_HOST}:{PG_PORT}/{quote_plus(PG_DB)}"
        )
    return create_engine(dsn, pool_pre_ping=True)

def fetch_df(query: str, params: dict | None = None) -> pd.DataFrame:
    with engine().connect() as conn:
        return pd.read_sql(text(query), conn, params=params)
