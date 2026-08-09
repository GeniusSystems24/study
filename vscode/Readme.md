# VS Code Search & Replace Dictionaries

A compact documentation set for mastering **Search**, **Regular Expressions (Regex)**, and **Replace / Replace All** in Visual Studio Code. The guides are especially useful for codebases using Dart/Flutter, but most patterns are language-agnostic.

## Documentation Index

| Section | English | Arabic | Description |
|---|---|---|---|
| Search & Regex | [Open](search/Readme.md) | [فتح النسخة العربية](search/Readme_ar.md) | Search syntax, Regex rules, file filters, Glob patterns, and practical code-search recipes. |
| Replace | [Open](replace/Readme.md) | [فتح النسخة العربية](replace/Readme_ar.md) | Capture groups, replacements, case transformations, refactoring recipes, and Replace All safety practices. |

## Folder Structure

```text
vscode/
├── Readme.md
├── Readme_ar.md
├── assets/
│   └── vscode-regex-search-poster.png
├── search/
│   ├── Readme.md
│   └── Readme_ar.md
└── replace/
    ├── Readme.md
    └── Readme_ar.md
```

## Recommended Usage

Start with the **Search & Regex** guide to learn how to locate identifiers, code patterns, imports, file groups, and architecture violations. Then use the **Replace** guide for safe bulk transformations, refactoring, suffix/prefix changes, capture-group based replacements, and path updates.

Before using **Replace All** across a project, always inspect the preview, restrict the file scope, exclude generated files, and create a Git commit.

![VS Code Regex Search Poster](assets/vscode-regex-search-poster.png)
