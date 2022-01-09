# GitHub Action: GoKart Security Static Analysis

[![Status](https://github.com/bryk-io/gokart-scan-action/actions/workflows/publish.yml/badge.svg)](https://github.com/bryk-io/gokart-scan-action/actions/workflows/publish.yml)
[![Version](https://img.shields.io/github/tag/bryk-io/gokart-scan-action.svg)](https://github.com/bryk-io/gokart-scan-action/releases)
[![Software License](https://img.shields.io/badge/license-BSD3-red.svg)](LICENSE)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-v2.0-ff69b4.svg)](.github/CODE_OF_CONDUCT.md)

GoKart is a static analysis tool for Go that finds vulnerabilities using the SSA (single
static assignment) form of Go source code. It is capable of tracing the source of variables
and function arguments to determine whether input sources are safe, which reduces the number
of false positives compared to other Go security scanners. For instance, a SQL query that is
concatenated with a variable might traditionally be flagged as SQL injection; however, GoKart
can figure out if the variable is actually a constant or constant equivalent, in which case
there is no vulnerability.

More information: [original project](https://github.com/praetorian-inc/gokart).

## Usage

### Inputs

- `globalsTainted`: Marks global variables as dangerous. Either "yes" or "no".
- `verbose`: Outputs full trace of taint analysis. Either "yes" or "no".
- `config`: Custom configuration file. (path relative to the root of your repository)

Sample step configuration.

```yaml
steps:
  - name: GoKart scan
    uses: bryk-io/gokart-scan-action@v0.3.0
    # example with all parameters
    with:
      globalsTainted: yes
      verbose: yes
      config: tools/gokart_analyzers.yml
```

> __Note:__ The path set on `config` is relative to the root of your repository.

### Code Scanning Integration

In order for GitHub to be able to parse and display the scan results make sure to
upload the SARIF results using the `github/codeql-action/upload-sarif` action.

> SARIF (Static Analysis Results Interchange Format) is an OASIS Standard that defines an
> output file format. The SARIF standard is used to streamline how static analysis tools share
> their results. Code scanning supports a subset of the SARIF 2.1.0 JSON schema.
>
> To upload a SARIF file from a third-party static code analysis engine, you'll need to ensure
> that uploaded files use the SARIF 2.1.0 version. GitHub will parse the SARIF file and show
> alerts using the results in your repository as a part of the code scanning experience.

```yaml
- name: Upload GoKart results
  uses: github/codeql-action/upload-sarif@v1
```

More information: [Code scan integration.](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/about-integration-with-code-scanning)

## Workflow

Sample workflow file.

```yaml
name: scan
on:
  # To manually run
  workflow_dispatch: {}
  # To automatically run for all commits on branch 'main'
  push:
    branches:
      - main
jobs:
  # GoKart scan
  scan:
    runs-on: ubuntu-latest
    timeout-minutes: 10
    steps:
      # Checkout code
      - name: Checkout repository
        uses: actions/checkout@v2

      # GoKart scan
      - name: GoKart scan
        uses: bryk-io/gokart-scan-action@v0.3.0
      
      # Upload scan results
      - name: Upload GoKart results
        uses: github/codeql-action/upload-sarif@v1
```

To manually trigger this workflow using GitHub's CLI tool.

```shell
gh workflow run scan
```
