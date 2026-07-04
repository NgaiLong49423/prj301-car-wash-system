import os
import subprocess
import json
import sys

# Reconfigure stdout to use UTF-8 to prevent encoding issues when printing Vietnamese characters
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')
if hasattr(sys.stderr, 'reconfigure'):
    sys.stderr.reconfigure(encoding='utf-8')

# Define the issues we found
issue_mapping = {
    'FR-09': {
        'number': '41',
        'title': 'FR-09 — Tích điểm tự động sau khi hoàn thành rửa xe',
        'body_file': r'agent\github-issue-bodies\FR-09.md'
    },
    'FR-10a': {
        'number': '42',
        'title': 'FR-10a — Xét hạng thành viên tự động',
        'body_file': r'agent\github-issue-bodies\FR-10a.md'
    },
    'FR-10b': {
        'number': '58',
        'title': 'FR-10b — Tự động kích hoạt xét lại hạng khi dữ liệu loyalty thay đổi',
        'body_file': r'agent\github-issue-bodies\FR-10b.md'
    },
    'FR-11': {
        'number': '43',
        'title': 'FR-11 — Đổi điểm loyalty lấy ưu đãi',
        'body_file': r'agent\github-issue-bodies\FR-11.md'
    },
    'FR-12': {
        'number': '44',
        'title': 'FR-12 — Điểm loyalty hết hạn sau 12 tháng',
        'body_file': r'agent\github-issue-bodies\FR-12.md'
    },
    'FR-13': {
        'number': '45',
        'title': 'FR-13 — Admin Loyalty Configuration: Cấu hình luật loyalty cho Admin',
        'body_file': r'agent\github-issue-bodies\FR-13.md'
    },
    'FR-14a': {
        'number': '46',
        'title': 'FR-14a — Gửi khuyến mãi nhắm mục tiêu theo hạng thành viên',
        'body_file': r'agent\github-issue-bodies\FR-14a.md'
    },
    'FR-15': {
        'number': '47',
        'title': 'FR-15 — Báo cáo thống kê khách hàng dành cho Admin',
        'body_file': r'agent\github-issue-bodies\FR-15.md'
    },
    'FR-16': {
        'number': '48',
        'title': 'FR-16 — Báo cáo doanh thu và lịch đặt dành cho Admin',
        'body_file': r'agent\github-issue-bodies\FR-16.md'
    }
}

backup_dir = r'd:\Semester 4\PRJ301\prj301-car-wash-system\agent\github-issue-backup'
os.makedirs(backup_dir, exist_ok=True)

cwd = r'd:\Semester 4\PRJ301\prj301-car-wash-system'

print("Starting backup and sync process...")

for fr, info in issue_mapping.items():
    number = info['number']
    title = info['title']
    body_file = os.path.join(cwd, info['body_file'])
    
    print(f"\n--- Processing {fr} (Issue #{number}) ---")
    
    # 1. Backup the existing issue details
    backup_file = os.path.join(backup_dir, f"issue-{number}-before.json")
    print(f"Backing up Issue #{number} to {backup_file}...")
    
    backup_cmd = ["gh", "issue", "view", number, "--json", "number,title,body"]
    res_backup = subprocess.run(backup_cmd, cwd=cwd, capture_output=True, text=True, encoding='utf-8')
    if res_backup.returncode != 0:
        raise RuntimeError(f"Failed to backup Issue #{number}: {res_backup.stderr}")
        
    # Write the output to backup json file
    with open(backup_file, 'w', encoding='utf-8') as bf:
        bf.write(res_backup.stdout)
    
    # Verify backup is valid JSON and not empty
    try:
        data = json.loads(res_backup.stdout)
        if not data.get('body'):
            print(f"Warning: Backup body for Issue #{number} seems empty.")
    except Exception as e:
        raise RuntimeError(f"Backup file for Issue #{number} is not valid JSON: {e}")
        
    print(f"Backup of Issue #{number} successful.")

    # 2. Update the issue
    print(f"Updating Issue #{number} with title: '{title}' and body file: '{body_file}'...")
    
    edit_cmd = [
        "gh", "issue", "edit", number,
        "--title", title,
        "--body-file", body_file
    ]
    res_edit = subprocess.run(edit_cmd, cwd=cwd, capture_output=True, text=True, encoding='utf-8')
    if res_edit.returncode != 0:
        print(f"ERROR updating issue #{number}!")
        print(f"STDOUT: {res_edit.stdout}")
        print(f"STDERR: {res_edit.stderr}")
        raise RuntimeError(f"Failed to edit Issue #{number}. Return code: {res_edit.returncode}")
        
    print(f"Issue #{number} successfully updated.")

    # 3. Verify issue is updated correctly
    print(f"Verifying Issue #{number}...")
    verify_cmd = ["gh", "issue", "view", number]
    res_verify = subprocess.run(verify_cmd, cwd=cwd, capture_output=True, text=True, encoding='utf-8')
    if res_verify.returncode != 0:
        raise RuntimeError(f"Verification of Issue #{number} failed: {res_verify.stderr}")
    print(f"Verification of Issue #{number} passed.")

print("\nAll issues processed and verified successfully!")
