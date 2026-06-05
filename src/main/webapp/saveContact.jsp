<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ include file="db.jsp" %>

<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String topic = request.getParameter("topic");
    String priority = request.getParameter("priority");
    String message = request.getParameter("messageBox");

    Connection con = null;
    PreparedStatement ps = null;

    try {

        con = getConnection();

        if(con == null){
            out.println("Database Connection Failed");
            return;
        }

        ps = con.prepareStatement(
                "INSERT INTO contact_messages(name,email,topic,priority,message) VALUES(?,?,?,?,?)"
        );

        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, topic);
        ps.setString(4, priority);
        ps.setString(5, message);

        int result = ps.executeUpdate();

        if(result > 0){
            String successName = URLEncoder.encode(name == null ? "" : name, "UTF-8");
            response.sendRedirect("contactSuccess.jsp?name=" + successName);
        }else{
            response.sendRedirect("contact.jsp?status=failed");
        }

    } catch(Exception e){
        response.sendRedirect("contact.jsp?status=error");
    } finally {

        try {
            if(ps != null) ps.close();
            if(con != null) con.close();
        } catch(Exception e){
            e.printStackTrace();
        }
    }
%>
