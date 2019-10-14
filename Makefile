
.PHONY: build debug listen push run

listen:
	docker run -it \
		--volume $(PWD)/config:/mnt/config \
		--device /dev/usb \
		--device /dev/snd \
		mimi \
		./listen

debug:
	docker run -it \
		--volume $(PWD)/config:/mnt/config \
		--device /dev/usb \
		--device /dev/snd \
		mimi \
		./debug

run:
	docker run -it \
		--volume $(PWD)/config:/mnt/config \
		--device /dev/usb \
		--device /dev/snd \
		mimi \
		/bin/sh

build:
	docker build -t mimi .
