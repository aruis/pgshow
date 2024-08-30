drop table products;

CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          product_data JSONB
);

INSERT INTO products (product_data) VALUES
                                        ('{"name": "Gaming Laptop", "brand": "Asus", "specs": {"ram": "32GB", "storage": "1TB SSD", "graphics": "NVIDIA RTX 3070"}, "price": 2000}'),
                                        ('{"name": "Smartwatch", "brand": "Apple", "specs": {"battery_life": "18 hours", "connectivity": "WiFi, Bluetooth"}, "price": 400}'),
                                        ('{"name": "Desktop PC", "brand": "HP", "specs": {"ram": "16GB", "storage": "2TB HDD", "graphics": "AMD Radeon RX 5500"}, "price": 1500}'),
                                        ('{"name": "Smartphone", "brand": "Google", "specs": {"ram": "6GB", "storage": "128GB", "camera": "12.2MP Dual Pixel"}, "price": 900}'),
                                        ('{"name": "Convertible Laptop", "brand": "Lenovo", "specs": {"ram": "8GB", "storage": "256GB SSD", "screen_size": "13.3 inches"}, "price": 850}'),
                                        ('{"name": "Wireless Earbuds", "brand": "Sony", "specs": {"battery_life": "24 hours", "noise_cancellation": "Active"}, "price": 250}'),
                                        ('{"name": "4K TV", "brand": "Samsung", "specs": {"screen_size": "55 inches", "resolution": "4K UHD", "connectivity": "HDMI, USB, WiFi"}, "price": 1200}'),
                                        ('{"name": "Router", "brand": "Netgear", "specs": {"speed": "AC1200", "bands": "Dual-Band", "ports": "4 Gigabit Ethernet"}, "price": 100}'),
                                        ('{"name": "Bluetooth Speaker", "brand": "JBL", "specs": {"battery_life": "20 hours", "water_resistant": "IPX7"}, "price": 150}'),
                                        ('{"name": "Gaming Console", "brand": "Microsoft", "specs": {"storage": "1TB SSD", "resolution": "4K", "controllers_included": 2}, "price": 500}'),
                                        ('{"name": "Fitness Tracker", "brand": "Fitbit", "specs": {"battery_life": "7 days", "connectivity": "Bluetooth"}, "price": 130}'),
                                        ('{"name": "Wireless Mouse", "brand": "Logitech", "specs": {"battery_life": "2 years", "connectivity": "Bluetooth, USB"}, "price": 60}'),
                                        ('{"name": "Tablet", "brand": "Microsoft", "specs": {"ram": "16GB", "storage": "512GB SSD", "screen_size": "12.3 inches"}, "price": 1400}'),
                                        ('{"name": "External Hard Drive", "brand": "Seagate", "specs": {"storage": "4TB", "connectivity": "USB 3.0"}, "price": 110}'),
                                        ('{"name": "Smart Speaker", "brand": "Amazon", "specs": {"assistant": "Alexa", "connectivity": "WiFi, Bluetooth"}, "price": 70}'),
                                        ('{"name": "Smartphone", "brand": "Samsung", "specs": {"ram": "12GB", "storage": "512GB", "camera": "108MP"}, "price": 1300}'),
                                        ('{"name": "VR Headset", "brand": "Oculus", "specs": {"resolution": "1832 x 1920 per eye", "refresh_rate": "90Hz"}, "price": 300}'),
                                        ('{"name": "Mechanical Keyboard", "brand": "Corsair", "specs": {"switch_type": "Cherry MX Red", "backlight": "RGB"}, "price": 160}'),
                                        ('{"name": "E-Reader", "brand": "Amazon", "specs": {"screen_size": "7 inches", "storage": "8GB"}, "price": 90}'),
                                        ('{"name": "Smart Doorbell", "brand": "Ring", "specs": {"resolution": "1080p HD", "connectivity": "WiFi"}, "price": 200}');

SELECT product_data->>'brand' AS brand FROM products;

SELECT * FROM products
WHERE product_data->'specs' @> '{"ram": "8GB"}';

SELECT * FROM products
WHERE product_data @? '$.price ? (@ > 700)';

UPDATE products
SET product_data = jsonb_set(product_data, '{price}', ((product_data->>'price')::int * 1.1)::text::jsonb);

SELECT
    product_data->>'brand' AS brand,
    COUNT(*) AS total_products,
    jsonb_agg(product_data) AS products
FROM products
GROUP BY product_data->>'brand';
