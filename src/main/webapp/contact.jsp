<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | PMS+</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #08111f;
            --bg-soft: rgba(11, 20, 35, 0.72);
            --panel: rgba(12, 21, 38, 0.86);
            --panel-2: rgba(16, 27, 47, 0.9);
            --text: #eef4ff;
            --muted: #b7c5de;
            --line: rgba(167, 190, 255, 0.14);
            --primary: #7cdbff;
            --primary-2: #7c8cff;
            --accent: #78f0c0;
            --danger: #ff8fab;
            --shadow: 0 30px 80px rgba(3, 8, 18, 0.52);
            --radius: 28px;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        html {
            scroll-behavior: smooth;
        }

        body {
            min-height: 100vh;
            font-family: 'Manrope', sans-serif;
            background:
                radial-gradient(circle at 15% 20%, rgba(124, 219, 255, 0.18), transparent 28%),
                radial-gradient(circle at 80% 15%, rgba(124, 140, 255, 0.2), transparent 26%),
                radial-gradient(circle at 75% 85%, rgba(120, 240, 192, 0.18), transparent 24%),
                linear-gradient(135deg, #050914 0%, #091327 48%, #0b1730 100%);
            color: var(--text);
            overflow-x: hidden;
        }

        body::before,
        body::after {
            content: "";
            position: fixed;
            inset: auto;
            width: 36rem;
            height: 36rem;
            border-radius: 50%;
            filter: blur(24px);
            opacity: 0.22;
            pointer-events: none;
            z-index: 0;
        }

        body::before {
            top: -10rem;
            left: -12rem;
            background: radial-gradient(circle, rgba(124, 219, 255, 0.9), transparent 65%);
            animation: drift 18s ease-in-out infinite;
        }

        body::after {
            right: -12rem;
            bottom: -10rem;
            background: radial-gradient(circle, rgba(124, 140, 255, 0.88), transparent 65%);
            animation: drift 22s ease-in-out infinite reverse;
        }

        a {
            color: inherit;
            text-decoration: none;
        }

        .page {
            position: relative;
            z-index: 1;
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 20;
            backdrop-filter: blur(18px);
            background: rgba(7, 13, 25, 0.7);
            border-bottom: 1px solid rgba(167, 190, 255, 0.12);
        }

        .topbar-inner {
            max-width: 1240px;
            margin: 0 auto;
            padding: 18px 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px;
        }

        .brand {
            display: inline-flex;
            align-items: center;
            gap: 14px;
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .brand-mark {
            width: 46px;
            height: 46px;
            border-radius: 16px;
            display: grid;
            place-items: center;
            background: linear-gradient(135deg, rgba(124, 219, 255, 0.96), rgba(124, 140, 255, 0.94));
            color: #06101d;
            box-shadow: 0 18px 36px rgba(124, 140, 255, 0.35);
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            justify-content: center;
        }

        .nav a {
            color: var(--muted);
            font-weight: 600;
            padding: 10px 14px;
            border-radius: 999px;
            transition: 0.28s ease;
        }

        .nav a:hover,
        .nav a.active {
            color: var(--text);
            background: rgba(124, 219, 255, 0.12);
        }

        .cta {
            padding: 12px 18px;
            border-radius: 999px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--primary), var(--primary-2));
            color: #07111d;
            box-shadow: 0 18px 36px rgba(124, 140, 255, 0.28);
            transition: transform 0.25s ease, box-shadow 0.25s ease;
        }

        .cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 22px 42px rgba(124, 140, 255, 0.34);
        }

        .hero {
            max-width: 1240px;
            margin: 0 auto;
            padding: 44px 24px 26px;
            display: grid;
            grid-template-columns: 1.08fr 0.92fr;
            gap: 28px;
            align-items: center;
        }

        .eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 10px 16px;
            border-radius: 999px;
            background: rgba(124, 219, 255, 0.1);
            border: 1px solid rgba(124, 219, 255, 0.16);
            color: #d8f7ff;
            font-weight: 700;
            letter-spacing: 0.03em;
            margin-bottom: 18px;
        }

        .hero h1 {
            font-size: clamp(2.8rem, 5vw, 5.2rem);
            line-height: 0.98;
            letter-spacing: -0.05em;
            margin-bottom: 18px;
        }

        .hero p {
            max-width: 62ch;
            color: var(--muted);
            font-size: 1.04rem;
            line-height: 1.8;
        }

        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 14px;
            margin-top: 28px;
        }

        .button {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            min-height: 50px;
            padding: 0 20px;
            border-radius: 999px;
            border: 1px solid transparent;
            font-weight: 800;
            transition: transform 0.25s ease, border-color 0.25s ease, background 0.25s ease;
        }

        .button:hover {
            transform: translateY(-2px);
        }

        .button.primary {
            color: #07111d;
            background: linear-gradient(135deg, #9ee9ff, #8fa2ff);
        }

        .button.secondary {
            color: var(--text);
            border-color: rgba(167, 190, 255, 0.18);
            background: rgba(255, 255, 255, 0.03);
        }

        .status-strip {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            margin-top: 28px;
        }

        .status {
            padding: 16px 18px;
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(167, 190, 255, 0.12);
        }

        .status strong {
            display: block;
            font-size: 1.15rem;
            margin-bottom: 6px;
        }

        .status span {
            color: var(--muted);
            font-size: 0.95rem;
        }

        .panel {
            position: relative;
            padding: 22px;
            border-radius: calc(var(--radius) + 8px);
            background: linear-gradient(180deg, rgba(16, 27, 47, 0.94), rgba(10, 17, 30, 0.92));
            border: 1px solid rgba(167, 190, 255, 0.14);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .panel::before {
            content: "";
            position: absolute;
            inset: -40% auto auto -10%;
            width: 280px;
            height: 280px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(124, 219, 255, 0.2), transparent 68%);
            pointer-events: none;
        }

        .contact-grid {
            max-width: 1240px;
            margin: 0 auto;
            padding: 20px 24px 54px;
            display: grid;
            grid-template-columns: 0.92fr 1.08fr;
            gap: 28px;
        }

        .info-stack {
            display: grid;
            gap: 16px;
        }

        .info-card {
            padding: 22px;
            border-radius: var(--radius);
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(167, 190, 255, 0.12);
            backdrop-filter: blur(14px);
            box-shadow: 0 20px 50px rgba(2, 7, 18, 0.24);
            transition: transform 0.3s ease, border-color 0.3s ease, background 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
            border-color: rgba(124, 219, 255, 0.24);
            background: rgba(255, 255, 255, 0.07);
        }

        .info-card h3 {
            font-size: 1.15rem;
            margin-bottom: 10px;
        }

        .info-card p,
        .info-card a,
        .info-card span {
            color: var(--muted);
            line-height: 1.7;
        }

        .info-card strong {
            display: block;
            color: var(--text);
            font-size: 1.02rem;
            margin-top: 8px;
            word-break: break-word;
        }

        .info-icon {
            width: 48px;
            height: 48px;
            border-radius: 16px;
            display: grid;
            place-items: center;
            margin-bottom: 14px;
            font-size: 1.15rem;
            color: #07111d;
            background: linear-gradient(135deg, #9ee9ff, #8fa2ff);
        }

        .form-shell {
            padding: 28px;
            border-radius: calc(var(--radius) + 6px);
            background: linear-gradient(180deg, rgba(255, 255, 255, 0.07), rgba(255, 255, 255, 0.04));
            border: 1px solid rgba(167, 190, 255, 0.16);
            box-shadow: var(--shadow);
        }

        .form-top {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            gap: 18px;
            margin-bottom: 22px;
        }

        .form-top h2 {
            font-size: clamp(1.8rem, 2.3vw, 2.5rem);
            line-height: 1.05;
        }

        .form-top p {
            color: var(--muted);
            max-width: 38ch;
            line-height: 1.6;
        }

        form {
            display: grid;
            gap: 16px;
        }

        .field-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }

        .field {
            display: grid;
            gap: 9px;
        }

        label {
            font-weight: 700;
            color: #dfe8fa;
        }

        input,
        select,
        textarea {
            width: 100%;
            border: 1px solid rgba(167, 190, 255, 0.16);
            border-radius: 18px;
            background: rgba(6, 11, 21, 0.45);
            color: var(--text);
            padding: 14px 16px;
            font: inherit;
            outline: none;
            transition: border-color 0.25s ease, box-shadow 0.25s ease, transform 0.25s ease;
        }

        input::placeholder,
        textarea::placeholder {
            color: rgba(183, 197, 222, 0.7);
        }

        input:focus,
        select:focus,
        textarea:focus {
            border-color: rgba(124, 219, 255, 0.6);
            box-shadow: 0 0 0 4px rgba(124, 219, 255, 0.11);
            transform: translateY(-1px);
        }

        textarea {
            min-height: 160px;
            resize: vertical;
        }

        .form-footer {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 4px;
        }

        .status-note {
            color: var(--muted);
            font-size: 0.95rem;
        }

        .notice {
            display: none;
            margin-bottom: 18px;
            padding: 14px 16px;
            border-radius: 18px;
            border: 1px solid transparent;
            font-weight: 700;
        }

        .notice.show {
            display: block;
        }

        .notice.error {
            background: rgba(255, 143, 171, 0.12);
            border-color: rgba(255, 143, 171, 0.18);
            color: #ffd8e2;
        }

        .notice.success {
            background: rgba(124, 240, 192, 0.12);
            border-color: rgba(124, 240, 192, 0.18);
            color: #dbffef;
        }

        .submit {
            border: 0;
            cursor: pointer;
        }

        .toast {
            position: fixed;
            left: 50%;
            bottom: 28px;
            transform: translateX(-50%) translateY(140%);
            padding: 14px 18px;
            border-radius: 999px;
            background: rgba(11, 20, 35, 0.92);
            border: 1px solid rgba(124, 219, 255, 0.18);
            color: var(--text);
            box-shadow: var(--shadow);
            opacity: 0;
            transition: transform 0.35s ease, opacity 0.35s ease;
            z-index: 40;
            pointer-events: none;
        }

        .toast.show {
            transform: translateX(-50%) translateY(0);
            opacity: 1;
        }

        .reveal {
            opacity: 0;
            transform: translateY(18px);
            transition: opacity 0.8s ease, transform 0.8s ease;
        }

        .reveal.in-view {
            opacity: 1;
            transform: translateY(0);
        }

        .floating-badge {
            position: absolute;
            top: 18px;
            right: 18px;
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(124, 240, 192, 0.12);
            border: 1px solid rgba(124, 240, 192, 0.2);
            color: #dffdf3;
            font-size: 0.92rem;
            font-weight: 700;
        }

        .hours {
            display: grid;
            gap: 10px;
            margin-top: 10px;
        }

        .hours-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
            color: var(--muted);
            padding: 10px 0;
            border-bottom: 1px solid rgba(167, 190, 255, 0.1);
        }

        .hours-row strong {
            color: var(--text);
        }

        .mini-links {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 12px;
        }

        .mini-link {
            padding: 10px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.04);
            border: 1px solid rgba(167, 190, 255, 0.12);
            color: var(--muted);
            font-weight: 700;
            transition: transform 0.25s ease, background 0.25s ease, color 0.25s ease;
        }

        .mini-link:hover {
            transform: translateY(-2px);
            background: rgba(124, 219, 255, 0.12);
            color: var(--text);
        }

        .spark {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--accent);
            box-shadow: 0 0 0 8px rgba(124, 240, 192, 0.12);
            animation: pulse 2.1s ease-in-out infinite;
        }

        @keyframes drift {
            50% {
                transform: translate3d(16px, 14px, 0) scale(1.06);
            }
        }

        @keyframes pulse {
            50% {
                transform: scale(0.85);
                box-shadow: 0 0 0 12px rgba(124, 240, 192, 0.05);
            }
        }

        @media (max-width: 1060px) {
            .hero,
            .contact-grid {
                grid-template-columns: 1fr;
            }

            .form-top,
            .topbar-inner {
                flex-direction: column;
                align-items: flex-start;
            }

            .nav {
                justify-content: flex-start;
            }
        }

        @media (max-width: 720px) {
            .topbar-inner,
            .hero,
            .contact-grid {
                padding-left: 18px;
                padding-right: 18px;
            }

            .hero {
                padding-top: 28px;
            }

            .status-strip,
            .field-grid {
                grid-template-columns: 1fr;
            }

            .panel,
            .form-shell,
            .info-card {
                border-radius: 22px;
            }

            .hero-actions {
                width: 100%;
            }

            .button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="page">
    <header class="topbar">
        <div class="topbar-inner">
            <a class="brand" href="index.html">
                <span class="brand-mark">P</span>
                <span>PMS+</span>
            </a>
            <nav class="nav">
                <a href="index.html">Home</a>
                <a href="contact.jsp" class="active">Contact</a>
                <a href="#message">Message</a>
            </nav>
            <a class="cta" href="#message">Book a Call</a>
        </div>
    </header>

    <main>
        <section class="hero">
            <div class="reveal">
                <div class="eyebrow"><span class="spark"></span><span>We reply within one business day</span></div>
                <h1>Contact the team behind your patient workflow.</h1>
                <p>
                    Reach out for support, onboarding, integrations, or a product walkthrough.
                    PMS+ keeps patient operations organized, fast, and easy to scale.
                </p>
                <div class="hero-actions">
                    <a class="button primary" href="mailto:abhisheksamadhiya@gmail.com">Email support</a>
                    <a class="button secondary" href="tel:+911234567890">Call now</a>
                </div>
                <div class="status-strip">
                    <div class="status">
                        <strong>Fast response</strong>
                        <span>Average reply time under 24 hours</span>
                    </div>
                    <div class="status">
                        <strong>Secure handling</strong>
                        <span>Protected communication for patient-related queries</span>
                    </div>
                    <div class="status">
                        <strong>Live support</strong>
                        <span id="localTime">Checking local time</span>
                    </div>
                </div>
            </div>

            <div class="panel reveal">
                <div class="floating-badge">Online support available</div>
                <div class="info-stack">
                    <div class="info-card">
                        <div class="info-icon">Email</div>
                        <h3>Email</h3>
                        <p>Send detailed requests, documents, or feature questions.</p>
                        <strong><a href="mailto:abhisheksamadhiya@gmail.com">abhisheksamadhiya@gmail.com</a></strong>
                        <div class="mini-links">
                            <a class="mini-link" href="#" data-copy="abhisheksamadhiya@gmail.com">Copy email</a>
                        </div>
                    </div>
                    <div class="info-card">
                        <div class="info-icon">Call</div>
                        <h3>Phone</h3>
                        <p>Use this for urgent coordination or quick product guidance.</p>
                        <strong><a href="tel:+911234567890">+91 1234567890</a></strong>
                        <div class="mini-links">
                            <a class="mini-link" href="tel:+911234567890">Start call</a>
                        </div>
                    </div>
                    <div class="info-card">
                        <div class="info-icon">Visit</div>
                        <h3>Visit</h3>
                        <p>Schedule a meeting before visiting the office.</p>
                        <strong>123 Main Street, City, Country</strong>
                        <div class="hours">
                            <div class="hours-row"><strong>Mon - Fri</strong><span>9:00 AM - 6:00 PM</span></div>
                            <div class="hours-row"><strong>Saturday</strong><span>10:00 AM - 2:00 PM</span></div>
                            <div class="hours-row"><strong>Sunday</strong><span>Closed</span></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section class="contact-grid">
            <div class="info-stack">
                <div class="info-card reveal">
                    <div class="info-icon">Help</div>
                    <h3>What we can help with</h3>
                    <p>
                        Setup assistance, workflow customization, appointment handling, patient records,
                        and admin access troubleshooting.
                    </p>
                </div>
                <div class="info-card reveal">
                    <div class="info-icon">Quick</div>
                    <h3>Need a quick answer?</h3>
                    <p>
                        Use the form to send a direct message. You will see an immediate confirmation after submit.
                    </p>
                </div>
            </div>

            <div class="form-shell reveal" id="message">
                <div class="form-top">
                    <div>
                        <h2>Send a message</h2>
                        <p>Tell us what you need and we'll route it to the right person.</p>
                    </div>
                    <div class="status-note" id="formHint">All fields are required.</div>
                </div>

                <div class="notice" id="notice"></div>

                <form action="saveContact.jsp" method="post" id="contactForm">
                    <div class="field-grid">
                        <div class="field">
                            <label for="name">Full name</label>
                            <input id="name" name="name" type="text" placeholder="Your name" required>
                        </div>
                        <div class="field">
                            <label for="email">Email address</label>
                            <input id="email" name="email" type="email" placeholder="you@example.com" required>
                        </div>
                    </div>
                    <div class="field-grid">
                        <div class="field">
                            <label for="topic">Topic</label>
                            <select id="topic" name="topic" required>
                                <option value="">Select a topic</option>
                                <option>General inquiry</option>
                                <option>Technical support</option>
                                <option>Billing</option>
                                <option>Product demo</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="priority">Priority</label>
                            <select id="priority" name="priority" required>
                                <option value="">Select priority</option>
                                <option>Low</option>
                                <option>Normal</option>
                                <option>Urgent</option>
                            </select>
                        </div>
                    </div>
                    <div class="field">
                        <label for="messageBox">Message</label>
                        <textarea id="messageBox" name="messageBox" placeholder="Write your message here..." required></textarea>
                    </div>
                    <div class="form-footer">
                        <span class="status-note" id="liveCount">0 characters typed</span>
                        <button class="button primary submit" type="submit">Send message</button>
                    </div>
                </form>
            </div>
        </section>
    </main>
</div>

<div class="toast" id="toast" aria-live="polite"></div>

<script>
    const toast = document.getElementById('toast');
    const form = document.getElementById('contactForm');
    const messageBox = document.getElementById('messageBox');
    const liveCount = document.getElementById('liveCount');
    const localTime = document.getElementById('localTime');
    const notice = document.getElementById('notice');
    const params = new URLSearchParams(window.location.search);

    const showToast = (text) => {
        toast.textContent = text;
        toast.classList.add('show');
        clearTimeout(showToast.timer);
        showToast.timer = setTimeout(() => toast.classList.remove('show'), 2400);
    };

    document.querySelectorAll('[data-copy]').forEach((item) => {
        item.addEventListener('click', async (event) => {
            event.preventDefault();
            const value = event.currentTarget.getAttribute('data-copy');
            try {
                await navigator.clipboard.writeText(value);
                showToast('Email copied to clipboard');
            } catch (error) {
                showToast('Copy failed. Use the email link instead.');
            }
        });
    });

    messageBox.addEventListener('input', () => {
        liveCount.textContent = `${messageBox.value.length} characters typed`;
    });

    if (params.get('status') === 'failed') {
        notice.textContent = 'Message could not be saved. Please try again.';
        notice.className = 'notice show error';
    } else if (params.get('status') === 'error') {
        notice.textContent = 'Something went wrong while saving your message.';
        notice.className = 'notice show error';
    } else if (params.get('status') === 'success') {
        notice.textContent = 'Message sent successfully.';
        notice.className = 'notice show success';
    }

    const updateTime = () => {
        const time = new Intl.DateTimeFormat('en-IN', {
            hour: 'numeric',
            minute: '2-digit',
            second: '2-digit',
            hour12: true,
            timeZone: 'Asia/Kolkata'
        }).format(new Date());
        localTime.textContent = `India time: ${time}`;
    };

    updateTime();
    setInterval(updateTime, 1000);

    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
            if (entry.isIntersecting) {
                entry.target.classList.add('in-view');
                revealObserver.unobserve(entry.target);
            }
        });
    }, { threshold: 0.18 });

    document.querySelectorAll('.reveal').forEach((element) => revealObserver.observe(element));
</script>
</body>
</html>
