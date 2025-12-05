## CHANGELOG

> NOTE: this changelog is only for changes to the sokol-odin 'scaffolding'.
For actual Sokol header changes, see the
[sokol changelog](https://github.com/floooh/sokol/blob/master/CHANGELOG.md).

### 05-Dec-2025

Removed 'glue.odin' from the helpers package, this no longer compiled
after the last sokol_app.h update, and tbh it really doesn't make much
sense to have a redundant implementation to the official `sokol/glue`
bindings since it just increases manual maintenance overhead.

Also see: https://github.com/floooh/sokol-odin/issues/38

### 13-Apr-2024

Merged PR https://github.com/floooh/sokol-odin/pull/11, this changes the
directory structure of the bindings repository, adds support to build
the Windows bindings as a DLL and a couple of smaller things
detailed here: https://github.com/floooh/sokol/pull/1023
