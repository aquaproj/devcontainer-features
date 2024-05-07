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
    elif has_command apk > /dev/null 2>&1; then
        apk add curl
    else
        log_error "Neither curl nor wget is found. Please install either curl or wget to download aqua"
        exit 1
    fi
fi

pwd
ls

url=https://raw.githubusercontent.com/aquaproj/aqua-installer/v3.0.0/aqua-installer

tempdir=$(mktemp -d)
cd "$tempdir"

if has_command curl; then
    curl -sSfL -O "$url"
elif has_command wget; then
    wget "$url"
fi

echo "8299de6c19a8ff6b2cc6ac69669cf9e12a96cece385658310aea4f4646a5496d  aqua-installer" | sha256sum -c

chmod +x aqua-installer
./aqua-installer

rm -R "$tempdir"
