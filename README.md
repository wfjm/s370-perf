# s370_perf: IBM System/370 Instruction Timing Benchmark 

### Overview <a name="overview"></a>
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
| [clib](clib)   | assembler code sniplets |
| [codes](codes) | the codes and jobs |
| [data](data)   | benchmark results |
| [doc](doc)     | documentation |
| [jcl](jcl)     | JCL job templates |