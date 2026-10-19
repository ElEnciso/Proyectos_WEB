package com.ipn.mx.tareas4bm2.control;

import com.ipn.mx.tareas4bm2.domain.Tarea;
import com.ipn.mx.tareas4bm2.service.TareaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

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

    @GetMapping("/tareas/{id}")
    public Tarea read(@PathVariable Long id){
        return service.findById(id);
    }

    @PostMapping("/tareas")
    @ResponseStatus(HttpStatus.CREATED)
    public Tarea save(@RequestBody Tarea tarea){
        return service.save(tarea);
    }

    public class TareaController{
        @PostMapping("/tareas/{id}")
        @ResponseStatus(HttpStatus.OK)
        public Tarea update(@RequestBody Tarea tarea,
                            @PathVariable Long id){
            Tarea t = service.findById(id);
            t.setNombre(tarea.getNombre());
            t.setDescripcion(tarea.getDescripcion());
            t.setActivo(tarea.isActivo());
            return service.save(t);
        }

        @DeleteMapping("/tareas/{id}")
        @ResponseStatus(HttpStatus.NO_CONTENT)
        public void delete(@PathVariable Long id){
            service.deleteById(id);
        }
    }
}
