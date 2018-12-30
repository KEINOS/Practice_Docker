# Docker image for data containers

- Guest OS
    - `busybox:latest`
- 共有ディレクトリ
    - `/data`
- サンプルデータ
    - `/data/data_sample1.txt`

## 用途

同一 Host OS 内の**コンテナ間でデータを共有するためのデータ・コンテナ**を作るためのシンプルな Docker イメージを作成します。

## Docker イメージの作り方（ビルド）

```
docker build -t data-only ./
```

具体的には以下のように行います。（#行はコメント）

```shellsession
$ # Docker のバージョンチェック
$ docker --version
Docker version 18.09.0, build 4d60db4
$ 
$ # Dockerfile に作業ディレクトリを移動と Dockerfile の確認
$ cd /path/to/this/dir
$ ls
Dockerfile
$
$ # Docker イメージを 'image-data-only' のイメージ名で作成
$ docker build -t image-data-only ./
```

## 使い方

### コンテナの作成

「image-data-only」の Docker イメージから、コンテナ名「dat0001」でコンテナを作成。

今後は、このコンテナ「dat0001」にデータ・コンテナとして、他のコンテナからアクセスします。

```shellsession
$ docker run --name dat0001 image-data-only
$ 
$ # 起動中のコンテナがないことを確認
$ docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
$ 
$ # コンテナができていることを確認
$ docker container ls -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                      PORTS               NAMES
e68xxxxxxxxx        image-data-only     "sh"                20 minutes ago      Exited (0) 20 minutes ago                       dat0001
```


### 他のコンテナからの接続例

以下は、`alpine` イメージから作成した新規のコンテナに、上記で作成したデータ・コンテナ「dat0001」をマウントする例で、以下の作業を行なっています。

- マウントしたデータ・コンテナ内のサンプル・データ「data_sample1.txt」を確認。
- サンプル・データ「data_sample2.txt」を作成
- コンテナの停止

```shellsession
$ docker run --rm -it --volumes-from dat0001 alpine
/ # 
/ # ls /data
data_sample1.txt
/ # 
/ # cat /data/data_sample1.txt
Hello data container
/ # 
/ # echo "Hello data container from other container" > /data/data_sample2.txt
/ # 
/ # cat /data/data_sample2.txt
Hello data container from other container
/ # 
/ # exit
```

上記のテストデータ「data_sample2.txt」が保存されているか、再度別のコンテナから接続して確認する例です。

```shellsession
$ docker run --rm -it --volumes-from dat0001 alpine
/ # 
/ # ls /data
/data/data_sample1.txt  /data/data_sample2.txt
/ # 
/ # cat /data/data_sample2.txt
Hello data container from other container
/ # 
/ # exit
```

## 参考文献

- 「Docker実施ガイド」P.83「Docker におけるデータ専用コンテナ」より
    - ISBN: 9784844339625, ASIN: B0191B5FE4
- 「[VOLUME](http://docs.docker.jp/engine/articles/dockerfile_best-practice.html#volume) | Dockerfile のベストプラクティス」@ Docker.JP
- 「[VOLUME](http://docs.docker.jp/engine/reference/builder.html#volume) | Dockerfile リファレンス」@ Docker.JP
- 「[Use volume](https://docs.docker.com/storage/) | Docs」@ Docker.COM
- 「[Health check of Docker containers](https://www.alibabacloud.com/help/doc-detail/58588.htm) | Document Center」@ Alibaba Cloud
- 「[healthcheck](https://github.com/docker-library/healthcheck) | docker-library」@ GitHub
