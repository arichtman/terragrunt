ARG OPENTOFU
ARG TERRAFORM
FROM ghcr.io/opentofu/opentofu:${OPENTOFU} AS opentofu
FROM docker.io/hashicorp/terraform:${TERRAFORM} AS terraform

FROM docker.io/alpine:edge AS downloader

ARG TERRAGRUNT
ARG BOILERPLATE

# Determine the target architecture using uname -m
RUN case $(uname -m) in \
    x86_64) ARCH=amd64; ;; \
    armv7l) ARCH=arm; ;; \
    aarch64) ARCH=arm64; ;; \
    ppc64le) ARCH=ppc64le; ;; \
    s390x) ARCH=s390x; ;; \
    *) echo "un-supported arch, exit ..."; exit 1; ;; \
    esac && \
    echo "export ARCH=$ARCH" > /envfile && \
    cat /envfile

RUN . /envfile && \
    TERRAGRUNT_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT}/terragrunt_linux_${ARCH}" && \
    wget -q "${TERRAGRUNT_URL}" -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

RUN . /envfile && \
    BOILERPLATE_URL="https://github.com/gruntwork-io/boilerplate/releases/download/v${BOILERPLATE}/boilerplate_linux_${ARCH}" && \
    wget -q "${BOILERPLATE_URL}" -O /usr/local/bin/boilerplate && \
    chmod +x /usr/local/bin/boilerplate

FROM scratch

COPY --from=quay.io/terraform-docs/terraform-docs:latest /usr/local/bin/terraform-docs /usr/local/bin/terraform-docs
COPY --from=opentofu /usr/local/bin/tofu /usr/local/bin/tofu
COPY --from=downloader /usr/local/bin/terragrunt /usr/local/bin/terragrunt
COPY --from=downloader /usr/local/bin/boilerplate /usr/local/bin/boilerplate
COPY --from=terraform /bin/terraform /usr/local/bin/terraform

WORKDIR /apps
