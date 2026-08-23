# Partitioning Basics

## Objective

This scenario examines PostgreSQL range partitioning and how partition pruning
can reduce the partitions considered for date-filtered queries.

## Dataset

- posts: approximately 243k rows
- Date range: 2008-09-16 to 2024-03-31

## Problem

As a time-based table grows, date predicates can require PostgreSQL to consider
an increasingly large relation. Partitioning keeps one logical table interface
while organizing rows into smaller physical tables.

## Approach

The experiment creates `posts_partitioned`, partitions it by
`RANGE (creation_date)` into yearly 2020–2024 partitions, and loads source rows
from 2020 onward. It then queries 2023+ and 2024+ to observe pruning, followed
by a comparison with the original `posts` table.

## Partition Pruning Behavior

PostgreSQL routes inserted rows to the appropriate partition. With predicates
on `creation_date`, irrelevant yearly partitions can be pruned before
execution. The historical plans accessed `posts_2023` and `posts_2024` for the
2023+ query, and only `posts_2024` for the 2024+ query.

## Historical Observations

The original local observations were approximately 7.2 ms for partitioned
2023+, 0.7 ms for partitioned 2024+, and 2.9 ms for the original table at
2024+. They are historical measurements, not a controlled like-for-like
benchmark; see `historical-results.md`.

## Findings

- Date predicates allowed irrelevant partitions to be pruned.
- Partitioning did not replace indexing.
- Partitioning does not automatically make every query faster; its value comes
  from avoiding irrelevant data, particularly as time-based tables grow.
