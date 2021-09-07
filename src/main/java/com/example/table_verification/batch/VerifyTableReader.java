package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.TableSpecRepository;
import org.springframework.batch.item.ItemReader;
import org.springframework.batch.item.NonTransientResourceException;
import org.springframework.batch.item.ParseException;
import org.springframework.batch.item.UnexpectedInputException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Iterator;

@Component
public class VerifyTableReader implements ItemReader<TableSpecModel> {

    private final Iterator<TableSpecModel> iterator;

    @Autowired
    public VerifyTableReader(TableSpecRepository tableSpecRepository) {
        this.iterator = tableSpecRepository.findAll().iterator();
    }

    @Override
    public TableSpecModel read() throws Exception, UnexpectedInputException, ParseException, NonTransientResourceException {
        TableSpecModel result;

        if (iterator.hasNext()) {
            result = iterator.next();
        } else {
            result = null;
        }

        return result;
    }
}
