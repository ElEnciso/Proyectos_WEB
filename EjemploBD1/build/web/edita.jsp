<%@page import="Conexion.Base"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="CSS/estilos.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Procesando Edición Dinámica</title>
        <style>
            .alert-container { max-width: 600px; margin: 50px auto; font-family: Arial, sans-serif; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
            .btn-back { display: inline-block; margin-top: 15px; padding: 10px 20px; color: white; text-decoration: none; border-radius: 5px; font-weight: bold; transition: background 0.3s; }
        </style>
    </head>
    <body style="background-color: #f4f6f9;">
        <%
            request.setCharacterEncoding("UTF-8");
            String tabla = request.getParameter("nomTabla");
            String txtId = request.getParameter("TxtId");
            
            // Recolección genérica de inputs del formulario
            String val1 = request.getParameter("val1");
            String val2 = request.getParameter("val2");
            String val3 = request.getParameter("val3");
            String val4 = request.getParameter("val4");
            String val5 = request.getParameter("val5");
            String val6 = request.getParameter("val6"); // Crucial para ponentes y articulos
            
            if (txtId != null && tabla != null) {
                try {
                    int id = Integer.parseInt(txtId.trim());
                    Base bd = new Base();
                    bd.conectar();
                    String strQry = "";
                    
                    // Ensamblado condicional según la estructura del esquema
                    if (tabla.equals("clientes")) {
                        strQry = "UPDATE clientes SET nombre='" + val1 + "', apellido_paterno='" + val2 + "', apellido_materno='" + val3 + "', idEmpresa=" + Integer.parseInt(val4.trim()) + " WHERE idCliente=" + id;
                    } 
                    else if (tabla.equals("empresas")) {
                        strQry = "UPDATE empresas SET nombre='" + val1 + "', correo='" + val2 + "', telefono='" + val3 + "', idAliado=" + Integer.parseInt(val4.trim()) + " WHERE idEmpresa=" + id;
                    } 
                    else if (tabla.equals("aliados")) {
                        strQry = "UPDATE aliados SET nombre_aliado='" + val1 + "', tipo_alianza='" + val2 + "' WHERE idAliado=" + id;
                    } 
                    else if (tabla.equals("areas")) {
                        strQry = "UPDATE areas SET nombre='" + val1 + "' WHERE idArea=" + id;
                    } 
                    else if (tabla.equals("eventos")) {
                        strQry = "UPDATE eventos SET nombre='" + val1 + "', fecha='" + val2 + "', tipo_evento='" + val3 + "', horario='" + val4 + "' WHERE idEvento=" + id;
                    }
                    else if (tabla.equals("ediciones")) {
                        strQry = "UPDATE ediciones SET fecha='" + val1 + "', sede='" + val2 + "', idEvento=" + Integer.parseInt(val3.trim()) + " WHERE idEdicion=" + id;
                    } 
                    else if (tabla.equals("historial_academico")) {
                        strQry = "UPDATE historial_academico SET titulo='" + val1 + "', institucion='" + val2 + "', fecha_graduacion='" + val3 + "' WHERE idHistorial=" + id;
                    } 
                    else if (tabla.equals("ponentes")) {
                        strQry = "UPDATE ponentes SET nombre='" + val1 + "', apellido_paterno='" + val2 + "', apellido_materno='" + val3 + "', correo='" + val4 + "', telefono='" + val5 + "', idHistorial=" + Integer.parseInt(val6.trim()) + " WHERE idPonente=" + id;
                    } 
                    else if (tabla.equals("autores")) {
                        strQry = "UPDATE autores SET nombre='" + val1 + "', apellido_paterno='" + val2 + "', apellido_materno='" + val3 + "', correo='" + val4 + "' WHERE idAutor=" + id;
                    } 
                    else if (tabla.equals("articulos")) {
                        // val6 es el idEdicion. Si cambia, dispara el trigger de auditoría.
                        strQry = "UPDATE articulos SET titulo_ingles='" + val1 + "', titulo_espanol='" + val2 + "', fecha_publicacion='" + val3 + "', abstract_ingles='" + val4 + "', abstract_espanol='" + val5 + "', idEdicion=" + Integer.parseInt(val6.trim()) + " WHERE idArticulo=" + id;
                    }
                    
                    int resultadoEdita = bd.edita(strQry);
                    bd.cierraConexion();
                    
                    if (resultadoEdita == 1) {
                        // ÉXITO: Alerta JavaScript y redirección CORREGIDA a gestion.jsp
        %>
                        <script>
                            window.alert("Los datos se modificaron correctamente en el catálogo de <%=tabla%>.");
                            window.location.href = "gestion.jsp"; // Te mantiene en el módulo de gestión
                        </script>
        <%
                    } else {
                        // ERROR LÓGICO (ej. FK inexistente): Mensaje HTML y botón CORREGIDO a gestion.jsp
                        out.println("<div class='alert-container' style='background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba;'>");
                        out.println("<h2>⚠️ No se pudieron actualizar los datos.</h2>");
                        out.println("<p>Verifique que la información cumpla con los formatos requeridos y que los IDs de referencias (FK) existan en sus respectivos catálogos.</p>");
                        out.println("<a href='gestion.jsp' class='btn-back' style='background-color: #856404;'>Volver a Gestión</a>");
                        out.println("</div>");
                    }
                } catch (Exception ex) {
                    // ERROR TÉCNICO (ej. Fallo de conexión): Mensaje HTML y botón CORREGIDO a gestion.jsp
                    out.print("<div class='alert-container' style='background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;'>");
                    out.print("<h2>❌ Error Crítico de Sistema</h2>");
                    out.print("<p style='text-align: left; background: white; padding: 10px; border-radius:4px;'><b>Detalle:</b> " + ex.getMessage() + "</p>");
                    out.println("<a href='gestion.jsp' class='btn-back' style='background-color: #721c24;'>Volver al Inicio de Gestión</a>");
                    out.print("</div>");
                }
            } else {
                // DATOS INSUFICIENTES
                out.print("<div class='alert-container' style='background-color: #d1ecf1; color: #0c5460; border: 1px solid #bee5eb;'>");
                out.print("<h2>ℹ️ Datos insuficientes</h2>");
                out.print("<p>No se recibieron los parámetros necesarios para efectuar la actualización.</p>");
                out.println("<a href='gestion.jsp' class='btn-back' style='background-color: #0c5460;'>Volver</a>");
                out.print("</div>");
            }
        %>
    </body>
</html>