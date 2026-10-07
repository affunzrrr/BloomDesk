# BloomDesk — Afra

This project follows the coding level and five-screen structure of HotelBookingSystemV2.

## Screens

- Login: username and password checked with a JDBC query.
- Dashboard: direct order entry, bouquets, customers, one monthly Jasper report and logout.
- CustomerProfiles: save a customer and view the customer IDs.
- Bouquets: view bouquets, prices and availability; continue to orders.
- Orders: choose customer ID and bouquet ID, enter quantity, pickup date, choose payment and save one order.

Each order contains one bouquet type. Total = quantity × price. There are no baskets, discounts, suppliers, ingredient recipes, stock tracking, deposits, refunds or delivery workflow. Availability is a simple Available/Unavailable field, like the hotel example.

## Interface

BloomDesk uses a cream and green dashboard with three action cards. Data screens put records on the left, the entry form on the right, and Back in the top header. The login screens also use different layouts. All changes remain editable in NetBeans Design.

## NetBeans

Open this folder as a Maven project. Open Login.java, Dashboard.java, CustomerProfiles.java, Bouquets.java or Orders.java and select **Design**. Each has its own editable .form file. Change layout and controls in Design; write queries in the button handler below initComponents(). App.java starts Login. DatabaseConnection.java contains the shared connection method. There are no service or repository layers.

## Run

Use Run.cmd, or use the parent Start-Both-Projects.cmd. Demo login: **admin / Bloom@2026**. Requires Java 17+ and MySQL 8.0+. Maven: `mvn clean package`, then `java -jar target/bloomdesk-1.0.0.jar`.

For a new computer, run setup/Setup-Database.ps1 with your MySQL administrator details. It imports setup/database.sql and writes the connection settings to `%USERPROFILE%\.ead\bloomdesk\database.properties`. Existing local settings are reused. The database has four simple tables: simple_users, simple_customers, simple_bouquets and simple_orders. The prefix keeps any old project data untouched.

## Files

database/schema.sql contains the tables; demo-data.sql contains sample records; full-backup.sql imports both. src/main/resources/MonthlyReport.jrxml is the monthly demand report. It joins simple_orders, simple_customers and simple_bouquets to show quantities, distinct customers, transactions and revenue by month and bouquet. Use it to decide which bouquets to purchase or prepare. setup/Build-Installer.ps1 builds the Windows installer. The old version was preserved outside this project in .tools/before-simple-forms-2026-10-05.

## GitHub downloads

Repository: https://github.com/affunzrrr/BloomDesk

Windows installer and standalone JAR: https://github.com/affunzrrr/BloomDesk/releases/tag/v1.0.0
