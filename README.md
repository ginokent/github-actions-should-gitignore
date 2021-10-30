# github-actions-should-gitignore

This GitHub Action checks that no files that should `gitignore` are committed.

## Example

```yml
name: 'should-gitignore'

on: [push]

jobs:
  should-gitignore:
    name: Should gitignore
    runs-on: ubuntu-latest
    permissions:
      contents: read
    steps:
      - uses: actions/checkout@v2
        with:
          ref: ${{ github.event.pull_request.head.sha }}
          fetch-depth: 0
      - uses: newtstat/github-actions-should-gitignore@v1.0.0
        #with:
        #  gitignores: '.gitignore'
```
