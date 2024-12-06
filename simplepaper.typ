#let project(
  title: "",
  authors: (),
  abstract: none,
  keywords: (),
  body,
) = {
  let zh_song = ("Source Han Serif SC", "SimSun-ExtG")
  let zh_kai = ("KaiTi",)
  let zh_hei = ("Source Han Sans SC", "SimHei")
  let zh_fangsong = ("FangSong",)
  let en_serif = "Times New Roman"
  let en_typewriter = "Courier New"
  let en_code = "Sarasa Mono SC"

  // Moidfy the following to change the font.
  let fonts = (
    title: (en_serif, ..zh_hei),
    author: (en_typewriter, ..zh_fangsong),
    body: (en_serif, ..zh_song),
    heading_l1: (..zh_hei,),
    heading_l2: (..zh_kai,),
    heading_l3: (..zh_song,),
    caption: (en_serif, ..zh_song),
    header: (en_serif, ..zh_kai),
    strong: (en_serif, ..zh_hei),
    emph: (en_serif, ..zh_kai),
    raw: (en_code, ..zh_hei)
  )

  let blank_par = context {
    let b = par(box())
    b
    v(-measure(b + b).height)
  }
  let noindent() = h(-2em)

  set document(author: authors.map(author => author.name), title: title)
  set page(
    numbering: "1",
    paper: "a4",
    number-align: center,
  )

  set par(leading: 1.25em, spacing: 1.25em, first-line-indent: 2em)

  set heading(numbering: "1.1.1", supplement: [节])
  show heading: set block(above: 1.5em, below: 1.5em)

  show heading.where(level: 1): it => {
    set text(font: fonts.heading_l1, size: 12pt, weight: "regular")
    it + blank_par
  }
  show heading.where(level: 2): it => {
    set text(font: fonts.heading_l2, size: 12pt, weight: "regular")
    it + blank_par
  }
  show heading.where(level: 3): it => {
    set text(font: fonts.heading_l3, size: 12pt, weight: "regular")
    it + blank_par
  }

  // Title
  align(center)[
    #block()[
      #set text(font: fonts.title, size: 24pt, weight: "regular")
      #title
    ]
  ]

  // Display the authors list.
  if authors != () {
    set par(leading: 0.65em)
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
          #set text(font: fonts.author, size: 12pt)
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
  }

  set text(font: fonts.body, size: 12pt, lang: "zh", region: "cn")

  // Main body
  set figure(gap: 1em)
  show figure: it => [
    #set text(font: fonts.caption, size: 10.5pt)
    #it
    #blank_par
  ]
  show figure.caption: it => [
    #it.supplement
    #context it.counter.display(it.numbering)
    #it.body
  ]
  show figure.where(kind: table): set figure.caption(position: top)

  set enum(numbering: "1).a)")
  show list: it => [
    #it
    #blank_par
  ]
  show enum: it => [
    #it
    #blank_par
  ]

  show strong: set text(font: fonts.strong)
  show emph: set text(font: fonts.emph)

  show raw.where(block: true): block.with(
    width: 100%,
    fill: luma(240),
    inset: 10pt,
  )
  show raw.where(block: true): it => [
    #it
    #blank_par
  ]

  show raw: set text(font: fonts.raw)

  set math.equation(numbering: "(1)", supplement: [式])
  show math.equation.where(block: false): it => h(0.25em, weak: true) + it + h(0.25em, weak: true)
  show math.equation.where(block: true): it => [
    #it
    #blank_par
  ]

  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.
      link(
        el.location(),
        [式 #numbering(
          el.numbering,
          ..counter(eq).at(el.location()),
        )],
      )
    } else {
      // Other references as usual.
      it
    }
  }

  set bibliography(style: "gb-7714-2015-numeric")
  show bibliography: it => [
    #set text(font: fonts.body, size: 12pt, lang: "zh", region: "cn")
    #pagebreak()
    #it.
  ]

  if abstract != none [
    #text(font: fonts.heading_l1)[#h(2em) 摘#h(1em)要：] #abstract

    #if keywords != () [
      #text(font: fonts.heading_l1)[关键词：] #keywords.join("，")
    ]
    #v(1em)
  ]

  body
}

#let noindent() = h(-2em)
