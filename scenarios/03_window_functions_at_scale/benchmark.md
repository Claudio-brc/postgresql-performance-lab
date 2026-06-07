| Scenario         | Execution Time |
| ---------------- | -------------: |
| Default work_mem |         246 ms |
| work_mem = 32 MB |         209 ms |


| Metric      |        Default |     32 MB |
| ----------- | -------------: | --------: |
| Sort Method | external merge | quicksort |
| Temp Files  |            yes |        no |
| Disk Usage  |        2992 KB |      0 KB |
| Result Rows |           5000 |      5000 |
