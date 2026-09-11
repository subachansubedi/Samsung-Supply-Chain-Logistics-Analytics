/*
============================================================================
NEW BUSINESS INSIGHT QUERIES
============================================================================
*/

/*
I01: Latest inventory below reorder point
Purpose: Identifies product-facility combinations requiring immediate replenishment at the latest available date.
Query:
*/

WITH latest AS (
    SELECT MAX(date_key) AS date_key
    FROM fact_inventory
)
SELECT
    p.product_name,
    f.facility_name,
    i.stock_level,
    i.reorder_point,
    i.stock_level - i.reorder_point AS units_vs_reorder
FROM fact_inventory i
JOIN latest l
    ON l.date_key = i.date_key
JOIN dim_product p
    ON p.product_id = i.product_id
JOIN dim_facility f
    ON f.facility_id = i.facility_id
WHERE i.stock_level < i.reorder_point
ORDER BY units_vs_reorder ASC;

/*
Executed result:
product_name                 facility_name     stock_level  reorder_point  units_vs_reorder
Galaxy Z Flip5               Mumbai DC         136          267            -131
Galaxy Tab S9 Ultra          New Jersey DC     109          173             -64
Galaxy Z Fold5               Poland DC          86          132             -46
Galaxy Z Fold5               Mumbai DC          95          132             -37
Galaxy Tab S9                New Jersey DC     106          139             -33
Galaxy Z Fold5               New Jersey DC     101          132             -31
Galaxy S24 Ultra             Mumbai DC         103          131             -28
Galaxy S24 Ultra             Mumbai DC         133          160             -27
Galaxy Buds2 Pro             New Jersey DC     328          347             -19
Galaxy Z Flip5               New Jersey DC     251          267             -16
OLED 65" 4K                 Poland DC           77           86              -9
Galaxy S24 Ultra             New Jersey DC     158          160              -2
Smart Front Load Washer      Mumbai DC          47           49              -2
Galaxy Tab A9                New Jersey DC     118          119              -1
*/

/* ------------------------------------------------------------------------ */

/*
I02: Inventory excess above reorder point
Purpose: Quantifies tied-up inventory above reorder levels on the latest snapshot.
Query:
*/

WITH latest AS (
    SELECT MAX(date_key) AS date_key
    FROM fact_inventory
)
SELECT
    p.product_name,
    SUM(i.stock_level - i.reorder_point) AS excess_units,
    ROUND(
        SUM((i.stock_level - i.reorder_point) * p.unit_cost),
        2
    ) AS excess_cost_value
FROM fact_inventory i
JOIN latest l
    ON l.date_key = i.date_key
JOIN dim_product p
    ON p.product_id = i.product_id
WHERE i.stock_level > i.reorder_point
GROUP BY p.product_name
ORDER BY excess_cost_value DESC;

/*
Executed result:
product_name                 excess_units  excess_cost_value
Neo QLED 85" 4K             83            178034.17
Galaxy S23                  361           176886.39
Galaxy S24 Ultra             162           141718.38
Galaxy Watch6 Classic        403           121298.97
Galaxy S24                  197           117213.03
Galaxy Tab S9               137            86308.63
Galaxy Tab S9 Ultra          74            68375.26
OLED 65" 4K                  36            53819.64
Family Hub Refrigerator      25            53624.75
Galaxy Buds2 Pro            324            52160.76
Crystal UHD 65"              60            25349.40
Galaxy Tab A9               107            16476.93
Smart Front Load Washer      17            14364.83
Galaxy Z Flip5                5             3499.95
*/

/* ------------------------------------------------------------------------ */

/*
I03: Product gross margin
Purpose: Finds product variants with the strongest and weakest realized profit economics.
Query:
*/

SELECT
    p.product_name,
    p.spec,
    ROUND(SUM(s.gross_revenue), 2) AS gross_revenue,
    ROUND(SUM(s.profit), 2) AS profit,
    ROUND(
        100.0 * SUM(s.profit) / SUM(s.gross_revenue),
        2
    ) AS margin_pct
FROM fact_sales s
JOIN dim_product p
    ON p.product_id = s.product_id
GROUP BY
    p.product_name,
    p.spec
ORDER BY margin_pct DESC;

/*
Executed result:
product_name                 spec          gross_revenue   profit       margin_pct
Family Hub Refrigerator      28 cu ft      12506962.10     3756886.74   30.04
Smart Front Load Washer      5.0 cu ft      4798263.09     1428636.68   29.77
Neo QLED 85" 4K              85 inch       14183357.02     4211792.35   29.70
Crystal UHD 65"              65 inch        2947054.66      867297.31   29.43
OLED 65" 4K                  65 inch       11051451.95     3243232.62   29.35
Galaxy S24 Ultra             512GB         18371458.68     4682292.46   25.49
Galaxy Buds2 Pro             Standard       6094275.02     1534940.70   25.19
Galaxy S24 Ultra             256GB         17966250.28     4511827.30   25.11
Galaxy Tab S9                256GB          8117909.80     2014879.66   24.82
Galaxy Tab S9 Ultra          512GB         11046996.31     2740258.22   24.81
Galaxy Z Fold5               512GB         29204967.89     7236679.81   24.78
Galaxy S24                  256GB         11921109.75     2951504.81   24.76
Galaxy Z Flip5               256GB         15666843.33     3852158.49   24.59
Galaxy Tab A9                64GB           2056246.53      504651.91   24.54
Galaxy S23                   128GB         11038142.31     2694238.78   24.41
Galaxy Watch6 Classic        47mm           9890629.98     2328271.34   23.54
*/

/* ------------------------------------------------------------------------ */

/*
I04: Discount and margin relationship
Purpose: Tests whether discounting is associated with lower realized margin by discount band.
Query:
*/

WITH bands AS (
    SELECT
        CASE
            WHEN discount_pct = 0 THEN '0%'
            WHEN discount_pct <= 5 THEN '1-5%'
            WHEN discount_pct <= 10 THEN '6-10%'
            ELSE '11%+'
        END AS discount_band,
        gross_revenue,
        profit
    FROM fact_sales
)
SELECT
    discount_band,
    COUNT(*) AS sales_lines,
    ROUND(SUM(gross_revenue), 2) AS revenue,
    ROUND(
        100.0 * SUM(profit) / SUM(gross_revenue),
        2
    ) AS margin_pct
FROM bands
GROUP BY discount_band
ORDER BY
    CASE discount_band
        WHEN '0%' THEN 1
        WHEN '1-5%' THEN 2
        WHEN '6-10%' THEN 3
        ELSE 4
    END;

/*
Executed result:
discount_band  sales_lines  revenue       margin_pct
0%              4346        93796339.17    31.29
1-5%             1583        34600419.54    26.30
6-10%            1651        34783630.14    21.30
11%+              920        23681529.85    11.39
*/

/* ------------------------------------------------------------------------ */

/*
I05: Production facility utilization
Purpose: Estimates production output against annual facility capacity to flag concentration and headroom.
Query:
*/

SELECT
    f.facility_name,
    f.annual_capacity,
    SUM(pr.quantity_produced) AS units_produced,
    ROUND(
        100.0 * SUM(pr.quantity_produced) / f.annual_capacity,
        2
    ) AS capacity_ratio_pct
FROM fact_production pr
JOIN dim_facility f
    ON f.facility_id = pr.facility_id
GROUP BY
    f.facility_name,
    f.annual_capacity
ORDER BY capacity_ratio_pct DESC;

/*
Executed result:
facility_name          annual_capacity  units_produced  capacity_ratio_pct
Gumi Appliance Plant   320000           1291277         403.52
Gumi Manufacturing 1  850000           1241714         146.08
Thai Nguyen Plant      1500000          1297456          86.50
*/

/* ------------------------------------------------------------------------ */

/*
I06: Defect rate by product
Purpose: Ranks products by observed defective units and recalculated defect rate.
Query:
*/

SELECT
    p.product_name,
    p.spec,
    SUM(pr.quantity_produced) AS units_produced,
    SUM(pr.defective_units) AS defective_units,
    ROUND(
        100.0 * SUM(pr.defective_units) / SUM(pr.quantity_produced),
        3
    ) AS recalculated_defect_rate_pct
FROM fact_production pr
JOIN dim_product p
    ON p.product_id = pr.product_id
GROUP BY
    p.product_name,
    p.spec
ORDER BY recalculated_defect_rate_pct DESC;

/*
Executed result:
product_name                 spec          units_produced  defective_units  recalculated_defect_rate_pct
Galaxy Buds2 Pro             Standard      512756          3438             0.670
Galaxy Watch6 Classic        47mm          433101          2871             0.663
Galaxy S23                   128GB         348288          2289             0.657
Galaxy S24 Ultra             512GB         343531          2246             0.654
Galaxy Z Fold5               512GB         348590          2277             0.653
Galaxy S24                   256GB         322312          2056             0.638
Galaxy Z Flip5               256GB         335798          2129             0.634
Galaxy S24 Ultra             256GB         323247          2007             0.621
Galaxy Tab S9                256GB         209447          1301             0.621
Galaxy Tab S9 Ultra          512GB         170592          1056             0.619
Galaxy Tab A9                64GB          189661          1127             0.594
OLED 65" 4K                 65 inch        61978           304              0.490
Crystal UHD 65"              65 inch        72243           345              0.478
Neo QLED 85" 4K              85 inch        60714           281              0.463
Smart Front Load Washer      5.0 cu ft     50705           197              0.389
Family Hub Refrigerator      28 cu ft      47484           178              0.375
*/

/* ------------------------------------------------------------------------ */

/*
I07: Supplier cost-quality frontier
Purpose: Surfaces suppliers that combine high quality with competitive unit economics.
Query:
*/

SELECT
    s.supplier_name,
    ROUND(SUM(p.total_cost), 2) AS spend,
    ROUND(AVG(p.unit_cost), 2) AS avg_unit_cost,
    ROUND(AVG(p.quality_score), 2) AS avg_quality,
    ROUND(AVG(p.lead_time_days), 2) AS avg_lead_days
FROM fact_procurement p
JOIN dim_supplier s
    ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name
ORDER BY
    avg_quality DESC,
    avg_unit_cost ASC;

/*
Executed result:
supplier_name                  spend        avg_unit_cost  avg_quality  avg_lead_days
Taiwan Semiconductor Mfg       11334183.40   672.56         98.12        12.37
Sony Semiconductor             11186192.91   657.34         97.93        12.42
Samsung Electronics Co. Ltd    11158326.79   657.00         97.48        12.42
SK Hynix Inc.                  11216821.84   683.98         96.74        12.33
Samsung Vietnam                11399432.28   601.60         95.80         9.39
BOE Technology                 11492863.42   651.06         95.62        12.47
Samsung India                  10347031.56   600.75         94.80         9.46
*/

/* ------------------------------------------------------------------------ */

/*
I08: Carrier cost per kilogram
Purpose: Compares logistics efficiency independent of shipment volume.
Query:
*/

SELECT
    carrier,
    COUNT(*) AS shipments,
    ROUND(SUM(shipping_cost), 2) AS shipping_cost,
    ROUND(SUM(total_weight_kg), 2) AS total_kg,
    ROUND(
        SUM(shipping_cost) / SUM(total_weight_kg),
        4
    ) AS cost_per_kg,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN status = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_pct
FROM fact_shipment
GROUP BY carrier
ORDER BY cost_per_kg DESC;

/*
Executed result:
carrier                shipments  shipping_cost  total_kg    cost_per_kg  delay_rate_pct
DHL Express            824        1879875.95     789081.61   2.3824       8.01
C.H. Robinson           867        2166422.31     929249.60   2.3314       6.92
CMA CGM                 802        2117422.62     910255.54   2.3262       6.86
Kuehne+Nagel            796        2190359.35     946378.27   2.3145       6.41
UPS Worldwide           845        2417973.04    1059436.85   2.2823       7.22
DB Schenker             835        2012667.29     901632.16   2.2322       7.78
FedEx International     824        2171921.49     977573.55   2.2217       7.77
Maersk Line             837        2161002.09     994385.99   2.1732      10.39
XPO Logistics            870        2300038.17    1060010.26   2.1698       7.36
*/

/* ------------------------------------------------------------------------ */

/*
I09: Customer concentration
Purpose: Measures account concentration and dependence on the largest customers.
Query:
*/

SELECT
    c.customer_name,
    c.channel_type,
    ROUND(SUM(s.gross_revenue), 2) AS revenue,
    ROUND(
        100.0 * SUM(s.gross_revenue) /
        (SELECT SUM(gross_revenue) FROM fact_sales),
        2
    ) AS revenue_share_pct,
    ROUND(SUM(s.profit), 2) AS profit
FROM fact_sales s
JOIN dim_customer c
    ON c.customer_id = s.customer_id
GROUP BY
    c.customer_name,
    c.channel_type
ORDER BY revenue DESC;

/*
Executed result:
customer_name             channel_type  revenue       revenue_share_pct  profit
Amazon.com Inc.            Online        38832797.17    20.78              10079326.35
Flipkart                   Online        38451068.87    20.58              10068978.46
Best Buy Co. Inc.          Retailer      38004488.21    20.34               9961754.88
MediaMarkt Saturn          Retailer      37592080.25    20.12               9596950.50
Samsung Direct Store       Direct        33981484.20    18.19               8852538.99
*/

/* ------------------------------------------------------------------------ */

/*
I10: Monthly revenue and margin trend
Purpose: Tests seasonality and whether revenue growth is accompanied by margin pressure.
Query:
*/

SELECT
    d.year,
    d.month,
    d.month_name,
    ROUND(SUM(s.gross_revenue), 2) AS revenue,
    ROUND(SUM(s.profit), 2) AS profit,
    ROUND(
        100.0 * SUM(s.profit) / SUM(s.gross_revenue),
        2
    ) AS margin_pct
FROM fact_sales s
JOIN dim_date d
    ON d.date_key = s.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;

/*
Executed result:
year  month  month_name  revenue       profit       margin_pct
2023  1      January     7184407.85    1407694.03   19.59
2023  2      February    6528759.86    1828078.88   28.00
2023  3      March       6855679.87    1924995.77   28.08
2023  4      April       7471204.92    2082643.81   27.88
2023  5      May         7778631.28    2185424.04   28.10
2023  6      June        6944520.15    1944167.28   28.00
2023  7      July        7357856.20    2090762.42   28.42
2023  8      August      6323194.51    1781154.09   28.17
2023  9      September   6785614.46    1944387.34   28.65
2023  10     October     11174516.15   3133846.73   28.04
2023  11     November   9560203.68    2018873.68   21.12
2023  12     December   9837745.61    1940419.32   19.72
2024  1      January     6852244.88    1404986.28   20.50
2024  2      February   7431223.40    2081897.86   28.02
2024  3      March      6882172.91    1969864.00   28.62
2024  4      April      6816802.73    1903466.28   27.92
2024  5      May        6327601.15    1762613.14   27.86
2024  6      June       6477784.38    1825095.92   28.17
2024  7      July       7800126.69    2223044.74   28.50
2024  8      August     6860064.44    1945565.06   28.36
2024  9      September  6586458.97    1864506.27   28.31
2024  10     October    10724616.12   3083769.16   28.75
2024  11     November  9665747.33    1982359.82   20.51
2024  12     December  10634741.16   2229933.26   20.97
*/

/* ------------------------------------------------------------------------ */
