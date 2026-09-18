<%-- 
    Document   : DESPLEGAR
    Created on : 11 abr. 2022, 07:51:21
    Author     : alien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Tus Datos</h1>
        <% 
        String desnombre  = request.getParameter("TxTNombre");
        String paterno  = request.getParameter("TxTPaterno");
        String materno  = request.getParameter("TxTMaterno");
        String desedad  = request.getParameter("TxTEdad");
        %>
    </body>
</html>
