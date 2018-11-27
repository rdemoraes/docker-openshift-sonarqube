FROM registry.access.redhat.com/rhel7.5
LABEL maintainer="Raphael Moraes"

ENV SONAR_VERSION=7.3 \
    SONARQUBE_HOME=/opt/sonarqube

LABEL name="SonarQube" \
      io.k8s.display-name="SonarQube" \
      io.k8s.description="Provide a SonarQube image to run on Red Hat OpenShift" \
      io.openshift.expose-services="9000" \
      io.openshift.tags="sonarqube" \
      build-date="2018-10-12" \
      version=$SONAR_VERSION \
      release="1"

USER root
EXPOSE 9000

RUN yum-config-manager --disablerepo=* && yum-config-manager --enablerepo=rhel-server-rhscl-7-rpms \
--enablerepo=rhel-7-server-rpms \
--enablerepo=rhel-7-server-optional-rpms \
--enablerepo=rhel-7-server-satellite-tools-6.2-rpms \
--enablerepo=Banco_Votorantim_Epel_Epel_Red_Hat_Enterprise_Linux_7_Server_RPMs_x86_64

RUN yum -y update \
    && yum -y install unzip java-1.8.0-openjdk nss_wrapper \
    && yum clean all \
    && rm -rf /var/cache/yum \
    && cd /tmp \
    && curl -o sonarqube.zip -fSL https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-$SONAR_VERSION.zip \
    && cd /opt \
    && mkdir sonarqube \
    && cd sonarqube \
    && unzip /tmp/sonarqube.zip \
    && rm /tmp/sonarqube.zip*
ADD root /

RUN useradd -r sonar \
    && chmod 775 $SONARQUBE_HOME/bin/run_sonarqube.sh \
    && /usr/bin/fix-permissions /opt/sonarqube

USER sonar
WORKDIR $SONARQUBE_HOME
VOLUME $SONARQUBE_HOME/data

ENTRYPOINT ["./bin/run_sonarqube.sh"]
