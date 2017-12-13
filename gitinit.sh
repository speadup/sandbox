#!/bin/sh

#配置使用git仓库的人员姓名  
git config --global user.name "speadup"
  
#配置使用git仓库的人员email  
git config --global user.email "speadup@gmail.com"
  
#配置到缓存 默认15分钟  
git config --global credential.helper cache   
  
#修改缓存时间
git config --global credential.helper 'cache --timeout=3600'
  
git config --global color.ui true
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.br branch
git config --global alias.dc 'svn dcommit'
git config --global alias.lg 'log --oneline'
git config --global core.editor 'vim'    # 设置Editor使用textmate  

git config --global core.excludesfile '~/.gitignore'
touch ~/.gitignore

git config -l #列举所有配置  
