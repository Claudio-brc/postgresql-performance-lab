# Conclusions

## What Worked

- PostgreSQL automatically launched multiple workers for suitable queries.
- Parallel aggregation was effective for global aggregates such as SUM() and COUNT().
- Queries producing small partial result sets benefited from parallel execution.

## What We Learned

- Parallel execution is not free.
- Worker coordination introduces overhead.
- Large tables do not automatically imply parallel execution.
- Aggregation cardinality strongly influences planner decisions.

## Key Insight

PostgreSQL does not parallelize queries simply because they are large.

The planner evaluates whether the cost of coordinating workers is justified by the expected reduction in execution time.

Queries with small, easily mergeable partial results are much better candidates for parallel execution than queries producing tens of thousands of groups.