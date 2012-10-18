install: install-bin

install-bin:
	mkdir -p ~/bin/
	ln -fs `pwd`/bin/* ~/bin/
