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

    private void renderOutcome(javax.servlet.jsp.JspWriter out, String title, String heading, String message, String detail) throws java.io.IOException {
        out.write("<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"><title>");
        out.write(escapeHtml(title));
        out.write("</title><style>");
        out.write(":root{--bg-0:#040814;--bg-1:#08111f;--bg-2:#0d1d36;--panel:rgba(10,18,33,.84);--line:rgba(148,163,184,.18);--text:#edf6ff;--muted:#9cb1cd;--accent:#63f0dd;--accent-2:#74a8ff;--danger:#fb7185;--shadow:0 28px 90px rgba(0,0,0,.42)}");
        out.write("*{box-sizing:border-box}html,body{height:100%}body{margin:0;color:var(--text);font:16px/1.5 \"Segoe UI\",Tahoma,Geneva,Verdana,sans-serif;background:radial-gradient(circle at 10% 8%, rgba(99,240,221,.22), transparent 24%),radial-gradient(circle at 92% 4%, rgba(116,168,255,.20), transparent 22%),linear-gradient(145deg, var(--bg-0), var(--bg-1) 45%, var(--bg-2));display:grid;place-items:center;padding:18px}body:before{content:\"\";position:fixed;inset:0;background-image:linear-gradient(rgba(255,255,255,.035) 1px, transparent 1px),linear-gradient(90deg, rgba(255,255,255,.035) 1px, transparent 1px);background-size:56px 56px;mask-image:linear-gradient(to bottom, rgba(0,0,0,.85), transparent);pointer-events:none}.card{position:relative;width:min(720px,100%);padding:30px;border-radius:30px;background:linear-gradient(180deg, rgba(12,22,40,.94), rgba(8,15,29,.84));border:1px solid var(--line);box-shadow:var(--shadow);backdrop-filter:blur(18px);overflow:hidden}.card:before{content:\"\";position:absolute;inset:auto -120px -120px auto;width:320px;height:320px;border-radius:50%;background:radial-gradient(circle, rgba(99,240,221,.16), transparent 68%);pointer-events:none}.eyebrow{display:inline-flex;align-items:center;gap:10px;padding:10px 14px;border-radius:999px;border:1px solid rgba(148,163,184,.16);background:rgba(255,255,255,.04);color:var(--muted);font-size:.82rem;letter-spacing:.12em;text-transform:uppercase;font-weight:800}.eyebrow span{width:10px;height:10px;border-radius:50%;background:linear-gradient(135deg, var(--accent), var(--accent-2));box-shadow:0 0 0 6px rgba(99,240,221,.11)}h1{margin:18px 0 10px;font-size:clamp(2rem, 4vw, 3.4rem);line-height:1.02;letter-spacing:-.05em}.message{margin:0;color:var(--muted);font-size:1.02rem;line-height:1.8;max-width:58ch}.actions{display:flex;flex-wrap:wrap;gap:12px;margin-top:26px}.btn{display:inline-flex;align-items:center;justify-content:center;gap:10px;padding:14px 18px;border-radius:16px;text-decoration:none;font-weight:800;transition:transform .2s ease, box-shadow .2s ease, opacity .2s ease}.btn:hover{transform:translateY(-2px)}.primary{color:#04111d;background:linear-gradient(135deg, var(--accent), #98e5ff);box-shadow:0 18px 42px rgba(99,240,221,.24)}.secondary{color:var(--text);background:rgba(255,255,255,.04);border:1px solid rgba(148,163,184,.18)}.danger{color:#fff;background:linear-gradient(135deg, rgba(251,113,133,.94), rgba(244,63,94,.92));box-shadow:0 18px 42px rgba(251,113,133,.22)}.details{margin-top:18px;padding:16px 18px;border-radius:20px;background:rgba(255,255,255,.04);border:1px solid rgba(148,163,184,.12);color:var(--muted)}.details strong{color:var(--text)}.grid{display:grid;grid-template-columns:repeat(3, minmax(0, 1fr));gap:14px;margin-top:24px}.mini{padding:16px;border-radius:20px;background:rgba(255,255,255,.04);border:1px solid rgba(148,163,184,.12)}.mini b{display:block;font-size:1.2rem;letter-spacing:-.03em}.mini span{display:block;margin-top:6px;color:var(--muted);font-size:.92rem}.status{display:inline-flex;align-items:center;gap:8px;margin-top:4px;padding:10px 14px;border-radius:999px;background:rgba(99,240,221,.08);border:1px solid rgba(99,240,221,.16);color:#d9fffb;font-size:.88rem;font-weight:700}.status:before{content:\"\";width:8px;height:8px;border-radius:50%;background:currentColor}.footer{margin-top:20px;color:var(--muted);font-size:.92rem}.danger-text{color:#ffd7df}.spark{position:absolute;inset:auto 24px 24px auto;width:150px;height:150px;border-radius:50%;background:radial-gradient(circle, rgba(116,168,255,.12), transparent 66%);pointer-events:none}@media (max-width:720px){.card{padding:22px;border-radius:24px}.grid{grid-template-columns:1fr}.actions{width:100%}.btn{width:100%}}");
        out.write("</style></head><body><main class=\"card\"><div class=\"eyebrow\"><span></span> Patient intake</div><h1>");
        out.write(escapeHtml(heading));
        out.write("</h1><p class=\"message\">");
        out.write(escapeHtml(message));
        out.write("</p><div class=\"status\">Action required</div><div class=\"grid\"><div class=\"mini\"><b>Dashboard</b><span>Return to the control center.</span></div><div class=\"mini\"><b>Logout</b><span>Leave the session and go to the landing page.</span></div><div class=\"mini\"><b>Records</b><span>Review the patient list after save.</span></div></div><div class=\"actions\"><a class=\"btn primary\" href=\"dashboard\">Back to Dashboard</a><a class=\"btn secondary\" href=\"viewPatient.jsp\">Open Patient List</a><a class=\"btn danger\" href=\"index.html\">Logout</a></div><div class=\"details\"><strong>Tip:</strong> verify all required fields, especially name, age, gender, disease, and mobile, before trying again.</div><div class=\"footer\">If the insert failed because of a server or database issue, the system message below may help diagnose it.</div>");
        if (detail != null && detail.trim().length() > 0) {
            out.write("<div class=\"details danger-text\">");
            out.write(escapeHtml(detail));
            out.write("</div>");
        }
        out.write("<div class=\"spark\" aria-hidden=\"true\"></div></main></body></html>");
    }
%>

<%
    String name = request.getParameter("name");
    int age = Integer.parseInt(request.getParameter("age"));
    String gender = request.getParameter("gender");
    String disease = request.getParameter("disease");
    String mobile = request.getParameter("mobile");

    Connection con = null;
    PreparedStatement ps = null;

    try {
        con = getConnection();
        ps = con.prepareStatement("INSERT INTO patient(name, age, gender, disease, mobile) VALUES(?,?,?,?,?)");
        ps.setString(1, name);
        ps.setInt(2, age);
        ps.setString(3, gender);
        ps.setString(4, disease);
        ps.setString(5, mobile);

        int result = ps.executeUpdate();

        if (result > 0) {
            response.sendRedirect("viewPatient.jsp");
        } else {
            renderOutcome(out, "Insert Patient", "Patient not inserted!", "The record could not be saved. Please return to the dashboard or review the patient list.", null);
        }
    } catch (Exception e) {
        renderOutcome(out, "Insert Patient", "Something went wrong", "The request could not be completed. Please try again after checking the input and connection.", e.getMessage());
        e.printStackTrace();
    } finally {
        try {
            if (ps != null) ps.close();
            if (con != null) con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
