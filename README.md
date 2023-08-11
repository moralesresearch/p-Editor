# p-Editor: Feature-Rich Text Editor in Pascal

p-Editor is a powerful text editor written in Pascal. It provides users with a feature-rich environment for creating, editing, and formatting text files. This documentation explains how to use the program, its features, and advanced capabilities.

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
3. [Basic Usage](#basic-usage)
4. [Advanced Usage](#advanced-usage)
5. [Examples](#examples)
6. [Frequently Asked Questions (FAQ)](#faq)

## Introduction <a name="introduction"></a>

**Purpose of the Program:**

p-Editor aims to enhance the text editing experience by providing the following features:

- Create new files or open existing ones.
- Save files and save files with new names.
- Apply styling options: Bold, Italics, Title, Subtitle, Heading.
- Perform spell checks and suggest adding unknown words to the dictionary.
- Toggle a ruler for better alignment.
- Navigate through the document using arrow keys.
- Multiline scrolling for large files.
- Line numbering for easy reference.

**Copyright Information:**  
Copyright © 2023 Morales Research Inc

## Getting Started <a name="getting-started"></a>

**System Requirements:**

- A Unix/Linux environment
- Free Pascal Compiler (Version 3.2.2 or later)

**Compiling and Running the Program:**

1. Open a terminal.
2. Navigate to the directory containing `pEditor.pas`.
3. Compile the program using the following command:

```shell
fpc pEditor.pas

1. Run the compiled program:
```shell
./pEditor

Loading the Dictionary:

The program uses a dictionary file (dictionary.txt) to assist with spell checks. If the dictionary file is missing, the program will prompt you to generate a new empty dictionary file or bypass the requirement. You can customize the dictionary by editing the dictionary.txt file.
Basic Usage <a name="basic-usage"></a>

Commands:

    N: Create a new empty file.
    O: Open an existing file.
    S: Save the current file.
    A: Save the current file with a new name.
    Q: Quit the program.
    Arrow keys: Navigate through the document.
    I: Insert text at the cursor position.
    DEL: Delete the character at the cursor position.

File Management:

    N: Create a new empty file.
    O: Open an existing file.
    S: Save the current file.
    A: Save the current file with a new name.

Cursor Movement:

    Arrow keys: Move the cursor up, down, left, or right.

Text Styling:

    B: Apply bold style.
    I: Apply italics style.
    T: Apply title style.
    S: Apply subtitle style.
    H: Apply heading style.

Spell Check:

    C: Perform a spell check on the current file.

Toggling the Ruler:

    R: Toggle the ruler display.

Troubleshooting:

If the program doesn't find the dictionary file (dictionary.txt), it will prompt you to generate a new empty dictionary file or bypass the requirement.
Advanced Usage <a name="advanced-usage"></a>

Working with Styles:

You can apply various styles to the text, including bold, italics, title, subtitle, and heading styles. Styles are applied to the entire line.

Customizing the Dictionary:

The dictionary is loaded from the file dictionary.txt. You can customize the dictionary by adding or removing words from this file. The program will suggest adding unknown words to the dictionary during spell checks.

Multiline Scrolling:

The program supports multiline scrolling for larger files. You can use the arrow keys to navigate through the document, and the program will automatically adjust the scroll position.

Line Numbering:

Line numbering is displayed in the editor, making it easy to reference specific lines in the document.

Keyboard Shortcuts:

The program supports various keyboard shortcuts for common operations, such as navigation and styling.

Dealing with Spelling Errors:

If the spell check encounters words not found in the dictionary, the program will suggest adding these words to the dictionary.

Performance Considerations:

For very large files, the program's performance may be impacted. It's recommended to use the program for editing reasonably sized text files.
Examples <a name="examples"></a>

Sample Text Files:

The program can be used to create, open, and edit text files. You can experiment with various styling options and see how the program handles different files.

Applying Styles:

You can apply different styles (bold, italics, title, etc.) to the text in the editor. Try applying styles and saving the file to see how the styles are preserved.

Using the Dictionary:

During the spell check, the program may suggest adding unknown words to the dictionary. You can choose to add these words to the dictionary for future reference.
Frequently Asked Questions (FAQ) <a name="faq"></a>

Common Issues:

This section covers common issues that users may encounter and provides solutions.

Additional Tips:

Useful tips and tricks for making the most out of the p-Editor program.

This documentation provides a structured overview of the p-Editor program, its features, usage, and advanced capabilities. It helps users understand how to work with the program and provides guidance on handling various scenarios.