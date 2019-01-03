# DockerUI

Docker のイメージやコンテナ管理をするための GUI 管理ツール「[Docker UI](https://github.com/kevana/ui-for-docker)」を起動するコンテナの作り方です。

- Base Image
    - `kevan/dockerui`

```shellsession
$ docker run -d \
    -p $PORT_OUTSIDE:$PORT_INSIDE \
    --name dockerui \
    -v /var/run/docker.sock:/var/run/docker.sock \
    kevan/dockerui
```

## Usage

```
$ ./runner.sh
```

- Docker UI のコンテナが無事起動すると、アクセス先の URL が表示されます。
- macOS の場合は Safari が起動します。

## 参考文献

- 「[kevana/ui-for-docker](https://github.com/kevana/ui-for-docker)」@ GitHub
    - 後継「[Portainer](https://github.com/portainer/portainer)」@ GitHub
- 「[DockerUI](https://dockerui.readthedocs.io/en/latest/)」@ ReadTheDocs
- 「Docker実施ガイド」P.214「第9章 管理・監視ツール」より
    - ISBN: 9784844339625, ASIN: B0191B5FE4
- 「[docker UIの導入](https://qiita.com/kod314/items/f96541373398dfffea37)」@ Qiita
