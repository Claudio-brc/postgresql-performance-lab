# Historical results

Historical results captured during earlier local testing. These timings are not
a controlled equal-page comparison: a strict OFFSET-versus-Keyset comparison
requires a cursor proven to represent the same logical page.

| Variant | Execution time |
|---|---:|
| No index | 277 ms |
| Indexed | 6 ms |
| OFFSET 1000 | 17 ms |
| OFFSET 10000 | 98 ms |
| OFFSET 50000 | 291 ms |
| Keyset Pagination | 2.6 ms |

| Query | Rows read |
|---|---:|
| LIMIT 100 | 101 |
| OFFSET 1000 | 1122 |
| OFFSET 10000 | 10246 |
| OFFSET 50000 | 51239 |
| Keyset | 102 |
