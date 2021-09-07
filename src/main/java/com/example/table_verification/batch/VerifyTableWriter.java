package com.example.table_verification.batch;

import com.example.table_verification.model.VerifiedResultModel;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.ItemWriter;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class VerifyTableWriter implements ItemWriter<VerifiedResultModel> {

    @Override
    public void write(List<? extends VerifiedResultModel> list) throws Exception {

    }

}
