# Historical observations

Historical local observations from the original experiment. They are not
newly reproduced execution plans or universal PostgreSQL behavior.

| Predicate | Matching users | Join strategy observed |
|---|---:|---|
| `reputation > 50000` | 15 | Nested Loop |
| `reputation > 1000` | 848 | Parallel Hash Join |

For the highly selective predicate, the observed plan used index scans on
`users` and `posts`. For the less selective predicate, it used parallel
sequential scans, Parallel Hash, and Gather Merge.
