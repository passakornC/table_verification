package com.example.table_verification.model;

import lombok.Data;

import java.io.Serializable;

@Data
public class TableSpecId implements Serializable {

    private String tableName;
    private String columnName;

}
