## s370_perf_sum: summarize s370_perf data 

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Options](#user-content-options)
- [Usage](#user-content-usage)
- [See also](#user-content-also)

### Synopsis <a name="synopsis"></a>
```
  s370_perf_sum [OPTIONS]... [FILE]...
```

### Description <a name="description"></a>
s370_perf_sum reads multiple [s370_perf_ana](s370_perf_ana.md) output files
and allows to a create compact, one line per [s370_perf](s370_perf.md) test,
listing summarizing and comparing the benchmark cases.
The output format is, for an example with three input files and using
the [-rat](#user-content-opt-rat) option
```
File num: name ----------------------------------- #test w50-avr  w50-max
      01: 2018-03-04_sys2.dat                        275   0.69%     3.8%
      02: 2018-01-09_nbk2.dat                        205   2.19%     8.3%
      03: 2018-01-03_rasp2b.dat                      205   0.69%     7.4%

Tag   Comment                :     tpi01     tpi02     tpi03 :  t02/t01  t03/t01
T100  LR R,R                 :      2.09      3.56     28.98 :    1.703   13.866
T101  LA R,n                 :      2.76      4.10     49.77 :    1.486   18.033
T102  L R,m                  :      7.53     11.94    130.93 :    1.586   17.388
T103  L R,m (unal)           :      8.61     15.04    138.38 :    1.747   16.072
T104  LH R,m                 :      9.13     15.19    142.14 :    1.664   15.568
T105  LH R,m (unal3)         :      9.54     15.81    146.03 :    1.657   15.307
...
```

The header section lists the input files plus some statistics
- **#test**: number of s370_perf tests found in this file
- **w50-avr**: average distribution width in %, good to judge data quality
- **w50-max**: maximal distribution width in %

The main body has the columns
- **Tag**: the s370_perf test name
- **Comment**: text describing this test
- **tpi..**: instruction time from case nn
- **t../t01**: relative time, case nn normalized by the first case 01

See the description of
[-nrr](#user-content-opt-nrr),
[-nrx](#user-content-opt-nrx),
[-min](#user-content-opt-min), and
[-w50](#user-content-opt-w50) 
for options which allow to display other data fields,
the description of
[-fmis](#user-content-opt-fmis) and
[-fsig](#user-content-opt-fsig)
for options to filter output lines, and the description of
[-k](#user-content-opt-k),
[-r](#user-content-opt-r), and
[-i](#user-content-opt-i) for options to sort the output.


### Options <a name="options"></a> 

| Option | Description |
| ------ | :---------- |
| [-nrr](#user-content-opt-nrr)      | use n-rr (T100 normalized) |
| [-nrx](#user-content-opt-nrx)      | use n-rx (T102 normalized) |
| [-min](#user-content-opt-min)      | use min  (minimal time) |
| [-w50](#user-content-opt-w50)      | use w50  (50% distribution width) |
| [-rel](#user-content-opt-rel)      | show relative speed for each tag |
| [-rat](#user-content-opt-rat)      | show in addition ratios relative to 1st file |
| [-fmis[=n]](#user-content-opt-fmis) | drop test line when n values missing |
| [-fsig[=n]](#user-content-opt-fsig) | show test line only when differing by n percent |
| [-k=key](#user-content-opt-k)      | select sort criterion |
| [-r](#user-content-opt-r)          | reverse sorting order |
| [-i](#user-content-opt-i)          | select instruction time lines |
| [-help](#user-content-opt-help)    | print help text and quit |

#### -nrr <a name="opt-nrr"></a>
Use the `n-rr` field instead of the `cor` field from the input data.
Instead of the absolute instruction time in ns the `LR` instruction normalized
relative time is used. This way the absolute speed of the hardware
is normalized out and systematic differences can be studied.
The output columns are labeled `nrr**` instead of `tpi**`.
See [example](#user-content-exa-nrr) for usage of `-nrr`.

#### -nrx <a name="opt-nrx"></a>
Use the `n-rx` field instead of the `cor` field from the input data.
Like for [-nrr](#user-content-opt-nrr), but with `L` instruction normalized
relative time.
The output columns are labeled `nrx**` instead of `tpi**`.

#### -min <a name="opt-min"></a>
Use the `min` field instead of the `cor` field from the input data.
Useful for debugging, use the minimal instead of the median time.
Caveat is that in this case no loop overhead is subtracted.
The output columns are labeled `min**` instead of `tpi**`.

#### -w50 <a name="opt-w50"></a>
Use the `w50` field instead of the `cor` field from the input data.
Useful for debugging, to visualize the distribution width.
The output columns are labeled `w50_**` instead of `tpi**`.

#### -rel <a name="opt-rel"></a>
Will determine, for each  test independently, the minimal value and
normalize the data to this minimal value. The fastest case has per
construction a value of 1., all others are >= 1., the value indicating
how much slower a case is compared to the fastest one.
Note that this can be combined with [-nrr](#user-content-opt-nrr)
or [-nrx](#user-content-opt-nrx).

#### -rat <a name="opt-rat"></a>
Adds columns with ratios relative to the 1st file. This allows to have the
absolute instruction times and ratios in one output file.
Note that proper choice of file order is important here as the 1st
one is used as normalization and thus as reference case.

#### -fmis[=n] <a name="opt-fmis"></a>
The input files may contain different sets of tests, e.g. because
they contain data of different s370_perf revisions. When data is missing
for an input file '  -' is written into the summary output. 
If `-fmis=n` is specified tests lines are dropped when n or more values
are missing. A `-fmis=1`, which can be abbreviated to `-fmis`, will drop
all tests which are missing in one or more input files.

#### -fsig[=n] <a name="opt-fsig"></a>
Show test line only when differing by at least n percent. This option is
very helpful when comparing two test campaigns on the same system to verify
the reproducibility. With `-fsig=1`, which can be abbreviated to `-fsig`,
only tests where one case differs by at least 1 percent are listed.

#### -k=key <a name="opt-k"></a>
Selects the sorting criterion, if no `-k` option is given `-k=tag` is assumed.
Supported `key` values are
- **tag** - the s370_perf test id (Tnnn) or calculation id (Dnnn). In most
  cases this simply reproduces the input file because  normal s370_perf_ana
  output is sorted by test id.
- **ins** - selects only tests which give the timing of a single instruction,
  and prints these tests ordered by instruction mnemonic.
- **vN** - sort by value of N'th file, e.g. v1,v2,...
- **rN** - sort by ratio for N'th file, e.g. r2,...

See [example](#user-content-exa-k) for usage of `-k=r2`.

#### -r <a name="opt-r"></a>
The default sorting order is ascending, this option reverses the sorting order
to descending. Supported only for value (like `-k=v1`) and ratio sorts
(line `-k=r2`).

#### -i <a name="opt-i"></a>
Selects only tests which give the timing of a single instruction. All composite
and auxiliary tests are removed. 

#### -help <a name="opt-help"></a>
Print help text and quit.

### Usage <a name="usage"></a>

#### Compare absolute instruction times <a name="exa-rat"></a>
To list the instruction times of test cases plus the time rations relative
to the first case use
```
  s370_perf_sum -rat <file1> <file2> ...
```

An example output is shown in the
[description section](#user-content-description).

#### Compare datasets from different systems - use -nrr  <a name="exa-nrr"></a>
When comparing data from different systems it is interesting to check
whether the different instructions all show the same speed ratio or
whether there are significant differences. Relative speed differences
can be seen best when the absolute speed of the underlying hardware
normalized out by dividing all instruction times by the time for `LR`
with the [-nrr option](#user-content-opt-nrr), like in
```
  s370_perf_sum -nrr -rat <file1> <file2> ...
```

The value listed for `T100` is now by construction 1.00, the ratio in the last
column(s) is now a double ratio
```
 ( tpi(test,filex) / tpi(T100,filex) ) / ( tpi(test,file1) / tpi(T100,file1) )
```

which equivalent to
```
 ( tpi(test,filex) / tpi(test,file1) ) / ( tpi(T100,filex) / tpi(T100,file1) )
```
which indicates the variation of the relative speed difference.
A practical example is given in the narrative for dataset
[2018-01-03_rasp2b](../narr/2018-01-03_rasp2b.md).

The body of the output looks like (same data as shown in
[description section](#user-content-description))
```
Tag   Comment                :     nrr01     nrr02     nrr03 :  t02/t01  t03/t01
T100  LR R,R                 :      1.00      1.00      1.00 :    1.000    1.000
T101  LA R,n                 :      1.32      1.15      1.72 :    0.871    1.303
T102  L R,m                  :      3.59      3.35      4.52 :    0.933    1.259
T103  L R,m (unal)           :      4.11      4.22      4.77 :    1.027    1.161
T104  LH R,m                 :      4.36      4.27      4.90 :    0.979    1.124
T105  LH R,m (unal3)         :      4.56      4.44      5.04 :    0.974    1.105
T106  LTR R,R                :      1.68      1.47      1.31 :    0.875    0.780
T107  LCR R,R                :      1.73      1.46      1.50 :    0.844    0.867
...
```

This analysis can also be done with a normalization on the `L`
instruction time with the [-nrx option](#user-content-opt-nrx).

#### Compare datasets from different systems - use -k  <a name="exa-k"></a>
For a quick overview of what is faster or slower it helps to sort the output
by the speed ratio with the [-k option](#user-content-opt-k), like in
```
  s370_perf_sum -rat -k r2 <file1> <file2> ...
```

which gives an output like
```
File num: name ----------------------------------- #test w50-avr  w50-max
      01: 2018-03-31_sys2.dat                        330   0.83%     4.5%
      02: 2018-04-02_rasp2b.dat                      330   0.69%    15.8%

Tag   Comment                :     tpi01     tpi02 :  t02/t01
T156  MVC m,m (250c,over1)   :    351.62   1140.12 :    3.242
T276  CLC m,m (250c,eq)      :    165.90    667.73 :    4.025
T274  CLC m,m (100c,eq)      :     83.62    431.75 :    5.163
D610  EX R,i (bare, via TM)  :     21.75    133.29 :    6.128
D611  EX R,i (bare, via XI)  :     20.85    132.73 :    6.366
...
D215  DR R,R                 :     14.72    498.06 :   33.836
T600  STCK m                 :     65.48   2838.00 :   43.341
T547  DD R,m                 :    156.37   7336.85 :   46.920
T546  DDR R,R                :    152.40   7254.83 :   47.604
T401  CVD R,m                :     36.04   6177.14 :  171.397
```

Using in addition the [-nrr option](#user-content-opt-nrr) helps to see
the relative trends better, and the [-i option](#user-content-opt-i) helps
to focus in the instruction timings, like in
```
  s370_perf_sum -nrr -rat -i -k r2 <file1> <file2> ...
```

which gives an output like (same files as above)
```
Tag   Comment                :     nrr01     nrr02 :  t02/t01
T156  MVC m,m (250c,over1)   :    168.33     39.42 :    0.234
T276  CLC m,m (250c,eq)      :     79.42     23.09 :    0.291
T274  CLC m,m (100c,eq)      :     40.03     14.93 :    0.373
D610  EX R,i (bare, via TM)  :     10.41      4.61 :    0.443
D611  EX R,i (bare, via XI)  :      9.98      4.59 :    0.460
T304  BR R                   :      3.21      1.67 :    0.520
...
T600  STCK m                 :     31.35     98.12 :    3.130
T547  DD R,m                 :     74.86    253.67 :    3.389
T546  DDR R,R                :     72.95    250.83 :    3.438
T401  CVD R,m                :     17.25    213.57 :   12.381
```
### See also <a name="also"></a>
- [s370_perf](s370_perf.md) - IBM System/370 Instruction Timing Benchmark
- [s370_perf_ana](s370_perf_ana.md) - analyze s370_perf data
- [s370_perf_sort](s370_perf_sort.md) - generate a sorted s370_perf data listing
- [s370_perf_mark](s370_perf_mark.md) - derive MIPS ratings from s370_perf data

