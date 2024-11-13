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
  let heading-font = (en_serif, ..zh_hei)
  let caption-font = (en_serif, ..zh_kai)
  let header-font = (en_serif, ..zh_kai)
  let strong-font = (en_serif, ..zh_hei)
  let emph-font = (en_serif, ..zh_kai)
  let raw-font = (en_code, ..zh_hei)

  set document(author: authors.map(author => author.name), title: title)
  set page(
    numbering: "1",
    paper: "a4",
    number-align: center,
    header: align(left)[
      #set text(font: header-font)
      #title
    ],
  )
  set heading(numbering: "1.1.1")
  set text(font: body-font, lang: "zh", region: "cn")
  set bibliography(style: "gb-7714-2015-numeric")

  show heading: it => box(width: 100%)[
    #v(0.50em)
    #if it.numbering != none {
      counter(heading).display()
    }
    #h(0.75em)
    #it.body
  ]

  show heading.where(level: 1): it => box(width: 100%)[
    #v(0.5em)
    #set align(center)
    #set text(font: heading-font, weight: "bold")
    #set heading(numbering: "一")
    #it
    #v(0.75em)
  ]

  show heading.where(level: 2): it => box(width: 100%)[
    #v(0.5em)
    #set text(font: heading-font, weight: "bold")
    #it
    #v(0.75em)
  ]

  show heading.where(level: 3): it => box(width: 100%)[
    #v(0.5em)
    #set text(font: body-font, weight: "medium")
    #it
    #v(0.75em)
  ]

  // Title
  align(center)[
    #block(
      text(
        font: title-font,
        weight: "bold",
        size: 1.75em,
        title,
      ),
    )
    #v(0.5em)
  ]

  // Display the authors list.
  let author_num = authors.len()
  let author_num_per_line = 3
  let column_num = calc.min(author_num, author_num_per_line)
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

  // Main body
  set enum(indent: 2em)
  set list(indent: 2em)
  set figure(gap: 0.8cm)

  // 定义空白段，解决首段缩进问题
  // let blank_par = par()[#text()[#v(0em, weak: true)];#text()[#h(0em)]]
  let blank_par = context {
    let b = par[#box()]
    let t = measure(b + b)

    b
    v(-t.height)
  }


  show figure: it => [
    #v(12pt)
    #set text(font: caption-font)
    #it
    #blank_par
    #v(12pt)
  ]

  show image: it => [
    #it
    #blank_par
  ]

  show list: it => [
    #it
    #blank_par
  ]

  show enum: it => [
    #it
    #blank_par
  ]

  show table: it => [
    #set text(font: body-font)
    #it
    #blank_par
  ]
  show strong: set text(font: strong-font)
  show emph: set text(font: emph-font)
  show ref: set text(red)
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
  show link: underline
  show link: set text(blue)
  set par(first-line-indent: 2em, justify: true)

  if abstract != none [
    #v(2pt)
    #h(2em) *摘要：* #abstract

    #if keywords != () [
      *关键字：* #keywords.join("；")
    ]
    #v(2pt)
  ]

  body
}
#let problem-counter = counter("problem")
#problem-counter.step()

#let problem(body) = {
  problem-counter.step()
  set enum(numbering: "(1)")
  block(
    fill: rgb(241, 241, 255),
    inset: 8pt,
    radius: 2pt,
    width: 100%,
  )[*题目 #problem-counter.display().* #h(0.75em) #body]
}

#let solution(body) = {
  set enum(numbering: "(1)")
  let blank_par = par()[#text()[#v(0em, weak: true)];#text()[#h(0em)]]
  block(
    inset: 8pt,
    width: 100%,
  )[
    *解答.*
    #blank_par
    #body
  ]
}
