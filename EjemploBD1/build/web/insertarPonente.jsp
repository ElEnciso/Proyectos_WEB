<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    String nombre = request.getParameter("nombre");
    String apellido_paterno = request.getParameter("apellido_paterno");
    String apellido_materno = request.getParameter("apellido_materno");
    String correo = request.getParameter("correo");
    String telefono = request.getParameter("telefono");
    String idHistorial = request.getParameter("idHistorial");

    if (nombre != null && !nombre.trim().isEmpty() && idHistorial != null) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            String qry = "INSERT INTO ponentes (nombre, apellido_paterno, apellido_materno, correo, telefono, idHistorial) VALUES ("
                    + "'" + nombre + "', "
                    + "'" + apellido_paterno + "', "
                    + "'" + apellido_materno + "', "
                    + "'" + correo + "', "
                    + "'" + telefono + "', "
                    + idHistorial + ")";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
        } catch (Exception ex) {
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; border: 1px solid #f5c6cb;'>");
            out.print("<h3 style='margin-top: 0;'>❌ Error al insertar Ponente</h3>");
            out.print("<p>Asegúrate de que el <b>ID de Historial</b> (" + idHistorial + ") exista en la tabla Historial Académico.</p>");
            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
            out.print("<br><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #721c24; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a>");
            out.print("</div>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>Faltan datos obligatorios para registrar al ponente.</h3>");
    }
%>