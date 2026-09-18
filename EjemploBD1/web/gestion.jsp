<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Conexion.Base"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Catálogos</title>
        <link rel="stylesheet" href="CSS/estilos.css">
        <style>
            .btn-toggle { padding: 6px 12px; font-size: 14px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #8e44ad; font-weight: bold; transition: 0.3s; }
            table th, table td { padding: 10px; border: 1px solid #ddd; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; background: white; }
            thead { background-color: #34495e; color: white; }
            .section-title { color: #2c3e50; border-bottom: 2px solid #7f8c8d; padding-bottom: 10px; margin-top: 40px; }
        </style>
    </head>
    <body style="margin: 0;">
        <jsp:include page="navbar.jsp" />

        <div style="max-width: 1200px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
            <h1 class="section-title">Tablas de Gestión Interna (CRUD)</h1>
            
            <%
                Base bd = new Base();
                ResultSet rs = null;
                try {
                    bd.conectar();
            %>

            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px;">
                <h4 style="margin: 0;">Gestión de Eventos</h4>
                <button type="button" onclick="alternarTabla('tablaEventos', this)" class="btn-toggle">Mostrar ▼</button>
            </div>
            <table id="tablaEventos" style="display: none;">
                <thead><tr><th>ID</th><th>Nombre</th><th>Fecha</th><th>Tipo</th><th>Horario</th><th>Opciones</th></tr></thead>
                <tbody>
                    <% rs = bd.consulta("SELECT * FROM eventos");
                       while (rs.next()) { int id = rs.getInt("idEvento"); %>
                    <tr>
                        <td><%=id%></td><td><%=rs.getString("nombre")%></td><td><%=rs.getString("fecha")%></td><td><%=rs.getString("tipo_evento")%></td><td><%=rs.getString("horario")%></td>
                        <td style="text-align: center;">
                            <a href="editaDatos.jsp?id=<%=id%>&tabla=eventos"><img src="imagenes/editar.jpg" width="25"></a>
                            <a href="eliminar.jsp?id=<%=id%>&tabla=eventos" onclick="return confirm('¿Seguro?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                        </td>
                    </tr>
                    <% } rs.close(); %>
                </tbody>
            </table>
            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                <h4 style="margin: 0;">Gestión de Artículos (Crudo)</h4>
                <button type="button" onclick="alternarTabla('tablaArticulosCRUD', this)" class="btn-toggle">Mostrar ▼</button>
            </div>
            <table id="tablaArticulosCRUD" style="display: none;">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Título (Inglés)</th>
                        <th>Título (Español)</th>
                        <th>Fecha Pub.</th>
                        <th>ID Edición</th>
                        <th>Opciones</th>
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
                            <a href="eliminar.jsp?id=<%=id%>&tabla=articulos" onclick="return confirm('¿Seguro que deseas eliminar este artículo?');"><img src="imagenes/eliminar.jpg" width="25"></a>
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
                        <th>ID Artículo</th>
                        <th>ID Autor</th>
                        <th>Opciones</th>
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
                            <a href="eliminar.jsp?idArticulo=<%=idArt%>&idAutor=<%=idAut%>&tabla=escriben" onclick="return confirm('¿Deseas romper esta asociación artículo-autor?');"><img src="imagenes/eliminar.jpg" width="25"></a>
                        </td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <hr style="margin: 40px 0;">

            <h2 style="color: #c0392b;">Bitácora de Auditoría: Eventos</h2>
            <table style="width: 100%;">
                <thead style="background-color: #c0392b;">
                    <tr><th>ID Evento</th><th>F. Anterior</th><th>F. Nueva</th><th>H. Anterior</th><th>H. Nuevo</th><th>Modificado</th><th>Usuario</th></tr>
                </thead>
                <tbody>
                    <% try {
                        rs = bd.consulta("SELECT * FROM auditoria_eventos ORDER BY fecha_modificacion DESC");
                        while(rs.next()) { %>
                    <tr>
                        <td><%=rs.getInt("idEvento")%></td>
                        <td><strike><%=rs.getDate("fecha_anterior")%></strike></td><td><b><%=rs.getDate("fecha_nueva")%></b></td>
                        <td><strike><%=rs.getString("horario_anterior")%></strike></td><td><b><%=rs.getString("horario_nuevo")%></b></td>
                        <td><%=rs.getString("fecha_modificacion")%></td><td><code><%=rs.getString("usuario")%></code></td>
                    </tr>
                    <% } rs.close(); } catch(Exception e) { out.print("<tr><td colspan='7'>Sin registros.</td></tr>"); } %>
                </tbody>
            </table>

            <h2 style="color: #2980b9; margin-top: 40px;">Bitácora de Auditoría: Reasignación de Artículos</h2>
            <p style="font-size: 13px; color: #666;">Seguimiento automático cuando un artículo cambia de Edición.</p>
            <table style="width: 100%;">
                <thead style="background-color: #2980b9;">
                    <tr><th>ID Artículo</th><th>Edición Anterior</th><th>Nueva Edición</th><th>Fecha Cambio</th><th>Usuario DB</th></tr>
                </thead>
                <tbody>
                    <% try {
                        rs = bd.consulta("SELECT * FROM log_cambios_articulos ORDER BY fecha_cambio DESC");
                        while(rs.next()) { %>
                    <tr>
                        <td><%=rs.getInt("idArticulo")%></td>
                        <td><strike><%=rs.getInt("idEdicion_anterior")%></strike></td>
                        <td><b><%=rs.getInt("idEdicion_nueva")%></b></td>
                        <td><%=rs.getString("fecha_cambio")%></td>
                        <td><code><%=rs.getString("usuario_bd")%></code></td>
                    </tr>
                    <% } rs.close(); } catch(Exception e) { out.print("<tr><td colspan='5'>Sin movimientos registrados.</td></tr>"); } %>
                </tbody>
            </table>

            <%
                bd.cierraConexion();
                } catch (Exception ex) {
                    out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 20px;'>❌ Error de BD: " + ex.toString() + "</div>");
                }
            %>
        </div>
        
        <script>
        function alternarTabla(idTabla, boton) {
            var tabla = document.getElementById(idTabla);
            if (tabla.style.display === "none") {
                tabla.style.display = "table"; 
                boton.innerHTML = "Colapsar ▲";
                boton.style.backgroundColor = "#e74c3c"; 
            } else {
                tabla.style.display = "none"; 
                boton.innerHTML = "Mostrar ▼";
                boton.style.backgroundColor = "#8e44ad"; 
            }
        }
        </script>
    </body>
</html>