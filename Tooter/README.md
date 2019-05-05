# Docker image for tooting Mastodon

- Guest OS
    - `alpine:3.8`
- 必須環境変数
    - `ACCESS_TOKEN`
    - `ENDPOINT`
    - `STATUS`
    - `VISIBILITY`

## 用途

この Dockerfile は Mastodon にトゥートするだけのシンプルな Docker イメージを作成します。

## Docker イメージの作り方（ビルド）

```shellsession
$ ls
Dockerfile
$ 
$ # Docker イメージ名
$ NAME_IMAGE='tooter'
$ 
$ # 自分の Mastodon インスタンで発行したアクセストークンをセット
$ TOOT_TOKEN='xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
$ 
$ # 自分の Mastodon インスタンスのトゥート API のエンドポイント URL をセット
$ URL_ENDPOINT='https://qiitadon.com/api/v1/statuses'
$
$ # ビルドの実行
$ docker build \
    --build-arg ACCESS_TOKEN=$TOKEN \
    --build-arg ENDPOINT=$URL_ENDPOINT \
    -t $NAME_IMAGE ./
```

## 使い方

`TOOT_STATUS` の値は、トゥートしたい UTF-8 の文字列を URL エンコード（パーセントエンコーディング）したものです。

```shellsession
$ NAME_IMAGE='tooter'
$ 
$ TOOT_STATUS='Hello%20World'
$ TOOT_VISIBILITY='private'
$ 
$ # 使い捨てのコンテナを作成して実行します
$ docker run --rm -it \
    -e STATUS="${TOOT_STATUS}" \
    -e VISIBILITY="${TOOT_VISIBILITY}" \
    $NAME_IMAGE
```

### URL エンコードについて

URL エンコードは [RFC-3986](https://tools.ietf.org/html/rfc3986.html#section-2.3) に準拠する必要があります。

「`a-z` `A-Z` `0-9` `-` `.` `_` `~`」以外の文字はパーセント・エンコードしてください。

