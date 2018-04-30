## s370_perf_sort: generate a sorted s370_perf data listing

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Options](#user-content-options)
- [Usage](#user-content-usage)

### Synopsis <a name="synopsis"></a>
```
  s370_perf_sort [OPTIONS]... [FILE]
```

### Description <a name="description"></a>
s370_perf_sort reads a [s370_perf_ana](s370_perf_ana.md) output file, which is
ordered by tag names, and generates a listing sorted by a criterion defined by
the [-k option](#user-content-opt-k), for example
[by instruction mnemonic](#user-content-exa-ins) with `-k=ins`,
[by instruction time](#user-content-exa-tpi) with `-k=tpi`, or
for real CPUs even [by cycle count](#user-content-exa-mcc) with `-k=mcc`.
The sorting order can be reversed with the [-r option](#user-content-opt-r).
The option syntax was obviously insprired by
[sort(1)](http://man7.org/linux/man-pages/man1/sort.1.html).

s370_perf_sort is used with at most one file name. If no file name is
specified it acts as a filter and reads from `STDIN`.

### Options <a name="options"></a> 
| Option | Description |
| ------ | :---------- |
| [-k=key](#user-content-opt-k)   | select sort key |
| [-r](#user-content-opt-r)       | reverse sorting order |
| [-i](#user-content-opt-i)       | select instruction time lines |
| [-help](#user-content-opt-help) | print help text and quit |

#### -k=key <a name="opt-k"></a>
Selects the sorting criterion, if no `-k` option is given `-k=tag` is assumed.
Supported `key` values are
- **tag** - the s370_perf test id (Tnnn) or calculation id (Dnnn). In most
  cases this simply reproduces the input file because  normal s370_perf_ana
  output is sorted by test id.
- **ins** - selects only tests which give the timing of a single instruction,
  and prints these tests ordered by instruction mnemonic. 
- **min**: the minimal raw time in ns (before loop overhead correction)
- **max**: the maximal raw time in ns
- **tpi**: the time per instruction after subtracting the loop overhead, in ns
- **w50**: the 50% width of the raw time distribution in %
- **nrr**: the time per instruction normalized to the `LR` instruction time
  (from T100)
- **nrx**: the rime per instruction normalized to the `L` instruction time
  (from T102)

For input files generated by s370_perf_ana with the
[-cp option](s370_perf_ana.md#user-content-opt-cp) or the
[-cf option](s370_perf_ana.md#user-content-opt-cf) three additional
`key` values are supported
- **ncp**: number of clock cycles, calculated dividing the instruction time
  shown in the `tpi` column by the clock period.
- **ecp**: show how much of the clock cycle number is from an integer value,
  given in percent of the clock period.
- **mcc**: the `n-cp` value rounded to the nearest integer.

#### -r <a name="opt-r"></a>
The default sorting order is ascending, this option reverses the sorting order
to descending.

#### -i <a name="opt-i"></a>
Selects only tests which give the timing of a single instruction. All composite
and auxiliary tests are removed. Also selects the instruction mnemonic is
as secondary sorting criterion instead of the tag name.

#### -help <a name="opt-help"></a>
Print help text and quit.

### Usage <a name="usage"></a>

#### Generate _'by instruction name'_ sorted s370_perf data <a name="exa-ins"></a>
To generate a listing ordered by instruction mnemonic use
```
  s370_perf_sort -k=ins <file>
```

A typical output looks like
```
s370_perf version: s370_perf V0.9.5  rev  998  2018-03-04

Tag   Comment                : nr     min     max      tpi   w50%    n-rr   n-rx
T201  A R,m                  : 92     9.4     9.7     9.33  0.99%    4.47   1.25
T541  AD R,m                 : 92    20.7    21.3    20.65  0.79%    9.88   2.76
T540  ADR R,R                : 92    15.5    15.9    15.43  0.88%    7.39   2.07
T511  AE R,m                 : 92    19.6    20.1    19.59  0.73%    9.38   2.62
T510  AER R,R                : 92    14.6    15.1    14.56  0.86%    6.97   1.95
T202  AH R,m                 : 92    10.1    10.4    10.03  0.91%    4.80   1.34
...
T261  C R,m                  : 92     8.8     9.1     8.70  0.70%    4.16   1.16
T551  CD R,m                 : 92    18.2    18.6    18.15  0.73%    8.69   2.43
T550  CDR R,R                : 92    12.0    12.4    11.94  0.87%    5.71   1.60
D295  CDS R,R,m (eq,eq)      : 92       -       -    39.36  0.96%   18.84   5.27
D296  CDS R,R,m (eq,ne)      : 92       -       -    39.40  0.91%   18.86   5.27
D297  CDS R,R,m (ne)         : 92       -       -   176.49  0.98%   84.49  23.62
T521  CE R,m                 : 92    16.8    17.4    16.78  0.95%    8.03   2.25
T520  CER R,R                : 92    11.0    11.3    10.98  0.75%    5.26   1.47
...
T232  XI m,i                 : 92     9.9    10.3     9.77  0.86%    4.68   1.31
T230  XR R,R                 : 92     3.2     3.3     3.20  0.81%    1.53   0.43
T440  ZAP m,m (10d,10d)      : 92   100.3   103.1   100.57  0.73%   48.14  13.46
T441  ZAP m,m (30d,30d)      : 92   100.3   103.5   100.61  0.79%   48.16  13.46
T442  ZAP m,m (10d,30d)      : 92   100.5   102.8   100.87  0.77%   48.29  13.50
T443  ZAP m,m (30d,10d)      : 92   100.2   106.0   100.39  0.77%   48.06  13.44
```

#### Generate _'by instruction time'_ sorted s370_perf data  <a name="exa-tpi"></a>
To generate a listing ordered by instruction time use
```
  s370_perf_sort -i -k=tpi <file>
```

The [-i option](#user-content-opt-i) is useful to select only instruction
time tests and remove composite and auxiliary tests which would clutter
the listing.

A typical output looks like
```
s370_perf version: s370_perf V0.9.7  rev 1003  2018-03-30

Tag   Comment                : nr     min     max      tpi   w50%    n-rr   n-rx
T100  LR R,R                 : 92     2.1     2.3     2.09  1.31%    1.00   0.28
T301  BNZ l (no br)          : 92     2.2     2.2     2.11  0.93%    1.01   0.28
T300  BCR 0,0 (noop)         : 92     2.5     2.6     2.49  0.87%    1.19   0.33
T263  CLR R,R                : 92     2.6     2.6     2.51  0.97%    1.20   0.34
T260  CR R,R                 : 92     2.6     2.7     2.56  0.76%    1.23   0.34
T101  LA R,n                 : 92     2.8     2.9     2.77  0.97%    1.32   0.37
...
D411  ED (30c)               : 92       -       -   389.96  1.29%  186.68  52.19
D426  DP m,m (10d)           : 92       -       -   442.87  0.92%  212.01  59.27
T169  MVCIN m,m (100c)       : 92   665.6   682.7   667.17  0.76%  319.38  89.29
T256  TRT m,m (100c,zero)    : 92   779.8   800.0   782.46  0.83%  374.57 104.72
T259  TRT m,m (250c,100b)    : 92   795.6   818.3   799.32  0.93%  382.64 106.98
D282  CLCL (4kb,100b)        : 92       -       -   870.45  0.95%  416.69 116.50
D427  DP m,m (30d)           : 92       -       -  1030.89  0.65%  493.50 137.97
T257  TRT m,m (250c,zero)    : 92  1927.1  1980.6  1936.51  0.42%  927.03 259.17
D283  CLCL (4kb,250b)        : 92       -       -  2134.36  0.65% 1021.74 285.65
```

#### Generate _'by major cycle count'_ sorted s370_perf data  <a name="exa-mcc"></a>
For systems which have a well defined cycle time s370_perf_ana is usually
used with the [-cp option](s370_perf_ana.md#user-content-opt-cp) or the
[-cf option](s370_perf_ana.md#user-content-opt-cf). To generate a listing
ordered by _major cycle count_ use
```
  s370_perf_sort -i -k=mcc <file>
```

The [-i option](#user-content-opt-i) ensures that instruction mnemonic is
used as secondary sort criterion, so output is first grouped by `mcc` and
than by `ins`. A typical output looks like
```
s370_perf version: s370_perf V0.9.2  rev  993  2018-02-10  

Tag   Comment                : nr     min     max      tpi   w50%    n-rr   n-rx    n-cp  e-cp%   mcc
T203  ALR R,R                : 10    58.8    59.1    57.35 0.398%    1.00   0.33    1.00     0%     1
T200  AR R,R                 : 10    58.8    59.1    57.42 0.034%    1.00   0.33    1.00     0%     1
T300  BCR 0,0 (noop)         : 10    58.9    59.1    57.33 0.310%    1.00   0.33    1.00     0%     1
...
T239  OR R,R                 : 10    58.8    59.1    57.40 0.411%    1.00   0.33    1.00     0%     1
T230  XR R,R                 : 10    58.8    59.1    57.39 0.365%    1.00   0.33    1.00     0%     1
T311  BCTR R,R               : 10   114.1   114.7   114.19 0.029%    2.00   0.65    2.00     0%     2
T530  LDR R,R                : 10   115.5   116.0   113.97 0.357%    1.99   0.65    1.99     0%     2
...
T257  TRT m,m (250c,zero)    : 10 36692.5 44104.5 36843.45 14.45%  644.65 210.90  644.85   -15%   645
T254  TR m,m (250c)          : 10 36949.6 44296.2 36945.38 14.86%  646.44 211.48  646.63   -36%   647
D174  MVCL (4kb)             : 10       -       - 61139.53 0.077% 1069.76 349.97 1070.09     8%  1070
```