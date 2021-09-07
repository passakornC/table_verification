package com.example.table_verification.batch;

import com.example.table_verification.model.TableSpecModel;
import com.example.table_verification.model.TableSpecRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.batch.item.ItemWriter;
import org.springframework.stereotype.Component;

import java.util.List;

@RequiredArgsConstructor
@Component
public class ImportDbSpecWriter implements ItemWriter<TableSpecModel> {

    final private TableSpecRepository tableSpecRepository;

    @Override
    public void write(List<? extends TableSpecModel> list) throws Exception {
        this.tableSpecRepository.saveAll(list);
    }

}
