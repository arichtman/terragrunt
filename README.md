# enhanced tool to manage terraform deployment with terragrunt

[If enjoy, please consider buying the originator a coffee.](https://www.buymeacoffee.com/ozbillwang)

Auto-trigger docker build for [terragrunt](https://github.com/gruntwork-io/terragrunt) when new terraform version is related.

[![DockerHub Badge](http://dockeri.co/image/arichtman/terragrunt)](https://hub.docker.com/r/arichtman/terragrunt/)

### Notes

* Never use tag `latest` in prod environment.
* Multi-Arch supported (linux/amd64, linux/arm64)
* For examples, below tags are supported now:
  - alpine/terragrunt:latest
  - alpine/terragrunt:tf-1.8.4 (terraform version)
  - alpine/terragrunt:tg-0.58.14 (terragrunt version)
  - alpine/terragrunt:otf-1.7.1 (opentofu version)
* Loose tags are also pushed to allow optimistic versioning

### Tools included in this container

* [terraform](https://terraform.io) - terraform version is this docker image's tag
* [terragrunt](https://github.com/gruntwork-io/terragrunt) - The latest terragrunt version when running the build.
* [boilerplate](https://github.com/gruntwork-io/boilerplate) - The latest boilerplate version when running the build.
* [terraform-docs](https://github.com/terraform-docs/terraform-docs) - The latest terraform-docs version when running the build.
* [OpenTofu](https://opentofu.org/docs/intro/install/) - the latest opentofu version when running the build

### Repo:

https://github.com/arichtman/terragrunt

### Daily build logs:

https://github.com/arichtman/terragrunt/actions

### Docker image tags:

https://hub.docker.com/r/arichtman/terragrunt/tags/

### Multiple platforms supported

* linux/arm64
* linux/amd64

# Why we need it

This is mostly used during Continuous Integration and Continuous Delivery (CI/CD), or as a component of an automated build and deployment process.

# Usage:

    # (1) must mount the local folder to /apps in container.
    # (2) must mount the aws credentials and ssh config folder in container.
    $ docker run -ti --rm -v $HOME/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/apps alpine/terragrunt:0.12.16 bash
    #
    # common terraform steps
    $ terraform init
    $ terraform fmt
    $ terraform validate
    $ terraform plan
    $ terraform apply

    # common opentofu steps
    $ tofu init
    $ tofu fmt
    $ tofu validate
    $ tofu plan
    $ tofu apply

    # common terragrunt steps
    # cd to terragrunt configuration directory, if required.
    # Terraform and OpenTofu Version Compatibility Table
    # https://terragrunt.gruntwork.io/docs/getting-started/supported-versions/
    $ terragrunt hclfmt
    $ terragrunt run-all plan
    $ terragrunt run-all apply

# The Processes to build this image

* Enable CI cronjob on this repo to run build weekly on main branch
* Check if there are new versions announced via Terraform Github REST API
* Match the exist docker image tags via Hub.docker.io REST API
* If not matched, build the image with latest `terraform version` as tag and push to hub.docker.com
* Always install latest version of terragrunt
