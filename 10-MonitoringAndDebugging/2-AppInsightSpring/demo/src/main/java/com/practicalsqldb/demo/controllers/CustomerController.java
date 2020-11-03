package com.practicalsqldb.demo.controllers;

import com.microsoft.applicationinsights.TelemetryClient;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.microsoft.applicationinsights.telemetry.Duration;
import com.practicalsqldb.demo.repositories.*;
import com.practicalsqldb.demo.models.*;

import java.util.*;

@RestController
@RequestMapping("/")
public class CustomerController {

    @Autowired
    TelemetryClient telemetryClient;

    @Autowired
    private final CustomerRepository customerRepository;

    public CustomerController(CustomerRepository customerRepository) {
        this.customerRepository = customerRepository;
    }

    @GetMapping("/customer")
    public Iterable<Customer>  getCustomers() {

        try {

            List<Customer> customers;

            //track a custom event  
            telemetryClient.trackEvent("URI /customer is triggered");

            //trace a custom trace
            telemetryClient.trackTrace("Sending a custom trace....");

            // measure DB query benchmark
            long startTime = System.currentTimeMillis();
            customers = customerRepository.findAll();
            long endTime = System.currentTimeMillis();
            int duration = (int)((endTime-startTime));

            //track a custom dependency
            telemetryClient.trackDependency("SQL", "Insert", new Duration(0, 0, 0, 0, duration), true);

            telemetryClient.trackMetric("DB query", duration);

            return customers;
        } catch (Exception e) {
            // send exception information
            telemetryClient.trackEvent("Error");
            telemetryClient.trackTrace("Exception: " + e.getMessage());
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,e.getMessage());
        }
    }
}