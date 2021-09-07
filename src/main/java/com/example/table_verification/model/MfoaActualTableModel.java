package com.example.table_verification.model;

import lombok.Data;

@Data
public class MfoaActualTableModel {

    private String tableName;
    private String columnName;
    private String dataType;
    private Integer maxLength;
    private Integer numPrecision;
    private Integer numScale;
    private Boolean isNullable;
    private Boolean isPrimary;
    private Boolean isUnique;
    private Boolean isIndex;

}
