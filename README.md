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
     -d "url=https://raw.githubusercontent.com/javanile/dist.sh/master/dist.sh" \
     -d "code=dist.sh"
```
