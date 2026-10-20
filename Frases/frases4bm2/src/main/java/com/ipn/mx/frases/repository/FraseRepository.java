package com.ipn.mx.frases.repository;

import com.ipn.mx.frases.domain.Frase;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FraseRepository extends JpaRepository<Frase, Long> {

}