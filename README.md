
# Little Lemon Sales Report Project

This project was developed as part of the Meta Database Engineer Professional Certificate. It implements a complete database reporting system for Little Lemon using MySQL and Python. The goal of this project is to design and implement a relational database for Little Lemon, populate it with sample data, and generate automated sales reports using SQL and Python. The project demonstrates database schema creation, data seeding, stored procedures for generating reports, and Python automation to extract results and export them as CSV files.

## Project Structure
- schema.sql → Creates the database schema and tables
- seed.sql → Inserts sample data into the tables
- report.sql → Defines a stored procedure for reporting
- run_report.py → Python script that connects to MySQL and generates CSV outputs
- daily_summary.csv → Daily sales summary report
- top_items.csv → Report of best-selling items
- by_category.csv → Revenue grouped by category
- kpis.csv → Key performance indicators

## How to Run
1. Start MySQL (via Docker):  
   docker run --name mysql8 -e MYSQL_ROOT_PASSWORD=1234 -d -p 3306:3306 mysql:8  

2. Load SQL files:  
   mysql -u root -p < schema.sql  
   mysql -u root -p little_lemon < seed.sql  
   mysql -u root -p little_lemon < report.sql  

3. Run Python script:  
   python run_report.py  

## Outputs
After running the Python script, the following CSV reports are generated: daily sales summary (total sales per day), top items (best-selling menu items), by category (sales revenue grouped by category), and KPIs (key performance indicators for management).

## Technologies Used
MySQL 8 (Database engine), Python 3 (Automation), mysql-connector-python (Database connector library), Docker (Containerized database environment).

## Key Learning Outcomes
Designing and implementing relational database schemas, writing SQL scripts and stored procedures, automating SQL queries with Python, exporting results into CSV for reporting and analytics.

## About
This project is part of the Meta Database Engineer Professional Certificate on Coursera. It showcases end-to-end database engineering skills by combining schema design, SQL reporting, and Python automation.
