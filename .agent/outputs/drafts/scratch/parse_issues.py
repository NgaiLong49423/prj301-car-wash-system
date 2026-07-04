import os

filepath = r'd:\Semester 4\PRJ301\prj301-car-wash-system\agent\assignment-issue-loyalty-flow-design.md'
if not os.path.exists(filepath):
    raise FileNotFoundError(f"Source file {filepath} not found!")

with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.readlines()

sections = {
    'FR-09': [],
    'FR-10a': [],
    'FR-10b': [],
    'FR-11': [],
    'FR-12': [],
    'FR-13': [],
    'FR-14a': [],
    'FR-15': [],
    'FR-16': []
}

current_section = None

for line in lines:
    stripped = line.strip()
    matched_section = None
    if stripped.startswith('# FR-09'):
        matched_section = 'FR-09'
    elif stripped.startswith('# FR-10a'):
        matched_section = 'FR-10a'
    elif stripped.startswith('# FR-10b'):
        matched_section = 'FR-10b'
    elif stripped.startswith('# FR-11'):
        matched_section = 'FR-11'
    elif stripped.startswith('# FR-12'):
        matched_section = 'FR-12'
    elif stripped.startswith('# FR-13 —'):  # matches the em-dash for FR-13 specifically
        matched_section = 'FR-13'
    elif stripped.startswith('# FR-14a'):
        matched_section = 'FR-14a'
    elif stripped.startswith('# FR-15'):
        matched_section = 'FR-15'
    elif stripped.startswith('# FR-16'):
        matched_section = 'FR-16'
        
    if matched_section:
        current_section = matched_section
        
    if current_section:
        sections[current_section].append(line)

output_dir = r'd:\Semester 4\PRJ301\prj301-car-wash-system\agent\github-issue-bodies'
os.makedirs(output_dir, exist_ok=True)

for key, content_lines in sections.items():
    content = "".join(content_lines)
    content = content.strip()
    
    sub_lines = content.splitlines()
    while sub_lines and not sub_lines[-1].strip():
        sub_lines.pop()
    if sub_lines and sub_lines[-1].strip() == '---':
        sub_lines.pop()
    while sub_lines and not sub_lines[-1].strip():
        sub_lines.pop()
        
    cleaned_content = "\n".join(sub_lines) + "\n"
    
    if not cleaned_content.strip():
        raise ValueError(f"Error: Parsed body for {key} is empty!")
        
    out_file = os.path.join(output_dir, f"{key}.md")
    with open(out_file, 'w', encoding='utf-8') as out_f:
        out_f.write(cleaned_content)
    print(f"Successfully saved {key} to {out_file} ({len(cleaned_content)} bytes)")

print("Parsing completed successfully!")
