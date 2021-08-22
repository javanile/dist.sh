---
layout: default
title: "📦 dist.sh"
nav_order: 1
has_children: false
---

# Get Started

Create complex ZIP file in a minute. With this tool you can create a ZIP file with custom structure, useful to distribute your software instead of manually picking stuff one by one, or good for back up your data avoid to leaving your private data into ZIP file.

## Why use dist.sh

Having total control over what goes into your releases is very important for the following reasons

- It prevents secret or important files from being released unintentionally
- Avoid releasing large files or files that are not useful for distribution with the consequence of unnecessarily increasing the size of the package
- Having the ability to modify files before they are included in the release, for example by applying an encryption or a watermark
- Reduce the attack surface by improving security especially by applying a meticulous and granular selections of what is to be excluded from the release
- Possibility to repeat the process of creating the release indefinitely, always having the expected result

## Installation

Quick installation

- Download [dist.sh](https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh) file into your workstation 
- Move to `/usr/local/bin/dist.sh` or wherever you prefer
- Set executable permission with `chmod +x /usr/local/bin/dist.sh`.

## Usage

Create a file called `.distfile` like this

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

## Documentation

The `.distfile` works with instructions based on first char of line, this first char is called **Control Char**. All control chars are listed here:

- `@` - Create ZIP file, you can create multiple ZIP file at same time
- `>` - Change root directory into ZIP file
- `+` - Add directory or file to ZIP file
- `!` - Exclude specific directory or file from ZIP file
- `&` - Execute a shell command
- `#` - Comment line
