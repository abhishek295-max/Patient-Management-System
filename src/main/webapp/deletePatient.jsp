<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int id=Integer.parseInt(request.getParameter("id"));

    Connection con=getConnection();

    PreparedStatement ps=
            con.prepareStatement(
                    "delete from patient where id=?");

    ps.setInt(1,id);

    ps.executeUpdate();

    response.sendRedirect("viewPatient.jsp");
%>