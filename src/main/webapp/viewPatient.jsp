<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="db.jsp" %>

<%
    class PatientRow {
        int id;
        String name;
        int age;
        String gender;
        String disease;
        String mobile;
    }

    List<PatientRow> patients = new ArrayList<>();
    String errorMessage = null;

    try (
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement("select * from patient");
        ResultSet rs = ps.executeQuery()
    ) {
        while (rs.next()) {
            PatientRow patient = new PatientRow();
            patient.id = rs.getInt("id");
            patient.name = rs.getString("name");
            patient.age = rs.getInt("age");
            patient.gender = rs.getString("gender");
            patient.disease = rs.getString("disease");
            patient.mobile = rs.getString("mobile");
            patients.add(patient);
        }
    } catch (Exception e) {
        errorMessage = e.getClass().getSimpleName() + ": " + e.getMessage();
        e.printStackTrace();
    }

    int totalPatients = patients.size();
    int maleCount = 0;
    int femaleCount = 0;
    int otherCount = 0;
    for (PatientRow patient : patients) {
        String gender = patient.gender == null ? "" : patient.gender.trim().toLowerCase();
        if (gender.equals("male")) {
            maleCount++;
        } else if (gender.equals("female")) {
            femaleCount++;
        } else {
            otherCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Patient</title>
    <style>
        :root {
            --bg-1: #07111f;
            --bg-2: #10243f;
            --panel: rgba(9, 18, 33, 0.72);
            --panel-strong: rgba(13, 25, 45, 0.92);
            --line: rgba(148, 163, 184, 0.18);
            --text: #e5eefb;
            --muted: #90a4bf;
            --accent: #4dd0e1;
            --accent-2: #7c3aed;
            --danger: #ff6b6b;
            --success: #22c55e;
            --warning: #f59e0b;
            --shadow: 0 24px 80px rgba(0, 0, 0, 0.35);
            --radius-xl: 28px;
            --radius-lg: 20px;
            --radius-md: 14px;
        }

        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            min-height: 100%;
        }

        body {
            font-family: "Segoe UI", "Helvetica Neue", Arial, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(77, 208, 225, 0.20), transparent 30%),
                radial-gradient(circle at top right, rgba(124, 58, 237, 0.18), transparent 28%),
                linear-gradient(145deg, var(--bg-1), var(--bg-2));
        }

        body::before {
            content: "";
            position: fixed;
            inset: 0;
            background-image:
                linear-gradient(rgba(255, 255, 255, 0.035) 1px, transparent 1px),
                linear-gradient(90deg, rgba(255, 255, 255, 0.035) 1px, transparent 1px);
            background-size: 52px 52px;
            mask-image: linear-gradient(to bottom, rgba(0, 0, 0, 0.9), transparent);
            pointer-events: none;
        }

        .page-shell {
            position: relative;
            max-width: 1400px;
            margin: 0 auto;
            padding: 40px 24px 48px;
        }

        .hero {
            display: grid;
            grid-template-columns: minmax(0, 1.5fr) minmax(280px, 0.85fr);
            gap: 20px;
            align-items: stretch;
            margin-bottom: 22px;
            animation: riseIn 0.7s ease both;
        }

        .hero-card,
        .metrics-card,
        .table-card,
        .status-card {
            background: linear-gradient(180deg, rgba(13, 25, 45, 0.92), rgba(9, 18, 33, 0.78));
            border: 1px solid var(--line);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow);
            backdrop-filter: blur(18px);
        }

        .hero-card {
            padding: 28px;
            overflow: hidden;
            position: relative;
        }

        .hero-card::after {
            content: "";
            position: absolute;
            inset: auto -60px -80px auto;
            width: 220px;
            height: 220px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(77, 208, 225, 0.22), transparent 68%);
            pointer-events: none;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(77, 208, 225, 0.1);
            border: 1px solid rgba(77, 208, 225, 0.24);
            color: #bff8ff;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .eyebrow-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--accent);
            box-shadow: 0 0 0 6px rgba(77, 208, 225, 0.12);
        }

        .hero h1 {
            margin: 18px 0 10px;
            font-size: clamp(2rem, 3vw, 3.3rem);
            line-height: 1.05;
            letter-spacing: -0.04em;
        }

        .hero p {
            margin: 0;
            max-width: 60ch;
            color: var(--muted);
            font-size: 1rem;
            line-height: 1.7;
        }

        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 24px;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 46px;
            padding: 0 18px;
            border-radius: 14px;
            text-decoration: none;
            font-weight: 700;
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease, background 0.2s ease;
        }

        .button:hover {
            transform: translateY(-1px);
        }

        .button-primary {
            color: #04131a;
            background: linear-gradient(135deg, #87f5ff, #4dd0e1);
            box-shadow: 0 16px 32px rgba(77, 208, 225, 0.26);
        }

        .button-secondary {
            color: var(--text);
            border: 1px solid rgba(148, 163, 184, 0.24);
            background: rgba(255, 255, 255, 0.04);
        }

        .metrics-card {
            padding: 20px;
            display: grid;
            gap: 14px;
        }

        .metric-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 12px;
        }

        .metric {
            padding: 18px;
            border-radius: 18px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(148, 163, 184, 0.14);
        }

        .metric span {
            display: block;
            color: var(--muted);
            font-size: 0.82rem;
            margin-bottom: 8px;
        }

        .metric strong {
            display: block;
            font-size: 1.8rem;
            letter-spacing: -0.03em;
        }

        .metric small {
            display: block;
            margin-top: 6px;
            color: #9fb2d1;
            font-size: 0.82rem;
        }

        .filters {
            display: grid;
            grid-template-columns: minmax(0, 1fr) auto;
            gap: 14px;
            margin: 18px 0;
            align-items: center;
            animation: riseIn 0.8s ease both;
            animation-delay: 0.1s;
        }

        .search-wrap {
            position: relative;
        }

        .search-wrap input {
            width: 100%;
            min-height: 58px;
            padding: 0 20px 0 52px;
            border: 1px solid rgba(148, 163, 184, 0.2);
            border-radius: 18px;
            outline: none;
            color: var(--text);
            background: rgba(8, 16, 30, 0.82);
            box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.03);
            transition: border-color 0.2s ease, box-shadow 0.2s ease, transform 0.2s ease;
        }

        .search-wrap input::placeholder {
            color: #8096b8;
        }

        .search-wrap input:focus {
            border-color: rgba(77, 208, 225, 0.58);
            box-shadow: 0 0 0 4px rgba(77, 208, 225, 0.12);
        }

        .search-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #8ca6c7;
            font-size: 1rem;
            pointer-events: none;
        }

        .toolbar {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            justify-content: flex-end;
        }

        .toolbar-chip {
            min-height: 58px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 0 18px;
            border-radius: 18px;
            border: 1px solid rgba(148, 163, 184, 0.18);
            background: rgba(255, 255, 255, 0.04);
            color: var(--text);
            font-weight: 700;
            text-decoration: none;
            transition: transform 0.2s ease, border-color 0.2s ease, background 0.2s ease;
        }

        .toolbar-chip:hover {
            transform: translateY(-1px);
            border-color: rgba(77, 208, 225, 0.28);
            background: rgba(77, 208, 225, 0.08);
        }

        .table-card {
            overflow: hidden;
            animation: riseIn 0.9s ease both;
            animation-delay: 0.16s;
        }

        .table-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 16px;
            padding: 22px 24px;
            border-bottom: 1px solid var(--line);
        }

        .table-head h2 {
            margin: 0;
            font-size: 1.15rem;
            letter-spacing: -0.02em;
        }

        .table-head p {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 0.92rem;
        }

        .table-count {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(77, 208, 225, 0.08);
            border: 1px solid rgba(77, 208, 225, 0.18);
            color: #c5f8ff;
            font-weight: 700;
            white-space: nowrap;
        }

        .table-wrap {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1024px;
        }

        thead th {
            position: sticky;
            top: 0;
            z-index: 1;
            background: rgba(8, 16, 30, 0.96);
            color: #bcd1ee;
            text-align: left;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.12em;
            padding: 16px 18px;
            border-bottom: 1px solid rgba(148, 163, 184, 0.16);
        }

        tbody tr {
            border-bottom: 1px solid rgba(148, 163, 184, 0.08);
            transition: background 0.2s ease, transform 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(255, 255, 255, 0.03);
        }

        tbody td {
            padding: 18px;
            color: #d7e3f5;
            vertical-align: middle;
        }

        .patient-id {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-width: 48px;
            padding: 8px 12px;
            border-radius: 12px;
            background: rgba(77, 208, 225, 0.12);
            border: 1px solid rgba(77, 208, 225, 0.18);
            color: #d7fbff;
            font-weight: 800;
        }

        .name-cell {
            font-weight: 700;
            letter-spacing: -0.01em;
        }

        .subtle {
            display: block;
            margin-top: 4px;
            color: var(--muted);
            font-size: 0.85rem;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 9px 13px;
            border-radius: 999px;
            font-size: 0.86rem;
            font-weight: 700;
            white-space: nowrap;
        }

        .badge::before {
            content: "";
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }

        .badge-male {
            color: #7dd3fc;
            background: rgba(125, 211, 252, 0.12);
            border: 1px solid rgba(125, 211, 252, 0.18);
        }

        .badge-female {
            color: #f9a8d4;
            background: rgba(249, 168, 212, 0.12);
            border: 1px solid rgba(249, 168, 212, 0.18);
        }

        .badge-other {
            color: #fcd34d;
            background: rgba(252, 211, 77, 0.12);
            border: 1px solid rgba(252, 211, 77, 0.18);
        }

        .action-group {
            display: inline-flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .action-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            min-width: 92px;
            padding: 10px 14px;
            border-radius: 12px;
            font-weight: 700;
            text-decoration: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease, opacity 0.2s ease;
        }

        .action-link:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .action-edit {
            color: #04131a;
            background: linear-gradient(135deg, #c4f1ff, #67e8f9);
            box-shadow: 0 12px 24px rgba(103, 232, 249, 0.18);
        }

        .action-delete {
            color: #fff;
            background: linear-gradient(135deg, #ef4444, #f97316);
            box-shadow: 0 12px 24px rgba(239, 68, 68, 0.18);
        }

        .status-card {
            margin-top: 16px;
            padding: 22px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
            animation: riseIn 1s ease both;
            animation-delay: 0.2s;
        }

        .status-card h3 {
            margin: 0 0 6px;
            font-size: 1rem;
        }

        .status-card p {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }

        .empty-state {
            padding: 52px 24px;
            text-align: center;
        }

        .empty-state h3 {
            margin: 16px 0 8px;
            font-size: 1.35rem;
        }

        .empty-state p {
            margin: 0;
            color: var(--muted);
        }

        .empty-graphic {
            width: 82px;
            height: 82px;
            margin: 0 auto;
            border-radius: 22px;
            background: linear-gradient(145deg, rgba(77, 208, 225, 0.16), rgba(124, 58, 237, 0.12));
            border: 1px solid rgba(148, 163, 184, 0.16);
            display: grid;
            place-items: center;
            color: #cfe9ff;
            font-size: 1.9rem;
        }

        .alert {
            margin-top: 16px;
            padding: 16px 18px;
            border-radius: 18px;
            background: rgba(239, 68, 68, 0.12);
            border: 1px solid rgba(239, 68, 68, 0.22);
            color: #ffd2d2;
        }

        .hidden-row {
            display: none;
        }

        .fade-row {
            animation: rowIn 0.35s ease both;
        }

        @keyframes riseIn {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes rowIn {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 1080px) {
            .hero {
                grid-template-columns: 1fr;
            }

            .filters {
                grid-template-columns: 1fr;
            }

            .toolbar {
                justify-content: flex-start;
            }

            .table-head,
            .status-card {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 720px) {
            .page-shell {
                padding: 22px 14px 28px;
            }

            .hero-card,
            .metrics-card,
            .table-head,
            .status-card {
                border-radius: 22px;
            }

            .hero-card {
                padding: 22px;
            }

            .metric-grid {
                grid-template-columns: 1fr;
            }

            .button,
            .toolbar-chip,
            .action-link {
                width: 100%;
            }

            .hero-actions,
            .action-group {
                width: 100%;
            }

            .table-head {
                padding: 18px;
            }

            tbody td,
            thead th {
                padding: 14px 12px;
            }
        }
    </style>
</head>
<body>
    <div class="page-shell">
        <div class="hero">
            <section class="hero-card">
                <div class="eyebrow"><span class="eyebrow-dot"></span> Patient registry</div>
                <h1>Professional patient management with a faster, cleaner workflow.</h1>
                <p>
                    Review records, search instantly, and manage each patient from a modern interface designed for clarity and speed.
                </p>
                <div class="hero-actions">
                    <a class="button button-primary" href="addPatient.jsp">Add New Patient</a>
                    <a class="button button-secondary" href="dashboard.jsp">Back to Dashboard</a>
                </div>
            </section>

            <aside class="metrics-card">
                <div class="metric-grid">
                    <div class="metric">
                        <span>Total Patients</span>
                        <strong><%= totalPatients %></strong>
                        <small>Records currently available</small>
                    </div>
                    <div class="metric">
                        <span>Visible Now</span>
                        <strong id="visibleCount"><%= totalPatients %></strong>
                        <small>Updated by live search</small>
                    </div>
                    <div class="metric">
                        <span>Male</span>
                        <strong><%= maleCount %></strong>
                        <small>Gender distribution</small>
                    </div>
                    <div class="metric">
                        <span>Female + Other</span>
                        <strong><%= femaleCount + otherCount %></strong>
                        <small>Remaining records</small>
                    </div>
                </div>
            </aside>
        </div>

        <div class="filters">
            <div class="search-wrap">
                <span class="search-icon">&#128269;</span>
                <input id="patientSearch" type="text" placeholder="Search by name, disease, gender, mobile, or ID">
            </div>
            <div class="toolbar">
                <a class="toolbar-chip" href="addPatient.jsp">+ Add Patient</a>
            </div>
        </div>

        <section class="table-card">
            <div class="table-head">
                <div>
                    <h2>Patient List</h2>
                    <p>Click edit or delete to manage each record immediately.</p>
                </div>
                <div class="table-count"><span>&#9679;</span><span id="matchLabel"><%= totalPatients %> matched</span></div>
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Age</th>
                            <th>Gender</th>
                            <th>Disease</th>
                            <th>Mobile</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="patientTableBody">
                    <%
                        if (errorMessage != null) {
                    %>
                        <tr>
                            <td colspan="7">
                                <div class="alert"><%= errorMessage %></div>
                            </td>
                        </tr>
                    <%
                        } else if (patients.isEmpty()) {
                    %>
                        <tr>
                            <td colspan="7">
                                <div class="empty-state">
                                    <div class="empty-graphic">&#128137;</div>
                                    <h3>No patients found</h3>
                                    <p>Add the first patient to start building the registry.</p>
                                </div>
                            </td>
                        </tr>
                    <%
                        } else {
                            for (PatientRow patient : patients) {
                                String gender = patient.gender == null ? "" : patient.gender.trim();
                                String genderKey = gender.toLowerCase();
                                String badgeClass = "badge-other";
                                if (genderKey.equals("male")) {
                                    badgeClass = "badge-male";
                                } else if (genderKey.equals("female")) {
                                    badgeClass = "badge-female";
                                }
                    %>
                        <tr class="patient-row fade-row" data-search="<%= (patient.id + " " + patient.name + " " + patient.age + " " + gender + " " + patient.disease + " " + patient.mobile).toLowerCase().replace("\"", "&quot;") %>">
                            <td><span class="patient-id"><%= patient.id %></span></td>
                            <td>
                                <span class="name-cell"><%= patient.name %></span>
                                <span class="subtle">Record ID #<%= patient.id %></span>
                            </td>
                            <td><%= patient.age %></td>
                            <td><span class="badge <%= badgeClass %>"><%= gender %></span></td>
                            <td><%= patient.disease %></td>
                            <td><%= patient.mobile %></td>
                            <td>
                                <div class="action-group">
                                    <a class="action-link action-edit" href="editPatient.jsp?id=<%= patient.id %>">Edit</a>
                                    <a class="action-link action-delete" href="deletePatient.jsp?id=<%= patient.id %>">Delete</a>
                                </div>
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

        <section class="status-card">
            <div>
                <h3>Operational summary</h3>
                <p>Search updates the table instantly, action buttons stay visible, and the layout scales cleanly on smaller screens.</p>
            </div>
            <a class="button button-primary" href="addPatient.jsp">Create New Record</a>
        </section>
    </div>

    <script>
        (function () {
            const input = document.getElementById("patientSearch");
            const rows = Array.from(document.querySelectorAll(".patient-row"));
            const visibleCount = document.getElementById("visibleCount");
            const matchLabel = document.getElementById("matchLabel");

            function syncVisibleCount(count) {
                visibleCount.textContent = count;
                matchLabel.textContent = count + (count === 1 ? " matched" : " matched");
            }

            function filterRows() {
                const term = input.value.trim().toLowerCase();
                let count = 0;

                rows.forEach((row, index) => {
                    const haystack = row.dataset.search || "";
                    const matches = !term || haystack.includes(term);
                    row.classList.toggle("hidden-row", !matches);

                    if (matches) {
                        count++;
                        row.style.animationDelay = Math.min(index * 18, 180) + "ms";
                    }
                });

                syncVisibleCount(count);
            }

            if (input) {
                input.addEventListener("input", filterRows);
                input.addEventListener("keydown", function (event) {
                    if (event.key === "Escape") {
                        input.value = "";
                        filterRows();
                    }
                });
            }

            filterRows();
        })();
    </script>
</body>
</html>
