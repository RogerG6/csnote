# 汇编知识总结
## 基础知识
	计算机中所有的信息都是以二进制的形式存储的
	存储单元：一个存储单元的大小为8位，即8bit，1Byte
	总线：CPU有许多管脚，通过管脚引出总线，总线和存储器相连。有3种总线
		1. 地址总线：决定CPU寻址能力
				宽度N，则CPU最多可以寻找2^N个内在单元		eg:N=32，2^32Byte=4GB
		2. 数据总线：决定CPU与其他器件传送数据时，一次性传送的数据量
				宽度N		eg:	N=16， 则一次能传输2Byte；N=8， 则一次能传输1Byte
		3. 控制总线：决定CPU对系统中其他器件的控制能力
				传输命令	eg: 读写命令
	主板
		1. cpu 
		2. 存储器
			分类：ROM：只读不能写，断电也能存储(硬盘)，一般装有系统BIOS
				  RAM：可读可写，但必须带电存储(内存)
					 主RAM(主内存)
					 各类接口卡上的RAM(显存……)
			内在地址空间：
				eg8086:	0~9FFFH			主RAM
						A000H~BFFFH		显存
						C000H~FFFFH		各个ROM
		3. 外置芯片组
		4. 扩展插槽
			1)RAM内存条
			2)各类接口卡: cpu不直接对外设进行控制，而是通过接口卡间接控制外设
				CMOS RAM芯片
					1) 包含一个实时钟和一个有128个存储单元的RAM存储器 
					2) 靠电池供电，关机后实时钟仍能运行，RAM中信息不丢失
					3) 128byteRAM 中，实时钟：0~0dh ，其余大部分保存系统配置信息，供系统启时BIOS程序读取
							CMOS RAM中存放着当前的时间：年月日时分秒，各占1byte，以BCD码表示，存放单元为：
							秒：0	分：2	时：4	日：7	月：8	年：9
					4) 有2个端口：70h ————地址端口，存放要访问的CMOS RAM单元的地址
								  71h ————数据端口，存放从选定的CMOS RAM中读取的数据或要写入的数据
		
## 寄存器(8086)
	1. 按属性分
		AX,BX,CX,DX——通用寄存器，存放一般性数据，16bit
		CS,DS,SS,ES——段寄存器，存放段地址，16bit
		IP,SI,SP,BP,DI——存放偏移地址，16bit。
			其中，SI/DI不能分成2个8bit寄存器使用
		PSW(程序状态字)
		
			15	14	13	12	11	10	9	8	7	6	5	4	3	2	1	0
							OF	DF	IF	TF	SF	ZF		AF		PF		CF	
			--------------------------------------------------------------------
					0			1
			OF		no overfow	overfow			溢出，针对signed
			DF		cld			std				数据传送
			SF		>=0    		<0				符号位
			ZF		!=0			0				结果是
			AF
			PF		odd			even			1 的个数的奇偶
			CF		carry		no carry		进位，针对unsigned
			------
			IF		cli			sti				可屏蔽中断响应与否
			TF									单步中断
			
	2. 按使用分
		CS-IP：命令段，指向哪个地址，就该地址开始执行其中的命令
		DS-	 ：数据段
		SS-SP/BP：栈段，SP指向栈顶。入栈：SP-2， 压入数据；出栈：弹出数据，SP+2。 BP用来读取栈中数据
		ES-  ：附加段
## 内存寻址方式
	地址表示：存储单元的地址用段地址(SA)和偏移地址(EA)来表示：物理地址 = SA * 16 + EA
	标号：
		地址标号：仅仅表示地址
			eg:  s: ———— 有：的地址标号只能在code segment中使用
		数据标号：标记了存储数据单元的地址和长度(PS:在其他段中使用数据标号，需用assume 将标号所在的段和一个段寄存器联系起来)
			eg:  b dw 0,1,2,3 ———— 地址为b且长度为word
				 mov ax,b[si]……		
 
	寻址方式
		直接寻址：[idata]
		reg 间接寻址：[bx],[si],[di],[bp]
		ret 相对寻址：[bx+idata]
							eg:
								mov ax,200[bx]
								mov ax,[bx].200
					  [si+idata]
					  [di+idata]
					  [bp+idata]
		基址变址寻址：[bx+si],[bx+di]	eg: mov ax,[bx][si]
					  [bp+si],[bp+di]
		相对基址变址寻址：[bx+si+idata]
						  [bx+di+idata]
						  [bp+si+idata]
						  [bp+di+idata]
								eg:
									mov ax,200[bx][si]
									mov ax,[bx].200[si]
									mov ax,[bx][si].200
						
## 指令
	1. Debug命令
		R：查看、改变寄存器的值
		D：查看内存中的内容
		U：将内存中的机器指令翻译成汇编指令
		A：在内存中以汇编命令的形式写入机器指令
		T：执行一条机器指令
		G：跳至指定内存单元执行
		P：执行int 21h 必须用p指令
	2. 数据传送指令
		mov
		push,pop
		pushf,popf
		xchg
		
	3. 算术运算指令
		add,sub
		adc：进位加
		sbb：借位减
		imul
		idiv
		inc,dec
		cmp
		aaa
	4. 逻辑指令
		and,or,not,xor,test
		shl,shr
			shl: 1） 将寄存器or内存中的数据左移位
				 2） 将最后移出的一位写入CF中
				 3） 最低位用0补充 
			eg: 
				shl 1
				mov cl,4		;移动位数必须用cl存放
				shl cl
				
		sal,sar,rol,ror,rcl,rcr
	5. 转移指令
		无条件转移：jmp
		条件转移：jcxz,je,jb,ja,jna,jnb
		循环：loop
		过程：call,ret,retf
			ret: pop ip, 近转移
			retf: pop ip, pop cs, 远转移
		中断：int,iret
	6. 处理机控制指令
		cld,std
			cld: 令df=0， 控制每次操作后si,di递增，正向传输
			std: 令df=1， 控制每次操作后si,di递减，逆向传输
		cli,sti
		nop
		clc,cmc,stc,hlt,wait,esc,lock
	7. 串处理指令 (若需要这些指令进行批量数据处理，需和rep,repe,repne前缀配合使用)
		movsb,movsw
		cmps,scas,lods,stos
	8. 其他
		org：传送时，从偏移地址开始偏移		eg: org 200h
		seg：取某一标号的段地址
		offset：取偏移地址
		in, out(端口读写指令)
			eg: in al,20h	从20h读入一个Byte到al
				out 20h,al	从al往20h写入一个Byte
## 中断
### 内中断：来自cpu内部
		分类
				1) 除法错误
				2) 单步执行
				3) 执行into指令
				4) 执行int指令
			单步中断
				若检测到TF=1, 则执行完当前指令后产生单步中断，中断类型码为1，过程与中断一样
				TF=0,则不产生单步中断
			int指令
				BIOS和DOS的所提供的中断例程 
					安装过程：1) 开机后，cpu一加电，初始化CS:IP,自动从FFFF:0 开始执行程序，此处有一条转跳指令，转去BIOS中的硬
					             件系统检测和初始化程序
							  2) 初始化程序建立BIOS所支持的中断向量，将中断例程的入口登记在中断向量表中，例程固化在ROM中
							  3) 硬件系统检测和初始化完成后，调用int 19h 进行操作系统引导，从此计算机由操作系统控制
							  4) DOS启动后，除完成其他工作，还将它提供的中断例程装入内存，并建立相应的中断向量
					BIOS中断例程
						int 10h: 包含多个与屏幕输出相关的子程序
					DOS中断例程
						int 21h
		中断向量表：中断例程入口地址的列表
		过程：1) 取得中断类型码N
			  2) pushf 
			  3) TF=0, IF=0
			  4) push CS, push IP
			  5) (IP) = (N * 4), (CS) = (N * 4 +２)
			  6) 执行中断例程并返回
		安装中断例程
			1) 将中断例程的代码传送到指定位置(eg: 0:200f)
			2) 设置中断向量表，将地址写入中断类型码对应的内存空间中
				
### 外中断：来自cpu外部，一般为外设
#### 可屏蔽中断：当cpu检测到可屏蔽中断信息时，若IF=1,则执行完指令后呼应;若IF=0 ，则不响应
#### 不可屏蔽中断：cpu必须响应的外中断

--------------
#### BIOS中断例程
* int 10h

			内部通过ah来传递子程序的编号
			eg: 
			mov ah,2   ;置光标
			mov bh,0   ;第0页
			mov dh,5   ;第5行
			mov dl,12  ;第12列
			int 10h
			
			mov ah,9	;在光标位置显示字符
			mov al,'a'	;字符
			mov bl,7	;颜色属性
			mov bh,0	;第0页
			mov cx,3	;字符重复次数
			
* int 9<br>	

			用来处理键盘输入，读出60h端口的扫描码，将扫描码和对应的ASCII码放入BIOS键盘缓冲区，高8位存放扫描码，低8位存放ASCII
			还有一些对键盘系统的控制，如向相关芯片发出应答信息
			

* int 16h<br>	

			mov ah,0	;功能号0：从键盘缓冲区读取一个键盘输入。结果：(ah)=扫描码，(al)=ASCII<br>	
			int 16h		 检测缓冲区有无数据，有则执行0号功能，无则继续检测。直到键盘输入数据，缓冲区中有数据<br><br>	

	
* int 13h<br>	

			mov ax,0 	
			mov es,ax 	
			mov bx,200h		;es:[bx]指向接收从扇区读入数据的内存区
			mov al,1	;读取的扇区数
			mov ch,0	;磁道号
			mov cl,1	;扇区号
			mov dl,0	;驱动器号，	软驱：从0开始，0:软驱A，1：软驱B
									硬盘：从80h开始，80h:C盘，81h:D盘
			mov dh,0	;磁头号，即软盘的面号
			mov ah,2	;功能号，2表示读扇区
			int 13h
			
------------------------
			mov ax,0
			mov es,ax
			mov bx,200h		;es:bx指向写入磁盘的数据 
			
			mov al,1	;写入的扇区数
			mov ch,0	;磁道号
			mov cl,1	;扇区号
			mov dl,0	;驱动器号
			mov dh,0	磁头号，即软盘的面号
			mov ah,3	;功能号，3表示写扇区
			int 13h
			
#### DOS中断例程
* int 21h
			
			mov ah,4ch	;4ch代表调用第21h号中断例程中的4ch号子程序，功能为程序返回
			mov al,0	;返回值
			int 21h
			
			mov ax,data	
			mov ds,ax
			mov dx,0	;ds:[dx]指向字符串的首地址,字符串需用$结束。
			mov ah,9	;9号子程序功能为在光标位置显示字符串，如果字符串较长，遇到行尾，会自动转到下一行开头显示;
						 如果到了最后一行，还能自动上卷一行
			int 21h		
		
