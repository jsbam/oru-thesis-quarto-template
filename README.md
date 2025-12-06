# ÖRU Thesis - Quarto Typst Format

This is a Quarto extension created to reproduce Örebro University (ÖRU) thesis PDF templating. The official ÖRU thesis template is a MS Word document that needs to be converted to PDF (see `offical-oru-thesis-template` directory). This Quarto extension is an attempt to reproduce ÖRU thesis PDF applying ÖRU formatting guidelines using Quarto and Typst.

## Features

The extension attempts **ÖRU-compliant formatting** and follows Örebro University thesis style guidelines.

## Installation

To use this extension in your (empty) Quarto project:

``` bash
quarto use template jsbam/oru-thesis-quarto-template
```

will clone the repository in your project directory with `thesis.qmd` file as a starting point. After installing the extension, `quarto render thesis.qmd` with produce `thesis.pdf` file.

Or if you want to only use the format in your Quarto project:

``` bash
quarto add jsbam/oru-thesis-quarto-template
```

will add the `_extensions/oru-thesis-template` folder to your project directory.

## Usage

Once you have installed the extension, you will see a `thesis.qmd` file in your project directory. Rendering the `thesis.qmd` will produce a PDF formatted according to ÖRU thesis guidelines.

## Multi-file project setup

As typst format only supports single file documents/projects, to create a multi-file project, you can use quarto shortcodes `{{< include "file-name.qmd" >}}` such as `{{< include "01-introduction.qmd" >}}`, `{{< include "02-methods.qmd" >}}`, `{{< include "03-results.qmd" >}}`, and `{{< include "04-conclusion.qmd" >}}`:

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
    This is fictitious abstract regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

    Regarding the scientific literature on the association between obesity and type 2 diabetes millets. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

    Regarding the scientific literature on the association between obesity and type 2 diabetes mellites. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

    The mechanisms explaining these associations? Please add refer regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI. The mechanisms explaining these associations? Please add refer regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI.

keywords:
  - Health literacy
  - Chronic diseases
  - Diabetes
  - Obesity
  - Hypertension
  - Cardiovascular disease
  - Diabetes mellitus
  - Obesity
  - Cardiovascular disease
  - Diabetes mellitus
  - Diabetes mellitus
  - Obesity
  - Card. Is even last line.
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

# Bibliography settings - user can customize the reference title
bibliography: reference.bib
csl: vancouver-author-date.csl
reference-section-title: "Cited Works"

format:
  oru-thesis-template-typst:
    keep-typ: true
---

{{< include "01-introduction.qmd" >}}

{{< include "02-methods.qmd" >}}

{{< include "03-results.qmd" >}}

{{< include "04-conclusion.qmd" >}}

```

### Customizing Bibliography Title

The extension supports user-defined bibliography titles through the `reference-section-title` field:

``` yaml
# Default
reference-section-title: "References"

# Custom titles
reference-section-title: "Bibliography"
reference-section-title: "References with Numbers"
reference-section-title: "Litteraturförteckning"  # Swedish
```

## Required Files and Setup

If you install the extension, it will automatically set up the necessary files for you. But if you manually add the `_extensions/oru-thesis-template/` folder to your project or with `quarto add jsbam/oru-thesis-quarto-template`, you need to ensure the following files are present.

### Files Automatically Provided

When you render your document, Quarto **automatically copies** these files from the extension to your project directory:

1. **`oru-logo-mono.svg`** - Örebro University logo (no action needed)
2. **`vancouver.csl`** - Default citation style (numbered)
3. **`vancouver-author-date.csl`** - Alternative citation style (author-date)

### Files You Must Provide

**`reference.bib`** - Your bibliography file with citations

- Create this file in your project root

- Add your references in BibTeX format

- Example:

``` bibtex
@article{Smith2020,
  author = {Smith, John},
  title = {Article Title},
  journal = {Journal Name},
  year = {2020},
  volume = {10},
  pages = {1--10}
}
```

### Using Custom Bibliography and Citation Styles

#### Use Your Own `.bib` File

Simply specify your bibliography file in the YAML:

``` yaml
bibliography: my-references.bib  # Use your own file
```

#### Use Your Own `.csl` Style

To use a different citation style (other than Vancouver):

1.  **Download** a CSL file from:

    -   [Zotero Style Repository](https://www.zotero.org/styles) (2000+ styles)
    -   [Citation Style Language GitHub](https://github.com/citation-style-language/styles)

2.  **Place** the `.csl` file in your project root

3.  **Specify** it in your YAML:

    ``` yaml
    csl: apa.csl                     # APA style
    # OR
    csl: chicago-author-date.csl     # Chicago author-date
    # OR
    csl: nature.csl                  # Nature journal
    # OR
    csl: harvard-cite-them-right.csl # Harvard
    ```

#### Example: Using APA Style with Custom Title

``` yaml
---
title: "My Thesis"
author: "Your Name"
year: "2025"

# Custom bibliography setup
bibliography: my-thesis-references.bib
csl: apa.csl
reference-section-title: "References"  # or "Bibliography"

format:
  oru-thesis-template-typst: default
---
```

### Default Citation Styles Included

The extension includes two Vancouver styles by default:

1.  **`vancouver.csl`** (default)

    -   Numbered inline citations (1), (2,3)
    -   References in bibliography numbered in order of appearance

2.  **`vancouver-author-date.csl`**

    -   Author-date citations: (Smith 2020), (Smith 2020; Johnson 2021)
    -   Unnumbered references in bibliography alphabetically ordered

### Fonts

The template requires the following fonts:

-   **Trade Gothic Next** (and Trade Gothic Next HvyCd)
-   **Sabon Next**

Ensure these fonts are installed on your system before rendering.

## Structure

The thesis document includes the following sections in order:

1.  **Title page**: University name, logo, author, title, and subtitle
2.  **Copyright/Publication page**: Author, publisher, ISBN information
3.  **Abstract page**: Abstract text with keywords in a formatted box
4.  **Dedication page** (optional): If `dedication` is provided
5.  **Table of contents**: Automatically generated
6.  **List of papers** (optional): If `list-of-papers` is provided
7.  **Main content**: Your thesis chapters and sections
8.  **References**: Automatically formatted with customizable title

## Rendering

Render your document using:

``` bash
quarto render template.qmd
```

Or:

``` bash
quarto render template.qmd --to oru-thesis-template-typst
```

## Example Content

See `template.qmd` for a complete working example with:

-   Multiple heading levels
-   Lists (bulleted and numbered)
-   Citations
-   Mathematical equations
-   Figure references

## Customization

### Page Layout

The template uses:

-   Page size: 157mm × 223mm
-   Margins: Top 1.8cm, Bottom 2.5cm, Inside 2.5cm, Outside 1.8cm
-   Font size: 11pt
-   Line spacing: 0.73em leading

### Heading Styles

-   **H1**: 16pt, Trade Gothic Next HvyCd, numbered (1, 2, 3...)
-   **H2**: 13pt, Trade Gothic Next HvyCd, numbered (1.1, 1.2...)
-   **H3**: 13pt, Trade Gothic Next HvyCd (gray), numbered (1.1.1...)
-   **H4**: 12pt, Trade Gothic Next, numbered (1.1.1.1...)

## Project Structure

### After Installation

```         
your-thesis-project/
├── _extensions/
│   └── oru-thesis/              # Extension folder
│       ├── _extension.yml       # Extension configuration
│       ├── typst-template.typ   # ÖRU thesis template
│       ├── typst-show.typ       # Quarto-Typst bridge
│       ├── oru-logo-mono.svg    # Örebro logo (auto-copied)
│       ├── vancouver.csl        # Citation style (auto-copied)
│       └── vancouver-author-date.csl  # Alt citation style (auto-copied)
├── your-thesis.qmd              # Your thesis document
├── reference.bib                # Your bibliography (YOU CREATE)
├── oru-logo-mono.svg           # Auto-copied on first render
├── vancouver.csl                # Auto-copied on first render
├── vancouver-author-date.csl   # Auto-copied on first render
└── media/                       # Optional: for images
```

**Note**: The logo and CSL files are automatically copied from `_extensions/oru-thesis-template/` to your project root when you first render. You don't need to copy them manually!

## Troubleshooting

### Missing Fonts

**Error**: Font not found errors

**Solution**: Install the required fonts:

-   **Trade Gothic Next** (including HvyCd variant)
-   **Sabon Next**

These are commercial fonts used by Örebro University. Contact your IT department if you don't have them.

### Logo Not Found

**Error**: `file not found: oru-logo-mono.svg`

**Solution**: The logo should auto-copy on first render. If it doesn't:

1.  Check that `oru-logo-mono.svg` exists in `_extensions/oru-thesis-template/`
2.  Manually copy it: `cp _extensions/oru-thesis-template/oru-logo-mono.svg .`
3.  Re-render: `quarto render your-thesis.qmd`

### CSL File Not Found

**Error**: `file not found: vancouver.csl` (or other CSL file)

**Solution**:

-   If using default Vancouver: Should auto-copy on render
-   If using custom CSL: Ensure the `.csl` file is in your project root
-   Check the filename matches your YAML: `csl: filename.csl`

### Bibliography Not Appearing

**Error**: No references section in output

**Check**:

1.  `bibliography: reference.bib` is in your YAML
2.  `reference.bib` file exists in your project root
3.  You have citations in your text: `[@Smith2020]`
4.  Citation keys in text match entries in `.bib` file

### Custom Bibliography Title Not Working

**Error**: Bibliography shows "References" instead of custom title

**Solution**: Use `reference-section-title` (not `bibliography-title`):

``` yaml
reference-section-title: "Your Custom Title"
```

### Using Custom CSL with Non-Vancouver Style

**Question**: Can I use APA/Chicago/Nature style?

**Answer**: Yes! Just:

1.  Download the CSL file from [Zotero Styles](https://www.zotero.org/styles)
2.  Place it in your project root
3.  Update YAML: `csl: apa.csl` (or whatever style you chose)

## License

This template follows Örebro University formatting guidelines.

## Credits

Created for Örebro University thesis submissions using Quarto and Typst.