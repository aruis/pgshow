drop table products;

CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name TEXT
);

truncate products;

INSERT INTO products (name) VALUES
                                ('Apple iPhone 13'),
                                ('Samsung Galaxy S21'),
                                ('Google Pixel 6'),
                                ('OnePlus 9 Pro'),
                                ('Sony Xperia 5'),
                                ('Nokia G50'),
                                ('Xiaomi Mi 11'),
                                ('Huawei P40 Pro'),
                                ('Motorola Edge 20'),
                                ('Oppo Find X3 Pro');

insert into products select * from product_csv;

CREATE EXTENSION pg_trgm;

CREATE INDEX idx_trgm_search ON products USING GIN (name gin_trgm_ops);

SELECT * FROM products WHERE name ILIKE '%Galaxy%';

EXPLAIN ANALYZE SELECT * FROM products WHERE name ILIKE '%Galaxy%';

select count(*) from products;
