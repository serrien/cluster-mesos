# cluster-mesos

# Installation

```bash
brew cask install chefdk
brew cask install vagrant
vagrant plugin install vagrant-cachier vagrant-omnibus vagrant-berkshelf
```

# Run

```bash
vagrant up
```
> Warning : you will be prompted to enter password for nfs use.
To prevent this privilege prompt password edit /etc/sudoers following
[the guidelines here](http://docs.vagrantup.com/v2/synced-folders/nfs.html)
