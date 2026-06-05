<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String name = request.getParameter("name");
    if (name == null || name.trim().isEmpty()) {
        name = "there";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Message Sent | PMS+</title>
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
        radial-gradient(circle at 10% 8%, rgba(99,240,221,.22), transparent 24%),
        radial-gradient(circle at 92% 4%, rgba(116,168,255,.20), transparent 22%),
        linear-gradient(145deg, var(--bg-0), var(--bg-1) 45%, var(--bg-2));
}
body:before{
    content:"";
    position:fixed;
    inset:0;
    background-image:
        linear-gradient(rgba(255,255,255,.035) 1px, transparent 1px),
        linear-gradient(90deg, rgba(255,255,255,.035) 1px, transparent 1px);
    background-size:56px 56px;
    mask-image:linear-gradient(to bottom, rgba(0,0,0,.85), transparent);
    pointer-events:none;
}
.card{
    width:min(860px,100%);
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
    background:radial-gradient(circle, rgba(99,240,221,.16), transparent 68%);
    pointer-events:none;
}
.eyebrow{
    display:inline-flex;
    align-items:center;
    gap:10px;
    padding:10px 14px;
    border-radius:999px;
    background:rgba(99,240,221,.08);
    border:1px solid rgba(99,240,221,.16);
    color:#d9fffb;
    font-size:.82rem;
    letter-spacing:.12em;
    text-transform:uppercase;
    font-weight:800;
}
.eyebrow span{
    width:10px;
    height:10px;
    border-radius:50%;
    background:linear-gradient(135deg, var(--accent), var(--accent-2));
    box-shadow:0 0 0 6px rgba(99,240,221,.11);
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
.hero-line{
    display:flex;
    align-items:center;
    gap:12px;
    margin-top:16px;
    color:var(--muted);
}
.spark{
    width:12px;
    height:12px;
    border-radius:50%;
    background:var(--accent);
    box-shadow:0 0 0 8px rgba(99,240,221,.12);
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
    <div class="eyebrow"><span></span> Message sent</div>
    <h1>Thanks, <%= name %>. Your message has been received.</h1>
    <p>
        The contact request is now stored and ready for review. You can return to the dashboard, send another message, or continue working with the system.
    </p>
    <div class="hero-line"><span class="spark"></span><span>Confirmation complete and support queue updated.</span></div>
    <div class="grid">
        <div class="tile"><strong>Support</strong><span>Use the contact form again for follow-up questions.</span></div>
        <div class="tile"><strong>Dashboard</strong><span>Return to the main control center anytime.</span></div>
        <div class="tile"><strong>System</strong><span>Everything is ready for the next task.</span></div>
    </div>
    <div class="actions">
        <a class="btn primary" href="contact.jsp">Send another message</a>
        <a class="btn secondary" href="dashboard.jsp">Back to Dashboard</a>
    </div>
    <div class="footer">Your message flow is now connected to `saveContact.jsp` and ends on a branded success screen.</div>
</main>
</body>
</html>
