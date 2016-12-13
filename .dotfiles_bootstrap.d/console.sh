#!exec sh

PACKAGES="vcsh mr zsh ranger ispell lynx vim"

echo "echo === Changing default shell to zsh ===" >> $RESULT_SCRIPT_FILE
echo "sudo chsh `whoami` `which zsh`" >> $RESULT_SCRIPT_FILE

while true; do
    read -p "Do you wish to install console version of emacs? " yn
    case $yn in
        [Yy]* ) PACKAGES="$PACKAGES emacs24-nox"; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

echo $PACKAGES > $RESULT_PACKAGES_FILE
