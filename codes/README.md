This directory contains the s370_perf code and associated jobs

| Job      | PARMs | Description |
| -------- | ----- | ----------- |
| [s370_perf_t](s370_perf_t.JES)   | /G001/OPTT      | test job, fast, with asm listing |
| [s370_perf_tf](s370_perf_tf.JES) | /G001/OPTT/E9** | test job, with T9** tests, fast, with asm listing |
| [s370_perf_f](s370_perf_f.JES)   | /GAUT           | production job |
| [s370_perf_ff](s370_perf_ff.JES) | /GAUT/E9**      | production job, with T9** tests |

Typical execution time of a `s370_perf_ff` job is 4-6 minutes.
