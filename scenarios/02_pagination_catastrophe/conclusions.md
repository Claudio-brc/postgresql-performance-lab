## Findings

- Adding an index on creation_date reduced execution time from 277 ms to 6 ms.
- PostgreSQL was able to eliminate the expensive sort operation and use an Index Scan.
- OFFSET pagination continued to degrade as page numbers increased.
- With OFFSET 50000 PostgreSQL had to scan more than 51k index entries to return only 100 rows.
- Keyset pagination allowed PostgreSQL to seek directly into the index and stop after reading approximately 100 rows.
- Execution time remained nearly constant regardless of logical page depth.