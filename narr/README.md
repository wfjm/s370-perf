This directory contains the narrative for s370_perf test data,
tbe currently available test cases are

| Date | Host | System | Case narrative | Comment |
| ---- | ---- | ------ | -------------- | ------- |
| 1964-05-01 | n/a  | S/360 70 | [1964-05-01_s360-70](1964-05-01_s360-70.md) | System/360 Model 70 as _paper reference_ |
| 2017-11-30 | n/a  | [P/390](sysinfo_p390.md) | [2017-11-30_p390](2017-11-30_p390.md) | first P/390 data |
| 2018-01-03 | [rasp2b](hostinfo_rasp2b.md) | Herc tk4- | [2018-01-03_rasp2b](2018-01-03_rasp2b.md) | first Raspberry/ARMv7 data|
| 2018-01-13 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-01-13_sys2-b](2018-01-13_sys2-b.md) | early reference data |
| 2018-01-14 | [sys1](hostinfo_sys1.md) | Herc tk4- | [2018-01-14_sys1-a](2018-01-14_sys1-a.md) | before Meltdown kernel patch |
| 2018-01-14 | [sys1](hostinfo_sys1.md) | Herc tk4- | [2018-01-14_sys1-b](2018-01-14_sys1-b.md) | after Meltdown kernel patch |
| 2018-01-21 | [nbk2](hostinfo_nbk2.md) | Herc tk4- | [2018-01-21_nbk2-a](2018-01-21_nbk2-a.md) | before Meltdown kernel patch |
| 2018-01-21 | [nbk2](hostinfo_nbk2.md) | Herc tk4- | [2018-01-21_nbk2-b](2018-01-21_nbk2-b.md) | after Meltdown kernel patch |
| 2018-02-14 | n/a  | [P/390](sysinfo_p390.md) | [2018-02-14_p390](2018-02-14_p390.md) | first complete P/390 data |
| 2018-03-04 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-03-04_sys2](2018-03-04_sys2.md) | data with close-to-final s370_perf |
| 2018-03-10 |      | z/PDT 1.7 | [2018-03-10_zpdt](2018-03-10_zpdt.md) | z/PDT V1.7 observations |
| 2018-03-31 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-03-31_sys2](2018-03-31_sys2.md) | **reference data** with final s370_perf |
| 2018-03-31 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-03-31_sys2-1cpu](2018-03-31_sys2-1cpu.md) | with NUMCPU=1 MAXCPU=1 |
| 2018-03-31 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-03-31_sys2-g001](2018-03-31_sys2-g001.md) | with /G001 |
| 2018-03-31 | [sys2](hostinfo_sys2.md) | Herc tk4- | [2018-03-31_sys2-orip](2018-03-31_sys2-orip.md) | with /ORIP |
| 2018-03-31 | [sys1](hostinfo_sys1.md) | Herc tk4- | [2018-03-31_sys1-3g](2018-03-31_sys1-3g.md) | with cpufreq-set 3GHz |
| 2018-03-31 | [sys1](hostinfo_sys1.md) | Herc tk4- | [2018-03-31_sys1-od](2018-03-31_sys1-od.md) | with cpufreq-set ondemand |
| 2018-04-01 | [sys1](hostinfo_sys1.md) | Herc tk4- | [2018-04-01_sys1-08](2018-04-01_sys1-08.md) | with tk4- 08 |
| 2018-04-01 | [nbk1](hostinfo_nbk1.md) | Herc tk4- | [2018-04-01_nbk1](2018-04-01_nbk1.md) | |
| 2018-04-01 | [nbk2](hostinfo_nbk2.md) | Herc tk4- | [2018-04-01_nbk2](2018-04-01_nbk2.md) | |
| 2018-04-01 | [srv1](hostinfo_srv1.md) | Herc tk4- | [2018-04-01_srv1](2018-04-01_srv1.md) | Turbo disabled in BIOS |
| 2018-04-02 | [rasp2b](hostinfo_rasp2b.md) | Herc tk4- | [2018-04-02_rasp2b](2018-04-02_rasp2b.md) | |
| 2018-04-07 | [srv1](hostinfo_srv1.md) | Herc tk4- | [2018-04-07_srv1-od](2018-04-07_srv1-od.md) | with governor = ondemand |
| 2018-04-07 | [srv1](hostinfo_srv1.md) | Herc tk4- | [2018-04-07_srv1-pf](2018-04-07_srv1-pf.md) | with governor = performance |
| 2018-04-16 | [pogoe2](hostinfo_pogoe2.md) | Herc tk4- | [2018-04-16_pogoe2](2018-04-16_pogoe2.md) | |
| 2018-04-16 | n/a  | [P/390](sysinfo_p390.md) | [2018-04-16_p390](2018-04-16_p390.md) | with final s370_perf |
| 2018-04-20 | [srv2](hostinfo_srv2.md) | Herc tk4- | [2018-04-20_srv2](2018-04-20_srv2.md) | |
| 2018-04-27 | [srv5](hostinfo_srv5.md) | Herc tk4- | [2018-04-27_srv5-a](2018-04-27_srv5-a.md) | |
| 2018-04-28 | [srv4](hostinfo_srv4.md) | Herc tk4- | [2018-04-28_srv4](2018-04-28_srv4.md) | |
| 2018-04-29 | [srv3](hostinfo_srv3.md) | Herc tk4- | [2018-04-29_srv3](2018-04-29_srv3.md) | |
| 2018-04-30 | [rasp2b](hostinfo_rasp2b.md) | Herc tk4- | [2018-04-30_rasp2b-1cpu](2018-04-30_rasp2b-1cpu.md) | with NUMCPU=1 MAXCPU=1 |
| 2018-05-06 | [rasp3b](hostinfo_rasp3b.md) | Herc tk4- | [2018-05-06_rasp3b](2018-05-06_rasp3b.md) |  |
| 2018-06-17 | [nbk1](hostinfo_nbk1.md) | Herc tk4- | [2018-06-17_nbk1-b](2018-06-17_nbk1-b.md) | after system upgrade |
| 2018-06-23 | [nbk2](hostinfo_nbk2.md) | Herc tk4- | [2018-06-23_nbk2](2018-06-23_nbk2.md) | after system upgrade |
| 2018-06-26 | [pra1](hostinfo_pra1.md) | Herc tk?? | [2018-06-26_pra1](2018-06-26_pra1.md) | Atom 330, single core/thread |
| 2018-06-26 | [pra2](hostinfo_pra2.md) | Herc tk?? | [2018-06-26_pra2](2018-06-26_pra2.md) | Atom 330, 2 core / 4 threads |
| 2018-07-06 | [nbk1](hostinfo_nbk1.md) | Herc tk4- | [2018-07-06_nbk1-1cpu-1core](2018-07-06_nbk1-1cpu-1core.md) | with NUMCPU=1, one host core |
| 2018-07-06 | [nbk1](hostinfo_nbk1.md) | Herc tk4- | [2018-07-06_nbk1-1cpu-2core](2018-07-06_nbk1-1cpu-2core.md) | with NUMCPU=1, two host cores |
