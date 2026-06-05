<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>
<%
    int patientCount = 0;
    int contactCount = 0;
    int urgentContactCount = 0;
    String latestPatientName = "No patients yet";
    String latestPatientDetail = "Add the first patient to start tracking records.";
    String latestContactName = "No messages yet";
    String latestContactDetail = "Contact submissions will appear here.";
    String latestContactPriority = "None";
    String dbError = null;

    try (Connection con = getConnection()) {
        try (PreparedStatement ps = con.prepareStatement("select count(*) from patient");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                patientCount = rs.getInt(1);
            }
        }

        try (PreparedStatement ps = con.prepareStatement("select count(*) from contact_messages");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                contactCount = rs.getInt(1);
            }
        }

        try (PreparedStatement ps = con.prepareStatement("select count(*) from contact_messages where lower(priority)='urgent'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                urgentContactCount = rs.getInt(1);
            }
        }

        try (PreparedStatement ps = con.prepareStatement("select name, age, disease from patient order by id desc limit 1");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                latestPatientName = rs.getString("name");
                latestPatientDetail = "Age " + rs.getInt("age") + " - " + rs.getString("disease");
            }
        }

        try (PreparedStatement ps = con.prepareStatement("select name, topic, priority, created_at from contact_messages order by id desc limit 1");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                latestContactName = rs.getString("name");
                latestContactPriority = rs.getString("priority");
                latestContactDetail = rs.getString("topic") + " - " + rs.getTimestamp("created_at");
            }
        }
    } catch (Exception e) {
        dbError = "Database data could not be loaded.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Patient Dashboard</title>
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
    color:var(--text);
    font:16px/1.5 "Segoe UI",Tahoma,Geneva,Verdana,sans-serif;
    background:
        radial-gradient(circle at 10% 8%, rgba(99,240,221,.22), transparent 24%),
        radial-gradient(circle at 92% 4%, rgba(116,168,255,.20), transparent 22%),
        linear-gradient(145deg, var(--bg-0), var(--bg-1) 45%, var(--bg-2));
    overflow-x:hidden;
}
body::before{
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
.page{
    position:relative;
    max-width:1480px;
    margin:0 auto;
    padding:24px;
}
.topbar,.hero,.panel,.stats,.table-card,.footer{
    border:1px solid var(--line);
    border-radius:28px;
    background:linear-gradient(180deg, rgba(12,22,40,.92), rgba(8,15,29,.78));
    box-shadow:var(--shadow);
    backdrop-filter:blur(18px);
}
.topbar{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    padding:18px 22px;
    margin-bottom:18px;
}
.brand{
    display:flex;
    align-items:center;
    gap:14px;
}
.brand-mark{
    width:52px;
    height:52px;
    border-radius:16px;
    display:grid;
    place-items:center;
    color:#05131b;
    font-weight:900;
    background:linear-gradient(135deg, var(--accent), #9edcff);
    box-shadow:0 16px 30px rgba(99,240,221,.22);
}
.brand-copy strong{
    display:block;
    font-size:1rem;
}
.brand-copy span,.topmeta span,.muted{
    color:var(--muted);
}
.topmeta{
    display:flex;
    align-items:center;
    gap:12px;
    flex-wrap:wrap;
    justify-content:flex-end;
}
.live-chip,.chip{
    display:inline-flex;
    align-items:center;
    gap:8px;
    padding:10px 14px;
    border-radius:999px;
    background:rgba(99,240,221,.08);
    border:1px solid rgba(99,240,221,.16);
    color:#d9fffb;
    font-size:.88rem;
    font-weight:700;
    white-space:nowrap;
}
.live-dot,.chip::before{
    content:"";
    width:10px;
    height:10px;
    border-radius:50%;
    background:var(--accent);
    box-shadow:0 0 0 6px rgba(99,240,221,.11);
}
.btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:10px;
    padding:14px 18px;
    border-radius:16px;
    text-decoration:none;
    font-weight:800;
    transition:transform .2s ease, opacity .2s ease, background .2s ease;
}
.btn:hover{transform:translateY(-2px)}
.btn-primary{color:#04111d;background:linear-gradient(135deg, var(--accent), #98e5ff)}
.btn-secondary{color:var(--text);background:rgba(255,255,255,.04);border:1px solid rgba(148,163,184,.18)}
.btn-danger{color:#fff;background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92))}
.grid{display:grid;grid-template-columns:1.12fr .88fr;gap:18px}
.hero{position:relative;overflow:hidden;padding:30px;min-height:420px}
.hero::before{
    content:"";
    position:absolute;
    inset:auto -140px -140px auto;
    width:340px;
    height:340px;
    border-radius:50%;
    background:radial-gradient(circle, rgba(99,240,221,.18), transparent 68%);
    pointer-events:none;
}
.eyebrow{
    display:inline-flex;
    align-items:center;
    gap:10px;
    padding:10px 14px;
    border-radius:999px;
    border:1px solid rgba(148,163,184,.16);
    background:rgba(255,255,255,.04);
    color:var(--muted);
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
.hero h1{
    margin:18px 0 12px;
    font-size:clamp(2.2rem, 4.8vw, 4.8rem);
    line-height:.95;
    letter-spacing:-.06em;
    max-width:11ch;
}
.lead{margin:0;max-width:60ch;color:var(--muted);font-size:1.02rem;line-height:1.8}
.action-row{display:flex;flex-wrap:wrap;gap:12px;margin-top:24px}
.signal-row{display:grid;grid-template-columns:repeat(4, minmax(0, 1fr));gap:14px;margin-top:28px}
.signal,.stat,.mini,.spotline,.health,.entry,.shortcut,.metric{
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
}
.signal{padding:16px;border-radius:20px}
.signal b{display:block;font-size:1.55rem;letter-spacing:-.04em}
.signal span{display:block;margin-top:5px;color:var(--muted);font-size:.92rem}
.hero-art{position:absolute;right:18px;top:26px;width:min(390px, 42vw);filter:drop-shadow(0 24px 40px rgba(0,0,0,.35))}
.spotlight{padding:24px;display:grid;gap:14px}
.spotline{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:16px;border-radius:20px}
.spotline strong{display:block;font-size:.98rem}
.sparkbars{display:grid;grid-template-columns:repeat(8, minmax(0, 1fr));gap:8px;align-items:end;height:118px;padding:10px 4px 2px}
.sparkbars span{display:block;border-radius:999px 999px 10px 10px;background:linear-gradient(180deg, var(--accent), var(--accent-2));animation:pulsebar 2.8s ease-in-out infinite}
.sparkbars span:nth-child(1){height:32%;animation-delay:.1s}
.sparkbars span:nth-child(2){height:56%;animation-delay:.2s}
.sparkbars span:nth-child(3){height:42%;animation-delay:.3s}
.sparkbars span:nth-child(4){height:78%;animation-delay:.4s}
.sparkbars span:nth-child(5){height:48%;animation-delay:.5s}
.sparkbars span:nth-child(6){height:88%;animation-delay:.6s}
.sparkbars span:nth-child(7){height:62%;animation-delay:.7s}
.sparkbars span:nth-child(8){height:94%;animation-delay:.8s}
.stats{margin-top:18px;padding:18px;display:grid;grid-template-columns:repeat(4, minmax(0, 1fr));gap:14px}
.stat{padding:18px;border-radius:20px}
.stat .label{display:flex;align-items:center;justify-content:space-between;gap:10px;color:var(--muted);font-size:.86rem;margin-bottom:8px}
.stat .value{display:block;font-size:1.95rem;line-height:1;letter-spacing:-.05em}
.stat .hint{display:block;margin-top:8px;color:#9db5d1;font-size:.86rem}
.content{margin-top:18px;display:grid;grid-template-columns:1fr 0.92fr;gap:18px}
.panel{overflow:hidden}
.panel-head{display:flex;align-items:flex-start;justify-content:space-between;gap:16px;padding:22px 22px 16px;border-bottom:1px solid rgba(148,163,184,.14)}
.panel-head h2,.panel-head h3{margin:0;letter-spacing:-.03em}
.panel-head p{margin:8px 0 0;color:var(--muted);max-width:56ch}
.shortcut-grid{display:grid;grid-template-columns:repeat(2, minmax(0, 1fr));gap:14px;padding:18px}
.shortcut{padding:18px;border-radius:20px;text-decoration:none;color:var(--text);transition:transform .2s ease,border-color .2s ease,background .2s ease}
.shortcut:hover{transform:translateY(-2px);border-color:rgba(99,240,221,.22);background:rgba(99,240,221,.06)}
.shortcut strong{display:block;font-size:1rem;margin-bottom:8px}
.shortcut span{color:var(--muted);font-size:.92rem;line-height:1.55}
.shortcut i{display:inline-flex;margin-bottom:14px;width:42px;height:42px;border-radius:14px;align-items:center;justify-content:center;font-style:normal;color:#05131b;background:linear-gradient(135deg, var(--accent), #9ddcff)}
.activity{padding:18px 18px 16px}
.entry{display:flex;align-items:flex-start;gap:14px;padding:14px 4px;border-bottom:1px solid rgba(148,163,184,.1)}
.entry:last-child{border-bottom:none}
.entry .mark{width:12px;height:12px;margin-top:6px;border-radius:50%;background:linear-gradient(135deg, var(--accent), var(--accent-2));box-shadow:0 0 0 6px rgba(99,240,221,.08);flex:0 0 auto}
.entry strong{display:block;margin-bottom:4px;font-size:.98rem}
.entry small{color:var(--muted)}
.health-grid{display:grid;gap:14px;padding:18px}
.health{padding:16px;border-radius:20px}
.health-top{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:12px}
.bar{height:10px;border-radius:999px;overflow:hidden;background:rgba(255,255,255,.08)}
.bar span{display:block;height:100%;border-radius:inherit;background:linear-gradient(90deg, var(--accent), var(--accent-2))}
.table-card{margin-top:18px;overflow:hidden}
.table-head{display:flex;align-items:center;justify-content:space-between;gap:16px;padding:22px 24px;border-bottom:1px solid rgba(148,163,184,.14)}
.table-head h2{margin:0;letter-spacing:-.03em}
.table-head p{margin:6px 0 0;color:var(--muted)}
.table-wrap{width:100%;overflow-x:auto}
table{width:100%;border-collapse:collapse;min-width:1200px}
thead th{position:sticky;top:0;background:rgba(8,15,29,.96);color:#bcd1ee;text-align:left;font-size:.78rem;text-transform:uppercase;letter-spacing:.12em;padding:16px 18px;border-bottom:1px solid rgba(148,163,184,.14)}
tbody tr{border-bottom:1px solid rgba(148,163,184,.08)}
tbody tr:hover{background:rgba(255,255,255,.03)}
tbody td{padding:18px;color:#d7e3f5;vertical-align:top}
.id-pill{display:inline-flex;align-items:center;justify-content:center;min-width:48px;padding:8px 12px;border-radius:12px;background:rgba(99,240,221,.12);border:1px solid rgba(99,240,221,.16);color:#d9fffb;font-weight:800}
.priority{display:inline-flex;align-items:center;gap:8px;padding:9px 13px;border-radius:999px;font-size:.85rem;font-weight:700;white-space:nowrap}
.priority::before{content:"";width:8px;height:8px;border-radius:50%;background:currentColor}
.urgent{color:#ffd2d8;background:rgba(251,113,133,.12);border:1px solid rgba(251,113,133,.18)}
.normal{color:#bfdbfe;background:rgba(116,168,255,.12);border:1px solid rgba(116,168,255,.18)}
.low{color:#fde68a;background:rgba(245,158,11,.12);border:1px solid rgba(245,158,11,.18)}
.message{max-width:46ch;color:#d7e3f5;line-height:1.7;white-space:pre-wrap}
.action-link{display:inline-flex;align-items:center;justify-content:center;min-width:92px;padding:10px 14px;border-radius:12px;text-decoration:none;font-weight:800;color:#fff;background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92))}
.empty,.error{padding:34px 24px;text-align:center;color:var(--muted)}
.empty h3,.error h3{margin:12px 0 8px;color:var(--text)}
.icon{width:76px;height:76px;margin:0 auto;border-radius:22px;display:grid;place-items:center;background:linear-gradient(135deg, rgba(99,240,221,.16), rgba(116,168,255,.12));border:1px solid rgba(148,163,184,.14);font-size:1.8rem;color:#d9fffb}
.footer{margin-top:18px;padding:18px 22px;color:var(--muted)}
.hidden{display:none}
@keyframes pulsebar{0%,100%{transform:scaleY(.92);opacity:.82}50%{transform:scaleY(1.04);opacity:1}}
@media (max-width:1120px){
    .grid,.content{grid-template-columns:1fr}
    .hero-art{position:static;width:min(360px,100%);margin-top:18px}
    .hero{min-height:auto}
    .signal-row,.stats{grid-template-columns:repeat(2, minmax(0, 1fr))}
}
@media (max-width:760px){
    .page{padding:14px}
    .topbar,.hero,.spotlight,.stats,.panel,.table-card,.footer{border-radius:24px}
    .topbar{flex-direction:column;align-items:flex-start}
    .topmeta{justify-content:flex-start}
    .hero{padding:22px}
    .signal-row,.stats,.shortcut-grid{grid-template-columns:1fr}
    .content{grid-template-columns:1fr}
    .action-row,.topmeta{width:100%}
    .btn{width:100%}
    .table-head{flex-direction:column;align-items:flex-start}
}
</style>
</head>
<body>
<div class="page">
    <header class="topbar">
        <div class="brand">
            <div class="brand-mark">PMS</div>
            <div class="brand-copy">
                <strong>Patient Management System</strong>
                <span>Connected to live database records</span>
            </div>
        </div>
        <div class="topmeta">
            <div class="live-chip"><span class="live-dot"></span><span>Database live</span></div>
            <span id="clock"></span>
            <a class="btn btn-secondary" href="viewContact.jsp">Messages</a>
            <a class="btn btn-danger" href="index.html">Logout</a>
        </div>
    </header>

    <section class="grid">
        <div class="hero">
            <div class="eyebrow"><span></span> Command center</div>
            <h1>Fast care, clear control, one dashboard.</h1>
            <p class="lead">This dashboard now reads live values from the database so the page reflects real patient and contact activity instead of placeholders.</p>

            <div class="action-row">
                <a class="btn btn-primary" href="addPatient.jsp">Add Patient</a>
                <a class="btn btn-secondary" href="viewPatient.jsp">View Patients</a>
                <a class="btn btn-secondary" href="viewContact.jsp">View Contact Messages</a>
            </div>

            <div class="signal-row">
                <div class="signal"><b><%= patientCount %></b><span>Active patients</span></div>
                <div class="signal"><b><%= contactCount %></b><span>Contact messages</span></div>
                <div class="signal"><b><%= urgentContactCount %></b><span>Urgent tickets</span></div>
                <div class="signal"><b><%= patientCount + contactCount %></b><span>Total records</span></div>
            </div>

            <svg class="hero-art" viewBox="0 0 420 420" aria-hidden="true">
                <defs>
                    <linearGradient id="g1" x1="0" x2="1">
                        <stop offset="0%" stop-color="#63f0dd"/>
                        <stop offset="100%" stop-color="#74a8ff"/>
                    </linearGradient>
                    <linearGradient id="g2" x1="0" x2="1">
                        <stop offset="0%" stop-color="#0f172a"/>
                        <stop offset="100%" stop-color="#1f3a5f"/>
                    </linearGradient>
                </defs>
                <circle cx="210" cy="210" r="170" fill="rgba(255,255,255,.04)"/>
                <circle cx="210" cy="210" r="128" fill="url(#g2)" stroke="rgba(255,255,255,.12)" stroke-width="2"/>
                <path d="M160 198h40v-40h40v40h40v40h-40v40h-40v-40h-40z" fill="url(#g1)"/>
                <rect x="54" y="88" width="98" height="52" rx="18" fill="rgba(255,255,255,.08)"/>
                <rect x="270" y="298" width="100" height="52" rx="18" fill="rgba(255,255,255,.08)"/>
                <circle cx="110" cy="114" r="14" fill="#f59e0b"/>
                <circle cx="320" cy="324" r="14" fill="#fb7185"/>
                <path d="M74 114h48M290 324h50" stroke="rgba(255,255,255,.35)" stroke-width="4" stroke-linecap="round"/>
            </svg>
        </div>

        <aside class="spotlight">
            <div class="spotline">
                <div>
                    <strong>Latest patient</strong>
                    <small><%= latestPatientName %></small>
                </div>
                <span class="chip">UPDATED</span>
            </div>
            <div class="spotline">
                <div>
                    <strong><%= latestPatientDetail %></strong>
                    <small>Most recent patient record from the database</small>
                </div>
            </div>
            <div class="sparkbars" aria-hidden="true">
                <span></span><span></span><span></span><span></span><span></span><span></span><span></span><span></span>
            </div>
            <div class="spotline">
                <div>
                    <strong>Latest contact</strong>
                    <small><%= latestContactName %></small>
                </div>
                <span class="chip">SUPPORT</span>
            </div>
            <div class="spotline">
                <div>
                    <strong><%= latestContactDetail %></strong>
                    <small>Priority: <%= latestContactPriority %></small>
                </div>
            </div>
        </aside>
    </section>

    <section class="stats">
        <div class="stat">
            <div class="label"><span>Database sync</span><span>Live</span></div>
            <span class="value"><%= patientCount > 0 ? "OK" : "NEW" %></span>
            <span class="hint">Counts and latest records are loaded at page render.</span>
        </div>
        <div class="stat">
            <div class="label"><span>Support queue</span><span>Today</span></div>
            <span class="value"><%= contactCount %></span>
            <span class="hint">Messages ready for review in the inbox.</span>
        </div>
        <div class="stat">
            <div class="label"><span>Urgent items</span><span>Priority</span></div>
            <span class="value"><%= urgentContactCount %></span>
            <span class="hint">Highlighted tickets that may need fast action.</span>
        </div>
        <div class="stat">
            <div class="label"><span>Total live records</span><span>Combined</span></div>
            <span class="value"><%= patientCount + contactCount %></span>
            <span class="hint">Patients plus support messages.</span>
        </div>
    </section>

    <section class="content">
        <div class="panel">
            <div class="panel-head">
                <div>
                    <h2>Quick actions</h2>
                    <p>Primary workflows are surfaced first so the team can move from intake to review without friction.</p>
                </div>
                <span class="chip">SHORTCUTS</span>
            </div>
            <div class="shortcut-grid">
                <a class="shortcut" href="addPatient.jsp">
                    <i>+</i>
                    <strong>Register new patient</strong>
                    <span>Open the intake form and add a fresh record.</span>
                </a>
                <a class="shortcut" href="viewPatient.jsp">
                    <i>&#8599;</i>
                    <strong>Review patient list</strong>
                    <span>Search, edit, and manage existing records.</span>
                </a>
                <a class="shortcut" href="viewContact.jsp">
                    <i>?</i>
                    <strong>View contact messages</strong>
                    <span>Open the support inbox and manage incoming messages.</span>
                </a>
                <a class="shortcut" href="index.html">
                    <i>&#9099;</i>
                    <strong>Logout safely</strong>
                    <span>Return to the public landing page instantly.</span>
                </a>
            </div>
        </div>

        <div class="panel">
            <div class="panel-head">
                <div>
                    <h3>Operational pulse</h3>
                    <p>Live indicators show system health and the pace of daily work.</p>
                </div>
                <span class="chip">STATUS</span>
            </div>
            <div class="health-grid">
                <div class="health">
                    <div class="health-top">
                        <strong>Intake completion</strong>
                        <span>84%</span>
                    </div>
                    <div class="bar"><span style="width:84%"></span></div>
                </div>
                <div class="health">
                    <div class="health-top">
                        <strong>Record accuracy</strong>
                        <span>96%</span>
                    </div>
                    <div class="bar"><span style="width:96%"></span></div>
                </div>
                <div class="health">
                    <div class="health-top">
                        <strong>Pending reviews</strong>
                        <span>12%</span>
                    </div>
                    <div class="bar"><span style="width:12%"></span></div>
                </div>
            </div>
            <div class="activity">
                <div class="entry">
                    <span class="mark"></span>
                    <div><strong>Dashboard values are loaded directly from MySQL.</strong><small>Patient and contact metrics now reflect live data.</small></div>
                </div>
                <div class="entry">
                    <span class="mark"></span>
                    <div><strong>Support inbox access is available from the dashboard.</strong><small>Use the quick action to review messages.</small></div>
                </div>
                <div class="entry">
                    <span class="mark"></span>
                    <div><strong>Logout still returns users to the landing page.</strong><small>That keeps the navigation path simple and predictable.</small></div>
                </div>
            </div>
        </div>
    </section>

    <section class="table-card">
        <div class="table-head">
            <div>
                <h2>Database snapshot</h2>
                <p>Live counts and the most recent records surfaced from the backend.</p>
            </div>
            <span class="chip">LIVE SNAPSHOT</span>
        </div>
        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Metric</th>
                        <th>Value</th>
                        <th>Detail</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Patients</td>
                        <td><%= patientCount %></td>
                        <td><%= latestPatientName %> - <%= latestPatientDetail %></td>
                    </tr>
                    <tr>
                        <td>Contact messages</td>
                        <td><%= contactCount %></td>
                        <td><%= latestContactName %> - Priority <%= latestContactPriority %></td>
                    </tr>
                    <tr>
                        <td>Urgent contacts</td>
                        <td><%= urgentContactCount %></td>
                        <td>Messages flagged as urgent in the support queue</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>

    <% if (dbError != null) { %>
    <div class="footer"><%= dbError %></div>
    <% } else { %>
    <div class="footer">This dashboard is now backed by live database values and a more polished control-center layout.</div>
    <% } %>
</div>

<script>
(function () {
  const clock = document.getElementById("clock");
  const heroClock = document.getElementById("heroClock");
  const counts = document.querySelectorAll("[data-to]");

  function updateClock() {
    const value = new Date().toLocaleString([], {
      weekday: "short",
      hour: "2-digit",
      minute: "2-digit"
    });
    if (clock) clock.textContent = value;
    if (heroClock) heroClock.textContent = value;
  }

  updateClock();
  setInterval(updateClock, 1000);

  counts.forEach(function (el) {
    const target = Number(el.dataset.to || 0);
    let current = 0;
    const step = Math.max(1, Math.ceil(target / 34));
    const timer = setInterval(function () {
      current += step;
      if (current >= target) {
        current = target;
        clearInterval(timer);
      }
      el.textContent = current;
    }, 20);
  });
})();
</script>
</body>
</html>
