
.PHONY: run debug

debug:
	docker run -it \
		--volume $(PWD)/config:/mnt/config \
		--device /dev/usb \
		--device /dev/snd \
		--volume /tmp/xmosh/:/tmp/xmosh \
		mimi \
		./debug

run:
	docker run -it \
		--volume $(PWD)/config:/mnt/config \
		--device /dev/usb \
		--device /dev/snd \
		--volume /tmp/xmosh/:/tmp/xmosh \
		mimi \
		/bin/sh

build:
	docker build -t mimi .
