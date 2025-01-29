### Terraform with Yandex.Cloud Provider

##### [English.md](./README.md)

Этот репозиторий был разработан в рамках изучения возможностей Terraform+Yandex.Cloud

---

Перед использованием:

- Задайте необходимые значения в [`variables.auto.tfvars`](./variables.auto.tfvars)
- Задайте ключ IAM сервисного аккаунта Yandex.Cloud в файле [`key.json`](./key.json) в корне проекта
- _Настоятельно рекомендуется использовать редактор `VS Code`_

- Почитать:
    - [Yandex.Cloud в реестре Terraform](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs)
    - [Документация Yandex.Cloud](https://yandex.cloud/en/docs)
    - [Исходники модулей Terraform Yandex.Cloud](https://github.com/terraform-yc-modules) _(не особо понадобились)_

---

Структура проекта (кликабельно):
- [`compute`](./compute/) - модуль Terraform для создания Bastion + Private VM
- [`db`](./db/) - модуль Terraform для создания кластера PostgreSQL + host
- [`network`](./network/) - модуль Terrafrom для создания VPC
- [`root`](./) - корневой модуль Terrafrom - общая точка запуска всех модулей

---

#### Varibales

Каждый модуль имеет [`variables.tf`](./variables.tf) - переменные, требуемые для запуска модуля, их следует рассматривать как входные параметры для работы модуля

Корневой модуль помимо этого имеет файл [`variables.auto.tfvars`](./variables.auto.tfvars) <br />
Значения переменных, описанных в нём, автоматически используются Terraform'ом

Переменные лучше типизированы на уровне дочерних модулей. На корневом уровне дублируется лишь их название, чтобы иметь вводные данные для работы всего проекта

---

#### Outputs

Если есть необходимость в данных из одного модуля для работы в другом модуле, следует воспользоваться данным механизмом Terraform.

На этом примере использовались выходные значения работы модуля [`network`](./network/), описанные в файе [`outputs.tf`](./network/outputs.tf)

Перед использованием этого механизма стоит убедиться, что точно нет способов достать необходимые данные более простым и изящным способом, например механизмом `data` Terrafrom'а (например [`datas.tf`](./compute/datas.tf)). <br />
Для этого ознакомтесь с документацией вашего провайдера в регистре провайдеров Terraform (в данном случае [Yandex.Cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs))
