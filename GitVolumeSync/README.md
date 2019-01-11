# GitVolumeSync

A Dockerfile which automaticaly clone, commit and push origin to a mounted volume.

この Dockerfile は、**ボリュームを監視して GitHub との同期を行うコンテナ**が作れます。このコンテナにボリュームをマウントすると、GitHub のリポジトリを `git clone` 後、ボリューム内に変更があると自動的にコミットとプッシュを行い GitHub のリポジトリに反映します。

## 主な用途

その他のコンテナで、同じボリュームをマウントしてデータを変更すると自動的に GitHub のリポジトリに反映します。

Kubernetes の [gitRepo Volume](http://kubernetes.io/docs/user-guide/volumes/#gitrepo) や [git-sync](https://github.com/kubernetes/git-sync) が大げさで、もっと小さい規模で使いたいと思い、勉強がてら作ってみました。安定したら、専用のリポジトリで公開したいと思います。

## Easy usage

`ENV.list.sample` を `ENV.list` にリネームして、"User edit" 内の項目を変更後、`runner.sh` を実行します。あとは、自分の作業用コンテナに `data_git` をマウントして、マウントしたディレクトリ内で変更があると自動的に GitHub に同期します。

1. Edit the "[/ENV.list.sample](ENV.list.sample)" file and rename it to "ENV.list"
2. Move the current directory to this repo. (`$ cd /path/to/GitVolumeSync`)
3. Run `runner.sh`. (`$ /bin/bash ./runner.sh`)
4. After the monitoring container is ran, mount the "data_git" volume on to your container.
    - Ex: `docker run --rm -it -v data_git:/data alpine /bin/sh`
    - All the changes in "/data" directory will reflect to origin(GitHub)

## Repository Details

```
.
├── README.md          # This file
├── runner.sh          # Runs Build.sh and/or the monitoring container
├── Build.sh           # Build image and runs monitoring container
├── Dockerfile         # Dockerfile for the image
├── ENV.list.sample    # User settings. Rename to 'ENV.list'
└── resource           # Files to be copied in to the image
     ├── entrypoint.sh   # Monitor script to commit changes and push origin
     └── setup.sh        # Setups git and ssh setting and do the first clone
```

## Tipical usage from other container

```
$ # Run monitoring container
$ ./runner.sh
- Checking existing container running ... OK
Monitoring container is already running:
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
4c4e93631c11        img_git-volume-sync   "/bin/sh -c ${PATH_D…"   23 minutes ago      Up 22 minutes                           cont_git-volume-sync

Mount volume 'data_git' on to your container.

$ 
$ # Mount data_git volume to your any container
$ docker run --rm -it -v data_git:/data --name my_container01 alpine
/ # 
/ # # Check if /data is mounted
/ # ls /
bin    dev    home   media  proc   run    srv    tmp    var
data   etc    lib    mnt    root   sbin   sys    usr
/ # 
/ # # Do something in 'data' dir
/ # echo 'did something' >> /data/something.txt
/ # 
/ # # After 5 min, see your GitHub repo.
/ # # The monitoring container in background will commit the changes and then
/ # # push them to the orign (the GitHub repo).
```
