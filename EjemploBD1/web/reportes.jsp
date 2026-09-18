<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="Conexion.Base"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reportes Avanzados</title>
        <link rel="stylesheet" href="CSS/estilos.css">
        <style>
            .btn-buscar {
                padding: 10px 20px; font-size: 16px; cursor: pointer; border: none; border-radius: 4px; color: white; background-color: #f39c12; font-weight: bold; transition: 0.3s;
            }
            .btn-buscar:hover { background-color: #d68910; }
            .input-busqueda {
                padding: 10px; font-size: 16px; width: 300px; border: 1px solid #ccc; border-radius: 4px;
            }
            table th, table td { padding: 10px; border: 1px solid #ddd; }
            table { width: 100%; border-collapse: collapse; margin-bottom: 15px; background: white; text-align: left; }
            thead { background-color: #2c3e50; color: white; }
        </style>
    </head>
    <body style="margin: 0;">
    <jsp:include page="navbar.jsp" />

        <div style="max-width: 1200px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.05);">
            
            <h1 style="color: #2c3e50; border-bottom: 2px solid #f39c12; padding-bottom: 10px;">Reportes Dinámicos y Consultas</h1>
            <p style="color: #7f8c8d;">Búsquedas avanzadas utilizando Procedimientos Almacenados y Vistas Agrupadas.</p>
            
            <div style="background-color: #ecf0f1; padding: 20px; border-radius: 8px; margin-top: 20px;">
                <h3 style="margin-top: 0; color: #34495e;">🔍 Buscar Agenda por Sede</h3>
                <form method="POST" action="reportes.jsp" style="display: flex; gap: 10px; align-items: center;">
                    <input type="text" name="sedeBusqueda" class="input-busqueda" placeholder="Ej. Monterrey, ESCOM, WTC..." required>
                    <button type="submit" class="btn-buscar">Buscar Eventos</button>
                    <a href="reportes.jsp" style="text-decoration: none; color: #7f8c8d; margin-left: 10px;">Limpiar</a>
                </form>
            </div>

            <%
                Base bd = new Base();
                ResultSet rs = null;
                try {
                    bd.conectar();
                    
                    // Lógica para capturar la búsqueda del usuario
                    String sedeBusq = request.getParameter("sedeBusqueda");
                    
                    if (sedeBusq != null && !sedeBusq.trim().isEmpty()) {
            %>
            <h3 style="color: #27ae60; margin-top: 30px;">Resultados para la sede: "<%=sedeBusq%>"</h3>
            <table>
                <thead>
                    <tr><th>ID Evento</th><th>Nombre del Evento</th><th>Fecha</th><th>Horario</th><th>Tipo</th><th>Sede Exacta</th></tr>
                </thead>
                <tbody>
                    <%
                        // AQUÍ EJECUTAMOS EL PROCEDIMIENTO ALMACENADO
                        String querySP = "CALL consultarAgendaporSede('" + sedeBusq + "')";
                        rs = bd.consulta(querySP);
                        
                        boolean hayResultados = false;
                        while (rs.next()) {
                            hayResultados = true;
                    %>
                    <tr>
                        <td><%=rs.getString(1)%></td>
                        <td><b><%=rs.getString(2)%></b></td>
                        <td><%=rs.getString(3)%></td>
                        <td><%=rs.getString(4)%></td>
                        <td><%=rs.getString(5)%></td>
                        <td><%=rs.getString(6)%></td>
                    </tr>
                    <%  } rs.close(); 
                        
                        if (!hayResultados) {
                            out.print("<tr><td colspan='6' style='text-align:center; color:red;'>No se encontraron eventos en esa sede.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
            <%      } %>

            <hr style="margin: 40px 0; border: 0; height: 1px; background: #ccc;">

            <h3 style="color: #2980b9;">🎓 Directorio Académico de Ponentes</h3>
            <table>
                <thead>
                    <tr><th>Nombre del Ponente</th><th>Máximo Grado Obtenido</th><th>Institución de Egreso</th><th>Fecha de Graduación</th></tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM reporte_historial_ponentes ORDER BY Fecha_Graduacion DESC");
                        while (rs.next()) {
                    %>
                    <tr>
                        <td><b><%=rs.getString("Ponente")%></b></td>
                        <td><%=rs.getString("Titulo_Obtenido")%></td>
                        <td><%=rs.getString("Lugar_Estudios")%></td>
                        <td><%=rs.getString("Fecha_Graduacion")%></td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <h3 style="color: #2980b9; margin-top: 30px;">📊 Resumen Estadístico: Eventos por Edición</h3>
            <table>
                <thead>
                    <tr><th>ID Edición</th><th>Sede del Congreso</th><th>Fecha</th><th>Total de Eventos (Count)</th></tr>
                </thead>
                <tbody>
                    <%
                        rs = bd.consulta("SELECT * FROM reporte_eventos_edicion");
                        while (rs.next()) {
                    %>
                    <tr>
                        <td style="text-align: center;"><%=rs.getString("idEdicion")%></td>
                        <td><b><%=rs.getString("Sede_Edicion")%></b></td>
                        <td><%=rs.getString("Fecha_Edicion")%></td>
                        <td style="text-align: center; font-size: 18px; font-weight: bold; color: #8e44ad;"><%=rs.getString("Cantidad_Eventos")%></td>
                    </tr>
                    <%  } rs.close(); %>
                </tbody>
            </table>

            <%
                bd.cierraConexion();
                } catch (Exception ex) {
                    out.print("<div style='background-color: #f8d7da; color: #721c24; padding: 20px; border-radius:5px;'>❌ Error al cargar reportes: " + ex.toString() + "</div>");
                }
            %>
        </div>
    </body>
</html>