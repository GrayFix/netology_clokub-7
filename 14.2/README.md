#1 4.2 Синхронизация секретов с внешними сервисами. Vault

1. Работа с модулем Vault
  - Запуск vault
    ``` bash
    root@cpl:/data/clokub-homeworks# kubectl apply -f 14.2/vault-pod.yml
    pod/14.2-netology-vault created
    ```
  - Получаем IP пода
    ``` bash
    root@cpl:/data/clokub-homeworks# kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
    [{"ip":"10.233.90.120"}]
    ```
  - Доп пакеты установили
  - Python скрипт немного модернезировал, чтобы было понятно что он вообще работает. Обернул все вызовы в print
    ``` python
    import hvac
    client = hvac.Client(
        url='http://10.10.133.71:8200',
        token='aiphohTaa0eeHei'
    )
    print(client.is_authenticated())

    # Пишем секрет
    print(client.secrets.kv.v2.create_or_update_secret(
        path='hvac',
        secret=dict(netology='Big secret!!!'),
    ))

    # Читаем секрет
    print(client.secrets.kv.v2.read_secret_version(
        path='hvac',
    ))
    ```
  - Выполнение скрипта
    ``` bash
    sh-5.1# python3 example.py
    True
    {'request_id': '823b9dca-f147-2ffa-2334-bc5035676312', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-04-07T04:30:34.474392468Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 3}, 'wrap_info': None, 'warnings': None, 'auth': None}
    {'request_id': 'b41698fe-6927-2ba3-b6a5-2b1e3f6966ab', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-04-07T04:30:34.474392468Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 3}}, 'wrap_info': None, 'warnings': None, 'auth': None}
    ```
2. Работа с секретами внутри пода
  - Конфигурация для проверкаи. В секрет положен файл со скриптом
    ``` yaml
    ---
    apiVersion: v1
    kind: Secret
    metadata:
    name: example-py
    type: Opaque
    stringData:
    example.py: |
        import hvac
        client = hvac.Client(
            url='http://10.233.90.120:8200',
            token='aiphohTaa0eeHei'
        )
        print(client.is_authenticated())

        # Пишем секрет
        print(client.secrets.kv.v2.create_or_update_secret(
            path='hvac',
            secret=dict(netology='Big secret!!!'),
        ))

        # Читаем секрет
        print(client.secrets.kv.v2.read_secret_version(
            path='hvac',
        ))
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: example
    spec:
    containers:
    - name: fedora-example
        image: fedora
        command: ['sh', '-c', 'dnf -y install pip; pip install hvac; python3 /data/script/example.py && sleep 1800']
        volumeMounts:
        - name: example-py
            mountPath: "/data/script"
            readOnly: true
    volumes:
    - name: example-py
        secret:
        secretName: example-py
        optional: false
    ```
  - Запуск пода
    ``` bash
    root@cpl:/data/clokub-05# kubectl apply -f 02-example.yaml
    secret/example-py configured
    pod/example created
    ```
  - Смотрим логи
    ``` bash
    root@cpl:/data/clokub-05# kubectl logs -f example
    Fedora 35 - x86_64                               14 MB/s |  79 MB     00:05
    Fedora 35 openh264 (From Cisco) - x86_64        1.2 kB/s | 2.5 kB     00:02
    Fedora Modular 35 - x86_64                      1.7 MB/s | 3.3 MB     00:01
    Fedora 35 - x86_64 - Updates                    7.0 MB/s |  29 MB     00:04
    Fedora Modular 35 - x86_64 - Updates            1.4 MB/s | 2.9 MB     00:02
    Last metadata expiration check: 0:00:01 ago on Thu Apr  7 05:02:36 2022.
    Dependencies resolved.
    ================================================================================
    Package                  Architecture Version              Repository     Size
    ================================================================================
    Installing:
    python3-pip              noarch       21.2.3-4.fc35        updates       1.8 M
    Installing weak dependencies:
    libxcrypt-compat         x86_64       4.4.28-1.fc35        updates        89 k
    python3-setuptools       noarch       57.4.0-1.fc35        fedora        928 k

    Transaction Summary
    ================================================================================
    Install  3 Packages

    Total download size: 2.8 M
    Installed size: 14 M
    Downloading Packages:
    (1/3): libxcrypt-compat-4.4.28-1.fc35.x86_64.rp 317 kB/s |  89 kB     00:00
    (2/3): python3-setuptools-57.4.0-1.fc35.noarch. 1.6 MB/s | 928 kB     00:00
    (3/3): python3-pip-21.2.3-4.fc35.noarch.rpm     2.4 MB/s | 1.8 MB     00:00
    --------------------------------------------------------------------------------
    Total                                           2.3 MB/s | 2.8 MB     00:01
    Running transaction check
    Transaction check succeeded.
    Running transaction test
    Transaction test succeeded.
    Running transaction
    Preparing        :                                                        1/1
    Installing       : libxcrypt-compat-4.4.28-1.fc35.x86_64                  1/3
    Installing       : python3-setuptools-57.4.0-1.fc35.noarch                2/3
    Installing       : python3-pip-21.2.3-4.fc35.noarch                       3/3
    Running scriptlet: python3-pip-21.2.3-4.fc35.noarch                       3/3
    Verifying        : python3-setuptools-57.4.0-1.fc35.noarch                1/3
    Verifying        : libxcrypt-compat-4.4.28-1.fc35.x86_64                  2/3
    Verifying        : python3-pip-21.2.3-4.fc35.noarch                       3/3

    Installed:
    libxcrypt-compat-4.4.28-1.fc35.x86_64      python3-pip-21.2.3-4.fc35.noarch
    python3-setuptools-57.4.0-1.fc35.noarch

    Complete!
    Collecting hvac
    Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
    Collecting six>=1.5.0
    Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
    Collecting requests>=2.21.0
    Downloading requests-2.27.1-py2.py3-none-any.whl (63 kB)
    Collecting idna<4,>=2.5
    Downloading idna-3.3-py3-none-any.whl (61 kB)
    Collecting certifi>=2017.4.17
    Downloading certifi-2021.10.8-py2.py3-none-any.whl (149 kB)
    Collecting charset-normalizer~=2.0.0
    Downloading charset_normalizer-2.0.12-py3-none-any.whl (39 kB)
    Collecting urllib3<1.27,>=1.21.1
    Downloading urllib3-1.26.9-py2.py3-none-any.whl (138 kB)
    Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
    WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
    Successfully installed certifi-2021.10.8 charset-normalizer-2.0.12 hvac-0.11.2 idna-3.3 requests-2.27.1 six-1.16.0 urllib3-1.26.9
    
    True
    {'request_id': 'bb8adb18-cb96-045f-0bc0-1e0237643599', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-04-07T05:02:51.749946426Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 4}, 'wrap_info': None, 'warnings': None, 'auth': None}
    {'request_id': 'f0f5e991-15a7-9302-104f-28a6f3541d9c', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-04-07T05:02:51.749946426Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 4}}, 'wrap_info': None, 'warnings': None, 'auth': None}
    ```