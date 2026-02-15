SQL Projects: User Funnel & Conversion Analysis
Overview

This project performs comprehensive user behavior and revenue analysis using SQL on a sample user_events dataset. It focuses on tracking users through key stages of the e-commerce funnel, measuring conversion rates, analyzing traffic sources, and calculating revenue metrics.

The analysis can help product managers, data analysts, and business stakeholders understand:

How users move through the sales funnel

Drop-off points in the user journey

Time taken to convert

Revenue generated per user, order, and traffic source

Database & Dataset

Database: sql_projects

Table: user_events

Sample Columns:

event_id (INT): Unique event identifier

user_id (INT): Unique user identifier

event_type (VARCHAR): Event name (e.g., page_view, add_to_cart, checkout_start, payment_info, purchase)

event_date (DATETIME): Timestamp of the event

traffic_source (VARCHAR): Source of user traffic (e.g., organic, ads, referral)

amount (DECIMAL): Order amount (only for purchases)

Features
1. Funnel Stage Analysis

Calculates unique users at each stage of the e-commerce funnel:

Stage 1: Page Views

Stage 2: Add to Cart

Stage 3: Checkout Start

Stage 4: Payment Info Entered

Stage 5: Purchase Completed

Outputs:

Number of users at each stage

Conversion rate between stages

Overall conversion efficiency

2. Funnel Analysis by Traffic Source

Breaks down the funnel by traffic_source to understand performance per marketing channel.

Metrics:

Views, carts, and purchases per source

Cart conversion rate

Purchase conversion rate

Cart-to-purchase conversion rate

3. Time-to-Conversion Analysis

Analyzes how long users take to move through funnel stages:

Average minutes from view → cart

Average minutes from cart → purchase

Average total journey time (view → purchase)

This helps identify friction points and optimize the user experience.

4. Revenue Funnel Analysis

Focuses on monetization and revenue efficiency:

Total visitors

Total buyers

Total orders

Total revenue

Average order value

Revenue per buyer

Revenue per visitor

Purpose: Understand ROI, order efficiency, and revenue distribution.

SQL Scripts

funnel_stages.sql: Calculates user count and conversion rates for funnel stages.

source_funnel.sql: Breaks down funnel by traffic source.

time_to_conversion.sql: Computes average time metrics for conversion stages.

revenue_funnel.sql: Calculates revenue metrics and order efficiency.

All scripts are designed to run on MySQL and use CTEs (WITH), conditional aggregation, and TIMESTAMPDIFF.

Usage

Create and use the database:

CREATE DATABASE IF NOT EXISTS sql_projects;
USE sql_projects;


Run any script directly on the user_events table.

Adjust the date interval in the queries as needed (default is last 30 days):

WHERE event_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)


Optional: Export results to BI tools like Tableau, Power BI, or Metabase for visualization.

Insights & Applications

Identify high-dropoff stages to optimize UI/UX.

Measure campaign effectiveness via traffic source analysis.

Determine average purchase journey for better targeting and email automation.

Analyze revenue per user to prioritize high-value customer segments.

Optimize checkout process and reduce cart abandonment.

Future Enhancements

Segment analysis by device type (mobile vs desktop)

Cohort analysis for repeat purchases

Predictive modeling for purchase likelihood

Visualization dashboards for real-time monitoring

Author

Abishek KC – Passionate about data analytics, SQL, and building actionable business insights from raw data.
