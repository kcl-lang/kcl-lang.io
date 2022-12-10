# KCL Release Policy

The KCL development team hopes to adopt [semantic version](https://semver.org) to simplify management. Version format: `{major}.{minor}.{revision}`. The rules for increasing version numbers are as follows: major version numbers correspond to incompatible API modifications, minor version numbers correspond to downward compatible functional additions, and revision numbers correspond to downward compatible problem corrections. The major version number and minor version number contain different features, which are called the large version and the patch repair is called the small version.

The overall goal is to release a large version with enhanced features every quarter, support the two recently released large versions, and release revisions of other versions from time to time as needed.

## 1. Release Process

The release process is as follows:

- The main branch is developed, and a Nightly version is produced every day, and the CI system is tested
- The beta test branch produces a beta version from Nightly after 6 weeks
- Stable branch. After 6 weeks, a stable version will be produced from the beta version
- release-branch.kcl-x. Y Release branch, produce a RC candidate version from the Stable version every quarter, and finally release it
- release-branch.kcl-x. BUG fix of branch y needs to be merged back to the main branch, and then synchronized to the beta and stable branches step by step

Among them, stable and beta are only delayed the main branch, release branch.kcl-x after publishing, `y` will be saved independently from the master.

If this release fails, it will be postponed to the next release cycle.

## 2. Release Maintenance

Release minor versions to solve one or more critical problems that have no solution (usually related to stability or security). The only code changes included in the release are fixes for specific critical issues. Important only document changes and security test updates may also be included, but that's all. Once `KCL 1.x+2` is released, minor versions that address the non security issues of `KCL 1.x` will stop updating. The minor version to solve `KCL 1.x` security problems will stop after `KCL 1.x+2` is released.
