# Branch workflow

- Work and commit on a feature branch. Before committing, run
  `git branch --show-current`; if it returns `master` or nothing (detached HEAD),
  create or switch to a feature branch while preserving existing changes.
- Never commit directly to `master` or push directly to `origin/master`, including
  through an explicit refspec such as `HEAD:master`.
- Submit changes to `master` through a pull request. Keep repository protections
  enabled and respect them when merging.
