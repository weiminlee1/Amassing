##REmap包的使用##

<b>托管在GitHub</b></br>
1 下载方法
##
` library(devtools)`
 
 `install_github('lchiffon/REmap')`
 
 2 获取经纬度
 
 > get_city_coord ( ) 获取一个城市的经纬度
 
 >get_geo_position ( ) 获取一个城市向量的经纬度
 
 >library(REmap)
 >city_vec = c("北京", "shanghai", "guangzhou")
 >get_city_coord("Shanghai") 单个城市
 >get_geo_positon(city_vec) 一组城市的经纬度
 
 3 绘制迁徙地图
 
 绘制迁徙地图使用的主函数remap
 
 >remap(mapdata, title = "" subtitle = ", theme = get_theme("Dark")
 
 mapdata 一个数据框对象，第一列为出发地点，第二列为到达地点

 title 标题
 
 subtitle 副标题
 
 theme 控制生成地图的颜色，具体会在get_theme 部分说明


>set.seed(125)</br>
origin = rep("北京",10)</br>
destination = c('上海','广州','大连','南宁','南昌',
                '拉萨','长春','包头','重庆','常州')</br>
dat = data.frame(origin,destination)

>out = remap(dat,title = "REmap实例数据",subtitle = "theme:Dark")</br>
plot(out)
 
 
## 个性化地图

正如之前所说的,为了简化学习和使用的流程,REmap并没有封装太多的参数.(真的不是我懒)如果想更个性化地调整Echarts的参数,请移步Echarts的官方文档http://echarts.baidu.com/doc/doc.html

REmap中get_theme提供了迁徙地图中常用颜色的调整:

get_theme(theme = "Dark", lineColor = "Random",
  backgroundColor = "#1b1b1b", titleColor = "#fff",
  borderColor = "rgba(100,149,237,1)", regionColor = "#1b1b1b")

    theme 默认主题,除了三个内置主题,可以使用“none”来自定义颜色
        a character object in (“Dark”,“Bright,”Sky“,”none“)
    lineColor 线条颜色,默认随机,也可以使用固定颜色
        Control the color of the line, “Random” for random color
    backgroundColor 背景颜色
        Control the color of the background
    titleColor 标题颜色
        Control the color of the title
    borderColor 边界颜色(省与省之间的信息)
        Control the color of the border
    regionColor 区域颜色
        Control the color of the region

颜色可以使用颜色名(比如’red’,’skyblue’等),RGB(“#1b1b1b”,“#fff”)或者一个rgba的形式(“rgba(100,100,100,1)”),可以在这里找到颜色对照表.

## 默认模板: Bright

 default theme:"Bright"
>set.seed(125)

>out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("Bright"))
plot(out)


##更改线条颜色

set Line color as 'orange'
>set.seed(125)
out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("None",
                             lineColor = "orange"))
plot(out)


##更改其他颜色

Set Region Color
>out = remap(dat,title = "REmap实例数据",subtitle = "theme:Bright",
            theme = get_theme("None",
                              lineColor = "orange",
                              backgroundColor = "#FFC1C1",
                              titleColor = "#1b1b1b",
                              regionColor = '#ADD8E6'))
plot(out)


##remapC--分级统计图
remapC是用于创建分级统计图(Choropleth map).即根据子区域数值的多少进行深浅不同的颜色填充的地图形式.目前支持的地图为:

 - ‘china’ 中国省份地图
 - ‘world’ 世界地图
- 各省市地图,如’广东’,’西藏’等…

<b>函数的调用形式为:</b>


> remapC(data,
      maptype = 'china',
      
      color = c('#1e90ff','#f0ffff'),
      theme = get_theme("Bright"),
      title = "",
      subtitle = "",
      mindata = NA,
      maxdata = NA,
      # mark Line & point
      markLineData = NA,
      markPointData = NA,
      markLineTheme = markLineControl(),
      markPointTheme = markPointControl(),
      geoData = NA)

    data: 数据框,第一列为子区域名(比如全国地图的省名,省级地图的市名)
    color: 传入单个颜色就使用从白色到该色的填充,多个颜色根据值大小计算填充颜色
    maptype: 地图的格式,’china’代表中地图,’world’代表世界地图

data 格式</br>

- V1  V2
- 北京 629
- 天津 516
- 上海 280
- 重庆 933
- 河北 296
- 河南 172

>data = data.frame(country = mapNames("world"),
                   value = 5*sample(178)+200)
                   
>head(data)

>remapC(data,maptype = "world",color = 'skyblue')

其中mapNames()函数可以得到某个地图下的子图信息:

mapNames('西藏')

[1] "那曲地区"   "阿里地区"   "日喀则地区" "林芝地区"  
[5] "昌都地区"   "山南地区"   "拉萨市" 

>data = data.frame(country = mapNames('西藏'),
                   value = 50*sample(7)+200)

>head(data)

>remapC(data,maptype = '西藏',color = 'skyblue')

其他的参数: - theme: 地图的主题,里面可以设置背景颜色,标题颜色,边界颜色等 - title,subtitle: 标题与附标题 - max,min: dataRange的最大最小值

比如,精细的调整一下最初的地图:
>remapC(chinaIphone,
        title = "remapC实例地图",
        theme = get_theme('none',backgroundColor = '#fff',
                          titleColor = "#1b1b1b",
                          pointShow = T),
        max = 2000)
        
 最后,再演示下remapC中使用markLine和markPoint的效果:

>remapC(chinaIphone,
        title = "remapC实例地图",
        theme = get_theme('none',backgroundColor = '#fff',
                          titleColor = "#1b1b1b",
                          pointShow = T),
        max = 2000,
        markLineData = demoC,
        markPointData = demoC[,2])       
        
      
##remapB的使用

函数的调用形式为:

remapB(center = c(104.114129,37.550339),
       zoom = 5,
       color = "Bright",
       title = "",
       subtitle = "",
       # mark Line & point
       markLineData = NA, #矩阵(出发地，目的地）
       markPointData = NA, # 目的地
       markLineTheme = markLineControl(),
       markPointTheme = markPointControl(),
       geoData = NA)

先说除去markline和markpoint的参数:

    center: 地图的中心(经纬度坐标),可以从get_city_coord获得
    zoom: 地图缩放尺寸,越小地图越大,(5代表国家级的地图,15代表市级的地图)
    color: 地图的颜色风格,目前仅开放了“Bright”和“Blue”,两种,细节调整参见百度地图API来修改html的源代码
    

##可以用remapB来查看某个城市的地图

remapB(get_city_coord("北京"),zoom = 12)


简单演示下remapB中使用markLine和markPoint的效果:

remapB(title = "Bmap 迁徙图示例",
        color = "Blue",
        markLineData = demoC,
        markPointData = demoC[,2])
        
 
##markLine

markLine是Echarts中进行标线的工具.通过标线(直线,曲线),可以完成很多有意思的可视化
先说一下markLine相关的参数,这些参数可以在remapC或者remapB中调用:

    markLineData 标线使用的数据,第一列为出发地,第二列为目的地
    markLineTheme 控制标线颜色,形状等,由markLineControl来控制
    geoData 标中各个点的经纬度坐标,如果没有,会使用BaiduAPI自动查找

一个简单的示例:

remapB(title = "Remap:  百度迁徙模拟",
       color = "Blue",
       markLineData = demoC)
       

<b>markLineTheme</b>

markLineTheme控制了标线的风格,使用markLineControl来调用,这里列出主要的参数:

markLineControl(symbolSize = c(2,4),
      smoothness = 0.2,
      effect = T,
      lineWidth = 1,
      lineType = 'solid',
      color = "Random") 

    SymbolSize:
        形状的大小,标线默认是一段无形状,一段箭头,如果不想要箭头可以使用symbolSize = c(0,0)
    smoothness:
        曲线的弯曲度,取0标线会退化为直线
    effect:
        炫光特效,标线较多的时候建议关闭
    lineWidth:
        标线的宽度
    lineType:
        标线的样式: ’solid’实线’dotted’点线或者 ’dashed’虚线
    color:
        颜色,默认为随机颜色,设置一个颜色会取为固定颜色
        此外对markLineData下设置color变量会覆盖该颜色

remapB(title = "Remap:  百度迁徙模拟",
       color = "Blue",
       markLineData = demoC,
       markLineTheme = markLineControl(symbolSize = c(0,0),
                                       lineWidth = 10,
                                       lineType = 'dashed'))
                                       
                                       
<b>设置额外的颜色:</b>

demoC$color = sample(c("red","blue"),10,replace = T)

remapB(title = "Remap:  百度迁徙模拟",
       color = "Blue",
       markLineData = demoC,
       markLineTheme = markLineControl(symbolSize = c(0,0),
                                       lineWidth = 10,
                                       effect = F,
                                       lineType = 'dashed'))
                                       
 
##geoData

mapC和mapB中,都会有geoData这个变量,用以储存markLine和markPoint的地理位置信息.具体的格式与get_city_coord返回相同:

    第一列lon -经度
    第二列lat -纬度
    第三列地理名称

get_geo_position(c("Beijing","Shanghai","Guangzhou"))

       lon      lat      city
1 116.4232 39.91528   Beijing
2 121.5221 31.30477  Shanghai
3 113.2684 23.12980 Guangzhou

下面是一个例子,通过这个例子可以看到markLine的使用方式
Example:地铁线路可视化

这里,我们使用REmap中自带的subway来进行演示,是上海地铁一号线的线路信息,其中<b>subway[[1]]为各个点的经纬度坐标,subway[[2]]为各个点的连线方式</b>.(数据来源于百度API)

各个点的经纬度坐标

head(subway[[1]])

               V1              V2              name
1 121.43102542826 31.398676380258 yihaoxian Point 1
2 121.43132186908 31.397705460498 yihaoxian Point 2
3 121.43154644546 31.396665178073 yihaoxian Point 3
4 121.43339695481 31.391602304084 yihaoxian Point 4
5 121.43433119254 31.387733681833 yihaoxian Point 5
6 121.43766390598 31.374986126392 yihaoxian Point 6

各个点的连线方式

head(subway[[2]])

             origin       destination
1 yihaoxian Point 1 yihaoxian Point 2
2 yihaoxian Point 2 yihaoxian Point 3
3 yihaoxian Point 3 yihaoxian Point 4
4 yihaoxian Point 4 yihaoxian Point 5
5 yihaoxian Point 5 yihaoxian Point 6
6 yihaoxian Point 6 yihaoxian Point 7

remapB(center = get_city_coord("上海"),
       zoom = 13,
       title = "Remap:  上海地铁一号线",
       color = "Blue",
       markLineData = subway[[2]],
       markLineTheme = markLineControl(smoothness = 0,
                                       effect = T,
                                       symbolSize = c(0,0)),
       geoData = subway[[1]])
       
##markPoint

markPoint是Echarts中进行标点的工具.通过不同形状的点(箭头,星,圆或者自定义的图片)来完成点的标注

与markLine类似,markPoint相关的参数,可以在remapC或者remapB中调用:

    markPointData 标点使用的数据,可以是一个向量,如果是数据框就仅使用第一列.
    markPointTheme 控制标点颜色,形状等,由markPointControl来控制
    geoData 标中各个点的经纬度坐标,如果没有,会使用BaiduAPI自动查找

一个简单的示例:

remapB(title = "Remap:  百度迁徙模拟",
       color = "Blue",
       markPointData = demoC[,2])
   
##markPointTheme

markPointTheme控制了标线的风格,使用markPointControl来调用,这里列出主要的参数:

markPointControl(symbol = 'emptyCircle',
                  symbolSize = "Random",
                  effect = T,
                  effectType = 'scale',
                  color = "Random")

    symbol:
        ‘circle’,‘emptyCircle’,圆,空心圆
        ‘rectangle’,‘emptyRectangle’,方块,空心方块
        ‘triangle’,‘emptyTriangle’,三角,空心三角
        ‘diamond’,‘emptyDiamond’,钻石,空心钻石
        ‘heart’心形,’droplet’,水滴
        ‘pin’,POI标注,’arrow’箭头, ’star’五角星
        或者使用’image://http://….’来引用一个图片
        此外对markLineData下设置symbol变量会覆盖该颜色
    symbolSize:
        标点的大小
    effect:
        炫光特效,标线较多的时候建议关闭
    effectType:
        炫光特效的方式,’scale’放大,或者’bounce’跳动
    color:
        颜色,默认为随机颜色,设置一个颜色会取为固定颜色
        此外对markLineData下设置color变量会覆盖该颜色

remapB(title = "Remap:  markPoint示例",
       color = "Blue",
       markPointData = demoC[,2],
       markPointTheme = markPointControl(symbol = 
      "image://http://chiffon.gitcafe.io/assets/images/df_logo.jpg",
                                        symbolSize = 15,
                                       effect = F))
                                     
##绘制点图

前20个标注为天蓝色,后10个标注为红色
pointData = data.frame(geoData$name,
                       color = c(rep("skyblue",20),
                                 rep("red",10)))



remapB(get_city_coord("上海"),
       zoom = 13,
       color = "Blue",
       title = "上海美食",
       markPointData = pointData,
       markPointTheme = markPointControl(symbol = 'pin',
                                         symbolSize = 5,
                                         effect = F),
       geoData = geoData)
 
## 当然在一个地图中可以混合标点与标线的信息

names(geoData) = names(subway[[1]])
remapB(get_city_coord("上海"),
       zoom = 13,
       color = "Blue",
       title = "Remap:  MarkPoint&MarkLine",
       markPointData = pointData,
       markPointTheme = markPointControl(symbol = 'pin',
                                         symbolSize = 5,
                                         effect = F),
       markLineData = subway[[2]],
       markLineTheme = markLineControl(symbolSize = c(0,0),
                                       smoothness = 0),
       geoData = rbind(geoData,subway[[1]]))
      
 
 
##remapH

>remapH(data,
      maptype = 'china',
      theme = get_theme("Dark"),
      blurSize = 30,
      color = c('blue', 'cyan', 'lime', 'yellow', 'red'),
      minAlpha = 0.05,
      opacity = 1,
      ...)
  
- data -a data frame including lontitude, latitude and density

- maptype -the type of the map. For exameple,'china', 'world' or other names of province in China.

- theme -a list object created by get_theme,control the color of the map.

- blurSiz -blur size of the data point, default is 30.

- color -a vector of strings like ['blue', 'cyan', 'lime', 'yellow', 'red'], with which the color will transform evenly.

- minAlpha -If the unified value is less than minAlpha, remapH will be set to minAlpha to ensure small data value can also be visible on the chart.
- opacity	
Opacity of the heatmap. Default is 1
- ...	other paramters like title, subtitle,data for mark line