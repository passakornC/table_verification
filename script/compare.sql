/*
compare
- table name
- column name
- data type
- max length
- precision
- scale
- nullable
- primary
- unique
- index
*/
SELECT DISTINCT c.table_name                                                             AS 'tableName',
                c.column_name                                                            AS 'columnName',
                c.data_type                                                              AS 'datatype',
                c.character_maximum_length                                               AS 'maxLength',
                c.numeric_precision                                                      AS 'numPrecision',
                c.numeric_scale                                                          AS 'numScale',
                IF(c.is_nullable = 'YES', TRUE, FALSE)                                   AS 'isNullable',
                IF(tc.constraint_type = 'PRIMARY KEY', TRUE, FALSE)                      AS 'isPrimary',
                IF(tc.constraint_type = 'UNIQUE', TRUE, FALSE)                           AS 'isUnique',
                IF(tc.constraint_type IS NULL AND s.index_name IS NOT NULL, TRUE, FALSE) AS 'isIndex'
FROM information_schema.columns c
         LEFT JOIN information_schema.statistics s
                   ON c.column_name = s.column_name AND c.table_schema = s.table_schema AND c.table_name = s.table_name
         LEFT JOIN information_schema.table_constraints tc ON s.index_name = tc.constraint_name
WHERE c.table_schema = :schemaName
  AND c.table_name = :tableName;



SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'db'
  AND extra LIKE 'on update%'
  AND table_name NOT LIKE 'mfoa%'
  AND table_name NOT LIKE 'batch%';

-- table without some of common field
SELECT t.table_name
FROM information_schema.tables t
WHERE t.table_name NOT IN (SELECT table_name
                           FROM information_schema.columns c
                           WHERE table_schema = 'db'
                             AND c.column_name = 'updated_date_time'
#                              AND c.column_name IN ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')
                             AND table_name NOT LIKE 'mfoa%'
                             AND table_name NOT LIKE 'batch%')
  AND table_schema = 'db'
  AND table_name NOT LIKE 'mfoa%'
  AND table_name NOT LIKE 'batch%';
-- table without some of common field

-- check common field
SELECT temp1.table_name, COUNT(*) AS num_comm_field
FROM (SELECT c.table_name, COUNT(*)
      FROM information_schema.columns c
      WHERE c.table_schema = 'db'
        AND c.column_name IN ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')
      GROUP BY c.table_name, c.column_name) AS temp1
GROUP BY temp1.table_name
HAVING COUNT(*) <> 4;
-- check common field


SET @tbl_name = 'tbl_account';
--
-- Verify Table
--
CALL verify_table('db', @tbl_name);

SELECT COUNT(*)
FROM mfoa_table_spec
WHERE a_table_name = @tbl_name;





-- list all TABLE with #COLUMN
SELECT table_name, COUNT(*)
FROM information_schema.columns
WHERE table_schema = 'db'
  AND table_name NOT LIKE 'mfoa%'
  AND table_name NOT LIKE 'batch%'
GROUP BY table_name
ORDER BY COUNT(*) DESC, table_name;


SELECT a_column_name, IF(is_nullable = TRUE, 'Yes', 'No') AS result
FROM mfoa_table_spec
WHERE a_table_name = @tbl_name;



SELECT m.a_table_name,
       m.a_column_name,
       c.column_name,
       IF(m.a_column_name = c.column_name, '', 'DIFF') AS 'result'
FROM mfoa_table_spec m
         LEFT JOIN information_schema.columns c
                   ON m.a_column_name = c.column_name AND m.a_table_name = c.table_name AND c.table_schema = 'db'
WHERE m.a_table_name = @tbl_name
ORDER BY result DESC;



SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'db'
  AND table_name NOT LIKE 'mfoa%'
  AND table_name NOT LIKE 'batch%';



UPDATE mfoa_table_spec
SET data_type = 'varchar'
WHERE a_table_name = 'tbl_ktam_fund_info_temp'
  AND a_column_name = 'type_of_unit_trust';
DELETE
FROM mfoa_table_spec
WHERE a_table_name = 'tbl_transaction_clone';



SELECT m.a_column_name,
       m.data_type,
       c.data_type,
       IF(m.data_type = c.data_type, '', 'DIFF') AS 'result'
FROM mfoa_table_spec m
         LEFT JOIN information_schema.columns c
                   ON m.a_column_name = c.column_name AND m.a_table_name = c.table_name AND
                      c.table_schema = 'db'
WHERE m.a_table_name = 'tbl_recent_transaction'
ORDER BY result DESC;



SELECT DISTINCT data_type, column_type
FROM information_schema.columns;



DELETE
FROM mfoa_table_spec
WHERE a_table_name = @tbl_name;
SELECT @tbl_name;



-- main: mfoa_table
-- compare with design
SELECT a.column_name, b.a_column_name, IF(a.column_name = b.a_column_name, '', 'DIFF') AS result
FROM information_schema.columns a
         LEFT JOIN mfoa_table_spec b ON a.table_name = b.a_table_name AND a.column_name = b.a_column_name
WHERE a.table_schema = 'db'
  AND a.table_name = @tbl_name
  AND a.column_name NOT IN ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')
ORDER BY result DESC;


-- run script below
SELECT *
FROM mfoa_table_spec
WHERE a_table_name = 'tbl_reconcile_sag_transaction';

UPDATE mfoa_table_spec
SET a_column_name = 'work_position_description'
WHERE a_table_name = 'tbl_staged_customer_profile'
  AND a_column_name = 'work_position_descritpion';

DELETE
FROM mfoa_table_spec
WHERE a_table_name = 'tbl_reconcile_failed_transaction';


DESC mfoa.tbl_account;


SELECT *
FROM tbl_address_relation_fcn_cbs
WHERE fcn_unique_id = '7684';


SELECT *
FROM tbl_migration_log;

SELECT *
FROM tbl_migration_log_detail;








SELECT *
FROM information_schema.tables
WHERE table_schema = 'db';


USE test;

CREATE SCHEMA db COLLATE utf8mb4_general_ci;
USE db;