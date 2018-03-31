## s370_perf_ins: generate 'by instruction' sorted s370_perf data

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Usage](#user-content-usage)

### Synopsis <a name="synopsis"></a>
```
  s370_perf_ins [FILE]...
```

### Description <a name="description"></a>
This script reads a [s370_perf_ana](s370_perf_ana.md) output file, which
is ordered by tag names, selects only lines which give the timing of a
single instruction, and prints these lines ordered by instruction
mnemonic. A typical output looks like
```
s370_perf version: s370_perf V0.9.5  rev  998  2018-03-04

Tag   Comment                : nr     min     max      tpi   w50%    n-rr   n-rx
T201  A R,m                  : 20     9.4     9.6     9.28  0.94%    4.43   1.23
T541  AD R,m                 : 20    19.1    19.4    19.05  0.77%    9.10   2.53
T540  ADR R,R                : 20    14.3    14.6    14.19  0.79%    6.78   1.89
T511  AE R,m                 : 20    18.2    18.5    18.11  0.75%    8.65   2.41
T510  AER R,R                : 20    13.1    13.4    12.96  0.68%    6.19   1.72
T202  AH R,m                 : 20    10.1    10.3     9.98  0.65%    4.77   1.33
...
T261  C R,m                  : 20     8.8     9.0     8.72  0.47%    4.16   1.16
T551  CD R,m                 : 20    17.9    18.4    18.20  0.69%    8.69   2.42
T550  CDR R,R                : 20    12.0    12.3    11.90  0.71%    5.68   1.58
D295  CDS R,R,m (eq,eq)      : 20       -       -    39.36  0.77%   18.80   5.23
D296  CDS R,R,m (eq,ne)      : 20       -       -    39.40  0.70%   18.82   5.24
D297  CDS R,R,m (ne)         : 20       -       -   179.75  0.94%   85.85  23.88
T521  CE R,m                 : 20    16.8    17.3    16.75  0.97%    8.00   2.23
T520  CER R,R                : 20    11.1    11.2    10.96  0.60%    5.24   1.46
...
T232  XI m,i                 : 20     9.9    10.0     9.76  0.94%    4.66   1.30
T230  XR R,R                 : 20     3.2     3.4     3.19  0.70%    1.52   0.42
T440  ZAP m,m (10d,10d)      : 20   100.4   103.1   100.39  0.49%   47.95  13.34
T441  ZAP m,m (30d,30d)      : 20   100.4   102.4   100.46  0.55%   47.98  13.35
T442  ZAP m,m (10d,30d)      : 20   100.5   102.3   100.83  0.58%   48.16  13.40
T443  ZAP m,m (30d,10d)      : 20   100.2   101.5   100.25  0.35%   47.88  13.32
```

### Usage <a name="usage"></a>
s370_perf_ins is usually used with a single file name. If no file name is
specified it acts as a filter and reads from `STDIN`.
