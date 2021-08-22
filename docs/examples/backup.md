---
layout: default
title: Backup
parent: Examples
nav_order: 10
has_children: false
---

# Backup

Here is a list of scenarios in which it is possible to create backups in a smart way

## Backup Linux Home

To back up your current linux home create a `.distfile` as follows

```shell
## File: /home/samsepiol/.distfile
@backup-${USER}-${NOW}.zip

.ssh
.config
.bashrc
!*.secret
```

Then run

```shell
cd ${HOME} && dist.sh
```

## Backup System Logs

To back up all logs of your machine

```shell
## File: /var/log/.distfile
@logs-${NOW}.zip

*.log
```

Then run

```shell
cd /var/log && dist.sh
```
