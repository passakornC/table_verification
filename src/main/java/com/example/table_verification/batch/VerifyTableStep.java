package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.VerifiedResultModel;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class VerifyTableStep {

    final private StepBuilderFactory stepBuilderFactory;
    final private VerifyTableReader reader;
    final private VerifyTableProcessor processor;
    final private VerifyTableWriter writer;

    public Step execute() {
        return this.stepBuilderFactory.get("VerifyTableStep")
                .<TableSpecModel, VerifiedResultModel>chunk(100)
                .reader(this.reader)
                .processor(this.processor)
                .writer(this.writer)
                .build();
    }

}
