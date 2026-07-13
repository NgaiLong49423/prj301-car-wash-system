import os
import re
import sys

SRS_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Document\SRS.md"
OUTPUT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues"
INDEX_PATH = os.path.join(OUTPUT_DIR, "ISSUE_INDEX.md")

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Mappings of new FR to old issues
MAPPINGS = {
    "FR-AS-07": "#41", # Booking completed earns loyalty points
    "FR-AS-11": "#42, #58", # Tier review theo active spend/visits (Includes old #58 for refresh)
    "FR-AS-12": "#44", # Point expiry
    "FR-AS-14": "#43", # Redeem points into voucher
    "FR-AS-20": "#45", # Admin Loyalty Settings
    "FR-AS-21": "#46", # Admin Promotion Management
    "FR-AS-22": "#47, #48", # Admin Report Dashboard (Includes old #48 for revenue/booking reports)
}

# Recommendations for grouping
GROUPING_RECOMMENDATIONS = {
    "FR-AS-08": "Có thể gộp chung vào FR-AS-07 (Issue #41)",
    "FR-AS-09": "Có thể gộp chung vào FR-AS-07 (Issue #41)",
    "FR-AS-10": "Có thể gộp chung vào FR-AS-07 (Issue #41)",
    "FR-AS-18": "Nên xem xét gom thành Epic Admin cùng FR-AS-17 đến FR-AS-22 và FR-AS-26",
    "FR-AS-19": "Nên xem xét gom thành Epic Admin cùng FR-AS-17 đến FR-AS-22 và FR-AS-26",
    "FR-AS-26": "Nên xem xét gom thành Epic Admin cùng FR-AS-17 đến FR-AS-22",
    "FR-AS-24": "Có thể chuyển thành Task thay vì Issue Feature",
    "FR-AS-25": "Có thể chuyển thành Task thay vì Issue Feature",
}

def extract_section(text, start_markers, end_markers):
    start_idx = -1
    for m in start_markers:
        idx = text.find(m)
        if idx != -1:
            start_idx = idx + len(m)
            break
            
    if start_idx == -1:
        return ""
        
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

    if len(matches) != 30:
        print(f"ERROR: Expected 30 FR-AS items, but found {len(matches)}.")
        sys.exit(1)

    issues = []
    
    for fr_code, fr_title, fr_body in matches:
        fr_code = fr_code.strip()
        fr_title = fr_title.strip()
        fr_body = fr_body.strip()
        
        old_issue = MAPPINGS.get(fr_code, "Mới")
        filename = f"{fr_code}.md"
        filepath = os.path.join(OUTPUT_DIR, filename)
        
        # Determine labels based on content and code
        labels = ["✨ Feature"]
        if "Admin" in fr_body or "Admin" in fr_title or "admin" in fr_title.lower():
            labels.extend(["⚙️ Backend", "🖥️ Frontend", "👑 Admin"])
        elif "Customer" in fr_body or "Customer" in fr_title:
            labels.extend(["🖥️ Frontend", "👤 Customer"])
        
        if "database" in fr_body.lower() or "cập nhật" in fr_body.lower() or "tính điểm" in fr_body.lower() or "transaction" in fr_body.lower():
            if "⚙️ Backend" not in labels: labels.append("⚙️ Backend")
            labels.append("🗄️ Database")
            
        # Deduplicate labels
        labels = list(dict.fromkeys(labels))
            
        size = "S" if len(fr_body) < 300 else ("L" if len(fr_body) > 1000 else "M")
        points = 2 if size == "S" else (8 if size == "L" else 5)
        
        # Parse body into sections
        mo_ta = extract_section(fr_body, ["**Mô tả:**"], ["**Lý do cần có:**", "**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Kết quả mong đợi:**"])
        ly_do = extract_section(fr_body, ["**Lý do cần có:**"], ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
        luong_xu_ly = extract_section(fr_body, ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**"], ["**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
        dieu_kien = extract_section(fr_body, ["**Điều kiện/ràng buộc:**"], ["**Kết quả mong đợi:**"])
        ket_qua = extract_section(fr_body, ["**Kết quả mong đợi:**"], [])
        
        goal = f"{mo_ta}\n\n{ly_do}".strip()
        if not goal: goal = "TBD"
        
        scope = luong_xu_ly if luong_xu_ly else "TBD"
        ac = f"{dieu_kien}\n\n{ket_qua}".strip() if (dieu_kien or ket_qua) else "TBD"
        
        draft_content = f"""# {fr_code} — {fr_title}

## Goal
{goal}

## Scope
{scope}

## Out of Scope
TBD

## Acceptance Criteria
{ac}

## Technical Notes
TBD (Tham khảo database schema và các ràng buộc đã định nghĩa trong SRS)

## Files likely affected
TBD

## Traceability
- **Nguồn:** `Document/SRS.md` - Section `{fr_code}`
- **GitHub Issue cũ (nếu có):** {old_issue}

## Suggested Labels
{', '.join(labels)}

## Size / Story Points
- **Size:** {size}
- **Story Points:** {points}
"""
        with open(filepath, "w", encoding="utf-8") as out_f:
            out_f.write(draft_content)
            
        group_rec = GROUPING_RECOMMENDATIONS.get(fr_code, "")
            
        issues.append({
            "code": fr_code,
            "title": fr_title,
            "filename": filename,
            "old_issue": old_issue,
            "labels": ", ".join(labels),
            "group_rec": group_rec
        })

    # Generate ISSUE_INDEX.md
    index_content = "# Mục lục Issue Đề xuất (ISSUE INDEX)\n\n"
    index_content += "| Mã FR | Tiêu đề | File Draft | Issue Cũ | Labels | Khuyến nghị Gộp |\n"
    index_content += "|---|---|---|---|---|---|\n"
    
    mapped_count = 0
    new_count = 0
    
    for iss in issues:
        if iss['old_issue'] != "Mới":
            mapped_count += 1
        else:
            new_count += 1
            
        index_content += f"| {iss['code']} | {iss['title']} | `{iss['filename']}` | {iss['old_issue']} | {iss['labels']} | {iss['group_rec']} |\n"
        
    with open(INDEX_PATH, "w", encoding="utf-8") as idx_f:
        idx_f.write(index_content)
        
    print(f"SUCCESS: Parsed {len(matches)} FRs.")
    print(f"Generated {len(issues)} drafts.")
    print(f"Mapped to old issues: {mapped_count}")
    print(f"New issues: {new_count}")

if __name__ == "__main__":
    parse_srs()
