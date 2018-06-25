string.join函数的使用方法
python 中有join()和os.path.join()两个函数
join(): 连接字符串数组，将字符串、元组、列表中的元素以指定的字符（分隔符）（可以为空字符）连接生成一个新的字符串
os.path.join():将多个路径组合后返回
>>> seq1 = ['hello','good','boy','doiido']  
>>> print ' '.join(seq1)  
hello good boy doiido  
>>> print ':'.join(seq1)  
hello:good:boy:doiido 

sys模块：处理系统环境的函数的集合
sys.argv是存储输入参数的列表。默认情况下，argv自带的参数是文件名

如果要在一行中书写多个语句，就必须使用分号分隔了，否则Python无法识别语句之间的间隔。Python更倾向于使用换行作为每条语句的分隔。通常一行只写一条语句，这样便于阅读和理解程序。
Python同样支持多行写一条语句，Python用'\'作为换行符。

局部变量：只能在函数或代码块内使用的变量。函数或代码块段一旦结束，局部变量的生命周期也就结束。

全局变量：全局变量是能够被不同的函数，类或文件共享的变量，在函数之外定义的变量都可以称为全局变量。
global （关键字）用于引用全局变量

Python的每个对象都有一个属性__doc__,这个属性用于描述该对象的作用

三引号的另一种用法是制作文档字符串
class hello：
    '''hello class'''
    def printhello():
        '''print hello world'''
        print 'hello world'
print hello.__doc__
print hello.printhello.__doc__

input()函数捕获用户的原始输入并将其转换为字符串。
input([promot]) -> string

连接两个列表：有两种方式，一种是调用extend()连接两个不同的列表， 另一种使用运算符'+'或'+='.
list = ['l','w','m']
查找位置
list.index('l')
排序
list.sort()
倒序
list.reverse()

append(object) 在列表的末尾添加一个对象object
pop([index]) 删除索引index的指定的值，如果index不指定，删除列表中最后一个元素
insert(index,object) 在指定的索引index处插入一个对象object
extend(iterable) 将iterable指定的元素添加到列表的末尾

字典的添加，删除和修改非常简单，添加或修改只需要编写一条赋值语句：
dict['x']='value'
如果索引x不在字典dict的key 列表中，字典dict将添加一条新的映射(x:value),如果索引在字典dict的key列表中，字典dict将直接修改索引x对应的value值。

字典元素的删除可以调用del()函数实现,del()属于内建函数，直接调用即可。

dict.pop('b') 弹出字典中键为b的元素
dict.copy()复制一个字典中所有的数据

字典的排序
sorted(dict.items(), key=lambda d: d[0])
    lambda 可以创建匿名函数，d[0]表示items()中的key，即按照key值进行排序。
sorted(dict.items(), key=lambda d:d[1])
    按照value值进行排序
    
    
## vars()函数
<code> vars(object) 返回object的属性和属性值的字典对象 </code>

 <code> os.rename("要修改的目录”， “修改后的目录”）
 
##python os.path模块
os.path.abspath(path) #返回绝对路径</br>
os.path.basename(path) #返回文件名</br>
os.path.commonprefix(list) #返回list(多个路径)中，所有path共有的最长的路径。</br>
os.path.dirname(path) #返回文件路径</br>
os.path.exists(path)  #路径存在则返回True,路径损坏返回False</br>
os.path.lexists  #路径存在则返回True,路径损坏也返回True</br>
os.path.expanduser(path)  #把path中包含的"~"和"~user"转换成用户目录</br>
os.path.expandvars(path)  #根据环境变量的值替换path中包含的”$name”和”${name}”</br>
os.path.getatime(path)  #返回最后一次进入此path的时间。</br>
os.path.getmtime(path)  #返回在此path下最后一次修改的时间。</br>
os.path.getctime(path)  #返回path的大小</br>
os.path.getsize(path)  #返回文件大小，如果文件不存在就返回错误</br>
os.path.isabs(path)  #判断是否为绝对路径</br>
os.path.isfile(path)  #判断路径是否为文件</br>
os.path.isdir(path)  #判断路径是否为目录</br>
os.path.islink(path)  #判断路径是否为链接</br>
os.path.ismount(path)  #判断路径是否为挂载点（）</br>
os.path.join(path1[, path2[, ...]])  #把目录和文件名合成一个路径</br>
os.path.normcase(path)  #转换path的大小写和斜杠</br>
os.path.normpath(path)  #规范path字符串形式</br>
os.path.realpath(path)  #返回path的真实路径</br>
os.path.relpath(path[, start])  #从start开始计算相对路径</br>
os.path.samefile(path1, path2)  #判断目录或文件是否相同</br>
os.path.sameopenfile(fp1, fp2)  #判断fp1和fp2是否指向同一文件</br>
os.path.samestat(stat1, stat2)  #判断stat tuple stat1和stat2是否指向同一个文件</br>
os.path.split(path)  #把路径分割成dirname和basename，返回一个元组</br>
os.path.splitdrive(path)   #一般用在windows下，返回驱动器名和路径组成的元组</br>
os.path.splitext(path)  #分割路径，返回路径名和文件扩展名的元组</br>
os.path.splitunc(path)  #把路径分割为加载点与文件</br>
os.path.walk(path, visit, arg)  #遍历path，进入每个目录都调用visit函数，visit函数必须有</br>
3个参数(arg, dirname, names)，dirname表示当前目录的目录名，names代表当前目录下的所有
文件名，args则为walk的第三个参数</br>
os.path.supports_unicode_filenames  #设置是否支持unicode路径名</br>

os.path.sep:路径分隔符 linux下就用这个了’/’</br>
os.path.altsep: 根目录</br>
os.path.curdir:当前目录</br>
os.path.pardir：父目录</br>
os.path.abspath(path)：绝对路径</br>
os.path.join(): 常用来链接路径</br>
os.path.split(path): 把path分为目录和文件两个部分，以列表返回</br>

##Python shutil 模块学习笔记

- shutil 名字来源于 shell utilities，有学习或了解过Linux的人应该都对 shell 不陌生，可以借此来记忆模块的名称。该模块拥有许多文件（夹）操作的功能，包括<b>复制、移动、重命名、删除</b>等等</br>

- shutil.copy(source, destination)
shutil.copy() 函数实现文件复制功能，将 source 文件复制到 destination 文件夹中，两个参数都是字符串格式。如果 destination 是一个文件名称，那么它会被用来当作复制后的文件名称，即等于 复制 + 重命名。举例如下：

  >> import shutil
  >> import os
  >> os.chdir('C:\\')
  >> shutil.copy('C:\\spam.txt', 'C:\\delicious')
  'C:\\delicious\\spam.txt'
  >> shutil.copy('eggs.txt', 'C:\\delicious\\eggs2.txt')
  'C:\\delicious\\eggs2.txt'

如代码所示，该函数的返回值是复制成功后的字符串格式的文件路径

#1. shutil.copytree(source, destination)
- shutil.copytree()函数复制整个文件夹，将 source 文件夹中的所有内容复制到 destination 中，包括 source 里面的文件、子文件夹都会被复制过去。<b>两个参数都是字符串格式。</b>

*****注意，如果 destination 文件夹已经存在，该操作并返回一个 FileExistsError 错误，提示文件已存在。即表示，如果执行了该函数，程序会自动创建一个新文件夹（destination参数）并将 source 文件夹中的内容复制过去
举例如下：
  
  >> import shutil
  >> import os
  >> os.chdir('C:\\')
  >> shutil.copytree('C:\\bacon', 'C:\\bacon_backup')
  'C:\\bacon_backup'

如以上代码所示，该函数的返回值是复制成功后的文件夹的绝对路径字符串
所以该函数可以当成是一个备份功能

#2. shutil.move(source, destination)
shutil.move() 函数会将 source 文件或文件夹移动到 destination 中。返回值是移动后文件的绝对路径字符串。
如果 destination 指向一个文件夹，那么 source 文件将被移动到 destination 中，并且保持其原有名字。例如：

  >> import shutil
  >> shutil.move('C:\\bacon.txt', 'C:\\eggs')
  'C:\\eggs\\bacon.txt'

上例中，如果 C:\eggs 文件夹中已经存在了同名文件 bacon.txt，那么该文件将被来自于 source 中的同名文件所重写。

如果 destination 指向一个文件，那么 source 文件将被移动并重命名，如下：

  >> shutil.move('C:\\bacon.txt', 'C:\\eggs\\new_bacon.txt')
  'C:\\eggs\\new_bacon.txt'

等于是移动+重命名

*****注意，如果 destination 是一个文件夹，即没有带后缀的路径名，那么 source 将被移动并重命名为 destination，如下：

  >> shutil.move('C:\\bacon.txt', 'C:\\eggs')
  'C:\\eggs'

即 bacon.txt 文件已经被重命名为 eggs，是一个没有文件后缀的文件

最后，destination 文件夹必须是已经存在的，否则会引发异常：
  
  >> shutil.move('spam.txt', 'C:\\does_not_exist\\eggs\\ham')
  Traceback (most recent call last):
    File "D:\Python36\lib\shutil.py", line 538, in move
      os.rename(src, real_dst)
  FileNotFoundError: [WinError 3] 系统找不到指定的路径。: 'test.txt' -> 'C:\\does_not_exist\\eggs\\ham'

  During handling of the above exception, another exception occurred:
  
  Traceback (most recent call last):
    File "<pyshell#5>", line 1, in <module>
      shutil.move('test.txt', 'C:\\does_not_exist\\eggs\\ham')
    File "D:\Python36\lib\shutil.py", line 552, in move
      copy_function(src, real_dst)
    File "D:\Python36\lib\shutil.py", line 251, in copy2
      copyfile(src, dst, follow_symlinks=follow_symlinks)
    File "D:\Python36\lib\shutil.py", line 115, in copyfile
      with open(dst, 'wb') as fdst:
    FileNotFoundError: [Errno 2] No such file or directory: 'C:\\does_not_exist\\eggs\\ham'

#3. 永久性删除文件和文件夹
这里有涉及到 os 模块中的相关函数
  os.unlink(path) 会删除 path 路径文件</br>
  os.rmdir(path)　会删除 path 路径文件夹，但是这个文件夹必须是空的，不包含任何文件或子文件夹</br>
  shutil.rmtree(path) 会删除 path 路径文件夹，并且在这个文件夹里面的所有文件和子文件夹都会被删除</br>

利用函数执行删除操作时，应该倍加谨慎，因为如果想要删除 txt 文件，而不小心写到了 rxt ，那么将会给自己带来麻烦</br>
此时，我们可以利用字符串的 endswith 属性对文件格式进行检查与筛选</br>