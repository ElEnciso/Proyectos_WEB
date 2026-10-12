package com.ipn.mx.tareas4bm2;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@SpringBootApplication
public class Tareas4bm2Application {
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Tarea {
        private int idTarea;
        private String nombre;
        private String descripcion;
        private boolean activo;
    }

    public static class TareaDAO {
        public static final String SQL_INSERT = "insert into Tarea(nombre, descripcion, activo) values(?,?,?)";
        public static final String SQL_DELETE = "delete from Tarea where idTarea=?";
        public static final String SQL_UPDATE = "update Tarea set nombre=?, descripcion=?, activo=? where idTarea=?";
        public static final String SQL_SELECTALL = "select * from Tarea";
        public static final String SQL_SELECT = "select * from Tarea where idTarea=?";

        private Connection con;

        private void obtenerConexion() {
            String url = "jdbc:mysql://localhost:3306/Tareas4bm2";
            String usuario = "root";
            String clave = "root";
            String driver = "com.mysql.cj.jdbc.Driver";

            try {
                Class.forName(driver);
                con = DriverManager.getConnection(url, usuario, clave);
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
        }

        public void create(Tarea t) throws SQLException {
            obtenerConexion();
            PreparedStatement ps = null;
            try {
                ps = con.prepareStatement(TareaDAO.SQL_INSERT);

                ps.setString(1, t.getNombre());
                ps.setString(2, t.getDescripcion());
                ps.setBoolean(3, t.isActivo());

                ps.executeUpdate();
            } finally {
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        }

        public void delete(Tarea t) throws SQLException{
            obtenerConexion();
            PreparedStatement ps = null;
            try {
                ps = con.prepareStatement(TareaDAO.SQL_DELETE);

                ps.setInt(1,t.getIdTarea());

                ps.executeUpdate();
            }finally {
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        }

        public void update(Tarea t) throws SQLException {
            obtenerConexion();
            PreparedStatement ps = null;
            try {
                ps = con.prepareStatement(TareaDAO.SQL_UPDATE);

                ps.setInt(1, t.getIdTarea());
                ps.setString(2, t.getNombre());
                ps.setString(3, t.getDescripcion());
                ps.setBoolean(4, t.isActivo());

                ps.executeUpdate();
            } finally {
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        }
    }

    public static void main(String[] args) {
        SpringApplication.run(Tareas4bm2Application.class, args);

        Tarea t = new Tarea();
        t.setNombre("Conquistar el mundo");
        t.setDescripcion("Es lo que hacemos todas las noches Pinky");
        t.setActivo(true);

        TareaDAO dao = new TareaDAO();
        try {
            dao.create(t);
            System.out.println("Tarea guardada correctamente!");
        }catch (Exception e){
            System.out.println("Ocurrio un error");
            e.printStackTrace();
        }

        System.out.println(t.getNombre());
        System.out.println(t.getDescripcion());
        System.out.println(t.isActivo());
    }
}