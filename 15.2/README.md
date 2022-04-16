# 15.2 Вычислительные мощности. Балансировщики нагрузки
1. Yandex Cloud
  - Конфигурация terraform лежит в папке [netology-yc](./netology-yc/);
  - Переменные не прятал, лежат в файле [terraform.tfvars](./netology-yc/terraform.tfvars);
  - Переменная token задается в переменной окружения заранее, для Windows PowerShell комманда `$env:TF_VAR_yc_token = yc iam create-token` (должно быть настроенное Yandex CLI);
  - Вывод комманды `terraform apply` [terraform-apply.log](./terraform-apply.log);
  - Предлодженный в задании образ LAMP работает как-то нестибльно. Состояние в группе размещения мониторится нормально, а балансировщик приложений L7 его не может проверить. В логах компьютера 400 ошибка от запросов проверки здоровья балансировщика. Переделал все на образ LEMP fd89p7c1733dg28ssvev. Сразу нормально заработали проверки;
  - Ссылка на картинку в бакете - [https://storage.yandexcloud.net/netology-grayfix/netology.jpg](https://storage.yandexcloud.net/netology-grayfix/netology.jpg);
  - Страничка для показа передается при создании ВМ через файл [auth-meta.txt](./netology-yc/auth-meta.txt);
  - Скриншоты после создания:
    __Консоль__
    ![text](images/folder.png)
    __Группы виртуальных машин__
    ![text](images/cig.png)
    __Виртуальные машины в группе__
    ![text](images/cc.png)
    __Балансировщик приложений L7__
    ![text](images/alb.png)
    __Раздел проверки состояния в настройках балансировщика__
    ![text](images/alb-hc.png)
    __Целевая группа__
    ![text](images/alb-tg.png)
    __Бакет в объектом хранилище__
    ![text](images/os.png)
    __Получившийся сайт__
    ![text](images/web-page.png)

2. В AWS сделать не могу в текущих условиях.