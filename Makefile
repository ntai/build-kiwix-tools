
default: build

setup: .setup

.setup:
	sudo apt install meson
	sudo apt install zlib1g-dev libicu-dev libpugixml-dev aria2 pkg-config liblzma-dev libxapian-dev googletest libcurl4-openssl-dev libcurl4-openssl-dev libmicrohttpd-dev 
	touch .setup

build: setup /usr/local/bin/kiwix-serve

kiwix-tools:
	git clone https://github.com/kiwix/kiwix-tools.git

/usr/local/bin/kiwix-serve: /usr/local/lib/x86_64-linux-gnu/libkiwix.so.8.1.0 kiwix-tools 
	cd kiwix-tools && meson . build && ninja -C build && sudo ninja -C build install

kiwix-lib:
	git clone https://github.com/kiwix/kiwix-lib.git
	sed -i -e 's/int main(int argc, char\*\* argv)/int notmain(int argc, char** argv)/g' kiwix-lib/test/*.cpp

/usr/local/lib/x86_64-linux-gnu/libkiwix.so.8.1.0: /usr/local/lib/x86_64-linux-gnu/libzim.so.6.0.2 kiwix-lib
	cd kiwix-lib && meson . build && ninja -C build && sudo ninja -C build install

libzim:
	git clone https://github.com/openzim/libzim.git
	sed -i -e 's/int main(int argc, char\*\* argv)/int notmain(int argc, char** argv)/g' libzim/test/*.cpp

/usr/local/lib/x86_64-linux-gnu/libzim.so.6.0.2: /usr/local/include/mustache.hpp libzim
	cd libzim && meson . build && ninja -C build && sudo ninja -C build install

/usr/local/include/mustache.hpp: Mustache/mustache.hpp
	sudo install Mustache/mustache.hpp /usr/local/include/

Mustache/mustache.hpp:
	git clone https://github.com/kainjow/Mustache.git

.PHONY: clean
clean:
	rm -fr kiwix-tools kiwix-lib libzim Mustache
