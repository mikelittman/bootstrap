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
                cd "$dir"
                brew bundle
                cd -
            fi
        done
    else
        echo "No brewfiles directory found."
    fi
fi
