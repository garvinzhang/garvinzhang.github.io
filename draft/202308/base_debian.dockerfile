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
