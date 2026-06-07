# Conclusions

The initial assumption was that sorting or aggregation would be the main bottleneck.

Execution plan analysis showed a different story.

The original query joined 236k+ rows before aggregation and filtering, causing PostgreSQL to process a much larger intermediate result set.

By aggregating first and joining later, the number of rows participating in the join was dramatically reduced.

This change reduced execution time from approximately 2469 ms to 507 ms.

An additional experiment increasing work_mem eliminated disk spill during HashAggregate execution, but produced only marginal improvements, confirming that memory pressure was not the primary bottleneck.

Key takeaway:

Reducing cardinality before expensive operations can have a greater impact than increasing memory or adding indexes.