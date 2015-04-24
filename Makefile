all: install

install:
		cp .bash_profile ../
		cp .gitconfig ../
		cp .gitignore ../
		mkdir -p ~/bin
		cp -rf tmux-powerline ../bin/.
		cp -rf .tmux-poweline ../
		cp .tmux-powerlinerc ../
		cp .tmux.conf ../
		cp -rf .vim ../
		cp .vimrc ../

update:
		cp ~/.bash_profile .
		cp ~/.gitconfig .
		cp ~/.gitignore .
		cp -rf ~/.tmux-powerline .
		cp ~/.tmux-powerlinerc .
		cp ~/.tmux.conf .
		cp -rf ~/.vim .
		cp ~/.vimrc .
