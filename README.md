Helper function to mount azure storage accounts.

# Dependencies
- [blobfuse2](https://github.com/Azure/azure-storage-fuse) (MS docs)
- dmenu (*optional* for interactive selection)

## Arch install
Availible in AUR.
```bash
yay -S azure-storage-fuse
```

# Usage

For help run with `-h`
```bash
./mount-blob.sh -h
```

## Pre-req
Create `.env` files containing credentials to specific endpoints.
These file(s) will be sourced in the bash script.

> `.env` files are included in `.gitignore`

### Service Principal example
```bash
# example-sp.env
export AZURE_STORAGE_AUTH_TYPE=SPN
export AZURE_STORAGE_SPN_CLIENT_ID=
export AZURE_STORAGE_SPN_TENANT_ID=
export AZURE_STORAGE_SPN_CLIENT_SECRET=

export AZURE_STORAGE_ACCOUNT=
export AZURE_STORAGE_ACCOUNT_TYPE="adls|block"
export AZURE_STORAGE_ACCOUNT_CONTAINER=
```

### Storage Account key example
```bash
# example-key.env
export AZURE_STORAGE_AUTH_TYPE=Key
export AZURE_STORAGE_ACCESS_KEY=

export AZURE_STORAGE_ACCOUNT=
export AZURE_STORAGE_ACCOUNT_TYPE="adls|block"
export AZURE_STORAGE_ACCOUNT_CONTAINER=
```

## Run Executable
Make sure you have `x` permission on `mount-blob.sh`
```bash
chmod u+x ./mount-blob.sh
```

> Run as `sudo`

```bash
sudo ./mount-blob.sh [ OPTIONS ] [ ARGS ]
```

# Good to know
If running the shell command with option to mount all containers in the storage
account, the container enviroment variable will be ignored.
