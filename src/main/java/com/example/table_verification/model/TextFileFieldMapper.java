package com.example.table_verification.model;

import com.example.table_verification.model.TextFileModel;
import org.springframework.batch.item.file.mapping.FieldSetMapper;
import org.springframework.batch.item.file.transform.FieldSet;
import org.springframework.stereotype.Component;
import org.springframework.validation.BindException;

@Component
public class TextFileFieldMapper implements FieldSetMapper<TextFileModel> {

    @Override
    public TextFileModel mapFieldSet(FieldSet fieldSet) throws BindException {
        TextFileModel result = new TextFileModel();

        result.setTableName(fieldSet.readString(0));
        result.setColumnName(fieldSet.readString(1));
        result.setDataType(fieldSet.readString(2));
        result.setIsNullable(fieldSet.readString(3));
        result.setIsPk(fieldSet.readString(4));
        result.setIsUnique(fieldSet.readString(5));
        result.setIsIndex(fieldSet.readString(6));
        result.setDefaultValue(fieldSet.readString(7));
        result.setIsAutoIncrement(fieldSet.readString(8));

        return result;
    }

}
