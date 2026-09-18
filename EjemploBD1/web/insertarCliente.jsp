<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    String nombre = request.getParameter("nombre");
    String apellido_paterno = request.getParameter("apellido_paterno");
    String apellido_materno = request.getParameter("apellido_materno");
    String idEmpresa = request.getParameter("idEmpresa");

    if (nombre != null && !nombre.trim().isEmpty() && idEmpresa != null) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            String qry = "INSERT INTO clientes (nombre, apellido_paterno, apellido_materno, idEmpresa) VALUES ("
                    + "'" + nombre + "', "
                    + "'" + apellido_paterno + "', "
                    + "'" + apellido_materno + "', "
                    + idEmpresa + ")";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
        } catch (Exception ex) {
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; border: 1px solid #f5c6cb;'>");
            out.print("<h3 style='margin-top: 0;'>❌ Error al insertar Cliente</h3>");
            out.print("<p>Asegúrate de que el <b>ID de Empresa</b> (" + idEmpresa + ") exista en el catálogo de Empresas.</p>");
            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
            out.print("<br><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #721c24; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a>");
            out.print("</div>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>El Nombre y la Empresa son obligatorios.</h3>");
    }
%>