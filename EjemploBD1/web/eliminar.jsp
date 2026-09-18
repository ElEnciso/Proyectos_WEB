<%@page import="Conexion.Base"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="CSS/estilos.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Eliminar Registro</title>
    </head>
    <body>
        <h2>Procesando Eliminación</h2>
        <div style="max-width: 600px; margin: 30px auto;">
            <div class="panel-control">
                <%
                    String txtId = request.getParameter("id");
                    String tabla = request.getParameter("tabla");
                    
                    if (tabla != null && !tabla.trim().isEmpty()) {
                        try {
                            Base bd = new Base();
                            bd.conectar();
                            String strQry = "";
                            
                            // Evaluamos qué consulta armar según el nuevo esquema E-R
                            switch(tabla) {
                                case "clientes":
                                    strQry = "DELETE FROM clientes WHERE idCliente = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "empresas":
                                    strQry = "DELETE FROM empresas WHERE idEmpresa = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "aliados":
                                    strQry = "DELETE FROM aliados WHERE idAliado = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "areas":
                                    strQry = "DELETE FROM areas WHERE idArea = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "ponentes":
                                    strQry = "DELETE FROM ponentes WHERE idPonente = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "historial_academico":
                                    strQry = "DELETE FROM historial_academico WHERE idHistorial = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "eventos":
                                    strQry = "DELETE FROM eventos WHERE idEvento = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "ediciones":
                                    strQry = "DELETE FROM ediciones WHERE idEdicion = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "autores":
                                    strQry = "DELETE FROM autores WHERE idAutor = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "articulos":
                                    strQry = "DELETE FROM articulos WHERE idArticulo = " + Integer.parseInt(txtId.trim());
                                    break;
                                case "escriben":
                                    // Manejo especial de la llave compuesta Muchos a Muchos
                                    int idArt = Integer.parseInt(request.getParameter("idArticulo").trim());
                                    int idAut = Integer.parseInt(request.getParameter("idAutor").trim());
                                    strQry = "DELETE FROM escriben WHERE idArticulo = " + idArt + " AND idAutor = " + idAut;
                                    break;
                            }
                            
                            int resultadoElimina = bd.edita(strQry);
                            
                            if (resultadoElimina == 1) {
                                // Si tenía autoincremento, reajustamos el índice por comodidad estética
                                if(!tabla.equals("escriben")) {
                                    bd.edita("ALTER TABLE " + tabla + " AUTO_INCREMENT = 1");
                                }
                %>
                                <script>
                                    window.alert("El registro se eliminó correctamente del catálogo <%=tabla%>.");
                                    window.location.href = "tablaPersonas.jsp";
                                </script>
                <%
                            } else {
                                out.println("<h3 style='color: #e67e22;'>⚠ No se afectaron registros. Es posible que el elemento ya no exista.</h3>");
                            }
                            bd.cierraConexion();
                        } catch (Exception ex) {
                            out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 20px; border-radius: 5px; margin-bottom: 15px;'>");
                            out.print("<h3 style='margin-top: 0;'>❌ Error en la operación de borrado</h3>");
                            out.print("<p><b>Detalle técnico:</b> " + ex.getMessage() + "</p>");
                            out.print("<p><i>Nota: Si estás intentando borrar un registro que está siendo referenciado por otra tabla (Ej. Una Empresa que ya tiene Clientes registrados, o una Edición que tiene Artículos), la base de datos bloqueará la eliminación por seguridad (Restricción de Llave Foránea). Debes borrar primero los datos dependientes.</i></p>");
                            out.print("</div>");
                        }
                    } else {
                        out.print("<h3 style='color: #c0392b; text-align: center;'>❌ Parámetros insuficientes para realizar la baja.</h3>");
                    }
                %>
            </div>
            <div style="text-align: left; margin-top: 20px;">
                <a href="tablaPersonas.jsp" class="btn btn-cargar" style="text-decoration: none; display: inline-block; padding: 10px 20px; background-color: #7f8c8d; color: white; border-radius: 5px;">Regresar al menú principal</a>
            </div>
        </div>
    </body>
</html>