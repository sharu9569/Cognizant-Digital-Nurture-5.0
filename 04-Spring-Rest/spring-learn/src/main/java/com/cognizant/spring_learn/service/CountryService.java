package com.cognizant.spring_learn.service;

import com.cognizant.spring_learn.Country;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class CountryService {

    private final List<Country> countries = new ArrayList<>();

    public CountryService() {

        Country c1 = new Country();
        c1.setCode("IN");
        c1.setName("India");

        Country c2 = new Country();
        c2.setCode("US");
        c2.setName("United States");

        Country c3 = new Country();
        c3.setCode("JP");
        c3.setName("Japan");

        Country c4 = new Country();
        c4.setCode("DE");
        c4.setName("Germany");

        countries.add(c1);
        countries.add(c2);
        countries.add(c3);
        countries.add(c4);
    }

    public Country getCountry(String code) {

        for (Country c : countries) {

            if (c.getCode().equalsIgnoreCase(code)) {
                return c;
            }

        }

        return null;
    }
}