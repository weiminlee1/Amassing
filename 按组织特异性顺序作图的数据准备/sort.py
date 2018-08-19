#author:WeiminLee
#-*-coding:utf-8-*-
#date:''
#function='按组织的顺序画热图的数据准备'

from itertools import islice
inputdata = open('inputdata','r')
title = inputdata.readline() ##获取第一行

mydict = {} ##用来存放行号和所在行最大值的坐标
mydictrawdata = {} ##用来存放原始数据
for line in islice(open('inputdata','r'),1,None):
    line = line.strip().split()
    mydictrawdata[line[0]] = line[1:]
    maxindex = line.index(max(line[1:])) ###返回该行最大值的坐标
   # rowid_maxix = line[0] + '\t' + str(maxindex) ##输出行号和最大值的坐标
    mydict[line[0]] = maxindex  ##行号 + 最大值坐标
print mydict

mydict1 = sorted(mydict.items(), key=lambda d:d[0], reverse=False) ##用lambda d 对字典按键排序，reverse=F表示顺序
print mydict1

mydict2 = sorted(mydict.items(), key=lambda d:d[1], reverse=False)##sorted函数对字典按键值排序
print mydict2
print title
for item in mydict2:
    if item[0] in mydictrawdata.keys():
        print item[0] + '\t' + '\t'.join(mydictrawdata[item[0]]) ##输出按一定顺序整理过的数据
    else:
        pass