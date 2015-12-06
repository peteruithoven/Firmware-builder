# LaOS firmware builder
Docker build system for building mbed binaries

## Getting started

### Dependencies
Make sure you have the following dependencies installed.
- Git ([installation instructions](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git))
- Docker ([installation instructions](https://docs.docker.com/))

### Usage
Checkout this repository and use `make.sh`.
```bash
$ git clone https://github.com/peteruithoven/Firmware-builder.git
$ cd Firmware-builder
$ sh make.sh setup
$ sh make.sh build
```
Use `sh make.sh help` to view all available commands.

## Background
Instead of contaminating your machine with lots of build dependencies, which vary per operating system, we put the MBED cross compilation toolchain in a separated virtual machine using [Docker](http://docker.com/) ([Understanding docker](http://docs.docker.com/introduction/understanding-docker/)). 
One of the goals is to make it simple enough for non Docker or Linux experts to grasp and use. 
