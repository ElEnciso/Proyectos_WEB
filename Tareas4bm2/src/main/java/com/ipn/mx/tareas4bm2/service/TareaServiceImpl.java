package com.ipn.mx.tareas4bm2.service;

import com.ipn.mx.tareas4bm2.domain.Tarea;
import com.ipn.mx.tareas4bm2.repository.TareaRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TareaServiceImpl implements TareaService{
    @Autowired
    private TareaRepository repository;
    @Override
    public List<Tarea> findAll() {
        return List.of();
    }

    @Override
    public Tarea findById(Long id) {
        return null;
    }

    @Override
    public Tarea save(Tarea tarea) {
        return null;
    }

    @Override
    public void deleteById(Long id) {

    }
}
