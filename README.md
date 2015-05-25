# cluster-mesos

# Installation

```bash
brew cask install chefdk
brew cask install vagrant
vagrant plugin install vagrant-cachier vagrant-omnibus vagrant-triggers vagrant-berkshelf
```

vagrant-berkshelf and chefdk are optional.

# Run

```bash
vagrant up
```
> Warning : you will be prompted to enter password for nfs use.
To prevent this privilege prompt password edit /etc/sudoers following
[the guidelines here](http://docs.vagrantup.com/v2/synced-folders/nfs.html)

# Sample apps

In order to build sample apps

```bash
vagrant ssh consul
cd /vagrant
sh buildAndInstallAllContainer.sh
```

Sample apps are now in private registry on consul node.