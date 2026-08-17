# PNova

### A theorem prover built from first principles.

**PNova — Proof-Nova** is an experimental interactive theorem-proving engine written from scratch in **OCaml**, starting at the mathematical foundations rather than wrapping an existing proof kernel.

The project begins with a deliberately small idea:

> **Understand computation at the level of mathematical structure, then build proof on top of it.**

At its core, PNova implements the untyped **λ-calculus** as an executable formal system. Terms are represented structurally, substitutions are performed with capture avoidance, bound variables are renamed when necessary, and β-reduction drives evaluation to normal form.

The result is a compact foundation for exploring how programming languages, computation, and formal reasoning emerge from the same mathematical machinery.

---

## Why PNova?

Most theorem-proving systems expose an enormous amount of functionality to the user.

PNova takes the opposite approach.

Instead of starting with a massive language and hiding the foundations, PNova starts with the foundations themselves:

```text
Mathematical Term
      ↓
Abstract Syntax Tree
      ↓
Free-variable analysis
      ↓
Capture-avoiding substitution
      ↓
α-renaming when required
      ↓
β-reduction
      ↓
Evaluation
      ↓
Normal form
```

Every transformation is explicit.

That makes PNova more than a collection of features. It is an attempt to build a transparent computational foundation on which progressively stronger forms of formal reasoning can be constructed.

---

# Core Architecture

PNova is intentionally modular.

```text
PNova
│
├── AST
│   ├── Terms
│   └── Free-variable analysis
│
├── Lambda Calculus
│   ├── Substitution
│   ├── α-renaming
│   ├── β-reduction
│   └── Evaluation
│
└── Utilities
    ├── Identifiers
    ├── Fresh-name generation
    ├── Identifier sets
    └── Source locations
```

The current source tree reflects this separation directly.

---

# The Mathematical Core

## 1. Structural λ-Term Representation

PNova represents expressions using a minimal algebraic data type:

```ocaml
type t =
  | Variable of Identifier.t
  | Lambda of Identifier.t * t
  | Application of t * t
```

This gives PNova exactly three fundamental constructs:

* **Variable** — `x`
* **Abstraction** — `λx. t`
* **Application** — `(t₁ t₂)`

For example:

```text
λx. x
```

is represented as an abstraction whose body is the variable `x`.

Likewise:

```text
(λx. x) y
```

is represented as an application between a lambda term and an argument.

This deliberately minimal representation is the foundation on which the rest of PNova operates.

---

# Algorithms

## 2. Free-Variable Analysis

Before substitution can be performed safely, PNova must know which variables are **free** inside an expression.

The recursive definition is:

```text
FV(x)        = {x}

FV(M N)      = FV(M) ∪ FV(N)

FV(λx. M)    = FV(M) \ {x}
```

PNova implements this directly through structural recursion.

This seemingly simple algorithm becomes critical during substitution because it determines whether inserting an expression underneath a binder could accidentally capture one of its variables.

### Why this matters

Consider:

```text
(λx. λy. x) y
```

Naively substituting `y` for `x` would produce:

```text
λy. y
```

But that changes the meaning of the expression because the substituted `y` has become bound.

PNova detects this situation before performing the substitution.

---

# 3. Capture-Avoiding Substitution

This is one of the most important algorithms in the entire system.

PNova implements substitution recursively:

```text
[x := N]x        = N

[x := N]y        = y              if x ≠ y

[x := N](M P)    = ([x := N]M [x := N]P)

[x := N](λx.M)   = λx.M

[x := N](λy.M)   = λy.([x := N]M)
                    when y ∉ FV(N)
```

But when:

```text
y ∈ FV(N)
```

substitution cannot safely continue.

PNova therefore performs **α-renaming** first.

Conceptually:

```text
λy. M
```

becomes:

```text
λy₀. M[y → y₀]
```

and only then is substitution continued.

This is known as **capture-avoiding substitution**, and it is essential for preserving the semantics of λ-calculus expressions. PNova explicitly computes free variables, detects conflicts, generates a fresh identifier, renames the binder, and resumes substitution.

---

# 4. α-Renaming

PNova separates renaming from substitution.

The renaming algorithm recursively walks the term:

```text
rename(old, new, term)
```

and replaces occurrences of an identifier while respecting nested binders.

This provides an explicit mechanism for transforming:

```text
λx. x
```

into an α-equivalent expression such as:

```text
λx₀. x₀
```

without changing its computational meaning.

The distinction is important:

**α-conversion changes names.
β-reduction changes computation.**

Keeping these operations separate makes the implementation easier to reason about and provides a foundation for future proof-oriented transformations.

---

# 5. Fresh Identifier Generation

Whenever α-renaming is required, PNova creates a deterministic fresh identifier.

For example:

```text
x
x_0
x_1
x_2
...
```

Fresh identifiers are produced by a monotonic counter associated with a generator.

```ocaml
let next generator prefix =
  let id =
    prefix ^ "_" ^ string_of_int generator.counter
  in
  generator.counter <- generator.counter + 1;
  Identifier.of_string id
```

This gives the substitution engine a reliable mechanism for avoiding accidental identifier collisions.

---

# 6. β-Reduction

β-reduction is the computational heart of PNova.

The fundamental rule is:

```text
(λx. M) N  →  [x := N]M
```

PNova detects reducible applications and delegates the actual replacement to its capture-avoiding substitution engine.

The reducer then recursively searches through applications and lambda bodies for additional reducible expressions.

For example:

```text
(λx. x) y
```

reduces to:

```text
y
```

The repository contains an executable test for precisely this identity reduction.

---

# 7. Normalization / Evaluation

PNova repeatedly performs β-reduction until no further reduction is possible:

```ocaml
let rec evaluate term =
  match Beta_reduction.reduce term with
  | Some reduced ->
      evaluate reduced
  | None ->
      term
```

Conceptually:

```text
Term
 ↓
β-reduce
 ↓
β-reduce
 ↓
β-reduce
 ↓
...
 ↓
Normal form
```

This turns the individual reduction algorithm into an evaluator for λ-terms.

---

# Why This Architecture Is Interesting

PNova is not revolutionary because it has a gigantic feature list.

It is interesting because the project explores something much more fundamental:

## Computation itself can become the proof substrate.

Lambda calculus is simultaneously:

```text
Mathematics
     +
Programming Language Theory
     +
Computation
     +
Formal Semantics
```

By implementing the underlying calculus directly, PNova creates a foundation from which more sophisticated formal systems can grow.

That creates a path toward a system in which:

```text
Definitions
    ↓
Expressions
    ↓
Computation
    ↓
Proof terms
    ↓
Machine-checkable reasoning
```

can share one coherent underlying representation.

---

# What Makes PNova Different?

### Built from first principles

PNova does not depend on an external theorem-proving kernel for its λ-calculus core.

The essential algorithms are implemented directly in OCaml.

### Explicit semantics

Instead of treating substitution, variable binding, and reduction as invisible implementation details, PNova makes them first-class components of the architecture.

### Correctness-aware substitution

Naive substitution is easy to implement.

Correct substitution is not.

PNova explicitly handles variable capture through free-variable analysis, α-renaming, and fresh-name generation.

### Small mathematical core

The project intentionally starts small.

A small kernel is easier to inspect, understand, test, and extend.

### Functional architecture

OCaml's algebraic data types and recursive programming model fit the structure of formal syntax naturally, making the implementation closely resemble the mathematics it represents.

---

# From Lambda Calculus to a Proof Engine

The most exciting part of PNova is not necessarily what exists today.

It is what the architecture makes possible next.

A potential evolution path is:

```text
                 PNova
                   │
          ┌────────┴────────┐
          │                 │
      Term Core        Proof Infrastructure
          │                 │
          ▼                 ▼
   λ-calculus         Judgments
          │            Contexts
          │             Types
          ▼              Proofs
   Normalization          │
          └──────┬─────────┘
                 ▼
          Type Theory
                 │
                 ▼
       Machine-checked proofs
```

This opens the door to progressively richer systems involving:

* simply typed λ-calculus
* type inference
* propositions-as-types
* dependent types
* inductive definitions
* proof terms
* rewrite systems
* automated tactics
* proof checking
* formalized mathematics

These are **future directions**, not claims about capabilities already implemented in the current repository.

---

# Why Build It From Scratch?

Because theorem proving is ultimately about trust.

A proof assistant is only as meaningful as the chain of reasoning you are willing to trust.

Building the foundations yourself forces the implementation to answer questions that mature systems can hide:

```text
What exactly is a term?

What does variable binding mean?

When is substitution valid?

How do we avoid capture?

What does reduction preserve?

What does it mean for two expressions to be equivalent?

How can computation become evidence?
```

PNova treats these questions as engineering problems rather than abstractions hidden behind an enormous framework.

That makes it useful not only as software, but as an experiment in the foundations of formal reasoning.

---

# Project Structure

```text
PNova/
│
├── src/
│   ├── ast/
│   │   ├── term.ml
│   │   └── free_variables.ml
│   │
│   ├── lambda/
│   │   ├── substitution.ml
│   │   ├── beta_reduction.ml
│   │   └── evaluator.ml
│   │
│   ├── utils/
│   │   ├── identifier.ml
│   │   ├── identifier_set.ml
│   │   ├── fresh.ml
│   │   └── location.ml
│   │
│   └── pnova.ml
│
├── tests/
│   ├── test_ast.ml
│   ├── test_lambda.ml
│   ├── test_substitution.ml
│   ├── test_beta_reduction.ml
│   ├── test_evaluator.ml
│   ├── test_free_variables.ml
│   ├── test_alpha_conversion.ml
│   ├── test_identifier_set.ml
│   └── test_utils.ml
│
├── dune-project
├── CHANGELOG.md
├── LICENSE
└── README.md
```

The repository currently includes dedicated tests for ASTs, λ-calculus operations, substitution, β-reduction, evaluation, free-variable analysis, α-conversion, and utilities.

---

# Installation

PNova uses **OCaml** and **Dune**. The package currently declares OCaml, Dune, and Alcotest as its dependencies.

Clone the repository:

```bash
git clone https://github.com/krishnasys-admin/PNova.git
cd PNova
```

Build:

```bash
dune build
```

Run the test suite:

```bash
dune test
```

The core library is exposed as the `pnova` library through Dune.

---

# A Tiny Example

The core API allows expressions to be constructed directly:

```ocaml
let identity =
  Term.lambda "x" (Term.var "x")

let argument =
  Term.var "y"

let expression =
  Term.apply identity argument
```

Conceptually:

```text
(λx. x) y
```

Evaluation produces:

```text
y
```

The important part is what happened internally:

```text
Application
    ↓
β-reduction detected
    ↓
Substitution requested
    ↓
Free-variable analysis
    ↓
Capture check
    ↓
α-renaming if necessary
    ↓
Substitution
    ↓
Reduced term
```

That chain is the foundation PNova is designed to grow from.

---

# Design Philosophy

PNova follows a few principles.

### 1. Start with mathematics

Implement the formal system first.

### 2. Make hidden mechanisms explicit

Binding, substitution, renaming, and reduction should be understandable and inspectable.

### 3. Prefer small composable algorithms

Each subsystem should have a narrow responsibility.

### 4. Make correctness part of the architecture

Algorithms such as capture-avoiding substitution should not be patched in later; they should be foundational.

### 5. Build upward

Rather than beginning with a huge proof language, establish a trustworthy computational core and extend it layer by layer.

---

# Current Status

PNova is an **experimental research/learning project** and an actively evolving foundation.

### Implemented

* λ-term AST
* Variables
* Lambda abstractions
* Applications
* Term pretty-printing
* Free-variable analysis
* Capture-avoiding substitution
* α-renaming
* Fresh identifier generation
* β-reduction
* Recursive evaluation
* Modular OCaml architecture
* Automated tests with Alcotest

### In development / future direction

* Richer proof language
* Type checking
* Typed λ-calculus
* Proof terms
* Formal propositions
* Interactive proof commands
* More sophisticated normalization strategies
* Automated reasoning
* A stronger proof kernel

---

# The Bigger Idea

PNova is an experiment around a simple question:

> **How far can a trustworthy formal reasoning system be built from a tiny computational core?**

The answer does not need to start with thousands of lines of automation.

It can start with:

```text
Variable
Lambda
Application
```

Then add:

```text
Free variables
      ↓
Substitution
      ↓
α-conversion
      ↓
β-reduction
      ↓
Evaluation
```

And eventually:

```text
Computation
      ↓
Types
      ↓
Propositions
      ↓
Proofs
      ↓
Verified mathematics
```

That is the vision behind PNova.

Not another wrapper around an existing prover.

A proof system whose foundations are visible.

---

# Contributing

PNova is intentionally designed to be understandable.

Contributions, discussions, mathematical feedback, implementation ideas, and correctness reviews are welcome.

Especially valuable are contributions around:

* binding and substitution correctness
* reduction semantics
* type theory
* proof representation
* kernel design
* normalization
* formal verification

---

# License

PNova is released under the **MIT License**.

---

## PNova

**Proof-Nova**

*A small kernel for a much larger idea.*

```text
        TERMS
          │
          ▼
     COMPUTATION
          │
          ▼
      REASONING
          │
          ▼
        PROOFS
          │
          ▼
      KNOWLEDGE
```

**Built from first principles. Built to grow.**
