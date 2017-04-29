FROM	node:7.8

ENV	NW_VERSION 0.22.0

RUN	npm install -g bower grunt-cli

RUN	apt-get update \
	&& apt-get install -y libnss3 libxtst6 libxss1 libasound2 libgtk2.0-0 libgl1-mesa-glx libgconf-2-4 desktop-file-utils

RUN	curl -SLO https://dl.nwjs.io/v$NW_VERSION/nwjs-v$NW_VERSION-linux-x64.tar.gz \
	&& tar xzf nwjs-v$NW_VERSION-linux-x64.tar.gz -C /usr/local \
	&& ln -s /usr/local/nwjs-v$NW_VERSION-linux-x64/nw /usr/local/bin/nw \
	&& rm nwjs-v$NW_VERSION-linux-x64.tar.gz 

RUN	deluser --remove-home node \
	&& groupadd --gid 1000 byteball \
	&& useradd --uid 1000 --gid byteball --shell /bin/bash --create-home byteball \
	&& mkdir /byteball /home/byteball/.config \
        && chown byteball:byteball /byteball /home/byteball/.config \
        && ln -s /byteball /home/byteball/.config/byteball-tn

RUN	su - byteball -c "git clone https://github.com/byteball/byteball.git; cd byteball; git checkout testnet; bower install;  npm install; grunt"

VOLUME	/byteball

USER	byteball
WORKDIR	/home/byteball

CMD	["nw", "byteball"]

