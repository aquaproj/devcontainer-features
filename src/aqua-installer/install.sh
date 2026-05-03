set -eu

log_error() {
	echo "[ERROR] $1" >&2
}

if [ -z "${AQUA_VERSION:-}" ]; then
	log_error "AQUA_VERSION is required"
	exit 1
fi

has_command() {
	local cmd=$1
	command -v $cmd > /dev/null 2>&1
}

if ! has_command bash; then
	if has_command apt-get; then
		apt-get update -y
		apt-get install -y bash
	elif has_command apk > /dev/null 2>&1; then
		apk add bash
	else
		log_error "bash isn't found. Please install bash to run aqua-installer"
		exit 1
	fi
fi

if ! has_command curl && ! has_command wget; then
	if has_command apt-get; then
		apt-get update -y
		apt-get install -y curl
	elif has_command apk; then
		apk add curl
	else
		log_error "Neither curl nor wget is found. Please install either curl or wget to download aqua"
		exit 1
	fi
fi

if [ "$_REMOTE_USER" = root ]; then
	tempdir=$(mktemp -d)
else
	tempdir=$(sudo -u "$_REMOTE_USER" mktemp -d)
fi
cd "$tempdir"

url=https://raw.githubusercontent.com/aquaproj/aqua-installer/v4.0.4/aqua-installer

if has_command curl; then
	curl --retry 5 -sSfL -O "$url"
elif has_command wget; then
	wget "$url"
fi

echo "acd21cbb06609dd9a701b0032ba4c21fa37b0e3b5cc4c9d721cc02f25ea33a28  aqua-installer" | sha256sum -c -

chmod a+x aqua-installer
if [ "$_REMOTE_USER" = root ]; then
	./aqua-installer -v "$AQUA_VERSION"
else
	if ! has_command sudo; then
		if has_command apt-get; then
			apt-get update -y
			apt-get install -y sudo
		elif has_command apk; then
			apk add sudo
		else
			log_error "Please install sudo to run aqua-installer as $_REMOTE_USER"
			exit 1
		fi
	fi
	sudo -u "$_REMOTE_USER" ./aqua-installer -v "$AQUA_VERSION"
fi

rm -R "$tempdir"
