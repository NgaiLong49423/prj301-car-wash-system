import os
import re
import sys
import glob

SRS_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Document\SRS.md"
OUTPUT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues-grouped"
INDEX_PATH = os.path.join(OUTPUT_DIR, "GROUPED_ISSUE_INDEX.md")

os.makedirs(OUTPUT_DIR, exist_ok=True)

# 1. Cleanup old files in the grouped directory
for f in glob.glob(os.path.join(OUTPUT_DIR, "*.md")):
    os.remove(f)

# Group Definitions
GROUPS = [
    {
        "id": "GI-01",
        "slug": "auth-registration-access-control",
        "title": "Auth, Registration and Access Control",
        "fr_codes": ["FR-AS-01", "FR-AS-02", "FR-AS-27"],
        "old_issue": "Mới",
        "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend",
        "size": "M",
        "points": 5,
        "deps": "None"
    },
    {
        "id": "GI-02",
        "slug": "customer-dashboard-loyalty-history",
        "title": "Customer Dashboard, Loyalty Overview and History",
        "fr_codes": ["FR-AS-03", "FR-AS-04", "FR-AS-05", "FR-AS-06", "FR-AS-13"],
        "old_issue": "Mới",
        "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 👤 Customer",
        "size": "L",
        "points": 8,
        "deps": "GI-01"
    },
    {
        "id": "GI-03",
        "slug": "booking-completion-loyalty-award",
        "title": "Booking Completion Loyalty Award",
        "fr_codes": ["FR-AS-07", "FR-AS-08", "FR-AS-09", "FR-AS-10", "FR-AS-28"],
        "old_issue": "#41",
        "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database",
        "size": "L",
        "points": 13,
        "deps": "GI-01"
    },
    {
        "id": "GI-04",
        "slug": "tier-review-active-12-month-loyalty",
        "title": "Tier Review and Active 12-Month Loyalty Data",
        "fr_codes": ["FR-AS-11"],
        "old_issue": "#42, #58",
        "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing",
        "size": "M",
        "points": 5,
        "deps": "GI-03"
    },
    {
        "id": "GI-05",
        "slug": "point-batch-expiry-active-refresh",
        "title": "Point Batch Expiry and Active Points Refresh",
        "fr_codes": ["FR-AS-12"],
        "old_issue": "#44",
        "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing",
        "size": "M",
        "points": 5,
        "deps": "GI-03",
        "tech_notes": "IMPORTANT: Do NOT require Quartz, Spring Task, SQL Agent Job, or a nightly scheduler. In this PRJ301 Servlet/JSP scope, expiry should be event-based: refresh when Customer opens loyalty dashboard, before redeeming reward, when booking completed earns points, and when Admin reports need active data."
    },
    {
        "id": "GI-06",
        "slug": "reward-redemption-into-voucher",
        "title": "Reward Redemption into Voucher",
        "fr_codes": ["FR-AS-14"],
        "old_issue": "#43",
        "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 👤 Customer",
        "size": "M",
        "points": 5,
        "deps": "GI-04, GI-05"
    },
    {
        "id": "GI-07",
        "slug": "apply-voucher-to-booking-lifecycle",
        "title": "Apply Voucher to Booking and Voucher Lifecycle",
        "fr_codes": ["FR-AS-15", "FR-AS-16"],
        "old_issue": "Mới",
        "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 🧪 Testing",
        "size": "M",
        "points": 8,
        "deps": "GI-06"
    },
    {
        "id": "GI-08",
        "slug": "admin-ui-shell-dashboard",
        "title": "Admin UI Shell and Dashboard",
        "fr_codes": ["FR-AS-17", "FR-AS-26"],
        "old_issue": "Mới",
        "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend",
        "size": "M",
        "points": 5,
        "deps": "GI-01"
    },
    {
        "id": "GI-09",
        "slug": "admin-loyalty-configuration",
        "title": "Admin Loyalty Configuration Controls",
        "fr_codes": ["FR-AS-18", "FR-AS-19", "FR-AS-20"],
        "old_issue": "#45",
        "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database",
        "size": "L",
        "points": 8,
        "deps": "GI-08"
    },
    {
        "id": "GI-10",
        "slug": "promotion-management-inbox",
        "title": "Promotion Management and Customer Promotion Inbox",
        "fr_codes": ["FR-AS-21", "FR-AS-23"],
        "old_issue": "#46",
        "labels": "✨ Feature, 👑 Admin, 👤 Customer, 🎨 Frontend, ⚙️ Backend, 🗄️ Database",
        "size": "M",
        "points": 8,
        "deps": "GI-08"
    },
    {
        "id": "GI-11",
        "slug": "admin-reports-dashboard",
        "title": "Admin Reports Dashboard",
        "fr_codes": ["FR-AS-22"],
        "old_issue": "#47, #48",
        "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database",
        "size": "M",
        "points": 8,
        "deps": "GI-03, GI-08"
    },
    {
        "id": "GI-12",
        "slug": "assessment-seed-demo-cleanup",
        "title": "Assessment Seed Data, Demo Flow and Scope Cleanup",
        "fr_codes": ["FR-AS-24", "FR-AS-25", "FR-AS-29", "FR-AS-30"],
        "old_issue": "Mới",
        "labels": "📚 Documentation, 🧪 Testing, ⚙️ Backend, 🗄️ Database",
        "size": "M",
        "points": 5,
        "deps": "GI-01 -> GI-11",
        "tech_notes": "Note: FR-AS-29 Database-driven display values should be treated as a cross-cutting checklist applied to all issues, not only as a standalone feature. FR-AS-30 should be treated as cleanup/scope control."
    }
]

def extract_section(text, start_markers, end_markers):
    start_idx = -1
    for m in start_markers:
        idx = text.find(m)
        if idx != -1:
            start_idx = idx + len(m)
            break
    if start_idx == -1: return ""
    end_idx = len(text)
    for m in end_markers:
        idx = text.find(m, start_idx)
        if idx != -1 and idx < end_idx:
            end_idx = idx
    return text[start_idx:end_idx].strip()

def parse_srs():
    with open(SRS_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    section_5_match = re.search(r"## 5\. Yêu cầu chức năng(.*?)## 6\.", content, re.DOTALL)
    if not section_5_match:
        print("ERROR: Could not find Section 5 in SRS.md.")
        sys.exit(1)

    section_5_content = section_5_match.group(1)
    fr_pattern = re.compile(r"### 5\.\d+ (FR-AS-\d+) — (.*?)\n(.*?)(?=\n### 5\.\d+ FR-AS|\Z)", re.DOTALL)
    matches = fr_pattern.findall(section_5_content)
    
    fr_data = {}
    for fr_code, fr_title, fr_body in matches:
        fr_data[fr_code.strip()] = {
            "title": fr_title.strip(),
            "body": fr_body.strip()
        }

    for gi in GROUPS:
        gi_goals = []
        gi_scopes = []
        gi_acs = []
        
        for fr_code in gi["fr_codes"]:
            if fr_code not in fr_data:
                continue
                
            body = fr_data[fr_code]["body"]
            title = fr_data[fr_code]["title"]
            
            mo_ta = extract_section(body, ["**Mô tả:**"], ["**Lý do cần có:**", "**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Kết quả mong đợi:**"])
            ly_do = extract_section(body, ["**Lý do cần có:**"], ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
            luong_xu_ly = extract_section(body, ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**"], ["**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
            dieu_kien = extract_section(body, ["**Điều kiện/ràng buộc:**"], ["**Kết quả mong đợi:**"])
            ket_qua = extract_section(body, ["**Kết quả mong đợi:**"], [])
            
            goal = f"**{fr_code} ({title}):**\n{mo_ta}\n{ly_do}".strip()
            if len(goal) > 20: gi_goals.append(goal)
            
            scope = f"**{fr_code}:**\n{luong_xu_ly}".strip()
            if len(scope) > 20: gi_scopes.append(scope)
            
            ac = f"**{fr_code}:**\n{dieu_kien}\n{ket_qua}".strip()
            if len(ac) > 20: gi_acs.append(ac)
            
        final_goal = "\n\n".join(gi_goals) if gi_goals else "TBD"
        final_scope = "\n\n".join(gi_scopes) if gi_scopes else "TBD"
        final_ac = "\n\n".join(gi_acs) if gi_acs else "TBD"
        
        out_of_scope = "Các chức năng không nằm trong danh sách FR-AS trên."
        tech_notes = gi.get("tech_notes", "Tuân thủ thiết kế DB và các Rule từ Document/SRS.md.")
        files_affected = "TBD - Cần xác định cụ thể trong lúc implementation."
        
        draft_content = f"""# {gi['id']} — {gi['title']}

## Goal
{final_goal}

## Scope
{final_scope}

## Out of Scope
{out_of_scope}

## Acceptance Criteria
{final_ac}

## Technical Notes
{tech_notes}

## Suggested files likely affected
{files_affected}

## FR Traceability
Các functional requirements được gộp trong issue này:
- {', '.join(gi['fr_codes'])}

## Old GitHub issue mapping if any
{gi['old_issue']}

## Suggested labels
{gi['labels']}

## Size / Story Points
- **Size:** {gi['size']}
- **Story Points:** {gi['points']}

## Dependencies
{gi['deps']}

## Demo verification steps
1. Setup môi trường và test account.
2. Thực hiện các luồng công việc theo Acceptance Criteria.
3. Đảm bảo UI/UX mượt mà, Database ghi nhận log chính xác.
"""
        filename = f"{gi['id']}-{gi['slug']}.md"
        with open(os.path.join(OUTPUT_DIR, filename), "w", encoding="utf-8") as out_f:
            out_f.write(draft_content)

    # Generate Index
    index_content = "# Mục lục Grouped Issues Đề xuất\n\n"
    index_content += "| Group ID | Title | File Draft | FR-AS Cover | Issue Cũ | Labels | Size / SP |\n"
    index_content += "|---|---|---|---|---|---|---|\n"
    
    for gi in GROUPS:
        frs = ", ".join(gi["fr_codes"])
        index_content += f"| {gi['id']} | {gi['title']} | `{gi['id']}-{gi['slug']}.md` | {frs} | {gi['old_issue']} | {gi['labels']} | {gi['size']}/{gi['points']} |\n"
        
    with open(INDEX_PATH, "w", encoding="utf-8") as idx_f:
        idx_f.write(index_content)
        
    print(f"SUCCESS: Generated {len(GROUPS)} grouped issues.")

if __name__ == "__main__":
    parse_srs()
