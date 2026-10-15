package com.ipn.mx.tareas4bm2.service;

import com.ipn.mx.tareas4bm2.domain.Tarea;

import java.util.List;

public interface TareaService {
    public List<Tarea> findAll();
    public Tarea findById(Long id);
    public Tarea save (Tarea tarea);
    public void deleteById(Long id);

}
