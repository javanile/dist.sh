# dist.sh

Create complex ZIP in a minute. With this tool you can create a ZIP file with custom structure.

## Installation

Download [dist.sh](https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh) file into your workstation



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
