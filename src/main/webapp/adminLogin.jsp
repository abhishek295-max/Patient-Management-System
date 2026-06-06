<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;");
    }
%>
<%
    String user = request.getParameter("username");
    String pass = request.getParameter("password");
    boolean submitted = "POST".equalsIgnoreCase(request.getMethod());
    boolean failed = false;
    String errorMessage = null;

    if (submitted && user != null && pass != null) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = getConnection();
            ps = con.prepareStatement(
                "SELECT username FROM admin WHERE username = ? AND password = ? LIMIT 1"
            );
            ps.setString(1, user.trim());
            ps.setString(2, pass);
            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("adminUsername", rs.getString("username"));
                response.sendRedirect("dashboard.jsp");
                return;
            }

            failed = true;
            errorMessage = "Invalid username or password";
        } catch (Exception e) {
            failed = true;
            errorMessage = "Unable to verify admin login right now";
        } finally {
            try {
                if (rs != null) rs.close();
            } catch (Exception ignore) {}
            try {
                if (ps != null) ps.close();
            } catch (Exception ignore) {}
            try {
                if (con != null) con.close();
            } catch (Exception ignore) {}
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin Login</title>
<style>
:root{--bg:#050816;--card:rgba(8,15,28,.74);--line:rgba(255,255,255,.12);--text:#f1f7ff;--muted:#a9bdd8;--a:#5eead4;--b:#60a5fa;--c:#f59e0b}
*{box-sizing:border-box}html,body{height:100%}body{margin:0;font:16px/1.5 system-ui,-apple-system,Segoe UI,sans-serif;color:var(--text);background:radial-gradient(circle at 12% 12%,rgba(94,234,212,.16),transparent 24%),radial-gradient(circle at 88% 18%,rgba(96,165,250,.24),transparent 28%),linear-gradient(135deg,#030611 0%,#09111d 52%,#020308 100%);overflow:hidden}
body:before,body:after{content:"";position:fixed;border-radius:50%;filter:blur(54px);opacity:.55;animation:drift 12s ease-in-out infinite}
body:before{width:18rem;height:18rem;left:-4rem;top:-4rem;background:#2563eb}body:after{width:15rem;height:15rem;right:4rem;bottom:2rem;background:#14b8a6;animation-delay:-5s}
.wrap{min-height:100%;display:grid;place-items:center;padding:22px}
.shell{width:min(1080px,100%);display:grid;grid-template-columns:1fr .9fr;gap:18px;align-items:stretch}
.art,.form{position:relative;overflow:hidden;background:var(--card);backdrop-filter:blur(18px);border:1px solid var(--line);border-radius:30px;box-shadow:0 25px 80px rgba(0,0,0,.38)}
.art{padding:34px}
.art h1{margin:0;font-size:clamp(2.3rem,4.5vw,4.6rem);line-height:.95;letter-spacing:-.06em;max-width:9ch}
.art p{color:var(--muted);max-width:48ch;margin:14px 0 24px}
.badge{display:inline-flex;align-items:center;gap:8px;padding:9px 14px;border:1px solid var(--line);border-radius:999px;color:var(--muted)}
.dot{width:10px;height:10px;border-radius:50%;background:linear-gradient(135deg,var(--a),var(--b));box-shadow:0 0 18px var(--a)}
.cards{display:grid;grid-template-columns:repeat(2,1fr);gap:12px}
.card{padding:16px;border-radius:20px;border:1px solid var(--line);background:rgba(255,255,255,.04)}
.card strong{display:block;margin-bottom:4px}.card span{color:var(--muted);font-size:.92rem}
.heroimg{width:min(92%,420px);display:block;margin:30px auto 0;animation:float 8s ease-in-out infinite;filter:drop-shadow(0 22px 38px rgba(0,0,0,.35))}
.form{padding:30px;display:grid;align-content:center}
.form h2{margin:0 0 8px;font-size:1.8rem}.form p{margin:0 0 22px;color:var(--muted)}
label{display:block;margin:14px 0 8px;font-weight:700}
input{width:100%;padding:14px 16px;border-radius:16px;border:1px solid rgba(255,255,255,.12);background:rgba(255,255,255,.04);color:var(--text);outline:none;transition:.2s border-color,.2s transform,.2s box-shadow}
input:focus{border-color:rgba(94,234,212,.7);box-shadow:0 0 0 4px rgba(94,234,212,.12)}
.submit{width:100%;margin-top:18px;padding:14px 16px;border:0;border-radius:16px;background:linear-gradient(135deg,var(--a),#93c5fd);color:#06101d;font-weight:900;cursor:pointer;transition:.25s transform,.25s box-shadow}
.submit:hover{transform:translateY(-2px);box-shadow:0 18px 42px rgba(96,165,250,.3)}
.error{margin:14px 0 0;padding:12px 14px;border-radius:14px;background:rgba(251,113,133,.12);border:1px solid rgba(251,113,133,.25);color:#fecdd3}
.footer{display:flex;justify-content:space-between;gap:12px;margin-top:16px;color:var(--muted);font-size:.92rem}
svg{display:block}
@keyframes drift{50%{transform:translate3d(0,14px,0) scale(1.05)}}
@keyframes float{50%{transform:translateY(-8px) rotate(-1deg)}}
@media (max-width:920px){body{overflow:auto}.shell{grid-template-columns:1fr}.art,.form{border-radius:24px}.cards{grid-template-columns:1fr}}
</style>
</head>
<body>
<div class="wrap">
  <main class="shell">
    <section class="art">
      <div class="badge"><span class="dot"></span><span>Admin Secure Access</span></div>
      <h1>Welcome back.</h1>
      <p>Sign in to manage patients, control records, and keep the system moving from one polished command center.</p>
      <div class="cards">
        <div class="card"><strong>Fast Workflow</strong><span>One-step access to daily operations</span></div>
        <div class="card"><strong>Secure Login</strong><span>Focused entry with simple recovery flow</span></div>
      </div>
      <svg class="heroimg" viewBox="0 0 520 360" aria-hidden="true">
        <defs>
          <linearGradient id="lg1" x1="0" x2="1"><stop offset="0%" stop-color="#5eead4"/><stop offset="100%" stop-color="#60a5fa"/></linearGradient>
          <linearGradient id="lg2" x1="0" x2="1"><stop offset="0%" stop-color="#0f172a"/><stop offset="100%" stop-color="#1e3a5f"/></linearGradient>
        </defs>
        <rect x="24" y="24" width="472" height="312" rx="34" fill="rgba(255,255,255,.05)" stroke="rgba(255,255,255,.12)"/>
        <rect x="70" y="72" width="180" height="216" rx="28" fill="url(#lg2)" stroke="rgba(255,255,255,.1)"/>
        <circle cx="160" cy="130" r="38" fill="url(#lg1)"/>
        <path d="M128 180h64M128 208h82M128 236h54" stroke="rgba(255,255,255,.3)" stroke-width="10" stroke-linecap="round"/>
        <rect x="286" y="84" width="150" height="34" rx="17" fill="rgba(96,165,250,.26)"/>
        <rect x="286" y="136" width="124" height="34" rx="17" fill="rgba(94,234,212,.24)"/>
        <rect x="286" y="188" width="164" height="34" rx="17" fill="rgba(245,158,11,.22)"/>
        <circle cx="398" cy="256" r="42" fill="#fb7185" fill-opacity=".26"/>
        <path d="M398 232v48M374 256h48" stroke="#fff" stroke-width="10" stroke-linecap="round"/>
      </svg>
    </section>
    <section class="form">
      <h2>Admin Login</h2>
      <p>Enter your credentials to continue.</p>
      <form method="post">
        <label>Username</label>
        <input type="text" name="username" value="<%= escapeHtml(user) %>" required>
        <label>Password</label>
        <input type="password" name="password" required>
        <button class="submit" type="submit">Login</button>
      </form>
      <% if(failed){ %><div class="error"><%= errorMessage %></div><% } %>
      <div class="footer"><span>Patient Management System</span><span>Secure access</span></div>
    </section>
  </main>
</div>
</body>
</html>
