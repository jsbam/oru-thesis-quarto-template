// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}

#let TOC_Heading(content, spacing: 18pt) = [
  #text(16pt, font: "Trade Gothic Next HvyCd")[#content]
]
#let ORU_H1_Heading_1(content) = text(font: "Trade Gothic Next HvyCd")[#content]
#let ORU_H2_Heading_2(content) = text(font: "Trade Gothic Next HvyCd")[#content]
#let ORU_H3_Heading_3(content) = text(font: "Trade Gothic Next HvyCd", fill: rgb(101, 101, 108))[#content]
#let ORU_H4_Heading_4(content) = text(font: "Trade Gothic Next")[#content]

#let iuquote(body) = {
  set par(leading: 0.65em)
  pad(x: 30pt, y: 15pt, body)
}

#let thesis(
  title: none,
  subtitle: none,
  author: none,
  dept: none,
  year: none,
  month: none,
  day: none,
  committee: (),
  dedication: none,
  acknowledgement: [],
  abstract: [],
  keywords: [],
  list-of-papers: [],
  reference-title: [References],
  doc,
) = {
  // global settings
  set text(
    lang: "en",
    font: "Sabon Next",
    size: 11pt,
    weight: "regular",
    hyphenate: true,
    tracking: 0.0em,
  )
  set par(
    leading: 0.73em,
    first-line-indent: 0em,
    justify: false,
    spacing: 1.5em,
  )

  let page-nr = [#context here().page()]
  let is-odd-page() = calc.rem(counter(page).get().first(), 2) == 1
  
  // Set initial page settings with NO page numbering for front matter
  set page(
    width: 157mm,
    height: 223mm,
    margin: (
      top: 1.8cm,
      bottom: 2.5cm,
      inside: 2.5cm,
      outside: 1.8cm,
    ),
    numbering: none,  // No page numbers on front matter
    footer: none,     // No footer on front matter
  )
  show math.equation: it => {
    if it.has("label") {
      math.equation(
        block: true,
        numbering: it1 => (
          context {
            let count = counter(heading.where(level: 1)).get()
            numbering("(1.1)", count.at(0), it1)
          }
        ),
        it,
      )
    } else {
      it
    }
  }
  show ref: it => {
    let el = it.element
    if el != none and el.func() == math.equation {
      link(
        el.location(),
        [Eq.~#context {
            let count = counter(heading.where(level: 1)).get()
            numbering("(1.1)", count.at(0), counter(math.equation).at(el.location()).at(0) + 1)
          }],
      )
    } else {
      it
    }
  }

  // Title page
  grid(
    columns: 1fr,
    row-gutter: 1.5em,
    rows: (auto, auto, auto, auto, auto),
    v(0.5em),
    align(center + horizon)[Örebro University],
    v(0.5em),
    align(center + horizon)[#image(width: 70pt, "oru-logo-mono.svg")],
    v(0.5em),
    align(center + horizon)[#author],
    align(center, text(16pt, font: "Trade Gothic Next HvyCd")[#title]),
    align(center, text(12pt, font: "Trade Gothic Next HvyCd")[#subtitle]),
  )

  pagebreak()

  // Copyright/publication page
  grid(
    columns: 1fr,
    row-gutter: 0.5em,
    rows: (1fr, auto, auto, auto, auto),
    v(1.0em),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *Author:* #author]),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *Title:* #title, #subtitle
    ]),
    v(0.4em),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *Publisher:* Örebro University, #year
    ]),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      www.oru.se/publikationer
    ]),
    v(0.4em),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *Print:* Örebro University, Repro MM/YYYY (remove if not relevant)]),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *Cover image:* (remove if not relevant)
    ]),
    v(0.4em),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *ISBN:* 978-91- XXXX-XXX-X (print)]),
    align(left + horizon, text(0.8em, font: "Trade Gothic Next")[
      *ISBN:* 978-91- XXXX-XXX-X (pdf)
    ])
  )
  pagebreak()

  // Abstract page
  {
    set page(
      header-ascent: 1.25cm,
      footer-descent: 0.6cm,
      header: none,
      footer: none,
    )

    place(
      top + left,
      dy: 0cm,
      grid(
        columns: 11.3cm,
        rows: (0.79cm, 16.05cm, 2.46cm),
        row-gutter: 0em,
        align: left,
        stroke: 0.5pt,
        align(left + horizon)[#text(TOC_Heading([Abstract]))],
        pad(top: 13pt)[#abstract],
        align(left + horizon)[Keywords: #keywords]
      ),
    )
  }
  pagebreak()

  // Dedication
  if dedication != none {
    align(left + top)[#dedication]
    pagebreak()
  }

  // Table of contents
  show outline: set par(leading: 0.75em)

  show outline.entry.where(level: 1): it => {
    v(12pt, weak: true)
    text(size: 12pt)[#ORU_H1_Heading_1(it)]
  }

  show outline.entry.where(level: 2): it => {
    block(
      inset: (left: 1em),
      ORU_H2_Heading_2(it),
    )
  }

  show outline.entry.where(level: 3): it => {
    block(
      inset: (left: 1em),
      ORU_H3_Heading_3(it),
    )
  }

  show outline.entry.where(level: 4): it => {
    block(
      inset: (left: 1em),
      ORU_H4_Heading_4(it),
    )
  }

  outline(
    title: align(left, TOC_Heading([Table of contents])),
    indent: 0em,
  )

  pagebreak()

  set heading(numbering: "1.1.1.1", bookmarked: auto)

  show heading.where(level: 1): it => {
    if it.body == [List of papers] {
      pagebreak(weak: true)
      set text(size: 16pt)
      set par(leading: 1.25em, spacing: 1.09em)
      align(left)[#ORU_H1_Heading_1(it.body)]
    } else {
      pagebreak(weak: true)
      set text(size: 16pt)
      set par(leading: 1.25em, spacing: 1.09em)
      align(left)[#ORU_H1_Heading_1([#counter(heading).display(it.numbering) #it.body])]
    }
  }

  show heading.where(level: 2): it => {
    set text(size: 13pt)
    set par(leading: 1.15em, spacing: 0.333em)
    align(left)[#ORU_H2_Heading_2([#counter(heading).display(it.numbering) #it.body])]
    v(-4pt)
  }

  show heading.where(level: 3): it => {
    set text(size: 13pt)
    set par(leading: 1.25em, spacing: 0.333em)
    align(left)[#ORU_H3_Heading_3([#counter(heading).display(it.numbering) #it.body])]
  }

  show heading.where(level: 4): it => {
    set text(size: 12pt)
    set par(leading: 1.25em, spacing: 0.333em)
    align(left)[#ORU_H4_Heading_4([#counter(heading).display(it.numbering) #it.body])]
  }

  if list-of-papers != none {
    heading(level: 1, outlined: true, numbering: none)[List of papers]

    set enum(numbering: "I.", body-indent: 0.3cm, number-align: left)
    set par(
      leading: 0.75em,
      spacing: 1.25em,
    )
    list-of-papers
  }

  pagebreak()

  set page(
    numbering: "1",
    footer: context {
      v(0.6cm - 0.7cm)
      if is-odd-page() [
        #set text(
          font: "Trade Gothic Next",
          size: 9pt,
        )
        #set align(right)
        #grid(
          columns: (1fr, auto),
          rows: 2pt,
          column-gutter: 1cm,
          [#title], [#counter(page).display("1")],
        )
      ] else [
        #set text(
          font: "Trade Gothic Next",
          size: 9pt,
        )
        #set align(left)
        #grid(
          columns: (auto, 1fr),
          column-gutter: 1cm,
          [#counter(page).display("1")], [#author],
        )
      ]
    },
  )

  show figure: set align(left)
  show figure.caption: it => context {
    set par(leading: 0.917em)
    v(0.3em)
    text(
      font: "Trade Gothic Next",
      size: 0.8em,
    )[
      #strong[#it.supplement #it.counter.display().] #it.body
    ]
    v(2em)
  }

  // Set bibliography to use custom title
  set bibliography(title: reference-title)
  show bibliography: set heading(numbering: "1.")

  doc
}

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)

// This is the 'typst-show.typ' file that connects Quarto metadata 
// to the ORU thesis template defined in 'typst-template.typ'

#show: doc => thesis(
  title: [Thesis Title],
  subtitle: [Subtitle],
  author: [Author Name],
  dept: [Department Name],
  year: [2025],
  month: [December],
  day: [4],
  committee: (
    (
      name: [Committee Member 1],
      title: [Ph.D.],
    ),
    (
      name: [Committee Member 2],
      title: [Ph.D.],
    ),
    (
      name: [Committee Member 3],
      title: [Ph.D.],
    ),
  ),
  dedication: [Dedication/thanks to. This page is optional.

],
  abstract: [This is fictitious abstract regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

Regarding the scientific literature on the association between obesity and type 2 diabetes millets. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

Regarding the scientific literature on the association between obesity and type 2 diabetes mellites. It was reported that our high BMI was associated with an increased risk of T2DM. This association was graded with higher BMI associated with a higher risk of T2DM. Also, among people with BMI ≥ 30, the risk of T2DM was greater before than after age 50. What are the mechanisms explaining these associations? Please add references of peer.

The mechanisms explaining these associations? Please add refer regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI. The mechanisms explaining these associations? Please add refer regarding the scientific literature on the association between obesity and type 2 diabetes mellitus. It was reported that our high BMI.

],
  keywords: [Health literacy, Chronic diseases, Diabetes, Obesity, Hypertension, Cardiovascular disease, Diabetes mellitus, Obesity, Cardiovascular disease, Diabetes mellitus, Diabetes mellitus, Obesity, Card. Is even last line.],
  list-of-papers: [This thesis is based on the following studies, referred to in the text by their Roman numerals.

+ Use the style sheet ORU\_List of Papers. If not needed, the page should be deleted.

+ LastName, FirstName, 2021. "Title of article. And possible subtitle". #emph[Name of journal];, 1:1, 90--95 \[volume, number and pages\].

+ Article/Study 3

Reprints were made with permission from the respective publishers.

],
  reference-title: [Cited Works],
  doc,
)

= \[ORU\_H1\_Heading 1\]
<oru_h1_heading-1>
Start to write here. The template will automatically use ORU\_Body text unless you make changes manually. Do not add extra space between headings and body text or between paragraphs unless you have a specific reason to do so.

When you want to start a new paragraph, just press Enter.

== \[ORU\_H2\_Heading 2\]
<oru_h2_heading-2>
ORU\_Body text will always follow the style sheets for headings (ORU\_H1--ORU\_H5). Citation/quotation. Use the stylesheet ORU\_Quotation for all longer quotations and an indent and smaller font will automatically be used @Zomer-2016@Arbaje-2008.

=== \[ORU\_H3\_Heading 3\]
<oru_h3_heading-3>
Replace this text.

==== \[ORU\_H4\_Heading 4\]
<oru_h4_heading-4>
Replace this text.

= ORU\_H1\_Heading \#1
<oru_h1_heading-1-1>
If you need numbered headings, please use the style sheets ORU\_H1\_Heading \#1--ORU\_H4\_Heading \#4, see below. Otherwise delete this page. When you want to start a new paragraph, just press Enter.

== ORU\_H2\_Heading \#2
<oru_h2_heading-2-1>
ORU\_Body text will always follow the style sheets for headings (ORU\_H1\_Heading \#1--ORU\_H4\_Heading \#4).

=== ORU\_H3\_Heading \#3
<oru_h3_heading-3-1>
ORU\_Body text will always follow the style sheets for headings (ORU\_H1\_Heading \#1--ORU\_H4\_Heading \#4).

==== ORU\_H4\_Heading \#4
<oru_h4_heading-4-1>
ORU\_Body text will always follow the style sheets for headings (ORU\_H1\_Heading \#1--ORU\_H4\_Heading \#4).

= Use the built-in format lists
<use-the-built-in-format-lists>
By using the built-in format lists you ensure that the structure is correct also for those who use different kinds of accessibility aids.

== Letter list
<letter-list>
#block[
#set enum(numbering: "a.", start: 1)
+ ORU\_Letter list -- Et vel mossus moluptatio. Rum non re nam et di dipsam quia ditibus earum nonem niendebis dolorepro.
+ Et re alist, volorent evenduntion pora illam, sequod quat escil ilicatendis nem expersp ercidi tem.
]

== Bulleted list
<bulleted-list>
- ORU\_Bullet list - Et vel mossus moluptatio. Rum non re nam et di dipsam quia ditibus earum nonem niendebis dolorepro.
- Et re alist, volorent evenduntion pora illam, sequod quat escil ilicatendis nem expersp ercidi tem.

== Numbered list
<numbered-list>
+ ORU\_Numbered list -- Et vel mossus moluptatio. Rum non re nam et di dipsam quia ditibus earum nonem niendebis dolore-pro.
+ Et re alist, volorent evenduntion pora illam, sequod quat escil ilicatendis nem expersp ercidi tem.

When you want body text to apply again, you must select the style sheet ORU\_Body text.

= Insert pictures, figures and tables
<insert-pictures-figures-and-tables>
To insert pictures, select the style sheet ORU\_Insert picture.

#figure([
#box(image("media/image3.png", height: 4.73cm, width: 11.4cm))
], caption: figure.caption(
position: bottom, 
[
To add an image or figure description to your picture. Apply ORU\_Description and make "Figure X" bold.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#figure([
#box(image("media/image4.png", height: 6.22cm, width: 8.57cm))
], caption: figure.caption(
position: bottom, 
[
If you use the function "Insert caption" the numbering of the figure will adjust automatically.
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


== Use the tool for tables and charts
<use-the-tool-for-tables-and-charts>
Use the Table tool and Chart tool in Word to insert tables and charts. The tools, if used correctly, support accessibility.

#table(
  columns: (24.69%, 24.69%, 24.69%, 25.93%),
  align: (auto,auto,auto,auto,),
  table.header([ORU\_Table\_ Heading], [ORU\_Table\_ Heading], [ORU\_Table\_ Heading], [ORU\_Table\_ Heading],),
  table.hline(),
  [ORU\_Table\_ content], [ORU\_Table\_ content], [ORU\_Table\_ content], [ORU\_Table\_ content],
  [ORU\_Table\_ content], [ORU\_Table\_ content], [ORU\_Table\_ content], [ORU\_Table\_ content],
)
= References with/without numbers
<references-without-numbers>
Use a .csl file numbered (e.g.~vancouver.csl) or unnumbered (e.g.~vancouver-author-date.csl) style. Specify which style you want in the YAML front matter `csl: your-style-file.csl` at the top of the document or in `_quarto.yml`.

Below are an example of numbered references.

 
  
#set bibliography(style: "vancouver-author-date.csl") 


#bibliography("reference.bib")

