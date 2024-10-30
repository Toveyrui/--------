import argparse

def insert_css(html_path, output_path):
    css_style = """
    <style>
        @media print {
            @page {
                size: A4;
                margin: 20mm;
            }
            body {
                margin: 0;
                padding: 0;
            }
            .content {
                border: 1px solid black;
                padding: 10mm;
                margin: 0;
            }
        }
    </style>
    """

    with open(html_path, 'r', encoding='utf-8') as file:
        html_content = file.read()

    # Insert the CSS after the <head> tag
    head_index = html_content.find('<head>')
    if head_index != -1:
        head_index += len('<head>')
        html_content = html_content[:head_index] + css_style + html_content[head_index:]

    with open(output_path, 'w', encoding='utf-8') as file:
        file.write(html_content)

def main():
    parser = argparse.ArgumentParser(description='Insert CSS into an HTML file.')
    parser.add_argument('input_file', type=str, help='Path to the input HTML file.')
    parser.add_argument('output_file', type=str, help='Path to the output HTML file.')
    
    args = parser.parse_args()
    insert_css(args.input_file, args.output_file)

if __name__ == "__main__":
    main()
