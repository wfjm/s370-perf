# Changelog: V0.50 -> HEAD

### Table of contents
- Current [HEAD](#user-content-head)
- Release [V0.80](#user-content-V0.80)
- Release [V0.60](#user-content-V0.60)
- Release [V0.50](#user-content-V0.50)

<!-- --------------------------------------------------------------------- -->
---
## HEAD <a name="head"></a>
### General Proviso
The HEAD version shows the current development. No guarantees that software or
the documentation is consistent.

### Summary
- s370_perf_mark: added, a script to derive MIPS ratings

<!-- --------------------------------------------------------------------- -->
---
## 2018-04-01: [V0.80](https://github.com/wfjm/s370-perf/releases/tag/V0.80) - rev 1005(wfjm) <a name="V0.80"></a>

### Summary
- s370_perf_ana:
  - cleanup ^L handling; add -dt,-dl,-du,-nonrr
  - re-organize code; use -w1 instead of -w2
  - add -tcal; support lt>2 (extended loop overhead correction)
  - add calculated tag lines (Dxxx)
- s370_perf_sum
  - add -ins (instruction name sorted output)
- s370_perf_ins
  - added, generates instruction name sorted s370_perf_sum listing
- s370_perf
  - use `REPINSN` instead of `REPINS5` and `REPINS2`
  - add tests for subtract (don't assume add and sub have same timing)
  - add MVC length cases (5d,15d,30d) to loop overhead subtraction
  - add DP test (now AP,SP,MP and DP are covered)
  - move loop closing BCTR in T302,T303 such that BCTR is always same page
  - add test for BR R (use 10 registers, structure like T302,T303)
  - some renames needed to have a logical test sequence:
    - ren T150->T151, T151->T154, T152->T155, T153->T156
    - ren T154->T157, T156->T167, T157->T168, T158->T169
    - add T150  MVC m,m (5c)
    - add T152  MVC m,m (15c)
    - add T153  MVC m,m (30c)
    - add T205  SR R,R
    - add T206  S R,m
    - add T207  SH R,m
    - add T208  SLR R,R
    - add T209  SL R,m
    - add T304  BR R
    - add T305  BR R (far)
    - ren T422->T424, T423->T425
    - add T422  SP m,m (10d)
    - add T423  SP m,m (30d)
    - add T426  MVC;DP m,m (10d)
    - add T427  MVC;DP m,m (30d)
    - ren T512->T514, T513->T515, T514->T516, T515->T517, T516->T520
    - ren T517->T521, T518->T522, T519->T523
    - add T512  SER R,R
    - add T513  SE R,m
    - ren T520->T530, T521->T531, T522->T532, T523->T533, T524->T534, T525->T535
    - ren T526->T536, T527->T537, T528->T538, T529->T539, T530->T540, T531->T541
    - ren T532->T544, T533->T545, T534->T546, T535->T547, T536->T550, T537->T551
    - ren T538->T552, T539->T553, T540->T560, T541->T561
    - add T542  SDR R,R
    - add T543  SD R,m
  - move init code out of inner loop for T510-T513,T540-T543,T560
  - fix minor issues in T551,T553
  - add and use more ltype codes; add `/TCOR`
  - rename summary files, use _and_ instead of _vs_ as separator
- *.JES
  - ASM step:  use `BUFSIZE(MAX)`, reduces WORK file accesses, lowers CPU time
  - LKED step: use `SIZE=(512000,122880)`, required to avoid `IEW0364` error

<!-- --------------------------------------------------------------------- -->
---
## 2018-03-16: [V0.60](https://github.com/wfjm/s370-perf/releases/tag/V0.60) - rev 1000(wfjm) <a name="V0.60"></a>

### Summary
- rename clib -> sios
- remove bin/hercjis; add instead whole herc-tools project as submodule
- s370_perf_ana:
  - print s370_perf version; add -raw,-t311,-t312
  - add -w2,-csv options; change -lrun to -nolrun
- s370_perf_sum:
  - add -rat option
  - print essential options; print file stats, w50 ect
- s370_perf
  - add T9**,T703; fix T232 text
  - add `/OPCF`, enables print of config file entries
  - re-organized PRAM and config file handling
  - add `STCK` time to `PERF003I` and `PERF004I` messages
  - add `PERF000I` version info message
  - run test `T102` as warmup before `/GAUT` processing or testing
  - use R11,R12 as base to allow 8k  main code
  - add SETB DISBAS to disable BAS/BASR tests
  - add /Cxxx, sets test used for GMUL (and warmup)
  - support /X*** wildcards for /Tnnn,/Ennn and /Dnnn
  - add config file handling
- rename 2018-01-03-rasp2b.dat -> 2018-01-03_rasp2b.dat

<!-- --------------------------------------------------------------------- -->
---
## 2018-02-03: [V0.50](https://github.com/wfjm/s370-perf/releases/tag/V0.50) - rev 981(wfjm) <a name="V0.50"></a>

### Summary
- first release. The GitHub project was mentioned in post [82874](https://groups.yahoo.com/neo/groups/hercules-390/conversations/topics/82874) to Yahoo! group [hercules-390](https://groups.yahoo.com/neo/groups/hercules-390/info) but not explicitly announced otherwise.
- the code was initially developed as part of the [mvs38j-langtest](https://github.com/wfjm/mvs38j-langtest) project under the name `perf_asm`, removed there with the commit [ab95f76](https://github.com/wfjm/mvs38j-langtest/commit/ab95f765f6a6b3979d79ab8f07d69b128911357a), and renamed to `s370_perf`.
