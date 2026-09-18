<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%@page import="java.sql.SQLException"%>

<%
    request.setCharacterEncoding("UTF-8");
    
    String titulo_ingles = request.getParameter("titulo_ingles");
    String titulo_espanol = request.getParameter("titulo_espanol");
    String fecha_publicacion = request.getParameter("fecha_publicacion");
    String abstract_ingles = request.getParameter("abstract_ingles");
    String abstract_espanol = request.getParameter("abstract_espanol");
    String idEdicion = request.getParameter("idEdicion");

    if (titulo_ingles != null && !titulo_ingles.trim().isEmpty() && idEdicion != null) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            // 1. Invocamos el Procedimiento Almacenado en lugar del INSERT directo
            String qry = "CALL RegistraArticulo("
                    + "'" + titulo_ingles + "', "
                    + "'" + titulo_espanol + "', "
                    + "'" + fecha_publicacion + "', "
                    + "'" + abstract_ingles + "', "
                    + "'" + abstract_espanol + "', "
                    + idEdicion + ")";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
            
        } catch (SQLException ex) {
            // 2. Atrapamos los errores de la Base de Datos (incluyendo el Trigger)
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; padding: 20px; border-radius: 8px;'>");
            
            // Si el error es el 45000, significa que el Trigger detuvo la inserción por la fecha
            if ("45000".equals(ex.getSQLState())) {
                out.print("<div style='background-color: #fff3cd; color: #856404; padding: 15px; border-left: 5px solid #ffeeba;'>");
                out.print("<h3 style='margin-top: 0;'>⚠️ Aviso del Sistema</h3>");
                out.print("<p><b>" + ex.getMessage() + "</b></p>");
                out.print("</div>");
            } else {
                // Si es cualquier otro error (ej. llave foránea que no existe)
                out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 15px; border: 1px solid #f5c6cb;'>");
                out.print("<h3 style='margin-top: 0;'>❌ Error de Base de Datos</h3>");
                out.print("<p>Asegúrate de que el <b>ID de Edición</b> (" + idEdicion + ") exista en el catálogo de Ediciones.</p>");
                out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
                out.print("</div>");
            }
            
            out.print("<br><div style='text-align: center;'><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #2c3e50; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a></div>");
            out.print("</div>");
            
        } catch (Exception ex) {
            // Atrapa cualquier otro error de Java que no sea de SQL
            out.print("<h3 style='color: red; text-align: center;'>Error general del sistema: " + ex.getMessage() + "</h3>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>Faltan datos obligatorios para el artículo.</h3>");
    }
%>