# Publishing to @next Tag

This document explains how to publish packages to the `@next` NPM tag for development and testing purposes.

## Overview

The repository now supports publishing packages under the `@next` tag instead of the default `latest` tag. This is useful for:
- Development branch releases
- Feature preview releases  
- Testing changes before stable release

## Configuration Changes

### Package.json Scripts

Added new scripts to support @next tag publishing:

```json
{
  "scripts": {
    "release:next": "changeset publish --tag next",
    "version:snapshot": "changeset version --snapshot next", 
    "release:snapshot": "changeset publish --tag next"
  }
}
```

### Changeset Configuration

Updated `.changeset/config.json` to support snapshot releases:

```json
{
  "snapshot": {
    "useCalculatedVersion": true,
    "prereleaseTemplate": "{tag}-{datetime}"
  }
}
```

### GitHub Workflow

Added `.github/workflows/release-next.yml` that automatically publishes to @next tag for development branches:
- `copilot/**`
- `feature/**` 
- `dev/**`
- `next/**`

## Usage

### Manual Release to @next Tag

1. Create and add changesets as normal:
   ```bash
   npm run changeset
   ```

2. Create snapshot version:
   ```bash
   npm run version:snapshot
   ```

3. Publish to @next tag:
   ```bash
   npm run release:snapshot
   ```

### Automatic Release via GitHub Actions

Simply push to a development branch with one of the supported prefixes:
- `copilot/feature-name`
- `feature/feature-name`
- `dev/feature-name`
- `next/feature-name`

The workflow will automatically create a snapshot version and publish to @next tag.

### Installing @next Packages

Users can install the @next version with:
```bash
npm install rescript-bun@next
```

## Branch Strategy

- `main` branch → publishes to `latest` tag (1.x versions)
- `2.x` branch → publishes to `latest` tag (2.x versions)  
- Development branches → publishes to `next` tag (snapshot versions)