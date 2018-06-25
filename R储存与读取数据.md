##R语言数据储存与读取
- write.table()
- write.csv()

- 不写入行名 row.names=False
- 不写入列名 col.names=False (write.csv不能设置为False)

-输出文本字符串没有双引号则设置quote=F

read.table( ) 变形有： aread.csv( ),read.csv2( ), read.delim( ), read.delim2( ).前两读取逗号分割数据，后两个读取其他分割符数据。