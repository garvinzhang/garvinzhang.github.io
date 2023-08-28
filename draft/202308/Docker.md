# Docker 入门与实战

## 1. docker 基础用法

```bash
docker pull debian

# 创建容器
docker run -dit --name debian_demo debian:latest
docker run -dit --name Name -v LocalPath:ContainerPath debian_demo debian:latest

docker build -t {ImageNAME}:{TAG} -f Dockerfile .

RUN source ~/.zshrc \
    && pip install \
    requests 
```

dockerfile 基础环境

```dockerfile
# 基础镜像
FROM debian:latest

# 工作目录
WORKDIR /usr/src/app

# 安装基础包
RUN apt-get update \
    && apt-get install -y \
        locales vim wget \
        git curl zsh

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata
RUN DEBIAN_FRONTEND=noninteractive ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 设置环境变量
ENV LANG=C.UTF-8

# 配置vim
RUN echo "set number" >> ~/.vimrc \
    && echo "syntax on" >> ~/.vimrc \
    && echo "set showmode" >> ~/.vimrc \
    && echo "set encoding=utf-8" >> ~/.vimrc \
    && echo "set autoindent" >> ~/.vimrc \
    && echo "set expandtab" >> ~/.vimrc \
    && echo "set relativenumber" >> ~/.vimrc \
    && echo "set cursorline" >> ~/.vimrc \
    && echo "set ruler" >> ~/.vimrc \
    && echo "set showmatch" >> ~/.vimrc \
    && echo "set hlsearch" >> ~/.vimrc \
    && echo "set visualbell" >> ~/.vimrc \
    && echo "set autoread" >> ~/.vimrc


# 安装zsh
# https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
RUN sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && sed -i 's/robbyrussell/ys/' ~/.zshrc \
    && sed -i 's/plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

# 安装conda环境（处理器架构: x86(x86_64) | arm64(aarch64)）
ARG CONDA_VER=aarch64
ARG CONDA_PATH=/opt/conda
ENV PATH=${CONDA_PATH}/bin:$PATH
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-${CONDA_VER}.sh -O ~/miniconda.sh \
    && /bin/bash ~/miniconda.sh -b -p ${CONDA_PATH} \
    && rm ~/miniconda.sh \
    && conda create --name conda39 python=3.9 -y \
    && conda init zsh \
    && echo "conda activate conda39" >> ~/.zshrc

# ENTRYPOINT ["/bin/zsh"]
# RUN zsh \
#     && pip install requests

```



## docker 本地服务

### mysql

[Mysql的utf8与utf8mb4区别，utf8mb4_bin、utf8mb4_general_ci、utf8mb4_unicode_ci区别_yzh_1346983557的博客-CSDN博客](https://blog.csdn.net/yzh_1346983557/article/details/89643071)



```bash
docker run \
--name mysql \
-d \
-p 3306:3306 \
--restart unless-stopped \
-v /mydata/mysql/log:/var/log/mysql \
-v /mydata/mysql/data:/var/lib/mysql \
-v /mydata/mysql/conf:/etc/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
mysql:5.7

docker run \
--name mysql_demo \
-d \
-p 3306:3306 \
--restart unless-stopped \
-e MYSQL_ROOT_PASSWORD=123456 \
mysql:latest

mysql -uroot -p
```

### pgsql

[在Docker中安装Postgresql - 知乎 (zhihu.com)](https://zhuanlan.zhihu.com/p/434248483)

```
docker run -d --name pgsql_demo -e POSTGRES_PASSWORD=123456 -p 5432:5432 -d postgres:latest

su postgres

psql

\l
```

[(36 封私信 / 22 条消息) PostgreSQL 与 MySQL 相比，优势何在？ - 知乎 (zhihu.com)](https://www.zhihu.com/question/20010554)



### redis

[史上最详细Docker安装Redis （含每一步的图解）实战_docker redis_宁在春的博客-CSDN博客](https://blog.csdn.net/weixin_45821811/article/details/116211724)



```bash
docker run --restart=always -p 6379:6379 --name myredis -d redis:7.0.12  --requirepass ningzaichun

docker run --restart=always -p 6379:6379 --name redis_demo -d redis:latest

redis-cli
```

[redis修改requirepass 参数 改密码_redis requirepass_西红柿天尊的博客-CSDN博客](https://blog.csdn.net/plpldog/article/details/120747176)



### python

```
FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD [ "python", "./your-daemon-or-script.py" ]
```

