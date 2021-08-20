# dist.sh

Create complex ZIP file in a minute. With this tool you can create a ZIP file with custom structure, useful to backup your data instead of manually picking stuff one by one, or good for distrubute your software avoiding to leave your private data into ZIP file.

## Installation

Quick installation
- Download [dist.sh](https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh) file into your workstation 
- Move to `/usr/local/bin/dist.sh` or wherever you prefer
- Set executable permission with `chmod +x /usr/local/bin/dist.sh`.

## Usage

Create in your workstation a file called `.distfile` like this

```
## File: .distfile
@mybackup.zip

+.ssh/*
+.config/*
!*.secret
```

Run the following command

```shell
dist.sh
```

With this simple instructions you create a ZIP file with all `.ssh/` and `.config/` directories but without all files `*.secret`.

## Documantation

The `.distfile` process instruction based on first char of line, all control char are listed here:

- `@` - Create ZIP file, you can create multiple ZIP file at same time
- `>` - Change root directory into ZIP file
- `+` - Add directory or file to ZIP file
- `!` - Exclude specific directory or file from ZIP file
- `&` - Execute a shell command
- `#` - Comment line

## Good to know 

Run without install

```bash
$ curl -sL git.io/dist.sh | bash -
```

Use into Makefile

```Makefile
dist:
     curl -sL git.io/dist.sh | bash -
```

### Package manager

BPKG

```shell
bpkg install -g javanile/dist.sh
```

BPKG/CI

```shell
curl -sL git.io/bpkg-install | curl -s javanile/dist.sh
```

Binst.tk

```shell
curl binst.tk | curl -s javanile/dist.sh
```

### Short url

```bash
curl -i "https://git.io" \
     -d "url=https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh" \
     -d "code=dist.sh"
```

### Contributing

Thank you for considering contributing to this project! The contribution guide can be found in the [CONTRIBUTING.md](CONTRIBUTING.md).

### Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](CONTRIBUTING.md).

### Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Francesco Bianco via [bianco@javanile.org](mailto:bianco@javanile.org). All security vulnerabilities will be promptly addressed.

### License

This project is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
