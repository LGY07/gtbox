# Grass!Bash Shell

Grass!Bash Shell，一个为`Linux`准备的工具箱,你也可以在别的 Unix/Unix Like 系统使用

## 一个不是完全没用的 Bash 脚本管理器

作用：一个类似软件包管理器的东西，但是简单粗暴，适合管理脚本（依赖关系不能很好的解决，只建议管理 shell 脚本）

## 安装方法

1.下载 install.sh 或下载离线版安装包并解压

2.确保 tar 已安装的情况下运行`install.sh`

```
sudo su -
chmod +x install.sh
./install .sh
```

## 使用方法

参数使用帮助：

```
-h/--help   显示帮助
-v/--version显示版本
-r/--run    运行命令
无参数       交互模式
```

在脚本交互模式中：

```
.grass.[包名]               运行一个脚本包
.make [目录]                制作一个脚本包
.list                      显示所有已安装的脚本包
.help [包名]                获取脚本包的帮助文件
.install [包路径/链接]       安装脚本包
.remove [包名]              移除脚本包
.update [包名]              更新脚本包
.update-all                 更新所有脚本包
.upgrade                    更新脚本包管理器
.plugin add [脚本文件]       添加插件
.plugin del [脚本文件]       删除插件
```
