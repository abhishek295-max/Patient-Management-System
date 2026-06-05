<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="db.jsp" %>

<%
    class ContactRow {
        int id;
        String name;
        String email;
        String topic;
        String priority;
        String message;
        Timestamp createdAt;
    }

    List<ContactRow> contacts = new ArrayList<>();
    String errorMessage = null;

    try (
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM contact_messages ORDER BY id DESC");
        ResultSet rs = ps.executeQuery()
    ) {
        while (rs.next()) {
            ContactRow contact = new ContactRow();
            contact.id = rs.getInt("id");
            contact.name = rs.getString("name");
            contact.email = rs.getString("email");
            contact.topic = rs.getString("topic");
            contact.priority = rs.getString("priority");
            contact.message = rs.getString("message");
            contact.createdAt = rs.getTimestamp("created_at");
            contacts.add(contact);
        }
    } catch (Exception e) {
        errorMessage = "Unable to load contact messages.";
    }

    int total = contacts.size();
    int urgent = 0;
    int normal = 0;
    int low = 0;
    for (ContactRow contact : contacts) {
        String priority = contact.priority == null ? "" : contact.priority.trim().toLowerCase();
        if (priority.equals("urgent")) {
            urgent++;
        } else if (priority.equals("normal")) {
            normal++;
        } else {
            low++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>View Contact Messages | PMS+</title>
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
    --warning:#f59e0b;
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
        radial-gradient(circle at 10% 8%, rgba(99,240,221,.18), transparent 24%),
        radial-gradient(circle at 92% 4%, rgba(116,168,255,.18), transparent 22%),
        linear-gradient(145deg, var(--bg-0), var(--bg-1) 45%, var(--bg-2));
    overflow-x:hidden;
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
.page{
    position:relative;
    max-width:1500px;
    margin:0 auto;
    padding:24px;
}
.topbar{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    padding:18px 22px;
    margin-bottom:18px;
    border:1px solid var(--line);
    border-radius:30px;
    background:linear-gradient(180deg, rgba(12,21,38,.88), rgba(8,15,29,.76));
    box-shadow:var(--shadow);
    backdrop-filter:blur(18px);
}
.title-wrap h1{
    margin:0;
    font-size:clamp(2rem, 3.5vw, 3.2rem);
    letter-spacing:-.05em;
}
.title-wrap p{
    margin:8px 0 0;
    color:var(--muted);
}
.actions{
    display:flex;
    flex-wrap:wrap;
    gap:12px;
    justify-content:flex-end;
}
.btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:10px;
    min-height:48px;
    padding:0 18px;
    border-radius:16px;
    text-decoration:none;
    font-weight:800;
    transition:transform .2s ease, opacity .2s ease, border-color .2s ease, background .2s ease;
}
.btn:hover{transform:translateY(-2px)}
.primary{
    color:#04111d;
    background:linear-gradient(135deg, var(--accent), #98e5ff);
}
.secondary{
    color:var(--text);
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.18);
}
.hero{
    display:grid;
    grid-template-columns:repeat(4, minmax(0, 1fr));
    gap:14px;
    margin-bottom:18px;
}
.metric{
    padding:18px;
    border-radius:24px;
    background:linear-gradient(180deg, rgba(12,22,40,.92), rgba(8,15,29,.78));
    border:1px solid var(--line);
    box-shadow:var(--shadow);
}
.metric span{
    display:block;
    color:var(--muted);
    font-size:.9rem;
    margin-bottom:8px;
}
.metric strong{
    display:block;
    font-size:2rem;
    letter-spacing:-.05em;
}
.toolbar{
    display:grid;
    grid-template-columns:minmax(0, 1fr) auto;
    gap:14px;
    margin-bottom:18px;
}
.search{
    position:relative;
}
.search input{
    width:100%;
    min-height:58px;
    padding:0 18px 0 48px;
    border-radius:18px;
    border:1px solid rgba(148,163,184,.2);
    outline:none;
    color:var(--text);
    background:rgba(8,15,29,.82);
}
.search input::placeholder{color:#8096b8}
.search input:focus{
    border-color:rgba(99,240,221,.58);
    box-shadow:0 0 0 4px rgba(99,240,221,.12);
}
.search-icon{
    position:absolute;
    left:18px;
    top:50%;
    transform:translateY(-50%);
    color:#8ca6c7;
}
.table-card{
    overflow:hidden;
    border-radius:30px;
    border:1px solid var(--line);
    background:linear-gradient(180deg, rgba(12,22,40,.92), rgba(8,15,29,.78));
    box-shadow:var(--shadow);
}
.table-head{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:16px;
    padding:22px 24px;
    border-bottom:1px solid rgba(148,163,184,.14);
}
.table-head h2{
    margin:0;
    letter-spacing:-.03em;
}
.table-head p{
    margin:6px 0 0;
    color:var(--muted);
}
.chip{
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
.table-wrap{
    width:100%;
    overflow-x:auto;
}
table{
    width:100%;
    border-collapse:collapse;
    min-width:1200px;
}
thead th{
    position:sticky;
    top:0;
    background:rgba(8,15,29,.96);
    color:#bcd1ee;
    text-align:left;
    font-size:.78rem;
    text-transform:uppercase;
    letter-spacing:.12em;
    padding:16px 18px;
    border-bottom:1px solid rgba(148,163,184,.14);
}
tbody tr{
    border-bottom:1px solid rgba(148,163,184,.08);
    transition:background .2s ease;
}
tbody tr:hover{
    background:rgba(255,255,255,.03);
}
tbody td{
    padding:18px;
    color:#d7e3f5;
    vertical-align:top;
}
.id-pill{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-width:48px;
    padding:8px 12px;
    border-radius:12px;
    background:rgba(99,240,221,.12);
    border:1px solid rgba(99,240,221,.16);
    color:#d9fffb;
    font-weight:800;
}
.priority{
    display:inline-flex;
    align-items:center;
    gap:8px;
    padding:9px 13px;
    border-radius:999px;
    font-size:.85rem;
    font-weight:700;
    white-space:nowrap;
}
.priority::before{
    content:"";
    width:8px;
    height:8px;
    border-radius:50%;
    background:currentColor;
}
.urgent{
    color:#ffd2d8;
    background:rgba(251,113,133,.12);
    border:1px solid rgba(251,113,133,.18);
}
.normal{
    color:#bfdbfe;
    background:rgba(116,168,255,.12);
    border:1px solid rgba(116,168,255,.18);
}
.low{
    color:#fde68a;
    background:rgba(245,158,11,.12);
    border:1px solid rgba(245,158,11,.18);
}
.message{
    max-width:46ch;
    color:#d7e3f5;
    line-height:1.7;
    white-space:pre-wrap;
}
.action-link{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-width:92px;
    padding:10px 14px;
    border-radius:12px;
    text-decoration:none;
    font-weight:800;
    color:#fff;
    background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92));
    box-shadow:0 12px 24px rgba(251,113,133,.18);
}
.action-link:hover{
    opacity:.95;
}
.empty,
.error{
    padding:34px 24px;
    text-align:center;
    color:var(--muted);
}
.empty h3,
.error h3{
    margin:12px 0 8px;
    color:var(--text);
}
.icon{
    width:76px;
    height:76px;
    margin:0 auto;
    border-radius:22px;
    display:grid;
    place-items:center;
    background:linear-gradient(135deg, rgba(99,240,221,.16), rgba(116,168,255,.12));
    border:1px solid rgba(148,163,184,.14);
    font-size:1.8rem;
    color:#d9fffb;
}
.hidden{display:none}
.footer{
    margin-top:18px;
    padding:18px 22px;
    border-radius:24px;
    background:linear-gradient(135deg, rgba(99,240,221,.08), rgba(116,168,255,.08));
    border:1px solid rgba(148,163,184,.14);
    color:var(--muted);
    box-shadow:var(--shadow);
}
@media (max-width:1100px){
    .hero,.toolbar{grid-template-columns:1fr}
}
@media (max-width:760px){
    .page{padding:14px}
    .topbar,.table-card,.footer{border-radius:24px}
    .topbar{flex-direction:column;align-items:flex-start}
    .actions{justify-content:flex-start}
    .hero{grid-template-columns:1fr}
}
</style>
</head>
<body>
<div class="page">
    <header class="topbar">
        <div class="title-wrap">
            <h1>Contact Messages</h1>
            <p>Review customer messages, prioritize responses, and keep the support queue organized.</p>
        </div>
        <div class="actions">
            <a class="btn secondary" href="dashboard.jsp">Back to Dashboard</a>
            <a class="btn primary" href="contact.jsp">Open Contact Form</a>
        </div>
    </header>

    <section class="hero">
        <div class="metric">
            <span>Total Messages</span>
            <strong><%= total %></strong>
        </div>
        <div class="metric">
            <span>Urgent</span>
            <strong><%= urgent %></strong>
        </div>
        <div class="metric">
            <span>Normal</span>
            <strong><%= normal %></strong>
        </div>
        <div class="metric">
            <span>Low</span>
            <strong><%= low %></strong>
        </div>
    </section>

    <div class="toolbar">
        <div class="search">
            <span class="search-icon">&#128269;</span>
            <input id="searchInput" type="text" placeholder="Search by name, email, topic, priority, or message">
        </div>
        <div class="actions">
            <span class="chip"><span>&#9679;</span><span id="visibleCount"><%= total %> visible</span></span>
        </div>
    </div>

    <section class="table-card">
        <div class="table-head">
            <div>
                <h2>Inbox</h2>
                <p>Newest messages appear first. Delete carefully.</p>
            </div>
            <span class="chip">LIVE QUEUE</span>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Topic</th>
                        <th>Priority</th>
                        <th>Message</th>
                        <th>Date</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="contactBody">
                <%
                    if (errorMessage != null) {
                %>
                    <tr>
                        <td colspan="8">
                            <div class="error">
                                <div class="icon">&#9888;</div>
                                <h3><%= errorMessage %></h3>
                                <p>Please check the database connection and try again.</p>
                            </div>
                        </td>
                    </tr>
                <%
                    } else if (contacts.isEmpty()) {
                %>
                    <tr>
                        <td colspan="8">
                            <div class="empty">
                                <div class="icon">&#9993;</div>
                                <h3>No contact messages yet</h3>
                                <p>New submissions will appear here automatically.</p>
                            </div>
                        </td>
                    </tr>
                <%
                    } else {
                        for (ContactRow contact : contacts) {
                            String searchData = (contact.name + " " + contact.email + " " + contact.topic + " " + contact.priority + " " + contact.message).toLowerCase();
                            String priorityKey = contact.priority == null ? "low" : contact.priority.trim().toLowerCase();
                            String priorityClass = "low";
                            if ("urgent".equals(priorityKey)) {
                                priorityClass = "urgent";
                            } else if ("normal".equals(priorityKey)) {
                                priorityClass = "normal";
                            }
                %>
                    <tr class="contact-row" data-search="<%= searchData.replace("\"", "&quot;") %>">
                        <td><span class="id-pill"><%= contact.id %></span></td>
                        <td><%= contact.name %></td>
                        <td><%= contact.email %></td>
                        <td><%= contact.topic %></td>
                        <td><span class="priority <%= priorityClass %>"><%= contact.priority %></span></td>
                        <td><div class="message"><%= contact.message %></div></td>
                        <td><%= contact.createdAt %></td>
                        <td>
                            <a class="action-link" href="deleteContact.jsp?id=<%= contact.id %>" onclick="return confirm('Delete this message?')">Delete</a>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </section>

    <div class="footer">
        The contact inbox is now styled as a real operations screen, with filtering and direct navigation back to the dashboard.
    </div>
</div>

<script>
(function () {
    const input = document.getElementById('searchInput');
    const rows = Array.from(document.querySelectorAll('.contact-row'));
    const visibleCount = document.getElementById('visibleCount');

    function syncCount(count) {
        visibleCount.textContent = count + (count === 1 ? ' visible' : ' visible');
    }

    function filterRows() {
        const term = input.value.trim().toLowerCase();
        let count = 0;

        rows.forEach((row) => {
            const search = row.dataset.search || '';
            const match = !term || search.includes(term);
            row.classList.toggle('hidden', !match);
            if (match) {
                count++;
            }
        });

        syncCount(count);
    }

    input.addEventListener('input', filterRows);
    filterRows();
})();
</script>
</body>
</html>
