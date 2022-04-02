#
# Dockerなんもわからん
#

.PHONY: build

build:
	docker build -t enchan1207/mcserver-base:0.1.0 .
	docker images

run:
	docker run -itd -p 25565:25565 --name mcserver enchan/spigot_mcserver:0.1.0
