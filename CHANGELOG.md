# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project's packages adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[Unreleased]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.2.1...HEAD
[0.2.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.1.1...v0.2.0
[0.1.1]: https://github.com/giantswarm/kubectl-apply-job/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/giantswarm/kubectl-apply-job/releases/tag/v0.1.0
