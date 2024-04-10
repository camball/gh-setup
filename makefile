all:
	@if [ -e /usr/local/bin/git-setup ]; then\
		rm /usr/local/bin/git-setup;\
		echo "rm /usr/local/bin/git-setup";\
	fi
	cp git-setup /usr/local/bin/
	chmod u+x /usr/local/bin/git-setup