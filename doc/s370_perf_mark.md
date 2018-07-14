## s370_perf_mark: derive MIPS ratings from s370_perf data 

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Options](#user-content-options)
- [Available Mixes](#user-content-mix)
- [Usage](#user-content-usage)
- [See also](#user-content-also)
- _source code:_ [bin/s370_perf_mark](../bin/s370_perf_mark)

### <a id="synopsis">Synopsis</a>
```
  s370_perf_mark [OPTIONS]... [FILE]...
```

### <a id="description">Description</a>
s370_perf_mark reads a single or multiple [s370_perf_ana](s370_perf_ana.md)
output files, determines for each system a weighted average instruction time
and derives from this a
[MIPS](https://en.wikipedia.org/wiki/Instructions_per_second#MIPS)
rating by simple inversion.
The weight factors are normalized instruction frequencies determined
for example by tracing the execution flow of a workload. The mix to
be applied can be selected with the [-mix option](#user-content-opt-mix)
and listed with the [-l option](#user-content-opt-l), the section
[Available Mixes](#user-content-mix) describes the available distributions.

The output has the format
```
file name                           #i     wsum      tsum      MIPS
2018-03-31_sys1-3g.dat              78   0.9858     13.03     76.72
2018-03-31_sys2.dat                 78   0.9858      8.84    113.07
2018-04-01_nbk1.dat                 78   0.9858      9.08    110.11
2018-04-01_nbk2.dat                 78   0.9858     13.92     71.83
2018-04-01_srv1.dat                 78   0.9858     16.12     62.03
2018-04-02_rasp2b.dat               78   0.9858    124.61      8.02
...
```

with the columns
- **file name**: input file name
- **#i**: number of instructions used in the weighted average
- **wsum**: sum of frequency weights
- **tavr**: average instruction time in ns
- **MIPS**: MIPS rating, simply 1000./tavr

The [-v option](#user-content-opt-v) generates a detailed _by instruction_
listing for each case of the format
```
2018-03-31_sys2.dat
   fi  ti inst       fwt      tpi     twt     cwt   tag m comment
    7   0  CLC    0.0342    34.19  0.1341  0.1341  T270   CLC m,m (10c,eq)
    6   1  MVC    0.0418    20.01  0.0959  0.2301  T151   MVC m,m (10c)
    1   2  BC y   0.0875     7.16  0.0719  0.3019  T302 * BNZ l (do br)
    3   3  TM     0.0610     8.82  0.0617  0.3636  T250   TM m,i
    2   4  L      0.0648     7.47  0.0555  0.4192  T102   L R,m
    5   5  CLI    0.0424     9.79  0.0476  0.4668  T265   CLI m,i
...
   72  74  SDR    0.0001    15.53  0.0002  0.9997  T542   SDR R,R
   68  75  LTDR   0.0002     5.18  0.0001  0.9998  T533   LTDR R,R
   77  76  O      0.0001     9.39  0.0001  0.9999  T231 * X R,m
   73  77  LPDR   0.0001     5.32  0.0001  1.0000  T536   LPDR R,R
```
with the columns
- **fi**: rank by frequency weight, 0 is highest
- **ti**: rank by time weight, 0 is highest
- **inst**: instruction
- **fwt**: frequency weight
- **tpi**: time per instruction in ns
- **twt**: time weight (contribution of this instruction to average
  instruction time)
- **cwt**: cumulative weight (from twt or, if [-sf](#user-content-opt-sf)
  is used, from fwt)
- **tag**: test tag the instruction time is taken from
- **m**: a `*` indicates that an equivalent instruction is mapped in
- **comment**: test comment test for tag

By default the output is sorted by time weight, with the instruction which
contributes most to the average instruction time at the top.
When the [-sf option](#user-content-opt-sf) is given the output is sorted
by frequency weight, with the most frequent instruction at the top.

### <a id="options">Options</a> 

| Option | Description |
| ------ | :---------- |
| [-mix=m](#user-content-opt-mix)  | specify mix to be used (default: lmix) |
| [-v](#user-content-opt-v)        | verbose, print detailed info |
| [-sf](#user-content-opt-sf)      | sort -v output by instruction frequency |
| [-l](#user-content-opt-l)        | list instruction mix |
| [-help](#user-content-opt-help)  | print help text and quit |

#### <a id="opt-mix">-mix=m</a>
Specify mix to be used. For available values see section
[Available Mixes](#user-content-mix). Default is [lmix](#user-content-mix-lmix).

#### <a id="opt-v">-v</a>
Generates a detailed _by instruction_ listing for each case.
The format is described in section[Description](#user-content-description).

#### <a id="opt-sf">-sf</a>
The detailed listing is sorted by frequency weight and not by time weight.

#### <a id="opt-l">-l</a>
The frequency distribution of the the select mix it printed in the format
```
Instruction frequencies for mix 'lmix'
   fi  inst      fwt     cwt   tag  map    comment
    0  BC n   0.0875  0.0875  T301  BNZ    (no br)
    1  BC y   0.0875  0.1750  T302  BNZ    (do br)
    2  L      0.0648  0.2398  T102         
    3  TM     0.0610  0.3008  T250         
    4  LA     0.0498  0.3506  T101         
    5  CLI    0.0424  0.3930  T265         
    6  MVC    0.0418  0.4348  T151         (10c)
    7  CLC    0.0342  0.4690  T270         (10c,eq)
...
   75  UNPK   0.0001  0.9856  T404         (5d)
   76  CVB    0.0001  0.9857  T400         
   77  O      0.0001  0.9858  T231  X 
```

with the columns
- **fi**: rank by frequency weight
- **inst**: instruction
- **fwt**: frequency weight
- **cwt**: cumulative frequency weight
- **tag**: test tag the instruction time is to be taken from
- **map**: indicates that an equivalent instruction is mapped in
- **comment**: indicates choices of tags

#### <a id="opt-help">-help</a>
Print help text and quit.

### <a id="mix">Available Mixes</a>
Currently only a single mix is available: lmix

#### <a id="mix-lmix">lmix: the Liba Svobodova mix from 1974</a>
The distribution was extracted from the very comprehensive report
> Computer System Performance Measurement:  
>   Instruction Set Processor Level and Microcode Level  
> by Liba Svobodova  
>   
> June 1974  
> Technical Report No. 66  
> Stanford Electronics Laborarories
>  
> http://i.stanford.edu/pub/cstr/reports/csl/tr/74/66/CSL-TR-74-66.pdf

The paper gives the normalized instruction frequencies. However, in
several important cases the instruction time depends on environment or
operands, the time of a `BC` can be much different for branch taken or
fall through, and the time for `MVC`, `CLC` and the like depend on
buffer size and match length. s370_perf tests all these cases, so some
assumptions had to be made for the weighting of these cases:
- all memory accesses are taken as aligned and same page
- `BC` and `BCR` are assumed to be 50% branch taken and 50% fall through
- `MVC`, `MVZ`, `MVN`, `TR`, `XC`, and `OC` act on 10 byte operands
- `CLC` acts on a 10 byte `ne` operands
- `LM` and `STM` act on a set of 6 registers
- for `EX` the time without target instruction is used
- `ZAP` and `TRT` act on 10 byte buffers
- `CP` acts on a 10 digit number
- `PACK` and `UNPK` act on a 5 digit number

s370_perf doesn't cover all S/370 non-privileged instructions,
it is assumed that
- `NI` and `OI` have the same timing as `XI`
- `N` and `O` have the same timing as `X`
- `OC` has the same timing as `XC`
- `BXH` has the same timing as `BXLE`

### <a id="usage">Usage</a>

To get a summary of cases simply
```
cd s370_perf/data
s370_perf_mark *.dat
```

### <a id="also">See also</a>
- [s370_perf](s370_perf.md) - IBM System/370 Instruction Timing Benchmark
- [s370_perf_ana](s370_perf_ana.md) - analyze s370_perf data
- [s370_perf_sum](s370_perf_sum.md) - summarize s370_perf data
- [s370_perf_sort](s370_perf_sort.md) - generate a sorted s370_perf data listing
