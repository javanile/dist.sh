# dist.sh

```bash
$ curl -sL git.io/dist.sh | bash -
```

```Makefile
dist:
     curl -sL git.io/dist.sh | bash -
```

### Short url

```bash
curl -i "https://git.io" \
     -F "url=https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh" \
     -F "code=dist.sh"
```
