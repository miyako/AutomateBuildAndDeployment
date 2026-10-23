# Build4Dコンポーネントによるビルドとデプロイの自動化

Automating Build and Deployment processes with Build4D Component (4D Technical Note 25-07): Japanese edition.

このテクニカルノートでは、4Dチームが提供する**Build4D**コンポーネントを使って、4Dアプリケーションのコンパイル、ビルド、パッケージングを自動化する方法を説明します。コンパイル済みストラクチャー、コンポーネント、スタンドアロンアプリケーション、クライアント/サーバーアプリケーションのビルドを、それぞれ実践的な例で紹介します。さらに、tool4dとGitHub Actionsを組み合わせて、コンパイルとビルドをCI/CDパイプラインに組み込む方法も解説します。付属のデモプロジェクトには、ノートで紹介するビルド用メソッドが収録されています。

This technical note explains how to automate compiling, building and packaging 4D applications with the Build4D component, with examples for compiled structures, components, standalone and client/server applications, and a GitHub Actions pipeline driven by tool4d.

## Download

| | |
|---|---|
| PDF (Japanese) | [25-07_AutomateBuildAndDeployment_ja.pdf](https://github.com/miyako/AutomateBuildAndDeployment/releases/latest/download/25-07_AutomateBuildAndDeployment_ja.pdf) |
| 4D demo | [AutomateBuildAndDeployment.zip](https://github.com/miyako/AutomateBuildAndDeployment/releases/latest/download/AutomateBuildAndDeployment.zip) |
| Original (English) | `document/25-07_AutomateBuildAndDeployment.pdf` |

## Demo

- 4D version: 4D 20 R8 (the version used in the note)
- Open `demo/AutomateBuildAndDeployment/Project/AutomateBuildAndDeployment.4DProject`.
- The Build4D component is included in `Components/Build4D.4dbase`.
- The build methods are `buildCompiledStructure`, `buildComponent`, `buildStandalone`, `buildServer` and
  `buildClient`; `compileMethod` and `buildMethod` are the entry points used by the GitHub Actions workflow.
- `buildStandalone`, `buildServer` and `buildClient` expect 4D Volume Desktop or 4D Server in
  `Documents/4D 20 R8 100333/`. Adjust the path to your installation.
- The demo project is the original one; it is not localised.

## Differences from the original

- The labels in the 4D and Windows Explorer screenshots (figures 1–6, 16 and 21–23) are replaced in place with
  the Japanese UI terms of 4D and Windows 11. Dates use the Japanese Windows format.
- GitHub screenshots, terminal output, logs and code stay in English.
- The first YAML example is corrected to valid YAML.
- The code blocks are identical to the original.

## Editing and rebuilding

The PDF is generated from plain-text sources. Edit them and run `make`.

| File | What |
|---|---|
| `src/ja.md` | Translated body text. **Don't touch code blocks** (`make check` verifies them). |
| `figures/fig-NN.ja.txt` | Text drawn in figure NN. Line N corresponds to line N of `fig-NN.en.txt`: an identical line keeps the original, an empty line erases it. |
| `figures/layout/fig-NN.json` | Per-label overrides for size, weight, alignment and position; `"replace"` uses a ready-made image |
| `glossary.md` | Terminology |

```sh
make            # check → figures → build/25-07_AutomateBuildAndDeployment_ja.pdf
make check      # code blocks unchanged, figure references complete
make review     # contact sheets of the figures (build/contact-N.png)
make release-assets
```

Requirements: Python 3, Google Chrome, CJK fonts, and Tesseract (only needed for re-extraction).
See the [localisation template](https://github.com/miyako/4d-technote-localisation-template) for the full workflow.

## Credits

- Original: Soukaina BACHIKH, Customer Success Engineer, 4D Inc. (Technical Note 25-07)
- Produced with [4d-technote-localisation-template](https://github.com/miyako/4d-technote-localisation-template) and GitHub Copilot.
