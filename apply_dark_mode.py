import os
import re

def process_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    new_content = content
    # Replace background
    new_content = new_content.replace('AppColors.background', 'Theme.of(context).scaffoldBackgroundColor')
    
    # Replace white container backgrounds
    new_content = re.sub(r'(Container\([^)]*color:\s*)Colors\.white', r'\1Theme.of(context).colorScheme.surface', new_content)
    new_content = re.sub(r'(BoxDecoration\([^)]*color:\s*)Colors\.white', r'\1Theme.of(context).colorScheme.surface', new_content)
    new_content = re.sub(r'(color:\s*)Colors\.white(,\s*//\s*container\s*bg)', r'\1Theme.of(context).colorScheme.surface\2', new_content)
    new_content = re.sub(r'(backgroundColor:\s*)Colors\.white', r'\1Theme.of(context).colorScheme.surface', new_content)
    new_content = re.sub(r'(backgroundColor:\s*)AppColors\.white', r'\1Theme.of(context).colorScheme.surface', new_content)
    
    # General colors.white replacements where we know it's a block background
    new_content = new_content.replace('color: Colors.white, // background', 'color: Theme.of(context).colorScheme.surface,')

    if new_content != content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, _, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart') and file not in ['theme.dart', 'theme_provider.dart']:
            process_file(os.path.join(root, file))
