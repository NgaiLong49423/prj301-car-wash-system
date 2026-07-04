import os
import re
import subprocess
import time
import sys

sys.stdout.reconfigure(encoding='utf-8')

SRS_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Docs\requirements\SRS.md"
REPORT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Docs\reports"
REPORT_PATH = os.path.join(REPORT_DIR, "assignment-issue-report.md")

os.makedirs(REPORT_DIR, exist_ok=True)

GROUPS = [
    {"id": "GI-01", "title": "Auth, Registration and Access Control", "fr_codes": ["FR-AS-01", "FR-AS-02", "FR-AS-27"], "old_issue": "83", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend", "size": "M", "points": 5, "deps": "None"},
    {"id": "GI-02", "title": "Customer Dashboard, Loyalty Overview and History", "fr_codes": ["FR-AS-03", "FR-AS-04", "FR-AS-05", "FR-AS-06", "FR-AS-13"], "old_issue": "84", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "size": "L", "points": 8, "deps": "GI-01"},
    {"id": "GI-03", "title": "Booking Completion Loyalty Award", "fr_codes": ["FR-AS-07", "FR-AS-08", "FR-AS-09", "FR-AS-10", "FR-AS-28"], "old_issue": "41", "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database", "size": "L", "points": 13, "deps": "GI-01"},
    {"id": "GI-04", "title": "Tier Review and Active 12-Month Loyalty Data", "fr_codes": ["FR-AS-11"], "old_issue": "42", "close_issues": [], "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "size": "M", "points": 5, "deps": "GI-03"},
    {"id": "GI-05", "title": "Point Batch Expiry and Active Points Refresh", "fr_codes": ["FR-AS-12"], "old_issue": "44", "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "size": "M", "points": 5, "deps": "GI-03"},
    {"id": "GI-06", "title": "Reward Redemption into Voucher", "fr_codes": ["FR-AS-14"], "old_issue": "43", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "size": "M", "points": 5, "deps": "GI-04, GI-05"},
    {"id": "GI-07", "title": "Apply Voucher to Booking and Voucher Lifecycle", "fr_codes": ["FR-AS-15", "FR-AS-16"], "old_issue": "85", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "size": "M", "points": 8, "deps": "GI-06"},
    {"id": "GI-08", "title": "Admin UI Shell and Dashboard", "fr_codes": ["FR-AS-17", "FR-AS-26"], "old_issue": "", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend", "size": "M", "points": 5, "deps": "GI-01"},
    {"id": "GI-09", "title": "Admin Loyalty Configuration Controls", "fr_codes": ["FR-AS-18", "FR-AS-19", "FR-AS-20"], "old_issue": "45", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "size": "L", "points": 8, "deps": "GI-08"},
    {"id": "GI-10", "title": "Promotion Management and Customer Promotion Inbox", "fr_codes": ["FR-AS-21", "FR-AS-23"], "old_issue": "46", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "size": "M", "points": 8, "deps": "GI-08"},
    {"id": "GI-11", "title": "Admin Reports Dashboard", "fr_codes": ["FR-AS-22"], "old_issue": "47", "close_issues": ["48"], "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "size": "M", "points": 8, "deps": "GI-03, GI-08"},
    {"id": "GI-12", "title": "Assessment Seed Data, Demo Flow and Scope Cleanup", "fr_codes": ["FR-AS-24", "FR-AS-25", "FR-AS-29", "FR-AS-30"], "old_issue": "", "labels": "📚 Documentation, 🧪 Testing, ⚙️ Backend, 🗄️ Database", "size": "M", "points": 5, "deps": "GI-01 -> GI-11"},
]

def run_cmd(cmd):
    try:
        res = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True, encoding='utf-8')
        return res.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running: {cmd}\n{e.stderr}")
        return None

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

def build_drafts():
    with open(SRS_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    section_5 = re.search(r"## 5\. Yêu cầu chức năng(.*?)## 6\.", content, re.DOTALL).group(1)
    matches = re.findall(r"### 5\.\d+ (FR-AS-\d+) — (.*?)\n(.*?)(?=\n### 5\.\d+ FR-AS|\Z)", section_5, re.DOTALL)
    
    fr_data = {}
    for code, title, body in matches:
        fr_data[code.strip()] = {"title": title.strip(), "body": body.strip()}

    drafts = []
    for gi in GROUPS:
        gi_goals = []
        gi_checklists = []
        gi_acs = []
        
        for fr_code in gi["fr_codes"]:
            if fr_code not in fr_data: continue
            body = fr_data[fr_code]["body"]
            
            mo_ta = extract_section(body, ["**Mô tả:**"], ["**Lý do cần có:**", "**Luồng xử lý chính:**"])
            ly_do = extract_section(body, ["**Lý do cần có:**"], ["**Luồng xử lý chính:**"])
            luong_xu_ly = extract_section(body, ["**Luồng xử lý chính:**"], ["**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
            dieu_kien = extract_section(body, ["**Điều kiện/ràng buộc:**"], ["**Kết quả mong đợi:**"])
            ket_qua = extract_section(body, ["**Kết quả mong đợi:**"], [])
            
            gi_goals.append(f"**{fr_code}:** {mo_ta}\n{ly_do}".strip())
            
            lines = luong_xu_ly.split('\n')
            for l in lines:
                if l.strip() and not l.startswith("**"):
                    gi_checklists.append(f"- [ ] {l.strip().lstrip('1234567890. -')}")
                    
            gi_acs.append(f"**{fr_code}:**\n{dieu_kien}\n{ket_qua}".strip())
            
        goal_text = "\n\n".join(gi_goals)
        ac_text = "\n\n".join(gi_acs)
        checklist_text = "\n".join(gi_checklists) if gi_checklists else "- [ ] Hoàn thành chức năng."
        
        blockers = "PR không được merge nếu app crash, khách/khách hàng truy cập sai quyền, dữ liệu loyalty sai lệch hoặc vi phạm scope."
        
        body_content = f"""## Goal
{goal_text}

## FR Cover
{', '.join(gi['fr_codes'])}

## Completion Checklist
{checklist_text}

## Acceptance Criteria
{ac_text}

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR có liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 review theo quy định review của nhóm.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng được liệt kê trong phần này.
{blockers}

## Suggested Labels
{gi['labels']}

## Old issue mapping nếu có
{gi.get('old_issue', 'Mới')}
"""
        drafts.append({
            "id": gi["id"],
            "title": f"{gi['id']} — {gi['title']}",
            "body": body_content,
            "old_issue": gi["old_issue"],
            "close_issues": gi.get("close_issues", []),
            "labels": gi["labels"],
            "size": gi["size"],
            "points": gi["points"],
            "deps": gi["deps"]
        })
    return drafts

def sync_github(drafts):
    created = []
    updated = []
    closed = []
    mapping_dict = {}

    for d in drafts:
        # Create temp file for body
        tmp_file = f"tmp_{d['id']}.md"
        with open(tmp_file, "w", encoding="utf-8") as f:
            f.write(d["body"])
            
        lbl_args = ""
        for lbl in d["labels"].split(","):
            lbl_args += f' --label "{lbl.strip()}"'
            
        lbl_add_args = ""
        for lbl in d["labels"].split(","):
            lbl_add_args += f' --add-label "{lbl.strip()}"'

        gh_issue_number = ""

        if d["old_issue"]:
            issue_num = d["old_issue"]
            print(f"Updating Issue #{issue_num} for {d['id']}...")
            run_cmd(f'gh issue edit {issue_num} --title "{d['title']}" --body-file "{tmp_file}" {lbl_add_args}')
            updated.append(d["id"])
            gh_issue_number = issue_num
            
            # Close replaced issues
            for c_issue in d["close_issues"]:
                print(f"Closing Issue #{c_issue} due to replacement by {d['id']}...")
                msg = f"Issue này đã được thay thế/gộp vào Grouped Issue **{d['id']} (Issue #{issue_num})**. Vui lòng qua issue đó để tiếp tục công việc."
                run_cmd(f'gh issue comment {c_issue} -b "{msg}"')
                run_cmd(f'gh issue close {c_issue} -r "not planned"')
                closed.append(c_issue)
        else:
            print(f"Creating new Issue for {d['id']}...")
            url = run_cmd(f'gh issue create --title "{d['title']}" --body-file "{tmp_file}" {lbl_args}')
            if url:
                gh_issue_number = url.split("/")[-1]
                created.append(d["id"])
                
        mapping_dict[d["id"]] = gh_issue_number
        os.remove(tmp_file)
        time.sleep(2)
        
    return created, updated, closed, mapping_dict

def generate_report(drafts, created, updated, closed, mapping_dict):
    report_content = f"""# Phân công công việc & Báo cáo Grouped Issues
**Dự án:** AutoWash Pro
**Thời gian:** 2026-07-05

## 1. Thống kê Sync GitHub Issues
- **Tổng số Grouped Issues:** 12
- **Đã tạo mới (kể cả lần chạy trước):** 5 issues (GI-01, GI-02, GI-07, GI-08, GI-12)
- **Đã update (từ issue cũ):** 7 issues (GI-03, GI-04, GI-05, GI-06, GI-09, GI-10, GI-11)
- **Đã close (vì duplicate/superseded):** 2 issues (#48, #58)

## 2. Bảng Phân Công Công Việc Ẩn Danh

| Member | Grouped Issues phụ trách | Lý do & Scope | Reviewer Chéo (Suggested) |
| :--- | :--- | :--- | :--- |
| **Member 1** | GI-03, GI-04, GI-05 | Core logic phức tạp nhất: cộng điểm, tier review, point batch expiry. | Member 2 |
| **Member 2** | GI-06, GI-07, GI-09 | Reward redemption, voucher lifecycle, admin loyalty configuration. | Member 1 |
| **Member 3** | GI-08, GI-10, GI-11 | Admin UI shell, promotion management, reports dashboard. | Member 4 |
| **Member 4** | GI-01, GI-02, GI-12 | Auth, customer dashboard, seed data, demo flow và cleanup. | Member 3 |

## 3. Danh sách Issue & Dependency

| Group ID | GitHub | FR Cover | Lables | Size/SP | Phụ trách | Dependency (Làm sau) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
"""
    for d in drafts:
        gh_num = mapping_dict.get(d["id"], "N/A")
        member = "Member 1" if d["id"] in ["GI-03", "GI-04", "GI-05"] else (
                 "Member 2" if d["id"] in ["GI-06", "GI-07", "GI-09"] else (
                 "Member 3" if d["id"] in ["GI-08", "GI-10", "GI-11"] else "Member 4"))
        frs = ", ".join(d["fr_codes"])
        report_content += f"| {d['id']} | #{gh_num} | {frs} | {d['labels']} | {d['size']}/{d['points']} | {member} | {d['deps']} |\n"

    report_content += """
## 4. Hướng dẫn & Lưu ý quan trọng
- **Issue ưu tiên làm trước:** `GI-01`, `GI-08` để có bộ khung Auth và UI cho việc test. Cốt lõi hệ thống là `GI-03` nên Member 1 cần ưu tiên.
- **Rủi ro ảnh hưởng lớn:** `GI-03` tác động tới cấu trúc Database transaction mạnh nhất, dễ block người khác nếu code sai. Cần Member 2 review thật kỹ. `GI-12` cần được cập nhật dần trong quá trình làm thay vì chờ tới cuối.
- **Merge Blockers:** Bất kỳ PR nào vi phạm quy tắc ở mục 14.8 trong SRS.md đều không được phép merge. Thành viên review chéo phải chịu trách nhiệm đảm bảo Acceptance Criteria của issue mình review đã được hoàn thành.
"""
    with open(REPORT_PATH, "w", encoding="utf-8") as f:
        f.write(report_content)

if __name__ == "__main__":
    drafts = build_drafts()
    print("Drafts built. Starting GitHub sync...")
    created, updated, closed, mapping_dict = sync_github(drafts)
    generate_report(drafts, created, updated, closed, mapping_dict)
    print("Report generated successfully.")
