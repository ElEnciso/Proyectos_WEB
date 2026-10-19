package com.ipn.mx.tareas4bm2.service;

import com.ipn.mx.tareas4bm2.domain.Tarea;
import com.ipn.mx.tareas4bm2.repository.TareaRepository;
import org.springframework.transaction.annotation.Transactional; // Import corregido
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TareaServiceImpl implements TareaService {

    @Autowired
    private TareaRepository repository;

    @Override
    @Transactional(readOnly = true)
    public Tarea findById(Long id){
        return repository.findById(id).orElse(null);
    }

    @Override
    @Transactional
    public Tarea save(Tarea tarea){
        // Corregido: Ahora guarda la entidad en lugar de buscar un ID
        return repository.save(tarea);
    }

    @Override
    public List<Tarea> findAll() {
        // Corregido: Retorna todas las tareas de la base de datos
        return repository.findAll();
    }

    @Override
    public void deleteById(Long id) {
        // Corregido: Elimina la tarea por su ID
        repository.deleteById(id);
    }
}