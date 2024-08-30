CREATE TABLE tag (
                     tag_id SERIAL PRIMARY KEY,
                     tag_name TEXT NOT NULL
);

CREATE TABLE people (
                        person_id SERIAL PRIMARY KEY,
                        person_name TEXT NOT NULL,
                        tags INTEGER[]  -- 使用数组来存储标签ID
);

-- 插入标签数据
INSERT INTO tag (tag_name) VALUES
                               ('Developer'),
                               ('Manager'),
                               ('Designer'),
                               ('QA'),
                               ('DevOps');

-- 插入人员数据，其中 `tags` 字段存储了该人员拥有的标签ID
INSERT INTO people (person_name, tags) VALUES
                                           ('Alice', ARRAY[1, 3]),    -- Alice 是 Developer 和 Designer
                                           ('Bob', ARRAY[2]),         -- Bob 是 Manager
                                           ('Charlie', ARRAY[1, 4]),  -- Charlie 是 Developer 和 QA
                                           ('David', ARRAY[1, 5]);    -- David 是 Developer 和 DevOps

SELECT p.person_name, ARRAY_AGG(t.tag_name) AS tag_names
FROM people p
         JOIN tag t ON t.tag_id = ANY(p.tags)
GROUP BY p.person_id, p.person_name;

-- 查找特定标签的人员：查询所有拥有 “Developer” 标签的人员。
SELECT person_name
FROM people
WHERE 1 = ANY(tags);  -- 标签ID为1的是 "Developer"

-- 	查找拥有多个特定标签的人员：查询拥有 “Developer”（标签ID为1）和 “DevOps”（标签ID为5）标签的人员。
SELECT person_name
FROM people
WHERE ARRAY[1, 5] <@ tags;  -- 使用 <@ 操作符检查是否包含数组的所有元素

-- 	统计每种标签下的人员数量：统计每种标签下的人员数量。
SELECT t.tag_name, COUNT(*) AS person_count
FROM tag t
         JOIN people p ON t.tag_id = ANY(p.tags)
GROUP BY t.tag_name;
