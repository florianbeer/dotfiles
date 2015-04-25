all: install

install:
		cp .bash_profile ../
		cp .gitconfig ../
		cp .gitignore ../
		cp -rf .tmux-powerline ../
		cp .tmux-powerlinerc ../
		cp .tmux.conf ../
		cp .tmux-macosx ../
		cp -rf .vim ../
		cp .vimrc ../
