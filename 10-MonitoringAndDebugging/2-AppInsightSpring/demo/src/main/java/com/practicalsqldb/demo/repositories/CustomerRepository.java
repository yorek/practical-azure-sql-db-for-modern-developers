package com.practicalsqldb.demo.repositories;

import java.util.List;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jdbc.repository.query.*;

import com.practicalsqldb.demo.models.Customer;

@Repository
public interface CustomerRepository extends CrudRepository<Customer, Long> {
    @Query("SELECT TOP 10 CustomerID, CustomerName FROM Sales.Customers")
    List<Customer> findAll();
}