#
# Docker file for rabbitMQ with shovel management enabled
#
FROM rabbitmq:3.5.7-management

MAINTAINER Merapar

RUN rabbitmq-plugins enable rabbitmq_shovel rabbitmq_shovel_management