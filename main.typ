#import "@preview/touying:0.4.2": *
#import "@preview/cetz:0.2.2"
#import "@preview/fletcher:0.4.4" as fletcher: node, edge
#import "@preview/ctheorems:1.1.2": *
#import "@preview/showybox:2.0.1": *
#import "@preview/physica:0.9.3": *
#show link: it => underline(stroke: (dash: "densely-dotted"), text(fill: eastern, it)) 


#let showy-thm(
  identifier,
  head,
  color: blue,
  symbol: "♥",
  ..showy-args,
  supplement: auto,
  base: "heading",
  base_level: none,
) = {
  let showy-fmt(name, number, body, ..args) = {
    showybox(
      title-style: (
        boxed-style: (
          anchor: (
            x: left, // https://github.com/Pablo-Gonzalez-Calderon/showybox-package/blob/081b596cbbaaa275e154eb982833ec7410d13c29/examples/examples.typ#L133
            y: horizon
          ),
          radius: (top-left: 10pt, bottom-right: 10pt, rest: 0pt),
        )
      ),
      title: {
        head
        number
        if name != none {
          [（#name）]
        }
      },
      frame: (
        border-color: color,
        title-color: color.lighten(5%),
        body-color: color.lighten(95%),
        footer-color: color.lighten(80%),
      ),
      ..args.named(),
      {
        body
        place(
          bottom + right,
          dy: 0pt + 5pt, // Account for inset of block
          dx: 10pt + 0pt,
          text(fill: color)[#symbol]
        )
      }
    )
  }
  if supplement == auto {
    supplement = head
  }
  thmenv(
    identifier,
    "heading",
    none,
    showy-fmt,
  ).with(supplement: supplement)
}

#let theorem = showy-thm("theorem", "定理").with(numbering: "1.1")
#let exercise = showy-thm("exercise", "Exercise ").with(numbering: "1.1")
#let lemma = showy-thm("lemma ", "引理", color: rgb("#00a652"), symbol: "♣").with(numbering: "1.1")
// #let lemma = showy-thm("lemma ", "引理", color: eastern).with(numbering: "1.1")
#let proof = thmproof("proof", "Proof")


// cetz and fletcher bindings for touying
#let cetz-canvas = touying-reducer.with(reduce: cetz.canvas, cover: cetz.draw.hide.with(bounds: true))
#let fletcher-diagram = touying-reducer.with(reduce: fletcher.diagram, cover: fletcher.hide)

// Register university theme
// You can replace it with other themes and it can still work normally
#let s = themes.university.register(aspect-ratio: "16-9")

// Set the numbering of section and subsection
#let s = (s.methods.numbering)(self: s, section: "1.", "1.1")

// Set the speaker notes configuration
// #let s = (s.methods.show-notes-on-second-screen)(self: s, right)

// Global information configuration
#let s = (s.methods.info)(
  self: s,
  title: [Julia Language  and  Scientific Machine Learning],
  subtitle: [From a user's perspective],
  author: [Junyi Xu],
  date: [September 21, 2024],
  institution: [Department 52],
)

// Pdfpc configuration
// typst query --root . ./example.typ --field value --one "<pdfpc-file>" > ./example.pdfpc
#let s = (s.methods.append-preamble)(self: s, pdfpc.config(
  duration-minutes: 30,
  start-time: datetime(hour: 14, minute: 10, second: 0),
  end-time: datetime(hour: 14, minute: 40, second: 0),
  last-minutes: 5,
  note-font-size: 12,
  disable-markdown: false,
  default-transition: (
    type: "push",
    duration-seconds: 2,
    angle: ltr,
    alignment: "vertical",
    direction: "inward",
  ),
))

#let mybox(name, color: navy, body, ..args) = showybox(
  frame: (
      border-color: color,
      title-color: color.lighten(5%),
      body-color: color.lighten(95%),
      footer-color: color.lighten(80%),
  ),
  title: {
    if name != none {
      [#name]
    }
  },
  title-style: (
    // color: black,
    weight: "regular",
    align: center
  ),
  shadow: (
    offset: 3pt,
  ),
  ..args.named(),
  body
)


// Theroems configuration by ctheorems
#show: thmrules.with(qed-symbol: $square$)
#let theorem = thmbox("theorem", "Theorem", fill: rgb("#eeffee"))
#let corollary = thmplain(
  "corollary",
  "Corollary",
  base: "theorem",
  titlefmt: strong
)
#let definition = thmbox("definition", "Definition", inset: (x: 1.2em, top: 1em))
#let example = thmplain("example", "Example").with(numbering: none)
#let proof = thmproof("proof", "Proof")

// Extract methods
#let (init, slides, touying-outline, alert, speaker-note) = utils.methods(s)
#show: init

#show strong: alert

// Extract slide functions
#let (slide, empty-slide) = utils.slides(s)
#show: slides


= Julia Lang

== Hey, Have you heard of Julia Lang?

#slide(composer: (1fr, 1fr))[
  #image("./img/同学你听过.png", width: 240pt)
  *Julia is a high level language for high performance computing.*
][
  #mybox(
    [Features]
  // footer: "Information extracted from a well-known public encyclopedia"
)[
- Generic Programming
- Multiple Dispatch
- Operator overloading
- Native Differential Programming
- Metaprogramming #emoji.face
- Call Python and R
- …
  #v(10pt)
"*We are #link("https://julialang.org/blog/2012/02/why-we-created-julia/")[greedy]*".

]]

== Julia 的缺点

#slide(composer: (1fr, 1fr, 1fr))[
  #mybox(
  "Features"
  // footer: "Information extracted from a well-known public encyclopedia"
)[
  If you are not strong enough, features bug you.
  e.g. \
  runtime-dispatch
  #image("./img/年轻人你渴望力量吗.png", width: 85pt)
]
][
  #mybox(
  "特定情况比较慢"
  // footer: "Information extracted from a well-known public encyclopedia"
)[
  - 首次调用延迟(JIT)
  - 编译开销大，适合长时间运行的任务
  - 动态语言，碰到类型不稳定的代码会很慢
  #v(30pt)
]
][
  #mybox(
  "Niche: 科学计算"
  // footer: "Information extracted from a well-known public encyclopedia"
)[
  - 缺乏原生 GUI 支持
  - 移动开发支持薄弱
  #v(164pt)
]
]

= SciML

== What's SciML

=== Key Components

#line(length: 100%)

- *Physics-based Modeling*
- *Data-driven Machine Learning*
- The Universal Approximation Theorem
- Enhanced Interpretability
- Efficient Handling of Complex Systems

=== Key Technologies

#line(length: 100%)

*Automatic Differentiation*:
Leverage #link("https://enzyme.mit.edu/julia/stable/")[Enzyme.jl] or #link("https://github.com/FluxML/Zygote.jl")[Zygote.jl] for auto-diff and faster scientific computing

== How do you solve ODEs

#slide[
  #image("./img/uniform_rod.png", width: 340pt)
  *A uniform rod of mass $M$ and length $l$ is hinged at one end.*
][
  According to the #link("https://en.wikipedia.org/wiki/Parallel_axis_theorem")[parallel axis theorem], the moment of inertia $J'$:
  $
  J' = J + M dot l^2.
  $
  Hamiltonian:
  $
  H = 1/2 J' dot(theta)^2  - M g l sin theta.
  $
  ODEs:
  $
  dot(theta) = pdv(H, p) = pdv(H, J' theta), quad dot(p) = -pdv(H, theta).
  $
]

== How do you solve ODEs using Julia
```julia
using OrdinaryDiffEq

function odejoint!(dy,y,α,t) # α = [J', Mgl]
    dy[1] = y[2]/α[1] # Generalized coordinates q: θ
    dy[2] = α[2]*cos(y[1]) # Generalized momentum p: J' dθ/dt
end
```

#alternatives[
```julia
prob = ODEProblem(odejoint!, y0, tspan, α) # def your y0, α
```
][
```julia
prob = ODEProblem(odejoint!, y0, tspan, α) # def your y0, α
```
]

```julia
sol = solve(prob)
```

== Change the algorithm
```julia
using OrdinaryDiffEq

function odejoint!(dy,y,α,t) # α = [J', Mgl]
    dy[1] = y[2]/α[1] # Generalized coordinates q: θ
    dy[2] = α[2]*cos(y[1]) # Generalized momentum p: J' dθ/dt
end
```
#exercise[
  Use a symplectic integrator to solve the above problem.
]
```julia
sol = solve(prob)
```

= Showcase

== Code
  #mybox(
    [Exmaples]
  // footer: "Information extracted from a well-known public encyclopedia"
)[
Let's play around with #link("https://git.lug.ustc.edu.cn/junyixu/intro-to-julia-sciml")[PINNs in Jupyter].
]

= Summary

== Summary

- Machine learning and differential equations: converging to describe nonlinear world
- Julia ecosystem: integrating differential equation and deep learning packages
- Easy to tweak and customize loss functions
- Comprehensive solver access: ODEs, SDEs, DAEs, DDEs, PDEs, and more

// appendix by freezing last-slide-number
#let s = (s.methods.appendix)(self: s)
#let (slide, empty-slide) = utils.slides(s)

== Appendix

#slide[
  === References
  - #link("https://julialang.org/blog/2019/01/fluxdiffeq/")[DiffEqFlux.jl – A Julia Library for Neural Differential Equations]
  - #link("https://lux.csail.mit.edu/dev/introduction/overview")[Lux.jl]
  === Useful Books
  - First Semester in Numerical Analysis  with Julia
  - Numerical Linear Algebra with Julia
  - Design Patterns and Best Practices with julia
  - Statistics With Julia
  - Data Science with Julia (2019)
]
