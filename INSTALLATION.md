# ORU Thesis Extension - Installation & Configuration

## Quick Answer to Your Questions

### Q1: Does the logo need to be in working directory or `_extensions/oru-thesis-template/`?

**Answer**: The logo is stored in `_extensions/oru-thesis-template/` and **automatically copied** to your working directory when you render.

- ✅ Keep logo in: `_extensions/oru-thesis-template/oru-logo-mono.svg`
- ✅ Quarto auto-copies to: `./oru-logo-mono.svg` (on first render)
- ❌ No manual copying needed!

### Q2: What if users have their own reference style (not Vancouver)?

**Answer**: Users can easily use any CSL style they want!

**Method 1: Use Included Alternative**
```yaml
csl: vancouver-author-date.csl  # Author-date instead of numbered
```

**Method 2: Use Any Other Style**
1. Download CSL from [Zotero Style Repository](https://www.zotero.org/styles)
2. Place in project root
3. Reference in YAML:
```yaml
csl: apa.csl
# OR
csl: chicago-author-date.csl
# OR
csl: nature.csl
```

## How It Works

### Automatic Resource Copying

The extension uses `format-resources` in `_extension.yml`:

```yaml
format-resources:
  - oru-logo-mono.svg
  - vancouver.csl
  - vancouver-author-date.csl
```

When you run `quarto render`, these files are **automatically copied** from `_extensions/oru-thesis-template/` to your project root.

### File Locations Explained

#### Extension Directory (`_extensions/oru-thesis-template/`)
- **Purpose**: Master copies and template code
- **Contents**:
  - `typst-template.typ` - ORU thesis template
  - `typst-show.typ` - Quarto metadata bridge
  - `oru-logo-mono.svg` - University logo (master copy)
  - `vancouver.csl` - Citation style (master copy)
  - `_extension.yml` - Configuration

#### Project Root (Working Directory)
- **Purpose**: Active files used during compilation
- **Auto-copied** on render:
  - `oru-logo-mono.svg` ← from extension
  - `vancouver.csl` ← from extension
  - `vancouver-author-date.csl` ← from extension
- **User creates**:
  - `reference.bib` - Your bibliography
  - `your-thesis.qmd` - Your document
  - `custom-style.csl` - Optional: custom citation style

## Installation Steps

### For a New Thesis Project

1. **Install the extension**:
```bash
quarto add /path/to/oru-thesis
```

2. **Create your document** (`my-thesis.qmd`):
```yaml
---
title: "My Thesis Title"
author: "Your Name"
year: "2025"

abstract: |
  Your abstract here.

bibliography: reference.bib
csl: vancouver.csl  # or vancouver-author-date.csl or your-custom.csl
reference-section-title: "References"

format:
  oru-thesis-template-typst: default
---

# Introduction

Your content here with citations [@Smith2020].
```

3. **Create your bibliography** (`reference.bib`):
```bibtex
@article{Smith2020,
  author = {Smith, John},
  title = {Article Title},
  journal = {Journal Name},
  year = {2020}
}
```

4. **Render**:
```bash
quarto render my-thesis.qmd
```

On first render, Quarto will automatically copy:
- `oru-logo-mono.svg`
- `vancouver.csl`
- `vancouver-author-date.csl`

## Using Custom Bibliography Settings

### Custom Bibliography File
```yaml
bibliography: my-papers.bib  # Your own file
```

### Custom Citation Style
```yaml
# Download APA style from Zotero
csl: apa.csl  # Must be in project root
```

### Custom Bibliography Title
```yaml
reference-section-title: "Litteraturförteckning"  # Swedish
# OR
reference-section-title: "Bibliography"  # Alternative English
```

### Complete Custom Example
```yaml
---
title: "Machine Learning in Healthcare"
author: "Anna Svensson"
year: "2025"

bibliography: ml-healthcare-refs.bib
csl: ieee.csl
reference-section-title: "Referenser"

format:
  oru-thesis-template-typst: default
---
```

Just ensure `ml-healthcare-refs.bib` and `ieee.csl` are in your project root!

## Summary

✅ **Logo**: Stored in extension, auto-copied to project
✅ **Default CSL**: vancouver.csl (auto-copied)
✅ **Alternative CSL**: vancouver-author-date.csl (auto-copied)
✅ **Custom CSL**: Download any style, place in project root
✅ **Bibliography**: User creates their own `.bib` file
✅ **Bibliography Title**: Fully customizable via `reference-section-title`

No manual file copying needed for extension resources! 🎉
