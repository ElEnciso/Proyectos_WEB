package com.ipn.mx.frases.domain;

import jakarta.persistence.*;
import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Frase")
public class Frase {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idFrase;

    @Column(length = 500, nullable = false)
    private String textoFrase;

    @Column(length = 500, nullable = false)
    private String autorFrase;

    @Column(length = 200, nullable = false)
    private String origenFrase;
}