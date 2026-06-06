<%@ page import="java.sql.*" %>
<%@ include file="db.jsp" %>

<%!
    private String esc(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
    }
%>

<%
    int id = Integer.parseInt(request.getParameter("id"));
    boolean found = false;
    int patientId = id;
    String name = "";
    String age = "";
    String gender = "";
    String disease = "";
    String mobile = "";
    String errorMessage = null;

    try (
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement("select * from patient where id=?")
    ) {
        ps.setInt(1, id);

        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                found = true;
                patientId = rs.getInt("id");
                name = rs.getString("name");
                age = String.valueOf(rs.getInt("age"));
                gender = rs.getString("gender");
                disease = rs.getString("disease");
                mobile = rs.getString("mobile");
            } else {
                errorMessage = "No patient record was found for this ID.";
            }
        }
    } catch (Exception e) {
        errorMessage = "Unable to load the patient record.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Patient | PMS+</title>
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
        radial-gradient(circle at 10% 8%, rgba(99,240,221,.18), transparent 24%),
        radial-gradient(circle at 92% 4%, rgba(116,168,255,.18), transparent 22%),
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
    max-width:1420px;
    margin:0 auto;
    padding:24px;
}
.topbar,
.hero,
.form-card,
.aside-card{
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
.brand-copy span{
    color:var(--muted);
    font-size:.92rem;
}
.top-actions{
    display:flex;
    gap:12px;
    flex-wrap:wrap;
    justify-content:flex-end;
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
.primary{color:#04111d;background:linear-gradient(135deg, var(--accent), #98e5ff)}
.secondary{color:var(--text);background:rgba(255,255,255,.04);border:1px solid rgba(148,163,184,.18)}
.danger{color:#fff;background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92))}
.layout{
    display:grid;
    grid-template-columns:1.04fr .96fr;
    gap:18px;
}
.hero{
    position:relative;
    overflow:hidden;
    padding:30px;
    min-height:420px;
}
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
    font-size:clamp(2.2rem, 4.8vw, 4.6rem);
    line-height:.95;
    letter-spacing:-.06em;
    max-width:10ch;
}
.lead{
    margin:0;
    max-width:58ch;
    color:var(--muted);
    font-size:1.02rem;
    line-height:1.8;
}
.summary{
    display:grid;
    grid-template-columns:repeat(3, minmax(0, 1fr));
    gap:14px;
    margin-top:26px;
}
.stat{
    padding:18px;
    border-radius:20px;
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
}
.stat span{
    display:block;
    color:var(--muted);
    font-size:.9rem;
    margin-bottom:8px;
}
.stat strong{
    display:block;
    font-size:1.7rem;
    letter-spacing:-.04em;
}
.aside-card{
    padding:24px;
    display:grid;
    gap:14px;
}
.aside-card .panel{
    padding:18px;
    border-radius:20px;
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
}
.panel strong{
    display:block;
    margin-bottom:6px;
}
.panel span{
    color:var(--muted);
}
.pulse{
    width:12px;
    height:12px;
    border-radius:50%;
    background:var(--accent);
    box-shadow:0 0 0 8px rgba(99,240,221,.12);
}
.badge-row{
    display:flex;
    flex-wrap:wrap;
    gap:10px;
    margin-top:2px;
}
.badge{
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
}
.badge::before{
    content:"";
    width:8px;
    height:8px;
    border-radius:50%;
    background:currentColor;
}
.form-card{
    margin-top:18px;
    padding:28px;
}
.form-head{
    display:flex;
    align-items:flex-start;
    justify-content:space-between;
    gap:16px;
    margin-bottom:22px;
}
.form-head h2{
    margin:0 0 8px;
    font-size:clamp(1.8rem, 2.4vw, 2.6rem);
    letter-spacing:-.04em;
}
.form-head p{
    margin:0;
    color:var(--muted);
    max-width:50ch;
    line-height:1.7;
}
form{
    display:grid;
    gap:16px;
}
.field-grid{
    display:grid;
    grid-template-columns:repeat(2, minmax(0, 1fr));
    gap:16px;
}
.field{
    position:relative;
}
label{
    display:block;
    margin-bottom:9px;
    color:#dfe8fa;
    font-weight:700;
}
input,
select{
    width:100%;
    border:1px solid rgba(167,190,255,.16);
    border-radius:18px;
    background:rgba(6,11,21,.45);
    color:var(--text);
    padding:14px 16px;
    font:inherit;
    outline:none;
    transition:border-color .2s ease, box-shadow .2s ease, transform .2s ease, background .2s ease;
}
input:focus,
select:focus{
    border-color:rgba(99,240,221,.58);
    box-shadow:0 0 0 4px rgba(99,240,221,.12);
    transform:translateY(-1px);
    background:rgba(6,11,21,.56);
}
.actions{
    display:flex;
    flex-wrap:wrap;
    gap:12px;
    justify-content:flex-start;
    margin-top:2px;
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
.preview{
    margin-top:18px;
    padding:18px;
    border-radius:24px;
    border:1px solid rgba(148,163,184,.12);
    background:linear-gradient(135deg, rgba(99,240,221,.08), rgba(116,168,255,.08));
}
.preview-grid{
    display:grid;
    grid-template-columns:repeat(2, minmax(0, 1fr));
    gap:12px;
    margin-top:14px;
}
.preview-item{
    padding:14px;
    border-radius:18px;
    background:rgba(255,255,255,.04);
    border:1px solid rgba(148,163,184,.12);
}
.preview-item span{
    display:block;
    color:var(--muted);
    font-size:.88rem;
    margin-bottom:6px;
}
.preview-item strong{
    display:block;
    font-size:1rem;
}
.footer{
    margin-top:18px;
    color:var(--muted);
    font-size:.92rem;
}
.hidden-state{
    display:grid;
    place-items:center;
    min-height:260px;
    text-align:center;
}
.hidden-state h2{
    margin:14px 0 8px;
    font-size:clamp(1.6rem, 2vw, 2.4rem);
}
.hidden-state p{
    margin:0;
    max-width:48ch;
    color:var(--muted);
}
@media (max-width:1100px){
    .layout{grid-template-columns:1fr}
    .hero{min-height:auto}
}
@media (max-width:760px){
    .page{padding:14px}
    .topbar,.hero,.aside-card,.form-card{border-radius:24px}
    .topbar{flex-direction:column;align-items:flex-start}
    .top-actions{justify-content:flex-start}
    .summary,.field-grid,.preview-grid{grid-template-columns:1fr}
    .form-head{flex-direction:column}
    .actions,.btn{width:100%}
}
</style>
</head>
<body>
<div class="page">
    <header class="topbar">
        <div class="brand">
            <div class="brand-mark">PMS</div>
            <div class="brand-copy">
                <strong>Edit Patient</strong>
                <span>Update records with a polished workflow</span>
            </div>
        </div>
        <div class="top-actions">
            <a class="btn secondary" href="viewPatient.jsp">Patient List</a>
            <a class="btn secondary" href="dashboard">Back to Dashboard</a>
            <a class="btn danger" href="index.html">Logout</a>
        </div>
    </header>

    <div class="layout">
        <section class="hero">
            <div class="eyebrow"><span></span> Patient record editor</div>
            <h1>Refine the patient record with confidence.</h1>
            <p class="lead">This screen is designed for fast updates with a calmer, higher-end layout. The current patient details are loaded from the database and can be edited immediately.</p>

            <div class="summary">
                <div class="stat">
                    <span>Record ID</span>
                    <strong><%= patientId %></strong>
                </div>
                <div class="stat">
                    <span>Current age</span>
                    <strong><%= esc(age) %></strong>
                </div>
                <div class="stat">
                    <span>Gender</span>
                    <strong><%= esc(gender) %></strong>
                </div>
            </div>

            <div class="preview">
                <div class="badge-row">
                    <div class="badge"><span class="pulse"></span><span>Live form</span></div>
                    <div class="badge">Editable record</div>
                    <div class="badge">Back to dashboard ready</div>
                </div>
                <div class="preview-grid">
                    <div class="preview-item">
                        <span>Name</span>
                        <strong><%= esc(name) %></strong>
                    </div>
                    <div class="preview-item">
                        <span>Disease</span>
                        <strong><%= esc(disease) %></strong>
                    </div>
                    <div class="preview-item">
                        <span>Mobile</span>
                        <strong><%= esc(mobile) %></strong>
                    </div>
                    <div class="preview-item">
                        <span>Status</span>
                        <strong><%= found ? "Loaded from database" : "Not found" %></strong>
                    </div>
                </div>
            </div>
        </section>

        <aside class="aside-card">
            <div class="panel">
                <strong>Editing tips</strong>
                <span>Keep the name, age, and mobile accurate to avoid duplicate or incomplete records.</span>
            </div>
            <div class="panel">
                <strong>Navigation</strong>
                <span>Use the dashboard button if you want to switch tasks without saving changes.</span>
            </div>
            <div class="panel">
                <strong>Record source</strong>
                <span>Values are loaded from the `patient` table and prefilled into the form below.</span>
            </div>
        </aside>
    </div>

    <section class="form-card">
        <div class="form-head">
            <div>
                <h2>Update Patient</h2>
                <p>Modify the required fields and submit the record to save your changes.</p>
            </div>
            <div class="badge-row">
                <div class="badge"><span class="pulse"></span><span>Ready to update</span></div>
            </div>
        </div>

        <%
            if (!found || errorMessage != null) {
        %>
            <div class="hidden-state">
                <div class="badge-row" style="justify-content:center">
                    <div class="badge" style="background:rgba(251,113,133,.08);border-color:rgba(251,113,133,.16)"><span class="pulse" style="background:var(--danger);box-shadow:0 0 0 8px rgba(251,113,133,.12)"></span><span>Record unavailable</span></div>
                </div>
                <h2><%= errorMessage != null ? esc(errorMessage) : "Patient record not found." %></h2>
                <p>You can return to the dashboard or open the patient list to choose another record.</p>
                <div class="actions" style="margin-top:18px;justify-content:center">
                    <a class="btn primary" href="dashboard">Back to Dashboard</a>
                    <a class="btn secondary" href="viewPatient.jsp">Patient List</a>
                </div>
            </div>
        <%
            } else {
        %>
        <form action="updatePatient.jsp" method="post" id="editForm">
            <input type="hidden" name="id" value="<%= patientId %>">

            <div class="field-grid">
                <div class="field">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" value="<%= esc(name) %>" required>
                </div>
                <div class="field">
                    <label for="age">Age</label>
                    <input type="number" id="age" name="age" value="<%= esc(age) %>" min="0" max="150" required>
                </div>
                <div class="field">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender" required>
                        <option value="Male" <%= "Male".equalsIgnoreCase(gender) ? "selected" : "" %>>Male</option>
                        <option value="Female" <%= "Female".equalsIgnoreCase(gender) ? "selected" : "" %>>Female</option>
                        <option value="Other" <%= "Other".equalsIgnoreCase(gender) ? "selected" : "" %>>Other</option>
                    </select>
                </div>
                <div class="field">
                    <label for="mobile">Mobile</label>
                    <input type="text" id="mobile" name="mobile" value="<%= esc(mobile) %>" pattern="[0-9]{10,15}" required>
                </div>
                <div class="field" style="grid-column:1 / -1">
                    <label for="disease">Disease</label>
                    <input type="text" id="disease" name="disease" value="<%= esc(disease) %>" required>
                </div>
            </div>

            <div class="actions">
                <button class="btn primary" type="submit">Update Patient</button>
                <button class="btn secondary" type="reset">Reset Changes</button>
                <a class="btn secondary" href="dashboard">Back to Dashboard</a>
            </div>

            <div class="notice">
                <strong>Important:</strong> the update is submitted to <code>updatePatient.jsp</code> and then returns you to the patient list.
            </div>
        </form>
        <%
            }
        %>
    </section>

    <div class="footer">A calmer, more dynamic edit screen helps staff review and update records with fewer mistakes.</div>
</div>

<script>
(function () {
  const form = document.getElementById("editForm");
  if (!form) return;

  const fields = Array.from(form.querySelectorAll("input, select"));

  function updateState() {
    const filled = fields.filter(function (field) {
      return String(field.value || "").trim().length > 0;
    }).length;
    form.dataset.filled = String(filled);
  }

  fields.forEach(function (field) {
    field.addEventListener("input", updateState);
    field.addEventListener("change", updateState);
  });

  updateState();
})();
</script>
</body>
</html>
