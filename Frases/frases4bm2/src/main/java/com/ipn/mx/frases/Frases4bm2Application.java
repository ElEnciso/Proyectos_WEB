package com.ipn.mx.frases;

import com.ipn.mx.frases.domain.Frase;
import com.ipn.mx.frases.repository.FraseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Frases4bm2Application implements CommandLineRunner {

    @Autowired
    private FraseRepository repository;

    public static void main(String[] args) {
        SpringApplication.run(Frases4bm2Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {

        System.out.println("¡API Funcionando!");
    }
}