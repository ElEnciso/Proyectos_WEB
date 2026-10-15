package com.ipn.mx.tareas4bm2.control;

import com.ipn.mx.tareas4bm2.domain.Tarea;
import com.ipn.mx.tareas4bm2.service.TareaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/tarea")
public class TareaControler {
    @Autowired
    private TareaService service;
    @GetMapping("/tareas")
    public List<Tarea> readAll(){
        return service.findAll();
    }
}
