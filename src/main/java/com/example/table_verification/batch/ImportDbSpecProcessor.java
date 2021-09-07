package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.TextFileModel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class ImportDbSpecProcessor implements ItemProcessor<TextFileModel, TableSpecModel> {

    @Override
    public TableSpecModel process(TextFileModel textFileModel) throws Exception {
        TableSpecModel result = new TableSpecModel();

        result.setTableName(textFileModel.getTableName().toLowerCase());
        result.setColumnName(textFileModel.getColumnName().toLowerCase());
        result.setIsNullable(textFileModel.getIsNullable().compareToIgnoreCase("yes") == 0 || textFileModel.getIsNullable().compareToIgnoreCase("y") == 0);
        result.setIsPk(textFileModel.getIsPk().compareToIgnoreCase("p") == 0);
        result.setIsUnique(textFileModel.getIsUnique().compareToIgnoreCase("u") == 0);
        result.setIsIndex(textFileModel.getIsIndex().compareToIgnoreCase("i") == 0);
        result.setIsAutoIncrement(textFileModel.getIsAutoIncrement().compareToIgnoreCase("a") == 0);
        result.setDefaultValue(textFileModel.getDefaultValue().trim().isBlank() ? null : textFileModel.getDefaultValue().trim());

        // de component data typeBook3.csv
        String item = textFileModel.getDataType().trim().toLowerCase();
        if (item.contains("varchar")) {
            // varchar(20)
            result.setDataType("varchar");
            result.setCharacterMaxLength(Integer.parseInt(item.substring(item.indexOf('(') + 1, item.lastIndexOf(')')).trim()));
        } else if (item.contains("decimal")) {
            // decimal(18,0)
            String mag = item.substring(item.indexOf('(') + 1, item.lastIndexOf(')')).trim();
            if (mag.contains(",")) {
                String[] splitText = mag.split(",");
                result.setNumericPrecision(Integer.parseInt(splitText[0].trim()));
                result.setNumericScale(Integer.parseInt(splitText[1].trim()));
            } else {
                result.setNumericPrecision(Integer.parseInt(mag.trim()));
                result.setNumericScale(0);
            }
            result.setDataType("decimal");
        } else if (item.contains("integer")) {
            result.setDataType("int");
            if (item.contains("(")) {
                result.setNumericPrecision(Integer.parseInt(item.substring(item.indexOf('(') + 1, item.lastIndexOf(')')).trim()));
            }
            result.setNumericScale(0);
        } else if (item.contains("unsigned int")) {
            result.setDataType("unsigned int");
        } else if (item.contains("big int")) {
            result.setDataType("bigint");
        } else if (item.contains("boolean")) {
            result.setDataType("tinyint");
        } else if (item.contains("datetime")) {
            result.setDataType("datetime");
        } else if (item.contains("date")) {
            result.setDataType("date");
        } else if (item.contains("time")) {
            result.setDataType("time");
        } else if (item.contains("text")) {
            result.setDataType("text");
        }

        return result;
    }

}
