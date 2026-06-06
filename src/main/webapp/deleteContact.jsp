<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    boolean deleted = false;
    String message = "";

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement("DELETE FROM contact_messages WHERE id=?")) {
        ps.setInt(1, id);
        deleted = ps.executeUpdate() > 0;
        message = deleted ? "The contact message was deleted successfully." : "No contact message matched the requested record.";
    } catch (Exception e) {
        message = e.getMessage();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Delete Contact | PMS+</title>
<style>
:root{
    --bg-0:#040814;
    --bg-1:#08111f;
    --bg-2:#0d1d36;
    --line:rgba(148,163,184,.18);
    --text:#edf6ff;
    --muted:#9cb1cd;
    --accent:#63f0dd;
    --accent-2:#74a8ff;
    --danger:#fb7185;
    --shadow:0 28px 90px rgba(0,0,0,.42);
}
*{box-sizing:border-box}
html,body{height:100%}
body{
    margin:0;
    display:grid;
    place-items:center;
    padding:20px;
    color:var(--text);
    font:16px/1.5 "Segoe UI",Tahoma,Geneva,Verdana,sans-serif;
    background:
        radial-gradient(circle at 10% 8%, rgba(99,240,221,.18), transparent 24%),
        radial-gradient(circle at 92% 4%, rgba(116,168,255,.18), transparent 22%),
        linear-gradient(145deg, var(--bg-0), var(--bg-1) 45%, var(--bg-2));
}
.card{
    width:min(840px,100%);
    padding:32px;
    border-radius:30px;
    background:linear-gradient(180deg, rgba(12,22,40,.94), rgba(8,15,29,.84));
    border:1px solid var(--line);
    box-shadow:var(--shadow);
    position:relative;
    overflow:hidden;
}
.card:before{
    content:"";
    position:absolute;
    inset:auto -120px -120px auto;
    width:340px;
    height:340px;
    border-radius:50%;
    background:radial-gradient(circle, rgba(251,113,133,.14), transparent 68%);
    pointer-events:none;
}
.eyebrow{
    display:inline-flex;
    align-items:center;
    gap:10px;
    padding:10px 14px;
    border-radius:999px;
    background:rgba(251,113,133,.08);
    border:1px solid rgba(251,113,133,.16);
    color:#ffe2e8;
    font-size:.82rem;
    letter-spacing:.12em;
    text-transform:uppercase;
    font-weight:800;
}
.eyebrow span{
    width:10px;
    height:10px;
    border-radius:50%;
    background:linear-gradient(135deg, var(--danger), var(--accent-2));
    box-shadow:0 0 0 6px rgba(251,113,133,.11);
}
h1{
    margin:18px 0 10px;
    font-size:clamp(2rem, 4vw, 3.6rem);
    line-height:1.02;
    letter-spacing:-.05em;
}
p{
    margin:0;
    color:var(--muted);
    max-width:60ch;
    font-size:1.03rem;
    line-height:1.8;
}
.grid{
    display:grid;
    grid-template-columns:repeat(3,minmax(0,1fr));
    gap:14px;
    margin-top:24px;
}
.tile{
    padding:18px;
    border-radius:20px;
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
}
.tile strong{
    display:block;
    margin-bottom:6px;
}
.tile span{
    color:var(--muted);
}
.actions{
    display:flex;
    flex-wrap:wrap;
    gap:12px;
    margin-top:26px;
}
.btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:14px 18px;
    border-radius:16px;
    text-decoration:none;
    font-weight:800;
    transition:transform .2s ease;
}
.btn:hover{
    transform:translateY(-2px);
}
.primary{
    color:#04111d;
    background:linear-gradient(135deg, var(--accent), #98e5ff);
}
.secondary{
    color:var(--text);
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.18);
}
.danger{
    color:#fff;
    background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92));
}
.notice{
    margin-top:18px;
    padding:16px 18px;
    border-radius:20px;
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
    color:var(--muted);
}
.notice strong{
    color:var(--text);
}
.footer{
    margin-top:18px;
    color:var(--muted);
    font-size:.92rem;
}
@media (max-width:720px){
    .card{
        padding:22px;
        border-radius:24px;
    }
    .grid{
        grid-template-columns:1fr;
    }
    .btn{
        width:100%;
    }
}
</style>
</head>
<body>
<main class="card">
    <div class="eyebrow"><span></span> Contact delete</div>
    <h1><%= deleted ? "Contact message deleted" : "Delete result" %></h1>
    <p>
        <%= deleted ? "The selected contact message has been removed from the inbox." : "The selected message could not be removed." %>
    </p>
    <div class="grid">
        <div class="tile"><strong>Record ID</strong><span><%= id %></span></div>
        <div class="tile"><strong>Status</strong><span><%= deleted ? "Deleted successfully" : "Not deleted" %></span></div>
        <div class="tile"><strong>Result</strong><span><%= deleted ? "Inbox updated" : "Check the message ID or database connection" %></span></div>
    </div>
    <div class="notice"><strong>Details:</strong> <%= message %></div>
    <div class="actions">
        <a class="btn primary" href="viewContact.jsp">Back to Contact Messages</a>
        <a class="btn secondary" href="dashboard">Back to Dashboard</a>
        <a class="btn danger" href="contact.jsp">Open Contact Form</a>
    </div>
    <div class="footer">This confirmation page keeps the contact-delete flow consistent with the rest of the dashboard UI.</div>
</main>
</body>
</html>
