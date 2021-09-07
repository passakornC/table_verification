DELIMITER //


CREATE PROCEDURE map_rest_to_actual(job_id VARCHAR(50), tbl_name VARCHAR(50))
BEGIN
    DECLARE err_code CHAR(5) DEFAULT '00000';
    DECLARE err_msg TEXT;
    DECLARE err_no INT UNSIGNED;
    DECLARE end_record BOOLEAN;
    DECLARE before_count INT DEFAULT 0;
    DECLARE after_count INT DEFAULT 0;
    DECLARE total_in_rest INT DEFAULT 0;

    DECLARE data_id INT;
    DECLARE data_fcn_unique_id VARCHAR(6);
    DECLARE data_province VARCHAR(100);
    DECLARE data_district VARCHAR(100);
    DECLARE data_sub_district VARCHAR(100);
    DECLARE data_postal_code VARCHAR(100);
    DECLARE data_cbs_province_code VARCHAR(2);
    DECLARE data_cbs_district_code VARCHAR(2);
    DECLARE data_cbs_sub_district_code VARCHAR(4);
    DECLARE data_is_active VARCHAR(10);

    DECLARE data_cursor CURSOR FOR
        SELECT fcn_unique_id,
               province,
               district,
               sub_district,
               postal_code,
               cbs_province_code,
               cbs_district_code,
               cbs_sub_district_code,
               is_active
        FROM rest_address_relation_fcn_cbs;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING
        BEGIN
            GET DIAGNOSTICS CONDITION 1
                err_code = RETURNED_SQLSTATE,
                err_msg = MESSAGE_TEXT,
                err_no = MYSQL_ERRNO;
        END;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET end_record = TRUE;

    SELECT COUNT(*)
    INTO total_in_rest
    FROM rest_address_relation_fcn_cbs;

    SELECT COUNT(*)
    INTO before_count
    FROM tbl_address_relation_fcn_cbs;

    OPEN data_cursor;
    data_loop:
    LOOP
        FETCH data_cursor
            INTO data_fcn_unique_id, data_province, data_district, data_sub_district, data_postal_code,
                data_cbs_province_code, data_cbs_district_code, data_cbs_sub_district_code, data_is_active;
        IF end_record THEN
            CLOSE data_cursor;
            LEAVE data_loop;
        END IF;

        INSERT INTO tbl_address_relation_fcn_cbs (fcn_unique_id, province, district, sub_district, postal_code,
                                                  cbs_province_code, cbs_district_code, cbs_sub_district_code,
                                                  is_active)
            VALUE (data_fcn_unique_id, data_province, data_district, data_sub_district, data_postal_code,
                   data_cbs_province_code, data_cbs_district_code, data_cbs_sub_district_code, IF(data_is_active = 'TRUE', TRUE, FALSE));

        IF err_code != '00000' THEN
            INSERT IGNORE INTO tbl_migration_log_detail (batch_job_id, table_name, `key`, error_code, note)
                VALUE (job_id, tbl_name, data_id, err_no, CONCAT(err_code, ' ', err_msg));
        END IF;

    END LOOP data_loop;

    SELECT COUNT(*)
    INTO after_count
    FROM tbl_address_relation_fcn_cbs;

    SET @success_count = after_count - before_count;
    CALL plogmigrationrecord(job_id, total_in_rest, @success_count, total_in_rest - @success_count);

END //

DELIMITER ;