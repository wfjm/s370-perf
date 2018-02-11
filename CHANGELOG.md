# Changelog: V0.50 -> HEAD

### Table of contents
- Current [HEAD](#user-content-head)
- Release [V0.50](#user-content-V0.50)

<!-- --------------------------------------------------------------------- -->
---
## HEAD <a name="head"></a>
### General Proviso
The HEAD version shows the current development. No guarantees that software or
the documentation is consistent.

### Summary

- s370_perf
  - add `STCK` time to `PERF003I` and `PERF004I` messages
  - add `PERF000I` version info message
  - run test `T102` as warmup before `/GAUT` processing or testing
- rename 2018-01-03-rasp2b.dat -> 2018-01-03_rasp2b.dat

<!-- --------------------------------------------------------------------- -->
---
## 2018-02-03: [V0.50](https://github.com/wfjm/s370-perf/releases/tag/V0.50) - rev 981(wfjm) <a name="V0.50"></a>

### Summary
- first release. The GitHub project was mentioned in post [82874](https://groups.yahoo.com/neo/groups/hercules-390/conversations/topics/82874) to Yahoo! group [hercules-390](https://groups.yahoo.com/neo/groups/hercules-390/info) but not explicitly announced otherwise.
- the code was initially developed as part of the [mvs38j-langtest](https://github.com/wfjm/mvs38j-langtest) project under the name `perf_asm`, removed there with the commit [ab95f76](https://github.com/wfjm/mvs38j-langtest/commit/ab95f765f6a6b3979d79ab8f07d69b128911357a), and renamed to `s370_perf`.
