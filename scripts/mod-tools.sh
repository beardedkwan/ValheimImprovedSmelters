
#!/usr/bin/env bash

# CONFIG

# Project repository path
MOD_REPO="$HOME/Projects/Valheim/ValheimImprovedSmelters"

# r2modman Development profile
R2_PROFILE="$HOME/.var/app/io.github.ebkr.r2modman/config/r2modmanPlus-local/Valheim/profiles/Development/"


# Build ImprovedSmelters
build() {
    (
        cd "$MOD_REPO" || exit 1

        msbuild ImprovedSmelters.sln \
            /p:Configuration=Debug \
            /v:minimal
    )
}

# Deploy the compiled DLL
deploy() {
    local dll="$MOD_REPO/ImprovedSmelters/bin/Debug/ImprovedSmelters.dll"
    local plugins="$R2_PROFILE/BepInEx/plugins"

    if [[ ! -f "$dll" ]]; then
        echo "Error: Compiled DLL not found."
        return 1
    fi

    if [[ ! -d "$plugins" ]]; then
        echo "Error: r2modman plugins directory not found."
        return 1
    fi

    install -Dm644 "$dll" \
        "$plugins/ImprovedSmelters-dev/ImprovedSmelters.dll" || return 1

    echo "ImprovedSmelters deployed successfully!"
}

# Build and deploy
test() {
    build && deploy
}

