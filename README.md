# feishu_sendmessage

A new test Flutter project.

此项目采用token密钥上传，
为保证clone至本地的项目顺利build，上传时需清空本地build


Docker 运行：
请提前安装好docker
在feishu_sendmessage目录下，
依次执行flutter build web
然后执行docker build  -t flutter_web_nginx .                (注意此处有一个英文字符点)
最后执行docker run -p 80:80 -d flutter_web_nginx              然后访问127.0.0.1:80或者localhost:80即可




