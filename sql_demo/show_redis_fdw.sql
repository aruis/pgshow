drop  extension redis_fdw cascade ;
CREATE EXTENSION redis_fdw;

CREATE SERVER redis_server
    FOREIGN DATA WRAPPER redis_fdw
    OPTIONS (address '192.168.0.163', port '6379');

CREATE USER MAPPING FOR CURRENT_USER
    SERVER redis_server
    OPTIONS (password 'muyuntage');  -- 如果需要 Redis 密码

select * from redis_db0;

CREATE FOREIGN TABLE redis_db0 (key text, val text)
    SERVER redis_server
    OPTIONS (database '0');

CREATE FOREIGN TABLE myredishash (key text, val text[])
    SERVER redis_server
    OPTIONS (database '0', tabletype 'hash', tablekeyprefix 'mytable:');

INSERT INTO myredishash (key, val)
VALUES ('mytable:r1','{prop1,val1,prop2,val2}');

select * from myredishash;

UPDATE myredishash
SET val = '{prop3,val3,prop4,val4}'
WHERE key = 'mytable:r1';

DELETE from myredishash
WHERE key = 'mytable:r1';

CREATE FOREIGN TABLE myredis_s_hash (key text, val text)
    SERVER redis_server
    OPTIONS (database '0', tabletype 'hash',  singleton_key 'mytable');

INSERT INTO myredis_s_hash (key, val)
VALUES ('prop1','val1'),('prop2','val2');

UPDATE myredis_s_hash
SET val = 'val23'
WHERE key = 'prop1';

DELETE from myredis_s_hash
WHERE key = 'prop1';

select *
from  myredis_s_hash;
