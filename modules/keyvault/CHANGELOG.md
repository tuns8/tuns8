# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Use the first example below as a template for future releases:

## [x.y.z] - yyyy-mm-dd

### Added/Changed/Fixed

- Added foo
- Changed bar
- Fixed baz

## [2.3.0] - 2023-01-10

- Removed vars for ACL

## [2.2.1] - 2023-01-10

- Added a TFsec ignore comment to ignore the requirement of having an ACL for the Key Vault

## [2.2.0] - 2022-11-03

- Added the changes for tfsec warnings.

## [2.1.0] - 2022-11-01

- Added the `soft_delete_retention_days` attribute in `azurerm_key_vault.main` to conform with TFSec test [azure-keyvault-no-purge](https://aquasecurity.github.io/tfsec/v0.63.1/checks/azure/keyvault/no-purge/)
- Incresed the version constraint of the module and accompanying test from `>= 2.0` and `~> 2.34.0` respectively to `>= 2.42.0` to maintain compatibility the the changes above.

## [2.0.0] - 2021-07-26

### BREAKING CHANGES

- Upgraded syntax for terraform `v0.13`, removed provider block.

## 1.1.0 (March 01, 2021)

Added test folder for Gitlab test pipeline, added .gitignore

## 1.0.0 (October 28, 2020)