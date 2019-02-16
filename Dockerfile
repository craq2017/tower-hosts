FROM centos:7
MAINTAINER The CentOS Project <cloud-ops@centos.org>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40


RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd crontabs postgresql && \
    yum clean all

EXPOSE 80

ADD run-httpd.sh /run-httpd.sh
ADD update.sh /root/update.sh
ADD crontab /etc/cron.d/web
RUN chmod 0644 /etc/cron.d/web
RUN sed -i -e '/pam_loginuid.so/s/^/#/' /etc/pam.d/crond
RUN touch /var/log/cron.log
RUN chmod +x /root/update.sh
RUN chmod -v +x /run-httpd.sh
RUN crontab /etc/cron.d/web
CMD ["/run-httpd.sh"]
