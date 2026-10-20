package com.ipn.mx.frases.control;

import com.ipn.mx.frases.domain.Frase;
import com.ipn.mx.frases.service.FraseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/frase")
public class FraseController {

    @Autowired
    private FraseService service;

    @GetMapping("/frases")
    public List<Frase> readAll(){
        return service.findAll();
    }

    @GetMapping("/frases/{id}")
    public Frase read(@PathVariable Long id){
        return service.findById(id);
    }

    @PostMapping("/frases")
    @ResponseStatus(HttpStatus.CREATED)
    public Frase save(@RequestBody Frase frase){
        return service.save(frase);
    }

    @PostMapping("/frases/{id}")
    @ResponseStatus(HttpStatus.OK)
    public Frase update(@RequestBody Frase frase, @PathVariable Long id){
        Frase f = service.findById(id);
        if (f != null) {
            f.setTextoFrase(frase.getTextoFrase());
            f.setAutorFrase(frase.getAutorFrase());
            f.setOrigenFrase(frase.getOrigenFrase());
            return service.save(f);
        }
        return null;
    }

    @DeleteMapping("/frases/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id){
        service.deleteById(id);
    }
}