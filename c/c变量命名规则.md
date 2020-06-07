# 1. 常用单词

| 正义        | 反义          |
| --------- |:-----------:|
| add       | remove      |
| begin     | end         |
| create    | destroy     |
| insert    | delete      |
| first     | last        |
| g et      | release     |
| increment | decrement   |
| put       | get         |
| add       | delete      |
| lock      | unlock      |
| open      | close       |
| min       | max         |
| start     | stop        |
| next      | previous    |
| source    | target      |
| show      | hide        |
| send      | receive     |
| source    | destination |
| cut       | paste       |
| up        | down        |

# 2. 变量

*  普通变量

  * n : `door`

  * n + adj  : `door_width` 、`door_right_width`

  * n + adj + adv : `door_width_big`

  * n + verb : `door_open`

* 全局变量

  *  `g_variable`

* 指针变量

  * `p_variable`

* bool变量

  * `b_in_word`、`b_pen_down`

* 结构体变量

* 宏定义变量

  * 全大写        eg: `#define SIZE 32`

# 3. 函数名

```
原则：1. 见名知意
     2. 自定义函数函数名首字母大写（库函数里的函数名都是以小写字母定义，为了区分库函数和自定义函数，避免冲突）
```

* 一般格式：`n_verb_分类`            eg : `Lcd_init_s3c2440`、`Lcd_init_ti`

* 返回状态参数的函数：              eg : `Is_list_full`

# 4. 参数传递顺序

* 按ascii表顺序、变量类型从小到大

  > 整型 : `char、short、int、long、long long`
  > 
  > > 浮点 :` float、double`
  > > 
  > > > 指针 : `char*、short*、int*、long*、long long*、float*、double*、struct kind*`
  > > > 
  > > > > 字符串 
  > > > > 
  > > > > > 结构体

  eg: `void Function_name(int, double, char *, "string", struct kind name)`

  




