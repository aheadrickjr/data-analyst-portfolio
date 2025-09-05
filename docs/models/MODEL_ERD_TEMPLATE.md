# Customer Analytics — Star Schema (Template)

```mermaid
erDiagram
  FACT_TRANSACTIONS ||--o{ DIM_CUSTOMER : customer_id
  FACT_TRANSACTIONS ||--o{ DIM_PRODUCT  : product_id
  FACT_TRANSACTIONS ||--o{ DIM_DATE     : date_id
  FACT_TRANSACTIONS ||--o{ DIM_STORE    : store_id

  FACT_TRANSACTIONS {
    bigint transaction_id PK
    int customer_id FK
    int product_id  FK
    int date_id     FK
    int store_id    FK
    numeric amount
    int quantity
    numeric discount
  }
  DIM_CUSTOMER { int customer_id PK; string customer_name; string email; string segment; string city; string state; string country }
  DIM_PRODUCT  { int product_id PK; string product_name; string category; string subcategory; string brand }
  DIM_DATE     { int date_id PK; date date; int year; int quarter; int month; int day; int week }
  DIM_STORE    { int store_id PK; string store_name; string region }
