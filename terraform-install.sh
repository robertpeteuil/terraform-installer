#!/usr/bin/env bash

# TERRAFORM INSTALLER - Automated Terraform Installation
#   MIT License - Copyright (c) 2018  Robert Peteuil  @RobertPeteuil
#
#     Automatically Download, Extract and Install
#        Latest (or Specific) Version of Terraform
#
#   from: https://github.com/robertpeteuil/terraform-installer


scriptname=$(basename "$0")

usage() {
  echo -e "Tarraform Installer - install latest (or specified) version\n"
  echo -e "usage: ${scriptname} [-i VERSION] [-h]\n"
  echo -e "     -i VERSION\t: specify version to be installed in format '0.11.1' (OPTIONAL)"
  echo -e "     -h\t\t: display help"
}

if ! unzip -h 2&> /dev/null; then
  echo "aborting - unzip not installed and required for installation"
  exit 1
fi

while getopts ":i:h" arg; do
  case "${arg}" in
    i)  VERSION=${OPTARG};;
    h)  usage; exit;;
    \?) echo -e "Error - Invalid option: $OPTARG\n"; usage; exit;;
    :)  echo "Error - $OPTARG requires an argument"; echo; usage; exit 1;;
  esac
done
shift $((OPTIND-1))

# POPULATE VARIABLES NEEDED TO CREATE DOWNLOAD URL AND FILENAME
if [[ -z "$VERSION" ]]; then
  VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | awk '/tag_name/ {b = gensub(/("|,|v)/, "", "g", $2); print b}')
fi
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
  linux)
    PROC=$(dpkg --print-architecture);;
  *)
    PROC="amd64";;
esac

# CREATE FILENAME AND DOWNLOAD LINK BASED ON GATHERED PARAMETERS
FILENAME="terraform_${VERSION}_${OS}_${PROC}.zip"
LINK="https://releases.hashicorp.com/terraform/${VERSION}/${FILENAME}"
LINKVALID=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' "$LINK")

# VERIFY LINK VALIDITY
if [[ "$LINKVALID" != 200 ]]; then
  echo -e "Cannot Install - Download URL Invalid"
  echo -e "\n   Parameters:"
  echo -e "\tVER:\t$VERSION"
  echo -e "\tOS:\t$OS"
  echo -e "\tPROC:\t$PROC"
  echo -e "\tURL:\t$LINK"
  exit 1
fi

# DETERMINE DESTINATION
if [[ -w "/usr/local/bin" ]]; then
  BINDIR="/usr/local/bin"
  CMDPREFIX=""
  STREAMLINED=true
else
  echo -e "Tarraform Installer\n"
  echo "Specify install directory (a,b or c):"
  echo -en "\t(a) '~/bin'    (b) '/usr/local/bin' as root    (c) abort : "
  read -r -n 1 SELECTION
  echo
  if [ "${SELECTION}" == "a" ] || [ "${SELECTION}" == "A" ]; then
    BINDIR="${HOME}/bin"
    CMDPREFIX=""
  elif [ "${SELECTION}" == "b" ] || [ "${SELECTION}" == "B" ]; then
    BINDIR="/usr/local/bin"
    CMDPREFIX="sudo "
  else
    exit 0
  fi
fi

# CREATE TMPDIR FOR EXTRACTION
TMPDIR=${TMPDIR:-/tmp}
UTILTMPDIR="terraform_${VERSION}"

cd "$TMPDIR" || exit 1
mkdir -p "$UTILTMPDIR"
cd "$UTILTMPDIR" || exit 1

# DOWNLOAD AND EXTRACT
curl -s -o "$FILENAME" "$LINK"
unzip -qq "$FILENAME" || exit 1

# COPY TO DESTINATION
mkdir -p "${BINDIR}" || exit 1
${CMDPREFIX} cp -f terraform "$BINDIR" || exit 1

# CLEANUP AND EXIT
cd "${TMPDIR}" || exit 1
rm -rf "${UTILTMPDIR}"
[[ ! "$STREAMLINED" ]] && echo
echo "Tarraform Version ${VERSION} installed to ${BINDIR}"

exit 0
