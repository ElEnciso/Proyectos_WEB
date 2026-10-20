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
        // Prueba 1
        Frase f1 = new Frase();
        f1.setTextoFrase("Pienso, luego existo.");
        f1.setAutorFrase("René Descartes");
        f1.setOrigenFrase("Discurso del método (1637)");
        repository.save(f1);

        // Prueba 2
        Frase f2 = new Frase();
        f2.setTextoFrase("La imaginación es más importante que el conocimiento.");
        f2.setAutorFrase("Albert Einstein");
        f2.setOrigenFrase("Entrevista en The Saturday Evening Post (1929)");
        repository.save(f2);

        System.out.println("¡Frases guardadas correctamente con el nuevo esquema!");
    }
}