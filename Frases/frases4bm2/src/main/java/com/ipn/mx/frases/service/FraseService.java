package com.ipn.mx.frases.service;

import com.ipn.mx.frases.domain.Frase;
import java.util.List;

public interface FraseService {
    public List<Frase> findAll();
    public Frase findById(Long id);
    public Frase save(Frase frase);
    public void deleteById(Long id);
}