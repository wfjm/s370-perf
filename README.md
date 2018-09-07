# s370-perf: IBM System/370 Instruction Timing Benchmark

[![Build Status](https://travis-ci.org/wfjm/s370-perf.svg?branch=master)](https://travis-ci.org/wfjm/s370-perf)

### <a id="overview">Overview</a>
The project contains an instruction timing benchmark for the
[IBM System/370](https://en.wikipedia.org/wiki/IBM_System/370)
instruction set and covers almost all non-privileged instructions. The
benchmark code runs in 24-bit mode and does not cover `S/370-XA` extensions.
It was developed under `MVS 3.8J`, as available with turnkey systems
like [tk4-](http://wotho.ethz.ch/tk4-/). The development started in the
context of the [mvs38j-langtest](https://github.com/wfjm/mvs38j-langtest)
project but quickly turned into project of its own right.

For more detailed information consult
- [s370_perf code description](doc/s370_perf.md)

### Directory organization
The project files are organized in directories as

| Directory | Content |
| --------- | ------- |
| [bin](bin)     | some helper scripts |
| [codes](codes) | the codes and jobs |
| [data](data)   | benchmark results |
| [doc](doc)     | documentation |
| herc-tools     | the [herc-tools](https://github.com/wfjm/herc-tools) project as submodule, mainly for access to `hercjis` |
| [jcl](jcl)     | JCL job templates |
| [narr](narr)   | narrative for benchmark results |
| sios           | the [mvs38j-sios](https://github.com/wfjm/mvs38j-sios) project as submodule, simple I/O system asm code |

### License
This project is released under the 
[GPL V3 license](https://www.gnu.org/licenses/gpl-3.0.html),
all files contain the disclaimer:

    This program is free software; you may redistribute and/or modify
    it under the terms of the GNU General Public License version 3.
    See License.txt in distribition directory for further details.

The full text of the GPL license is in this directory as
[License.txt](License.txt).
