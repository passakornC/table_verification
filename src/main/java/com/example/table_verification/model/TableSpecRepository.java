package com.example.table_verification.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TableSpecRepository extends JpaRepository<TableSpecModel, TableSpecId> {

    @Query(nativeQuery = true)
    List<MfoaActualTableModel> getMfoaActualTableSpec(@Param("schemaName") String schemaName, @Param("tableName") String tableName);

}
