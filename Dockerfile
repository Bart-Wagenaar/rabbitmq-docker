#
# Docker file for rabbitMQ with shovel management enabled
#
FROM rabbitmq

MAINTAINER Merapar

RUN rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management