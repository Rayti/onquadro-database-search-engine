# Topology-based classification of tetrads and quadruplex structures

## Table 1

```sql
SELECT sequence,
       SUM(CASE tv.molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE tv.molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE tv.molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                             AS Total
FROM tetrad_view tv
         JOIN quadruplex_view qv on tv.quadruplex_id = qv.id
WHERE qv.count > 1
GROUP BY sequence

UNION ALL

SELECT 'Total',
       SUM(CASE tv.molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE tv.molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE tv.molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                             AS Total
FROM tetrad_view tv
         JOIN quadruplex_view qv on tv.quadruplex_id = qv.id
WHERE qv.count > 1;
```

## Table 2

```sql
SELECT CAST(count AS text)                               AS number_of_tetrads,
       SUM(CASE molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                          AS Total
FROM quadruplex_view
GROUP BY count

UNION ALL

SELECT 'Total',
       SUM(CASE molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                          AS Total
FROM quadruplex_view;
```

## Table 3

```sql
SELECT CAST(chains AS text),
       SUM(CASE molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                          AS Total
FROM quadruplex_view
GROUP BY chains

UNION ALL

SELECT 'Total',
       SUM(CASE molecule WHEN 'DNA' THEN 1 ELSE 0 END)   AS DNA,
       SUM(CASE molecule WHEN 'RNA' THEN 1 ELSE 0 END)   AS RNA,
       SUM(CASE molecule WHEN 'Other' THEN 1 ELSE 0 END) AS Other,
       COUNT(*)                                          AS Total
FROM quadruplex_view;
```

# ElTetrado: a tool for identification and classification of tetrads and quadruplexes

## Table 1

```sql
SELECT CAST(onz AS text),
       SUM(CASE tv.chains WHEN 1 THEN 1 ELSE 0 END) AS Unimolecular,
       SUM(CASE tv.chains WHEN 2 THEN 1 ELSE 0 END) AS Bimolecular,
       SUM(CASE tv.chains WHEN 4 THEN 1 ELSE 0 END) AS Tetramolecular,
       COUNT(*)                                     AS Total
FROM tetrad_view tv
         JOIN quadruplex_view qv on tv.quadruplex_id = qv.id
WHERE qv.count > 1
GROUP BY onz

UNION ALL

SELECT 'Total',
       SUM(CASE tv.chains WHEN 1 THEN 1 ELSE 0 END) AS Unimolecular,
       SUM(CASE tv.chains WHEN 2 THEN 1 ELSE 0 END) AS Bimolecular,
       SUM(CASE tv.chains WHEN 4 THEN 1 ELSE 0 END) AS Tetramolecular,
       COUNT(*)                                     AS Total
FROM tetrad_view tv
         JOIN quadruplex_view qv on tv.quadruplex_id = qv.id
WHERE qv.count > 1;
```

## Table 2

```sql
SELECT CAST(onzm AS text),
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 1
GROUP BY onzm

UNION ALL

SELECT 'Total',
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 1;
```

## Table 3a

```sql
SELECT CAST(onzm AS text),
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 2
GROUP BY onzm

UNION ALL

SELECT 'Total',
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 2;
```

## Table 3b

```sql
SELECT CAST(onzm AS text),
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 4
GROUP BY onzm

UNION ALL

SELECT 'Total',
       SUM(CASE subtype WHEN '+' THEN 1 ELSE 0 END) AS Plus,
       SUM(CASE subtype WHEN '-' THEN 1 ELSE 0 END) AS Minus,
       SUM(CASE subtype WHEN '*' THEN 1 ELSE 0 END) AS Star,
       COUNT(*)                                     AS Total
FROM quadruplex_view
WHERE chains = 4;
```
