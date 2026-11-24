# Unofficial Gentoo packaging for Rowpilot

Gentoo overlay providing `dev-db/rowpilot-bin-0.2.1` for amd64 with glibc.
Rowpilot is developed by Michal Novotny; see the [upstream website](https://rowpilot.com/).
Chrpa Jakub maintains this independent Gentoo overlay. This is an unofficial
packaging release, unaffiliated with Rowpilot's author or the Gentoo project.

## Install

Install the repository manager, register this overlay, and sync it:

```sh
sudo emerge --ask app-eselect/eselect-repository dev-vcs/git
sudo eselect repository add rowpilot-local git https://github.com/chrpa-jakub/rowpilot-gentoo.git
sudo emaint sync -r rowpilot-local
```

If an earlier local copy is already registered as `rowpilot-local`, replace that
repository's existing configuration with the Git registration before syncing.

Accept the testing keyword and proprietary license for this package only. Review
[Rowpilot's terms](https://rowpilot.com/terms) before accepting the license.
These commands assume Portage's per-package configuration paths are directories;
if yours are single files, append the corresponding lines to those files instead.

```sh
sudo mkdir -p /etc/portage/package.accept_keywords /etc/portage/package.license
printf '%s\n' 'dev-db/rowpilot-bin ~amd64' | sudo tee /etc/portage/package.accept_keywords/rowpilot
printf '%s\n' 'dev-db/rowpilot-bin all-rights-reserved' | sudo tee /etc/portage/package.license/rowpilot
sudo emerge --ask dev-db/rowpilot-bin
```

The ebuild downloads the versioned AppImage automatically. To reuse an existing,
verified download instead, copy it into the configured `DISTDIR` (normally
`/var/cache/distfiles`) under the versioned name before running `emerge`:

```sh
sudo cp /path/to/rowpilot-linux-x64.AppImage /var/cache/distfiles/Rowpilot-0.2.1.AppImage
```

Launch `rowpilot` from a terminal or Rowpilot from the application menu. Remove it
with `sudo emerge --ask --unmerge dev-db/rowpilot-bin`.

## Updates

When a newer ebuild is published, sync the overlay and update the package:

```sh
sudo emaint sync -r rowpilot-local
sudo emerge --ask --update dev-db/rowpilot-bin
```

## Install from a local checkout

To use a downloaded source release or local clone, create a file in
`/etc/portage/repos.conf/` containing the following, replacing the example path
with the absolute path to the unpacked overlay:

```ini
[rowpilot-local]
location = /absolute/path/to/rowpilot-gentoo
masters = gentoo
auto-sync = no
```

Then follow the keyword, license, and emerge steps above. A local checkout does
not fetch repository updates automatically.

## Packaging details

- Installs the application under `/opt/rowpilot`, a `/usr/bin/rowpilot` command,
  desktop entry, URL handler, and icons.
- Extracts with 7-Zip during the build; neither FUSE nor executing the AppImage
  runtime is required.
- Uses system GTK and desktop libraries and removes foreign-platform native
  addons. Bundled amd64 addons need glibc 2.34 or newer and GCC 12's libstdc++
  runtime or newer.
- Preserves the bundled third-party notices. Redistribution and mirroring are
  restricted because Rowpilot is proprietary.
- Uses Portage for updates. As in the upstream installer's `--extract` mode,
  in-app AppImage updates are inactive.
- Keeps Electron sandboxing enabled. The default requires unprivileged user
  namespaces. For systems where those are disabled, enable the optional `suid`
  USE flag to install the upstream sandbox helper with mode 4755:

  ```sh
  sudo mkdir -p /etc/portage/package.use
  printf '%s\n' 'dev-db/rowpilot-bin suid' | sudo tee /etc/portage/package.use/rowpilot
  sudo emerge --ask --newuse dev-db/rowpilot-bin
  ```

## Upstream references

- [Downloads](https://rowpilot.com/download)
- [Installer script](https://rowpilot.com/install.sh)
- [Linux release metadata](https://cdn.rowpilot.com/releases/latest-linux.yml)
- [Versioned AppImage](https://cdn.rowpilot.com/releases/Rowpilot-0.2.1.AppImage)

The Manifest's SHA512 matches the release metadata. The existing local AppImage
also matches upstream's published SHA256:

```text
97fb55cbaf7f962a2b4dc42af3163804a714322e6e31b20c139ee5a3b58018a7
```

## Validation

Validated on the local Gentoo amd64 system:

- Portage Manifest verification and unpack, prepare, configure, compile, and
  install phases completed into a temporary staging directory.
- Portage resolved the package's dependencies against the installed system.
- Desktop entry and metadata XML validation passed.
- All 11 installed ELF files resolved their shared libraries.
- Electron loaded the keytar, SQLite, and CBOR native addons.
- The application and backend started under Xvfb with sandboxing enabled and
  stayed running during a 12-second startup check. The temporary display lacked
  desktop portal integration, and the restricted environment reported an NSS
  database error; database connections and interactive workflows were not tested.

The optional setuid-helper installation was not tested with root privileges.

## License and provenance

The packaging is distributed under GPL-2.0-only; see [LICENSE](LICENSE). Rowpilot
itself remains subject to its upstream proprietary terms. Release archives
contain packaging files only; the application is fetched from upstream by
Portage.

This packaging was prepared with AI assistance and is maintained as an
independent overlay.

## Publishing packaging releases

Update the versioned ebuild, Manifest, and release notes, validate the package,
then push the changes and an annotated version tag such as `v0.2.1`. The release
workflow builds an overlay archive and SHA256 checksum from that tag and publishes
them as a GitHub release. It publishes packaging files only.
