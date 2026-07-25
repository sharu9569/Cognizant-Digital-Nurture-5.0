package com.cognizant.spring_learn.controller;

import com.cognizant.spring_learn.Country;
import com.cognizant.spring_learn.service.CountryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
public class CountryController {

    @Autowired
    CountryService service;

    @GetMapping("/country")
    public Country getCountryIndia() {
        return service.getCountry("IN");
    }

    @GetMapping("/countries/{code}")
    public Country getCountry(@PathVariable String code) {

        return service.getCountry(code);

    }
}