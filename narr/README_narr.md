## Content of Narratives

### cpufreq <a name="cpufreq"></a>
The _cpufreq_ line lists the key settings of the CPU clock freqency scaling
sub-system of the Linux kernel (see
[kernel docu](https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt)).
Usually inquired with the
[cpufreq-info](https://linux.die.net/man/1/cpufreq-info) command.

### eff. CPU clock <a name="effclk"></a>
The _eff. CPU clock_ value is an estmate of the average CPU clock used during
the execution of the s370_perf jobs. On Intel based systems in general obtained
from `/proc/cpuinfo` via
```
  cat /proc/cpuinfo | grep MHz
```

On AMD based systems `/proc/cpuinfo` in general does not return reliable CPU
clock values, on those systems
```
  sudo cpupower monitor
```
was used.

### ASM step <a name="asm"></a>
The _ASM step_ line contains a summary, generated with
[hercjsu using -asum](https://github.com/wfjm/herc-tools/blob/master/doc/hercjsu.md#user-content-opt-asum),
of the ASM steps of the s370_perf jobs with
- median value of CPU time
- 50% width of CPU time distribution
- ratio of CPU time to elapsed time

### GO step <a name="go"></a>
The _GO step_ line contains a summary, generated with
[hercjsu using -asum](https://github.com/wfjm/herc-tools/blob/master/doc/hercjsu.md#user-content-opt-asum),
of the GO steps of the s370_perf jobs with
- median value of CPU time
- 50% width of CPU time distribution
- ratio of CPU time to elapsed time

### lmark <a name="lmark"></a>
The _lmark_ value is a MIPS rating generated with the
[s370_perf_mark](../doc/s370_perf_mark.md) tool using the
[lmix](../doc/s370_perf_mark.md#user-content-mix-lmix)
instruction mix.
