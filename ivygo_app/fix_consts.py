import subprocess
import json

result = subprocess.run(["flutter", "analyze", "--machine"], capture_output=True, text=True)

# lines from flutter analyze --machine are like:
# INFO|LINT|lib/features/auth/presentation/screens/create_account_screen.dart|34|28|...|invalid_constant
file_lines = {}
for line in result.stdout.splitlines():
    if "invalid_constant" in line:
        parts = line.split('|')
        if len(parts) >= 5:
            filepath = parts[3]
            line_num = int(parts[4]) - 1
            if filepath not in file_lines:
                file_lines[filepath] = []
            file_lines[filepath].append(line_num)

import re

for file_path, lines_to_fix in file_lines.items():
    print(f"Fixing {file_path}")
    with open(file_path, "r") as f:
        lines = f.readlines()
    
    # Sort backwards to avoid messing up earlier lines if we ever added/removed lines, though we aren't here
    lines_to_fix = sorted(list(set(lines_to_fix)), reverse=True)
    
    for line_num in lines_to_fix:
        # Trace backwards up to 5 lines to find 'const'
        for i in range(line_num, max(-1, line_num - 5), -1):
            if i >= len(lines): continue
            if 'const ' in lines[i]:
                # Remove the first instance of 'const ' looking backwards
                # Or wait, if line_num has the error, the const might actually be strictly on a previous line,
                # but if we just replace the last 'const ' before this error...
                # Actually, replace the last 'const ' in the current line, or the one above it.
                # Regex replace rightmost 'const ' on the found line:
                idx = lines[i].rfind('const ')
                if idx != -1:
                    lines[i] = lines[i][:idx] + lines[i][idx+6:]
                    break
            
    with open(file_path, "w") as f:
        f.writelines(lines)

