FROM node:0.12.2-onbuild

# App
ADD . /src
# Install app dependencies
RUN cd /src; npm install

EXPOSE 3000

CMD ["node", "/src/bin/www"]