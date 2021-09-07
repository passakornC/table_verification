DELIMITER //

CREATE PROCEDURE verify_table(IN p_schema_name VARCHAR(255), IN p_table_name VARCHAR(255))
BEGIN
    -- main: design
    -- compare column
    SELECT m.a_table_name                                  AS 'design_table_name',
           m.a_column_name                                 AS 'design_column_name',
           c.column_name                                   AS 'impl_table_name',
           IF(m.a_column_name = c.column_name, '', 'DIFF') AS 'compare_result'
    FROM mfoa_table_spec m
             LEFT JOIN information_schema.columns c
                       ON m.a_column_name = c.column_name
                           AND m.a_table_name = c.table_name
    WHERE m.a_table_name = p_table_name
      AND c.table_schema = p_schema_name
    ORDER BY compare_result DESC, m.a_column_name;
END //

DELIMITER ;

