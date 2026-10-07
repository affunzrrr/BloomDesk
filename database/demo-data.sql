INSERT IGNORE INTO simple_users(id,username,password_hash) VALUES (1,'admin',SHA2('Bloom@2026',256));
INSERT IGNORE INTO simple_customers(id,first_name,last_name,phone,email) VALUES (1,'Demo','Customer','0771234567','demo@example.com');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (1,'Rose bouquet','Birthday',3500,'Available');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (2,'Lily bouquet','Wedding',5000,'Available');
INSERT IGNORE INTO simple_bouquets(id,name,type,price,availability) VALUES (3,'Mixed flowers','Gift',2800,'Unavailable');
INSERT IGNORE INTO simple_orders(id,customer_id,item_id,quantity,unit_price,total,payment_method,pickup_date) VALUES (1,1,1,2,3500,7000,'CASH',CURRENT_DATE);
