package com.ipn.mx.frases.service;

import com.ipn.mx.frases.domain.Frase;
import com.ipn.mx.frases.repository.FraseRepository;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FraseServiceImpl implements FraseService {

    @Autowired
    private FraseRepository repository;

    @Override
    @Transactional(readOnly = true)
    public Frase findById(Long id){
        return repository.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Frase save(Frase frase){
        return repository.save(frase);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Frase> findAll() {
        return repository.findAll();
    }

    @Override
    @Transactional
    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}