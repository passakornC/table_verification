package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.TextFileFieldMapper;
import com.example.table_verification.model.TextFileModel;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.StepBuilderFactory;
import org.springframework.batch.item.ExecutionContext;
import org.springframework.batch.item.file.FlatFileItemReader;
import org.springframework.batch.item.file.mapping.DefaultLineMapper;
import org.springframework.batch.item.file.transform.DelimitedLineTokenizer;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.FileSystemResource;
import org.springframework.stereotype.Component;

@RequiredArgsConstructor
@Component
public class ImportDbSpecStep {

    final private StepBuilderFactory stepBuilderFactory;
    final private TextFileFieldMapper fieldMapper;
    final private ImportDbSpecProcessor processTextFile;
    final private ImportDbSpecWriter writer;

    public Step execute() {
        return this.stepBuilderFactory.get("ImportDbSpecStep")
                .<TextFileModel, TableSpecModel>chunk(1000)
                .reader(reader("input/mfoa_design_spec_1.txt"))
                .processor(this.processTextFile)
                .writer(this.writer)
                .build();
    }

    private FlatFileItemReader<TextFileModel> reader(String input) {
        FlatFileItemReader<TextFileModel> result = new FlatFileItemReader<>();
        result.setResource(new FileSystemResource(input));
        result.setLinesToSkip(1);

        DelimitedLineTokenizer tokenizer = new DelimitedLineTokenizer();
        tokenizer.setDelimiter("\t");

        DefaultLineMapper<TextFileModel> lineMapper = new DefaultLineMapper<>();
        lineMapper.setLineTokenizer(tokenizer);
        lineMapper.setFieldSetMapper(this.fieldMapper);

        result.setLineMapper(lineMapper);
        result.open(new ExecutionContext());

        return result;
    }

}
