<%@page import="java.sql.ResultSet"%>
<%@page import="Conexion.Base"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="CSS/estilos.css">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Modificar Registro Dinámico</title>
        <style>
            table input[type="text"], table input[type="email"], table input[type="date"], table textarea {
                width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box;
            }
            table label { font-weight: bold; color: #333333; display: block; margin-bottom: 5px; }
        </style>
    </head>
    <body>
        <h2>Modificar Registro</h2>
        <div style="max-width: 600px; margin: 30px auto;">
            <form name="datosEdit" method="post" action="edita.jsp">
                <%
                    String txtId = request.getParameter("id");
                    String tabla = request.getParameter("tabla");
                    
                    if(txtId != null && tabla != null) {
                        int id = Integer.parseInt(txtId.trim());
                        Base bd = new Base();
                        
                        try {
                            bd.conectar();
                            String pkName = "";
                            
                            // Asignamos el nombre exacto de la Primary Key según la tabla
                            if (tabla.equals("empresas")) pkName = "idEmpresa";
                            else if (tabla.equals("aliados")) pkName = "idAliado";
                            else if (tabla.equals("clientes")) pkName = "idCliente"; 
                            else if (tabla.equals("areas")) pkName = "idArea";
                            else if (tabla.equals("ponentes")) pkName = "idPonente";
                            else if (tabla.equals("historial_academico")) pkName = "idHistorial";
                            else if (tabla.equals("eventos")) pkName = "idEvento";
                            else if (tabla.equals("ediciones")) pkName = "idEdicion";
                            else if (tabla.equals("autores")) pkName = "idAutor";
                            else if (tabla.equals("articulos")) pkName = "idArticulo";
                            
                            String strQry = "SELECT * FROM " + tabla + " WHERE " + pkName + " = " + id;
                            ResultSet rs = bd.consulta(strQry);
                            
                            if (rs.next()) {
                %>
                                <input type="hidden" name="nomTabla" value="<%=tabla%>">
                                <input type="hidden" name="TxtId" value="<%=id%>">
                                
                                <table>
                                    <thead>
                                        <tr><th colspan="2" style="background-color: #34495e; color: white; padding: 10px;">Modificando: <%=tabla.toUpperCase()%></th></tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td style="width: 35%;"><label>ID (Lectura):</label></td>
                                            <td><input type="text" value="<%=id%>" disabled style="background-color: #e9ecef;"/></td>
                                        </tr>
                                        
                                        <% if (tabla.equals("clientes")) { %>
                                            <tr>
                                                <td><label>Nombre:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Paterno:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("apellido_paterno")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Materno:</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("apellido_materno")%>" /></td>
                                            </tr>
                                            <tr>
                                                <td><label>ID Empresa (FK):</label></td>
                                                <td><input type="text" name="val4" value="<%=rs.getString("idEmpresa")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("empresas")) { %>
                                            <tr>
                                                <td><label>Nombre Empresa:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Correo Electrónico:</label></td>
                                                <td><input type="email" name="val2" value="<%=rs.getString("correo")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Teléfono:</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("telefono")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>ID Aliado (FK):</label></td>
                                                <td><input type="text" name="val4" value="<%=rs.getString("idAliado")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("aliados")) { %>
                                            <tr>
                                                <td><label>Nombre del Aliado:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre_aliado")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Tipo de Alianza:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("tipo_alianza")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("areas")) { %>
                                            <tr>
                                                <td><label>Nombre del Área:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("eventos")) { %>
                                            <tr>
                                                <td><label>Nombre Evento:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Fecha:</label></td>
                                                <td><input type="date" name="val2" value="<%=rs.getString("fecha")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Tipo de Evento:</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("tipo_evento")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Horario:</label></td>
                                                <td><input type="text" name="val4" value="<%=rs.getString("horario")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("ediciones")) { %>
                                            <tr>
                                                <td><label>Fecha:</label></td>
                                                <td><input type="date" name="val1" value="<%=rs.getString("fecha")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Sede:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("sede")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>ID Evento (FK):</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("idEvento")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("historial_academico")) { %>
                                            <tr>
                                                <td><label>Título:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("titulo")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Institución:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("institucion")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Fecha Graduación:</label></td>
                                                <td><input type="date" name="val3" value="<%=rs.getString("fecha_graduacion")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("ponentes")) { %>
                                            <tr>
                                                <td><label>Nombre Ponente:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Paterno:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("apellido_paterno")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Materno:</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("apellido_materno")%>" /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Correo:</label></td>
                                                <td><input type="email" name="val4" value="<%=rs.getString("correo")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Teléfono:</label></td>
                                                <td><input type="text" name="val5" value="<%=rs.getString("telefono")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>ID Historial (FK):</label></td>
                                                <td><input type="text" name="val6" value="<%=rs.getString("idHistorial")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("autores")) { %>
                                            <tr>
                                                <td><label>Nombre:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("nombre")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Paterno:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("apellido_paterno")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Apellido Materno:</label></td>
                                                <td><input type="text" name="val3" value="<%=rs.getString("apellido_materno")%>" /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Correo:</label></td>
                                                <td><input type="email" name="val4" value="<%=rs.getString("correo")%>" required /></td>
                                            </tr>

                                        <% } else if (tabla.equals("articulos")) { %>
                                            <tr>
                                                <td><label>Título Inglés:</label></td>
                                                <td><input type="text" name="val1" value="<%=rs.getString("titulo_ingles")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Título Español:</label></td>
                                                <td><input type="text" name="val2" value="<%=rs.getString("titulo_espanol")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Fecha Publicación:</label></td>
                                                <td><input type="date" name="val3" value="<%=rs.getString("fecha_publicacion")%>" required /></td>
                                            </tr>
                                            <tr>
                                                <td><label>Abstract Inglés:</label></td>
                                                <td><textarea name="val4" rows="4" required><%=rs.getString("abstract_ingles")%></textarea></td>
                                            </tr>
                                            <tr>
                                                <td><label>Abstract Español:</label></td>
                                                <td><textarea name="val5" rows="4" required><%=rs.getString("abstract_espanol")%></textarea></td>
                                            </tr>
                                            <tr>
                                                <td><label>ID Edición (FK):</label></td>
                                                <td><input type="text" name="val6" value="<%=rs.getString("idEdicion")%>" required /></td>
                                            </tr>
                                        <% } %>
                                        
                                        <tr>
                                            <td colspan="2" style="text-align: right; padding: 15px;">
                                                <input class="btn btn-actualizar" type="submit" value="Guardar Cambios" style="background-color: #f39c12; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-weight: bold;"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                <%
                            } else {
                                out.print("<p style='color:red;'>No se encontró el registro.</p>");
                            }
                            rs.close();
                            bd.cierraConexion();
                        } catch(Exception e) {
                            out.print("<p style='color:red; background:#f8d7da; padding:10px;'>Error al mapear datos: " + e.getMessage() + "</p>");
                        }
                    } else {
                        out.print("<p style='color:orange;'>Faltan parámetros para editar.</p>");
                    }
                %>
            </form>
            <div style="text-align: left; margin-top: 15px;">
                <a href="tablaPersonas.jsp" class="btn btn-cargar" style="text-decoration: none; display: inline-block; background-color: #7f8c8d; color: white; padding: 10px 20px; border-radius: 5px;">Volver a la Lista</a>
            </div>
        </div>
    </body>
</html>