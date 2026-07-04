import subprocess
import json
import sys
import os

# Reconfigure stdout to use UTF-8 to prevent encoding issues when printing Vietnamese characters
if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')
if hasattr(sys.stderr, 'reconfigure'):
    sys.stderr.reconfigure(encoding='utf-8')

# IDs
project_id = "PVT_kwHOCcGJZc4BZr1_"
status_field_id = "PVTSSF_lAHOCcGJZc4BZr1_zhUozW4"
ready_option_id = "61e4505c"
backlog_option_id = "f75ad846"

# Define classifications
target_issues = {41, 42, 58, 43, 44, 45, 46, 47, 48}
backlog_issues = {64, 59, 63, 61, 62}
skip_review_issues = {60}  # related to rewards, skip and ask for user review

def get_items():
    cmd = ["gh", "project", "item-list", "6", "--owner", "NgaiLong49423", "--limit", "100", "--format", "json"]
    res = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
    if res.returncode != 0:
        raise RuntimeError(f"Failed to fetch project items: {res.stderr}")
    data = json.loads(res.stdout)
    return data.get('items', [])

print("Fetching current project items (up to 100)...")
items = get_items()

# Map current project items by issue number
item_map = {}
for item in items:
    content = item.get('content', {})
    if content.get('type') == 'Issue':
        number = content.get('number')
        if number:
            item_map[number] = {
                'id': item.get('id'),
                'title': item.get('title'),
                'status': item.get('status')
            }

# Check if #41 is in project
if 41 not in item_map:
    print("Issue #41 not found in project. Adding it...")
    add_cmd = ["gh", "project", "item-add", "6", "--owner", "NgaiLong49423", "--url", "https://github.com/NgaiLong49423/prj301-car-wash-system/issues/41", "--format", "json"]
    res_add = subprocess.run(add_cmd, capture_output=True, text=True, encoding='utf-8')
    if res_add.returncode != 0:
        raise RuntimeError(f"Failed to add Issue #41 to project: {res_add.stderr}")
    add_data = json.loads(res_add.stdout)
    item_id = add_data.get('id')
    print(f"Successfully added Issue #41 (Item ID: {item_id})")
    item_map[41] = {
        'id': item_id,
        'title': "FR-09 — Tích điểm tự động sau khi hoàn thành rửa xe",
        'status': None
    }
else:
    print("Issue #41 is already in project.")

report_data = {
    'ready': [],
    'backlog': [],
    'skipped': []
}

# 1. Update target issues to Ready
for num in sorted(target_issues):
    item = item_map.get(num)
    if not item:
        raise ValueError(f"Target Issue #{num} is missing from project mapping!")
        
    item_id = item['id']
    title = item['title']
    current_status = item['status']
    
    if current_status == 'Ready':
        print(f"Issue #{num} is already 'Ready'. Skipping update.")
        report_data['skipped'].append({
            'number': num,
            'title': title,
            'reason': "Already in Ready status"
        })
    else:
        print(f"Updating Issue #{num} ({title}) status to 'Ready'...")
        edit_cmd = [
            "gh", "project", "item-edit",
            "--id", item_id,
            "--field-id", status_field_id,
            "--project-id", project_id,
            "--single-select-option-id", ready_option_id
        ]
        res_edit = subprocess.run(edit_cmd, capture_output=True, text=True, encoding='utf-8')
        if res_edit.returncode != 0:
            raise RuntimeError(f"Failed to update Issue #{num} to Ready: {res_edit.stderr}")
        print(f"Issue #{num} successfully set to 'Ready'.")
        report_data['ready'].append({
            'number': num,
            'title': title,
            'prev_status': current_status
        })

# 2. Update unrelated issues to Backlog
for num in sorted(backlog_issues):
    item = item_map.get(num)
    if not item:
        print(f"Warning: Issue #{num} to be backlogged is not in project.")
        report_data['skipped'].append({
            'number': num,
            'title': f"Issue #{num}",
            'reason': "Not in project board"
        })
        continue
        
    item_id = item['id']
    title = item['title']
    current_status = item['status']
    
    if current_status == 'Backlog':
        print(f"Issue #{num} is already 'Backlog'. Skipping update.")
        report_data['skipped'].append({
            'number': num,
            'title': title,
            'reason': "Already in Backlog status"
        })
    else:
        print(f"Updating Issue #{num} ({title}) status to 'Backlog'...")
        edit_cmd = [
            "gh", "project", "item-edit",
            "--id", item_id,
            "--field-id", status_field_id,
            "--project-id", project_id,
            "--single-select-option-id", backlog_option_id
        ]
        res_edit = subprocess.run(edit_cmd, capture_output=True, text=True, encoding='utf-8')
        if res_edit.returncode != 0:
            raise RuntimeError(f"Failed to update Issue #{num} to Backlog: {res_edit.stderr}")
        print(f"Issue #{num} successfully set to 'Backlog'.")
        report_data['backlog'].append({
            'number': num,
            'title': title,
            'prev_status': current_status
        })

# 3. Handle skipped / done / other issues
for num, item in sorted(item_map.items()):
    if num in target_issues or num in backlog_issues:
        continue
        
    title = item['title']
    current_status = item['status']
    
    if num in skip_review_issues:
        reason = "Skipped - needs user review (Related to rewards program)"
    elif current_status == 'Done':
        reason = "Skipped - Already Done/Closed"
    elif current_status == 'Backlog':
        reason = "Skipped - Already Backlog"
    else:
        reason = f"Skipped - Unrelated issue with status '{current_status}'"
        
    print(f"Skipping Issue #{num} ({title}). Reason: {reason}")
    report_data['skipped'].append({
        'number': num,
        'title': title,
        'reason': reason
    })

# 4. Verify the final status of all items in Project 6
print("\nVerifying final statuses of project items...")
final_items = get_items()
final_map = {}
for item in final_items:
    content = item.get('content', {})
    if content.get('type') == 'Issue':
        num = content.get('number')
        if num:
            final_map[num] = item.get('status')

print("\n--- FINAL STATUS VERIFICATION ---")
all_matched = True
for num in sorted(target_issues):
    status = final_map.get(num)
    print(f"Issue #{num} (Target) -> Current Status: {status} (Expected: Ready)")
    if status != 'Ready':
        print(f"ERROR: Issue #{num} status mismatch!")
        all_matched = False
        
for num in sorted(backlog_issues):
    status = final_map.get(num)
    print(f"Issue #{num} (Unrelated) -> Current Status: {status} (Expected: Backlog)")
    if status != 'Backlog':
        print(f"ERROR: Issue #{num} status mismatch!")
        all_matched = False

if all_matched:
    print("\nVerification process complete: All issue statuses match target values!")
else:
    print("\nVerification process complete: Some errors were detected!")
    sys.exit(1)

# Save report_data to a temporary json file for report generation
os.makedirs('agent/scratch', exist_ok=True)
with open('agent/scratch/project_sync_data.json', 'w', encoding='utf-8') as jf:
    json.dump(report_data, jf, ensure_ascii=False, indent=2)
print("Saved project sync data for report generation.")
