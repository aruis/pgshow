-- 创建父表 employees，包含所有员工的通用属性
CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100),
                           address VARCHAR(255),
                           hire_date DATE
);

-- 创建子表 full_time_employees，继承 employees 表，并添加特有的属性
CREATE TABLE full_time_employees (
                                     salary NUMERIC
) INHERITS (employees);

-- 创建子表 part_time_employees，继承 employees 表，并添加特有的属性
CREATE TABLE part_time_employees (
                                     hourly_rate NUMERIC
) INHERITS (employees);

-- 向 full_time_employees 表中插入数据
INSERT INTO full_time_employees (name, address, hire_date, salary)
VALUES ('Alice', '123 Main St', '2023-01-01', 60000);

-- 向 part_time_employees 表中插入数据
INSERT INTO part_time_employees (name, address, hire_date, hourly_rate)
VALUES ('Bob', '456 Elm St', '2023-02-01', 25);

-- 从 employees 表中查询所有员工信息（包括全职和兼职员工）
SELECT * FROM employees;

-- 从 full_time_employees 表中查询全职员工信息
SELECT * FROM full_time_employees;

-- 从 part_time_employees 表中查询兼职员工信息
SELECT * FROM part_time_employees;
