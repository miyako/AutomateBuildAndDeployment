# 用語集 / Glossary

Keep terminology consistent across `src/<target>.md` and `figures/*.<target>.txt`.
Change an entry here first, then search and replace in both places.

Style (ja): です・ます調. Half-width alphanumerics, no space between Japanese and Latin text (e.g. `4D.Vector型`).
Full-width `（）` and `：` in prose. First occurrence of a technical term: 日本語（English）.

## 4D terms (from the official 4D Japanese documentation)

| English | 日本語 | Notes |
|---|---|---|
| entity / entity selection | エンティティ / エンティティセレクション | |
| datastore | データストア | |
| dataclass | データクラス | |
| attribute | 属性 | |
| computed attribute | 計算属性 | |
| collection | コレクション | |
| object | オブジェクト | |
| method | メソッド | |
| project method | プロジェクトメソッド | |
| function | 関数 | |
| class | クラス | |
| parameter | 引数 | |
| form | フォーム | |
| form object | フォームオブジェクト | |
| list box | リストボックス | |
| web area | Webエリア | |
| 4D Web Server | 4D Webサーバー | |
| worker | ワーカー | |
| process | プロセス | |
| query | クエリ | |
| formula | フォーミュラ | |
| component | コンポーネント | |
| host project | ホストプロジェクト | |
| class store (ClassStore) | クラスストア | first occurrence: クラスストア（ClassStore） |
| compiled structure | コンパイル済みストラクチャー | |
| structure | ストラクチャー | |
| data file | データファイル | |
| interpreted / compiled (component) | インタープリター版 / コンパイル済み版 | |
| Build Application (dialog) | アプリケーションビルド | first occurrence: アプリケーションビルド（Build Application） |
| standalone application | スタンドアロンアプリケーション | |
| client/server application | クライアント/サーバーアプリケーション | half-width slash |
| startup method (host database) | 開始メソッド | the host's On Startup code |
| syntax error | シンタックスエラー | |
| folder | フォルダー | long vowel, as in the 4D docs |
| "About 4D" | 「4Dについて」 | 4D menu item |

## Document-specific terms

| English | 日本語 | Notes |
|---|---|---|
| technical note | テクニカルノート | |
| tech tip | テクニカルティップ | |
| build / to build | ビルド / ビルドする | |
| packaging | パッケージング | |
| signing | 署名 | |
| obfuscation | 難読化 | |
| deployment | デプロイ (CI/CD) / 配布 (shipping an app) | |
| pipeline | パイプライン | |
| Continuous Integration (CI) | 継続的インテグレーション（Continuous Integration、CI） | GitHub Docs ja |
| Continuous Deployment (CD) | 継続的デプロイ（Continuous Deployment、CD） | GitHub Docs ja |
| workflow | ワークフロー | |
| job / step / trigger | ジョブ / ステップ / トリガー | first occurrence in the list: トリガー（Triggers） etc. |
| to trigger (a workflow) manually | （ワークフローを）手動で実行する | |
| push / pull request / merge | プッシュ / プルリクエスト / マージ | |
| runner | ランナー | |
| GitHub-hosted runner | GitHubホステッドランナー | GitHub Docs ja, no space |
| self-hosted runner | セルフホステッドランナー | GitHub Docs ja, no space |
| headless / dataless mode | ヘッドレスモード / データレスモード | |
| command-line utility | コマンドラインユーティリティ | |
| core build methods | ビルド用のメインメソッド | |
| destination (output) folder | 出力先フォルダー | |
| Note: | 注： | italic, as in the original |
| GitHub UI labels (Settings, Actions, Runners, New self-hosted runner, Run workflow) | kept in English | they match the English screenshots |

## Proper nouns in examples

| English | 日本語 | Notes |
|---|---|---|
| Build4D, Tool4D (tool4d), 4D Volume Desktop, 4D Server | unchanged | product names |
| GitHub, GitHub Actions, PowerShell | unchanged | |
| Soukaina BACHIKH, Customer Success Engineer, 4D Inc. | Soukaina BACHIKH（4D Inc. カスタマーサクセスエンジニア） | cover |
| compileMethod, buildMethod, buildClient(), buildServer(), host_startup() | unchanged | method names |
