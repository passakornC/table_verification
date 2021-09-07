/********************************************************************************
  SCRIPT: main.sql
  OBJECTIVE:
  CREATED:
  RDBMS: MySQL 5.7.33
 ********************************************************************************/

# USE test;

-- Read from text file
SET @batch_job_id = 'TEST_02';
SET @tbl_name = 'rest_address_relation_fcn_cbs';

CALL start_migration_log(@batch_job_id, @tbl_name);
LOAD DATA LOCAL INFILE '/Users/passakorn.choosuk/IdeaProjects/ktb/mfoa/table_verification/input/tbl_address_relation_fcn_cbs_20210818_v1.0.csv'
# LOAD DATA LOCAL INFILE './sag1/input/CSVFile_TBL_ADDRESS_MAP.csv'
    INTO TABLE rest_address_relation_fcn_cbs
    CHARACTER SET utf8mb4
    COLUMNS TERMINATED BY ','
    OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 LINES
    (fcn_unique_id, province, district, sub_district, postal_code,
     cbs_province_code, cbs_district_code, cbs_sub_district_code,
     is_active);
CALL plogmigrationtime(@batch_job_id, @tbl_name);

-- Map to sag1_tmp
SET @batch_job_id = 'TEST_02';
SET @tbl_name = 'tbl_address_relation_fcn_cbs';

CALL start_migration_log(@batch_job_id, @tbl_name);
CALL map_rest_to_actual(@batch_job_id, @tbl_name);
CALL plogmigrationtime(@batch_job_id, @tbl_name);



