Comgr v3.0 Release Notes
========================

This document contains the release notes for the Code Object Manager (Comgr),
part of the ROCm Software Stack, release v3.0. Here we describe the status of
Comgr, including major improvements from the previous release and new feature

These are in-progress notes for the upcoming Comgr v3.0 release.
Release notes for previous releases can be found in
[docs/historical](docs/historical).

Potentially Breaking Changes
----------------------------
These changes are ones which we think may surprise users when upgrading to
Comgr v3.0 because of the opportunity they pose for disruption to existing
code bases.

-  Removed -h option from comgr-objdump: The -h option (short for -headers) is a
legal comgr-objdump option. However registering this as an LLVM option by Comgr
prevents other LLVM tools or instances from registering a -h option in the same
process, which is an issue because -h is a common short form for -help.

New Features
------------
- Added support for linking code\_object\_v4/5 device library files.
- Enabled llvm dylib builds. When llvm dylibs are enabled, a new package
rocm-llvm-core will contain the required dylibs for Comgr.
- Moved build to C++17, allowing us to use more modern features in the
implementation and tests.
- Enabled thread-safe execution of Comgr by enclosing primary Comgr actions in
an std::scoped\_lock()
- Added support for bitcode and archive unbundling during linking via the new
llvm OffloadBundler API.

Bug Fixes
---------
- Fixed symbolizer assertion for non-null terminated file-slice content,
by bypassing null-termination check in llvm::MemoryBuffer
- Fixed bug and add error checking for internal unbundling. Previously internal
unbundler would fail if files weren't already present in filesystem.
- Fixed issue where lookUpCodeObject() would fail if code object ISA strings
weren't listed in order.
- Added support for subdirectories in amd\_comgr\_set\_data\_name(). Previously
names with a "/" would generate a file-not-found error.
- Added amdgpu-internalize-symbols option to bitcode codegen action, which has
significant performance implications
- Fixed an issue where -nogpulib was always included in HIP compilations, which
prevented correct execution of
COMPILE\_SOURCE\_WITH\_DEVICE\_LIBS\_TO\_BC action.


New APIs
--------
- amd\_comgr\_populate\_mangled\_names() (v2.5)
- amd\_comgr\_get\_mangled\_name() (v2.5)
    - Support bitcode and executable name lowering. The first call populates a
    list of mangled names for a given data object, while the second fetches a
    name from a given object and index.

Deprecated APIs
---------------

Removed APIs
------------

New Comgr Actions and Data Types
--------------------------------
- (Data Type) AMD\_COMGR\_DATA\_KIND\_BC\_BUNDLE
- (Data Type) AMD\_COMGR\_DATA\_KIND\_AR\_BUNDLE
  - These data kinds can now be passed to an AMD\_COMGR\_ACTION\_LINK\_BC\_TO\_BC
action, and Comgr will internally unbundle and link via the OffloadBundler and linkInModule APIs.

Deprecated Comgr Actions and Data Types
---------------------------------------

Removed Comgr Actions and Data Types
------------------------------------

Comgr Testing, Debugging, and Logging Updates
---------------------------------------------
- Added support for C++ tests. Although Comgr APIs are C-compatible, we can now
use C++ features in testing (C++ threading APIs, etc.)
- Clean up test directory by moving sources to subdirectory
- Several tests updated to pass while verbose logs are redirected to stdout
- Log information reported when AMD\_COMGR\_EMIT\_VERBOSE\_LOGS updated to:
    - Show both user-facing clang options used (Compilation Args) and internal
    driver options (Driver Job Args)
    - Show files linked by linkBitcodeToBitcode()
- Remove support for code object v2 compilation in tests and test CMAKE due to
deprecation of code object v2 in LLVM. However, we still test loading and
metadata querys for code object v2 objects.
- Remove support for code object v3 compilation in tests and test CMAKE due to
deprecation of code object v3 in LLVM. However, we still test loading and
metadata querys for code object v3 objects.
- Revamp symbolizer test to fail on errors, among other improvments

New Targets
-----------
 - gfx940
 - gfx1036

Removed Targets
---------------

Significant Known Problems
--------------------------
- Several Comgr actions currently write and read files from the filesystem,
which is a known performance issue. We aim to address this by improving
clang's virtual file system support
- Several Comgr actions currently fork new processes for compilation actions. We
aim to address this by librayizing llvm tools that are currently only useable as
a separate process.
