# Call A Container From Other Container

同一 Docker ネットーワク内のコンテナ間で通信するためのサンプル Dokerfile です。

複数コンテナを起動させるため、docker-compose を利用しています。


## 起動

下記で、PHP7 のコンテナ `app_php`、Python3 のコンテナ `app_py` が起動します。

起動すると、各コンテナに、他のコンテナから `http://<コンテナ名>/` でアクセスすると実行結果を取得できます。

```
$ docker-compose up -d
```

## 利用

以下は、docker-compose.yml で定義した alpine ベースのサービス `client` を利用して、他のコンテナへアクセスしてみる例です。

```
$ docker-compose run --rm client /bin/sh
/ #
/ # # 別コンテナの app_php に wget でアクセスしてみる
/ # wget -O - http://app_php/
Connecting to app_php (172.22.0.4:80)
- Hi. I am: 551f211f52d0
- My IP is: 172.22.0.4
- Version info: PHP 7.3.1 (cli) (built: Jan 11 2019 00:26:38) ( NTS )
- ARG: 
- GET: 
Array
(
)
- POST: 
Array
(
)
-        100% |*******************************************|   163   0:00:00 ETA
/ #
/ # # 別コンテナの app_py に wget でアクセスしてみる
/ # wget -O - http://app_py/
Connecting to app_py (172.22.0.3:80)
<!DOCTYPE html>
<html>
<head>
<title>CGI Sample</title>
</head>
<body>
<form action="/cgi-bin/cgitest.py" method="POST">
  <input type="text" name="text" value="test" />  
  <input type="submit" name="submit" />
</form>
</body>
-        100% |*******************************************|   235   0:00:00 ETA
/ # 
```


