package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.VerifiedResultModel;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.ItemProcessor;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class VerifyTableProcessor implements ItemProcessor<TableSpecModel, VerifiedResultModel> {

    @Override
    public VerifiedResultModel process(TableSpecModel o) throws Exception {
        System.out.println(o.toString());
        return null;
    }
}
