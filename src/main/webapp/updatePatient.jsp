<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int id=Integer.parseInt(request.getParameter("id"));

    String name=request.getParameter("name");
    int age=Integer.parseInt(request.getParameter("age"));
    String gender=request.getParameter("gender");
    String disease=request.getParameter("disease");
    String mobile=request.getParameter("mobile");

    Connection con=getConnection();

    PreparedStatement ps=
            con.prepareStatement(
                    "update patient set name=?,age=?,gender=?,disease=?,mobile=? where id=?");

    ps.setString(1,name);
    ps.setInt(2,age);
    ps.setString(3,gender);
    ps.setString(4,disease);
    ps.setString(5,mobile);
    ps.setInt(6,id);

    ps.executeUpdate();

    response.sendRedirect("viewPatient.jsp");
%>