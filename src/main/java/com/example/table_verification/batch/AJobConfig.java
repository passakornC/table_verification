package com.example.table_verification.batch;

import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.configuration.annotation.JobBuilderFactory;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@RequiredArgsConstructor
@EnableBatchProcessing
@Configuration
public class AJobConfig {

    final private JobBuilderFactory jobBuilderFactory;
    final private ImportDbSpecStep importDbSpecStep;
//    final private VerifyTableStep verifyTableStep;

    @Bean
    public Job verifyTableJob() {
        return this.jobBuilderFactory.get("verifyTableJob")
                .incrementer(new RunIdIncrementer())
                .start(importDbSpecStep.execute())
//                .start(verifyTableStep.execute())
                .build();
    }

}
