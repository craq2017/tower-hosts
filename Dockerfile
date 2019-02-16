FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd crontabs postgresql && \
    yum clean all

EXPOSE 80

# Simple startup script to avoid some issues observed with container restart


ADD run-httpd.sh /run-httpd.sh
ADD crontab /etc/cron.d/web
ADD update.sh /root/update.sh
RUN chmod 0644 /etc/cron.d/web
RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
RUN chmod 0644 /etc/cron.d/web
RUN crontab /etc/cron.d/web
RUN chmod -v +x /run-httpd.sh
RUN chmod -v +x /root/update.sh

CMD ["/run-httpd.sh"]
