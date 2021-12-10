all:
	@if [ -e /usr/local/bin/git-setup.sh ]; then\
		rm /usr/local/bin/git-setup.sh;\
		echo "rm /usr/local/bin/git-setup.sh";\
	fi
	cp git-setup.sh /usr/local/bin/
	chmod u+x /usr/local/bin/git-setup.sh