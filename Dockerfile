FROM ubuntu:latest

RUN groupadd -r rabbitmq && useradd -r -d /var/lib/rabbitmq -m -g rabbitmq rabbitmq

# add rabbitmq repo
RUN apt-get update && \
apt-get install wget --assume-yes && \
wget https://www.rabbitmq.com/rabbitmq-signing-key-public.asc && \
sudo apt-key add rabbitmq-signing-key-public.asc && \
sed -i -e '1ideb http://www.rabbitmq.com/debian/ testing main\' /etc/apt/sources.list && \
apt-get update && \
apt-get install rabbitmq-server --assume-yes

# Enable plugins
RUN rabbitmq-plugins enable rabbitmq_management && \
rabbitmq-plugins enable rabbitmq_web_stomp && \
rabbitmq-plugins enable rabbitmq_mqtt

# expose ports
# Management
EXPOSE  15672
# Web-STOMP plugin
EXPOSE  15674
# MQTT:
EXPOSE  1883


# configure RabbitMQ
COPY ["rabbitmq-env.conf", "/etc/rabbitmq/rabbitmq-env.conf"]
RUN chmod 755 /etc/rabbitmq/rabbitmq-env.conf

# Create users for the apps
COPY ["rabbitmq-setup.sh", "/tmp/rabbitmq/rabbitmq-setup.sh"]
RUN mkdir /var/run/rabbitmq && \
chmod -R 755 /var/run/rabbitmq && \
chown -R rabbitmq:rabbitmq /var/run/rabbitmq && \
service rabbitmq-server start && \
sh /tmp/rabbitmq/rabbitmq-setup.sh && \
rm /tmp/rabbitmq/rabbitmq-setup.sh && \
service rabbitmq-server stop

# start rabbitmq
USER rabbitmq
CMD ["rabbitmq-server", "start"]