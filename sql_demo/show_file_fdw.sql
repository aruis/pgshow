drop extension file_fdw cascade ;
create extension file_fdw;

CREATE SERVER csv_server FOREIGN DATA WRAPPER file_fdw;


CREATE FOREIGN TABLE people_csv (
    id INTEGER,
    name TEXT,
    age INTEGER
    ) SERVER csv_server
    OPTIONS (filename '/var/lib/postgresql/data/data.csv', format 'csv', header 'true');

drop foreign table product_csv;

CREATE FOREIGN TABLE product_csv (
    id INTEGER,
    name TEXT
    ) SERVER csv_server
    OPTIONS (filename '/var/lib/postgresql/data/products_large_test_data.csv', format 'csv', header 'true');


SELECT * FROM people_csv;
SELECT count(*) FROM product_csv;
