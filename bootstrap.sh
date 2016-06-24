# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.
function install {
    echo installing $1
    shift
    apt-get -y install "$@" >/dev/null 2>&1
}

install 'development tools' build-essential git curl vim
install 'rvm dependencies' libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
install 'ruby dependencies' ruby-dev make

echo install rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 >/dev/null 2>&1
curl -sSL https://get.rvm.io | bash -s stable >/dev/null 2>&1

echo install ruby
rvm use 2.3.1 --default --install >/dev/null 2>&1

gem install bundler --no-rdoc --no-ri

echo 'all set, rock on!'