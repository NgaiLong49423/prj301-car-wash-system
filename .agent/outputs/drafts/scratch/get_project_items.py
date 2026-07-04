import subprocess
import json
import sys

if hasattr(sys.stdout, 'reconfigure'):
    sys.stdout.reconfigure(encoding='utf-8')

cmd = ["gh", "project", "item-list", "6", "--owner", "NgaiLong49423", "--limit", "100", "--format", "json"]
res = subprocess.run(cmd, capture_output=True, text=True, encoding='utf-8')
if res.returncode != 0:
    print(f"Error fetching project items: {res.stderr}")
    sys.exit(1)

try:
    data = json.loads(res.stdout)
except Exception as e:
    print(f"Failed to parse JSON: {e}")
    sys.exit(1)

items = data.get('items', [])
print(f"Total items in project: {len(items)}")

for idx, item in enumerate(items):
    content = item.get('content', {})
    item_id = item.get('id')
    title = item.get('title')
    status = item.get('status')
    
    # Check type of item
    content_type = content.get('type')
    number = content.get('number')
    
    print(f"{idx+1}. ID: {item_id} | Type: {content_type} | Number: {number} | Title: '{title}' | Status: '{status}'")
