package com.example.table_verification.model;

import lombok.Data;

import java.io.Serializable;

@Data
public class TextFileModel implements Serializable {

    private String tableName;
    private String columnName;
    private String dataType;
    private String isNullable;
    private String isPk;
    private String isUnique;
    private String isIndex;
    private String isAutoIncrement;
    private String defaultValue;


}
