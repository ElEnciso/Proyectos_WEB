<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    // Capturamos los datos con los nuevos nombres del Form.html
    String nombre = request.getParameter("nombre");
    String correo = request.getParameter("correo");
    String telefono = request.getParameter("telefono");
    String idAliado = request.getParameter("idAliado");

    // Validamos que el nombre no venga vacío
    if (nombre != null && !nombre.trim().isEmpty()) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            // Insertamos usando los nuevos nombres de las columnas en la BD
            String qry = "INSERT INTO empresas (nombre, correo, telefono, idAliado) VALUES ("
                    + "'" + nombre + "', "
                    + "'" + correo + "', "
                    + "'" + telefono + "', "
                    + idAliado + ")";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
        } catch (Exception ex) {
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; border: 1px solid #f5c6cb;'>");
            out.print("<h3 style='margin-top: 0;'>❌ Error al insertar Empresa</h3>");
            out.print("<p>Asegúrate de que el <b>ID de Aliado</b> que ingresaste (" + idAliado + ") realmente exista en el catálogo de Aliados.</p>");
            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
            out.print("<br><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #721c24; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a>");
            out.print("</div>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>El Nombre de la empresa es obligatorio.</h3>");
    }
%>