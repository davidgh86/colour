FROM node

ARG github_user
ARG github_password

RUN git clone https://$github_user:$github_password@github.com/davidgh86/colour.git
WORKDIR /colour
RUN git checkout master

RUN npm install
RUN npm i -g @quasar/cli

COPY start_server .

ENTRYPOINT /bin/bash start_server
