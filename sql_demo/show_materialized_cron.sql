-- 创建 sales 表，存储销售记录
CREATE TABLE sales (
                       id SERIAL PRIMARY KEY,
                       product_id INT,
                       quantity INT,
                       sale_date DATE
);

-- 插入一些示例数据
INSERT INTO sales (product_id, quantity, sale_date) VALUES
                                                        (1, 10, '2024-08-01'),
                                                        (2, 15, '2024-08-02'),
                                                        (1, 20, '2024-08-03'),
                                                        (3, 5,  '2024-08-04'),
                                                        (2, 8,  '2024-08-05');

-- 创建一个物化视图，用于存储产品销售数量的汇总
CREATE MATERIALIZED VIEW sales_summary AS
SELECT
    product_id,
    SUM(quantity) AS total_quantity
FROM
    sales
GROUP BY
    product_id;

select * from sales_summary;

-- 安装 pg_cron 扩展（需要超级用户权限）
CREATE EXTENSION pg_cron;

-- 在 pg_cron 表中添加定时任务，每隔 1 小时刷新一次物化视图
SELECT cron.schedule('0 * * * *', 'REFRESH MATERIALIZED VIEW CONCURRENTLY sales_summary');

select * from cron.job;
select cron.unschedule(jobid) from cron.job;
