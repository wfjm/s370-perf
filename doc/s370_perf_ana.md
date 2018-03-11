## s370_perf_ana: analyze s370_perf data 

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Options](#user-content-options)
- [Usage](#user-content-usage)

### Synopsis <a name="synopsis"></a>
```
  s370_perf_ana [OPTIONS]... [FILE]...
```

### Description <a name="description"></a>
This script processes the output of a set of [s370_perf](s370_perf.md) runs and
- extracts for each run the raw time for each test
- calculates the [distribution function](https://en.wikipedia.org/wiki/Cumulative_distribution_function)
  of raw times for each test
- determines the [median](https://en.wikipedia.org/wiki/Median) and the
  width for each test from the distribution function
- determines and subtracts a loop overhead correction

to determine the _time per instruction_ for each test. Using the median is
a good [robust estimator](https://en.wikipedia.org/wiki/Robust_statistics)
and insensitive to a small number of
[outliers](https://en.wikipedia.org/wiki/Outlier). Doing the loop overhead
subtraction based on the median values adds to the stability of the
analysis. The output is a test-by-test listing of the format
```
file name ----------------------------  GMUL  i-count  -- total time --   MIPS
2018-03-04-10:46:16_J5598_PERF-ASM.prt   196 2.44e+10  258.52s  4m18.52   94.3
2018-03-04-10:55:56_J5599_PERF-ASM.prt   196 2.44e+10  258.34s  4m18.34   94.4
2018-03-04-11:00:25_J5600_PERF-ASM.prt   196 2.44e+10  258.39s  4m18.39   94.3
2018-03-04-11:04:47_J5601_PERF-ASM.prt   193 2.40e+10  254.22s  4m14.22   94.4
...
Tag   Comment                : nt     min     max      cor   w50%    n-rr   n-rx
T100  LR R,R                 : 20     2.1     2.3     2.09   1.7%    1.00   0.28
T101  LA R,n                 : 20     2.8     2.9     2.76   0.6%    1.32   0.37
T102  L R,m                  : 20     7.6     7.9     7.53   1.0%    3.59   1.00
T103  L R,m (unal)           : 20     8.7     9.0     8.61   0.7%    4.11   1.14
T104  LH R,m                 : 20     9.2     9.5     9.13   1.0%    4.36   1.21
T105  LH R,m (unal3)         : 20     9.7    10.1     9.54   0.8%    4.56   1.27
...
```
The header section lists the processed runs with the columns
- **file name**: If multiple s370_perf runs are found in one file the file name
  is repeated several times.
- **GMUL**: GMUL used by this run. Helpful to see the GMUL variations when
  [s370_perf](s370_perf.md) was run with option
  [/GAUT](s370_perf.md#user-content-par-gaut).
- **i-count**: total number of instructions executed in this run.
- **total time**: elapsed time for this run, in two representations.
- **MIPS**: calculated as instruction count divided by run time.
  The [MIPS](https://en.wikipedia.org/wiki/Instructions_per_second) value
  is based in the instruction mix of the s370_perf tests enabled for the
  given run. In normal s370_perf operation a substantial amount of the total
  time is spend in slow instructions like `MVS` or decimal arithmetic.
  The MIPS value shown in this analysis is usually significantly lower
  than the usually advertised values, which are based on _typical_
  instruction mixes which give less weight to slow instructions.

The main body has the columns
- **Tag**: the s370_perf test name
- **Comment**: text describing this test
- **nt**: number of runs found in the input files
- **min**: the minimal raw time per instruction in ns
- **max**: the maximal raw time per instruction in ns
- **cor**: the time per instruction after subtracting the loop overhead, in ns
- **w50**: the 50% width of the raw time distribution in %
- **n-rr**: the time per instruction normalized to the `LR` instruction time
  (from T100)
- **n-rx**: the rime per instruction normalized to the `L` instruction time
  (from T102)

See the description of
[-ltpi](#user-content-opt-ltpi),
[-ldf](#user-content-opt-ldf), and
[-cp=p](#user-content-opt-cp)
for options which create additional output fields or components.

The `n-rr` and  `n-rx` columns allow to quickly compare to a
typical register-register and register-memory instruction.
For more in-depth and especially cross-system analysis use the
[s370_perf_sum](s370_perf_sum.md) script.

### Options <a name="options"></a> 

| Option | Description |
| ------ | :---------- |
| [-d1](#user-content-opt-d1)        | decrease time field precision |
| [-d3](#user-content-opt-d3)        | increase time field precision |
| [-w2](#user-content-opt-w2)        | increase w50 field precision (2 digit) |
| [-w3](#user-content-opt-w3)        | increase w50 field precision (3 digit) |
| [-nolcor](#user-content-opt-nolcor) | no loop (bctr/bct) timing correction |
| [-t311=t](#user-content-opt-t311)  | override time used for bctr loop correction |
| [-t312=t](#user-content-opt-t312)  | override time used for bct  loop correction |
| [-nolrun](#user-content-opt-nolrun) | suppress file/run statistics |
| [-ltpi](#user-content-opt-ltpi)    | list per run tpi values |
| [-ldf](#user-content-opt-ldf)      | list list tpi distribution function |
| [-raw](#user-content-opt-raw)      | show raw data |
| [-csv](#user-content-opt-csv)      | output in csv format for spreadsheet import |
| [-cp=p](#user-content-opt-cp)      | specify clock period (in ns) |
| [-cf=f](#user-content-opt-cf)      | specify clock frequency (in MHz) |
| [-cn=n](#user-content-opt-cn)      | number of clock phases |
| [-ttim](#user-content-opt-ttim)    | use test time field (instead of instruction time)
| [-help](#user-content-opt-help)    | print help text and quit |

#### -d1 <a name="opt-d1"></a>
Decrease the precision of the instruction time field from 2 to 1 decimal places,
helpful for slow systems.

#### -d3 <a name="opt-d3"></a>
Increase the precision of the instruction time field from 2 to 3 decimal places,
helpful for fast systems.

#### -w2 <a name="opt-w2"></a>
Increase the precision of the `w50` field from 1 to 2 decimal places,
helpful for systems with little run-to-run variation.

#### -w3 <a name="opt-w3"></a>
Increase the precision of the `w50` field from 1 to 3 decimal places,
helpful for very deterministic systems like a P/390.

#### -nolcor <a name="opt-nolcor"></a>
Disable correction of loop overhead, the instruction time is simply
calculated by dividing the test time by the number of instructions.
The output listing contains a `med` field with the plain median
values instead of the `cor` field.

#### -t311=t <a name="opt-t311"></a>
Specifies the instruction time for `BCTR` in ns, this value is used for
loop overhead corrections. By default the `BCTR` instruction time is
determined from test `T311`.

#### -t312=t <a name="opt-t312"></a>
Specifies the instruction time for `BCT` in ns, this value is used for
loop overhead corrections. By default the `BCT` instruction time is
determined from test `T312`.

#### -nolrun <a name="opt-nolrun"></a>
Suppress the file/run summary at the beginning of the output listing.

#### -ltpi <a name="opt-ltpi"></a>
Lists the input raw `tpi` values for each test. The values printed in the
order they are extracted from the input files, 5 values per line,
immediately following the line describing the test results.
A typical output looks like
```
T100  LR R,R                 : 20     2.1     2.3     2.09   1.7%    1.00   0.28
  tpi:     2.132     2.139     2.194     2.143     2.227
  tpi:     2.166     2.155     2.163     2.160     2.166
  tpi:     2.169     2.146     2.142     2.153     2.176
  tpi:     2.272     2.200     2.177     2.134     2.198
```

#### -ldf <a name="opt-ldf"></a>
Lists the distribution function of the input raw `tpi` values for each test.
This is done by printing the values in increasing order, smallest first,
5 values per line, immediately following the line describing the test results,
followed by time corresponding to the 25%, 50% and 75% point of the
distribution function. The 50% value is used as *median* values in
the analysis, the distribution width is determined from the difference
of the 75% and 25% point of the distribution function.
A typical output looks like
```
T100  LR R,R                 : 20     2.1     2.3     2.09   1.7%    1.00   0.28
  cdf:     2.132     2.134     2.139     2.142     2.143
  cdf:     2.146     2.153     2.155     2.160     2.163
  cdf:     2.166     2.166     2.169     2.176     2.177
  cdf:     2.194     2.198     2.200     2.227     2.272
  0.25:    2.145
  0.50:    2.164
  0.75:    2.181
```

The example is taken from the same input files as shown for
[-ltpi](#user-content-opt-ltpi), the key difference is that for `-ltpi`
the values are in input file order, while they are sorted for `-ldf`.

#### -raw <a name="opt-raw"></a>
Lists the raw input data instead of analyzed data in the format
```
Tag   Comment                : nt      lr  ig lt        raw   w50%
T100  LR R,R                 : 20   22000 100  1     216.45   1.7%
T101  LA R,n                 : 20   17000 100  1     283.50   0.6%
T102  L R,m                  : 20   13000  50  1     383.38   1.0%
T103  L R,m (unal)           : 20   12000  50  1     437.38   0.7%
T104  LH R,m                 : 20   10000  50  1     463.53   1.0%
...
```

with the columns
- **nt**: number of runs found in input files
- **lr**: _local repeat count_ of this test
- **ig**: _group count_ of this test
- **lt**: loop type of this test
- **raw**: the time per inner loop in ns, including the time of the
  loop closing `BCTR` or `BCT` instruction
- **w50**: 50% width of time distribution

The `lr`, `ig` and `lt` fields are taken 1-to-1 from the
[s370_perf output](s370_perf.md#user-content-output).
The `raw` time is calculated by `inst(usec)` field multiplying with `ig`.


#### -csv <a name="opt-csv"></a>
Output in [csv](https://en.wikipedia.org/wiki/Comma-separated_values) format
for [spreadsheet](https://en.wikipedia.org/wiki/Spreadsheet) import.
The fields are delimted by a '|' character instead of blanks or ':', like
```
Tag | Comment                | nt|    min|    max|     cor|  w50%|   n-rr|  n-rx
T100| LR R,R                 | 20|    2.1|    2.3|    2.09|  1.7%|   1.00|  0.28
T101| LA R,n                 | 20|    2.8|    2.9|    2.76|  0.6%|   1.32|  0.37
T102| L R,m                  | 20|    7.6|    7.9|    7.53|  1.0%|   3.59|  1.00
T103| L R,m (unal)           | 20|    8.7|    9.0|    8.61|  0.7%|   4.11|  1.14
...
```

instead of the default

```
Tag   Comment                : nt     min     max      cor   w50%    n-rr   n-rx
T100  LR R,R                 : 20     2.1     2.3     2.09   1.7%    1.00   0.28
T101  LA R,n                 : 20     2.8     2.9     2.76   0.6%    1.32   0.37
T102  L R,m                  : 20     7.6     7.9     7.53   1.0%    3.59   1.00
T103  L R,m (unal)           : 20     8.7     9.0     8.61   0.7%    4.11   1.14
...
```

Only header and test lines are printed, all other output is suppressed.
This option thus implies [-nolrun](#user-content-opt-nolrun) and disables
[-ltpi](#user-content-opt-ltpi) and [-ldf](#user-content-opt-ldf).


#### -cp=p <a name="opt-cp"></a>
Allows to specify a CPU clock period in ns. Useful for real CPUs like a
P/390 which have a well defined and known cycle time. When a clock period
is specified via `-cp` or `-cf` the number of clock cycles are determined
for each instruction. The output format is extended to
```
Tag   Comment                : nt     min     max      cor   w50%    n-rr   n-rx    n-cp  e-cp%   mcc
T100  LR R,R                 : 10    58.9    59.0    57.15 0.174%    1.00   0.33    1.00     0%     1
T101  LA R,n                 : 10    60.0    60.3    58.54 0.038%    1.02   0.34    1.02     2%     1
T102  L R,m                  : 10   178.0   178.2   174.70 0.027%    3.06   1.00    3.06     5%     3
T103  L R,m (unal)           : 10   236.1   237.6   232.78 0.044%    4.07   1.33    4.07     7%     4
...
```

with three additional columns
- **n-cp**: number of clock cycles, calculated dividing the instruction time
  shown in the `cor` column by the clock period.
- **e-cp**: show how much of the clock cycle number is from an integer value,
  given in percent of the clock period.
- **mcc**: the `n-cp` value rounded to the nearest integer.


#### -cf=f <a name="opt-cf"></a>
Allows to specify a CPU clock frequency in MHz. Value will be converted
to a CPU clock period, see [-cp=p](#user-content-opt-cp) for more details.

#### -cn=m <a name="opt-cn"></a>
Allows to specify the number of clock phases for systems with a multi-phase
clock. The analysis calculates now
- **mcc** major clock cycles
- **scc** sub clock cycles

The output format further is extended to
```
Tag   Comment                : nt     min     max      cor   w50%    n-rr   n-rx    n-cp  e-cp%   mcc   scc
T100  LR R,R                 : 10    58.9    59.0    57.72 0.174%    1.00   0.33    4.05     4%     1     0
T101  LA R,n                 : 10    60.0    60.3    59.11 0.038%    1.02   0.34    4.15    14%     1     0
T102  L R,m                  : 10   178.0   178.2   175.84 0.027%    3.05   1.00   12.33    33%     3     0
T103  L R,m (unal)           : 10   236.1   237.6   233.93 0.044%    4.05   1.33   16.40    40%     4     0
```

This option was introduced when analyzing data from a P/390 system, which has
a four phase clock, but turned out not to be useful. 

#### -ttim <a name="opt-ttim"></a>
Use the `test(s)` field instead of the `inst(usec)` field of the
[s370_perf output](s370_perf.md#user-content-output).
Useful for debugging.

#### -help <a name="opt-help"></a>
Print help text and quit.

### Usage <a name="usage"></a>
s370_perf_ana can process printer output files as they come from MVS.
It is able to extract multiple s370_perf runs from a single input file.

To analyze a set of s370_perf job print output files simply use
```
  s370_perf_ana *PERF*.prt
```
