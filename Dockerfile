FROM	node:7.4

RUN	deluser --remove-home node \
	&& groupadd --gid 1000 byteball \
	&& useradd --uid 1000 --gid byteball --shell /bin/bash --create-home byteball

RUN	npm install -g bower grunt-cli

RUN	apt-get update \
	&& apt-get install -y \
		desktop-file-utils \
		libasound2 \
		libgconf-2-4 \
		libgl1-mesa-glx \
		libgtk2.0-0 \
		libnss3 \
		libxss1 \
		libxtst6

ENV	NW_VERSION 0.19.5

RUN	curl -SLO https://dl.nwjs.io/v$NW_VERSION/nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz \
	&& tar xzf nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz -C /usr/local \
	&& ln -s /usr/local/nwjs-sdk-v$NW_VERSION-linux-x64/nw /usr/local/bin/nw \
	&& rm nwjs-sdk-v$NW_VERSION-linux-x64.tar.gz 

RUN	echo "Byteball 2.1.0test" > /etc/byteball-release \
	&& mkdir /byteball /home/byteball/.config \
        && chown byteball:byteball /byteball /home/byteball/.config \
        && ln -s /byteball /home/byteball/.config/byteball-tn \	
	&& su - byteball -c "git clone https://github.com/byteball/byteball.git \
		&& cd byteball \
		&& git checkout testnet \
		&& bower install \
		&& npm install \
		&& grunt \
		&& cp -ir node_modules/sqlite3/lib/binding/node-v*-linux-x64 node_modules/sqlite3/lib/binding/node-webkit-v$NW_VERSION-linux-x64"

VOLUME	/byteball

USER	byteball
WORKDIR	/home/byteball

CMD	["nw", "byteball"]

