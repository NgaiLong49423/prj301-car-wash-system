import os
import re
import sys

sys.stdout.reconfigure(encoding='utf-8')

SRS_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\Docs\requirements\SRS.md"
OUTPUT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues-grouped"

os.makedirs(OUTPUT_DIR, exist_ok=True)

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

# Fetch SRS Data
with open(SRS_PATH, "r", encoding="utf-8") as f:
    content = f.read()
section_5 = re.search(r"## 5\. Yêu cầu chức năng(.*?)## 6\.", content, re.DOTALL).group(1)
matches = re.findall(r"### 5\.\d+ (FR-AS-\d+) — (.*?)\n(.*?)(?=\n### 5\.\d+ FR-AS|\Z)", section_5, re.DOTALL)

fr_data = {}
for code, title, body in matches:
    fr_data[code.strip()] = {"title": title.strip(), "body": body.strip()}

GROUPS = [
    {
        "id": "GI-01", "gh_issue": "83", "title": "Auth, Registration and Access Control", "frs": ["FR-AS-01", "FR-AS-02", "FR-AS-27"],
        "desc": "Cung cấp tính năng đăng nhập, đăng ký cho Customer và xử lý phân quyền truy cập. Giới hạn Guest chỉ xem được tối thiểu.",
        "goal": "Người dùng có thể tạo tài khoản, đăng nhập thành công và bị chặn truy cập nếu không đúng role.",
        "size": "M", "sp": 5, "prio": "High", "type": "Feature", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend", "old_mapping": "Mới",
        "blockers": "Guest truy cập được trang cần đăng nhập. Customer truy cập được Admin page. Mã hóa mật khẩu (nếu có) bị lỗi."
    },
    {
        "id": "GI-02", "gh_issue": "84", "title": "Customer Dashboard, Loyalty Overview and History", "frs": ["FR-AS-03", "FR-AS-04", "FR-AS-05", "FR-AS-06", "FR-AS-13"],
        "desc": "Trang tổng quan cho Khách hàng sau khi đăng nhập. Hiển thị thông tin hồ sơ, điểm loyalty hiện tại, hạng thành viên, lịch sử booking và điểm, cùng danh mục phần thưởng có thể đổi.",
        "goal": "Khách hàng theo dõi được toàn bộ thông tin loyalty và lịch sử hoạt động của mình một cách trực quan.",
        "size": "L", "sp": 8, "prio": "Medium", "type": "Feature", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "old_mapping": "Mới",
        "blockers": "Dữ liệu hiển thị sai (ví dụ điểm loyalty bị sai lệch). Trang bị crash khi không có lịch sử booking."
    },
    {
        "id": "GI-03", "gh_issue": "41", "title": "Booking Completion Loyalty Award", "frs": ["FR-AS-07", "FR-AS-08", "FR-AS-09", "FR-AS-10", "FR-AS-28"],
        "desc": "Xử lý logic quan trọng nhất: Khi Booking chuyển trạng thái COMPLETED, hệ thống sẽ tính toán và cộng điểm loyalty tự động dựa trên số tiền thực trả (final amount), đồng thời cập nhật Lifetime và 12-Month active data.",
        "goal": "Tính và cộng đúng điểm loyalty khi hoàn thành dịch vụ, chống cộng trùng lặp.",
        "size": "L", "sp": 13, "prio": "High", "type": "Core", "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database", "old_mapping": "#41",
        "blockers": "Booking PENDING, CONFIRMED, CANCELLED vẫn được cộng điểm. Booking COMPLETED bị cộng điểm nhiều hơn một lần. Tính điểm theo original_amount thay vì final_amount."
    },
    {
        "id": "GI-04", "gh_issue": "42", "title": "Tier Review and Active 12-Month Loyalty Data", "frs": ["FR-AS-11"],
        "desc": "Định kỳ hoặc theo sự kiện, hệ thống quét dữ liệu chi tiêu (active spend) và số lần đến (active visits) trong 12 tháng qua để xét lên hạng, giữ hạng hoặc giáng hạng thành viên.",
        "goal": "Tự động xét lại hạng thành viên một cách chính xác dựa trên dữ liệu hoạt động 12 tháng gần nhất.",
        "size": "M", "sp": 5, "prio": "High", "type": "Core", "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "old_mapping": "#42, #58",
        "blockers": "Khách hàng đủ điều kiện nhưng không được lên hạng. Tính toán 12-month data bị sai lệch."
    },
    {
        "id": "GI-05", "gh_issue": "44", "title": "Point Batch Expiry and Active Points Refresh", "frs": ["FR-AS-12"],
        "desc": "Kiểm tra và trừ các điểm loyalty đã quá hạn 12 tháng. Hệ thống thiết kế theo hướng event-based (chạy tính toán khi mở trang hoặc trước khi dùng điểm) thay vì dùng background scheduler.",
        "goal": "Khách hàng bị trừ điểm hết hạn tự động, số điểm active luôn là số đã trừ hết hạn.",
        "size": "M", "sp": 5, "prio": "High", "type": "Core", "labels": "✨ Feature, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "old_mapping": "#44",
        "blockers": "Điểm quá hạn không bị trừ, dẫn đến việc dùng điểm hết hạn để redeem reward."
    },
    {
        "id": "GI-06", "gh_issue": "43", "title": "Reward Redemption into Voucher", "frs": ["FR-AS-14"],
        "desc": "Chức năng cho phép Khách hàng dùng điểm active loyalty để đổi lấy Voucher (Mã giảm giá). Cần kiểm tra kỹ số dư điểm và trừ điểm hợp lệ.",
        "goal": "Khách hàng đổi điểm lấy voucher thành công và điểm bị trừ chính xác.",
        "size": "M", "sp": 5, "prio": "High", "type": "Core", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "old_mapping": "#43",
        "blockers": "Redeem reward bằng điểm đã hết hạn. Đổi voucher thành công nhưng không bị trừ điểm."
    },
    {
        "id": "GI-07", "gh_issue": "85", "title": "Apply Voucher to Booking and Voucher Lifecycle", "frs": ["FR-AS-15", "FR-AS-16"],
        "desc": "Luồng áp dụng Voucher vào Booking để tính tiền giảm giá, đồng thời quản lý vòng đời Voucher (khi nào thì USED, khi nào thì EXPIRED).",
        "goal": "Tính toán đúng số tiền giảm giá và khóa các Voucher đã sử dụng hoặc hết hạn.",
        "size": "M", "sp": 8, "prio": "High", "type": "Core", "labels": "✨ Feature, 🎨 Frontend, ⚙️ Backend, 🗄️ Database, 🧪 Testing", "old_mapping": "Mới",
        "blockers": "Voucher USED, EXPIRED hoặc CANCELLED vẫn dùng lại được. Một voucher được dùng cho nhiều booking. Một booking áp dụng nhiều voucher trong scope hiện tại."
    },
    {
        "id": "GI-08", "gh_issue": "86", "title": "Admin UI Shell and Dashboard", "frs": ["FR-AS-17", "FR-AS-26"],
        "desc": "Khung giao diện chính (Shell) dành cho Admin, chứa thanh điều hướng và màn hình thống kê nhanh (tổng doanh thu, tổng user mới).",
        "goal": "Cung cấp không gian làm việc an toàn và thống nhất cho Admin.",
        "size": "M", "sp": 5, "prio": "Medium", "type": "Admin", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend", "old_mapping": "Mới",
        "blockers": "Trang Admin vỡ layout hoặc truy cập được từ Customer."
    },
    {
        "id": "GI-09", "gh_issue": "45", "title": "Admin Loyalty Configuration Controls", "frs": ["FR-AS-18", "FR-AS-19", "FR-AS-20"],
        "desc": "Quản lý các thông số cốt lõi: quy định hạng thành viên, danh sách phần thưởng, và tỷ lệ quy đổi điểm. Admin có thể thay đổi các thông số này.",
        "goal": "Admin có toàn quyền kiểm soát các quy định loyalty mà không cần sửa code (hoặc sửa ở database config).",
        "size": "L", "sp": 8, "prio": "High", "type": "Admin", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "old_mapping": "#45",
        "blockers": "Config được thay đổi nhưng hệ thống vẫn tính theo logic hardcode cũ."
    },
    {
        "id": "GI-10", "gh_issue": "46", "title": "Promotion Management and Customer Promotion Inbox", "frs": ["FR-AS-21", "FR-AS-23"],
        "desc": "Admin có thể soạn và gửi khuyến mãi nhắm mục tiêu theo Hạng. Khách hàng có hộp thư (Inbox) để xem khuyến mãi cá nhân.",
        "goal": "Đưa thông điệp marketing chính xác đến nhóm khách hàng mục tiêu.",
        "size": "M", "sp": 8, "prio": "Medium", "type": "Feature", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "old_mapping": "#46",
        "blockers": "Khuyến mãi gửi nhầm đối tượng hoặc không hiển thị trong hộp thư khách hàng."
    },
    {
        "id": "GI-11", "gh_issue": "47", "title": "Admin Reports Dashboard", "frs": ["FR-AS-22"],
        "desc": "Hệ thống báo cáo gồm báo cáo doanh thu, booking và thống kê khách hàng (số liệu loyalty).",
        "goal": "Hiển thị số liệu chính xác để ban quản lý đưa ra quyết định kinh doanh.",
        "size": "M", "sp": 8, "prio": "Medium", "type": "Admin", "labels": "✨ Feature, 👑 Admin, 🎨 Frontend, ⚙️ Backend, 🗄️ Database", "old_mapping": "#47, #48",
        "blockers": "Report dùng số fake/static làm kết quả chính."
    },
    {
        "id": "GI-12", "gh_issue": "87", "title": "Assessment Seed Data, Demo Flow and Scope Cleanup", "frs": ["FR-AS-24", "FR-AS-25", "FR-AS-29", "FR-AS-30"],
        "desc": "Chuẩn bị dữ liệu mẫu (sample data), dọn dẹp các module nằm ngoài scope đánh giá và thiết lập luồng Demo hoàn chỉnh.",
        "goal": "Dự án sạch sẽ, chạy luột và có đủ dữ liệu (quá khứ) để demo tính năng expiry/tier review ngay lập tức.",
        "size": "M", "sp": 5, "prio": "High", "type": "QA", "labels": "📚 Documentation, 🧪 Testing, ⚙️ Backend, 🗄️ Database", "old_mapping": "Mới",
        "blockers": "PR xóa hoặc phá dữ liệu seed cần cho demo Assessment. Gắn module ngoài scope làm phình to dự án."
    }
]

print("Updating local drafts...")

for gi in GROUPS:
    gi_checklists = []
    gi_acs = []
    
    for fr_code in gi["frs"]:
        if fr_code in fr_data:
            body = fr_data[fr_code]["body"]
            luong_xu_ly = extract_section(body, ["**Luồng xử lý chính:**"], ["**Điều kiện/ràng buộc:**", "**Kết quả mong đợi:**"])
            dieu_kien = extract_section(body, ["**Điều kiện/ràng buộc:**"], ["**Kết quả mong đợi:**"])
            ket_qua = extract_section(body, ["**Kết quả mong đợi:**"], [])
            
            for l in luong_xu_ly.split('\n'):
                if l.strip() and not l.startswith("**"):
                    gi_checklists.append(f"- [ ] {l.strip().lstrip('1234567890. -')}")
                    
            if dieu_kien or ket_qua:
                gi_acs.append(f"**{fr_code}:**\n{dieu_kien}\n{ket_qua}".strip())

    if not gi_checklists:
        gi_checklists = ["- [ ] Hoàn thành logic theo thiết kế."]
    if not gi_acs:
        gi_acs = ["- Đạt chuẩn kiểm thử chức năng cơ bản."]

    checklist_text = "\n".join(gi_checklists)
    ac_text = "\n\n".join(gi_acs)

    body_content = f"""# {gi["id"]} — {gi["title"]}

## Description
{gi["desc"]}

## Goal
{gi["goal"]}

## FR Cover
{', '.join(gi['frs'])}

## Metadata
- **Type:** {gi["type"]}
- **Size:** {gi["size"]}
- **Story Points:** {gi["sp"]}
- **Priority:** {gi["prio"]}
- **Suggested Labels:** {gi["labels"]}
- **Old Issue Mapping:** {gi["old_mapping"]}

## Completion Checklist
{checklist_text}

## Acceptance Criteria
{ac_text}

## PR Merge Gate
PR có thể được merge nếu:
- [ ] Code build/run được.
- [ ] PR liên quan trực tiếp đến grouped issue này.
- [ ] Các checklist chính của issue đã hoàn thành hoặc phần chưa làm được ghi rõ là follow-up.
- [ ] Không phá chức năng hiện có.
- [ ] Đã có ít nhất 2 reviewer theo quy định review của nhóm.
- [ ] PR phải sử dụng đúng Pull Request template trong thư mục `.github` (ví dụ: `.github/pull_request_template.md`).
- [ ] PR description không được để trống.
- [ ] PR phải link issue liên quan bằng cú pháp như `Closes #{gi["gh_issue"]}`, `Fixes #{gi["gh_issue"]}`, hoặc `Related to #{gi["gh_issue"]}`.
- [ ] PR phải điền đầy đủ các phần chính trong template, gồm summary, changes, testing hoặc manual test note, checklist.
> **Note:** Agent review sẽ yêu cầu sửa PR description nếu PR không dùng template hoặc để trống phần bắt buộc.

## Merge Blockers
PR không được merge nếu có lỗi nghiêm trọng trong issue này.
- {gi["blockers"]}
> **Note:** Hardcode business/display values chỉ ghi warning, không tự động block merge (trừ khi làm sai checklist hoặc sai nghiệp vụ). PR quá scope issue chỉ ghi warning/tư vấn tách PR, không tự động block merge nếu không phá chức năng.
"""
    slug = gi["title"].lower().replace(", ", "-").replace(" ", "-").replace("---", "-")
    filepath = os.path.join(OUTPUT_DIR, f"{gi['id']}-{slug}.md")
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(body_content)
        
    print(f"Updated local draft: {filepath}")

print("All local drafts updated.")
