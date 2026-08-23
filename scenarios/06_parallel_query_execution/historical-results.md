# Historical observations

Historical local observations from the original experiment. Parallel scans and
partial aggregates appeared for global and low-cardinality aggregates, while
the high-cardinality group-by used a serial HashAggregate. The serial global
aggregate was faster on that machine. These observations are not universal
rules; plan selection depends on configuration and runtime conditions.
