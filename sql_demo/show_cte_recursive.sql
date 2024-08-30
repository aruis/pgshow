drop table region;
CREATE TABLE region (
                        id SERIAL PRIMARY KEY,
                        name VARCHAR NOT NULL,
                        parent_id INT
);

INSERT INTO region (id, name, parent_id) VALUES
                                             (1, '江苏省', NULL),     -- 省级
                                             (2, '南京市', 1),        -- 地级市
                                             (3, '苏州市', 1),
                                             (4, '玄武区', 2),        -- 区级
                                             (5, '鼓楼区', 2),
                                             (6, '吴中区', 3),
                                             (7, '昆山市', 3);

WITH RECURSIVE region_hierarchy AS (
    -- 基础情况：从根节点开始，这里是江苏省
    SELECT id,name, name as full_name, parent_id, 1 AS level
    FROM region
    WHERE name = '江苏省'

    UNION ALL

    -- 递归部分：查找子区域，并拼接全名
    SELECT r.id,r.name, rh.full_name || '-' || r.name as full_name, r.parent_id, rh.level + 1
    FROM region r
             JOIN region_hierarchy rh ON r.parent_id = rh.id
)
SELECT id,name, full_name, parent_id, level
FROM region_hierarchy;
