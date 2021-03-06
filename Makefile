.PHONY: install

all : install

install :
		cp -rf .vim "$(HOME)"/.
		mkdir -p "$(HOME)"/.config/i3
		install -v -C -m 0644 -- .config/i3/config "$(HOME)"/.config/i3/config
		install -v -C -m 0644 -- .bashrc "$(HOME)"/.bashrc
		install -v -C -m 0644 -- .bash_profile "$(HOME)"/.bash_profile
		install -v -C -m 0644 -- .inputrc "$(HOME)"/.inputrc
		install -v -C -m 0644 -- .gitconfig "$(HOME)"/.gitconfig
		install -v -C -m 0644 -- .githelpers "$(HOME)"/.githelpers
		install -v -C -m 0644 -- .gitignore "$(HOME)"/.gitignore
		install -v -C -m 0644 -- .tmux.conf "$(HOME)"/.tmux.conf
		install -v -C -m 0644 -- .vimrc "$(HOME)"/.vimrc
		install -v -C -m 0644 -- .wgetrc "$(HOME)"/.wgetrc
		install -v -C -m 0644 -- .ackrc "$(HOME)"/.ackrc
		install -v -C -m 0644 -- .toprc "$(HOME)"/.toprc
