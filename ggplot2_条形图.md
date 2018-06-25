ggplot2绘制条形图
原创 2016年03月01日 14:22:25

    标签：
    可视化 /
    ggplot2

重要细节：条形图的高度表示的是数据集中变量的频数，还是表示变量取值本身

1.离散型单变量的条形图
数据形式：已经汇总好的数据集和明细数据集

 # 使用汇总好的数据集绘制条形图
library(ggplot2)
x <- c("A","B","C","D","E")
y <- c(13,22,16,31,8)
df <- data.frame(x = x,y = y)
ggplot(data = df,mapping = aes(x = x,y = y))+geom_bar(stat = "identity")
# y轴绘制的是变量的本身取值,因此不需要再做变换{stat = "identity"}
# 而该参数的默认值是count

    1
    2
    3
    4
    5
    6
    7
    8

# 使用明细数据集绘制条形图
set.seed(12)
x <- sample(c("A","B","C","D"),size = 1000,replace = TRUE,prob = c(0.2,0.3,0.3,0.2))
y <- rnorm(1000)*1000
df <- data.frame(x = x,y = y)
ggplot(data = df,mapping = aes(x=x,y = ..count..))+geom_bar(stat = "count")
# 统计某个离散型变量出现的频次时,geom_bar()函数中stat(统计转换)参数用默认值,即"count"

    1
    2
    3
    4
    5
    6
    7

如果需要对明细数据中的某个离散变量进行聚合(均值、求和、最大、最小、方差等)后再绘制条形图,可以用dplyr包中的group_by()和summarize()函数实现。

2.从x轴的数据类型来看：有字符型的x值,也有数值型的x值
上面的两幅图对应的x轴均为离散的字符型值,如果X值是数值型时：

set.seed(12)
x <- sample(c(1,2,4,6,7),size = 1000,replace = TRUE,prob = c(0.1,0.2,0.3,0.2,0.2))
ggplot(data = data.frame(x=x),aes(x = x,y = ..count..))+geom_bar(stat = "count")
# 此时直接用数值型变量作为条形图的x轴,我们会发现条形图之间产生空缺，这样的图并不美观。

# 将数值型的x转换为因子{factor(x)}
ggplot(data = data.frame(x = x),aes(x = factor(x),y = ..count..))+geom_bar()

# 设定条形的边框色和填充色
ggplot(data = data.frame(x = x),aes(x = factor(x),y = ..count..))+geom_bar(color = "black",fill = "blue")

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

输入colours(),可查看657中颜色的字符
输入colours()[grep(‘red’, colours())] 可查看与红色有关的字符

3.绘制并列条形图
以上条形图是基于一个离散型变量作为x轴,如果绘制多个离散型变量的条形图，

x <- rep(1:5,each = 3)
y <- rep(c("A","B","C"),times = 5)
set.seed(12)
z <- round(runif(min = 10,max =20,n = 15))
df <- data.frame(x = x,y = y,z = z)

# 并列式条形图
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "dodge")

# 堆叠式条形图
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "stack")

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13

发现条形图的堆叠顺序与图例顺序恰好相反,使用guides()函数进行设置即可;或者指定图形映射中的参数order = desc()来实现

ggplot(data = df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "stack")+
  guides(fill = guide_legend(reverse = TRUE))
  # guides()函数将图例引到fill属性中,再使图例反转即可

library(plyr)
ggplot(data = df,aes(x = factor(x),y = z,fill = y,order = desc(y)))+
  geom_bar(stat = "identity",position = "stack")


# 填充式，即百分比堆叠式
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "fill")

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13

4.颜色配置
如果觉得R自动配置的填充色不好看,还可以根据颜色标度更改条形图的填充色。
scale_fill_brewer()函数使用R自带的ColorBrewer画板；
scale_fill_manual()函数使用用户自定义画板
可参照ggplot2:数据分析与图形艺术P101

# 使用R自带画板
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "dodge")+
  scale_fill_brewer(palette = "Set1")

# 用户指定色彩设置
cols <- c("A" = "darkred","B" = "skyblue","C" =  "purple")
P <- ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",colour = "black",position = "dodge")+
  xlab("x")
P + scale_fill_manual(values = cols,limits = c("B","C","A"))

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11

5.绘制有序条形图

# 按x值的默认顺序
x <- c("A","B","C","D","E","F","G")
y <- c("xx","yy","yy","xx","xx","xx","yy")
z <- c(10,33,12,9,16,23,11)
df <- data.frame(x = x,y = y,z = z)
# 按默认x值的顺序,条形图的高度不一
ggplot(df,aes(x = x,y = z,fill = y))+
  geom_bar(stat = "identity")

# 条形图按高低次序排列
# reorder(,)将x的属性重新排序
ggplot(df,aes(x = reorder(x,z),y = z,fill = y))+
  geom_bar(stat = "identity")+
  xlab("x")

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14

6.关于条形图的微调
如何将y轴的正负值区分开,并去除图例

set.seed(12)
x <- 1980 + 1:35
y <- round(100*rnorm(35))
df <- data.frame(x = x,y = y)
# 判断y是否为正值
df <- transform(df,judge = ifelse(y>0,"YES","NO"))

# 去除图例用theme()主题函数
ggplot(df,aes(x = x,y = y,fill = judge))+
  geom_bar(stat = "identity")+
  theme(legend.position= "")+
  xlab("Year")+
  scale_fill_manual(values = c("darkred","blue"))

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13

排除图例还可以通过scale_fill_manual()函数将参数guide设置为FALSE，如下：

ggplot(data = df, mapping = aes(x = x, y = y, fill = judge))+ 
  geom_bar(stat = 'identity', position = 'identity')+ 
  scale_fill_manual(values = c('blue','red'), guide = FALSE)+ 
  xlab('Year')

    1
    2
    3
    4

7.调整条形图的条形宽度和条形间距
geom_bar()函数可以非常灵活的将条形图的条形宽度进行变宽或变窄设置,具体通过函数width参数实现,width的最大值为1,默认为0.9。
注意:binwidth参数只能在geom_histogram()函数中实现
示例：

x <- c("A","B","C","D","E")
y <- c(10,20,15,22,18)
df <- data.frame(x = x,y = y)
# 不作任何条形宽度的调整
ggplot(df,aes(x = x,y = y))+
  geom_bar(stat = "identity",fill = "steelblue",colour = "black")

# 使条形宽度变宽
ggplot(df,aes(x = x,y = y))+geom_bar(stat = "identity",fill = "steelblue",colour = "black",width = 1)

    1
    2
    3
    4
    5
    6
    7
    8
    9

对并列排放的条形图,还可以调整条形之间的距离,默认情况下,条形图的组内条形间隔为0，具体可通过函数position_dodge参数实现条形距离的调整。如果希望增加组内条形的间距,一般将条形距离设置的比条形宽度大一点。
示例：

x <- rep(1:5,each = 3)
y <- rep(c("A","B","C"),times = 5)
set.seed(12)
z <- round(runif(min = 10,max = 20,n = 15))
df <- data.frame(x = x,y = y,z = z)
# 不做任何条形宽度和条形距离的调整
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",position = "dodge")

# 调整条形宽度和条形距离
ggplot(df,aes(x = factor(x),y = z,fill = y))+
  geom_bar(stat = "identity",width = 0.5,position = position_dodge(width=0.7) )

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12

8.添加数据标签
geom_text()函数可以方便的在图形中添加数值标签aes(label = )

x <- rep(1:5,each = 3)
y <- rep(c("A","B","C"),times = 5)
set.seed(12)
z <- round(runif(min = 10,max = 20,n = 15))
df <- data.frame(x = x,y = y,z = z)
 # 添加标签
ggplot(df,aes(x = interaction(x,y),y = z,fill = y))+
  geom_bar(stat = "identity")+
  geom_text(aes(label = z))

#调整标签的大小、颜色、位置
ggplot(df,aes(x = interaction(x,y),y = z,fill = y))+
  geom_bar(stat = "identity")+
  ylim(0,max(z)+1)+
  geom_text(aes(label = z),size = 5,colour = "orange",hjust = 1)

# vjust 调整标签竖直位置,越大,标签越在条形图的上界下方；0.5时，则在中间。
# hjust 调整标签水平位置，越大,标签越在条形图的上界左边；0.5时，则在中间。

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19

水平交错并列的簇条形图，必须通过geom_text()函数中的position_dodge()函数来调整标签位置；
注意：图形位置与标签位置摆放必须一致。

ggplot(data = df, mapping = aes(x = x, y = z, fill = y)) +
  geom_bar(stat = 'identity', position = 'dodge') + 
  geom_text(mapping = aes(label = z), size = 5, 
            colour = 'black', vjust = 1, hjust = .5,
            position = position_dodge(0.9))

    1
    2
    3
    4
    5

堆叠的簇条形图，必须通过geom_text()函数中的position_stack()参数来调整标签位置

ggplot(data = df, mapping = aes(x = x, y = z, fill = y)) +
  geom_bar(stat = 'identity', position = "stack") + 
  geom_text(mapping = aes(label = z), size = 5, 
            colour = 'black', vjust = 3.5, hjust = .5,
            position = position_stack()) 