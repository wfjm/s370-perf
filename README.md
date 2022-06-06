# s370-perf: IBM System/370 Instruction Timing Benchmark

[![Build Status](https://travis-ci.org/wfjm/s370-perf.svg?branch=master)](https://travis-ci.org/wfjm/s370-perf)

### <a id="overview">Overview</a>
The project contains an instruction timing benchmark for the
[IBM System/370](https://en.wikipedia.org/wiki/IBM_System/370)
instruction set and covers almost all non-privileged instructions. The
benchmark code runs in 24-bit mode and does not cover `S/370-XA` extensions.
It was developed under `MVS 3.8J`, which is freely available with turnkey
systems like [tk4-](http://wotho.ethz.ch/tk4-/).
The development began as part of the
[mvs38j-langtest](https://github.com/wfjm/mvs38j-langtest)
project, but quickly evolved into an independent project.

The timing benchmark was executed on a wide range of systems.
Most tests were performed with the
[Hercules](https://en.wikipedia.org/wiki/Hercules_(emulator)) simulator
on a variety of host systems. Some less common or less accessible  platforms,
like a [P/390](narr/sysinfo_p390.md) or `z/PDT 1.7` are also included.

The instruction time tables were condensed into a
[MIPS](https://en.wikipedia.org/wiki/Instructions_per_second) rating called
_lmark_ using the weighting factors published in 1974 by Liba Svobodova,
see [lmark](doc/s370_perf_mark.md.html#user-content-mix-lmix) description.

The results as well as some explaining narrative is also part of this project.

For more detailed information consult
- [s370_perf code description](doc/s370_perf.md)
- [documentation of helper scripts](doc/README.md)
- [list of all benchmark runs](narr/README.md)
- [summary of Hercules based tests](narr/README_gsum.md)
- [HOWTO execute a benchmark test](doc/HOWTO_execute_benchmark.md)

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
| [narr](narr)   | narrative for benchmark results, see [README](narr/README.md) for summary |
| sios           | the [mvs38j-sios](https://github.com/wfjm/mvs38j-sios) project as submodule, simple I/O system asm code |

### License
This project is released under the 
[GPL V3 license](https://www.gnu.org/licenses/gpl-3.0.html),
all files contain a [SPDX](https://spdx.org/)-style disclaimer:

    SPDX-License-Identifier: GPL-3.0-or-later

The full text of the GPL license is in this directory as
[License.txt](License.txt).

### Installation
This project uses submodules, therefore use
```
  git clone --recurse-submodules git@github.com:wfjm/s370-perf.git
```
