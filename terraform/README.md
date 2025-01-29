### Terraform with Yandex.Cloud Provider

##### [Russian.md](./README.ru.md)

This repository was developed as part of exploring the capabilities of Terraform+Yandex.Cloud

---

Before use:

- Set the required values ​​in [`variables.auto.tfvars`](./variables.auto.tfvars)
- Set the IAM key of the Yandex.Cloud service account in the file [`key.json`](./key.json) in the root of the project
- _It is strongly recommended to use the editor `VS Code`_

- see:
    - [Yandex.Cloud in Terraform's registry](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs)
    - [Yandex.Cloud's docs](https://yandex.cloud/en/docs)
    - [Terraform Yandex.Cloud module sources](https://github.com/terraform-yc-modules) _(optional)_

---

Project structure (clickable):
- [`compute`](./compute/) - Terraform module for creating Bastion + Private VM
- [`db`](./db/) - Terraform module for creating PostgreSQL cluster + host
- [`network`](./network/) - Terrafrom module for creating VPC
- [`root`](./) - Terrafrom root module - common launch point for all modules

---

#### Varibales

Each module has [`variables.tf`](./variables.tf) - variables required to run the module, they should be considered as input parameters for the module to work

The root module also has a file [`variables.auto.tfvars`](./variables.auto.tfvars) <br />
The values ​​of the variables described in it are automatically used by Terraform

Variables are better typed at the level of child modules. At the root level, only their name is duplicated in order to have input data for the entire project to work

---

#### Outputs

If you need data from one module to work in another module, you should use this Terraform mechanism.

In this example, we used the output values ​​of the [`network`](./network/) module, described in the [`outputs.tf`](./network/outputs.tf) file

Before using this mechanism, you should make sure that there is definitely no way to get the necessary data in a simpler and more elegant way, for example, using the Terrafrom `data` mechanism (for example, [`datas.tf`](./compute/datas.tf)). <br />
To do this, read the documentation of your provider in the Terraform provider registry (in this case, [Yandex.Cloud](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs))
