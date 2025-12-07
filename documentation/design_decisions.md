## Design Decisions

- **Naming**: Adopted `snake_case` for tables/columns for consistency
- **Keys**: Separate sequences for portability and explicit control
- **Integrity**: PK/FK constraints with indexes on join columns
- **Business Logic**: Encapsulated in PL/SQL packages for reuse
- **Restrictions**: Centralized via `audit_pkg` and enforced by triggers
- **Auditing**: Write-ahead logging on every DML attempt, capture ALLOWED/DENIED
- **Analytics**: Window functions for ranking, cadence, and top-N analysis
