---
layout: default
title: Release
parent: Examples
nav_order: 2
has_children: false
---

# Release

Create a software release is an important stage on development process, this tool help you to create an elegant and simple manifest to recreate your package on the fly. This is useful to save your artifact at the end of CI/CD process.

> _TIP: Often a Software Release unlike a Software Package could contain some dependencies already downloaded and distributed together with the sources so that the product is ready to use._

## Create Laravel Release

In this example the `vendor/` directory is included into release

```shell
## File: .distfile
&export VERSION=1.0.0
@MyLaravelProject-${VERSION}.zip

app
storage
vendor
!*.log
```

## Create Next.js Release

A Next.js release is useful for cheap FTP hosting

```shell
## File: .distfile
&export VERSION=1.0.0
@MyNexJsProject-${VERSION}.zip

public
!pages
!styles
!node_modules
!*.log
```

Then run

```shell
dist.sh
```
