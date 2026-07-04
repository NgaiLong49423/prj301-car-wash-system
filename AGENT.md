# AutoWash Pro - Project Context & Agent Rules

## 1. Project Overview
- **Name:** AutoWash Pro (Smart Automated Car Wash Management System)
- **Course Code:** PRJ301
- **Tech Stack:** Java Web (Servlet/JSP), SQL Server (JDBC), HTML/CSS/JS.
- **Key Features:** Advance Booking, Loyalty Program (Tier System: Member, Silver, Gold, Platinum), Admin Controls, AI Personalization, LPR (License Plate Recognition).
- **Core Entities:** `Customer`, `Vehicle`, `Booking`, `LoyaltyAccount`, `Promotion`, `Transaction`.

## 2. Architecture & File Structure
- `AutoWashPro-Website/`: Main Java Web Application folder.
  - `src/java/`: Java source code (`dao/`, `dto/`, `controller/` servlets).
  - `web/`: JSP views (`booking-history.jsp`, `booking-result.jsp`, etc.), CSS, JS.
- `Database/`: SQL scripts (`schema.sql`, `sample-data.sql`).
- `Document/`: Documentation files, mainly `SRS.md` (Software Requirements Specification) which acts as the ultimate source of truth for business logic.
- `.agent/`: Custom configurations, generated reports, and scripts for the agent assistant.

## 3. General Development Rules
1. **Source of Truth:** Always refer to `Document/SRS.md` for business rules before implementing backend logic. Do not deviate from the SRS unless explicitly requested by the user.
2. **Database Constraints:** Respect `CHECK` constraints defined in `schema.sql` (e.g., booking statuses are strictly `PENDING`, `CONFIRMED`, `COMPLETED`, `CANCELLED`).
3. **Loyalty Logic:** Points accumulation must be based on `final_amount` and only triggered when a booking transitions to `COMPLETED` state.
4. **Issue Tracking:** Development tasks should align with open GitHub issues (documented in `.agent/outputs/reports/assignment-open-issues-report.md`).
5. **Code Style (Java):** Use consistent naming conventions, standard JDBC patterns (try-with-resources), and encapsulate data access logic in DAOs.
6. **Code Style (Frontend):** Focus on clean, modern, and aesthetic UI using Vanilla CSS and HTML5 unless a framework is introduced. Use intuitive micro-animations for interactions.

## 4. Agent Operational Guidelines
- **No Implicit Destructive Actions:** Do not drop databases, delete crucial files, or wipe configurations without explicit user consent.
- **Specific Tools First:** Always use standard APIs (like `view_file`, `list_dir`) before falling back to shell scripts.
- **Log Management:** Store any generated reports, drafts, or backups into the corresponding subdirectories inside `.agent/outputs/`.
