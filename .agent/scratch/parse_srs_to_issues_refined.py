import os
import re
import sys
import glob

SRS_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Document\SRS.md"
OUTPUT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues"
INDEX_PATH = os.path.join(OUTPUT_DIR, "ISSUE_INDEX.md")

os.makedirs(OUTPUT_DIR, exist_ok=True)

# 1. Cleanup old invalid files
def cleanup_old_files():
    for f in glob.glob(os.path.join(OUTPUT_DIR, "*.md")):
        basename = os.path.basename(f)
        if basename == "ISSUE_INDEX.md":
            continue
        if not re.match(r"^FR-AS-\d{2}\.md$", basename):
            os.remove(f)
            print(f"Deleted old file: {basename}")

cleanup_old_files()

# Mappings of new FR to old issues
MAPPINGS = {
    "FR-AS-07": "#41",
    "FR-AS-11": "#42, #58",
    "FR-AS-12": "#44",
    "FR-AS-14": "#43",
    "FR-AS-20": "#45",
    "FR-AS-21": "#46",
    "FR-AS-22": "#47, #48",
}

GROUPING_RECOMMENDATIONS = {
    "FR-AS-08": "Gộp vào FR-AS-07 (Issue #41)",
    "FR-AS-09": "Gộp vào FR-AS-07 (Issue #41)",
    "FR-AS-10": "Gộp vào FR-AS-07 (Issue #41)",
    "FR-AS-18": "Gộp vào Epic Admin Controls",
    "FR-AS-19": "Gộp vào Epic Admin Controls",
    "FR-AS-26": "Gộp vào Epic Admin Controls",
    "FR-AS-24": "Chuyển thành Testing Task",
    "FR-AS-25": "Chuyển thành Testing Task",
    "FR-AS-29": "Cross-cutting Task / Code Checklist",
    "FR-AS-30": "Maintenance Task",
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
        
        # Determine labels
        labels = []
        if fr_code in ["FR-AS-11", "FR-AS-12", "FR-AS-14", "FR-AS-15", "FR-AS-16"]:
            labels.extend(["✨ Feature", "⚙️ Backend", "🗄️ Database", "🧪 Testing"])
        elif fr_code in ["FR-AS-03", "FR-AS-04", "FR-AS-05", "FR-AS-06", "FR-AS-13", "FR-AS-23"]:
            labels.extend(["✨ Feature", "🎨 Frontend", "⚙️ Backend", "🗄️ Database"])
        elif fr_code in ["FR-AS-17", "FR-AS-18", "FR-AS-19", "FR-AS-20", "FR-AS-21", "FR-AS-22", "FR-AS-26"]:
            labels.extend(["✨ Feature", "👑 Admin", "⚙️ Backend", "🎨 Frontend", "🗄️ Database"])
        elif fr_code in ["FR-AS-24", "FR-AS-25"]:
            labels.extend(["📚 Documentation", "🧪 Testing"])
        else:
            labels.append("✨ Feature")
            if "database" in fr_body.lower() or "tính điểm" in fr_body.lower():
                labels.extend(["⚙️ Backend", "🗄️ Database"])
            if "giao diện" in fr_body.lower() or "trang" in fr_body.lower():
                labels.append("🎨 Frontend")

        labels = list(dict.fromkeys(labels))
            
        # Determine size/story points based on hard difficulty rules
        size = "M"
        points = 5
        if fr_code == "FR-AS-07":
            size, points = "L", 8
        elif fr_code == "FR-AS-12":
            size, points = "M", 5
        elif fr_code == "FR-AS-16":
            size, points = "M", 5
        elif fr_code == "FR-AS-22":
            size, points = "M", 5
        elif fr_code == "FR-AS-27":
            size, points = "S", 2
        elif fr_code in ["FR-AS-29", "FR-AS-30"]:
            size, points = "S", 2
        elif fr_code in ["FR-AS-01", "FR-AS-02"]:
            size, points = "M", 3
        elif len(fr_body) < 300:
            size, points = "S", 2

        # Parse body into sections
        mo_ta = extract_section(fr_body, ["**Mô tả:**"], ["**Lý do cần có:**", "**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Kết quả mong đợi:**"])
        ly_do = extract_section(fr_body, ["**Lý do cần có:**"], ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**", "**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
        luong_xu_ly = extract_section(fr_body, ["**Luồng xử lý chính:**", "**Dữ liệu cần hiển thị:**"], ["**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
        dieu_kien = extract_section(fr_body, ["**Điều kiện/ràng buộc:**"], ["**Kết quả mong đợi:**"])
        ket_qua = extract_section(fr_body, ["**Kết quả mong đợi:**"], [])
        
        goal = f"{mo_ta}\n\n{ly_do}".strip() if (mo_ta or ly_do) else fr_body[:200] + "..."
        scope = luong_xu_ly if luong_xu_ly else "Theo tài liệu SRS"
        ac = f"{dieu_kien}\n\n{ket_qua}".strip() if (dieu_kien or ket_qua) else "Kiểm thử theo TS-AS tương ứng trong SRS"
        out_of_scope = "Các chức năng không liệt kê trong scope"
        
        technical_notes = "Tham khảo database schema và các ràng buộc đã định nghĩa trong SRS"
        files_affected = "TBD"

        # Enhance specific TBDs
        if fr_code == "FR-AS-12":
            technical_notes = "Yêu cầu cơ chế Job/Scheduler (như Quartz, Spring Task hoặc SQL Agent Job) chạy định kỳ mỗi đêm để scan bảng LoyaltyPointBatch và cập nhật status sang EXPIRED nếu quá 12 tháng. Phải dùng Transaction để đảm bảo tính toàn vẹn khi trừ điểm active_points trên Customer."
            files_affected = "PointExpiryJob.java, LoyaltyAccountDAO.java, schema.sql"
        elif fr_code == "FR-AS-15":
            technical_notes = "Cần có logic kiểm tra voucher validity (ngày hạn, trạng thái, Customer_ID) ở Backend trước khi apply. Tính toán `discount_amount` và lưu `final_amount` vào bảng Booking."
            files_affected = "BookingDAO.java, VoucherDAO.java, booking-action.jsp"
        elif fr_code == "FR-AS-16":
            technical_notes = "Tương tự Point Expiry, cần Job chạy ngầm để scan bảng Voucher đổi trạng thái các voucher hết hạn thành EXPIRED. Tránh load toàn bộ DB lên bộ nhớ (xử lý theo batch)."
            files_affected = "VoucherExpiryJob.java, VoucherDAO.java"
        elif fr_code == "FR-AS-24":
            technical_notes = "Script `sample-data.sql` cần insert ít nhất 5 user, các giao dịch và điểm số có sẵn ở nhiều mốc thời gian để demo chức năng expiry và review hạng."
            files_affected = "Database/sample-data.sql"
        elif fr_code == "FR-AS-25":
            technical_notes = "Đảm bảo luồng đi từ Guest (đăng ký) -> Mua dịch vụ -> Hoàn thành booking -> Lên hạng -> Đổi điểm -> Áp dụng voucher."
            files_affected = "Testing Documents"
        elif fr_code == "FR-AS-29":
            technical_notes = "Tuyệt đối không dùng hardcode string 'PENDING', 'CONFIRMED' trên UI mà phải map từ DB Enum hoặc resource bundle / constant class ở Backend."
            files_affected = "Constants.java, *.jsp"
        elif fr_code == "FR-AS-30":
            technical_notes = "Rà soát toàn bộ code, xóa hoặc comment out các thư mục module cũ (ví dụ module quản lý kho, nhân sự) nếu không nằm trong phạm vi Assessment để code sạch."
            files_affected = "Source files, UI sidebar"

        draft_content = f"""# {fr_code} — {fr_title}

## Goal
{goal}

## Scope
{scope}

## Out of Scope
{out_of_scope}

## Acceptance Criteria
{ac}

## Technical Notes
{technical_notes}

## Files likely affected
{files_affected}

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
    index_content += "| Mã FR | Tiêu đề | File Draft | Issue Cũ | Labels | Khuyến nghị Gộp/Đổi loại |\n"
    index_content += "|---|---|---|---|---|---|\n"
    
    for iss in issues:
        index_content += f"| {iss['code']} | {iss['title']} | `{iss['filename']}` | {iss['old_issue']} | {iss['labels']} | {iss['group_rec']} |\n"
        
    with open(INDEX_PATH, "w", encoding="utf-8") as idx_f:
        idx_f.write(index_content)
        
    print(f"SUCCESS: Parsed 30 FRs and generated {len(issues)} drafts.")

if __name__ == "__main__":
    parse_srs()
