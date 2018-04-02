## Host Info: sys3

**sys3** is an AMD Opteron 6238 based dual socket server system

### CPU Info

| Attribute | Value |
| --------- | ----- |
| vendor_id    | AuthenticAMD |
| model name   | AMD Opteron(TM) Processor 6238 |
| cpu family   | 21 |
| model        | 1 |
| stepping     | 2 |
| microcode    | 0x6000624 |
| sockets      | 2 |
| cores per socket | 12 |
| CPU MHz       | 2600.0 |
| max Turbo MHz | 3200.0 (not enabled on test system) |
| bogomips     | 5199.92 |
| datasheet    | [at cpu-world.com](http://www.cpu-world.com/CPUs/Bulldozer/AMD-Opteron%206238.html) |
| microarchitecture | [Bulldozer-Interlagos](https://en.wikipedia.org/wiki/Bulldozer_(microarchitecture)) |

**Note**:
`lscpu` shows _6 cores_ and _2 thread/core_ because the `ht` flag is set.
`lstopo` shows a total of 12 cores per socket, each core with a single `PU`.
The AMD Opteron architecture shares much less resources per core that Intel
style hyperthreading, so for most practical purposes one can consider this as a
12 cores per socket system.

### OS Info

| Attribute | Value |
| --------- | ----- |
| Host OS      | Ubuntu 16.04.4 LTS |
| Host kernel  | 4.4.0-98-generic #121-Ubuntu SMP (on 2018-04-01) |
