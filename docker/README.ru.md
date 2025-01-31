### Docker с Nginx и Apache

Перед работой необходимо:
- установить [Docker Desktop](https://docs.docker.com/get-started/introduction/get-docker-desktop/)
- ознакомится с документацией по Docker, Dockerfile, Docker concepts, Docker Compose
- использовать `VS Code`

---

Структура проекта:

- [apache](./apache/) - конфиги для `httpd` (`Apache2`) и его `html`
- [nginx](./nginx/) - конфиги для `nginx` и его `html`
- [root](./.) - корень проекта

---

В файлах [Dockerfile.apache](./Dockerfile.apache) и [Dockerfile.nginx](./Dockerfile.nginx) описан процесс сборки docker-образов `apache` и `nginx` соответственно

В данном случае предполагается, что внешним сервером будет `nginx`, он доступен из вне, он работает с проксированием, он хранит сертификаты

Сам образ `nginx` собирается с самописными сертификатами

---
#### Самописный сертификат SSL для HTTPS

Чтобы использовать самописный сертификат для `localhost`:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout privkey.pem -out fullchain.pem \
    -subj "/C=RU/ST=Moscow/L=Moscow/O=Example Company/CN=localhost"
```

На выходе будут файлы `privkey.pem` и `fullchain.pem`
Это самописные сертификаты для SSL, с их помощью можно будет использовать HTTPS для localhost

Затем пересоберите образ с `Nginx` и прокиньте эти файлы в удобную для вас директорию и обновите конфигурацию server в [`site.conf`](./nginx/conf.d/site.conf)

---
#### LetsEncrypt сертификат SSL для HTTPS

Понадобятся:
- домен
- DNS-запись, указывающая на IP хоста, у которого на порту 80 хостится Nginx <br />
_(Сначала запустите Nginx-контейнер без редиректа на порт 443)_

Когда у вас есть поднятый контейнер Nginx, настроенная DNS-запис типа A,
запустите

```bash
docker compose up certbot
```

Certbot автоматически выдаст сертификат и положит его в папку [`certbot`](./certbot)
Обратите внимание, что содержимое этой папки уже является volume'ами для контейнера nginx _(можно глянуть в [compose.yml](./compose.yml))_

Главное убедитесь, что вы используете выданные сертификаты certbot, а не самописные

Внимание, у certbot есть ограничение на кол-во выданных сертификатов, поэтому для повторных тестовых запусков используйте флаг `--dry-run`

---

#### Yandex.Cloud's Serverless Containers с API Gateway

Предлагается поднять следующую инфраструктуру:
- API Gateway для контейнера Nginx
- API Gatewat для контейнера Apache
- один serverless контейнер Nginx
- один serverless контейнер Apache

Настраиваем API Gateway'и:

API Gateway для контейнера Nginx (Спецификация OpenAPI)
```yaml
openapi: 3.0.0
info:
  title: My API
  version: v1

servers:
- url: https://d5d89g1hdi2k77l5i8ol.g3ab4gln.apigw.yandexcloud.net
paths:
  /:
    get:
      x-yc-apigateway-integration:
        type: serverless_containers
        service_account_id: ajen07i4lj1n5s9djgg9
        container_id: bbahnbfb2hgu6aakp7hg # nginx
  /container/{path+}:
    x-yc-apigateway-any-method:
      x-yc-apigateway-integration:
        type: http
        url: https://d5ds8fuko015m71q1pn8.z7jmlavt.apigw.yandexcloud.net/{path} # API Gateway Apache
      parameters:
        - name: path
          in: path
          required: false
          schema:
            type: string
```

paths:
- / - все запросы будут идти контейнеру nginx _(id: `bbahnbfb2hgu6aakp7hg`)_
- /container/{path+} - отдельный обработчик для путей начинающегося на `/container/...` <br />
если перейти по ссылке ресурса, отданного nginx'ом, по данному пути, то сделать переадресацию на API Gatway Apache


API Gateway для контейнера Nginx
```yaml
openapi: 3.0.0
info:
  title: Sample API
  version: 1.0.0
servers:
- url: https://d5ds8fuko015m71q1pn8.z7jmlavt.apigw.yandexcloud.net
paths:
  /{path+}:
    get:
      x-yc-apigateway-integration:
        type: serverless_containers
        service_account_id: ajen07i4lj1n5s9djgg9
        container_id: bbamb2737o229m38sli7 # Apache
      parameters:
        - name: path
          in: path
          required: false
          schema:
            type: string

```

в данной конфигурации все запросы, которые проходят через этот Gateway, обслуживает Apache

далее настроим nginx:

```nginx
server {
  listen 8001;

  server_name first-virtual-server.apache;

  location / {
    proxy_pass https://api.gateway.apache.url:443; # на текущий момент формата d5ds8fuko015m71q1pn8.z7jmlavt.apigw.yandexcloud.net

    add_header X-Server-Name $server_name;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}

server {
  listen 8002;

  server_name second-virtual-server.apache;

  location / {
    proxy_pass https://api.gateway.apache.url:443;

    add_header X-Server-Name $server_name;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}

upstream php_servers {
    server 127.0.0.1:8001;
    server 127.0.0.1:8002;
}
```

данной конфигурацией объявляем два виртуальных сервера nginx:
- `second-virtual-server.apache`, слушает на порте `8001`
- `first-virtual-server.apache`, слушает на порте `8002`

объединяем их в один upstream `php_servers` и используем его для проксирования всех запросов, url которых начинается с /container/

```nginx
location /container/ {
    rewrite ^/container/(.*)$ /$1 break;

    proxy_pass https://php_servers;
}
```
