<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Conexion.Base"%>
<%
    request.setCharacterEncoding("UTF-8");
    
    // Capturamos el dato con el nuevo nombre definido en Form.html
    String nombre = request.getParameter("nombre");

    // Validamos que el nombre no venga vacío
    if (nombre != null && !nombre.trim().isEmpty()) {
        Base bd = new Base();
        try {
            bd.conectar();
            
            // Insertamos usando el nuevo nombre de la columna (nombre en lugar de nombre_ar)
            String qry = "INSERT INTO areas (nombre) VALUES ('" + nombre + "')";
            
            bd.insertar(qry);
            bd.cierraConexion();
            
            response.sendRedirect("tablaPersonas.jsp");
        } catch (Exception ex) {
            out.print("<div style='max-width: 600px; margin: 40px auto; font-family: Arial, sans-serif; background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; border: 1px solid #f5c6cb;'>");
            out.print("<h3 style='margin-top: 0;'>❌ Error al insertar Área</h3>");
            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
            out.print("<br><a href='Form.html' style='display: inline-block; padding: 10px 20px; background-color: #721c24; color: white; text-decoration: none; border-radius: 5px;'>Volver al Formulario</a>");
            out.print("</div>");
        }
    } else {
        out.print("<h3 style='color: red; text-align: center; margin-top: 50px; font-family: Arial;'>El Nombre del Área es obligatorio.</h3>");
    }
%>