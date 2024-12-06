# FROM quay.io/fedora/fedora-bootc:41

# ENV TZ=Asia/Shanghai

# RUN dnf install -y dnf-plugins-core && \
# 	dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
# 	dnf install -y docker-ce docker-ce-cli containerd.io firewalld && \
# 	dnf clean all && \
# 	systemctl enable docker && \
# 	systemctl enable firewalld && \
# 	firewall-offline-cmd --add-port=9999/tcp
FROM quay.io/centos-bootc/centos-bootc:stream9

ENV TZ=Asia/Shanghai

RUN dnf install -y yum-utils && \
	dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo && \
	dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin firewalld && \
	dnf clean all && \
	systemctl enable docker && \
	systemctl enable firewalld && \
	firewall-offline-cmd --add-port=9999/tcp

RUN curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/bin/docker-compose && \
	chmod +x /usr/bin/docker-compose

ADD build/1panel /usr/bin/
ADD hack/1panel.service /etc/systemd/system/
RUN ln -sr /var/lib/1panel /opt/1panel && systemctl enable 1panel && \
	ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
	echo $TZ > /etc/timezone
ADD cmd/server/conf/app.yaml /opt/1panel/conf/

EXPOSE 9999
