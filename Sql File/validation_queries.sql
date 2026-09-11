/* Samsung Supply Chain & Logistics BI Validation and Opportunity Analysis */

/* ============================================================================
   POWER BI VALIDATION QUERIES
   ============================================================================ */

/* V01: Gross revenue
   Purpose: Reconciles the Overview gross revenue card to the sales fact.
   Query: */

SELECT ROUND(SUM(gross_revenue), 2) AS gross_revenue
FROM fact_sales;

/* Executed result:
   gross_revenue
   186861918.7 */

/* ------------------------------------------------------------------------ */

/* V02: Profit
   Purpose: Reconciles the Overview profit card.
   Query: */

SELECT ROUND(SUM(profit), 2) AS total_profit
FROM fact_sales;

/* Executed result:
   total_profit
   48559549.18 */

/* ------------------------------------------------------------------------ */

/* V03: Procurement spend
   Purpose: Reconciles Supplier Performance total unit cost / procurement spend.
   Query: */

SELECT ROUND(SUM(total_cost), 2) AS procurement_spend
FROM fact_procurement;

/* Executed result:
   procurement_spend
   78134852.2 */

/* ------------------------------------------------------------------------ */

/* V04: Average procurement lead time
   Purpose: Reconciles the supplier lead-time KPI.
   Query: */

SELECT ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days
FROM fact_procurement;

/* Executed result:
   avg_lead_time_days
   11.53 */

/* ------------------------------------------------------------------------ */

/* V05: Average supplier quality
   Purpose: Checks the supplier quality KPI and gives the supplier-level basis.
   Query: */

SELECT
    s.supplier_name,
    ROUND(AVG(p.quality_score), 2) AS avg_quality_score
FROM fact_procurement p
JOIN dim_supplier s
    ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY avg_quality_score DESC;

/* Executed result:
   supplier_name                  avg_quality_score
   Taiwan Semiconductor Mfg       98.12
   Sony Semiconductor             97.93
   Samsung Electronics Co. Ltd    97.48
   SK Hynix Inc.                  96.74
   Samsung Vietnam                95.80
   BOE Technology                 95.62
   Samsung India                  94.80 */

/* ------------------------------------------------------------------------ */

/* V06: Inventory stock units
   Purpose: Reconciles the Inventory & Production stock-level headline.
   Query: */

SELECT SUM(stock_level) AS total_stock_units
FROM fact_inventory;

/* Executed result:
   total_stock_units
   159896 */

/* ------------------------------------------------------------------------ */

/* V07: Shipment cost
   Purpose: Reconciles the Shipment & Logistics shipment-cost headline.
   Query: */

SELECT ROUND(SUM(shipping_cost), 2) AS shipping_cost
FROM fact_shipment;

/* Executed result:
   shipping_cost
   19417682.31 */

/* ------------------------------------------------------------------------ */

/* V08: Delayed shipments
   Purpose: Reconciles total delayed shipments.
   Query: */

SELECT COUNT(*) AS delayed_shipments
FROM fact_shipment
WHERE status = 'Delayed';

/* Executed result:
   delayed_shipments
   573 */

/* ------------------------------------------------------------------------ */

/* V09: Delays by carrier
   Purpose: Checks the carrier delay ranking shown on the Shipment page.
   Query: */

SELECT
    carrier,
    COUNT(*) AS delayed_shipments
FROM fact_shipment
WHERE status = 'Delayed'
GROUP BY carrier
ORDER BY delayed_shipments DESC;

/* Executed result:
   carrier                  delayed_shipments
   Maersk Line              87
   DHL Express              66
   DB Schenker               65
   XPO Logistics             64
   FedEx International       64
   UPS Worldwide             61
   C.H. Robinson             60
   CMA CGM                    55
   Kuehne+Nagel               51 */

/* ------------------------------------------------------------------------ */

/* V10: Revenue share by channel
   Purpose: Tests the Customer & Sales channel-share narrative.
   Query: */

SELECT
    c.channel_type,
    ROUND(SUM(s.gross_revenue), 2) AS gross_revenue,
    ROUND(
        100.0 * SUM(s.gross_revenue) /
        (SELECT SUM(gross_revenue) FROM fact_sales),
        2
    ) AS revenue_share_pct
FROM fact_sales s
JOIN dim_customer c
    ON c.customer_id = s.customer_id
GROUP BY c.channel_type
ORDER BY gross_revenue DESC;

/* Executed result:
   channel_type    gross_revenue    revenue_share_pct
   Online          77283866.04      41.36
   Retailer        75596568.46      40.46
   Direct          33981484.20      18.19 */