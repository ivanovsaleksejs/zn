all:
	stack build && (rm /tmp/zn.sock*; stack exec zn)

# init:
#     cd ~/zn
#     git init zn --bare
#     su -c 'pacman -S haskell-stack'

update:
	git fetch origin master
	git reset --hard origin/master
	make service

deploy:
	git push origin master $(GITARGS)
	ssh zn make -C '~/zn' update

stack:
	mkdir -p ~/stack-tmp
	TMPDIR=~/stack-tmp stack setup
	rm -r ~/stack-tmp

setup: stack
	date
	mkdir -p ~/.config{,/systemd{,/user}}
	if ! [ -e ~/.config/systemd/user/zn.service ]; then \
		ln -s $$(realpath zn.service) ~/.config/systemd/user; \
	fi

restart:
	systemctl --user restart zn

build:
	stack build

service: setup build restart
	date
