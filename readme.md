# netecho

一个网络编程的小练习

也是一个小命令行工具

## 安装

```bash
luarocks install luasocket
git clone https://github.com/Yue-bin/netecho.git
# cp ./netecho.lua /usr/local/bin/netecho
```

## 使用

```bash
netecho [tcp|udp] port [bindaddr]
```

**注意**：在多数情况下，如果要将 `bindaddr`指定为 `*`，请使用双引号或者单引号包裹之，否则可能会被shell解析并匹配成当前文件夹的所有文件，推荐直接不显式指定bindaddr，因为默认值就是`*`
