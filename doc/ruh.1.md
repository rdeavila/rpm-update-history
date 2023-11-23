---
title: RUH
section: 1
header: RPM Update History
footer: rpm-update-history 23.11.1
date: November 13, 2023
---

# NAME

ruh - Compile data on the number of updates and installs using yum / dnf
transaction info.

# SYNOPSIS

**ruh** [*OPTION*]

# DESCRIPTION

**ruh** aims to track package history on RPM systems, compiling data on the
number of updates and installs. Designed to enhance system reliability, this
initiative collects and centralizes information, providing valuable insights
into the evolution of packages.

# OPTIONS

**-b**, **\--build**
: Compile history info

**-l**, **\--list**
: List all compiled statistics

**-v**, **\--version**
: Show version number

**-h**, **\--help**
: You know what this option does

# FILES

**/etc/ruh.conf** Configuration file. Normally `ruh` uses sane defaults, but if
you want to activate any option or integration, go to this file, uncomment the
section and modify it. Useful during development, since you can set another
parameters for this environment.

**/var/lib/ruh/ruh.db**
**sqlite3**(1) database file. Only remove this if you want to start again your
findings, like recalculate all transactions, or send all transaction data to
your integration again.

# INTEGRATIONS

TODO: Write this section

# BUGS

Submit bug reports online at:
<https://github.com/rdeavila/rpm-update-history/issues>

# SEE ALSO

Full documentation and sources at:
<https://github.com/rdeavila/rpm-update-history>
