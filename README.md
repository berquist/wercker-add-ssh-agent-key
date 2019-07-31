# add-ssh-agent-key step

A step to add an SSH key from an environment variable to the SSH agent. This step is useful if you use multiple SSH keys and/or keys with passphrases.

## Options

* `key` (required) Environment variable name that contains the SSH key
* `passphrase` (optional) Environment variable name that contains the passphrase to unlock the private SSH key. Do NOT put your actual passphrase here directly.

## Requirements

* openssh-client (`ssh-add`, `ssh-agent`)
* expect

## Example

``` yaml
build:
  steps:
    - cloudstek/add-ssh-agent-key:
      key: MY_KEY_PRIVATE
      passphrase: MY_KEY_PASS
```

## License

The MIT License (MIT)

## Changelog

### 1.0.1

* Fix passphrase handling
* Fix ssh-agent environment variables

### 1.0.0

* Initial release
