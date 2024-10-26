import re

def clean_annotation(match):
    annotation = match.group(1)
    # Initialize a dictionary to store the extracted values
    values = {}
    # Search and extract each value
    for key in ["q1", "q2", "q3", "pp1"]:
        result = re.search(rf"{key}=([0-9\.]+);?", annotation)
        values[key] = round(float(result.group(1)), 3)

    # Format the string to return the modified annotation
    return f"'[q1={values['q1']};q2={values['q2']};q3={values['q3']};pp1={values['pp1']}]'"

# input tree data (changable)
tree_data = ""
cleaned_tree = re.sub(r"'\[(.*?)\]'", clean_annotation, tree_data)

print(cleaned_tree)

