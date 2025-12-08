# ÖRU Thesis - Quarto Typst Format

This is a Quarto extension created to reproduce Örebro University (ÖRU) thesis PDF templating. The official ÖRU thesis template is a MS Word document that needs to be converted to PDF (see `official-oru-thesis-template` directory). This Quarto extension is an attempt to reproduce ÖRU thesis PDF applying ÖRU formatting guidelines using Quarto and Typst.

## Features

The extension attempts **ÖRU-compliant formatting** and follows Örebro University thesis style guidelines.

## Installation and usage

To use this extension in your (empty) Quarto project:

```bash
quarto use template jsbam/oru-thesis-quarto-template
```

will install the extension in your project directory and provide a `thesis.qmd` file as a starting point. After installing the extension, `quarto render thesis.qmd` will produce `thesis.pdf` file.

To only use the typst format in your Quarto project:

```bash
quarto add jsbam/oru-thesis-quarto-template
```

will add the `_extensions/` folder to your project directory. You can also copy the `_extension/` folder in Quarto project directory. In order to use the extension, make sure you specify  `format: oru-thesis-template-typst` your quarto document yaml front matter.

## Multi-file project setup

As of October 2025, typst format only supports single file documents/projects. To use a multi-file project/report/thesis, you can use quarto shortcodes `{{< include "file-name.qmd" >}}`. Below is an example using `{{< include "01-introduction.qmd" >}}`, `{{< include "02-methods.qmd" >}}`, `{{< include "03-results.qmd" >}}`, and `{{< include "04-conclusion.qmd" >}}`:

```yaml
---
title: "Thesis Title"
subtitle: "Subtitle"
author: "Author Name"
dept: "Department Name"
year: "2025"
month: "December"
day: "4"

abstract: |
    Your abstract here.

keywords:
  - Keyword One
  - Keyword Two
  - Up to max Ten

dedication: |
  Dedication/thanks to. This page is optional.

list-of-papers: |
  This thesis is based on the following studies, referred to in the text by their Roman numerals.
  
  1. Use the style sheet ORU_List of Papers. If not needed, the page should be deleted.
  
  2. LastName, FirstName, 2021. "Title of article. And possible subtitle". *Name of journal*, 1:1, 90–95 [volume, number and pages].
  
  3. Article/Study 3
  
  Reprints were made with permission from the respective publishers.

committee:
  - name: "Committee Member 1"
    title: "Ph.D."
  - name: "Committee Member 2"
    title: "Ph.D."
  - name: "Committee Member 3"
    title: "Ph.D."

bibliography: reference.bib
csl: vancouver-author-date.csl
reference-section-title: "Cited Works"

format:
  oru-thesis-template-typst:
---

{{< include "01-introduction.qmd" >}}

{{< include "02-methods.qmd" >}}

{{< include "03-results.qmd" >}}

{{< include "04-conclusion.qmd" >}}

```

### Customizing Bibliography Title

The default bibliography title is `References`, but the extension supports user-defined bibliography title by setting the `reference-section-title: "..."` field in the yaml header.

## Required Files and Setup


### Files Automatically Provided

If you install the extension, it will automatically set up the necessary files for you to test the extension. These files are ÖRO logo (`oru-logo-mono.svg`), a bibliography file (`references.bib`), and a reference style (`vancouver.csl` for numbered bibliography and `vancouver-author-date.csl` for unnumbered bibliography as per ÖRU thesis template guideline).

If you manually add the `_extensions/` folder to your project or with `quarto add jsbam/oru-thesis-quarto-template`, make sure to provide a .bib file and .csl file in your document's yaml header if your document contain '@' citation. An '@' inline citation without `bibliography: ` and `csl: ` set in yaml header will fail to render. After your first quarto render with the extension set as format, the files  `vancouver.csl` and `vancouver-author-date.csl` will be copied in your project directory.

>[!Tips]
>The logo and CSL files are automatically copied from `_extensions/oru-thesis-template/` to your project root when you first render. You don't need to copy them manually!
>If you manually add the extension, render a simple Quarto document with `format: oru-thesis-template`, which will copy `vancouver.csl`, `vancouver-author-date.csl`, and `oru-logo-mono.csl`. You can later build upon this document to experiment how the extension works.
>

csl styles can be downloaded from [Zotero Style Repository](https://www.zotero.org/styles) (2000+ styles) or [Citation Style Language GitHub](https://github.com/citation-style-language/styles).

### Default Citation Styles Included

The extension includes two Vancouver styles by default:

1. **`vancouver.csl`** (default)
   - Numbered inline citations (1), (2,3)
   - References in bibliography numbered in order of appearance
2. **`vancouver-author-date.csl`**
   - Author-date citations: (Smith 2020), (Smith 2020; Johnson 2021)
   - Unnumbered references in bibliography alphabetically ordered

### Fonts

The template requires the following fonts:

- **Trade Gothic Next** (and **Trade Gothic Next HvyCd**)
- **Sabon Next**

Ensure these fonts are installed on your system before rendering.

## Structure

The thesis document includes the following sections in order:

1. **Title page**: University name, logo, author, title, and subtitle
2. **Copyright/Publication page**: Author, publisher, ISBN information
3. **Abstract page**: Abstract text with keywords in a formatted box
4. **Dedication page** (optional): If `dedication` is provided
5. **Table of contents**: Automatically generated
6. **List of papers** (optional): If `list-of-papers` is provided
7. **Main content**: Your thesis chapters and sections
8. **References**: Automatically formatted with customizable title

## Rendering

Render your document using:

```bash
quarto render thesis.qmd
```

Or:

```bash
quarto render thesis.qmd --to oru-thesis-template-typst
```

## Example Content

See `thesis.qmd` for a complete working example. The file include the content of [ÖRU thesis template in MS Word](https://www.oru.se/english/study/doctoral-studies/thesis-production/structure/guide-avhandlingsmallen2/).

## Customization

### Page Layout

The template uses:

- Page size: 157mm × 223mm
- Margins: Top 1.8cm, Bottom 2.5cm, Inside 2.5cm, Outside 1.8cm
- Font size: 11pt
- Line spacing: 0.73em leading

### Heading Styles

- **H1**: 16pt, Trade Gothic Next HvyCd, numbered (1, 2, 3...)
- **H2**: 13pt, Trade Gothic Next HvyCd, numbered (1.1, 1.2...)
- **H3**: 13pt, Trade Gothic Next HvyCd (gray), numbered (1.1.1...)
- **H4**: 12pt, Trade Gothic Next, numbered (1.1.1.1...)

## Project Structure

### After Installation

```
your-project-directory/
├── _extensions/
│   └── oru-thesis/              # Extension folder
│       ├── _extension.yml       # Extension configuration
│       ├── typst-template.typ   # ÖRU thesis template
│       ├── typst-show.typ       # Quarto-Typst bridge
│       ├── oru-logo-mono.svg    # Örebro logo (auto-copied)
│       ├── vancouver.csl        # Citation style (auto-copied)
│       └── vancouver-author-date.csl  # Alt citation style (auto-copied)
├── your-thesis.qmd              # Your thesis document
├── your-reference.bib           # Your bibliography (YOU CREATE)
├── oru-logo-mono.svg            # Auto-copied on first render
├── vancouver.csl                # Auto-copied on first render
├── vancouver-author-date.csl    # Auto-copied on first render
└── media/                       # Optional: for images
```

## Troubleshooting

### Missing Fonts

**Error**: Font not found errors

**Solution**: Install the required fonts:

- **Trade Gothic Next** (including HvyCd variant)
- **Sabon Next**

These are commercial fonts used by Örebro University. Contact your IT department if you don't have them.

### Logo Not Found

**Error**: `file not found: oru-logo-mono.svg`

**Solution**: The logo should auto-copy on first render. If it doesn't:

1. Check that `oru-logo-mono.svg` exists in `_extensions/oru-thesis-template/`
2. Manually copy it: `cp _extensions/oru-thesis-template/oru-logo-mono.svg .`
3. Re-render: `quarto render your-thesis.qmd`

### CSL File Not Found

**Error**: `file not found: vancouver.csl` (or other CSL file)

**Solution**:

- If using default Vancouver: Should auto-copy on render
- If using custom CSL: Ensure the `.csl` file is in your project root
- Check the filename matches your YAML: `csl: filename.csl`

### Bibliography Not Appearing

**Error**: No references section in output

**Check**:

1. `bibliography: reference.bib` or your custom .bib is in your YAML
2. `reference.bib` file exists in your project root
3. You have citations in your text: `[@Smith2020]`
4. Citation keys in text match entries in `.bib` file

>[!NOTE]
>Efter the extension automatically add Bibliography at the end of the document, manually adding another #bibliography() call in the document will cause an error when renderig the document.
>

### Custom Bibliography Title Not Working

**Error**: Bibliography shows "References" instead of custom title

**Solution**: Use `reference-section-title` (not `bibliography-title`):

```yaml
reference-section-title: "Your Custom Title"
```

## License

This template was created for personal use.
