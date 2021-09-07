package com.example.table_verification.model;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import org.hibernate.Hibernate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Getter
@Setter
@ToString
@RequiredArgsConstructor
@Entity
@Table(name = "mfoa_verified_result")
public class VerifiedResultModel {

    @Id
    @Column(name = "a_table_name")
    private String tableName;

    @Column(name = "need_to_modify")
    private Boolean needToModify;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        return o != null && Hibernate.getClass(this) == Hibernate.getClass(o);
    }

    @Override
    public int hashCode() {
        return 0;
    }
}
