package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Alumno
 */
public class Base {
    
    private String usrBD;
    private String passBD;
    private String urlBD;
    private String driverClassName;
    private Connection conn = null;
    private Statement estancia;
    
    public Base(){
        // Agregar datos para conectarse
        this.usrBD = "root";
        this.passBD = "root";
        this.urlBD = "jdbc:mysql://base-datos:3306/ejemploBD?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

        this.driverClassName = "com.mysql.cj.jdbc.Driver"; 
    }

    // Métodos para establecer los valores de conexión a la BD
    public void setUsuarioBD(String usuario) throws SQLException {
        this.usrBD = usuario;
    }
    public void setPassBD(String pass){
        this.passBD = pass;
    }
    public void setUrlBD(String url){
        this.urlBD = url;
    }
    public void setConn(Connection conn){
        this.conn = conn;
    }
    public void setDriverClassName(String driverClassName) {
        this.driverClassName = driverClassName;
    }
    
    // Conexión a la BD
    public void conectar() throws SQLException {
        try {
            Class.forName(this.driverClassName);
            this.conn = DriverManager.getConnection(this.urlBD, this.usrBD, this.passBD);
            System.out.println("¡Conexión establecida con éxito!"); 
        } catch (ClassNotFoundException e) {
            // Si el JAR no está bien puesto en NetBeans, saltará aquí
            throw new SQLException("Error: No se encontró el Driver de MySQL en las librerías. " + e.getMessage());
        } catch (SQLException err) {
            // Si el usuario/password o la BD están mal, saltará aquí
            throw new SQLException("Error al conectar a la base de datos: " + err.getMessage());
        }
    }
    
    // Cerrar la conexión de BD
    public void cierraConexion() throws SQLException {
        if (this.conn != null && !this.conn.isClosed()) {
            this.conn.close();
        }
    }
    
    // Métodos para ejecutar sentencias SQL
    public int insertar(String inserta) throws SQLException {
        Statement st = this.conn.createStatement();
        return st.executeUpdate(inserta);
    }

    public String getUsrBD() {
        return usrBD;
    }

    public void setUsrBD(String usrBD) {
        this.usrBD = usrBD;
    }

    public Statement getEstancia() {
        return estancia;
    }

    public void setEstancia(Statement estancia) {
        this.estancia = estancia;
    }
    
    public ResultSet consulta(String consulta) throws SQLException {
        this.estancia = this.conn.createStatement();
        return this.estancia.executeQuery(consulta);
    }
    
    public int edita(String editar) throws SQLException {
        Statement st = this.conn.createStatement();
        return st.executeUpdate(editar);
    }
}