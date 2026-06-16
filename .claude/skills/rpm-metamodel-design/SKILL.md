---
name: rpm-metamodel-design
description: RedPrinting 옵션 구성 추출 데이터에서 "옵션 관리 메타모델"(자재/공정/옵션/템플릿/제약/기초코드/카테고리를 어떤 관리 축·엔티티·관계·제약/캐스케이드 패턴으로 분리·정규화하는가)을 추상화하는 방법론 스킬(후니 RP-Meta 하네스). 핵심 = 알려진 7버킷 외 추가 메타모델(관리 축) 심층 발굴(자재 usage·합성, 공정 param/순서, 옵션 캐스케이드 그래프, 템플릿 계층, 제약 논리유형, 코드 도메인 거버넌스, 카테고리 트리/다중분류/생산형태). 인스턴스 vs 메타모델 구분, 관계 우선 ERD(mermaid), 오버피팅 거부, 인쇄 도메인 정초(dbm-domain KB), distinct 축 vs facet 판정 절차를 제공한다. '메타모델 설계', '옵션 관리 메타모델', '관리 축 도출', '메타모델 발굴', '추가 메타모델', '메타모델 ERD', '메타모델 추상화', '메타모델 다시', 'distinct 축 판정' 작업 시 반드시 이 스킬을 사용. 라이브 추출은 rpm-live-reverse, 후니 갭/그릇은 rpm-gap-vessel이 담당한다.
---

# rpm-metamodel-design — Option-Management Metamodel Abstraction

Turn RedPrinting option extracts into an abstract metamodel: the management axes, their entity shapes,
relationships, and constraint/cascade patterns. The user's directive: hunt past the seven obvious buckets
for *additional* metamodels.

## Why this method

A maintainable option system is defined by how it *separates concerns*, not by its product list. Capturing
that separation as a metamodel lets 후니 reach the same expressive power with its own schema. The seven named
buckets are a starting hypothesis — the real value is finding the management axes hiding inside them.

## Instance vs metamodel (the core discipline)

- Instance: "현수막 uses 타포린 substrate." (one product fact)
- Metamodel: "Material carries a *usage role* (substrate vs add-on) and a *composition rule* (a display color
  is synthesized from a material row, not a separate color entity)." (a pattern across products)
Always lift instances to patterns. If you can't state it without naming a specific product, it's not a metamodel yet.

## Workflow

### 1. Cluster the extracts
Group `categories/*/reverse.md` axes by what they manage. Resolve each category's `## Ambiguous fragments`
section into buckets (record verdicts
in `_resolved-fragments.md`). Ground meaning in print domain — load dbm-domain KB at
`_workspace/huni-dbmap/07_domain/` (entity-semantic-model, process-recipe-tree) or request dbm-domain-researcher.

### 2. Dictionary each axis
For every management axis, document:
- **identity** — what concern it manages.
- **entities (그릇 shape)** — the records/tables it would live in (abstract, not 후니-specific yet).
- **attributes** — the fields each entity carries.
- **relationships** — FK / polymorphic / composition to other axes.
- **constraint & cascade patterns** — e.g. material→pcs disable, dosu↔bnc, essential/hidden, 택1/택N.

### 3. Hunt discovered axes (the directive)
Probe past the seven buckets. For each candidate, decide *distinct axis* vs *facet of an existing one* with
evidence. Candidate probes:
- Material **usage/role** (parent material + usage_cd) and **composition/synthesis** (본체색 ← material row).
- Process **parameters & ordering** (UV param, 후가공 순서/레시피).
- Option **cascade dependency graph** (which selection gates which) as a first-class structure.
- Template/SKU **hierarchy & production type** (완제품/반제품/디자인/기성).
- Constraint **logic typing** (택1/택N/exclude/require/min-max) as a governed vocabulary.
- Code-value **domain governance** (enum groups, 채번 rules, separators).
- Category **tree + multi-classification** (a product in several trees; 생산형태 orthogonal to category).
Distinctness test: does it have its own attributes/lifecycle/relationships that an existing axis can't carry
without distortion? If yes → distinct (record in `discovered-axes.md` with verdict + evidence). If no → facet.

### 4. Draw the ERD
Mermaid ERD of axes and their relationships — this is where the metamodel's value concentrates.

### 5. Generalize, reject overfit
An axis needed by a single product without clean generalization is not an axis. Keep the metamodel serving
the *whole* catalog shape.

## Outputs
- `_workspace/huni-rpmeta/02_metamodel/metamodel-dictionary.md`
- `_workspace/huni-rpmeta/02_metamodel/discovered-axes.md` (distinct/facet verdicts + evidence)
- `_workspace/huni-rpmeta/02_metamodel/metamodel-erd.md` (mermaid)
- `_workspace/huni-rpmeta/02_metamodel/_resolved-fragments.md`

## Done when
Every clustered axis is dictionaried with relationships, discovered-axes carry distinctness verdicts, the
ERD is drawn, and nothing is overfit to a single product.
