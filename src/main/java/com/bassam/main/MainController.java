package com.bassam.main;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/customers")
public class MainController {

    @GetMapping
    public ResponseEntity<String> getAllCustomers() {
        String message = "Hello World!";
        return ResponseEntity.ok(message);
    }

    @PostMapping
    public ResponseEntity<Object> createCustomer(@RequestBody Object customer) {
        return ResponseEntity.status(HttpStatus.CREATED).body(customer);
    }

}
