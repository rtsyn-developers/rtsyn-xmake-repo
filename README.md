# RTSyn Xmake repository

This repo contains the references to all **RTSyn** repos manage all the dependencies of **RTSyn**.

## Usage

After [installing xmake](https://xmake.io/guide/quick-start.html) and creating your project. You have two main options:

### Command

Inside the base directory of your xmake project you can run:

```bash
xmake repo --add rtsyn-xmake-repo \
    https://github.com/rtsyn-developers/rtsyn-xmake-repo.git
```

This option will need to be done every time the repo is cloned, so a the following option is better.

### Xmake file

Near the top of the `xmake.lua` file:

```lua
add_repositories("rtsyn-xmake-repo https://github.com/rtsyn-developers/rtsyn-xmake-repo.git")
```

To ensure it is correclty added:

```bash
xmake repo --list
```

### Example

For adding a dependency, add it in you `xmake.lua`:

```lua
add_requires("rtsyn-plugin")
...
    -- Target/Library set up
    add_packages("rtsyn-plugin")
```

For more information check [xmake package dependencies](https://xmake.io/api/description/package-dependencies.html).
