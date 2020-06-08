# Gitbash的基本操作

###  1. 创建版本库

1. 创建步骤：
   - 选择合适的地方创建一个空目录：
       ` $ mkdir <rep name>   ` 
      `  $ cd <rep name>`    切换路径
       ` $ pwd`    显示当前目录
   - 通过git init把这个目录变成git可以管理的仓库
        `$ git init `
2. 与远程库建立连接
   - `$ ssh-keygen -t rsa -C "youremail@example.com"`    创建密钥，会产生id_rsa     和id_rsa.pub这两个文件将pub中的密钥添加到github官网
   -  ` git config --global user.email "youremail@example"`   机器都必须自报家门，注意git config命令的--global参数，用了这个参数，表示你这台机器上所有的Git仓库都会使用这个配置
       `git config --global user.name "your name"`
3. "add & commit"
  - `git add <filename>`	把工作区的修改的文件文件添加到stage
  - `git add -f <filename> `   当文件被.gitignore忽略时，用-f 强制添加到git
  - `git commit -m <filename>`	 把stage区的文件提交到head区
  - `git commit -m "..."   ` 提交多个在暂存区中的文件，省略号是说明
4. “查看“
  - `git status `  显示仓库当前的状态
  - `git diff`    查看工作区和暂存区的区别
  - `git diff HEAD`   查看<u>**工作区(已修改未add)与暂存区(已add为commit)**</u>和**本地仓**库的区别
  - `git diff --staged` 查看**暂存区(已add为commit)**和**本地仓**库的区别

## 2. 时光机穿梭
* `git log`    显示从最近到最远的提交日志

* `git log --pretty=oneline`   精简显示提交日志

* `git reflog`   查看命令历史，以便确定要回到未来的哪个版本

* `git reset --hard HEAD^`	 回退到上一个版本
			             ` --hard HEAD~n`  回退到上第n个版本
			    `--hard <commit id>  ` 回到指定ID的版本
	
* “删除文件”
		
	* `git checkout -- <filename>`		把在工作区的文件的修改全部撤消, 其实是从stage中恢复到工作区中
* `git reset HEAD <filename> `   	把stage区的修改撤销掉（unstage），重新放回工作区
	
		rm <filename>   仅删除了工作区中的文件
		
		从版本库中删除文件
			git rm <filename>
			git commit -m "remove <filename>"
## 3. 远程仓库
* “关联”
		本地有rep,远程创建同名rep,关联remote repository
			`git remote add origin git@github.com:rogerg6/<rep name>.git `  远程库名默认为origin，但可以修改
	
* “推送”
		`git push -u origin master`    第一次向remote库推送
		`git push origin master `   以后向remote库推送
	
* “克隆”
		  ssh：`git clone git@github.com:rogerg6/<rep name>.git `             从remote库中clone rep
		https:  `git clone https://github.com/rogerg6/<rep name>.git`       同上
	
## 4. 分支管理
* 创建/切换分支
	`git branch`    查看分支
	`git branch <branch name>  ` 创建分支
	`git checkout <branch name>  `  切换分支
	`git checkout -b <branch name>`    创建+切换分支
	
*  "合并"
	* `git merge <branch name>`    合并某分支到当前分支<br>

		 1.  出现conflict,需将文件手动编辑成我们希望的内容，然后提交
	`git add <filename>`
	`git commit -m "conflict fixed"`
		2.  --no-ff合并 (禁用fast forward, fast forward模式下，删除分支会丢失分支信息)
	`git merge --no-ff -m "merge with no-ff" <branch name>`
		3.  查看分支合并情况
		`git log --graph --pretty=oneline --abbrev-commit`

* “删除”
		`git branch -d <branch name> `   删除分支
		`git branch -D <branch name> `   强行删除还未合并的分支
	
	* “stash功能” (分支dev进行一半时，需修复master bug时，新建master bug分支，再用stash保存dev现场)
		`git stash`   保存当前dev进度
		`git checkout master `
		`git checkout -b bug101  `
		* 修复完成后：
		`git add <filename> `
		`git commit -m "bug fixed"`
		`git checkout master`
		`git merge --no-ff -m "merged bug101" <bug101>`
		`git checkout dev`
		`git stash list `  查看保存的分支现场
		* “恢复”
			1) `git stash apply`   恢复现场
			   `git stash drop`    删除stash中的内容
			2) `git stash pop`     恢复并删除
			3) `git stash stash@{0}`   多个stash时，选择恢复哪个stash
	
* "推送”
	* 查看remote信息
			`git remote`
	* 查看remote抓取和推送的地址
			`git remote -v`
	* 推送分支
			`git push origin <branch name>`
	
* "多人合作"
		小伙伴从remote clone时，只能看到我的master,如果他要在dev上开发，则必须创建origin的dev:
	1. `  git checkout -b dev origin/dev`
		   然后修改，提交，push.....
	2. 同时，我也在dev上做了修改，这时push会失败，因为这时origin上的比我的更新，需pull下来合并再push
		  ` git pull `
				if 失败，可能没有指定本地dev和origin/dev的链接
					git branch --set-upstream-to=origin/dev dev    
				然后pull，合并(若冲突则解决)，提交，push
	
* “rebase”
	* 功能：
			rebase操作可以把本地未push的分叉提交历史整理成直线；
			rebase的目的是使得我们在查看历史提交的变化时更容易，因为分叉的提交需要三方对比。
	* 用法：
			`git rebase`
		
## 5.“tag”管理
	tag功能：便于识别某个版本，相比于commit id 
* 创建tag”
		`git tag <tag name> `   给当前branch打上标签，默认是最新的提交
		`git tag <tag name> <commit id> `  给过去某个commit打上标签
		`git tag -a <tag name> -m` "标签说明" <commit id>    给标签加上说明
		`git tag`    查看标签
		`git show <tag name> `   可以看到说明文字
	
* “操作tag”
	* 本地删除tag:
		`git tag -d <tag name>`
	* 远程删除tag：
		`git tag -d <tag name>`
		`git push origin :refs/tags/<tagname>`
		`git push origin <tag name>  `  push单个tag
		`git push origin --tags`    push当前分支所有未push过的tag
	
## 6. “github的使用”	
                        fork                             clone
    twbs/<project name> ------> myremote/<project name> -------> local/<project name>
    项目的官方开源仓库              我的远程仓库                    我的本地仓库
    
    过程：
    	从对方仓库的project下到本地如上图，接下来在local修改完project，push至myremote，
    	如果希望twbs能接受，则在github上发起pull request

## 7. “码云(gitee.com)”	
	功能：和github类似，但因为是国内Git托管服务，速度比github快
	用法：和github类似。在码云上注册，上传ssh，关联本地库，就可以操作了。关联两个库时，远程库名要不同。
		  git remote add origin git@github.com:rogerg6/master.git    关联github
		  git remote add eeorigin git@gitee.com:rogerg6/master.git    关联gitee
		  关联完后，可以用 git remote -v 查看

## 8. “自定义git”
`git config --global color.ue true`    让git显示颜色，让命令输出更醒目

* “gitignore”
```
功能：在.gitignore中加入自己不想提交的文件，最后也要把.gitignore提交至git
操作：
	touch .gitignore   				 创建.gitignore”文件
	git check-ignore -v <filename>   查找哪个规则写错了，导致无法添加文件
```

* “配置别名”	
```
`git config --global alias st status`   把status命令自定义成st，global是全局变量，对本机所有git仓库都适用；
									  若不加，仅对当前仓库起作用，每个仓库的配置文件都在.git/config文件中，
									  别名在[alias]后面，要删除别名，删除对应的行即可。
`git config --global alias unstage 'reset HEAD'  ` 同上
`git config --global alias last 'log -1' `   将last配置成显示最后一次提交
```
* “配置git服务器”	
		前提：一台运行Linux的机器，强烈推荐Ubuntu或Debian，这样可以通过简单的apt命令完成安装
		      有sudo权限的用户账号
		步骤：<br>
		
		 1) 安装git
					`$ sudo apt-get install git`
		 2) 创建一个git用户，用来运行git服务
					`$ sudo adduser git`
		 3) 创建证书登录
					 收集所有需要登录的用户的公钥，就是`id_rsa.pub`文件，将所有文件导入到
					 `/home/git/.ssh/authorized_keys`文件里，一行一个。
		 4) 初始化git仓库
					 先选定一个目录作为git仓库，eg:/srv/sample.git，在/srv中输入命令：
					` $ sudo git init --bare sample.git `
					 git会创建一个裸仓库，无工作区，仅为共享，且服务器上的git仓库通常以.git结尾，然后把owner改成git:
					 `$ sudo chown -R git:git sample.git `
		  5) 禁用shell登录
					 出于安全考虑，第二步创建的git用户不允许登录shell，这可以通过编辑/etc/passwd文件完成，找到类似下面一行：
					 `git:x:1001:1001:,,,:/home/git:/bin/bash`
					 改为：
					 `git:x:1001:1001:,,,:/home/git:/usr/bin/git-shell`
					 这样，git用户可以正常通过ssh使用git,但无法登录shell，因为我们为git用户指定的git-shell每次一登录就自动退出
		 6) clone 远程仓库
					` $ git clone git@server:/srv/sample.git `
					 剩下的就是push就easy了。
		管理公钥
			团队小：把每个人的公钥收集放入`/home/git/.ssh/authorized_keys`中是可行的
			团队大：用Gitosis
		管理权限：用Gitolite	
	
	
	​		
	​	
	​	
	​	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
