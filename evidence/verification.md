# Verification — simplified version

Verified on 2026-10-05 against the local MySQL server on port 33307.

- Maven clean package succeeded for seven Java source files.
- All five .form files loaded without persistence errors using the bundled NetBeans 29 form loader (standalone harness with look-and-feel switching disabled).
- Form controls, GroupLayout references and button handler markers match their paired Java files.
- Swing button checks passed: wrong and correct login, logout, empty customer rejection and customer save, item selection, availability filtering, invalid quantity rejection, record save and calculated total.
- Invalid and past pickup dates were rejected. A future pickup date saved successfully.
- JasperReports compiled, filled and exported the monthly report as PDF.
- Temporary customer and transaction records were removed after checking.
- Five screen previews were captured from the final demo data.
- Database and installer PowerShell helpers passed syntax parsing.
- jpackage rebuilt the app image and EXE installer. The target, distributed and packaged JAR hashes match; the installer includes the current database SQL.

The verification harnesses are kept in the parent .tools folder so they do not add complexity to these beginner projects. The EXE installers were built; installation into Windows was not rerun. Previous test evidence and documents are stored with the previous version in .tools/before-simple-forms-2026-10-05.

## UI redesign verification

- Both Maven builds passed after the redesign.
- All five forms per project loaded in the NetBeans form loader after layout changes.
- All windows fit within 1280 × 768, and every application action button fits inside its content area.
- Dashboard sale/order entry, customers and Back, catalogue and Continue, report viewer and logout were exercised through Swing buttons.
- Updated screen previews were inspected. The two projects use different dashboard, login and data-screen layouts.

## Report requirement correction — 2026-10-07

The monthly report now joins transactions, customers and products/bouquets. A JDBC/Jasper check verified distinct-customer counts, quantities, transaction counts and month/item grouping using two temporary customers, two item types and two months. The temporary data was rolled back. The report compiled and filled, and the evidence PDF was regenerated from the real demo data. Both Maven packages rebuilt successfully.
