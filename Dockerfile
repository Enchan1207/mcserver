##
## Minecraftサーバを構築してみる
##
FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

#
# パッケージ設定
#

# パッケージマネージャの更新
RUN \
    apt-get update; \
    apt-get -y upgrade

# 必須パッケージのインストール
RUN apt-get install -y openjdk-17-jre-headless
RUN apt-get install -y wget git

#
# ユーザ設定
#

# ユーザを追加 + sudoグループに追加
ARG password="password"
RUN \
    useradd enchan -m -s /bin/bash; \
    usermod -aG sudo enchan; \
    echo "enchan:${password}" | chpasswd

# サーバ用ファイル置き場を生成
WORKDIR /home/enchan/build_minecraft_server
RUN chown -R enchan /home/enchan/build_minecraft_server
USER enchan

#
# Spigotサーバのビルド
#

# BuildToolsをインストール
RUN wget -OBuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# ビルド
ARG version="1.18.2"
RUN \
    git config --global --unset core.autocrlf; \
    java -jar BuildTools.jar --rev $version

# サーバ設定ファイルをコピー
COPY ./eula.txt eula.txt
COPY ./server.properties server.properties

# 起動
EXPOSE 25565
CMD /usr/bin/java -Xms1G -Xmx2G -jar /home/enchan/build_minecraft_server/spigot-1.18.2.jar
