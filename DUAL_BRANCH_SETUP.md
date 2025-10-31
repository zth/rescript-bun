# Dual-Branch Release Setup

This repository uses a dual-branch approach for managing releases:

## Branch Structure

- **`main` branch**: Handles 1.x version releases
- **`2.x` branch**: Handles 2.x version releases

## Workflow Files

### Release Workflows

- **`release-main.yml`**: Triggers on pushes to `main` branch, handles 1.x releases
- **`release-2x.yml`**: Triggers on pushes to `2.x` branch, handles 2.x releases

Both workflow files exist on both branches, but each only triggers on its respective branch to prevent interference.

### Test Workflow

- **`test.yml`**: Runs on both `main` and `2.x` branches to ensure code quality across both version lines

## Changeset Configuration

Each branch has its own changeset configuration:

- **`main` branch**: `baseBranch: "main"` in `.changeset/config.json`
- **`2.x` branch**: `baseBranch: "2.x"` in `.changeset/config.json`

This ensures that changesets work correctly on each branch by comparing against the appropriate base.

## Release Process

### For 1.x releases (main branch):
1. Create changeset: `bun run changeset`
2. Commit and push to main branch
3. The `release-main.yml` workflow will create a release PR or publish

### For 2.x releases (2.x branch):
1. Switch to 2.x branch: `git checkout 2.x`
2. Create changeset: `bun run changeset`
3. Commit and push to 2.x branch
4. The `release-2x.yml` workflow will create a release PR or publish

## Important Notes

- Both branches maintain independent changeset histories
- Workflows do not interfere with each other due to branch-specific triggers
- Each branch can have different dependencies and configurations as needed
- The version numbers are managed separately per branch (1.x vs 2.x)