#R笔记
- 给定一个对象，知道它是由什么数据结构组成的最好方法就是使用 str( ) , str() 是structure的缩写。


##向量

- 向量包括两种风格： 原子向量和列表

-- 
共同属性</br>
<code> 类型， typeof() </br>
长度， length() </br>
属性， attributes()</code></br>
<b> 原子向量中的所有元素必须是相同类型的数据，而列表中的元素可以是不同的类型。</b>

##原子向量

* 类型： 逻辑型， 整形， 数值型， 字符型， 复合型， 原始型
* <code>c()来构建原子向量， c是combine的简写
* 缺失值用NA来表示，它是一个长度为一的逻辑向量，如果在程c()中使用NA，NA就会被强制转换成正确的数据类型。
* <b>判断向量的类型<br></b>
<code>typeof() 来判断它的类型

* <b>强制转换</b></br>

<code>原子向量的所有元素必须具有相同的类型，所以当把不同类型的数据结合成一个向量时，它们会被强制转换成最具灵活性的数据类型。逻辑型<整形<双精度型<字符型</br>
可以使用 as.character(), as.double(), as.integer(), as.logical()来进行显示强制转换</br>

## 列表

* 列表与原子向量不同在于列表中的元素可以是任意类型，甚至包括列表。</br>
* <code>使用list()来创建列表 原子向量和列表结合在一起的时候， c()会强制将向量转换成列表，然后再将它们结合在一起。

<b> 将列表转换成原子向量的方法是 unlist()</b>

##名字

* 3中方式来<b>命名向量中的元素</b>

* 创建时命名：x < c( a=1, b=2, c=3)

* 改变现有向量的名字： x <- 1:3, names(x) <- c('a', 'b', 'c')
* 复制一个向量并修改它的名字： x <- setNames (1:3, c('a', 'b', 'c')


##因子

* 因子就是只能包含预先定义值的向量， 它经常用来储存分类数据。 因子建立在整形向量的基础之上，它具有两个属性： class()和levels()。 class()使得因子与通常的整型向量具有不同的行为，而levels()定义因子中所有<b>可能的取值。</b> 
* 虽然因子看上去很像字符型向量，但他其实是整型。

##矩阵和数组

* 给一个原子向量添加dim()属性之后， 它的行为就像多维数组了。数组的一个特例就是矩阵，它是二维的。
* <code> a <- matrix(1:6, ncol=3, nrow=2)
* <code>c <- 1:6, dim(c) <- c(3,2)


##数据框<b>是由相同长度的向量构成的列表</b>

* 数据框构建
* 可以使用函数data.frame()来构建数据框， 它的输入是已经命名好的向量
* 需要注意的是，data.frame()的默认行为是把字符串转换成因子。 使用参数stringasFactor = False来禁止这种转换。

##数据判断和强制转换

<code> is .data.frame()判断是否是数据框类型</br>
as.data.frame()进行强制转换</code>


##合并数据框

* 可以使用cbind() 和 rbind()对数据框进行合并


    (1)当进行列向合并时， 两个数据框的行数必须保持一致， 行的名字可以忽略。</br>
    (2) 当进行行向合并时， 两个数据框的列数必须保持一致且列名必须一致。</br>
    (3) 如果两个数据框没有相同列， 可以使用plyr::rbind.fill()来进行合并。
  
* merge 函数</br>
    (1) 横向合并两个数据框， 两个数据框是通过一个或多个共有变量进行联结的：</br>
    <code>total <- merge(dataframe1, dataframe2, by=c("ID","Country")
##特殊列

当对列表使用data.frame()时， 它会将列表中的每个元素都放入自己的列中，就会报错。

使用I()可以避免这种错误，它使data.frame()把列表看做一个单元。

<code>df <- data.frame(x = 1:3, y = I(list(1:2,1:3,1:4))) ##I()可以给他的输入加上AsIs类
</code>

# 子集选取
<code> mtcars[mtcars$cyl == 4, ]</br> #选取cyl这列等于4的数据
mtcars[c('cyl','disp')]</br>
mtcars[c(1,3),] #选取第一和第三行数据</br>
mtcars[ , c(1,3)] # 选取第一和第三列数据</br>

##剔除数据框中某些列
 <code>df <- data.frame(x=1:3, y=3:1, z= letters[1:3])</br>
 df$z <- NULL
 
 
 - 根据条件选取行：&和， | 或
 - subset() 是对数据框进行子集选取的专用函数。 subset(data, condition)
 - </br>
 
##
#提取样本（行）</br>

`newdata <- patientdata[which(patientdata$status == 'poor' $ patientdata$age > 30), ]`</br>
which()找出坐标，然后[]匹配数据。

##
#subset()函数</br>
`nwedata <- subset(patientdata, age>=30, select=2:4)`</br>
选择数据集中所有age大于等于30的行，并只选第二列到第四列

##
#绘图参数</br>
* 通过par()函数进行全局性参数设置，可以通过修改图形参数的选项自定义图形的某些特征。该方式设定的参数值，如果不再修改，在结束会话前都是有效的.</br>
    <code><font size=4>par() # 查看当前绘图参数设置</br>
    opar <- par # 保存当前设置</br>
    par (col.lab = 'red') #设置坐标轴的标签为红色</br>
    hist(mcars$mpg) #利用新的参数进行绘图</br>
    par(opar) # 恢复绘图参数的原始设置</code></font>
    
##
#图形的组合</br>
<font size=4> par()中， 图形参数mfrow=c(a,b)可以创建按行填充的，行数为a，列数为b的图形矩阵；而图形参数nfcol=c(a,b)生成的是按列填充的矩阵。</br>
`par(mfrow(2,2)) #设置两行两列的画纸`</br>
layout(matrix(c(1,2,3,3),2,2,byrow=T) #将画纸设定为两行两列；按行排列的矩阵，第一行两个位置分别放置第一幅图和第二幅图，第二行两个位置放置第三幅图。