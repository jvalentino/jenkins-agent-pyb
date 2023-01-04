FROM jenkins/agent:latest-jdk11
USER root
RUN apt-get update &&  \
    apt-get install python3-minimal=3.9.2-3 -y && \
    apt-get install python-is-python3 -y && \
    apt-get install python3-pip -y && \
    pip install pybuilder && \
    pip install virtualenv
