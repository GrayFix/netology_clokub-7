# 15.3 "Безопасность в облачных провайдерах"
1. Yandex Cloud
  - Общее: 
    - Конфигурация terraform лежит в папке [netology-yc](./netology-yc/);
    - Переменные не прятал, лежат в файле [terraform.tfvars](./netology-yc/terraform.tfvars);
    - Переменная token задается в переменной окружения заранее, для Windows PowerShell команда `$env:TF_VAR_yc_token = yc iam create-token` (должно быть настроенное Yandex CLI);
    - Вывод команды `terraform apply` [terraform-apply.log](./terraform-apply.log);
    - Пароль для БД указан в файле terraform.tfvars, в продуктовой среде нужно спрятать куда-то. Например, в vault;
    - После применения выводится адрес хоста MySQL и команда для настройки конфигурации kubernetes;
      ```
      Outputs:

        kubectl_init = "kubectl init kommand: yc managed-kubernetes cluster get-credentials --id cattql109ek6ia8hrdlv --external"
        mysql_host_address = "MySQL host: rc1a-xyztxbetik5k5wxb.mdb.yandexcloud.net"
      ```
  - Консоль облака
    ![text](images/console.png)
  - Скриншоты части MySQL
    __Консоль__
    ![text](images/mysql_console.png)
    __Распределение хостов MySQL__
    ![text](images/mysql_host.png)
    __Список БД__
    ![text](images/mysql_db.png)

  - Скриншоты части Kubernetes
    __Консоль__
    ![text](images/kube_console.png)
    __Настройки рабочих нод__
    ![text](images/kube_nodes.png)
    __Список подов__
    ![text](images/kube_pods.png)
    __Список сервисов__
    ![text](images/kube_services.png)

  - phpMyAdmin
    - Манифест для деплоя [deploy.yaml](./phpmyadmin/deploy.yaml)
    - Перед применением изменить хост mysql на выданный терраформом. Логин и пароль на сам сервис лучше спрятать получше.

