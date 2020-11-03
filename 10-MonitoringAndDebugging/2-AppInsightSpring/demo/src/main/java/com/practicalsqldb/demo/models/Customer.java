package com.practicalsqldb.demo.models;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Column;
import org.springframework.data.relational.core.mapping.Table;

@Table("Customer")
public class Customer {

    @Id
    @Column("CustomerID")
    public Integer CustomerID;

    @Column("CustomerName")
    public String CustomerName;
}
