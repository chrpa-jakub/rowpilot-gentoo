# Unofficial Gentoo packaging for Rowpilot

Unofficial Gentoo overlay for [Rowpilot](https://rowpilot.com/), for amd64 with glibc.

## Install

```sh
sudo emerge --ask app-eselect/eselect-repository dev-vcs/git
sudo eselect repository add rowpilot-local git https://github.com/chrpa-jakub/rowpilot-gentoo.git
sudo emaint sync -r rowpilot-local
```

Accept the testing keyword and [upstream license terms](https://rowpilot.com/terms).
If your Portage configuration paths are files rather than directories, append
the corresponding lines to those files instead.

```sh
sudo mkdir -p /etc/portage/package.accept_keywords /etc/portage/package.license
printf '%s\n' 'dev-db/rowpilot-bin ~amd64' | sudo tee /etc/portage/package.accept_keywords/rowpilot
printf '%s\n' 'dev-db/rowpilot-bin all-rights-reserved' | sudo tee /etc/portage/package.license/rowpilot
sudo emerge --ask dev-db/rowpilot-bin
```

Launch `rowpilot` from a terminal or your application menu.
