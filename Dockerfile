FROM ubuntu:latest
MAINTAINER Don Li

# Reduce output from debconf
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get -y update
RUN echo "deb http://www.rabbitmq.com/debian/ testing main" >> /etc/apt/sources.list
RUN apt-get install -y wget
RUN wget http://www.rabbitmq.com/rabbitmq-signing-key-public.asc -O /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc
RUN apt-get -y update

RUN apt-get install -y rabbitmq-server
RUN rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []},{cluster_nodes, {['rabbit@rabbit1', 'rabbit@rabbit2', 'rabbit@rabbit3'], disc}}]}]." > /etc/rabbitmq/rabbitmq.config
RUN echo "VFKJTFEVZBVIHQYTPDMF" > /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie
RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie

# For RabbitMQ and RabbitMQ Admin
EXPOSE 5672 15672

# For RabbitMQ clustering
EXPOSE 4369 25672

ENTRYPOINT ["/usr/sbin/rabbitmq-server"]
