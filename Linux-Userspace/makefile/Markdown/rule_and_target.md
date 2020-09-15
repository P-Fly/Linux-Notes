# 规则和目标

## 规则

一个简单的 **Makefile** 规则描述如下：

```
TARGET... : PREREQUISITES...
	COMMAND
	...
```

 - **target**: 规则的目标。通常是最后需要生成的文件名，或者为了实现这个目的而必需生成的中间过程文件名，也可以是一个伪目标。

 - **prerequisites**: 规则的依赖。是生成规则目标所需要的文件名列表，文件名也可以是其它的规则目标。

 - **command**: 规则的命令行。是规则所要执行的动作集合，是在任何一个目标的依赖文件发生变化后重建目标的动作描述。

**一句话解释：规则包含了目标和依赖的关系以及更新目标所要求的命令。**

**规则的书写建议是：单目标，多依赖。尽量做到一个规则中只存在一个目标文件，但可以有多个依赖文件。**

## 终极目标

**终极目标** 就是 **Makefile** 最终所要重建的某个规则的目标。默认情况下，第一个规则中的第一个目标就是 **终极目标**。因此 **终极目标** 的编译规则往往会描述整个工程或者程序的编译过程和规则。

 1. 如果 **Makefile** 中的第一个规则有多个目标，那么多个目标中的第一个目标就是默认的 **终极目标**。

 2. 可以通过命令行直接指定本次执行过程的 **终极目标**，如 `make clean`。此时 **Makefile** 设置一个特殊变量 **MAKECMDGOALS** 来记录命令行参数指定的 **终极目标**。没有通过命令行参数指定 **终极目标** 时，此变量为空。

    ```
    $ cat Makefile
    foo:
        @echo "MAKECMDGOALS = ${MAKECMDGOALS}"

    $ make
    MAKECMDGOALS =

    $ make foo
    MAKECMDGOALS = foo
    ```

 3. 可以指定一个在 **Makefile** 中不显示存在的目标作为 **终极目标**，前提是存在一个对应的 **隐含规则** 能够生成该目标。

## 伪目标

**伪目标** 不代表一个真正的文件名，在执行 **Makefile** 时可以指定这个目标来执行其所在规则定义的命令。将一个目标声明为 **伪目标** 需要将它作为特殊目标 **.PHONY** 的依赖。

```
.PHONY: clean
clean:
    rm *.o
```

使用 **伪目标** 有两点原因：

 1. 避免在规则中定义的目标和目录下的文件出现名字冲突。

 2. 提高执行 **Makefile** 的效率。样例如下：

    ```
    SUBDIRS = foo bar baz
    .PHONY: subdirs $(SUBDIRS)
    subdirs: $(SUBDIRS)
    $(SUBDIRS):
        $(MAKE) -C $@
    ```

    - 该规则会使用 **并行执行** 方式。

    - 对于 **伪目标**，**Makefile** 在执行此规则时不会试图去查找隐含规则来创建这个目标。

## 强制目标

**强制目标** 是指一个规则没有命令或者依赖，并且它的目标不是一个存在的文件名。在执行此规则时，目标总会被认为是 **已经被更新过**。

```
$ cat Makefile 
target: FORCE
    touch target

.PHONY: FORCE

FORCE: ;

$ make target
touch target

$ make target
touch targe
```

上例中，目标 `FORCE` 为一个 **强制目标**，并作为目标 `target` 的依赖。因此在执行 `make target` 时，由于 `FORCE` 总会被认为需要更新，所以 `target` 所在的规则总会被执行。

## 空目标文件

**空目标文件** 是指 **目标文件** 存在，但我们对该文件的具体内容并不关心。只是利用该文件的时间戳，记录此规则命令的最后执行时间。通常此文件是一个空文件。

```
$ cat Makefile 
print: foo.txt
    cat $? 
    touch print

$ echo 1 > foo.txt

$ make print
cat foo.txt 
1
touch print

$ make print
make: 'print' is up to date.

$ echo 2 > foo.txt 

$ make print      
cat foo.txt 
2
touch print

$ make print
make: 'print' is up to date.
```

 - 目标文件 `print` 的内容并不关心，只是用来记录上一次执行此规则命令的时间。
 
 - 如果依赖文件 `foo.txt` 有更新，此目标所在规则的命令行将被执行。
