# github-actions-should-gitignore

This GitHub Action checks that no files that should `gitignore` are committed.

By default, `.DS_Store` and `Thumbs.db` and the files listed in .gitignore in the repository root are detected.

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
      - uses: newtstat/github-actions-should-gitignore@v1.0.2
        #with:
        #  gitignores: 'path/to/.gitignore path/to/2/.gitignore'
```
