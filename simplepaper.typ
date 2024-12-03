#let project(
  title: "",
  authors: (),
  abstract: none,
  keywords: (),
  body,
) = {
  let zh_song = ("Source Han Serif SC", "SimSun-ExtG")
  // let zh_xiaobiansong = ("FZXiaoBiaoSong-B05", "FZXiaoBiaoSong-B05S")
  let zh_kai = ("KaiTi",)
  let zh_hei = ("Source Han Sans SC", "SimHei")
  let zh_fangsong = ("FangSong",)
  let en_sans_serif = "Georgia"
  let en_serif = "Times New Roman"
  let en_typewriter = "Courier New"
  let en_code = "Sarasa Mono SC"
  let zh_sourcesong = "Source Han Serif SC"
  let zh_sourcehei = "Source Han Sans SC"

  // Moidfy the following to change the font.
  let title-font = (en_serif, ..zh_hei)
  let author-font = (en_typewriter, ..zh_fangsong)
  let body-font = (en_serif, ..zh_song)
  let heading-l1-font = (en_serif, ..zh_hei)
  let heading-l2-font = (en_serif, ..zh_kai)
  let heading-l3-font = (en_serif, ..zh_song)
  let caption-font = (en_serif, ..zh_song)
  let header-font = (en_serif, ..zh_kai)
  let strong-font = (en_serif, ..zh_hei)
  let emph-font = (en_serif, ..zh_kai)
  let raw-font = (en_code, ..zh_hei)
  let blank_par = context {
    let b = par(box())
    b
    v(-measure(b + b).height)
  }

  set document(author: authors.map(author => author.name), title: title)
  set page(
    numbering: "1",
    paper: "a4",
    number-align: center,
    // header: align(left)[
    //   #set text(font: header-font)
    //   #title
    // ],
  )

  set par(leading: 1.25em, spacing: 1.25em, first-line-indent: 2em)

  set heading(numbering: "1.1.1")
  show heading: set block(above: 1em, below: 1em)

  show heading.where(level: 1): it => {
    set text(font: heading-l1-font, size: 12pt, weight: "regular")
    it + blank_par
  }
  show heading.where(level: 2): it => {
    set text(font: heading-l2-font, size: 12pt, weight: "regular")
    set heading(numbering: "1.1")
    it + blank_par
  }
  show heading.where(level: 3): it => {
    set text(font: heading-l3-font, size: 12pt, weight: "regular")
    set heading(numbering: "1.1.1")
    it + blank_par
  }

  // Title
  align(center)[
    #block()[
      #set text(font: title-font, size: 24pt, weight: "regular")
      #title
    ]
  ]


  // Display the authors list.
  let author_num = authors.len()
  let author_num_per_line = 3
  let column_num = calc.min(author_num, author_num_per_line)
  v(2em)
  grid(
    columns: (1fr,) * column_num,
    column-gutter: 12pt,
    row-gutter: 16pt,
    align: center,
    ..authors.map(author => {
      [
        #set text(font: author-font, size: 12pt)
        #author.name
        #if ("ID" in author) [
          \ #author.ID
        ]
        #if ("organization" in author) [
          \ #author.organization
        ]
        #if ("email" in author) [
          \ #link("mailto:" + author.email)
        ]
      ]
    })
  )
  v(2em, weak: true)

  set text(font: body-font, size: 12pt, lang: "zh", region: "cn")

  // Main body
  set figure(gap: 1em)
  show figure: it => [
    #set text(font: caption-font, size: 10.5pt)
    #it
    #blank_par
  ]
  show figure.caption: it => [
    #it.supplement
    #context it.counter.display(it.numbering)
    #it.body
  ]
  show figure.where(kind: table): set figure.caption(position: top)

  set enum(indent: 2em)
  set list(indent: 2em)
  show list: it => [
    #it
    #blank_par
  ]
  show enum: it => [
    #it
    #blank_par
  ]

  show strong: set text(font: strong-font)
  show emph: set text(font: emph-font)

  show raw.where(block: true): block.with(
    width: 100%,
    fill: luma(240),
    inset: 10pt,
  )
  show raw.where(block: true): it => [
    #it
    #blank_par
  ]

  show raw: set text(font: raw-font)

  set math.equation(numbering: "(1)")
  show math.equation.where(block: false): it => h(0.25em, weak: true) + it + h(0.25em, weak: true)
  show math.equation.where(block: true): it => [
    #it
    #blank_par
  ]

  set bibliography(style: "gb-7714-2015-numeric")
  show bibliography: it => [
    #set text(font: body-font, size: 12pt, lang: "zh", region: "cn")
    #pagebreak()
    #it.
  ]


  if abstract != none [
    #text(font: heading-l1-font)[#h(2em) 摘#h(1em)要：] #abstract

    #if keywords != () [
      #text(font: heading-l1-font)[关键词：] #keywords.join("，")
    ]
    #v(1em)
  ]

  body
}
