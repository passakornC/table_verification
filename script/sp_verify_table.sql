DELIMITER //

CREATE PROCEDURE verify_table(IN p_schema_name VARCHAR(255), IN p_table_name VARCHAR(255))
BEGIN
    -- main: design
    -- compare column
    SELECT m.a_table_name                                  AS 'design_table_name',
           m.a_column_name                                 AS 'design_column_name',
           c.column_name                                   AS 'impl_column_name',
           IF(m.a_column_name = c.column_name, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN information_schema.columns c
                       ON m.a_column_name = c.column_name
                           AND m.a_table_name = c.table_name
    WHERE m.a_table_name = p_table_name
      AND c.table_schema = p_schema_name
    ORDER BY compare_result DESC, m.a_column_name;
    -- compare column

    -- compare data type name
    SELECT m.a_table_name                            AS 'design_table_name',
           m.a_column_name                           AS 'design_column_name',
           m.data_type                               AS 'design_data_type',
           c.data_type                               AS 'impl_data_type',
           IF(m.data_type = c.data_type, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN information_schema.columns c
                       ON m.a_column_name = c.column_name
                           AND m.a_table_name = c.table_name
    WHERE m.a_table_name = p_table_name
      AND c.table_schema = p_schema_name
    ORDER BY compare_result DESC, m.a_column_name;
    -- compare data type name

    -- compare nullable
    SELECT m.a_table_name                                                            AS 'design_table_name',
           m.a_column_name                                                           AS 'design_column_name',
           m.is_nullable                                                             AS 'design_is_nullable',
           c.is_nullable                                                             AS 'impl_is_nullable',
           IF(m.is_nullable = IF(c.is_nullable LIKE 'YES', TRUE, FALSE), '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN information_schema.columns c
                       ON m.a_column_name = c.column_name
                           AND m.a_table_name = c.table_name
    WHERE m.a_table_name = p_table_name
      AND c.table_schema = p_schema_name
    ORDER BY compare_result DESC, m.a_column_name;
    -- compare nullable

    -- compare PK
    SELECT m.a_table_name                        AS 'design_table_name',
           m.a_column_name                       AS 'design_column_name',

           IF(m.is_pk = TRUE, 'PK', '')          AS 'design_pk',
           IF(temp1.is_pk = TRUE, 'PK', '')      AS 'impl_pk',
           IF(m.is_pk = temp1.is_pk, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN (SELECT DISTINCT c.table_name,
                                        c.column_name,
                                        IF(temp1.constraint_type = 'PRIMARY KEY', TRUE, FALSE) AS 'is_pk'
                        FROM information_schema.columns c
                                 LEFT JOIN (SELECT DISTINCT s.table_schema,
                                                            s.table_name,
                                                            tc.constraint_type,
                                                            s.column_name
                                            FROM information_schema.statistics s
                                                     INNER JOIN information_schema.table_constraints tc
                                                                ON s.table_schema = tc.table_schema AND s.table_name = tc.table_name
                                            WHERE s.table_schema = p_schema_name
                                              AND s.table_name = p_table_name
                                              AND s.non_unique = FALSE
                                              AND tc.constraint_type = 'PRIMARY KEY') AS temp1
                                           ON c.table_schema = temp1.table_schema AND
                                              c.table_name = temp1.table_name AND
                                              c.column_name = temp1.column_name
                        WHERE c.table_schema = p_schema_name
                          AND c.table_name = p_table_name
                          AND c.column_name NOT IN
                              ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')) AS temp1
                       ON m.a_table_name = temp1.table_name AND m.a_column_name = temp1.column_name
    WHERE m.a_table_name = p_table_name
    ORDER BY compare_result DESC, design_pk DESC;
    -- compare PK

    -- compare UNIQUE
    SELECT m.a_table_name                                AS 'design_table_name',
           m.a_column_name                               AS 'design_column_name',

           IF(m.is_unique = TRUE, 'UNIQUE', '')          AS 'design_unique',
           IF(temp1.is_unique = TRUE, 'UNIQUE', '')      AS 'impl_unique',
           IF(m.is_unique = temp1.is_unique, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN (SELECT DISTINCT c.table_name,
                                        c.column_name,
                                        IF(temp1.constraint_type = 'UNIQUE', TRUE, FALSE) AS 'is_unique'
                        FROM information_schema.columns c
                                 LEFT JOIN (SELECT DISTINCT s.table_schema,
                                                            s.table_name,
                                                            tc.constraint_type,
                                                            s.column_name
                                            FROM information_schema.statistics s
                                                     INNER JOIN information_schema.table_constraints tc
                                                                ON s.table_schema = tc.table_schema AND s.table_name = tc.table_name
                                            WHERE s.table_schema = p_schema_name
                                              AND s.table_name = p_table_name
                                              AND s.non_unique = FALSE
                                              AND tc.constraint_type = 'UNIQUE') AS temp1
                                           ON c.table_schema = temp1.table_schema AND
                                              c.table_name = temp1.table_name AND
                                              c.column_name = temp1.column_name
                        WHERE c.table_schema = p_schema_name
                          AND c.table_name = p_table_name
                          AND c.column_name NOT IN
                              ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')) AS temp1
                       ON m.a_table_name = temp1.table_name AND m.a_column_name = temp1.column_name
    WHERE m.a_table_name = p_table_name
    ORDER BY compare_result DESC, design_unique DESC;
    -- compare UNIQUE

    -- compare INDEX
    SELECT m.a_table_name                                                        AS 'design_table_name',
           m.a_column_name                                                       AS 'design_column_name',

           IF(m.is_index = TRUE, 'INDEX', '')                                    AS 'design_index',
           IF(temp1.is_index = TRUE, 'INDEX', '')                                AS 'impl_index',
           IF(m.is_index = temp1.is_index OR temp1.is_index IS NULL, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN (SELECT c.table_schema,
                               c.table_name,
                               c.column_name,
                               s.non_unique AS 'is_index'
                        FROM information_schema.columns c
                                 LEFT JOIN information_schema.statistics s
                                           ON c.table_schema = s.table_schema AND c.table_name = s.table_name AND
                                              c.column_name = s.column_name
                        WHERE c.table_schema = p_schema_name
                          AND c.table_name = p_table_name
                          AND s.non_unique = TRUE
                          AND c.column_name NOT IN
                              ('updated_by', 'updated_date_time', 'created_by', 'created_date_time'))
        AS temp1 ON m.a_table_name = temp1.table_name AND m.a_column_name = temp1.column_name
    WHERE m.a_table_name = p_table_name
    ORDER BY compare_result DESC, design_index DESC;
    -- compare INDEX


    --
    -- main: mfoa_table
    -- compare with design
    SELECT a.table_name                                    AS 'impl_table_name',
           a.column_name                                   AS 'impl_column_name',
           b.a_column_name                                 AS 'design_column_name',
           IF(a.column_name = b.a_column_name, '', 'DIFF') AS 'compare_result'
    FROM information_schema.columns a
             LEFT JOIN mfoa_table_spec b ON a.table_name = b.a_table_name AND a.column_name = b.a_column_name
    WHERE a.table_schema = p_schema_name
      AND a.table_name = p_table_name
      AND a.column_name NOT IN ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')
    ORDER BY compare_result DESC, a.column_comment;
    -- compare with design

    -- compare default value
    SELECT c.table_schema,
           m.a_table_name   AS 'design_table_name',
           m.a_column_name  AS 'design_column_name',
           m.default_value  AS 'design_default',
           c.column_default AS 'impl_default'
    FROM mfoa_table_spec m
             LEFT JOIN information_schema.columns c ON m.a_table_name = c.table_name AND m.a_column_name = c.column_name
    WHERE table_schema = p_schema_name
      AND table_name = p_table_name
      AND c.column_name NOT IN
          ('updated_by', 'updated_date_time', 'created_by', 'created_date_time')
    ORDER BY m.default_value DESC, c.column_default DESC, m.a_column_name;
    -- compare default value


END //

DELIMITER ;

# DROP PROCEDURE verify_table;



