# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project's packages adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.10.0] - 2025-06-25

### Changed

- Set seccompProfileType to `RuntimeDefault` for kubectl Job by default.
- Update gsoci.azurecr.io/giantswarm/docker-kubectl Docker tag to v1.33.2

## [0.9.2] - 2025-04-03

### Changed

- Allow filenames with dots.

## [0.9.1] - 2025-02-18

### Added

- Allow disabling the Job through values.

## [0.9.0] - 2025-01-24

### Changed

- Update Update gsoci.azurecr.io/giantswarm/docker-kubectl Docker tag to v1.32.1
- Set `securityContext.seccompProfileType: RuntimeDefault` by default for kubectl Job.

### Removed

- Remove PSP.

## [0.8.0] - 2024-07-08

### Changed

- Set `readOnlyRootFilesystem: true` for kubectl container.

## [0.7.0] - 2023-12-12

### Changed

- Configure `gsoci.azurecr.io` as the default container image registry.

## [0.6.0] - 2023-10-05

### Changed

- Do not install PodSecurityPolicy resources if `global.podSecurityStandards.enforced` is set to `true`

## [0.5.0] - 2023-05-10

### Changed

- Comply to PodSecurityPolicy restricted profile

## [0.4.0] - 2023-05-04

### Changed

- Add `node-role.kubernetes.io/control-plane:NoSchedule` to Job tolerations

## [0.3.1] - 2023-04-19

### Changed

- Fix ciliumNetworkPolicy condition

## [0.3.0] - 2023-04-19

### Added

- Add values schema file
- Add cilium network policies

## [0.2.2] - 2023-02-03

### Fixed

Correctly set `"helm.sh/hook-delete-policy": "before-hook-creation,hook-succeeded,hook-failed"` annotation

## [0.2.1] - 2023-01-31

### Added

- Add kube-linter `ignore-check.kube-linter.io/no-read-only-root-fs: "kubectl writes temporary files"` annotation to Job

## [0.2.0] - 2023-01-31

### Added

- Additional PodSecurityPolicy annotations and labels through values
- Pod and container seccomp type value

## [0.1.1] - 2023-01-25

### Fixed

- Change evaluation of .Values.global for container image registry

## [0.1.0] - 2023-01-19

Initial Release

[Unreleased]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.10.0...HEAD
[0.10.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.9.2...v0.10.0
[0.9.2]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.9.1...v0.9.2
[0.9.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.9.0...v0.9.1
[0.9.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/kubectl-apply-job/releases/tag/v0.1.0
