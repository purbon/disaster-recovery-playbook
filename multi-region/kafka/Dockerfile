FROM  confluentinc/cp-server:7.4.6
# --platform=linux/amd64

#x86_64
ARG ARCH=aarch64 

USER root
RUN yum install -y \
     libmnl \
     findutils \
     which

    
RUN wget http://vault.centos.org/8.1.1911/BaseOS/${ARCH}/os/Packages/iproute-tc-4.18.0-15.el8.${ARCH}.rpm
RUN rpm -i --nodeps --nosignature http://vault.centos.org/8.1.1911/BaseOS/${ARCH}/os/Packages/iproute-tc-4.18.0-15.el8.${ARCH}.rpm
RUN wget http://vault.centos.org/8.1.1911/BaseOS/${ARCH}/os/Packages/iptables-libs-1.8.2-16.el8.${ARCH}.rpm
RUN rpm -i --nodeps --nosignature http://vault.centos.org/8.1.1911/BaseOS/${ARCH}/os/Packages/iptables-libs-1.8.2-16.el8.${ARCH}.rpm
USER appuser