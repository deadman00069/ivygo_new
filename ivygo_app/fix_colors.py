import os
import re

lib_dir = "lib/features"

# Find all dart files
for root, _, files in os.walk(lib_dir):
    for f in files:
        if f.endswith(".dart"):
            path = os.path.join(root, f)
            with open(path, "r") as file:
                content = file.read()
            
            # replace AppColors. with context.appColors.
            new_content = content.replace("AppColors.", "context.appColors.")
            
            # Also, since we don't want to replace LightAppColors, let's fix if it accidentally replaced Lightcontext.appColors
            new_content = new_content.replace("Lightcontext.appColors.", "LightAppColors.")
            
            if new_content != content:
                with open(path, "w") as file:
                    file.write(new_content)
                print(f"Updated {path}")
