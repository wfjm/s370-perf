# s370_perf installation

The s370_perf uses git
[submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
to embed the project
[herc-tools](https://github.com/wfjm/herc-tools).

To install use
```bash
cd <install-root>
git clone --recurse-submodules https://github.com/wfjm/s370-perf.git
```

To update use
```bash
cd <install-root>/s370-perf
git pull  --recurse-submodules

```

To setup the environment use
```bash
export PATH=$PATH:<install-root>/s370-perf/bin:<install-root>/s370-perf/herc-tools/bin
```
