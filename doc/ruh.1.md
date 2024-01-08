---
title: rpm-update-history
section: 1
header: RPM Update History
footer: rpm-update-history 24.01.0
date: November 23, 2023
---

# NAME

**rpm-update-history**: Compile data on the number of updates and installs using
yum / dnf transaction info.

# SYNOPSIS

**rpm-update-history** [*OPTION*]

# DESCRIPTION

**rpm-update-history** aims to track package history on RPM systems, compiling
data on the number of updates and installs. Designed to enhance system
reliability, this initiative collects and centralizes information, providing
valuable insights into the evolution of packages.

# OPTIONS

**-b**, **\--build**
: Compile history info

**-l**, **\--list**
: List all compiled statistics

**-u**, **\--upload**
: Upload data to a central repository. See the **INTEGRATIONS** section to
configure a destination.

**-v**, **\--version**
: Show version number

**-h**, **\--help**
: You know what this option does

# FILES

**/etc/rpm-update-history.conf**
Configuration file. Normally `rpm-update-history` uses sane defaults, but if you
want to activate any option or integration, go to this file, uncomment the
section and modify it. Useful during development, since you can set another
parameters for this environment.

**/var/lib/rpm-update-history/ruh.db**
**sqlite3**(1) database file. Only remove this if you want to start again your
findings, like recalculate all transactions, or send all transaction data to
your integration again.

# INTEGRATIONS

## InfluxDB

The integration with InfluxDB enables the storage and retrieval of package data
in an easy-to-use manner. To send data to InfluxDB, modify the configuration
file to include a **\[influxdb\]** block. Typically, the configuration file contains a
commented-out example block; simply uncomment this and edit the parameters.

# BUGS

Submit bug reports online at:
<https://github.com/rdeavila/rpm-update-history/issues>

# SEE ALSO

Full documentation and sources at:
<https://github.com/rdeavila/rpm-update-history>
