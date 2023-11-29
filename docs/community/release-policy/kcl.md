# KCL Release Policy

The KCL development team uses [Semantic Versioning](https://semver.org/) to simplify management. The version format follows the pattern of major.minor.patch. The version increments as follows: major version for incompatible API changes, minor version for backward-compatible functionality additions, and patch version for backward-compatible bug fixes. The overall goal is to release a minor version with feature enhancements every six months, with occasional patch versions as needed.

The KCL project version release strategy is as follows:

- Major Version: The major version is increased when there are significant architectural changes or major new features. The current major version for the KCL project is 0.
- Minor Version: The minor version is increased when there are significant changes to added features and functionalities. The current minor version is 5, and versions 0.5, 0.6, and 0.7 will be released in the year 2023.
- Patch Version: The patch version is increased when there are updates to fix bugs or improve performance. The patch version starts from 0 and increments by 1.
- Release Cycle: Before reaching version 1.0.0, the plan is to release a new minor version every 3 months. During this period, user feedback will be continuously collected, and necessary fixes and improvements will be made.
- Release Process: Before releasing a new version, rigorous testing and review are conducted to ensure the quality of the new version. After finalizing the release and completing the testing, the source code, binaries, and images of the new version will be published on Github, along with detailed documentation and usage guides.
- Version Support: Long-term support will be provided for the latest version, including bug fixes and security updates. Limited support will be provided for older versions, with fixes only done when necessary.

## Release Process and Rules

- Feature Development: Main branch development, branch releases, block user issues, critical bugs, security vulnerabilities, and high-priority fixes. It is given higher priority over general feature development and should be completed within a week.
- Iteration Cycle: The iteration cycle is typically 3 months, with a new minor version released every 3 months.
- Version Planning: Two weeks before the release, an alpha version is produced, followed by a beta version one week before the release. Alpha versions can still include feature merging, while beta versions only include bug fixes. The final release version is tagged as a long-term saved release branch.
- Release Plan: A detailed release plan (Github Milestone) is created at the beginning of each release cycle, including release dates, version numbers, feature lists, and testing plans. The release plan should be followed as closely as possible to ensure timely releases.
- Pre-release Testing: Comprehensive testing, including unit testing, integration testing, fuzz testing, stress testing, and user acceptance testing, is conducted before releasing a new version. The new version is only released when it passes all tests without any issues.
- Version Rollback: If serious issues are discovered after the release, the version will be rolled back immediately, and the issues will be fixed as soon as possible. Users will be promptly notified through email, social media, etc., and provided with solutions.
- Release Documentation: Detailed documentation, including release notes, update logs, API documentation, and usage guides, is provided during the release to help users understand and use the new version. In KCL, this documentation is maintained on the KCL website.
- Version Compatibility: When releasing a new version, compatibility is maintained as much as possible to minimize the need for modifications and adaptations by users. Since KCL has not reached version 1 yet, there are no compatibility guarantees at the moment. The goal of KCL is to minimize major changes unless they provide significant benefits, such as solving problems in the target scenarios or improving the overall user experience. For features or changes that may introduce compatibility issues, appropriate prompts and solutions will be provided. Gradual upgrade guides or automated migration tools will be offered to help users smoothly transition to the new version.

## Release Components

![](/img/docs/community/release-policy/kcl-components.png)

For each version release, all related components of KCL depend on the same major version of the KCL core. The dependencies are organized in a tree structure and released and regression tested in a specific order until the release testing is completed, with efforts made to avoid triangular dependencies and prohibit circular dependencies.

## Lifecycle of a Feature

- Design and Documentation: Clearly answer the motivations, problems to be solved, and goals of the feature through issues. Define user requirements and user stories. Specify what the feature does, how it is implemented, its difficulty level, estimated time, dependencies, and testing requirements. (Tips: Split large designs into smaller ones, find a simple and sustainable solution through trade-offs and extensive research, and ensure scalability to adapt to future business or technical changes. Finalize the design through continuous discussions and design reviews).
- Code Implementation: Iteratively develop the feature through frequent small changes, continuous communication and collaboration. Design unit tests, integration tests, and benchmark tests in advance to ensure 100% test coverage, complete comments, and clear logic. Continuously collect feedback through demonstrations.
- Documentation Writing: Update user documentation on the KCL website.
- Testing and Feedback: Before releasing the feature, allow some peers/users to try and test these new features through written documentation rather than oral descriptions. Receive feedback and make improvements.
- Release and Announcements: Write Release Notes, PR articles, interpret scenarios and new features, and promote through various channels.

> Note: All the above information is public and should be made available for all community developers to participate, discuss, and contribute.
