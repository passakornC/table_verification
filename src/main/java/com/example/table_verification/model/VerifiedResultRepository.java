package com.example.table_verification.model;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface VerifiedResultRepository extends JpaRepository<VerifiedResultModel, String> {
}
