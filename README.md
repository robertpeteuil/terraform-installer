# Terraform Installer - Automated Terraform Installation

## Automatically Download, Extract and Install Latest or Specific Version

[![GitHub release](https://img.shields.io/github/release/robertpeteuil/terraform-installer.svg?colorB=2067b8)](https://github.com/robertpeteuil/terraform-installer)
[![lang](https://img.shields.io/badge/language-bash-89e051.svg?style=flat-square)](https://github.com/robertpeteuil/terraform-installer)
[![license](https://img.shields.io/github/license/robertpeteuil/terraform-installer.svg?colorB=2067b8)](https://github.com/robertpeteuil/terraform-installer)

---

The **terraform-installer** script automates process of downloading and installing terraform using bash.  It provides a quick method for installation on hew hosts,  installing updates and downgrading if necessary.  By default, the latest version is installed.  A specific version can be installed by using the parameter `-i`.

The automates the official method which requires manually downloading, extracting and installing the binary (even for updates).

### Official Installation Process

- visit website download page
- locate version for OS/CPU and download
- find and extract binary from downloaded zip file
- copy binary to location on PATH

### Installation with this Installer

- Download the installer from this repo
- Run the script
- Keep the installer on the machine for installing updates

``` shell
curl -fsSL https://raw.github.com/robertpeteuil/terraform-installer/master/terraform-install.sh -o terraform-install.sh; chmod +x terraform-install.sh
./terraform-install.sh

# Alternatively a specific version can be installed using -i
./terraform-install.sh -i 0.11.1
```

### System Requirements

- System with Bash Shell (Linux, macOS, Windows Subsystem for Linux)
- `curl`
- `unzip` - downloads from terraform.io are in zip format

### Script Process Details

- Determines Version to Download and Install
  - Uses Version specified by `-i VERSION` parameter (if specified)
  - Otherwise determines Latest Version
    - Uses GitHub API to retrieve latest version number
- Calculates Download URL based on Version, OS and CPU-Architecture
- Verifies URL Validity before Downloading in Case:
  - VERSION incorrectly specified with `-i`
  - Download URL Format Changed on terraform Website
- Determines Installation Destination
  - Performed before Download/Install Process in case User selects `abort`
- Installation Process
  - Download, Extract, Install, Cleanup and Display Results

#### CPU Architecture Detection

CPU architecture is detected for each OS accordingly:

- Linux / Windows (WSL since this is a Bash script) - detected with dpkg
- macOS - uses Default - only terraform CPU Arch available on macOS is `AMD64`
- Default Value - `AMD64`

### License

MIT License - Copyright (c) 2018  Robert Peteuil  @RobertPeteuil
