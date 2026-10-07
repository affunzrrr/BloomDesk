# How the code works

1. App opens Login on the Swing event thread.
2. Login queries simple_users with PreparedStatement. Success opens Dashboard.
3. Dashboard opens customer profiles or Bouquets, and compiles/fills the monthly Jasper report.
4. CustomerProfiles inserts a customer with four setString calls and reloads the table.
5. Bouquets loads IDs into a combo box and shows the selected item's details.
6. Orders reads quantity, checks the pickup date, looks up the price, calculates the total and inserts one record. JDBC connections, statements and result sets close after each operation.

The generated initComponents section creates controls and GroupLayout. NetBeans reads the .form file to let you edit that section visually. All handwritten logic is outside that section. Use Design to change labels, add controls or move fields.

To change demo bouquets or availability, edit database/demo-data.sql before importing into a fresh database, or update the relevant table in MySQL. Prices and item names are read from MySQL, not hardcoded in Java.

The dashboard also has a direct Create a bouquet order button. Its handler opens the existing Orders form. Backgrounds, fonts, spacing and button positions are stored in .form and generated initComponents code. Table header colours and preferred column widths are set just after initComponents in the constructor.

The monthly demand report joins simple_orders, simple_customers and simple_bouquets. It groups transactions by month and bouquet, counts distinct customers, and sums quantities and revenue. This meets the brief's requirement to use more than two tables and supports purchasing decisions.
