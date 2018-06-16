This directory contains the [s370_perf code](s370_perf.asm) and associated jobs

| Job      | PARMs | Description |
| -------- | ----- | ----------- |
| [s370_perf_t](s370_perf_t.JES)                 | /G001/OPTT      | test job, fast, with asm listing |
| [s370_perf_tf](s370_perf_tf.JES)               | /G001/OPTT/E9** | test job, with T9** tests, fast, with asm listing |
| [s370_perf_tf_disbas](s370_perf_tf_disbas.JES) | /G001/OPTT/E9** | like s370_perf_tf, but BAS tests removed |
| [s370_perf_f](s370_perf_f.JES)                 | /GAUT           | production job |
| [s370_perf_ff](s370_perf_ff.JES)               | /GAUT/E9**      | production job, with T9** tests |
| [s370_perf_ff_disbas](s370_perf_ff_disbas.JES) | /GAUT/E9**      | like s370_perf_ff, but BAS tests removed |

Typical execution time of a `s370_perf_ff` job is 4-6 minutes.

In addition test codes and associated jobs are provided

| Code | Job | Description |
| ---- | --- | ----------- |
| [test_cputime](test_cputime.asm) | [JES](test_cputime.JES) | test of high-resolution CPU time retrieval |

