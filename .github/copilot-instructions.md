# Copilot Instructions for BenBox

Dearest Copilot,
this project is the **Data Science and Data Analytics** course material for students of the Fresenius University of Applied Sciences.

**Logic**

Quarto course materials are rendered to HTML:

- [DrBenjamin/Data-Science-and-Data-Analytics](https://github.com/DrBenjamin/Data-Science-and-Data-Analytics)

The Page is build via Jekyll and GitHub Pages through Github Actions.
The HTML files are fetched and updated via a GitHub Actions workflow.

When generating code snippets or explanations, please follow these guidelines:

1. Output always in Markdown.
2. When referring to a file in this repo, link using `#file:<relative_path>`.
   - Quarto file: [Data_Science_and_Data_Analytics.qmd](#file:Data_Science_and_Data_Analytics.qmd)
   - Readme: [README.md](#file:README.md)
3. Code‑block format for changes or new files:
   ````python
   // filepath: #file:<relative_path>
   # ...existing code...
   def my_new_function(...):
       ...
   # ...existing code...
   ````
4. Comments and code formatting rules:
   - Always import modules at the top of the file.
   - Use `#` for comments.
   - Start comments with 'Setting', 'Creating', 'Adding', 'Updating' etc.
     (always the gerund form) and before it add an empty line if not the
     beginning of a code block or function.
   - empty lines between functions use 2 lines empty lines and don't fill
     empty lines with spaces.
5. Adhere to PEP 8:
   - 4‑space indentation, snake_case names.
   - Imports at the top of the file.
   - Docstrings in Google or NumPy style.
