## This repository is meant to help people setup [lrsjng/h5ai](https://github.com/lrsjng/h5ai) easier

 * **All the scripts in this repository is written for Unix/Linux ONLY**

## Setup

 * setup system firewall to allow http/https traffic before running any scripts
 * simply choose a setup script for your distribution and run it as root
 * Example:
```sh
    $ curl -s https://raw.githubusercontent.com/Gavin1937/setup-h5ai/master/debian_ubuntu_setup.sh | sudo bash /dev/stdin
```
 * Script Arguments
```sh
    default, no argument input:
        clone original repository and build it
    
    setup.sh -o:
        clone original repository and build it
    
    setup.sh -g:
        download an *.zip file from ./ReleaseBuild/ and unzip
```

## Repository File Structure Explanation

 * ./h5ai/ submodule of original repository [lrsjng/h5ai](https://github.com/lrsjng/h5ai)
 * ./ReleaseBuild/ *.zip files of h5ai release builds download from [https://release.larsjung.de/h5ai/](https://release.larsjung.de/h5ai/)
 * ./*setup.sh setup bash scripts
