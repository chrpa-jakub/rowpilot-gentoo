# Unofficial Rowpilot Gentoo packaging 0.2.1

Initial independent Gentoo overlay release for Rowpilot 0.2.1 on amd64/glibc.
Rowpilot is developed by Michal Novotny. Chrpa Jakub maintains this packaging
independently of the upstream application.

- Versioned upstream download, verified by the Portage Manifest.
- Extraction during the build without FUSE or executing the AppImage runtime.
- Application command, desktop menu entry, URL handler, and icons.
- System desktop libraries and cleanup of foreign-platform native addons.
- Electron namespace sandboxing by default, with an optional `suid` helper.
- Portage-managed updates.

See the [installation guide](https://github.com/chrpa-jakub/rowpilot-gentoo/blob/v0.2.1/README.md) for repository registration, license acceptance, and
installation instructions. The package atom is `dev-db/rowpilot-bin`.

## Release assets

- `rowpilot-gentoo-0.2.1.tar.gz`: the complete overlay source at tag `v0.2.1`.
- `SHA256SUMS`: SHA256 checksum for the overlay archive.

The proprietary application binary is downloaded from upstream during emerge;
it is not included in these release assets.

## Validation and limitations

Portage's Manifest verification and unpack through install phases passed in a
temporary staging directory. Dependency resolution, desktop entry and XML
validation, shared-library resolution, and native addon loading passed. The app
and backend stayed running during a 12-second sandboxed Xvfb startup check.

Interactive database connections and the optional setuid-helper installation
were not tested. The restricted startup environment reported desktop portal and
NSS database errors; see the README for details.
