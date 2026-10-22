# Contributing Guide

InsIIT is a community project and welcomes contributions of every kind - code,
documentation, design, ideas and testing.

## Before you start

* Read the [Project Structure](project-structure.md) and
  [Architecture](architecture/overview.md) pages so you know where your change
  belongs.
* Join the **insIIT Developers Community** Discord (link in the repository
  README) to ask questions and claim an issue.
* Check the open issues for something that matches your interests.

## Workflow

1. **Fork** the repository and clone your fork.
2. **Branch off `dev`** - it is the default and active branch. Do not target
   `master`.
   ```bash
   git checkout dev
   git checkout -b feat/short-description
   ```
3. **Make your change**, following the existing feature-folder pattern.
4. **Run the checks**:
   ```bash
   flutter analyze
   flutter test
   ```
5. **Commit** with a clear message, and **push** to your fork.
6. **Open a pull request against `dev`.** Reference the issue it addresses.

## Issue templates

The repository ships a bug-report template in `.github/ISSUE_TEMPLATE/`. When
you open a feature request, describe the feature, why it is useful, and where in
the code you expect it to live.

## Coding conventions

* Match the surrounding style; keep the feature-folder layout.
* Read colours from `theme.<role>` (see
  [Theming](architecture/state-management.md)) rather than hard-coding them, so
  light and dark mode both work.
* Never commit secrets. Google credentials belong in the git-ignored
  `lib/credentials/credentials.dart`.

## Recognition

Contributors are listed automatically via the
[All Contributors](https://allcontributors.org/) bot - see the table in the
repository README.
