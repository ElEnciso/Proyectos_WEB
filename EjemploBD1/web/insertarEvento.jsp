<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    // Capturamos todos los datos con los nuevos nombres del Form.html
    String nombre = request.getParameter("nombre");
    String fecha = request.getParameter("fecha");
    String tipo_evento = request.getParameter("tipo_evento");
    String horario = request.getParameter("horario");

    // Validamos que el nombre y la fecha no vengan vacíos
    if (nombre != null && !nombre.trim().isEmpty() && fecha != null && !fecha.trim().isEmpty()) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            // Insertamos los 4 campos correspondientes a la nueva estructura
            String qry = "INSERT INTO eventos (nombre, fecha, tipo_evento, horario) VALUES ("
                    + "'" + nombre + "', "
                    + "'" + fecha + "', "
                    + "'" + tipo_evento + "', "
                    + "'" + horario + "')";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
        } catch (Exception ex) {
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; border: 1px solid #f5c6cb;'>");
            out.print("<h3 style='margin-top: 0;'>❌ Error al insertar Evento</h3>");
            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
            out.print("<br><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #721c24; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a>");
            out.print("</div>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>El Nombre y la Fecha del evento son obligatorios.</h3>");
    }
%>