package com.example.jekinstest.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author gongyiming
 */
@RestController
@RequestMapping("/test")
public class TestController {
    @GetMapping("/hello")
    public String helloSpring() {
        return "hello Jenkins!";
    }
}
