INSTALL_DIR=~/.local/bin
INSTALL_FILE=favdir.sh
FAVDIR=~/.favdir

all: install

install:
	git pull origin master
	mkdir -p $(INSTALL_DIR)
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "install.sh" \
		--exclude "Makefile" --exclude "README.md" -avh --no-perms . $(INSTALL_DIR)
	echo 'source $(INSTALL_DIR)/$(INSTALL_FILE) #FAVDIR' >>~/.bash_profile
	source ~/.bash_profile

clean:
	@$(RM) -rf $(INSTALL_DIR)/$(INSTALL_FILE) $(FAVDIR)
	@cat ~/.bashrc | (rm ~/.bashrc; sed '/FAVDIR/d' > ~/.bash_profile)

