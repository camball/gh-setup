all:
	@if [ -e /usr/local/bin/gh-setup ]; then\
		rm /usr/local/bin/gh-setup;\
	fi
	@cp gh-setup /usr/local/bin/
	@chmod u+x /usr/local/bin/gh-setup
	@echo "Installed to location \`/usr/local/bin/gh-setup\`"
	@echo "Process complete :)"