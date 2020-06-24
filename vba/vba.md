# VBA 

VBA是VB的一个子集，主要用于office软件中。

## 1. 数据类型

1. 数字

   ```
   byte		0 ~ 255
   integer		-32768 ~ 32767
   long		-2,147,483,648 ~ 2,147,483,648
   single		负值：-3.402823E+38 ~ -1.401298E-45，正值： 1.401298E-45 ~ 3.402823E+38
   double		负值：-1.79769313486232e+308 ~ -4.94065645841247E-324，
   			正值：4.94065645841247E-324 ~ 1.79769313486232e+308
   currency	-922,337,203,685,477.5808 ~ 922,337,203,685,477.5807
   decimal		如果不使用小数，则为+/- 79,228,162,514,264,337,593,543,950,335；如果使用小数，则为：+/- 7.9228162514264337593543950335
   ```

2. 非数字

   ```
   string					固定长度：1 ~ 65,400个字符；可变长度：0到20亿字符
   date					100年1月1日至9999年12月31日
   boolean					True / False
   object					任何嵌入对象
   variant(numeric)		任何大到double的数字值
   variant(text)			与可变长度的string一样。
   ```

3. 数组

   ```vb
   dim a(5) as integer			'声明一个数组，长度为5，索引：1~5
   a(i) = "hello"				'赋值
   a(i)						'引用
   ```

   

## 2. 条件语句

1. if

   ```vb
   if condition then
       ...
   elseif condition then
       ...
   else
       ...
   endif
   ```

   

## 3. 循环语句

1. do while loop

   ```vb
   do while condition
       ...
       exit do
   loop
   ```

2. for next

   ```vb
   for i = 1 to n step 2
   	...
   	exit for
   next i
   ```

   

## 4. 运算符

* 算术

```
=	赋值
+	加
-	减
*	乘
/	除
%	模运算
^	指数
```

* 逻辑

```
and		与
or		或
not		非
xor		异或
iif(y>5,"yes","no")		三目运算符（相当于C中 a>b ? y : n）
```

* 比较运算

```
=	相等
<>	不等于
>	大于
<	小于
>=	大于等于
<=	小于等于
```

* 连接运算

```
+	如果2个值为数值，则相加；有一个是string，则连接
&	如果2个值为数值或string，都连接
```



## 5. Sub

```vb
sub sub_name()
    ...
    exit sub
end sub
-----------------------
call sub_name			'调用
```

sub是VB下的子过程，能够像函数一样互相调用，但没有返回值。<br>sub 可以call sub，也可以call function。<br>用private修饰的sub则只能在本模块下被调用（相当于C中static）

## 6. Function

```vb
function func_name() as integer		'返回值的类型
    ...
    func_name = val		'返回值
    ...
    exit function		'用于退出function
end function
-----------------------
call func_name			'调用
```

Function是VB中的函数，能够相互调用，并且有返回值<br>

## 7. sub和function

1. 参数传递

   在VB中，sub和function的参数传递有2种：byval, byref。且默认byref传递<br>byval是值传递，只传递副本；byref是引用传递，传递的是地址（指针）<br>

2. 调用

   sub能call sub，也能call function。<br>function能call sub, 也能call function

3. 独立运行

   sub能独立运行<br>function分2种情况：<br>无形参时，能独立运行；有形参时，不能独立运行

## 8. Execl相关

1. 对象

   - workbook

     ```vb
     wkb = Workbooks.Open("C:\Users\Administrator\Desktop\水样品编号一览表(更新到6月).xlsx")			'获得一个workbook对象
     ```

   - worksheet

     ```vb
     sheets(1)				'按顺序索引
     sheets("name")			'按名字索引
     ```

     

   - cells

     ```vb
     cells.value							'单元格值
     cells.interior.colorindex			'单元格背景色
     cells.font.colorindex				'单元格字体颜色
     cells.formula						'单元格公式
     ```

     

2. 操作

   ```
   1. Range(Cells(r, 1), Cells(r, 3)).Select				'选中
   2. Selection.AutoFill Destination:=Range(Cells(1, 1), Cells(5, 5)), Type:=xlFillDefault								        '填充
   3. sheets.UsedRange.rows.Count							'获得sheets的有效行数
   4. Selection.Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove	'插入
       
   ```

   

3. 单元格绝对引用 & 相对引用

   ````vb
   cells(row, colum)		'绝对引用
   cells.formulaR1C1		'相对引用
   R[-1]C					'R1C1上方
   R[+1]C					'R1C1下方
   RC[-1]					'R1C1左边
   RC[+1]					'R1C1右边
   ````

4. InputBox & MsgBox

   ```vb
   inputbox("提示")			'输入盒子（相当于python中input（））
   msgbox("info")			  '输出信息info到一个跳出的小窗口
   ```

   



