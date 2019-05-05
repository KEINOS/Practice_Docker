# YAML-JSON 相互変換

## 用途

YAML → JSON / JSON → YAML への変換専用のアプリケーションです。

## ビルド

```
$ ls
Dockerfile	README.md	src
$ 
$ tree
.
├── Dockerfile
├── README.md
└── src
    ├── sample.yml
    ├── sample.json
    └── yaml-json.go
$ 
$ docker build -t yaml-json .
```

## USAGE

```
yaml-json [-json/-yaml] [data]
```

## 動作サンプル

```
$ # YAML から JSON への変換
$ cat src/sample.yml | docker run --rm -i yaml-json -json

$ # JSON から YAML への変換
$ cat src/sample.json | docker run --rm -i yaml-json -yaml
```
