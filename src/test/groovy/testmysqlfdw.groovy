import groovy.sql.Sql

def db = Sql.newInstance("jdbc:postgresql://localhost:54321/demo", "postgres", "muyuntage", "org.postgresql.Driver")

println(db.firstRow("select * from my_foreign_table"))

// 经验证mysql外部表不会跟pg自己的sql作为同一个事务管理
db.withTransaction {
    db.executeUpdate("update my_foreign_table set name = ? where id = ?", ['newtext', 1])
    db.firstRow("select 1/0")
}

println(db.firstRow("select * from my_foreign_table"))
