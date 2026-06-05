<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Patient</title>
    <style>
        :root {
            --bg-1: #081120;
            --bg-2: #0f213f;
            --bg-3: #12315d;
            --card: rgba(8, 16, 32, 0.72);
            --card-border: rgba(255, 255, 255, 0.14);
            --text: #eaf2ff;
            --muted: rgba(234, 242, 255, 0.72);
            --line: rgba(255, 255, 255, 0.16);
            --accent: #57d8ff;
            --accent-2: #7c9cff;
            --success: #39d98a;
            --shadow: 0 24px 90px rgba(0, 0, 0, 0.45);
        }

        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            min-height: 100%;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text);
            background:
                radial-gradient(circle at top left, rgba(87, 216, 255, 0.22), transparent 28%),
                radial-gradient(circle at top right, rgba(124, 156, 255, 0.18), transparent 24%),
                linear-gradient(135deg, var(--bg-1), var(--bg-2) 45%, var(--bg-3));
            overflow-x: hidden;
        }

        body::before,
        body::after {
            content: "";
            position: fixed;
            inset: auto;
            border-radius: 50%;
            pointer-events: none;
            filter: blur(18px);
            opacity: 0.7;
            animation: float 14s ease-in-out infinite;
        }

        body::before {
            width: 280px;
            height: 280px;
            left: -70px;
            top: 12vh;
            background: rgba(87, 216, 255, 0.18);
        }

        body::after {
            width: 220px;
            height: 220px;
            right: -50px;
            bottom: 10vh;
            background: rgba(124, 156, 255, 0.16);
            animation-delay: -5s;
        }

        .page {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 32px 18px;
            position: relative;
            isolation: isolate;
        }

        .wrap {
            width: min(1120px, 100%);
            display: grid;
            grid-template-columns: 1.05fr 0.95fr;
            gap: 24px;
            align-items: stretch;
        }

        .hero,
        .card {
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            background: var(--card);
            border: 1px solid var(--card-border);
            box-shadow: var(--shadow);
        }

        .hero {
            border-radius: 28px;
            padding: 34px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            min-height: 620px;
            animation: rise 900ms ease both;
        }

        .hero::before {
            content: "";
            position: absolute;
            inset: auto -120px -120px auto;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(87, 216, 255, 0.25), transparent 68%);
            pointer-events: none;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            width: fit-content;
            padding: 10px 14px;
            border-radius: 999px;
            border: 1px solid rgba(255, 255, 255, 0.14);
            background: rgba(255, 255, 255, 0.05);
            color: var(--muted);
            font-size: 0.9rem;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .eyebrow span {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--accent), var(--success));
            box-shadow: 0 0 0 6px rgba(87, 216, 255, 0.12);
        }

        h1 {
            margin: 22px 0 14px;
            font-size: clamp(2.2rem, 4vw, 4.2rem);
            line-height: 0.98;
            letter-spacing: -0.05em;
            max-width: 11ch;
        }

        .hero p {
            margin: 0;
            color: var(--muted);
            max-width: 52ch;
            font-size: 1.03rem;
            line-height: 1.75;
        }

        .metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-top: 34px;
        }

        .metric {
            padding: 16px 15px;
            border-radius: 20px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.09);
        }

        .metric strong {
            display: block;
            font-size: 1.35rem;
            margin-bottom: 6px;
        }

        .metric span {
            color: var(--muted);
            font-size: 0.92rem;
            line-height: 1.45;
        }

        .footer-note {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 28px;
            color: var(--muted);
            font-size: 0.95rem;
        }

        .avatar-row {
            display: flex;
            align-items: center;
        }

        .avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            border: 2px solid rgba(255, 255, 255, 0.22);
            margin-left: -10px;
            background: linear-gradient(135deg, var(--accent), var(--accent-2));
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.18);
        }

        .avatar:first-child {
            margin-left: 0;
        }

        .card {
            border-radius: 28px;
            padding: 30px;
            position: relative;
            overflow: hidden;
            animation: rise 1s ease 120ms both;
        }

        .card-head {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 24px;
        }

        .card h2 {
            margin: 0 0 8px;
            font-size: clamp(1.6rem, 2vw, 2.1rem);
            letter-spacing: -0.03em;
        }

        .card .sub {
            margin: 0;
            color: var(--muted);
            line-height: 1.6;
        }

        .status {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(57, 217, 138, 0.12);
            border: 1px solid rgba(57, 217, 138, 0.22);
            color: #c8ffe2;
            font-size: 0.9rem;
            white-space: nowrap;
        }

        .status::before {
            content: "";
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--success);
            box-shadow: 0 0 0 6px rgba(57, 217, 138, 0.12);
        }

        form {
            display: grid;
            gap: 18px;
        }

        .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .field {
            position: relative;
        }

        .field.full {
            grid-column: 1 / -1;
        }

        input,
        select {
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.14);
            background: rgba(255, 255, 255, 0.05);
            color: var(--text);
            border-radius: 18px;
            padding: 18px 16px 16px;
            font-size: 1rem;
            outline: none;
            transition: border-color 180ms ease, background 180ms ease, transform 180ms ease, box-shadow 180ms ease;
        }

        input:focus,
        select:focus {
            border-color: rgba(87, 216, 255, 0.72);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 0 0 4px rgba(87, 216, 255, 0.12);
            transform: translateY(-1px);
        }

        input::placeholder {
            color: transparent;
        }

        .field label {
            position: absolute;
            left: 16px;
            top: 16px;
            color: rgba(234, 242, 255, 0.7);
            pointer-events: none;
            transition: transform 180ms ease, color 180ms ease, opacity 180ms ease, top 180ms ease, font-size 180ms ease;
            background: transparent;
            padding: 0 6px;
        }

        .field input:focus + label,
        .field input:not(:placeholder-shown) + label {
            top: -9px;
            font-size: 0.78rem;
            color: var(--accent);
            background: linear-gradient(180deg, rgba(8, 16, 32, 0.98), rgba(8, 16, 32, 0.82));
        }

        .field select + label {
            top: -9px;
            font-size: 0.78rem;
            color: var(--accent);
            background: linear-gradient(180deg, rgba(8, 16, 32, 0.98), rgba(8, 16, 32, 0.82));
        }

        select {
            appearance: none;
            padding-right: 46px;
            color:aliceblue;
        }

        .select-wrap::after {
            content: "";
            position: absolute;
            right: 18px;
            top: 50%;
            width: 9px;
            height: 9px;
            border-right: 2px solid rgba(234, 242, 255, 0.7);
            border-bottom: 2px solid rgba(234, 242, 255, 0.7);
            transform: translateY(-65%) rotate(45deg);
            pointer-events: none;
            color: white;
        }

        .actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            margin-top: 6px;
        }

        .btn {
            appearance: none;
            border: none;
            cursor: pointer;
            border-radius: 18px;
            padding: 14px 22px;
            font-size: 1rem;
            font-weight: 700;
            transition: transform 180ms ease, box-shadow 180ms ease, opacity 180ms ease;
        }

        .btn-primary {
            color: #04111d;
            background: linear-gradient(135deg, #7cf4ff, #7f9dff 55%, #b2e4ff);
            box-shadow: 0 18px 40px rgba(87, 216, 255, 0.24);
        }

        .btn-secondary {
            color: var(--text);
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.12);
        }

        .btn-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .btn:active {
            transform: translateY(0);
        }

        .helper {
            color: var(--muted);
            font-size: 0.92rem;
            line-height: 1.6;
            margin: 2px 0 0;
        }

        .spark {
            position: absolute;
            inset: auto 22px 22px auto;
            width: 140px;
            height: 140px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(87, 216, 255, 0.12), transparent 65%);
            pointer-events: none;
        }

        @keyframes rise {
            from {
                opacity: 0;
                transform: translateY(18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% {
                transform: translate3d(0, 0, 0) scale(1);
            }
            50% {
                transform: translate3d(18px, -16px, 0) scale(1.06);
            }
        }

        @media (max-width: 960px) {
            .wrap {
                grid-template-columns: 1fr;
            }

            .hero,
            .card {
                min-height: auto;
            }
        }

        @media (max-width: 640px) {
            .page {
                padding: 16px;
            }

            .hero,
            .card {
                padding: 22px;
                border-radius: 22px;
            }

            .grid,
            .metrics {
                grid-template-columns: 1fr;
            }

            .card-head {
                flex-direction: column;
            }

            .actions {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <main class="page">
        <div class="wrap">
            <section class="hero">
                <div>
                    <div class="eyebrow"><span></span> Patient intake dashboard</div>
                    <h1>Care begins with a better first form.</h1>
                    <p>
                        Capture patient details in a clean, confident interface designed for fast entry,
                        clear focus, and a premium clinical workflow.
                    </p>

                    <div class="metrics">
                        <div class="metric">
                            <strong>Fast</strong>
                            <span>Streamlined fields for quick admission handling.</span>
                        </div>
                        <div class="metric">
                            <strong>Clear</strong>
                            <span>Readable hierarchy with guided input states.</span>
                        </div>
                        <div class="metric">
                            <strong>Modern</strong>
                            <span>Glassmorphism styling with subtle motion.</span>
                        </div>
                    </div>
                </div>

                <div>
                    <div class="footer-note">
                        <div class="avatar-row" aria-hidden="true">
                            <div class="avatar"></div>
                            <div class="avatar"></div>
                            <div class="avatar"></div>
                        </div>
                        <span>Trusted by care teams that need precision and speed.</span>
                    </div>
                </div>
            </section>

            <section class="card">
                <div class="card-head">
                    <div>
                        <h2>Add Patient</h2>
                        <p class="sub">Enter the details below to register a new patient record.</p>
                    </div>
                    <div class="status">Live validation ready</div>
                </div>

                <form action="insertPatient.jsp" method="post">
                    <div class="grid">
                        <div class="field">
                            <input type="text" name="name" id="name" placeholder=" " required>
                            <label for="name">Full Name</label>
                        </div>

                        <div class="field">
                            <input type="number" name="age" id="age" placeholder=" " min="0" max="150" required>
                            <label for="age">Age</label>
                        </div>

                        <div class="field select-wrap">
                            <select name="gender" id="gender" required>
                                <option value="" selected disabled></option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                                <option value="Other">Other</option>
                            </select>
                            <label for="gender">Gender</label>
                        </div>

                        <div class="field">
                            <input type="text" name="mobile" id="mobile" placeholder=" " pattern="[0-9]{10,15}" required>
                            <label for="mobile">Mobile Number</label>
                        </div>

                        <div class="field full">
                            <input type="text" name="disease" id="disease" placeholder=" " required>
                            <label for="disease">Disease / Complaint</label>
                        </div>
                    </div>

                    <div class="actions">
                        <button type="submit" class="btn btn-primary">Save Patient</button>
                        <button type="reset" class="btn btn-secondary">Clear Form</button>
                        <a href="dashboard.jsp" class="btn btn-secondary btn-link">Back to Dashboard</a>
                    </div>

                    <p class="helper">All fields are required. Keep the record accurate to support follow-up and treatment.</p>
                </form>
                <div class="spark" aria-hidden="true"></div>
            </section>
        </div>
    </main>
</body>
</html>
