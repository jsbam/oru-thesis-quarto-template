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

#set footnote.entry(
  indent: 0cm,
  //gap: 0.4cm,
  clearance: 2.85pt
)

#show footnote.entry: it => {
  let num = counter(footnote).at(it.note.location()).first()
  
  set text(size: 9.5pt)
    
  set par(
    leading: 0.73em,
  )
  grid(
    columns: (auto, 1fr),
    column-gutter: 0.5em,
    align()[#super[#num]],
    it.note.body
  )
}

#let thesis(
  title: none,
  subtitle: none,
  author: none,
  dept: none,
  subject-area: none,
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
    v(2.7em),
    align(center + horizon)[Örebro Studies in #subject-area],
    v(0.7em),
    align(center + horizon)[#image(width: 70pt, "oru-logo-mono.svg")],
    v(0.7em),
    align(center + horizon)[#author],
    align(center, text(16pt, font: "Trade Gothic Next HvyCd")[#title]),
    align(center, text(12pt, font: "Trade Gothic Next HvyCd")[#subtitle]),
  )

  pagebreak()

  // Copyright/publication page
  rect(
    width: 11.4cm,
    height: 17.31cm,
    //stroke: red,
    stroke: none,
  )[
  #grid(
    columns: 1fr,
    row-gutter: 0.5em,
    rows: (1fr, auto, auto, auto, auto),
    v(1.0em),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *Author:* #author]),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *Title:* #title, #subtitle
    ]),
    v(1.0em),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *Publisher:* Örebro University, #year
    ]),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      www.oru.se/publikationer
    ]),
    v(1.0em),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *Print:* Örebro University, Repro #month/#year (remove if not relevant)]),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *Cover image:* (remove if not relevant)
    ]),
    v(3.0em),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *ISBN:* XXX-XXXX (Entered by Repro)]),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *ISBN:* 978-91- XXXX-XXX-X (pdf)
    ]),
    align(left + horizon, text(10.5pt, font: "Trade Gothic Next")[
      *ISBN:* 978-91- XXXX-XXX-X (pdf)
    ]),

  )]
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
        // rows: (0.79cm, 16.05cm, 2.46cm),
        rows: (0.79cm, 16.05cm, 1.16cm),
        row-gutter: (0em, 1.0em),
        align: left,
        stroke: none,
        align(left + horizon)[#text(TOC_Heading([Abstract]))],
        pad(top: 13pt)[#abstract],
        align(left + horizon)[Keywords: #keywords]
      ),
    )
    v(1.0em)
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
      ORU_H3_Heading_3(it),
    )
  }

  outline(
    title: align(left, pad(
      bottom: 0.8em, TOC_Heading([Table of contents]))),
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
