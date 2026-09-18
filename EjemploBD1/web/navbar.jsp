<style>
    /* Solo estilos del Navbar */
    .navbar-singularity {
        background-color: #2c3e50;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 40px;
        height: 70px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
        margin-bottom: 20px; /* Separación con tu contenido */
    }

    .navbar-brand { color: #ffffff; font-size: 24px; font-weight: bold; text-decoration: none; }
    .navbar-brand span { color: #3498db; font-weight: 300; }
    .navbar-menu { list-style: none; display: flex; gap: 15px; margin: 0; padding: 0; }
    .navbar-menu li a {
        color: #ecf0f1; text-decoration: none; font-size: 15px; padding: 10px 18px;
        border-radius: 6px; transition: all 0.3s ease;
    }
    .navbar-menu li a:hover { background-color: #3498db; color: white; }
</style>

<nav class="navbar-singularity">
    <a href="https://singularityumexico.com/#acerca" class="navbar-brand">
        Singularity<span>Mexico</span>
    </a>
    <ul class="navbar-menu">
        <li><a href="tablaPersonas.jsp">Dashboard</a></li>
        <li><a href="tablasCompletas.jsp">Tablas</a></li>
        <li><a href="Form.html">Registrar</a></li>
        <li><a href="gestion.jsp">Catálogos</a></li>
        <li><a href="reportes.jsp">Reportes</a></li>
    </ul>
</nav>