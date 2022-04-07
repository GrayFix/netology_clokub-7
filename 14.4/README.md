# 14.4 Сервис-аккаунты
1. Работа с сервис-аккаунтами через утилиту kubectl
  - Cоздаем сервис-аккаунт
    ``` bash
    root@cpl:/data/clokub-05# kubectl create serviceaccount netology
    serviceaccount/netology created
    ```
  - Смотрим список сервис-аккаунтов
    ``` bash
    root@cpl:/data/clokub-05# kubectl get serviceaccounts
    NAME                                SECRETS   AGE
    default                             1         3d
    netology                            1         45s
    nfs-server-nfs-server-provisioner   1         2d19h

    root@cpl:/data/clokub-05# kubectl get serviceaccount
    NAME                                SECRETS   AGE
    default                             1         3d
    netology                            1         45s
    nfs-server-nfs-server-provisioner   1         2d19h
    ```
  - Получаем информацию в формате YAML и/или JSON
    ``` bash
    root@cpl:/data/clokub-05# kubectl get serviceaccount netology -o yaml
    apiVersion: v1
    kind: ServiceAccount
    metadata:
    creationTimestamp: "2022-04-07T05:34:05Z"
    name: netology
    namespace: default
    resourceVersion: "236274"
    uid: 762f084e-b176-4f72-9460-a082bac63847
    secrets:
    - name: netology-token-prnhd
    
    root@cpl:/data/clokub-05# kubectl get serviceaccount default -o json
    {
        "apiVersion": "v1",
        "kind": "ServiceAccount",
        "metadata": {
            "creationTimestamp": "2022-04-04T04:44:54Z",
            "name": "default",
            "namespace": "default",
            "resourceVersion": "428",
            "uid": "e61c04ed-f788-4c2b-9218-9d4ca2324150"
        },
        "secrets": [
            {
                "name": "default-token-7pj9h"
            }
        ]
    }
    ```
  - Выгружаем сервис-акаунты в файл
    ``` bash
    root@cpl:/data/clokub-05# kubectl get serviceaccounts -o json > serviceaccounts.json
    root@cpl:/data/clokub-05# kubectl get serviceaccount netology -o yaml > netology.yml

    # Проверка
    root@cpl:/data/clokub-05# cat serviceaccounts.json netology.yml
    {
        "apiVersion": "v1",
        "items": [
            {
                "apiVersion": "v1",
                "kind": "ServiceAccount",
                "metadata": {
                    "creationTimestamp": "2022-04-04T04:44:54Z",
                    "name": "default",
                    "namespace": "default",
                    "resourceVersion": "428",
                    "uid": "e61c04ed-f788-4c2b-9218-9d4ca2324150"
                },
                "secrets": [
                    {
                        "name": "default-token-7pj9h"
                    }
                ]
            },
            {
                "apiVersion": "v1",
                "kind": "ServiceAccount",
                "metadata": {
                    "creationTimestamp": "2022-04-07T05:34:05Z",
                    "name": "netology",
                    "namespace": "default",
                    "resourceVersion": "236274",
                    "uid": "762f084e-b176-4f72-9460-a082bac63847"
                },
                "secrets": [
                    {
                        "name": "netology-token-prnhd"
                    }
                ]
            },
            {
                "apiVersion": "v1",
                "kind": "ServiceAccount",
                "metadata": {
                    "annotations": {
                        "meta.helm.sh/release-name": "nfs-server",
                        "meta.helm.sh/release-namespace": "default"
                    },
                    "creationTimestamp": "2022-04-04T10:09:34Z",
                    "labels": {
                        "app": "nfs-server-provisioner",
                        "app.kubernetes.io/managed-by": "Helm",
                        "chart": "nfs-server-provisioner-1.1.3",
                        "heritage": "Helm",
                        "release": "nfs-server"
                    },
                    "name": "nfs-server-nfs-server-provisioner",
                    "namespace": "default",
                    "resourceVersion": "34099",
                    "uid": "2a61f2f4-15b5-4c2e-8619-513bc21d07bd"
                },
                "secrets": [
                    {
                        "name": "nfs-server-nfs-server-provisioner-token-89cwg"
                    }
                ]
            }
        ],
        "kind": "List",
        "metadata": {
            "resourceVersion": "",
            "selfLink": ""
        }
    }
    apiVersion: v1
    kind: ServiceAccount
    metadata:
    creationTimestamp: "2022-04-07T05:34:05Z"
    name: netology
    namespace: default
    resourceVersion: "236274"
    uid: 762f084e-b176-4f72-9460-a082bac63847
    secrets:
    - name: netology-token-prnhd
    ```
  - Удаляем сервис-акаунт
    ``` bash
    root@cpl:/data/clokub-05# kubectl delete serviceaccount netology
    serviceaccount "netology" deleted

    # Проверка
    root@cpl:/data/clokub-05# kubectl get serviceaccount
    NAME                                SECRETS   AGE
    default                             1         3d
    nfs-server-nfs-server-provisioner   1         2d19h
    ```
  - Загружаем сервис-акаунт из файла
    ``` bash
    root@cpl:/data/clokub-05# kubectl apply -f netology.yml
    serviceaccount/netology created

    # Проверка
    root@cpl:/data/clokub-05# kubectl get serviceaccount
    NAME                                SECRETS   AGE
    default                             1         3d
    netology                            2         2s
    nfs-server-nfs-server-provisioner   1         2d19h
    ```
2. Работа с сервис-акаунтами внутри модуля
  - Запускаем и смотрим переменные окружения
    ``` bash
    root@cpl:/data/clokub-05# kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
    If you don't see a command prompt, try pressing enter.

    sh-5.1# env | grep KUBE
    KUBERNETES_SERVICE_PORT_HTTPS=443
    KUBERNETES_SERVICE_PORT=443
    KUBERNETES_PORT_443_TCP=tcp://10.233.0.1:443
    KUBERNETES_PORT_443_TCP_PROTO=tcp
    KUBERNETES_PORT_443_TCP_ADDR=10.233.0.1
    KUBERNETES_SERVICE_HOST=10.233.0.1
    KUBERNETES_PORT=tcp://10.233.0.1:443
    KUBERNETES_PORT_443_TCP_PORT=443
    ```
  - Настраиваем переменные окружения и подключаемся к API
    ``` bash
    sh-5.1# K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
    SADIR=/var/run/secrets/kubernetes.io/serviceaccount
    TOKEN=$(cat $SADIR/token)
    CACERT=$SADIR/ca.crt
    NAMESPACE=$(cat $SADIR/namespace)

    sh-5.1# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
    {
    "kind": "APIResourceList",
    "groupVersion": "v1",
    "resources": [
        {
        "name": "bindings",
        "singularName": "",
        "namespaced": true,
        "kind": "Binding",
        "verbs": [
            "create"
        ]
        },
    ...
    ```