package com.ipn.mx.tareas4bm2.domain;

import jakarta.persistence.*;
import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Tarea")

public class Tarea{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idTarea;
    @Column(length = 50, nullable = false, unique = true)
    private String nombre;
    @Column(nullable = false)
    private String descripcion;
    private boolean activo;
}
