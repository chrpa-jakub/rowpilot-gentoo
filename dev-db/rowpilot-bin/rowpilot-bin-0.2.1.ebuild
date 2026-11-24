# Copyright 2026 Rowpilot ebuild contributors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="AI-powered SQL editor for files and databases"
HOMEPAGE="https://rowpilot.com/"
SRC_URI="https://cdn.rowpilot.com/releases/Rowpilot-${PV}.AppImage"
S="${WORKDIR}/rowpilot"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
IUSE="suid"
RESTRICT="bindist mirror strip"

BDEPEND="app-arch/7zip"
RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	app-crypt/libsecret
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	media-libs/alsa-lib
	media-libs/mesa[gbm(+)]
	net-print/cups
	sys-apps/dbus
	>=sys-devel/gcc-12
	>=sys-libs/glibc-2.34
	virtual/libudev
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libnotify
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="*"

src_unpack() {
	mkdir -p "${S}" || die
	cd "${S}" || die
	# Extract without executing the downloaded runtime or mounting with FUSE.
	unpack_7z "${DISTDIR}/Rowpilot-${PV}.AppImage"
}

src_prepare() {
	default

	sed -i \
		-e 's/^Exec=.*/Exec=rowpilot %U/' \
		-e '/^X-AppImage-Version=/d' \
		com.rowpilot.desktop || die

	# The remaining prebuilds target other operating systems, CPUs, or musl.
	local prebuilds="resources/app.asar.unpacked/node_modules/better-sqlite3/prebuilds"
	find "${prebuilds}" -type f ! -name linux-x64.node -delete || die
	find resources/app.asar.unpacked/node_modules/@cbor-extract \
		-type f -name '*.musl.node' -delete || die

	# Namespace sandboxing is the default. The setuid helper is opt-in.
	if ! use suid; then
		rm chrome-sandbox || die
	fi
}

src_install() {
	domenu com.rowpilot.desktop
	local icon
	for icon in usr/share/icons/hicolor/*/apps/rowpilot.png; do
		local size=${icon#usr/share/icons/hicolor/}
		size=${size%%x*}
		doicon -s "${size}" "${icon}"
	done

	# Use system desktop libraries instead of the AppImage's legacy GTK2 libs.
	rm -r usr .DirIcon rowpilot.png AppRun com.rowpilot.desktop || die

	dodir /opt/rowpilot
	cp -a . "${ED}/opt/rowpilot/" || die
	dosym -r /opt/rowpilot/rowpilot /usr/bin/rowpilot

	if use suid; then
		fowners root:root /opt/rowpilot/chrome-sandbox
		fperms 4755 /opt/rowpilot/chrome-sandbox
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	einfo "Updates are managed by Portage; the AppImage auto-updater is inactive."
	if ! use suid; then
		einfo "Electron needs unprivileged user namespaces for sandboxing."
		einfo "If these are disabled, rebuild with USE=suid for the sandbox helper."
	fi
}
