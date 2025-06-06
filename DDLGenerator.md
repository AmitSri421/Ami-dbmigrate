Get Column Definitions for CREATE TABLE
```sql
SELECT 
  '  ' || column_name || ' ' || data_type ||
  CASE 
    WHEN data_type IN ('VARCHAR2', 'CHAR') THEN '(' || data_length || ')'
    WHEN data_type IN ('NUMBER') AND data_precision IS NOT NULL THEN '(' || data_precision || ',' || data_scale || ')'
    ELSE ''
  END ||
  CASE nullable WHEN 'N' THEN ' NOT NULL' ELSE '' END || ',' AS column_def
FROM all_tab_columns
WHERE table_name = 'YOUR_TABLE_NAME'
  AND owner = 'TABLE_OWNER'
ORDER BY column_id;
```

Get Primary Key
```sql
SELECT 
  'ALTER TABLE ' || c.owner || '.' || c.table_name || 
  ' ADD CONSTRAINT ' || c.constraint_name || 
  ' PRIMARY KEY (' || 
  LISTAGG(cc.column_name, ', ') WITHIN GROUP (ORDER BY cc.position) || ');' AS ddl
FROM all_constraints c
JOIN all_cons_columns cc 
  ON c.constraint_name = cc.constraint_name 
  AND c.owner = cc.owner
WHERE c.constraint_type = 'P'
  AND c.table_name = 'YOUR_TABLE_NAME'
  AND c.owner = 'TABLE_OWNER'
GROUP BY c.owner, c.table_name, c.constraint_name;

```

UNIQUE, CHECK, and FOREIGN KEY DDL Query
```sql
SELECT 
  CASE c.constraint_type
    WHEN 'U' THEN 
      'ALTER TABLE ' || c.owner || '.' || c.table_name ||
      ' ADD CONSTRAINT ' || c.constraint_name || 
      ' UNIQUE (' || LISTAGG(cc.column_name, ', ') WITHIN GROUP (ORDER BY cc.position) || ');'
    WHEN 'C' THEN 
      '/* CHECK constraint: ' || c.constraint_name || ' - manual expression needed */'
    WHEN 'R' THEN 
      'ALTER TABLE ' || c.owner || '.' || c.table_name ||
      ' ADD CONSTRAINT ' || c.constraint_name || 
      ' FOREIGN KEY (' || LISTAGG(cc.column_name, ', ') WITHIN GROUP (ORDER BY cc.position) || ')' ||
      ' REFERENCES ' || r.owner || '.' || r.table_name || ';'
  END AS ddl
FROM all_constraints c
JOIN all_cons_columns cc 
  ON c.constraint_name = cc.constraint_name 
  AND c.owner = cc.owner
LEFT JOIN all_constraints r 
  ON c.r_constraint_name = r.constraint_name 
  AND c.owner = r.owner
WHERE c.constraint_type IN ('U', 'C', 'R')
  AND c.table_name = 'YOUR_TABLE_NAME'
  AND c.owner = 'TABLE_OWNER'
GROUP BY c.constraint_type, c.owner, c.table_name, c.constraint_name, r.owner, r.table_name;

```

Index DDLs (excluding PK/Unique constraints) 
```sql
SELECT 
  'CREATE ' || 
  DECODE(i.uniqueness, 'UNIQUE', 'UNIQUE ', '') ||
  'INDEX ' || i.index_name || 
  ' ON ' || i.table_name || 
  ' (' || 
  LISTAGG(ic.column_name, ', ') WITHIN GROUP (ORDER BY ic.column_position) || ');' AS ddl
FROM all_indexes i
JOIN all_ind_columns ic 
  ON i.index_name = ic.index_name 
  AND i.owner = ic.index_owner
WHERE i.table_name = 'YOUR_TABLE_NAME'
  AND i.owner = 'TABLE_OWNER'
  AND NOT EXISTS (
    SELECT 1 FROM all_constraints c 
    WHERE c.index_name = i.index_name AND c.owner = i.owner
  )
GROUP BY i.index_name, i.table_name, i.uniqueness;

```
Assemble
```sql
-- 1. CREATE TABLE
-- Paste column definitions here

-- 2. ALTER TABLE ADD PRIMARY KEY
-- Paste primary key DDL

-- 3. ALTER TABLE ADD CONSTRAINTS
-- Paste unique / foreign key constraints

-- 4. CREATE INDEX
-- Paste additional index DDLs
```
