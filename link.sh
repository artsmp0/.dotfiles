#!/bin/bash
# install.sh
dotfiles_dir="$HOME/.dotfiles"
files=".zshrc .gitconfig" # 添加其他文件

for file in $files; do
    ln "$dotfiles_dir/$file" "$HOME/$file"
done

ln "$dotfiles_dir/settings.json" "$HOME/Library/Application\ Support/Cursor/User/settings.json"
ln "$dotfiles_dir/keybindings.json" "$HOME/Library/Application\ Support/Cursor/User/keybindings.json"