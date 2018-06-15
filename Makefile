.PHONY: test

install:
	curl --create-dir -o vendor/bin/bashtub https://raw.githubusercontent.com/ueokande/bashtub/v0.1/bin/bashtub
	chmod +x vendor/bin/bashtub

test:
	[ -e vendor/bin/bashtub ] || make install
	echo hello
