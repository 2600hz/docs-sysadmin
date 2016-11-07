
We may be revising the build system to meet the demands of additional use cases. This document is a work-in-progress.
As the project has grown, more use-cases have evolved. Here are some we've learned about:
Desire to install on Debian, CentOS, FreeBSD, Windows
Desire to install on networks and servers which are 100% secure and private WAN
Desire to host all packages in a separate, non-public repository
Desire to have all dependencies packaged on a single CD or installation disk
Desire to be able to provide single-server upgrade procedures and installation media for remote sites
Customer Use Cases Include:
Internet Telephony Service Providers
Fire, Police and Military and Secure Installations With Disparate Sites
Health Care Industries with HIPPA compliance concerns
Installations who intend to be 100% self-sufficient and run everything on a private WAN for security
Installations where the logic and database servers are on non-public IPs and do not allow public internet access
 
Current Strategy:
Bundle everything in the RPM, including all libraries, wherever possible
 
Current Problems:
Effectively forking dependencies. Changes in our repo/dependencies can not be preserved when the dependency is upgraded
Individuals using/working with the project may end up testing/working on old dependency libraries. Upgrades to those libraries may break their work
The current source deployment model proposes a git clone into /opt/kazoo, which results in locally modified config files (whistle_apps/conf/vm.args and such) being shown in "git status", and they can accidentally be added to the repository.
New Proposed Standards:
Git repository should only contain sources, and no derivatives (such as beams). This applies to all sources, including third-party dependencies.
The build process should generate all needed beams and other derivatives
The source code does not assume any directory paths, and all the installation paths are defined during the installation (currently, for example: utils/sup/src/sup.erl contains "/opt/kazoo" hardcoded)
Desirable: strict separation of source directory, installation directory, and configuration directory. This is difficult to achieve within rebar paradigm, as it does not offer installing the application into a target path.
Installed scripts contains direct links to external binaries, such as full path to the erlang interpreter. This will allow multiple erlang versions exist on the same server (currently: "erl" from current PATH is used).
New Proposed Methods:
GNU Autoconf/Automake – seems to be a quite hardcore task to combine with rebar. One big difference is that automake assumes the source and target paths to be different, while rebar assumes that the source and installation paths are the same.
Shell scripts for configuration and installation:
Configuration script: takes the installation path (which is equal to CWD), Erlang path, configurable options such as cookies and hostnames, and generates the configuration files. These config files are never a part of Git repository. The configuration script is executed only once, and aborts if the configuration files already exist. Further modifications are done on configuration files directly. It is desirable to keep the config files outside of Kazoo installation path, then they can be added into their own git repository.
Build script generates all beams and other required derivatives. If any of source files are updated, the corresponding beams are re-built. The build script never modifies configuration files from #1.
Test script validates the current installation
 
Unresolved architecture issues:
Do we need to move all third-party dependencies outside of kazoo repository? 
Pros:
Easier to test new versions of third-party libraries
All original change history in third-party libraries is preserved
Possibility to use pre-packaged third-party libraries
A major update in a third-party library does not pollute kazoo repository
Cons:
Need to maintain reliable repositories for all dependencies
More complexity in installation scripts 
Need a script which fetches all third-party dependencies for offline installation

