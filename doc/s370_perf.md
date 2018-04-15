## s370_perf: IBM System/370 Instruction Timing Benchmark 

### Table of content

- [Overview](#user-content-overview)
- [Description](#user-content-description)
- [Tests](#user-content-tests)
- [Parameters](#user-content-parameters)
- [Configuration file](#user-content-config)
- [Output](#user-content-output)
- [Usage](#user-content-usage)

### Overview <a name="overview"></a>
s370_perf determines the _time per instruction_ of
[IBM System/370](https://en.wikipedia.org/wiki/IBM_System/370)
instructions in 24-bit mode. It
- covers almost all non-privileged instructions
- tests load and store instructions for _aligned_ and _unaligned_ data
- tests instructions with length fields (e.g. `MVC`) for several length
- tests decimal instructions (e.g. `AP`) for two digit counts
- tests conditional branches for _taken_ and _fall-through_ case
- tests branches (e.g. `BC`,`BAL`) for short (same 4k page) and
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
s370_perf contains about 220 test routines, each targeting one S/370
instruction, plus about 80 additional tests to verify the consistency of
the measured instruction times. The core of an instruction test looks like
```asm
T100L   LR  R2,R1
        LR  R2,R1
        LR  R2,R1
        ... total of 100 repeats ...
        BCTR  R15,R11
```

The instruction under test is repeated, usually 50 times for fast instructions,
and that sequence is wrapped in `BCTR` loop. The instruction repeat count is
called _group count_ and listed in the `ig` column of the
[output](#user-content-output).

The repeat count of the `BCTR` loop is called _local repeat count_ and listed
in the `lr` column of the [output](#user-content-output).
The default values are chosen such that all
test routines have roughly the same execution time of about 5 msec on a
reference system. They can be changed via a
[configuration file](#user-content-config).

The s370_perf main program executes each test `GMUL` times. This
_global multiplier_ is common for all tests and typically chosen such
that a test runs about one second for a benchmark run, either explicitly via
[/Gnnn](#user-content-par-gnnn) or automatically via
[/GAUT](#user-content-par-gaut) option.

In some cases a register used in the inner loop must be re-initialized for
each loop iteration to avoid arithmetic overflows, like
```asm
T220L   LA    R2,1
        SLA   R2,1
        SLA   R2,1
        SLA   R2,1
        ... total of 30 repeats ...
        BCTR  R15,R11
```

The loop overhead will be subtracted later by the analysis tool
[s370_perf_ana](s370_perf_ana.md), based on the
[loop type](#user-content-looptype)
listed in the `lt` column of the [output](#user-content-output).

Some instructions modify registers or memory such that a setup is needed for
each invocation of this instruction, e.g. `ED` requires a `MVC` to setup the
edit pattern which is overwritten by the edit result. In those cases the test
loop looks like
```asm
T410L   MVC   0(10,R3),T410V3
        ED    0(10,R3),T410V1+3
        MVC   0(10,R3),T410V3
        ED    0(10,R3),T410V1+3
        ... total of 10 repeats sequence ...
        BCTR  R15,R11
```

In those cases the test gives the time for the instruction sequence. The
time for the targeted instruction, `ED` in the example, is again determined
by the analysis tool [s370_perf_ana](s370_perf_ana.md) by subtracting the
independently measured instruction time(s) of the additional instructions,
`MVC` in the example.

Last but not least allows the s370_perf main program to enable or disable
the execution of tests via the
[/Ennn](#user-content-par-ennn),
[/Dnnn](#user-content-par-ennn) and
[/Tnnn](#user-content-par-tnnn) options.
Almost all of the instruction tests are enabled by default, most of the
auxiliary tests T9xx are disabled by default. The configuration of all
available tests can be listed with the [/OPTT](#user-content-par-optt) option.

### Tests <a name="tests"></a>
Each test has a unique identifier, usually called _tag_, of the form `Tddd`.
The tests are grouped into classes
- Test 1xx -- load/store/move
- Test 2xx -- binary/logical
- Test 3xx -- flow control
- Test 4xx -- packed/decimal
- Test 5xx -- floating point
- Test 6xx -- miscellaneous instructions
- Test 7xx -- mix sequence
- Test 9xx -- auxiliary tests

Most tests are self-explanatory and target a single instruction, but some
deserve some commentary
- [T113+T114 - STH unaligned](#user-content-tests-sth-unal)
- [T15x - MVC](#user-content-tests-mvc)
- [T17x - MVCL](#user-content-tests-mvcl)
- [T27x - CLC](#user-content-tests-clc)
- [T28x - CLCL](#user-content-tests-clcl)
- [T301+T302 - BC branch taken / not taken](#user-content-tests-bc)
- [T303 - BC far](#user-content-tests-bc-far)
- [T311,T312,T315 - BCT,BCTR,BXLE](#user-content-tests-bloop)
- [T320+T321 - BALR close and far](#user-content-tests-balr)
- [T330 - BALR;SAVE;RETURN](#user-content-tests-calret)
- [T700 - mix int RR](#user-content-tests-t700)
- [T701+T702 - mix int RX](#user-content-tests-t701)
- [T703 - mix int RR noopt](#user-content-tests-t703)
- [T90x - LR R,R count tests](#user-content-tests-t90x)
- [T92x - L R,m count tests](#user-content-tests-t92x)
- [T95x - T700 partial sequence tests](#user-content-tests-t95x)

#### T113+T114 - STH unaligned <a name="tests-sth-unal"></a>
In test T113 `STH` does a write across a halfword border, while in test
T114 `STH` does a write across a word border. In T114 the access can even
cross a page border, so the two cases might exhibit quite different
performance characteristics.

#### T15x - MVC <a name="tests-mvc"></a>
The `MVC` instruction is tested for a wide range of transfer sizes between
5 and 250 characters, and also for two scenarios with overlapping
source and destination areas:
- in T156 the destination buffer is offset by + 1 byte to the source buffer.
  This is sometimes used to fill buffer with a character.
- in T157 the destination buffer is offset by -24 bytes to the source buffer,
  effectively shifting the buffer 24 bytes to the left.

#### T17x - MVCL <a name="tests-mvcl"></a>
The `MVCL` instruction is tested, like `MVC` in [T15x](#user-content-tests-mvc),
for a wide range of copy transfer sizes between 10 and 4096 bytes,
for three zero-fill padding cases, and also for two scenarios with overlapping
source and destination areas:
- in T178 the destination buffer is offset by + 1 byte to the source buffer.
  Like [T156](#user-content-tests-mvc) for `MVC`, can be used to fill an area,
  but padding is likely more efficient.
- in T179 the destination buffer is offset by -100 bytes to the source buffer,
  effectively shifting the buffer 100 bytes to the left.
  
#### T27x - CLC <a name="tests-clc"></a>
The `CLC` instruction is tested for a range of buffer sizes (10 to 250)
and also for fully matching `eq` and completely different `ne` buffers.
Because the `ne` case can be detected at the very first byte comparison
it's natural to expect that the `ne` tests have the same instruction time
for all sizes, while the `eq` tests show a time which increases with
buffer size.

#### T28x - CLCL <a name="tests-clcl"></a>
The `CLCL` instruction is tested for two buffer sizes (10 and 4096)
and different locations of the first non-matching byte (10, 100, 250,
1024 and 4096). Like for `CLC` in [T27x](#user-content-tests-clc) it
is natural to assume that the instruction time mainly depends on the
number of bytes to test before a mismatch is detected. The tests
T284 and T285 are disabled by default because they are very slow on
Hercules.

#### T301+T302 - BC branch taken / not taken <a name="tests-bc"></a>
The `BC` instruction is tested in both the
- branch not taken (T301)
- branch taken (T302)
case. The later is implemented as branch maze. In most implementations
the branch taken case will have a significantly larger instruction time
the the not taken (or fall through) case.

#### T303 - BC far <a name="tests-bc-far"></a>
The T303 is similar to T302, but the branch maze is setup such that each
branch crosses a page border. 

#### T311,T312,T315 - BCT,BCTR,BXLE <a name="tests-bloop"></a>
The loop instructions `BCT`, `BCTR` and `BXLE` are tested with empty
loop bodies, like
```asm
T315L    LA    R3,0               index begin
         LA    R4,1               index increment
         LA    R5,99              index end
T315LL   EQU   *                  no inner loop body
         BXLE  R3,R4,T315LL       will be executed 100 times
```
As in real applications is the branch taken case much more frequent than the
fall through case at end of loop.

#### T320+T321 - BALR close and far <a name="tests-balr"></a>
The `BALR` instruction can only be tested together with a `BR`. T321 is
setup such that each branch crosses a page border.

#### T330 - BALR;SAVE;RETURN <a name="tests-calret"></a>
This test covers the standard MVS calling sequence, starting with a `L` and
`BALR` on the caller side and standard save area handling with a full
`(14,12)` save and restore and save area linkage update at the callee
side. The test returns the time for the full sequence of 11 instructions.

#### T700 - mix int RR <a name="tests-t700"></a>
The test T700 contains a sequence of 38 integer RR type instructions plus
two `BC` where the branch isn't taken. The test returns the _average_
execution time of the involved instructions. This test allows to check whether
the instruction times are additive on a given system, simply compare the
T700 time with the average of the involved instructions.

#### T701+T702 - mix int RX <a name="tests-t701"></a>
Similar goal as [T700](#user-content-tests-t700), using a sequence of
21 integer RX type instructions. In T701 the accessed operands are in
the same page as the code, while in T702 the accessed operands are in
a different page than the code.

#### T703 - mix int RR noopt <a name="tests-t703"></a>
Similar goal as [T700](#user-content-tests-t700), now with an instruction
sequence where each calculated values is used. This prevents that emulators
using an optimizing binary translator will remove part of the code.

#### T90x - LR R,R count tests <a name="tests-t90x"></a>
The tests T900 to T915 are similar to the T100 test, but use different repeat
counts of the `LR R,R` instruction, with `ig` ranging from 1 to 72 (T100
uses 100). These tests report the time for the bundle `ig` `LR` instructions
and not time for a single instruction as T100. The measured time should
increase in proportion to the `ig` count if instruction times are additive,
so this can be used to check whether the loop overhead is subtracted correctly.

#### T92x - L R,m count tests <a name="tests-t92x"></a>
Similar goal as [T90x](#user-content-tests-t90x), using `L R,m`. To be compared
with T102.

#### T95x - T700 partial sequence tests <a name="tests-t95x"></a>
The tests T952 to T990 contain the first 2,3,...,40 instructions of the
[T700](#user-content-tests-t700) test, they are therefore truncated versions
of T700. The tests report the time for whole sequence and not the average
as T700. The measured time should continuously increase if instruction
times are additive, so this sequence of tests can be used to check whether
this is actually true for a given system.

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
for systems with similar characteristics.
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
position. This allows to handle groups of tests, e.g. `/E1**` will enable all
tests in the 100 to 199 range, `/D5**` will disable all test in the range
500 to 599 (the floating point group).
By default all tests are enabled with the exception of T284 and T285
(very slow `CLCL` tests).
Can be used to disable tests which cause problems.
To setup a run with only a few tests use the
[/Tnnn](#user-content-par-tnnn) option.

#### /Tnnn <a name="par-tnnn"></a>
When the first `/Tnnn` option is detected in the PARM list all tests will
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
