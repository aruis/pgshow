drop extension mysql_fdw cascade ;
drop server my_mysql_server cascade ;

create extension mysql_fdw;

CREATE SERVER my_mysql_server
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (host 'muyuntage.local', port '3306');

CREATE USER MAPPING FOR postgres
    SERVER my_mysql_server
    OPTIONS (username 'demo', password 'demo');

CREATE FOREIGN TABLE my_foreign_table (
    id integer,
    name varchar,
    address varchar
    )
    SERVER my_mysql_server
    OPTIONS (dbname 'mysql_demo', table_name 'table_in_mysql');

select * from my_foreign_table;

truncate table my_foreign_table;

insert into my_foreign_table (name,address) values ('test','test from postgresql');
