drop table source_table;
drop table archive_table;

CREATE TABLE source_table (
                              id SERIAL PRIMARY KEY,
                              name TEXT,
                              created_at TIMESTAMPTZ
);

INSERT INTO source_table (name, created_at) VALUES
                                                ('Alice', NOW() - INTERVAL '40 days'),
                                                ('Bob', NOW() - INTERVAL '35 days'),
                                                ('Charlie', NOW() - INTERVAL '25 days'),
                                                ('David', NOW() - INTERVAL '20 days'),
                                                ('Eve', NOW() - INTERVAL '15 days'),
                                                ('Frank', NOW() - INTERVAL '10 days'),
                                                ('Grace', NOW() - INTERVAL '5 days');

select * from source_table;
select * from archive_table;


CREATE TABLE archive_table (
                               id SERIAL PRIMARY KEY,
                               name TEXT,
                               created_at TIMESTAMPTZ,
                               archived_at TIMESTAMPTZ DEFAULT NOW()
);

WITH deleted_rows AS (
    DELETE FROM source_table
        WHERE created_at < NOW() - INTERVAL '30 days'  -- 条件：删除 30 天前的数据
        RETURNING id, name, created_at  -- 返回被删除的行
)
INSERT INTO archive_table (id, name, created_at)
SELECT id, name, created_at
FROM deleted_rows;  -- 插入到归档表
