# Changelog: V0.50 -> HEAD

### Table of contents
- Current [HEAD](#user-content-head)
- Release [V0.50](#user-content-V0.50)
- Release [V0.60](#user-content-V0.60)

<!-- --------------------------------------------------------------------- -->
---
## HEAD <a name="head"></a>
### General Proviso
The HEAD version shows the current development. No guarantees that software or
the documentation is consistent.

### Summary

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
  - add /OPCF, enables print of config file entries
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
