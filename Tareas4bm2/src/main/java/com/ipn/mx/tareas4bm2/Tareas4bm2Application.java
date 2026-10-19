package com.ipn.mx.tareas4bm2;

import com.ipn.mx.tareas4bm2.domain.Tarea;
import com.ipn.mx.tareas4bm2.repository.TareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Tareas4bm2Application implements CommandLineRunner {

    @Autowired
    private TareaRepository repository;

    public static void main(String[] args) {
        SpringApplication.run(Tareas4bm2Application.class, args);
    }

    @Override
    public void run(String... args) throws Exception {
        // Prueba 1: Estudiar para el parcial
        Tarea t1 = new Tarea();
        t1.setNombre("Estudiar para el segundo parcial");
        t1.setDescripcion("Lo mismo que el nombre");
        t1.setActivo(true);
        // Omitimos setear el ID manualmente (ej. t1.setIdTarea(3L))
        // para permitir que MySQL y Spring Boot lo autoincrementen.
        repository.save(t1);

        // Prueba 2: La tarea de Pinky y Cerebro
        Tarea t2 = new Tarea();
        t2.setNombre("Conquistar el mundo");
        t2.setDescripcion("Es lo que hacemos todas las noches Pinky");
        t2.setActivo(true);
        repository.save(t2);

        System.out.println("¡Tareas guardadas correctamente usando JPA y Spring Boot!");
    }
}