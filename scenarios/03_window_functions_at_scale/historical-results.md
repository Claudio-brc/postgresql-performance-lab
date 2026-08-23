# Historical results

Captured during earlier local testing with a version that returned the top 1000
rows per year (5000 result rows), not the current top-10 query.

| Setting | Execution time | Sort method |
|---|---:|---|
| Default work_mem | 246 ms | external merge; 2992 kB disk |
| work_mem = 32 MB | 209 ms | quicksort; no temporary files |
