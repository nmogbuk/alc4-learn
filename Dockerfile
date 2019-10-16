FROM node:10.16

#Add user to run app as in container, instead of root user
ARG user=ubuntu
ARG group=ubuntu
ARG uid=1004
ARG gid=1004

EXPOSE 5000
RUN groupadd -g ${gid} ${group} && useradd -u ${uid} -g ${gid} -s /bin/bash -d /home/${user} ${user}
RUN mkdir -p /home/ubuntu/app

WORKDIR /home/ubuntu/app
ADD . /home/ubuntu/app

RUN npm install
RUN npm run build
RUN npm install -g serve
RUN chown -R ubuntu:ubuntu /home/ubuntu

USER ${user}


# From here we load our application's code in, therefore the previous docker
# "layer" thats been cached will be used if possible

CMD  serve -s build
