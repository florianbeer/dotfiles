.PHONY: install

all : install

install :
		cp -rf .tmux-powerline "$(HOME)"/.
		cp -rf .vim "$(HOME)"/.
		install -v -C -m 0644 -- .bashrc "$(HOME)"/.bashrc
		install -v -C -m 0644 -- .bash_profile "$(HOME)"/.bash_profile
		install -v -C -m 0644 -- .inputrc "$(HOME)"/.inputrc
		install -v -C -m 0644 -- .gitconfig "$(HOME)"/.gitconfig
		install -v -C -m 0644 -- .githelpers "$(HOME)"/.githelpers
		install -v -C -m 0644 -- .gitignore "$(HOME)"/.gitignore
		install -v -C -m 0644 -- .tmux-powerlinerc "$(HOME)"/.tmux-powerlinerc
		install -v -C -m 0644 -- .tmux.conf "$(HOME)"/.tmux.conf
		install -v -C -m 0644 -- .tmux-macosx "$(HOME)"/.tmux-macosx
		install -v -C -m 0644 -- .vimrc "$(HOME)"/.vimrc
		install -v -C -m 0644 -- .wgetrc "$(HOME)"/.wgetrc
		install -v -C -m 0644 -- .ackrc "$(HOME)"/.ackrc
