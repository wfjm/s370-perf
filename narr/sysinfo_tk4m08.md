## System Info: Hercules tk4- 08

The system uses Juergen Winkelmann's great
[tk4-](https://wotho.ethz.ch/tk4-/) setup:
- use tk4- V1.00 update 08 (was 'current' in 2018-2022)
- based on Hercules 4.00
  ```
  HHC01413I Hercules version 4.00
  HHC01414I (c) Copyright 1999-2012 by Roger Bowler, Jan Jaeger, and others
  HHC01415I Built on May 28 2017 at 14:25:55
  HHC01416I Build information:
  HHC01417I Hercules for TK4- (64-bit Linux)
  ```
- emulates a [3033](https://en.wikipedia.org/wiki/IBM_303X#IBM_3033) dual
  CPU MP configuration
- runs MVS 3.8j Service Level 8505

The benchmark jobs are executed sequentially because they all have the same name.
The emulated 3033 has two CPUs, which run on two threads on the host system.
The benchmark jobs run therefore essentially back-to-back without any
interruption while the other system activities tend to use the second CPU.

### <a id="data">Available Data</a>

Most available data was taken with this system, see [README](README.md).
