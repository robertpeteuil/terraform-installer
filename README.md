# Terraform Installer - Automated Terraform Installation

## Automatically Download, Extract and Install Latest or Specific Version

---

The **terraform-installer** script automates process of downloading and installing terraform.  It provides a quick method for installation on hew hosts and installing updates.  It installs the latest version unless a specific version is specified.

The script delivers substantial time savings over the official method which requires manually downloading, extracting and installing the binary (even for updates).

### Current Manual Installation Process

- visit website, find version for OS/CPU and download
- find and extract downloaded zip file
- copy 'terraform' binary to location on PATH

### REQUIREMENTS

- System with Bash Shell (Linux, macOS, Windows Subsystem for Linux)
- `curl`
- `unzip` - the downloads from hashicorp.io are in zip format

### Script Process

- Determines Version to Download and Install
  - Uses Version specified by `-i VERSION` parameter (if specified)
  - Otherwise determines Latest Version
    - Uses GitHub API to retrieve latest version number
- Calculates Download URL based on Version, OS and CPU-Architecture
- Verifies URL Validity before Downloading in Case:
  - VERSION incorrectly specified with `-i`
  - Download URL Format Changed on Hashicorp Website
- Determines Installation Destination
  - Performed before Download/Install Process in case User selects `abort`
- Installation Process
  - Download, Extract, Install, Cleanup and Display Results

#### CPU ARCHITECTURE DETECTION

CPU architecture is detected for each OS accordingly:

- Linux / Windows (WSL since this is a Bash script) - detected with dpkg
- macOS - uses Default - only terraform CPU Arch available on macOS is `AMD64`
- Default Value - `AMD64`

### LICENSE

MIT License - Copyright (c) 2018  Robert Peteuil  @RobertPeteuil
