# 14.5 SecurityContext, NetworkPolicies
1. Запуск `example-security-context.yml` и проверка настроенных UID и GUI
```
root@cpl:/data/clokub-homeworks# kubectl apply -f 14.5/example-security-context.yml
pod/security-context-demo created

root@cpl:/data/clokub-homeworks# kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```
2. Проверка доступов
  - Файл деплоя [05-example.yaml](./05-example.yaml)
  - Применяем деплой
    ``` bash
    # Применение
    root@cpl:/data/clokub-05# kubectl apply -f 05-example.yaml
    networkpolicy.networking.k8s.io/frontend created
    networkpolicy.networking.k8s.io/backend created
    deployment.apps/frontend created
    deployment.apps/backend created
    service/fronend created
    service/backend created

    # Проверка
    root@cpl:/data/clokub-05# kubectl get po,svc,networkpolicy
    NAME                                      READY   STATUS    RESTARTS       AGE
    pod/backend-5f864c49c-x7r55               1/1     Running   0              29s
    pod/frontend-65556c6477-mcgfs             1/1     Running   0              29s
    pod/nfs-server-nfs-server-provisioner-0   1/1     Running   3 (152m ago)   2d19h

    NAME                                        TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                                                                                     AGE
    service/backend                             ClusterIP   10.233.36.114   <none>        80/TCP                                                                                                      28s
    service/fronend                             ClusterIP   10.233.30.241   <none>        80/TCP                                                                                                      29s
    service/kubernetes                          ClusterIP   10.233.0.1      <none>        443/TCP                                                                                                     3d1h
    service/nfs-server-nfs-server-provisioner   ClusterIP   10.233.32.155   <none>        2049/TCP,2049/UDP,32803/TCP,32803/UDP,20048/TCP,20048/UDP,875/TCP,875/UDP,111/TCP,111/UDP,662/TCP,662/UDP   2d19h

    NAME                                       POD-SELECTOR   AGE
    networkpolicy.networking.k8s.io/backend    app=backend    29s
    networkpolicy.networking.k8s.io/frontend   app=frontend   29s
    ```
  - Проверка доступов для frontend
    ``` bash
    root@cpl:/data/clokub-05# kubectl exec pod/frontend-65556c6477-mcgfs -- curl http://ya.ru -v
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 87.250.250.242:80...
    * Connected to ya.ru (87.250.250.242) port 80 (#0)
    > GET / HTTP/1.1
    > Host: ya.ru
    > User-Agent: curl/7.79.1
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 302 Found
    < Cache-Control: no-cache,no-store,max-age=0,must-revalidate
    < Content-Length: 0
    < Date: Thu, 07 Apr 2022 06:03:09 GMT
    < Expires: Thu, 07 Apr 2022 06:03:09 GMT
    < Last-Modified: Thu, 07 Apr 2022 06:03:09 GMT
    < Location: https://ya.ru/
    < P3P: policyref="/w3c/p3p.xml", CP="NON DSP ADM DEV PSD IVDo OUR IND STP PHY PRE NAV UNI"
    < X-Content-Type-Options: nosniff
    < set-cookie: is_gdpr=0; Path=/; Domain=.ya.ru; Expires=Sat, 06 Apr 2024 06:03:09 GMT
    < set-cookie: is_gdpr_b=CNyJdhDxaw==; Path=/; Domain=.ya.ru; Expires=Sat, 06 Apr 2024 06:03:09 GMT
    < set-cookie: _yasc=v5tvpcTvMMpKLEgxT24a9tnVnoGyKxEaYjV66FBn4RpfTg==; domain=.ya.ru; path=/; expires=Sat, 07-May-2022 06:03:09 GMT; secure

    root@cpl:/data/clokub-05# kubectl exec pod/frontend-65556c6477-mcgfs -- curl http://backend -v
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0Praqma Network MultiTool (with NGINX) - backend-5f864c49c-x7r55 - 10.233.90.131 - HTTP: 80 , HTTPS: 443
    <br>
    <hr>
    <br>

    <h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

    <h2>Important note about name/org change:</h2>
    <p>
    Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
    </p>
    <p>
    The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though.
    </p>
    <p>
    - Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
    </p>

    <h2>Some important URLs:</h2>

    <ul>
    <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

    <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
    </ul>

    <br>
    Or:
    <br>

    <pre>
    <code>
    docker pull wbitt/network-multitool
    </code>
    </pre>


    <hr>

    *   Trying 10.233.36.114:80...
    * Connected to backend (10.233.36.114) port 80 (#0)
    > GET / HTTP/1.1
    > Host: backend
    > User-Agent: curl/7.79.1
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Server: nginx/1.18.0
    < Date: Thu, 07 Apr 2022 06:03:28 GMT
    < Content-Type: text/html
    < Content-Length: 1576
    < Last-Modified: Thu, 07 Apr 2022 06:01:24 GMT
    < Connection: keep-alive
    < ETag: "624e7e34-628"
    < Accept-Ranges: bytes
    <
    { [1576 bytes data]
    100  1576  100  1576    0     0  57369      0 --:--:-- --:--:-- --:--:-- 58370
    * Connection #0 to host backend left intact
    ```
  - Проверка доступов для backend
    ``` bash
    root@cpl:/data/clokub-05# kubectl exec backend-5f864c49c-x7r55 -- curl -m 2 ya.ru -v
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 87.250.250.242:80...
    *   Trying 2a02:6b8::2:242:80...
    * Immediate connect fail for 2a02:6b8::2:242: Network unreachable
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* After 987ms connect time, move on!
    * connect to 87.250.250.242 port 80 failed: Operation timed out
    * Failed to connect to ya.ru port 80 after 1236 ms: Operation timed out
    0     0    0     0    0     0      0      0 --:--:--  0:00:01 --:--:--     0
    * Closing connection 0
    curl: (28) Failed to connect to ya.ru port 80 after 1236 ms: Operation timed out
    command terminated with exit code 28

    root@cpl:/data/clokub-05# kubectl exec backend-5f864c49c-x7r55 -- curl -m 2 frontend -v
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying 10.233.52.227:80...
    * Connected to frontend (10.233.52.227) port 80 (#0)
    > GET / HTTP/1.1
    > Host: frontend
    > User-Agent: curl/7.79.1
    > Accept: */*
    >
    Praqma Network MultiTool (with NGINX) - frontend-65556c6477-mcgfs - 10.233.90.130 - HTTP: 80 , HTTPS: 443
    <br>
    <hr>
    <br>

    <h1>05 Jan 2022 - Press-release: `Praqma/Network-Multitool` is now `wbitt/Network-Multitool`</h1>

    <h2>Important note about name/org change:</h2>
    <p>
    Few years ago, I created this tool with Henrik Høegh, as `praqma/network-multitool`. Praqma was bought by another company, and now the "Praqma" brand is being dismantled. This means the network-multitool's git and docker repositories must go. Since, I was the one maintaining the docker image for all these years, it was decided by the current representatives of the company to hand it over to me so I can continue maintaining it. So, apart from a small change in the repository name, nothing has changed.<br>
    </p>
    <p>
    The existing/old/previous container image `praqma/network-multitool` will continue to work and will remain available for **"some time"** - may be for a couple of months - not sure though.
    </p>
    <p>
    - Kamran Azeem <kamranazeem@gmail.com> <a href=https://github.com/KamranAzeem>https://github.com/KamranAzeem</a>
    </p>

    <h2>Some important URLs:</h2>

    <ul>
    <li>The new official github repository for this tool is: <a href=https://github.com/wbitt/Network-MultiTool>https://github.com/wbitt/Network-MultiTool</a></li>

    <li>The docker repository to pull this image is now: <a href=https://hub.docker.com/r/wbitt/network-multitool>https://hub.docker.com/r/wbitt/network-multitool</a></li>
    </ul>

    <br>
    Or:
    <br>

    <pre>
    <code>
    docker pull wbitt/network-multitool
    </code>
    </pre>


    <hr>

    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < Server: nginx/1.18.0
    < Date: Thu, 07 Apr 2022 06:17:59 GMT
    < Content-Type: text/html
    < Content-Length: 1578
    < Last-Modified: Thu, 07 Apr 2022 06:01:23 GMT
    < Connection: keep-alive
    < ETag: "624e7e33-62a"
    < Accept-Ranges: bytes
    <
    { [1578 bytes data]
    100  1578  100  1578    0     0   124k      0 --:--:-- --:--:-- --:--:--  128k
    * Connection #0 to host frontend left intact
    ```