# ORU Thesis Quarto Extension - Usage Guide

## Quick Start

1. **Create your thesis document** (`my-thesis.qmd`):

```yaml
---
title: "Your Thesis Title"
subtitle: "Your Subtitle"
author: "Your Name"
year: "2025"

abstract: |
  Your abstract here.

keywords:
  - Keyword 1
  - Keyword 2

bibliography: reference.bib
reference-section-title: "References"  # ← Customize this!

format:
  oru-thesis-template-typst: default
---

# Your First Chapter

Your content here...
```

2. **Render your document**:

```bash
quarto render my-thesis.qmd
```

## Customizing the Bibliography Title

The extension **fully supports user-defined bibliography titles** through the `reference-section-title` field in your YAML metadata:

### Examples:

```yaml
# English (numbered)
reference-section-title: "References"

# English (alternative)
reference-section-title: "Bibliography"
reference-section-title: "Works Cited"
reference-section-title: "References with Numbers"

# Swedish
reference-section-title: "Referenser"
reference-section-title: "Litteraturförteckning"

# Other languages
reference-section-title: "Bibliographie"  # French
reference-section-title: "Literatur"     # German
```

### How It Works

The template includes this parameter in `typst-template.typ`:

```typst
#let thesis(
  ...
  reference-title: [References],  // default value
  ...
) = {
  ...
  // Sets the bibliography title
  set bibliography(title: reference-title)
  ...
}
```

And `typst-show.typ` passes the YAML value:

```typst
$if(reference-section-title)$
  reference-title: [$reference-section-title$],
$endif$
```

## Complete Example with Custom Bibliography Title

```yaml
---
title: "Health Outcomes in Swedish Populations"
subtitle: "A Longitudinal Study"
author: "Anna Andersson"
dept: "School of Medical Sciences"
year: "2025"
month: "December"
day: "15"

abstract: |
  This thesis examines health outcomes in Swedish populations
  over a 10-year period, focusing on chronic disease prevalence
  and healthcare utilization patterns.

keywords:
  - Public health
  - Sweden
  - Chronic disease
  - Healthcare utilization

dedication: |
  To my family and colleagues who supported this research.

list-of-papers: |
  This thesis is based on the following papers:
  
  I. Andersson, A., 2024. "Health trends in Sweden". 
     *Scandinavian Journal of Public Health*, 52:3, 234–245.
  
  II. Andersson, A., et al., 2025. "Chronic disease patterns".
      *European Journal of Epidemiology*, 40:1, 12–28.

# Bibliography with custom Swedish title
bibliography: reference.bib
csl: vancouver.csl
reference-section-title: "Litteraturförteckning"

format:
  oru-thesis-template-typst: default
---

# Introduktion

Detta är första kapitlet...

## Bakgrund

More content here...

# Metod

Describe your methods...

# Resultat

Present your results...

# Diskussion

Discuss findings...
```

## File Structure for Your Project

```
my-thesis-project/
├── my-thesis.qmd           # Your main document
├── reference.bib           # Your bibliography
├── vancouver.csl           # Citation style (copy from extension)
├── oru-logo-mono.svg      # ORU logo (copy from extension)
├── media/                  # Images directory
│   └── figure1.png
└── _extensions/
    └── oru-thesis/         # The extension (copy or install)
        ├── _extension.yml
        ├── typst-template.typ
        ├── typst-show.typ
        └── ...
```

## Tips

1. **Required files in project root**:
   - `oru-logo-mono.svg`
   - `vancouver.csl` (or your chosen CSL)
   - `reference.bib`

2. **Citations**: Use `[@citation-key]` in your text

3. **Multiple CSL options**:
   - `vancouver.csl` - numbered citations
   - `vancouver-author-date.csl` - author-date citations

4. **Optional sections**:
   - Set `dedication: null` to skip dedication page
   - Set `list-of-papers: null` to skip papers list

## Testing Different Bibliography Titles

You can quickly test different titles:

```bash
# Test English title
quarto render my-thesis.qmd

# Edit YAML to Swedish title, then:
quarto render my-thesis.qmd

# Compare the PDFs!
```

## Troubleshooting

**Bibliography title not showing up?**
- Check that `reference-section-title` is spelled correctly in YAML
- Ensure you have citations in your text (e.g., `[@Smith2020]`)
- Verify `reference.bib` exists and contains the cited entries

**Logo not found?**
- Copy `oru-logo-mono.svg` to your project root
- Or update the path in `typst-template.typ` line 269

**Fonts not available?**
- Install Trade Gothic Next and Sabon Next fonts
- Or modify font settings in `typst-template.typ` lines 40-47

## Support

For issues or questions about the extension:
1. Check the main README.md
2. Review the template.qmd example
3. Verify all required files are in place
