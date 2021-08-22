---
layout: default
title: "📦 dist.sh"
nav_order: 1
has_children: false
---

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
