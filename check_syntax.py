import re

with open('Mlibrary/ThanV2.lua', 'r', encoding='utf-8') as f:
    lines = f.readlines()

code = ""
for line in lines:
    code += line

# Keep a mapping from token index to line number
# It's easier to just match line by line
stack = []
for i, line in enumerate(lines):
    # Remove strings
    line = re.sub(r'"(.*?)"', '', line)
    line = re.sub(r"'(.*?)'", '', line)
    line = re.sub(r'--.*', '', line)
    tokens = re.findall(r'\b(function|if|for|while|repeat|do|end|until)\b', line)
    
    for idx, t in enumerate(tokens):
        if t in ['function', 'if', 'for', 'while', 'repeat']:
            stack.append((t, i+1))
        elif t == 'do':
            if idx > 0 and tokens[idx-1] in ['while', 'for']:
                pass
            else:
                stack.append((t, i+1))
        elif t in ['end', 'until']:
            if len(stack) > 0:
                stack.pop()
            else:
                print('Unmatched', t, 'at line', i+1)

print('Remaining on stack:', stack)
