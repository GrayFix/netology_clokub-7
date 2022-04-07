# 14.3 Карты конфигураций

1. Работа с картами конфигураций через утилиту kubectl
  - Cоздаем карту конфигураций
    ``` bash
    root@cpl:/data/clokub-05# kubectl create configmap nginx-config --from-file=nginx.conf
    configmap/nginx-config created
    root@cpl:/data/clokub-05# kubectl create configmap domain --from-literal=name=netology.ru
    configmap/domain created
    ```
  - Смотрим список карт конфигураций
    ``` bash
    root@cpl:/data/clokub-05# kubectl get configmaps
    NAME               DATA   AGE
    domain             1      39s
    kube-root-ca.crt   1      3d
    nginx-config       1      41s
    
    root@cpl:/data/clokub-05# kubectl get configmap
    NAME               DATA   AGE
    domain             1      39s
    kube-root-ca.crt   1      3d
    nginx-config       1      41s
    ```
  - Читаем карту конфигурации
    ``` bash
    # По смыслу первая комманда все таки describe должна быть
    root@cpl:/data/clokub-05# kubectl describe configmap nginx-config
    Name:         nginx-config
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    nginx.conf:
    ----
    user www-data;
    worker_processes auto;
    pid /run/nginx.pid;
    include /etc/nginx/modules-enabled/*.conf;

    events {
    worker_connections 768;
    # multi_accept on;
    }

    http {

    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    # server_tokens off;

    # server_names_hash_bucket_size 64;
    # server_name_in_redirect off;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    ##
    # SSL Settings
    ##

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE
    ssl_prefer_server_ciphers on;

    ##
    # Logging Settings
    ##

    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;

    # gzip_vary on;
    # gzip_proxied any;
    # gzip_comp_level 6;
    # gzip_buffers 16 8k;
    # gzip_http_version 1.1;
    # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
    }


    #mail {
    #  # See sample authentication script at:
    #  # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
    #
    #  # auth_http localhost/auth.php;
    #  # pop3_capabilities "TOP" "USER";
    #  # imap_capabilities "IMAP4rev1" "UIDPLUS";
    #
    #  server {
    #    listen     localhost:110;
    #    protocol   pop3;
    #    proxy      on;
    #  }
    #
    #  server {
    #    listen     localhost:143;
    #    protocol   imap;
    #    proxy      on;
    #  }
    #}


    BinaryData
    ====

    Events:  <none>

    root@cpl:/data/clokub-05# kubectl describe configmap domain
    Name:         domain
    Namespace:    default
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    name:
    ----
    netology.ru

    BinaryData
    ====

    Events:  <none>
    ```
  - Получаем информацию в формате YAML и/или JSON
    ``` bash
    root@cpl:/data/clokub-05# kubectl get configmap nginx-config -o yaml
    apiVersion: v1
    data:
    nginx.conf: "user www-data;\nworker_processes auto;\npid /run/nginx.pid;\ninclude
        /etc/nginx/modules-enabled/*.conf;\n\nevents {\n\tworker_connections 768;\n\t#
        multi_accept on;\n}\n\nhttp {\n\n\t##\n\t# Basic Settings\n\t##\n\n\tsendfile
        on;\n\ttcp_nopush on;\n\ttcp_nodelay on;\n\tkeepalive_timeout 65;\n\ttypes_hash_max_size
        2048;\n\t# server_tokens off;\n\n\t# server_names_hash_bucket_size 64;\n\t# server_name_in_redirect
        off;\n\n\tinclude /etc/nginx/mime.types;\n\tdefault_type application/octet-stream;\n\n\t##\n\t#
        SSL Settings\n\t##\n\n\tssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping
        SSLv3, ref: POODLE\n\tssl_prefer_server_ciphers on;\n\n\t##\n\t# Logging Settings\n\t##\n\n\taccess_log
        /var/log/nginx/access.log;\n\terror_log /var/log/nginx/error.log;\n\n\t##\n\t#
        Gzip Settings\n\t##\n\n\tgzip on;\n\n\t# gzip_vary on;\n\t# gzip_proxied any;\n\t#
        gzip_comp_level 6;\n\t# gzip_buffers 16 8k;\n\t# gzip_http_version 1.1;\n\t# gzip_types
        text/plain text/css application/json application/javascript text/xml application/xml
        application/xml+rss text/javascript;\n\n\t##\n\t# Virtual Host Configs\n\t##\n\n\tinclude
        /etc/nginx/conf.d/*.conf;\n\tinclude /etc/nginx/sites-enabled/*;\n}\n\n\n#mail
        {\n#\t# See sample authentication script at:\n#\t# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript\n#
        \n#\t# auth_http localhost/auth.php;\n#\t# pop3_capabilities \"TOP\" \"USER\";\n#\t#
        imap_capabilities \"IMAP4rev1\" \"UIDPLUS\";\n# \n#\tserver {\n#\t\tlisten     localhost:110;\n#\t\tprotocol
        \  pop3;\n#\t\tproxy      on;\n#\t}\n# \n#\tserver {\n#\t\tlisten     localhost:143;\n#\t\tprotocol
        \  imap;\n#\t\tproxy      on;\n#\t}\n#}\n"
    kind: ConfigMap
    metadata:
    creationTimestamp: "2022-04-07T05:08:45Z"
    name: nginx-config
    namespace: default
    resourceVersion: "233007"
    uid: 14c060a6-e555-4db1-b8c1-48446e5d2149

    root@cpl:/data/clokub-05# kubectl get configmap domain -o json
    {
        "apiVersion": "v1",
        "data": {
            "name": "netology.ru"
        },
        "kind": "ConfigMap",
        "metadata": {
            "creationTimestamp": "2022-04-07T05:08:47Z",
            "name": "domain",
            "namespace": "default",
            "resourceVersion": "233012",
            "uid": "abdd3aef-4117-4124-9d0f-25380ec8d967"
        }
    }

    ```
  - Выгружаем карту конфигурации в файл
    ``` bash
    # Выгружаем все configmaps текущего ns
    root@cpl:/data/clokub-05# kubectl get configmaps -o json > configmaps.json

    # Выгружаем все configmaps nginx-config текущего ns
    root@cpl:/data/clokub-05# kubectl get configmap nginx-config -o yaml > nginx-config.yml

    #Проверка
    root@cpl:/data/clokub-05# cat configmaps.json nginx-config.yml
    {
        "apiVersion": "v1",
        "items": [
            {
                "apiVersion": "v1",
                "data": {
                    "name": "netology.ru"
                },
                "kind": "ConfigMap",
                "metadata": {
                    "creationTimestamp": "2022-04-07T05:08:47Z",
                    "name": "domain",
                    "namespace": "default",
                    "resourceVersion": "233012",
                    "uid": "abdd3aef-4117-4124-9d0f-25380ec8d967"
                }
            },
            {
                "apiVersion": "v1",
                "data": {
                    "ca.crt": "-----BEGIN CERTIFICATE-----\nMIIC/jCCAeagAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl\ncm5ldGVzMB4XDTIyMDQwNDA0NDQwOFoXDTMyMDQwMTA0NDQwOFowFTETMBEGA1UE\nAxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALxE\n5KZ7vbSGvPHPfxlua9YcK3PmbPPdU2zmE6OZ222bB6N6kCGVaFIXaWMoNLrz1bhy\nDMj7QjvhjcVxe7HKGYGUZcs+kLWkPthJ1kFgglDF6BL4vPtJVn3G0yixnO8WPacB\nAr8O9Ra8mIX48ODAoLcEQEfYtRXBcD4Ojn53waJmknyZqOOu1ofjyn8b1DcJI8nH\nGxePsAqSm2PUW+CN7D2uD4ba2gTSTMcWjAT9Kd+6R3CqWJEdvaCpHmzqFTLAW4eh\nXo1yB9TEQRBoYdGadijmffLWs97SzfUhftCOF97MjXbjWh0UFy1kk7Ey5oJg7hgY\nx3di6Lth5ez2hRuVyqsCAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB\n/wQFMAMBAf8wHQYDVR0OBBYEFLFuP/4uyMpHt4brREALKJKD2qP1MBUGA1UdEQQO\nMAyCCmt1YmVybmV0ZXMwDQYJKoZIhvcNAQELBQADggEBACx0QQ0azAudT/dr48gj\nIEP7N9kf26h4hUA+4in3QMsq1NiyBPTKm/mtPm4bfVOTLTn7NE2Jq1z8xc2UAmfi\nmmBboQDi9WQO1pXu+AsB6EQPtRhY5bjiNagh+/C90vE8NNEL5Vqa5v/qfuSTu+Nd\nVZqe5DR8HrTYKtrFCb78PWS65IDJJSkoJosqWlLNTHu+pVwSYL5TBWBztDykBEBC\njZv2xZsyN4NqBBPhhwy6Ne5t3L4IeZcd1mHLNLLT3rw6TnogOwQD8AWRlN4qQTan\nLBPnE4N04AWbBYtwkhrjjWeCdmbt44QVp73ub07g5PpJMb5Gppy8v5k8MWPPHTAQ\n9pI=\n-----END CERTIFICATE-----\n"
                },
                "kind": "ConfigMap",
                "metadata": {
                    "annotations": {
                        "kubernetes.io/description": "Contains a CA bundle that can be used to verify the kube-apiserver when using internal endpoints such as the internal service IP or kubernetes.default.svc. No other usage is guaranteed across distributions of Kubernetes clusters."
                    },
                    "creationTimestamp": "2022-04-04T04:44:54Z",
                    "name": "kube-root-ca.crt",
                    "namespace": "default",
                    "resourceVersion": "419",
                    "uid": "80bef39e-aafb-4060-9e8c-a29bc2d9c17b"
                }
            },
            {
                "apiVersion": "v1",
                "data": {
                    "nginx.conf": "user www-data;\nworker_processes auto;\npid /run/nginx.pid;\ninclude /etc/nginx/modules-enabled/*.conf;\n\nevents {\n\tworker_connections 768;\n\t# multi_accept on;\n}\n\nhttp {\n\n\t##\n\t# Basic Settings\n\t##\n\n\tsendfile on;\n\ttcp_nopush on;\n\ttcp_nodelay on;\n\tkeepalive_timeout 65;\n\ttypes_hash_max_size 2048;\n\t# server_tokens off;\n\n\t# server_names_hash_bucket_size 64;\n\t# server_name_in_redirect off;\n\n\tinclude /etc/nginx/mime.types;\n\tdefault_type application/octet-stream;\n\n\t##\n\t# SSL Settings\n\t##\n\n\tssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping SSLv3, ref: POODLE\n\tssl_prefer_server_ciphers on;\n\n\t##\n\t# Logging Settings\n\t##\n\n\taccess_log /var/log/nginx/access.log;\n\terror_log /var/log/nginx/error.log;\n\n\t##\n\t# Gzip Settings\n\t##\n\n\tgzip on;\n\n\t# gzip_vary on;\n\t# gzip_proxied any;\n\t# gzip_comp_level 6;\n\t# gzip_buffers 16 8k;\n\t# gzip_http_version 1.1;\n\t# gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;\n\n\t##\n\t# Virtual Host Configs\n\t##\n\n\tinclude /etc/nginx/conf.d/*.conf;\n\tinclude /etc/nginx/sites-enabled/*;\n}\n\n\n#mail {\n#\t# See sample authentication script at:\n#\t# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript\n# \n#\t# auth_http localhost/auth.php;\n#\t# pop3_capabilities \"TOP\" \"USER\";\n#\t# imap_capabilities \"IMAP4rev1\" \"UIDPLUS\";\n# \n#\tserver {\n#\t\tlisten     localhost:110;\n#\t\tprotocol   pop3;\n#\t\tproxy      on;\n#\t}\n# \n#\tserver {\n#\t\tlisten     localhost:143;\n#\t\tprotocol   imap;\n#\t\tproxy      on;\n#\t}\n#}\n"
                },
                "kind": "ConfigMap",
                "metadata": {
                    "creationTimestamp": "2022-04-07T05:08:45Z",
                    "name": "nginx-config",
                    "namespace": "default",
                    "resourceVersion": "233007",
                    "uid": "14c060a6-e555-4db1-b8c1-48446e5d2149"
                }
            }
        ],
        "kind": "List",
        "metadata": {
            "resourceVersion": "",
            "selfLink": ""
        }
    }
    apiVersion: v1
    data:
    nginx.conf: "user www-data;\nworker_processes auto;\npid /run/nginx.pid;\ninclude
        /etc/nginx/modules-enabled/*.conf;\n\nevents {\n\tworker_connections 768;\n\t#
        multi_accept on;\n}\n\nhttp {\n\n\t##\n\t# Basic Settings\n\t##\n\n\tsendfile
        on;\n\ttcp_nopush on;\n\ttcp_nodelay on;\n\tkeepalive_timeout 65;\n\ttypes_hash_max_size
        2048;\n\t# server_tokens off;\n\n\t# server_names_hash_bucket_size 64;\n\t# server_name_in_redirect
        off;\n\n\tinclude /etc/nginx/mime.types;\n\tdefault_type application/octet-stream;\n\n\t##\n\t#
        SSL Settings\n\t##\n\n\tssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3; # Dropping
        SSLv3, ref: POODLE\n\tssl_prefer_server_ciphers on;\n\n\t##\n\t# Logging Settings\n\t##\n\n\taccess_log
        /var/log/nginx/access.log;\n\terror_log /var/log/nginx/error.log;\n\n\t##\n\t#
        Gzip Settings\n\t##\n\n\tgzip on;\n\n\t# gzip_vary on;\n\t# gzip_proxied any;\n\t#
        gzip_comp_level 6;\n\t# gzip_buffers 16 8k;\n\t# gzip_http_version 1.1;\n\t# gzip_types
        text/plain text/css application/json application/javascript text/xml application/xml
        application/xml+rss text/javascript;\n\n\t##\n\t# Virtual Host Configs\n\t##\n\n\tinclude
        /etc/nginx/conf.d/*.conf;\n\tinclude /etc/nginx/sites-enabled/*;\n}\n\n\n#mail
        {\n#\t# See sample authentication script at:\n#\t# http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript\n#
        \n#\t# auth_http localhost/auth.php;\n#\t# pop3_capabilities \"TOP\" \"USER\";\n#\t#
        imap_capabilities \"IMAP4rev1\" \"UIDPLUS\";\n# \n#\tserver {\n#\t\tlisten     localhost:110;\n#\t\tprotocol
        \  pop3;\n#\t\tproxy      on;\n#\t}\n# \n#\tserver {\n#\t\tlisten     localhost:143;\n#\t\tprotocol
        \  imap;\n#\t\tproxy      on;\n#\t}\n#}\n"
    kind: ConfigMap
    metadata:
    creationTimestamp: "2022-04-07T05:08:45Z"
    name: nginx-config
    namespace: default
    resourceVersion: "233007"
    uid: 14c060a6-e555-4db1-b8c1-48446e5d2149
    ```
  - Удаляем карту конфигурации
    ``` bash
    # Удаление
    root@cpl:/data/clokub-05# kubectl delete configmap nginx-config
    configmap "nginx-config" deleted

    # Проверка
    root@cpl:/data/clokub-05# kubectl get configmap
    NAME               DATA   AGE
    domain             1      8m15s
    ```
  - Загружаем карту конфигурации из файла
    ``` bash
    # Загрузка
    root@cpl:/data/clokub-05# kubectl apply -f nginx-config.yml
    configmap/nginx-config created

    # Проверка
    root@cpl:/data/clokub-05# kubectl get configmap
    NAME               DATA   AGE
    domain             1      9m11s
    kube-root-ca.crt   1      3d
    nginx-config       1      2s
    ```
2. Работа с картами конфигураций внутри пода
  - Пример деплоя по configMap созданным в п. 1
    ``` yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: test-example
    labels:
        app: test-example
    spec:
    replicas: 1
    selector:
        matchLabels:
        app: test-example
    template:
        metadata:
        labels:
            app: test-example
        spec:
        containers:
        - name: backend
            image: praqma/network-multitool
            env:
            - name: DOMAIN_NAME
                valueFrom:
                configMapKeyRef:
                    name: domain
                    key: name
            volumeMounts:
            - name: nginx
            mountPath: "/data/nginx"
        volumes:
        - name: nginx
            configMap:
            name: nginx-config
    ```
  - Запуск и проверка
    ``` bash
    # Применение
    root@cpl:/data/clokub-05# kubectl apply -f 03-example.yaml
    deployment.apps/test-example created

    # Ищем под
    root@cpl:/data/clokub-05# kubectl get po
    NAME                                  READY   STATUS        RESTARTS       AGE
    nfs-server-nfs-server-provisioner-0   1/1     Running       3 (114m ago)   2d19h
    test-example-6cdb796657-44qx9         1/1     Running       0              11s

    # Запускаем консоль внутри пода
    root@cpl:/data/clokub-05# kubectl exec -it test-example-6cdb796657-44qx9 -- bash

    # Проверка переменной окружения
    bash-5.1# env | grep DOMAIN_NAME
    DOMAIN_NAME=netology.ru

    # Проверка монтирования файллов
    bash-5.1# ls -al /data/nginx/
    total 12
    drwxrwxrwx    3 root     root          4096 Apr  7 05:23 .
    drwxr-xr-x    3 root     root          4096 Apr  7 05:23 ..
    drwxr-xr-x    2 root     root          4096 Apr  7 05:23 ..2022_04_07_05_23_32.2780863039
    lrwxrwxrwx    1 root     root            32 Apr  7 05:23 ..data -> ..2022_04_07_05_23_32.2780863039
    lrwxrwxrwx    1 root     root            17 Apr  7 05:23 nginx.conf -> ..data/nginx.conf
    ```