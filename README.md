# Sam Terminal 服务端部署说明文档

## 一. 部署环境要求

- 系统为 Centos7 或者 ubuntu 16.04

## 二. 下载源码

1. 在 [GitHub](https://github.com/SmartAssetManager/SAM-Terminal-Server-Install/releases) 上选择对应版本
2. 下载源码
3. 解压
   
示例：

- 下载 v2.3.0 源码命令

```shell
wget https://github.com/SmartAssetManager/SAM-Terminal-Server-Install/archive/v2.3.0.tar.gz
```

- 解压命令
```shell
tar -zxvf v2.3.0.tar.gz
```

- 进入目录命令

```shell
cd SAM-Terminal-Server-Install-2.3.0/
```

## 三. 安装服务

**注：安装特指第一次安装**

运行安装服务命令，然后按安装提示进行安装。

```shell
sh startup.sh
```

## 四. 更新说明

更新方式有两种：覆盖更新和不覆盖更新。
  
- 不覆盖更新：**只更新服务，不清除数据。**

    在步骤二中安装时

    如果选择了**一键部署搭建MySQL/PostgresSQL**，那么更新时运行脚本命令：

    ```shell
    sh insidedatabase-servicerecover.sh
    ```

    如果是选择了**外部自搭建MySQL/PostgresSQL**，那么更新时运行脚本命令：
    ```shell
    sh outsidedatabase-serivicerecover.sh
    ```

- 覆盖更新：**清除数据库的所有数据，请谨慎选择！**
  
  先运行停止服务命令
  
  ```shell
  sh shutdwon.sh
  ```

  然后运行安装服务命令

  ```shell
  sh startup.sh
  ```

## 五. 停止服务

运行停止服务命令

```shell
sh shutdwon.sh
```
