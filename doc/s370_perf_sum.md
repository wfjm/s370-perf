## s370_perf_sum: summarize s370_perf data 

### Table of content

- [Synopsis](#user-content-synopsis)
- [Description](#user-content-description)
- [Options](#user-content-options)
- [Usage](#user-content-usage)

### Synopsis <a name="synopsis"></a>
```
  s370_perf_sum [OPTIONS]... [FILE]...
```

### Description <a name="description"></a>
This script reads multiple [s370_perf_ana](s370_perf_ana.md) output files
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
- **tpinn**: instruction time from case nn
- **t../t01**: relative time, case nn normalized by the first case 01

See the description of
[-nrr](#user-content-opt-nrr),
[-nrx](#user-content-opt-nrx),
[-min](#user-content-opt-min),
[-w50](#user-content-opt-w50),
for options which allow to display other data fields,
and the description of
[-fmis](#user-content-opt-fmis) and
[-fsig](#user-content-opt-fsig)
for options to filter output lines.

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
| [-help](#user-content-opt-help)    | print help text and quit |

#### -nrr <a name="opt-nrr"></a>
Use the `n-rr` field instead of the `cor` field from the input data.
Instead of the absolute instruction time in ns the `LR` instruction normalized
relative time is used. This way the absolute speed of the hardware
is normalized out and systematic differences can be studied.
The output columns are labeled `nrr**` instead of `tpi**`.

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

#### -help <a name="opt-help"></a>
Print help text and quit.

### Usage <a name="usage"></a>

#### Compare absolute instruction times
To list the instruction times of test cases plus in addition the
time rations relative to the first case use
```
  s370_perf_sum -rat <file1> <file2> ...
```

#### Compare datasets from different systems
When comparing data from different systems it is interesting to check
whether the different instructions all show the same speed ratio or
whether there are significant differences. Relative speed differences
can be seen best when the absolute speed of the underlying hardware
normalized out by dividing all instruction times by the time for `LR`
with [-nrr](#user-content-opt-nrr) like in
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

This analysis can also be done with a normalization on the `L`
instruction time with the [-nrx](#user-content-opt-nrx) option.
