import re
import os
import subprocess

# Run flutter analyze to get errors
result = subprocess.run(["flutter", "analyze"], capture_output=True, text=True)
output = result.stdout + result.stderr

# Process undefined name 'context'
# error • Undefined name 'context' • lib/features/auth/presentation/screens/sign_in_screen.dart:69:20 • undefined_identifier
context_errors = re.findall(r"Undefined name 'context'.*?([a-zA-Z0-9_/\.]+dart):(\d+):", output, re.DOTALL)
for file_path, line_str in context_errors:
    line_num = int(line_str) - 1
    with open(file_path, "r") as f:
        lines = f.readlines()
    
    # We know in sign_in_screen.dart it's _buildBrand or similar
    # Let's just do a naive fix if it's _buildBrand or _buildDividerRow
    # Actually, let's just replace `Widget _buildBrand(ThemeData theme)` with `Widget _buildBrand(BuildContext context, ThemeData theme)`
    # And update its calls.
    pass

# A simpler way to fix the missing context in sign_in_screen:
with open("lib/features/auth/presentation/screens/sign_in_screen.dart", "r") as f:
    content = f.read()

content = content.replace("Widget _buildBrand(ThemeData theme) {", "Widget _buildBrand(BuildContext context, ThemeData theme) {")
content = content.replace("_buildBrand(theme),", "_buildBrand(context, theme),")

content = content.replace("Widget _buildDividerRow(ThemeData theme) {", "Widget _buildDividerRow(BuildContext context, ThemeData theme) {")
content = content.replace("_buildDividerRow(theme),", "_buildDividerRow(context, theme),")

with open("lib/features/auth/presentation/screens/sign_in_screen.dart", "w") as f:
    f.write(content)


# Process invalid_constant
# Let's just fix all "const " in front of things containing context.appColors
lib_dir = "lib/features"
for root, _, files in os.walk(lib_dir):
    for filename in files:
        if filename.endswith(".dart"):
            path = os.path.join(root, filename)
            with open(path, "r") as f:
                content = f.read()
            
            # Simple regex to remove const before common widgets that now have context.appColors
            # e.g. `const Icon(` -> `Icon(` if the line has context.appColors
            # Actually, let's just process line by line
            lines = content.split('\n')
            new_lines = []
            for line in lines:
                if 'context.appColors' in line and 'const ' in line:
                    line = line.replace('const ', '')
                # also handles multi-line consts where const is on a previous line?
                new_lines.append(line)
            
            with open(path, "w") as f:
                f.write('\n'.join(new_lines))

