package com.example.springbootdockerk8s.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @GetMapping(path="/api/hello")
    public ResponseEntity<?> getMessage() {
        return ResponseEntity.ok().body("Hello World from Spring boot on K8s with Docker container via Skaffold");
    }
    @GetMapping(path="/")
    public ResponseEntity<?> get() {
        return ResponseEntity.ok().body("Hello World!");
    }
}
