package com.example.table_verification.model;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.Hibernate;

import javax.persistence.*;

//    private String tableName;
//    private String columnName;
//    private String dataType;
//    private Integer maxLength;
//    private Integer numPrecision;
//    private Integer numScale;
//    private Boolean isNullable;
//    private Boolean isPrimary;
//    private Boolean isUnique;
//    private Boolean isIndex;


@SqlResultSetMapping(
        name = "MfoaActualTableSpecMapping",
        classes = {
                @ConstructorResult(
                        targetClass = MfoaActualTableModel.class,
                        columns = {
                                @ColumnResult(name = "tableName", type = String.class),
                                @ColumnResult(name = "columnName", type = String.class),
                                @ColumnResult(name = "dataType", type = String.class),
                                @ColumnResult(name = "maxLength", type = Integer.class),
                                @ColumnResult(name = "numPrecision", type = Integer.class),
                                @ColumnResult(name = "numScale", type = Integer.class),
                                @ColumnResult(name = "isNullable", type = Boolean.class),
                                @ColumnResult(name = "isPrimary", type = Boolean.class),
                                @ColumnResult(name = "isUnique", type = Boolean.class),
                                @ColumnResult(name = "isIndex", type = Boolean.class),
                        }
                )
        }
)
@NamedNativeQuery(
        name = "TableSpecModel.getMfoaActualTableSpec",
        query = "SELECT DISTINCT c.table_name  AS 'tableName',\n" +
                "                c.column_name AS 'columnName',\n" +
                "                c.data_type   AS 'datatype',\n" +
                "                c.character_maximum_length AS 'maxLength',\n" +
                "                c.numeric_precision AS 'numPrecision',\n" +
                "                c.numeric_scale AS 'numScale',\n" +
                "                IF (c.is_nullable = 'YES', TRUE, FALSE) AS 'isNullable',\n" +
                "                IF (tc.constraint_type = 'PRIMARY KEY', TRUE, FALSE) AS 'isPrimary',\n" +
                "                IF (tc.constraint_type = 'UNIQUE', TRUE, FALSE) AS 'isUnique',\n" +
                "                IF (tc.constraint_type IS NULL AND s.index_name IS NOT NULL, TRUE, FALSE) AS 'isIndex'\n" +
                "FROM information_schema.columns c\n" +
                "         LEFT JOIN information_schema.statistics s\n" +
                "                   ON c.column_name = s.column_name AND c.table_schema = s.table_schema AND c.table_name = s.table_name\n" +
                "         LEFT JOIN information_schema.table_constraints tc ON s.index_name = tc.constraint_name\n" +
                "WHERE c.table_schema = :schemaName\n" +
                "  AND c.table_name = :tableName",
        resultSetMapping = "MfoaActualTableSpecMapping"
)
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "mfoa_table_spec")
@IdClass(value = TableSpecId.class)
public class TableSpecModel {

    @Id
    @Column(name = "a_table_name")
    private String tableName;

    @Id
    @Column(name = "a_column_name")
    private String columnName;

    @Column(name = "is_nullable")
    private Boolean isNullable;

    @Column(name = "is_pk")
    private Boolean isPk;

    @Column(name = "is_unique")
    private Boolean isUnique;

    @Column(name = "is_index")
    private Boolean isIndex;

    @Column(name = "is_auto_increment")
    private Boolean isAutoIncrement;

    @Column(name = "default_value")
    private String defaultValue;

    @Column(name = "data_type")
    private String dataType;

    @Column(name = "max_length")
    private Integer characterMaxLength;

    @Column(name = "a_precision")
    private Integer numericPrecision;

    @Column(name = "scale")
    private Integer numericScale;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        return o != null && Hibernate.getClass(this) == Hibernate.getClass(o);
    }

    @Override
    public int hashCode() {
        return 0;
    }
}
