# update-alternatives

## 功能

**update-alternatives** 是通过软链接的方式，处理 **Linux** 系统中软件版本的切换，使其多版本共存。

## 语法

```
$ update-alternatives --help
Usage: update-alternatives [<option> ...] <command>

Commands:
  --install <link> <name> <path> <priority>
    [--slave <link> <name> <path>] ...
                           add a group of alternatives to the system.
  --remove <name> <path>   remove <path> from the <name> group alternative.
  --remove-all <name>      remove <name> group from the alternatives system.
  --auto <name>            switch the master link <name> to automatic mode.
  --display <name>         display information about the <name> group.
  --query <name>           machine parseable version of --display <name>.
  --list <name>            display all targets of the <name> group.
  --get-selections         list master alternative names and their status.
  --set-selections         read alternative status from standard input.
  --config <name>          show alternatives for the <name> group and ask the
                           user to select which one to use.
  --set <name> <path>      set <path> as alternative for <name>.
  --all                    call --config on all alternatives.

<link> is the symlink pointing to /etc/alternatives/<name>.
  (e.g. /usr/bin/pager)
<name> is the master name for this link group.
  (e.g. pager)
<path> is the location of one of the alternative target files.
  (e.g. /usr/bin/less)
<priority> is an integer; options with higher numbers have higher priority in
  automatic mode.

Options:
  --altdir <directory>     change the alternatives directory.
  --admindir <directory>   change the administrative directory.
  --log <file>             change the log file.
  --force                  allow replacing files with alternative links.
  --skip-auto              skip prompt for alternatives correctly configured
                           in automatic mode (relevant for --config only)
  --verbose                verbose operation, more output.
  --quiet                  quiet operation, minimal output.
  --help                   show this help message.
  --version                show the version.
```

## 示例

```
$ sudo update-alternatives --install /usr/bin/arm-linux-gnueabi-gcc arm-linux-gnueabi-gcc /usr/bin/arm-linux-gnueabi-gcc-7 7
$ sudo update-alternatives --install /usr/bin/arm-linux-gnueabi-gcc arm-linux-gnueabi-gcc /usr/bin/arm-linux-gnueabi-gcc-5 5
$ sudo update-alternatives --config arm-linux-gnueabi-gcc

  Choose the number 1 and set the default arm-linux-gnueabi-gcc-5 for the system.
```

安装命令的基本格式为 **update-alternatives --install \<link\> \<name\> \<path\> \<priority\>**

 - \<link\>：指向 **/etc/alternatives/\<name\>** 的符号引用。
 - \<name\>：链接的名称。
 - \<path\>：该命令对应的可执行文件的实际路径。
 - \<priority\>：软件版本的优先级，数字越大，优先级越高。

最终工具的链接方式为：

```
/usr/bin/arm-linux-gnueabi-gcc -> /etc/alternatives/arm-linux-gnueabi-gcc -> /usr/bin/arm-linux-gnueabi-gcc-5
```

