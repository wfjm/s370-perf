## HOWTO: execute an s370-perf benchmark test

### Table of content

- [Overview](#user-content-overview)
- [Installation](#user-content-installation)
- [Execute test](#user-content-execute)
- [Analyze test](#user-content-analyze)

### <a id="overview">Overview</a>
This HOWTO describes how to execute an s370-perf benchmark test in the
[Hercules tk4-](../narr/sysinfo_tk4m08.md) environment.
It assumes that
- the benchmark is executed on a _target node_. On this node, the
  simulator from the tk4- package must be installed.
- the test is controlled and analyzed from a _control node_. On this node,
  the [wfjm/s370-perf](https://github.com/wfjm/s370-perf) must be installed.

Target and control nodes can be identical. In that case, the `ssh` tunnel
described later is not needed.

### <a id="installation">Installation</a>
#### On _target node_
```
  mkdir -p ~/tmp/mvs/tk4m_1
  cd ~/tmp/mvs
  wget http://wotho.ethz.ch/tk4-/tk4-_v1.00_current.zip
    
  cd ~/tmp/mvs/tk4m_1
  unzip ../tk4-_v1.00_current.zip
```
#### On _control node_
```
  mkdir ~/tmp/mvs
  cd ~/tmp/mvs
  git clone --recurse-submodules git@github.com:wfjm/s370-perf.git
```
Ensure that `bin` and `herc-tools/bin` is in your `PATH`
```
  export PATH=$PATH:$HOME/tmp/mvs/s370-perf/bin:$HOME/tmp/mvs/s370-perf/herc-tools/bin
```

### <a id="execute">Execute Test</a>
#### On _target node_
Start the simulator with
```
  cd ~/tmp/mvs/tk4m_1
  NUMCPU=2 MAXCPU=2 ./mvs
```
This starts Hercules in a dual CPU configuration. Two CPUs match the
characteristics of the emulated IBM 3033, and are also the maximum
supported by MVS 3.9J.

#### On _control node_
If _target_ and control node are different setup an ssh tunnel with all the
relevant ports
```
  ssh <target node> \
      -L  8038:localhost:8038  \
      -L  3505:localhost:3505  \
      -L 14030:localhost:14030 \
      -L  3270:localhost:3270
```
Then start the Hercules WebGUI, essentially a system console
```
  firefox localhost:8038 &
```
wait until you see (click the `Send` botton to update display)
```
HHC02264I Script 5: file local_scripts/10 processing ended
HHC02264I Script 5: file scripts/local.rc processing ended
HHC01603I *
HHC01603I *                           ************   ****  *****          ||
HHC01603I *                           **   **   **    **    **           |||
HHC01603I *                           **   **   **    **   **           ||||
HHC01603I *                                **         **  **           || ||
HHC01603I *        |l      _,,,---,,_      **         ** **           ||  ||
HHC01603I * ZZZzz /,'.-'`'    -.  ;-;;,    **         ****           ||   ||
HHC01603I *      |,4-  ) )-,_. ,( (  ''-'  **         *****         ||    ||
HHC01603I *     '---''(_/--'  `-')_)       **         **  **       ||     ||    ||||||||||
HHC01603I *                                **         **   **      |||||||||||  Update 08
HHC01603I *       The MVS 3.8j             **         **    **            ||
HHC01603I *     Tur(n)key System           **         **     **           ||
HHC01603I *                              ******      ****     ***       ||||||
HHC01603I *
HHC01603I *            TK3 created by Volker Bandke       vbandke@bsp-gmbh.com
HHC01603I *            TK4- update by Juergen Winkelmann  winkelmann@id.ethz.ch
HHC01603I *                     see TK4-.CREDITS for complete credits
HHC01603I *
HHC02264I Script 5: file scripts/tk4-.rc processing ended
```
and enter in the S370 console the commands
```
  devinit 00E 14030 sockdev
  devinit 00c 3505 sockdev ascii trunc eof
```
The Hercules System Log should respond with
```
HHC01603I devinit 00E 14030 sockdev
HHC01042I 0:000E COMM: device bound to socket 14030
HHC02245I 0:000E device initialized
```
and
```
HHC01603I devinit 00c 3505 sockdev ascii trunc eof
HHC01046I 0:000C COMM: device unbound from socket 3505
HHC01042I 0:000C COMM: device bound to socket 3505
HHC02245I 0:000C device initialized
```

Next, start in one session the
[hercjos](https://github.com/wfjm/herc-tools/blob/master/doc/hercjos.md)
printer server. It captures the printer output, and stores it job-by-job in
files with telling names.
```
  cd ~/tmp/mvs/tk4m_1/prt
  hercjos -db -dt
```

Finally submit the `s370_perf` test jobs. This is done with the
[hercjis](https://github.com/wfjm/herc-tools/blob/master/doc/hercjis.md)
job submission system. Use at least 10 jobs, for best results use about 30.
Each job takes about 4-6 minutes, independent of host CPU speed because the
[GAUT](https://github.com/wfjm/s370-perf/blob/master/doc/s370_perf.md#user-content-par-gaut) option is used.
The number of jobs is controlled via the `-r` option of `hercjis`.
```
  cd ~/tmp/mvs/s370-perf/codes
  hercjis -r 30 s370_perf_ff.JES
```

You see in the session where `hercjos` runs output like
```
hercjos-I: head  'A JOB  251 PERF#ASM WFJM                 2022-06-06-13:41:59'
hercjos-I: write '2022-06-06-13:41:59_J0251_PERF-ASM.prt'
hercjos-I: close written   9p,   520l; dropped   2p,    66l
hercjos-I: head  'A JOB  252 PERF#ASM WFJM                 2022-06-06-13:47:16'
hercjos-I: write '2022-06-06-13:47:16_J0252_PERF-ASM.prt'
hercjos-I: head  'A STC  171 MF1                           2022-06-06-13:52:15'
hercjos-I: write '2022-06-06-13:52:15_S0171_MF1.prt'
hercjos-I: close written   9p,   307l; dropped   2p,    66l
hercjos-I: head  'A JOB  254 PERF#ASM WFJM                 2022-06-06-13:52:33'
hercjos-I: write '2022-06-06-13:52:33_J0254_PERF-ASM.prt'
hercjos-I: close written   9p,   521l; dropped   2p,    66l
```
The `PERF#ASM` jobs are the benchmark jobs, the `MF1` jobs are system
monitoring jobs that are executed periodically. To determine whether
all jobs have finished simply count the output files with
```
  cd ~/tmp/mvs/tk4m_1/prt
  ls -1 *PERF*.prt | wc  
```

When the benchmark jobs are finished the MVS system can be shut down with
```
  cd ~/tmp/mvs/s370-perf/codes
  hercjis ../jcl/shutdown.jcl
```
That triggers an orderly MVS shutdown, at the end, the Hercules simulator will
exit. The shutdown takes some time. `hercjos` will also exit when Hercules
has exited.

### <a id="analyze">Analyze Test</a>
When the benchmark jobs are finished the job outputs can be analysed.
The `prt` directory should contain files like
```
  cd ~/tmp/mvs/tk4m_1/prt
  ls -1
    2022-06-06-13:41:59_J0251_PERF-ASM.prt
    2022-06-06-13:47:16_J0252_PERF-ASM.prt
    2022-06-06-13:52:15_S0171_MF1.prt
    2022-06-06-13:52:33_J0254_PERF-ASM.prt
    2022-06-06-13:54:14_J0257_SHUTDWN.prt
```

The analysis is finanlly done with
[s370_perf_ana](s370_perf_ana.md) and [s370_perf_mark](s370_perf_mark.md)
```
  cd ~/tmp/mvs/tk4m_1/prt
  s370_perf_ana  *PERF*.prt > perf.dat
  s370_perf_mark perf.dat
```
