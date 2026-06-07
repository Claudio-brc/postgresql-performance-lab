## Findings

- PostgreSQL implemented the ranking using a WindowAgg node.
- The query required sorting approximately 57k rows before calculating ROW_NUMBER().
- Filtering on yearly_rank <= N did not eliminate the initial sort operation.
- With the default work_mem setting, PostgreSQL spilled the sort to disk using an external merge sort.
- Increasing work_mem to 32 MB allowed the sort to execute entirely in memory using quicksort.
- Query execution time improved from 246 ms to 209 ms without changing query logic or indexes.

## Key Lesson

Returning a small number of rows does not necessarily mean PostgreSQL processes a small number of rows.

The execution plan showed that PostgreSQL still needed to sort over 57k rows before producing the final Top-N ranking for each year.