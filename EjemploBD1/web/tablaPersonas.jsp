<%-- 
    Document   : tablaPersonas (Dashboard Principal)
    Updated    : Modularizado con Navbar
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Conexion.Base"%>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Singularity Mexico - Dashboard</title>
        <link rel="stylesheet" href="CSS/estilos.css">
        <style>
            .btn-toggle {
                padding: 6px 12px; font-size: 14px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #3498db; font-weight: bold; transition: 0.3s;
            }
            table th, table td { padding: 10px; border: 1px solid #ddd; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; background: white; }
        </style>
    </head>
    <body style="margin: 0;">
    <jsp:include page="navbar.jsp" />

        <div style="max-width: 1200px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <h1 style="margin: 0; color: #2c3e50;">Panel de Control Principal</h1>
                <a href="Form.html" style="text-decoration: none; background-color: #f39c12; color: white; padding: 10px 20px; border-radius: 5px; font-weight: bold;">+ Registrar Nuevo Dato</a>
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
                <button type="button" onclick="alternarTabla('vistaAgenda', this)" class="btn-toggle">Mostrar ▼</button>
            </div>
            <table id="vistaAgenda" style="display: none;">
                <thead style="background-color: #34495e; color: white;">
                    <tr><th>Ponente</th><th>Especialidad</th><th>Grado Académico</th><th>Evento</th><th>Sede</th><th>Fecha</th></tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM agenda_eventos");
                        while (rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td><%=rs.getString(1)%></td> <td><%=rs.getString(2)%></td> <td><%=rs.getString(3)%> (<%=rs.getString(4)%>)</td> <td><%=rs.getString(5)%></td> <td><%=rs.getString(6)%></td> <td><%=rs.getString(7)%></td> 
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                <h3 style="margin: 0;">Archivo de Artículos Publicados</h3>
                <button type="button" onclick="alternarTabla('vistaArticulos', this)" class="btn-toggle">Mostrar ▼</button>
            </div>
            <table id="vistaArticulos" style="display: none;">
                <thead style="background-color: #34495e; color: white;">
                    <tr><th>Título (Inglés)</th><th>Título (Español)</th><th>Autor</th><th>Presentado en</th><th>Fecha</th></tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM archivo_articulos");
                        while (rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td><%=rs.getString(1)%></td><td><%=rs.getString(2)%></td><td><%=rs.getString(4)%></td><td><%=rs.getString(5)%> (<%=rs.getString(7)%>)</td><td><%=rs.getString(6)%></td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <div style="display: flex; align-items: center; gap: 15px; margin-top: 20px; margin-bottom: 10px;">
                <h3 style="margin: 0;">Red de Alianzas Corporativas</h3>
                <button type="button" onclick="alternarTabla('vistaAlianzas', this)" class="btn-toggle">Mostrar ▼</button>
            </div>
            <table id="vistaAlianzas" style="display: none;">
                <thead style="background-color: #34495e; color: white;">
                    <tr><th>Empresa A</th><th>Empresa B</th><th>Tipo de Acuerdo</th></tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM reporte_empresas_aliados");
                        while (rs.next()) {
                    %>
                    <tr style="border-bottom: 1px solid #ddd;">
                        <td><b><%=rs.getString(2)%></b></td><td><b><%=rs.getString(3)%></b></td><td><%=rs.getString(4)%></td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <%
                bd.cierraConexion();
                } catch (Exception ex) {
                    out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 20px; border-radius:5px; margin-top:20px;'>❌ Error de BD: " + ex.toString() + "</div>");
                }
            %>
        </div>
        
        <script>
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
        </script>
    </body>
</html>