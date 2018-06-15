.PHONY: test

test:
	[ -e vendor/bin/bashtub ] || make install
	vendor/bin/bashtub tests/*.sh

install:
	curl --create-dir -o vendor/bin/bashtub https://raw.githubusercontent.com/ueokande/bashtub/v0.2/bin/bashtub
	chmod +x vendor/bin/bashtub
