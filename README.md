# Godot Addon Submodule Scripts
Some scripts for managing Godot addons as git submodules

## create-godot-addon-submodule.sh

Params:
1. "branch" or "tag"
2. name of branch or tag
3. git url

### Example
```
create-godot-addon-submodule.sh tag v7.3.0 gut
```

## add-godot-addon-submodule.sh

Params:
1. name of the folder to place the submodule in (i.e addons/<name>)
2. git url

### Example
```
add-godot-addon-submodule.sh gut git@github.com:you-win/Gut.git
```

## remove-godot-addon-submodule.sh

Params:
1. submodule path from project root

### Example
```
remove-godot-addon-submodule.sh addons/gut/
```

