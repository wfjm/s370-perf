## s370_perf: IBM System/370 Instruction Timing Benchmark 

### Table of content

- [Overview](#user-content-overview)
- [Description](#user-content-description)
- [Parameters](#user-content-parameters)
- [Configuration file](#user-content-config)
- [Output](#user-content-output)
- [Usage](#user-content-usage)

### Overview <a name="overview"></a>
This code determines the _time per instruction_ of
[IBM System/370](https://en.wikipedia.org/wiki/IBM_System/370)
instructions in 24-bit mode. It
- covers almost all non-privileged instructions
- tests load and store instructions for _aligned_ and _unaligned_ data
- tests instructions with length fields (e.g. `MVC`) for several length
- tests decimal instructions (e.g. `AP`) for two digit counts
- tests conditional branches for _taken_ and _fall-through_ case
- tests branches (e.g. `B`,`BAL`) for short (same 4k page) and
  _far_ (different page) targets
- tests instructions with memory interlock (`CS`,`CDS`,`TS`) in the
  typical _lock taken_ and the _lock missed_ data configurations

The code was developed and tested using the
[Hercules](https://en.wikipedia.org/wiki/Hercules_(emulator)) emulator
and MVS 3.8J as packaged with [tk4-](http://wotho.ethz.ch/tk4-/).
It should work for CPU speeds from below 1 to well above 1000
[MIPS](https://en.wikipedia.org/wiki/Instructions_per_second#MIPS), thus run
without modifications on a wide range of platforms
- older hardware implementations, like P/390 boards
- Hercules on slow systems, like Raspberry Pi
- Hercules on contemporary PC processors
- and even contemporary z Systems

### Description <a name="description"></a>
The basic test building block used in `s370_perf` looks like

``` asm
T100L   LR  R2,R1
        LR  R2,R1
        LR  R2,R1
        ... total of 50 repeats ...
        BCTR  R15,R11
```

The instruction under test is repeated, usually 50 times for fast instructions,
and that sequence is wrapped in `BCTR` loop.

### Parameters <a name="parameters"></a>
The run time behavior of `s370_perf` is controlled by options passed with
the JCL `EXEC` card `PARM` mechanism. The `PARM` string is a list of 4 letter
options, each starting with a `/`. Valid options are:

| Option | Description |
| ------ | :---------- |
| [/OWTO](#user-content-par-owto) | enable step by step MVS console messages |
| [/ODBG](#user-content-par-odbg) | enable debug trace output for test steps |
| [/OTGA](#user-content-par-otga) | enable debug trace output for [/GAUT](#user-content-par-gaut) processing |
| [/OPCF](#user-content-par-opcf) | print configuration file entries |
| [/OPTT](#user-content-par-optt) | print test descriptor table |
| [/ORIP](#user-content-par-orip) | run tests in place (default is relocate) |
| [/GAUT](#user-content-par-gaut) | automatic determination of `GMUL`, aim is 1 sec per test |
| [/Gnnn](#user-content-par-gnnn) | set `GMUL` to nnn |
| [/GnnK](#user-content-par-gnnn) | set `GMUL` to nn * 1000 |
| [/Cnnn](#user-content-par-cnnn) | select test used for /GAUT |
| [/Ennn](#user-content-par-ennn) | enable  test Tnnn |
| [/Dnnn](#user-content-par-ennn) | disable test Tnnn |
| [/Tnnn](#user-content-par-tnnn) | select  test Tnnn |
| [/TCOR](#user-content-par-tcor) | select tests required for corrections |

#### /OWTO <a name="par-owto"></a>
Enables step by step MVS console messages, send with `WTO` as 'job status'
message to the operator console. This might be useful to see the `s370_perf`
run steps in the context of all other system activities in the console log,
but on systems with a real operator this might not be too welcome. The
messages are send at the end of each test step and look like
```
13.49.45 JOB 5226  +s370_perf: done T100
13.49.46 JOB 5226  +s370_perf: done T101
13.49.47 JOB 5226  +s370_perf: done T102
```

#### /ODBG <a name="par-odbg"></a>
Enable debug trace output for test steps. Gives the start and stop time
of the test step as retrieved with `STCK` and all other information to
double check the calculation of the instruction timing.

#### /OTGA <a name="par-otga"></a>
Enable debug trace output for /GAUT processing in the format
```
--  GAUT:         1 :   D3BCC375  081DF080 :   D3BCC375  098220C0 :       5699
--  GAUT:         3 :   D3BCC375  09832880 :   D3BCC375  0E14E0C1 :      18716
--  GAUT:         9 :   D3BCC375  0E166081 :   D3BCC375  1934C0C1 :      45542
--  GAUT:        27 :   D3BCC375  193620C1 :   D3BCC375  3A9848C1 :     136738
--  GAUT:        81 :   D3BCC375  3A9A2841 :   D3BCC375  9EDCF041 :     410669
PERF002I run with GMUL=        197
```
The 1st number gives the current `GMUL`, the next two the time retrieved with
`STCK` before and after an execution of the T102 test, the last difference
divided by 4096, which is the elapsed time in units usec.

#### /OPCF <a name="par-opcf"></a>
Prints configuration file entries (comments are skipped) in the format
```
  PERF010I config: T151    1      2000
  PERF010I config: T152    1      4000
  PERF010I config: T154    1      4000
  ...
```

#### /OPTT <a name="par-optt"></a>
Prints the test descriptor table in the format
```
 ind   tag        lr  ig  lt      addr    length
   0  T100     22000 100   1  000A8D48       252
   1  T101     17000 100   1  000A8E48       452
   2  T102     13000  50   1  000A9010       256
 ...
```

with the columns containing

| column | description |
| ------ | :---------- |
| ind    | table entry index |
| tag    | name of the test. A disabled test is prefixed with `-` |
| lr     | _local repeat count_, the loop count for the `BCTR` loop of the test |
| ig     | _group count_, the number time the instruction under test is replicated in the body of the test loop |
| lt     | _loop type_, indicates the additional instructions used to close the loop around the instruction under test |
| addr   | absolute address of the beginning of the test code |
| length | length of the test code |

#### /ORIP <a name="par-orip"></a>
Run tests in place. The default is to relocate each test before execution into
a page aligned 8 kByte buffer. This ensures that test don't have branches
across page boundaries, unless explicitly wanted. `/ORIP` disables this
relocation and executes the code in the place where the assembler generated
it. Useful for debugging tests with break after relocation.

#### /GAUT <a name="par-gaut"></a>
Enables automatic determination of `GMUL`. This will setup the global repeat
count such that the `T102` test or the one selected with a
[/Cnnn](#user-content-par-cnnn) option
runs about 1 sec. Because the local repeat count of
each test have been tuned to get about equal CPU time for all tests on the
reference system this will result in about 1 sec CPU time for all tests
for systems with simuilar characteristics.
Typical `GMUL` values resulting from `/GAUT` are

| Host CPU | System | GMUL | Comment |
| -------- | ------ | ---: | ------- |
| ARMv5te               | Herc tk3         |   4 | Pogoplug v2 |
|                       | P/390            |   8 | CPU board |
| ARMv7 - BCM2835       | Herc tk4- 08     |  11 | Raspberry Pi 2 Model B |
| AMD Opteron 6238      | Herc tk4- 08     | 100 | older 2*12 core server |
| Intel Core2 Duo E8400 | Herc tk4- 09 rc2 | 118 | older desktop CPU |
| Intel Xeon E5-1620    | Herc tk4- 08     | 195 | typical 4 core  workstation |
| Intel Core i7-3520M   | Herc tk4- 08     | 202 | mid-end notebook |

#### /Gnnn and /GnnK <a name="par-gnnn"></a>
With `/Gnnn` or `GnnK`, where n are decimal digits, the global multiplier
`GMUL` will be set to nnn or nn*1000, respectively. Helpful for debugging,
normal production runs usually use [/GAUT](#user-content-par-gaut).

#### /Cnnn <a name="par-cnnn"></a>
Selects the test used by [/GAUT](#user-content-par-gaut). The three digit
code must match one of the test numbers. By default `T102` is used.

#### /Ennn and /Dnnn <a name="par-ennn"></a>
Allow to enable or disable the test Tnnn.
The three characters after the leading `/T` or `/D` can be either a number
`0` - `9` or a wildcard character `*`, which will match any number in that
postion. This allows to handle groups of tests, e.g. `/E1**` will enable all
tests in the 100 to 199 range, `/D5**` will disable all test in the range
500 to 599 (the floating point group).
By default all tests are enabled with the exception of T284 and T285
(very slow `CLCL` tests).
Can be used to disable tests which cause problems.
To setup a run with only a few tests use the
[/Tnnn](#user-content-par-tnnn) option.

#### /Tnnn <a name="par-tnnn"></a>
When the first `/Tnnn` option is detcted in the PARM list all tests will
be disabled.
Each `/Tnnn` re-enables than the test Tnnn. This allows to setup a run with
only a few tests enabled. Wildcards are supported as described for
[/Ennn](#user-content-par-ennn).

#### /TCOR <a name="par-tcor"></a>
Inspects all enabled tests and enables all tests required by
[s370_perf_ana](s370_perf_ana.md)
for corrections and normalizations:
- all tests required by loop overhead corrections
- T100 and T102 used in normalized instruction times

`/TCOR` is handled as last step of test enable/disable processing, after
the [configuration file](#user-content-config) and all
[/Ennn,Dnnn](#user-content-par-ennn) and
[/Tnnn](#user-content-par-tnnn) options.

### Configuration file <a name="config"></a>
The local repeat counts for each test have been adjusted such that all
tests consume roughly the same CPU time on a reference system, a Hercules
emulator running on an up-to-date Intel CPU. For very different
environments, e.g. a z/PDT emulator or real hardware like a P/390 system,
the relative CPU consumption can be very different. In those cases the
local repeat counts can be redefined with a configuration file read from
`SYSIN` in the format
```
#nnn    e     lrcnt
T151    1      2000
T152    1      4000
T154    1      4000
```
Lines starting with `#` are considered comments and are ignored.
Each line holds
- a four character task name, like `T154`. No wildcards supported here.
- an enable flag, `0` or `1`, which overrides the test enable status
- a new local repeat count for this test. If 0 is specified the old one is kept.

Note that the fields are strictly positional, the enable must be in column 9,
the local repeat count right justified in columns 12 to 18. It is thus
advisable to have a comment line as shown in the example above.
The processing of the configuration file can be monitored with the
[/OPCF](#user-content-par-opcf) option, the final settings can be
inspected with the [/OPTT](#user-content-par-optt) option.

### Output <a name="output"></a>
The output of `s370_perf` is a table of test step results in the form
```
PERF001I PARM: /GAUT
PERF002I run with GMUL=        118
PERF003I start with tests
 tag  description              :      test(s)         lr  ig  lt :    inst(usec)
T100  LR R,R                   :      0.818643     22000 100   1 :      0.003153
T101  LA R,n                   :      0.800819     17000 100   1 :      0.003992
T102  L R,m                    :      0.991196     13000  50   1 :      0.012923
T103  L R,m (unal)             :      1.078041     12000  50   1 :      0.015227
...
PERF004I done with tests
```

with the columns containing

| column | description |
| ------ | :---------- |
| tag         | name of the test |
| description | instruction under test and conditions |
| test(s)     | execution time of this test in sec |
| lr          | _local repeat count_, the loop count for the `BCTR` loop of the test |
| ig          | _group count_, the number time the instruction under test is replicated in the body of the test loop |
| lt          | _loop type_, indicates the additional instructions used to close the loop around the instruction under test, see section [Loop Types](#user-content-looptype). |
| inst(usec)  | time per instruction in usec |

Notes on the given instruction time:
- the loop overhead is not subtracted, that will be done in post-processing
  with [s370_perf_ana](s370_perf_ana.md). However, the loop overhead is
  typically a few % only, so the numbers are a good quick estimate.
- for instructions which can only be tested in context, like `BALR` or `MVCL`,
  the time is for the whole bundle, which is described in the
  description field as a `;` separated list like `BALR R,R; BR R`.

#### Loop Types <a name="looptype"></a>
Most tests contain only the replicated instruction under test and a closing
`BCTR`. In some cases additional initialization is needed for each inner
loop iteration. The current code uses the following loop types

| lt | Loop instructions | Comment |
| -: | ----------------- | ------- |
|  0 |                   | used for testing `BCTR` and `BCR` |
|  1 | BCTR              | used for most tests |
|  2 | BCT               | tests with 8k code |
|  3 | LR, BCTR          | |
|  4 | LA, BCTR          | |
|  5 | LA, XR, BCTR      | |
|  6 | LA, LA, LA, BCTR  | |
|  7 | MVC (5c), BCTR    | |
|  8 | MVC (15c), BCTR   | |
|  9 | LE, BCTR          | |
| 10 | LD, BCTR          | |
| 11 | LD, LD, BCTR      | |

### Usage <a name="usage"></a>
s370_perf is a fairly large assembler module, currently 6800+ lines of code
with a lot of macro generated code. Both assembler nor linkage editor
fail under MVS 3.8J and the defaults of the `ASMFCLG` procedure as
provided in [tk4-](http://wotho.ethz.ch/tk4-/). The assembler needs
increased allocations of the work files, and runs substantially faster
with `BUFSIZE(MAX)`. The linkage editor needs an increased work area
like `SIZE=(512000,122880)`. A well working JCL example is
```
//CLG EXEC ASMFCLG,
//      MAC1='SYS2.MACLIB',
//      PARM.ASM='NOLIST,NOXREF,NORLD,NODECK,LOAD,BUFSIZE(MAX)',
//      PARM.LKED='MAP,LIST,LET,NCAL,SIZE=(512000,122880)',
//      COND.LKED=(8,LE,ASM),
//      PARM.GO='/GAUT/E9**',
//      COND.GO=((8,LE,ASM),(4,LT,LKED))
//ASM.SYSUT1 DD DSN=&&SYSUT1,UNIT=SYSDA,SPACE=(1700,(600,100))
//ASM.SYSUT2 DD DSN=&&SYSUT2,UNIT=SYSDA,SPACE=(1700,(900,200))
//ASM.SYSUT3 DD DSN=&&SYSUT3,UNIT=SYSDA,SPACE=(1700,(900,200))
//ASM.SYSGO  DD DSN=&&OBJSET,UNIT=SYSDA,SPACE=(80,(2000,500))
//ASM.SYSIN  DD *
...
```

Job templates to be used with
[hercjis](https://github.com/wfjm/herc-tools/blob/master/doc/hercjis.md)
are provided in the
[codes](../codes) directory and described in the
[README](../codes/README.md).
