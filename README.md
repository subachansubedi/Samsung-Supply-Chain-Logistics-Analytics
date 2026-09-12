<div align="center">

<img src="Images/brand.png" alt="Samsung brand logo" width="58%">

### From operational data to decisions across procurement, production, inventory, logistics, and sales

<p align="center">
  <a href="Dashboard%20Pdf/dashboard.pdf">
    <img src="https://img.shields.io/badge/◈%20DASHBOARD-00A9E0?style=for-the-badge&labelColor=071A2B" alt="Explore Dashboard PDF">
  </a>
  <a href="Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf">
    <img src="https://img.shields.io/badge/◆%20BUSINESS%20REPORT-7C3AED?style=for-the-badge&labelColor=17102B" alt="Read Business Report">
  </a>
  <a href="Sql%20File/validation_queries.sql">
    <img src="https://img.shields.io/badge/⚙%20VALIDATION%20SQL-FFB000?style=for-the-badge&labelColor=241A00" alt="Inspect Validation SQL">
  </a>
</p>

<p><strong>Portfolio project by Subachan Subedi</strong><br>
Power BI · SQL · DAX · Power Query · Star Schema · Business Intelligence</p>

</div>

---

## 📌 Project overview

This project presents a six-page Power BI analytics experience for understanding a Samsung-style supply chain across a two-year operating window:

**January 2023 → December 2024**

The core business question is:

> **Where are value, risk, and improvement opportunities concentrated across the supply chain—and what should management do next?**

The answer is not limited to one KPI. The project connects the full operating chain:

> **Supplier spend → Procurement lead time & quality → Production output & defects → Inventory availability & reorder risk → Shipment cost & delivery reliability → Customer revenue & profit**

The result combines **executive reporting**, **operational diagnostics**, and **SQL-backed validation** so stakeholders can move from:

> **“What happened?” → “Why does it matter?” → “Where should we act?”**

> 📄 **Want the full context?** The [`full business report`](Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf) explains the methodology, KPI definitions, validation results, detailed findings, and recommendations behind this README.


## 📊 Executive scorecard

| Business signal | Result | Interpretation |
| --- | ---: | --- |
| Gross revenue | **$186.86M** | Total modeled sales value before discounts |
| Net revenue | **$176.95M** | Revenue after discounts |
| Profit | **$48.56M** | Modeled profit across 8,500 sales lines |
| Profit margin | **27.44%** | Dashboard margin based on net revenue |
| Procurement spend | **$78.13M** | Total modeled supplier purchasing cost |
| Average procurement lead time | **11.53 days** | Average time across procurement records |
| Shipments | **7,500** | Outbound shipment records analyzed |
| Delayed shipments | **573** | **7.64%** of all shipments |
| KPI validation | **10/10 reconciled** | Dashboard headline values checked with SQL |

<p align="center">
  <sub>All figures are taken from the project dataset, dashboard screenshots, and validation SQL.</sub>
</p>

For the calculation basis behind each KPI—including the distinction between gross revenue, net revenue, profit margin, catalog unit cost, and cumulative inventory—see the [`full business report`](Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf).

## 📊 Dashboard experience

The dashboard is designed as a navigable business product rather than a collection of disconnected charts.

It brings together:

**Sales · Inventory · Production · Suppliers · Logistics**

<p>📊 <strong>Start with the dashboard:</strong> <a href="Dashboard%20Pdf/dashboard.pdf">open the six-page PDF export</a>. For the narrative interpretation of the visuals and the decisions they support, see the <a href="Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf">full business report</a>.</p>

### 🏠 Home

The branded Home page provides navigation across the complete analytical experience:

**Home → Overview → Customer → Inventory → Supplier → Shipment**

<p align="center">
  <img src="Dashboard%20SS/home.png" alt="Power BI dashboard home page" width="100%">
</p>

### Executive overview

The Overview page brings together revenue, profit, inventory, supplier lead time, order volume, shipment quantity, and carrier delays. It is intended for the first management question: **“What is the current shape of the network?”**

<p align="center">
  <img src="Dashboard%20SS/overview.png" alt="Power BI executive overview page" width="100%">
</p>

### Customer and sales performance

The Customer page connects gross revenue, net revenue, profit, margin, discounting, product/category economics, customer contribution, and channel mix. It highlights the difference between a revenue-leading segment and a profit-leading segment.

<p align="center">
  <img src="Dashboard%20SS/customer.png" alt="Power BI customer and sales page" width="100%">
</p>

### Inventory and production

The Inventory page brings together stock levels, safety stock, reorder points, inventory value, turnover, days of inventory, production output, and defective units. This view supports replenishment and capacity conversations.

<p align="center">
  <img src="Dashboard%20SS/inventory.png" alt="Power BI inventory and production page" width="100%">
</p>

### Supplier performance

The Supplier page compares procurement spend, order quantity, unit cost, lead time, quality score, and supplier-level performance. It helps separate the cheapest supplier from the best overall trade-off.

<p align="center">
  <img src="Dashboard%20SS/supplier.png" alt="Power BI supplier performance page" width="100%">
</p>

### Shipment and logistics

The Shipment page analyzes shipping cost, total shipments, shipment quantity, delivery status, carrier delay counts, and delay reasons. It is designed to expose where cost efficiency may conflict with service reliability.

<p align="center">
  <img src="Dashboard%20SS/shipment.png" alt="Power BI shipment and logistics page" width="100%">
</p>

## 🔎 What the analysis found

The findings below are the executive takeaways. 

- **Inventory risk is concentrated:** 14 of 24 product–facility combinations were below reorder points, while $1.11M of inventory was above target levels.
- **Discounts erode margin:** Realized margin falls from **31.29%** at 0% discount to **11.39%** at 11%+.
- **Gumi capacity needs review:** Reported output materially exceeds stated annual capacity, requiring validation of the capacity definition and reporting period.
- **Carrier cost vs. reliability:** Lower freight cost does not always mean better delivery performance; carrier allocation should balance both.
- **Online narrowly leads Retailer:** Online accounts for **41.39%** of net revenue vs. **40.41%** for Retailer.
- **Appliances and TVs lead margins:** Several appliance and large-screen TV products deliver ~29–30% gross margins, outperforming many flagship mobile products.

The [`full business report`](Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf) provides the supporting SQL results, measure-definition notes, figures, and expanded discussion for readers who want to go deeper.


## 🎯 Recommended management actions

1. **Rebalance inventory:** use the latest-snapshot reorder analysis to review transfers from overstocked televisions and flagship phones toward understocked foldables and the Tab S9 Ultra, especially at Mumbai and New Jersey.
2. **Review facility capacity:** validate Gumi Appliance Plant’s stated annual capacity and confirm the operational definition used by the source data.
3. **Tighten discount governance:** focus commercial review on the 11%+ band, where realized margin is 11.39% versus 31.29% at no discount.
4. **Optimize carriers by service lane:** assess whether time-sensitive lanes should shift toward carriers with stronger reliability, while retaining cost visibility.
5. **Standardize KPI definitions:** label net revenue, catalog unit cost, and latest-snapshot inventory explicitly so users do not confuse different calculation bases.

## 🧱 Data model and scope

The repository contains **10 CSV tables** and **24,617 records** across five dimensions and five fact tables.

| Layer | Tables | Rows | Analytical role |
| --- | --- | ---: | --- |
| Dimensions | `dim_customer` | 5 | Customer, account, country, and channel context |
| Dimensions | `dim_date` | 731 | Calendar and time analysis from 2023–2024 |
| Dimensions | `dim_facility` | 6 | Plants and distribution centers |
| Dimensions | `dim_product` | 16 | Product, category, specification, and cost context |
| Dimensions | `dim_supplier` | 7 | Supplier, tier, location, and quality context |
| Facts | `fact_sales` | 8,500 | Revenue, discounts, profit, and margin |
| Facts | `fact_procurement` | 2,200 | Purchase quantity, spend, lead time, and quality |
| Facts | `fact_production` | 4,500 | Output, defective units, and defect rate |
| Facts | `fact_inventory` | 1,152 | Monthly stock snapshots by product and facility |
| Facts | `fact_shipment` | 7,500 | Shipment volume, carrier, cost, status, and delays |

## 🔬 Validation and analysis workflow

```text
CSV source tables
      ↓
Relational staging / SQL validation
      ↓
Power Query transformation and star-schema model
      ↓
DAX KPI and business measures
      ↓
Power BI dashboard pages
      ↓
SQL reconciliation + opportunity analysis
      ↓
Business findings and recommendations
```

### ✅ Validation SQL

[`Sql File/validation_queries.sql`](Sql%20File/validation_queries.sql) contains 10 checks covering:

- Gross revenue
- Profit
- Procurement spend
- Average supplier lead time
- Supplier quality
- Inventory stock units
- Shipment cost
- Delayed shipment count
- Carrier delay ranking
- Revenue share by channel

The validation results reconcile to the dashboard within normal display rounding.

### 🧠 Business insight SQL

[`Sql File/business_insight_queries.sql`](Sql%20File/business_insight_queries.sql) extends beyond dashboard reconciliation into:

- Latest inventory below reorder point
- Inventory excess above reorder point
- Product gross margin
- Discount and margin relationship
- Production facility utilization
- Defect rate by product
- Supplier cost–quality frontier
- Carrier cost per kilogram
- Customer concentration
- Revenue and margin seasonality

This separates **control evidence** from **decision analysis**: one script checks whether the dashboard is right, while the other asks what the business should investigate next.

## 🛠️ Tools and techniques

| Area | Tools and techniques |
| --- | --- |
| BI and visualization | Power BI Desktop, Power BI Service, interactive page navigation |
| Data preparation | Power Query, CSV ingestion, data typing, relationship management |
| Data modeling | Star schema with five facts and five dimensions |
| Calculations | DAX measures for revenue, profit margin, perfect orders, discounting, and inventory turnover |
| Validation | MySQL 8.0 / SQLite-compatible SQL, KPI reconciliation |
| Reporting | Microsoft Word business report and PDF dashboard export |

## 📁 Repository guide

| Resource | Purpose |
| --- | --- |
| [`Dashboard SS/`](Dashboard%20SS/) | Page-level dashboard screenshots |
| [`Dashboard Pdf/dashboard.pdf`](Dashboard%20Pdf/dashboard.pdf) | Six-page dashboard export |
| [`Dashboard/Samsung_Dashboard`](Dashboard/Samsung_Dashboard) | Power BI dashboard artifact |
| [`Dataset/`](Dataset/) | Source dimension and fact tables |
| [`Sql File/validation_queries.sql`](Sql%20File/validation_queries.sql) | Dashboard KPI validation |
| [`Sql File/business_insight_queries.sql`](Sql%20File/business_insight_queries.sql) | Business opportunity analysis |
| [`Business Report/SAMSUNG Supply Chain and Logistics Analytics Report.pdf`](Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf) | Full report with methodology, findings, and recommendations |

> ⚠️ **Dataset disclaimer:** The dataset used in this portfolio project was sourced from [The Developer](https://thedeveloperyt.com/). It is a synthetic educational dataset and is **highly unrealistic** compared with Samsung’s actual operations. The metrics, findings, and recommendations should therefore be treated as a demonstration of analytics, dashboard design, and business reasoning not as factual Samsung performance or real-world operational guidance.

## 🔗 Explore the project

<div align="center">

<a href="Dashboard%20Pdf/dashboard.pdf"><strong>Open the dashboard PDF</strong></a>
&nbsp; · &nbsp;
<a href="Business%20Report/SAMSUNG%20Supply%20Chain%20and%20Logistics%20Analytics%20Report.pdf"><strong>Read the full business report</strong></a>
&nbsp; · &nbsp;
<a href="Sql%20File/business_insight_queries.sql"><strong>Explore the insight queries</strong></a>

</div>

---

<div align="center">
<sub>Business intelligence · supply chain analytics · SQL validation · data storytelling</sub>
</div>
