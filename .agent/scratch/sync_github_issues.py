import os
import subprocess
import time

INDEX_PATH = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues\ISSUE_INDEX.md"
OUTPUT_DIR = r"d:\Semester 4\PRJ301\prj301-car-wash-system\.agent\outputs\drafts\github-issues"

def run_cmd(cmd):
    try:
        result = subprocess.run(cmd, shell=True, check=True, capture_output=True, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running: {cmd}")
        print(e.stderr)
        return None

def sync():
    with open(INDEX_PATH, "r", encoding="utf-8") as f:
        lines = f.readlines()
        
    start_parsing = False
    for line in lines:
        if line.startswith("|---|"):
            start_parsing = True
            continue
        if start_parsing and line.startswith("|"):
            parts = [p.strip() for p in line.split("|")][1:-1]
            if len(parts) >= 5:
                fr_code = parts[0]
                title = parts[1]
                filename = parts[2].replace("`", "")
                old_issue = parts[3]
                labels = parts[4]
                
                labels = labels.replace("🖥️ Frontend", "🎨 Frontend")
                
                filepath = os.path.join(OUTPUT_DIR, filename)
                
                if old_issue != "Mới":
                    main_issue = old_issue.split(",")[0].replace("#", "").strip()
                    
                    lbl_add = ""
                    for lbl in labels.split(","):
                        lbl_add += f' --add-label "{lbl.strip()}"'
                        
                    cmd = f'gh issue edit {main_issue} --title "{fr_code} — {title}" --body-file "{filepath}" {lbl_add}'
                    print(f"Editing {main_issue} for {fr_code}...")
                    run_cmd(cmd)
                    
                    if "," in old_issue:
                        second_issue = old_issue.split(",")[1].replace("#", "").strip()
                        print(f"Closing duplicate issue {second_issue}...")
                        run_cmd(f'gh issue close {second_issue} -c "Được gộp chung vào issue #{main_issue} ({fr_code})" -r "not planned"')
                        
                else:
                    lbl_args = ""
                    for lbl in labels.split(","):
                        lbl_args += f' --label "{lbl.strip()}"'
                    
                    cmd = f'gh issue create --title "{fr_code} — {title}" --body-file "{filepath}" {lbl_args}'
                    print(f"Creating new issue for {fr_code}...")
                    url = run_cmd(cmd)
                    if url:
                        print(f"Created: {url}")
                
                # Small sleep to avoid rate limits
                time.sleep(2)
                
    print("GitHub Sync Completed.")

if __name__ == "__main__":
    sync()
