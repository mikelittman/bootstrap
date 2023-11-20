#!/usr/bin/env bash

if ! xcode-select -p >/dev/null; then
    echo "Xcode developer tools not found. Installing..."
    xcode-select --install
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh not found. Installing..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! git config --get user.name >/dev/null; then
    echo "Git user.name not set."
    read -p "Enter your name: " name
    git config --global user.name "$name"
fi

if ! git config --get user.email >/dev/null; then
    echo "Git user.email not set."
    read -p "Enter your email: " email
    git config --global user.email "$email"
fi


read -p "Would you like to run 'brew bundle'? (Y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$|^$ ]]; then
    BREWFILES_DIR="./brewfiles"
    if [ -d "$BREWFILES_DIR" ]; then
        for dir in "$BREWFILES_DIR"/*/; do
            dir=${dir%*/}
            read -p "Would you like to install packages in $dir? (Y/n) " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$|^$ ]]; then
                cd "$dir" || exit
                brew bundle
                cd - || exit
            fi
        done
    else
        echo "No brewfiles directory found."
    fi
fi

# Array of known shell rc files
rcfiles=(
  ".bashrc"
  ".zshrc"
  ".config/fish/config.fish"
  ".dashrc"
  ".tcshrc"
)

# Check if 'fzf' is in PATH
if ! command -v fzf &>/dev/null; then
    echo "fzf is not installed or not available in PATH"
    echo "Run the bundler script option or install fzf manually"
else
    # Check each rc file for 'fzf' configuration
    for rcfile in "${rcfiles[@]}"; do
        full_rcfile="$HOME/$rcfile"
        if [ -f "$full_rcfile" ]; then
            if grep -q "fzf" "$full_rcfile"; then
                FZF_INSTALL=true
                break
            fi
        fi
    done

    if [ -n "${FZF_INSTALL+x}" ]; then
        echo "fzf is configured. pass FZF_INSTALL-true to run fzf install script"
    else
        echo "fzf configuration was not found."
        "$(brew --prefix)"/opt/fzf/install
    fi
fi

PROJECT_ROOT=$(dirname "$(realpath "$0")")
if ! grep -qxF "export PATH=\"\$PATH:$PROJECT_ROOT/scripts\"" ~/.bashrc; then
    echo "Adding ./scripts to PATH (bash)"
    echo "# ADDED BY BOOTSTRAP SCRIPT" >> ~/.bashrc
    echo "export PATH=\"\$PATH:$PROJECT_ROOT/scripts\"" >> ~/.bashrc
else
    echo "./scripts is already in PATH (bash)"
fi
if ! grep -qxF "export PATH=\"\$PATH:$PROJECT_ROOT/scripts\"" ~/.zshrc; then
    echo "Adding ./scripts to PATH (zsh)"
    echo "# ADDED BY BOOTSTRAP SCRIPT" >> ~/.zshrc
    echo "export PATH=\"\$PATH:$PROJECT_ROOT/scripts\"" >> ~/.zshrc
else
    echo "./scripts is already in PATH (zsh)"
fi


            
echo "   _______________________    "
echo "  |                  - (  |   "
echo " ,'-.                 . \`-|   "
echo "(____\".       ,-.    '   ||   "
echo "  |          /\,-\   ,-.  |   "
echo "  |      ,-./     \ /'.-\ |   "
echo "  |     /-.,\      /     \|   "
echo "  |    /     \    ,-.     \   "
echo "  |___/_______\__/___\_____\  "
echo "                              "
echo "⛰️🍾 All setup!"