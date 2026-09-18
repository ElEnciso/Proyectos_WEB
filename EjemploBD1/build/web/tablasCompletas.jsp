<%-- 
    Document   : index / panelPrincipal
    Created on : 3/05/2022, 01:27:50 PM
    Updated    : Adaptado a la nueva estructura E-R
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Conexion.Base"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Panel Principal - Base de Datos</title>
        <link rel="stylesheet" href="CSS/estilos.css">
    </head>
    <body style="margin: 0;">
    <jsp:include page="navbar.jsp" />
        
        <div style="max-width: 95%; margin: 30px auto;">
            
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; background-color: #2c3e50; color: white; padding: 15px; border-radius: 8px;">
                <h1 style="margin: 0;">Panel de Control Principal</h1>
                <a href="Form.html" class="btn btn-cargar" style="text-decoration: none; display: inline-block; background-color: #f39c12; color: white; padding: 10px 20px; border-radius: 5px; font-weight: bold;">+ Registrar Nuevo Dato</a>
            </div>
            
            <%
                Base bd = new Base();
                ResultSet rs = null;
                
                try {
                    bd.conectar();
            %>
            
            <h2 style="border-bottom: 2px solid #3498db; padding-bottom: 10px; color: #2980b9;">Consultas Principales</h2>

            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                <h3 style="margin: 0;">Agenda de Eventos</h3>
                <button type="button" onclick="alternarTabla('vistaAgenda', this)" style="padding: 6px 12px; font-size: 14px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #63AB63; font-weight: bold; transition: 0.3s;">Mostrar ▼</button>
            </div>
            <table id="vistaAgenda" style="display: none; width: 100%; text-align: left; border-collapse: collapse;">
                <thead style="background-color: #34495e; color: white;">
                    <tr>
                        <th>Ponente</th>
                        <th>Especialidad</th>
                        <th>Grado Académico</th>
                        <th>Evento</th>
                        <th>Sede</th>
                        <th>Fecha</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM agenda_eventos");
                        while (rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td><%=rs.getString(1)%></td> <td><%=rs.getString(2)%></td> <td><%=rs.getString(3)%> (<%=rs.getString(4)%>)</td> <td><%=rs.getString(5)%></td> <td><%=rs.getString(6)%></td> <td><%=rs.getString(7)%></td> </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                <h3 style="margin: 0;">Archivo de Artículos Publicados</h3>
                <button type="button" onclick="alternarTabla('vistaArticulos', this)" style="padding: 6px 12px; font-size: 14px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #63AB63; font-weight: bold; transition: 0.3s;">Mostrar ▼</button>
            </div>
            <table id="vistaArticulos" style="display: none; width: 100%; text-align: left; border-collapse: collapse;">
                <thead style="background-color: #34495e; color: white;">
                    <tr>
                        <th>Título (Inglés)</th>
                        <th>Título (Español)</th>
                        <th>Autor</th>
                        <th>Presentado en</th>
                        <th>Fecha</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM archivo_articulos");
                        while (rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td><%=rs.getString(1)%></td>
                        <td><%=rs.getString(2)%></td>
                        <td><%=rs.getString(4)%></td>
                        <td><%=rs.getString(5)%> (<%=rs.getString(7)%>)</td>
                        <td><%=rs.getString(6)%></td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <hr style="margin: 40px 0; border: 0; height: 1px; background: #ccc;">

            <div style="text-align: center; margin-bottom: 30px;">
                <button type="button" onclick="toggleMasInfo()" id="btnMasInfo" style="padding: 15px 30px; font-size: 18px; cursor: pointer; border: none; border-radius: 8px; color: white; background-color: #8e44ad; font-weight: bold; transition: 0.3s; box-shadow: 0px 4px 6px rgba(0,0,0,0.1);">
                    + Ver Más Información (Catálogos Internos)
                </button>
            </div>


            <div id="seccionMasInfo" style="display: none; background-color: #f9f9f9; padding: 20px; border-radius: 8px; border: 1px solid #ddd;">
                <h2 style="border-bottom: 2px solid #7f8c8d; padding-bottom: 10px; color: #34495e;">Tablas de Gestión Interna</h2>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Directorio de Clientes</h4>
                    <button type="button" onclick="alternarTabla('tablaClientes', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaClientes" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre</th><th>Paterno</th><th>Materno</th><th>ID Empresa</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM clientes");
                            while (rs.next()) {
                                int id = rs.getInt("idCliente");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td><%=rs.getString("apellido_paterno")%></td>
                            <td><%=rs.getString("apellido_materno")%></td>
                            <td><%=rs.getString("idEmpresa")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=clientes"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=clientes" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Directorio de Empresas</h4>
                    <button type="button" onclick="alternarTabla('tablaEmpresas', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaEmpresas" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre</th><th>Correo</th><th>Teléfono</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM empresas");
                            while (rs.next()) {
                                int id = rs.getInt("idEmpresa");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td><%=rs.getString("correo")%></td>
                            <td><%=rs.getString("telefono")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=empresas"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=empresas" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Gestión de Eventos</h4>
                    <button type="button" onclick="alternarTabla('tablaEventos', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaEventos" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre</th><th>Fecha</th><th>Tipo</th><th>Horario</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM eventos");
                            while (rs.next()) {
                                int id = rs.getInt("idEvento");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td><%=rs.getString("fecha")%></td>
                            <td><%=rs.getString("tipo_evento")%></td>
                            <td><%=rs.getString("horario")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=eventos"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=eventos" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>
                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Red de Alianzas Corporativas</h4>
                    <button type="button" onclick="alternarTabla('tablaAliados', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaAliados" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID Alianza</th>
                            <th>Empresa A</th>
                            <th>Empresa B</th>
                            <th>Tipo de Acuerdo</th>
                            <th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Llamamos a la VISTA en lugar de la tabla cruda para ver los nombres
                            rs = bd.consulta("SELECT * FROM reporte_empresas_aliados");
                            while (rs.next()) {
                                // Obtenemos las columnas por su posición en la Vista (1 al 4)
                                int id = rs.getInt(1); 
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><b><%=rs.getString(2)%></b></td>
                            <td><b><%=rs.getString(3)%></b></td>
                            <td><%=rs.getString(4)%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=aliados"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=aliados" onclick="return confirm('¿Seguro que deseas romper esta alianza corporativa?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Catálogo de Áreas</h4>
                    <button type="button" onclick="alternarTabla('tablaAreas', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaAreas" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre del Área</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM areas");
                            while (rs.next()) {
                                int id = rs.getInt("idArea");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=areas"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=areas" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Directorio de Ponentes</h4>
                    <button type="button" onclick="alternarTabla('tablaPonentes', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaPonentes" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre</th><th>Paterno</th><th>Materno</th><th>Correo</th><th>Teléfono</th><th>ID Historial</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM ponentes");
                            while (rs.next()) {
                                int id = rs.getInt("idPonente");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td><%=rs.getString("apellido_paterno")%></td>
                            <td><%=rs.getString("apellido_materno")%></td>
                            <td><%=rs.getString("correo")%></td>
                            <td><%=rs.getString("telefono")%></td>
                            <td><%=rs.getString("idHistorial")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=ponentes"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=ponentes" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Historial Académico</h4>
                    <button type="button" onclick="alternarTabla('tablaHistorial', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaHistorial" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Título</th><th>Institución</th><th>Fecha Graduación</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM historial_academico");
                            while (rs.next()) {
                                int id = rs.getInt("idHistorial");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("titulo")%></td>
                            <td><%=rs.getString("institucion")%></td>
                            <td><%=rs.getString("fecha_graduacion")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=historial_academico"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=historial_academico" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Gestión de Ediciones</h4>
                    <button type="button" onclick="alternarTabla('tablaEdiciones', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaEdiciones" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Fecha</th><th>Sede</th><th>ID Evento</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM ediciones");
                            while (rs.next()) {
                                int id = rs.getInt("idEdicion");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("fecha")%></td>
                            <td><%=rs.getString("sede")%></td>
                            <td><%=rs.getString("idEvento")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=ediciones"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=ediciones" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Directorio de Autores</h4>
                    <button type="button" onclick="alternarTabla('tablaAutores', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaAutores" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Nombre</th><th>Paterno</th><th>Materno</th><th>Correo</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM autores");
                            while (rs.next()) {
                                int id = rs.getInt("idAutor");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("nombre")%></td>
                            <td><%=rs.getString("apellido_paterno")%></td>
                            <td><%=rs.getString("apellido_materno")%></td>
                            <td><%=rs.getString("correo")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=autores"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=autores" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Gestión de Artículos (Crudo)</h4>
                    <button type="button" onclick="alternarTabla('tablaArticulosCRUD', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaArticulosCRUD" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID</th><th>Título (EN)</th><th>Título (ES)</th><th>Fecha Pub.</th><th>ID Edición</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM articulos");
                            while (rs.next()) {
                                int id = rs.getInt("idArticulo");
                        %>
                        <tr>
                            <td><%=id%></td>
                            <td><%=rs.getString("titulo_ingles")%></td>
                            <td><%=rs.getString("titulo_espanol")%></td>
                            <td><%=rs.getString("fecha_publicacion")%></td>
                            <td><%=rs.getString("idEdicion")%></td>
                            <td style="text-align: center;">
                                <a href="editaDatos.jsp?id=<%=id%>&tabla=articulos"><img src="imagenes/editar.jpg" width="25"></a>
                                <a href="eliminar.jsp?id=<%=id%>&tabla=articulos" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

                <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                    <h4 style="margin: 0;">Relación Artículo-Autor (Escriben)</h4>
                    <button type="button" onclick="alternarTabla('tablaEscriben', this)" class="btn-toggle">Mostrar ▼</button>
                </div>
                <table id="tablaEscriben" style="display: none;">
                    <thead>
                        <tr>
                            <th>ID Artículo</th><th>ID Autor</th><th>Opciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            rs = bd.consulta("SELECT * FROM escriben");
                            while (rs.next()) {
                                int idArt = rs.getInt("idArticulo");
                                int idAut = rs.getInt("idAutor");
                        %>
                        <tr>
                            <td><%=idArt%></td>
                            <td><%=idAut%></td>
                            <td style="text-align: center;">
                                <a href="eliminar.jsp?idArticulo=<%=idArt%>&idAutor=<%=idAut%>&tabla=escriben" onclick="return confirm('¿Deseas romper esta asociación?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                            </td>
                        </tr>
                        <%  } rs.close(); %>
                    </tbody>
                </table>

            </div> <%
                    bd.cierraConexion();
                } catch (Exception ex) {
                    out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 20px; font-weight: bold; border-radius:5px; margin-top:20px;'>❌ Error de Base de Datos: " + ex.toString() + "</div>");
                }
            %>
        </div>
        
        <script>
        // Función para mostrar/ocultar cada tabla individual
        function alternarTabla(idTabla, boton) {
            var tabla = document.getElementById(idTabla);

            if (tabla.style.display === "none") {
                tabla.style.display = "table"; 
                boton.innerHTML = "Colapsar ▲";
                boton.style.backgroundColor = "#dc3545"; 
            } else {
                tabla.style.display = "none"; 
                boton.innerHTML = "Mostrar ▼";
                boton.style.backgroundColor = "#63AB63"; 
            }
        }

        // Función para mostrar/ocultar toda la sección de "Más Información"
        function toggleMasInfo() {
            var seccion = document.getElementById("seccionMasInfo");
            var boton = document.getElementById("btnMasInfo");

            if (seccion.style.display === "none") {
                seccion.style.display = "block";
                boton.innerHTML = "Ocultar Información Interna ▲";
                boton.style.backgroundColor = "#c0392b"; // Cambia a rojo
            } else {
                seccion.style.display = "none";
                boton.innerHTML = "+ Ver Más Información (Catálogos Internos)";
                boton.style.backgroundColor = "#8e44ad"; // Vuelve a morado
            }
        }
        </script>

        <style>
            .btn-toggle {
                padding: 6px 12px; font-size: 14px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #63AB63; font-weight: bold; transition: 0.3s;
            }
            table th, table td { padding: 10px; border: 1px solid #ddd; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; background: white; }
        </style>
        
    <div style="text-align: right; margin-top: 15px">
            <a href="tablaPersonas.jsp" class="btn btn-cargar" style="text-decoration: none; display: inline-block;">Volver al Menú Principal</a>
    </div>
    </body>
</html>