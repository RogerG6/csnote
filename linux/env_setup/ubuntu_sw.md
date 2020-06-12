===========================================================>
 Date       : 2020年 04月 25日 星期六 19:46:06 CST
 Author     : rogerg6
 File       : ubuntu_sw
 Description:
 	记录在ubuntu18.04中装的一些系统服务配置&&软件安装的过程（备忘）
===========================================================>

# 1. 配置ftp服务

1)安装vsftp:
	sudo apt-get install vsftpd

2)启动vsftp
	sudo service vsftpd start

3)创建FTP用户组ftp-users
	groupadd ftp-users

4)创建用户组目录ftp-docs
	mkdir /home/ftp-docs

5)修改权限
	chmod -R 750 /home/ftp-docs
	750组只能读不能写，要组能写，请改成770或760。

6)指定文件夹归属用户和用户组
	chown root:ftp-users /home/ftp-docs

7)添加FTP用户并未他们设置缺省目录
	useradd -g ftp-users -d /home/ftp-docs user
	passwd user

	user和passwd可以自己设定

8)把vsftpd和创建的用户、目录做关联
	sudo vi /etc/vsftpd.conf
	修改配置文件，不可匿名访问，write_enable=YES

# 2. 字典 goldendict

goldendict：一款翻译软件

1. `sudo apt-get install goldendict`
2. 设置：在 编辑->词典来源->程序，添加：
      html  有道	/home/roger/tools/trans/youdao_get.py %GDWORD%
3. 将youdao_get.py脚本放在上述目录中（前提是已下载python及其需要的模块），此脚本可在 https://github.com/easeflyer/gd_plugin/tree/master/youdao中下载

# 3. kolor paint 画图软件

1. `sudo apt-get install  kolourpaint4 -y`

# 4. dia 流程图软件

1. `sudo apt-get install dia-common`
2. 无法输入中文解决方法：右击框框->Input Method -> X输入法