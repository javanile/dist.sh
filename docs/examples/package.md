---
layout: default
title: Package
parent: Examples
nav_order: 3
has_children: false
---

# Package

Create a Software Package is an important stage on development process, this tool help you to create an elegant and simple manifest to recreate your package on the fly. This is useful to save your artifact at the end of CI/CD process. 

```
TIP: Often the Software Package must be as lean as possible in fact it should not include any pre-installed software dependencies, which will therefore be downloaded when needed.
```

## Create Laravel Package

In this example the `vendor/` directory is ignored

```shell
## File: .distfile
&export VERSION=1.0.0
@MyLaravelProject-${VERSION}.zip

app
storage
!vendor
!*.log
```

Then run

```shell
dist.sh
```

## Create Next.js Package

A Next.js package could be use as skeleton project 

```shell
## File: .distfile
&export VERSION=1.0.0
@MyNexJsProject-${VERSION}.zip

pages
public
styles
!node_modules
!*.log
```

Then run

```shell
dist.sh
```
