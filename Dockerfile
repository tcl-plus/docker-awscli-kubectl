FROM bitnami/aws-cli:latest

USER root

# Install required system packages and dependencies
RUN install_packages ca-certificates curl git jq procps
RUN mkdir -p /tmp/bitnami/pkg/cache/ ; cd /tmp/bitnami/pkg/cache/ ; \
    COMPONENTS=( \
      "kubectl-1.29.1-0-linux-${OS_ARCH}-debian-11" \
    ) ; \
    for COMPONENT in "${COMPONENTS[@]}"; do \
      if [ ! -f "${COMPONENT}.tar.gz" ]; then \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz" -O ; \
        curl -SsLf "https://downloads.bitnami.com/files/stacksmith/${COMPONENT}.tar.gz.sha256" -O ; \
      fi ; \
      sha256sum -c "${COMPONENT}.tar.gz.sha256" ; \
      tar -zxf "${COMPONENT}.tar.gz" -C /opt/bitnami --strip-components=2 --no-same-owner --wildcards '*/files' ; \
      rm -rf "${COMPONENT}".tar.gz{,.sha256} ; \
    done

# Install yq
RUN curl -SsLf "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64" -o /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN apt-get autoremove --purge -y curl && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
RUN chmod g+rwX /opt/bitnami
RUN mkdir /.kube && chmod g+rwX /.kube

ENV PATH="/opt/bitnami/kubectl/bin:$PATH"

# 保持使用root用户，因为使用awscli中，需要往~/.aws/cli/cache/目录写文件
# USER 1001
ENTRYPOINT []
CMD []
