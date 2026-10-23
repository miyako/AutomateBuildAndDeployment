# Build4Dコンポーネントによるビルドとデプロイの自動化

Soukaina BACHIKH（4D Inc. カスタマーサクセスエンジニア）

## 概要

4Dが現代的なソフトウェア開発手法に対応して進化するにつれ、ビルドの自動化と再現可能なデプロイパイプラインが欠かせないものになっています。4Dチームが4Dコンポーネントとして提供している**Build4D**は、4Dアプリケーションのコンパイル、ビルド、パッケージングの自動化を支援します。スタンドアロンアプリケーション、コンポーネント、クライアント/サーバーのバイナリの作成をスクリプトで制御できるため、DevOpsの原則を4Dのワークフローに取り入れるうえで重要な役割を果たします。このテクニカルノートでは、Build4Dの概要と仕組みを説明し、さまざまな種類の4Dプロジェクトをビルドする実践的な例を紹介します。

## はじめに

今日のソフトウェア開発では、物事が速いスピードで進みます。チームには、品質を犠牲にすることなく、アップデートを素早く提供し、バグを効率よく修正し、システムの安定性を保つことが求められます。これに対応するには、自動化はもはや単なる便利な機能ではありません。誰がビルドを実行しても、どこで実行しても、一貫性のある再現可能な結果を得るための手段です。そこで役立つのが**Build4D**です。

Build4Dは、4Dアプリケーションのビルド、署名、パッケージングの処理を自動化するために設計された4Dコンポーネントです。ビルドのたびにメニューを手作業で操作し、同じ作業を繰り返す代わりに、Build4Dではすべての操作をスクリプトで実行できます。これにより、ひとつのコマンドでビルドを開始したり、継続的インテグレーション（Continuous Integration、CI）のパイプラインに自動で組み込んだりできます。

このテクニカルノートでは、Build4Dを使い始めるための手引きとして、次の内容を取り上げます：

- Build4Dの機能と、開発ワークフローへの組み込み方の概要
- プロジェクトの要件に合わせたBuild4Dスクリプトの書き方とカスタマイズ方法
- 自動化された環境でのBuild4Dの使用例

ひとりで開発する場合でもチームで開発する場合でも、Build4Dは4Dの開発を現代的なソフトウェアエンジニアリングの手法に近づけます。それでは、Build4Dを効果的に導入する方法を見ていきましょう。

## Build4Dとは

### コンポーネントの概要

Build4Dは、アプリケーションのビルドとパッケージングをコードで簡単に自動化できるようにする4Dコンポーネントです。ビルドのたびに4Dのインターフェースを手作業で操作する代わりに、スクリプトを使って、コンパイル済みファイル、スタンドアロンアプリケーション、クライアント/サーバー構成、コンポーネントを一貫した方法で繰り返し生成できます。これは、CI/CDパイプラインのような変化の速い環境や大規模なチームで特に役立ちます。Build4Dによってワークフローが効率化され、手作業によるミスが減ります。

### 対応する4Dのバージョンと互換性

Build4Dは、4D v18で導入されたプロジェクト形式の4Dアプリケーションに対応しています。Build4Dコンポーネント自体は4D v19 R3から提供されており、リリースごとに改良されています。互換性の問題を避け、すべての機能を活用するために、使用している4Dのバージョンに対応するBuild4Dを使うことをお勧めします。

互換性を確保するには：

1. **現在の4Dのバージョンを確認する**  
   4Dアプリケーションの「4Dについて」でバージョンを確認します。
2. **対応するバージョンのBuild4Dをダウンロードする**  
   公式のBuild4D GitHubリポジトリ（https://github.com/4d-depot/Build4D）にアクセスし、使用している4Dのバージョンに対応するブランチ（例：4D v20の場合は4D20.x）を選択します。

Build4Dと4D環境の互換性は、信頼性が高く効率的な開発プロセスを維持するために不可欠です。

### Build4Dを4Dに組み込む

Build4Dは、4Dプロジェクトにコンポーネントとしてインストールします：

- `Build4D.4dbase`フォルダーをプロジェクトの`Components`フォルダーに追加するか、公式のGitHubリポジトリからクローンします（コンポーネントの追加方法の詳細はこちらのテクニカルティップを参照してください）。
- コンポーネントは、インタープリター版とコンパイル済み版のどちらでも使用できます。
- Build4Dの機能には、cs.Build4D.Standalone、cs.Build4D.Server、cs.Build4D.CompiledProjectなどのクラスを通じてアクセスします。

***注：*** *インタープリター版のコンポーネントを使用する場合は：*

- *「Build4D」フォルダーをプロジェクトの「Components」フォルダーにコピーし、*
- *「Build4D」フォルダーに拡張子「.4dbase」を付けます。*

## Build4Dの設定

Build4Dをプロジェクトに組み込んだら、次はビルドの要件に合わせて設定します。この設定では、コンポーネントが提供する専用のクラスを使ってビルドの引数を定義します。

### Build4Dのクラス

Build4Dは、cs.Build4Dクラスストア（ClassStore）にいくつかのクラスを用意しており、それぞれ異なるビルドシナリオに対応しています：

- **cs.Build4D.CompiledProject**：.4dz形式のコンパイル済みストラクチャーファイルを作成します。
- **cs.Build4D.Component**：再利用可能な4Dコンポーネントをビルドします。
- **cs.Build4D.Standalone**：スタンドアロンアプリケーションをビルドします。
- **cs.Build4D.Server**：クライアント/サーバーアプリケーションのサーバー側をビルドします。
- **cs.Build4D.Client**：クライアント/サーバーアプリケーションのクライアント側をビルドします。

これらのクラスはすべて「**_core**」クラスを継承しており、設定後にビルド処理を開始するbuild()メソッドを備えています。

### 主な引数とその用途

| 引数 | 説明 |
|---|---|
| **projectFile** | 4Dプロジェクトファイルのパス |
| **sourceAppFolder** | - 4D Volume Desktopフォルダーのパス（クライアント）<br>- 4D Serverフォルダーのパス（サーバー） |
| **destinationFolder** | 最終的なビルドファイルを出力するフォルダー |
| **buildName** | 生成するアプリケーションまたはストラクチャーの名前 |
| **IPAddress** | クライアントのビルド設定に追加するサーバーのIPアドレス（クライアントを正しいサーバーに接続するため） |
| **versioning** | ビルドのメタデータに埋め込むバージョン番号 |
| **appShortVersion** | 人が読める形式のバージョン番号（例：1.0.0） |
| **iconPath** | カスタムのアプリケーションアイコンのパス |

これらの引数は、クラスのbuild()メソッドに渡すオブジェクトの一部です。そのほかの引数については公式ドキュメントを参照してください。

## ビルドシナリオ

この章では、Build4Dを使ってさまざまな種類のビルドを生成する方法を実践的な例で説明します。これらのシナリオでは、コンポーネントのクラスと引数を使って、プロジェクトの構成に合わせたビルドを自動化する方法を示します。

以下のシナリオは、4Dのグラフィカルな**アプリケーションビルド**（Build Application）画面で選択できるビルドの種類に対応しています：

![](fig-01)

### 1. コンパイル済みストラクチャーをビルドする

コンパイル済みストラクチャー（.4dz）は、本番運用向けアプリケーションの基礎となるものです。パフォーマンスが向上し、ソースコードを保護でき、スタンドアロン形式やクライアント/サーバー形式で配布するために必要です。Build4Dを使うと、コンパイル処理を簡単に自動化できます。

以下は、cs.Build4D.CompiledProjectクラスを使ってコンパイル済みストラクチャー（.4dz）を作成するコメント付きの例です。

```4d
// Declare variables for the build object, settings, and result
var $build : cs.Build4D.CompiledProject
var $settings : Object
var $success : Boolean

// Create and initialize the settings object
$settings := New object()

// Define the output folder where the compiled structure (.4dz) will be saved
$settings.destinationFolder := Folder(fk desktop folder).folder("builtStructure/")

// Define the name of the compiled structure
$settings.buildName := "myCompiledStructure"

// Define additional files or folders to include in the build (e.g., resources)
$settings.includePaths := New collection
$settings.includePaths.push(New object("source"; "Resources/"))

// Instantiate the build object with the settings
$build := cs.Build4D.CompiledProject.new($settings)

// Launch the build process and store the result (True if successful)
$success := $build.build()
```

その結果、ほかの配布形式にパッケージングできる.4dzファイルが作成されます。

![](fig-02)

### 2. コンポーネントをビルドする

4Dコンポーネント（.4dbase）は、ロジック、フォーム、メソッドをまとめて複数のプロジェクトで共有できるようにした再利用可能なモジュールです。モジュール化された開発とコードの再利用を促進します。Build4Dを使うと、必要なリソースだけを含め、開発用のファイルを除外したコンポーネントを自動で生成できます。

以下は、cs.Build4D.Componentクラスを使って再利用可能な4Dコンポーネント（.4dbase）をビルドするコメント付きの例です。

```4d
// Declare variables for the build object, settings, and success flag
var $build : cs.Build4D.Component
var $settings : Object
var $success : Boolean

// Create and initialize the settings object
$settings := New object()
// Define the output folder where the component will be generated
$settings.destinationFolder := "./Test/"

// Set the name of the resulting component
$settings.buildName := "myComponent"

// Define which folders or files to include in the component package
$settings.includePaths := New collection
$settings.includePaths.push(New object("source"; "./Documentation/"; "destination"; ""))

// Define which folders or files to remove before packaging the component
$settings.deletePaths := New collection
$settings.deletePaths.push("./Resources/Dev/")  // Exclude development resources

// Instantiate the build object with the configured settings
$build := cs.Build4D.Component.new($settings)

// Execute the build process and store the result (True if successful)
$success := $build.build()
```

メソッドを実行すると、ホストプロジェクトに追加できる.4dbaseプロジェクトが作成されます。

![](fig-03)

完成した「.4dbase」コンポーネントは、ほかの4Dプロジェクトの「Components」フォルダーにコピーして使用できます。

![](fig-04)

### 3. スタンドアロンアプリケーションをビルドする

スタンドアロンアプリケーションは、ストラクチャーとデータファイルの両方を含む自己完結型の実行ファイルです。シングルユーザーでの使用やデスクトップ向けの配布を想定しており、別途サーバーを用意する必要はありません。Build4Dを使うと、難読化、ライセンスの組み込み、UIの設定といった高度なオプションを含めて、スタンドアロンアプリケーションの作成をすべてスクリプトで行えます。

```4d
// Declare variables for the build object, settings, and success flag
var $build : cs.Build4D.Standalone
var $settings : Object
var $success : Boolean

// Initialize the settings object
$settings := {}

// Define the path to the project file to build
$settings.projectFile := Folder(fk desktop folder).file("demo-Build4D-Win/Project/demo-Build4D-Win.4DProject")

// Set the name of the resulting application
$settings.buildName := "myApp"

// Define the output directory where the standalone app will be generated
$settings.destinationFolder := Folder(fk desktop folder).folder("standaloneApp")

// Configuration options
$settings.obfuscated := True              // Obfuscate the source code (protects intellectual property)
$settings.packedProject := False          // Choose whether to pack project files into a single bundle
$settings.useSDI := False                 // Use Single Document Interface (for Windows apps)
$settings.startElevated := True          // Run the installer with admin rights if needed
$settings.lastDataPathLookup := "ByAppPath" // Determines how the app finds its last used data file

// Define the path to the source 4D application
$settings.sourceAppFolder := Folder(fk documents folder).folder("4D 20 R8 100333/4D Volume Desktop")

// Exclude development folders or files from the final build
$settings.deletePaths := New collection("Resources/Dev/")

// Application metadata
$settings.versioning := New object()
$settings.versioning.version := "1.0.0"
$settings.versioning.copyright := "copyright"
$settings.versioning.companyName := "4D"

// Specify the path to the deployment license file
$settings.license := Folder(fk licenses folder).file("4USDxxxxxxx.license4D")

// Instantiate the build object with the settings
$build := cs.Build4D.Standalone.new($settings)

// Launch the build process and store the result (True if successful)
$success := $build.build()
```

その結果、ユーザーのマシンに配布またはインストールできる自己完結型のアプリケーションが作成されます。

![](fig-05)

### 4. クライアント/サーバーアプリケーションをビルドする

**クライアント/サーバーアプリケーション**では、複数のユーザーが、サーバー上にある一元化された4Dデータベースとビジネスロジックにアクセスできます。サーバーがデータを管理し、各クライアントがユーザーインターフェースを提供します。Build4Dを使うと、アプリケーションのサーバー側とクライアント側の両方を一貫した方法で自動生成できます。

処理は2つの段階に分かれます：

- まず、**クライアント**をビルドします。これには、サーバーに組み込むアーカイブが含まれます。
- 次に、**サーバー**をビルドします。サーバーには、配布用にクライアントのアーカイブが組み込まれます。

**1. クライアントのビルドメソッド：** クライアント側のビルド設定を定義します。以下のコードを実行すると、client.exeと、サーバー側に組み込むアーカイブファイルが生成されます。

```4d
#DECLARE()->$result : Object

// Declare variables
var $build : cs.Build4D.Client
var $settings; $archive : Object
var $success : Boolean

// Initialize settings
$settings := {}

// Set elevated rights if required
$settings.startElevated := True

// Define the path to the 4D project
$settings.projectFile := Folder(fk desktop folder).file("demo-Build4D-Win/Project/demo-Build4D-Win.4DProject")

// Define the path to the source 4D Volume Desktop app
$settings.sourceAppFolder := Folder(fk documents folder).folder("4D 20 R8 100333/4D Volume Desktop")

// Define the output folder and application name
$settings.buildName := "clientApp"
$settings.publishName := "myAppCli"
$settings.destinationFolder := Folder(fk desktop folder).folder("buildApp/Client")

// Define the IP address of the server
$settings.IPAddress := "127.0.0.1"

// Set versioning and metadata
$settings.versioning := New object()
$settings.versioning.version := "1.0.0"
$settings.versioning.copyright := "copyright"
$settings.versioning.companyName := "4D SAS"

// Create the client build
$build := cs.Build4D.Client.new($settings)
$success := $build.build()

// Generate the client archive to be included in the server build
$archive := $build.buildArchive()

// Check the status
If ($success & $archive.archive.exists)
    $result:=New object("success"; $success; "logs"; $build.logs; "archiveClientWinPath"; $archive.archive.platformPath)
Else
    $result:=New object("success"; $success; "logs"; $build.logs)
End if
```

**2. サーバーのビルドメソッド：**

複数のクライアント接続に対応するためのネットワーク設定を含め、サーバー側のアプリケーションを設定してビルドします。以下のコードを実行すると、アプリケーションのサーバー側が生成されます。

```4d
#DECLARE()->$result : Object

// Declare variables
var $build : cs.Build4D.Server
var $settings : Object
var $success : Boolean

// Initialize settings
$settings := {}
$settings.startElevated := True

// Define the path to the 4D project
$settings.projectFile := Folder(fk desktop folder).file("demo-Build4D-Win/Project/demo-Build4D-Win.4DProject")

// Define the path to the 4D Server application
$settings.sourceAppFolder := Folder(fk documents folder).folder("4D 20 R8 100333/4D Server")

// Define output folder and application name
$settings.buildName := "serverApp"
$settings.destinationFolder := Folder(fk desktop folder).folder("buildApp/Server")

// Set versioning and metadata
$settings.versioning := New object()
$settings.versioning.version := "1.0.0"
$settings.versioning.copyright := "copyright"
$settings.versioning.companyName := "4D SAS"

// Add the widows client archive
If ($archiveClientPath#Null & File($archiveClientPath; fk platform path).exists)
    $settings.windowsClientArchive:=$archiveClientPath
End if

// Create the server build
$build := cs.Build4D.Server.new($settings)
$success := $build.build()

// Return build status and logs
$result := New object("success"; $success; "logs"; $build.logs)
```

2つのメソッドを実行すると、クライアントとサーバーの両方のアプリケーションが出力先フォルダーに作成されます。

![](fig-06)

## CI/CDとGitHub Actionsによるワークフローの自動化

現代のソフトウェア開発では、コードのテスト、ビルド、デプロイを自動化するために、**CI/CDパイプライン**（継続的インテグレーションと継続的デプロイ）が欠かせません。CI/CDパイプラインは、コードの品質を高め、リリースサイクルを短縮し、環境間の一貫性を確保します。

この章では、CI/CDの基本を紹介し、**GitHub Actions**を使って自動化されたワークフローを作成する方法を、「.yaml」ファイルの定義やワークフローのステップの設定を含めて説明します。

### 1. CI/CDとは

- **継続的インテグレーション（Continuous Integration、CI）** は、ソースリポジトリに変更がプッシュされるたびに、コードのビルドとテストを自動で行う手法です。
- **継続的デプロイ（Continuous Deployment、CD）** は、CIをさらに進めて、ビルドがすべてのテストと検証に合格した時点でアプリケーションを自動でデプロイします。

CI/CDを組み合わせることで、チームの連携が強化され、本番環境でのバグが減り、開発環境、ステージング環境、本番環境の間の一貫性が確保されます。

### 2. GitHub Actionsのワークフロー

**GitHub Actions**は、GitHubに組み込まれたCI/CDプラットフォームで、アプリケーションのビルド、テスト、デプロイなどの作業を自動化できます。ワークフローは、ブランチへのプッシュ、プルリクエスト、スケジュール実行などのイベントをきっかけに実行されます。そのため、GitHub Actionsは、4Dの自動ビルドを含む現代的な開発パイプラインに非常に適しています。

各ワークフローは、リポジトリの.github/workflows/ディレクトリに置いた.yamlファイルで定義します。これらのYAMLファイルには、コードのチェックアウト、ビルドコマンドの実行、結果のデプロイなど、実行する一連の処理を記述します。

![](fig-07)

GitHub Actionsのこの画面は、ワークフローがまだ設定されていないときに表示されます。ここから、ワークフローファイルを手作業で作成するか、用意されているテンプレートを選んでCI/CDの自動化を始めることができます。

### 3. .yamlファイルの設定

ワークフローファイルは、通常、次の3つの主要な要素で構成されます：

1. **トリガー**（Triggers）：ワークフローを開始するイベント（例：`push`、`pull_request`、`workflow_dispatch`（手動トリガー））
2. **ジョブ**（Jobs）：GitHubホステッドランナーまたはセルフホステッドランナー上で実行される独立したタスク
3. **ステップ**（Steps）：ジョブ内で実行されるコマンドまたはアクション

例：mainブランチへのプッシュのたびに実行されるシンプルなワークフローの例です：

```yaml
# Name of the workflow as it will appear in the GitHub Actions UI
name: Build 4D Application

# Define the trigger: this workflow runs on every push to the 'main' branch
on:
  push:
    branches: [ main ]

# Define the job(s) to run
jobs:
  build:  # Job name (can be any identifier)
    runs-on: windows-latest   # Specifies the OS/environment for the job runner
    steps:
      # Step 1: Checkout the code from the repository
      - name: Checkout repository
        uses: actions/checkout@v3    # Official GitHub Action to clone the repo

      # Step 2: Run a shell command as a placeholder for the actual build process
      - name: Build step
        run: echo "Running build steps..."  # Replace this with actual build commands (e.g., Tool4D)
```

## Build4DをCI/CDに組み込む

CI/CDパイプラインでの自動ビルドをサポートするために、4Dは**Tool4D**というコマンドラインユーティリティを提供しています。Tool4Dを使うと、グラフィカルな環境をすべて起動しなくても特定のプロジェクトメソッドを実行できるため、自動化ワークフローに最適です。

### Tool4Dによる4Dの作業の自動化

**Tool4D**は、4Dが提供するコマンドラインユーティリティで、ヘッドレスかつ最小限のリソースで動作します。Tool4Dを使うと、次のことができます：

- CLIから4Dのメソッドを直接実行する（--startup-method）
- プロジェクトをヘッドレスモードやデータレスモードで実行する（例：コンパイル、テスト、メンテナンス）
- CI/CDワークフローにシームレスに組み込む。GUIをすべて起動することなく、自動ビルド、ユニットテスト、プロジェクトのコンパイル、スクリプトによる作業に最適です。

例：

```shell
"C:\Program Files\4D\4D 20.6\tool4d.exe" "C:\Projects\MyApp\MyApp.4DProject" –build
```

各項目の意味：

- "C:\Program Files\4D\4D 20.6\tool4d.exe"は、tool4d実行ファイルのパスです（4Dのバージョンとインストール先に合わせて変更してください）。
- "C:\Projects\MyApp\MyApp.4DProject"は、4Dプロジェクトのパスです。
- --buildは、プロジェクトをビルドするようTool4Dに指示するコマンドラインオプションです（ほかに--compile、--checkなどがあります）。

***注：*** *使用するTool4Dのバージョンとプロジェクトに互換性があることを確認してください。*

## デモ：4Dのビルドパイプラインの自動化

このデモでは、Windowsプラットフォーム向けのバージョン20 R8（ビルド100333）を使って、4Dのクライアント/サーバーのビルドパイプラインを自動化する手順を説明します。自動化を効果的に実装するために、処理を一連のステップに分けています。デモの素材は、添付のプロジェクト「.zip」を参照してください。

### 1. プロジェクトをGitHubリポジトリにクローンする

ローカルで4Dプロジェクトを作成したら、次にそれをGitHubリポジトリにプッシュして、GitHub Actionsを利用できるようにします。

![](fig-08)

### 2. ランナーを作成する

GitHubでBuild4DとTool4Dを実行するには、ランナーが必要です。GitHubには2種類のランナーがあります。GitHubが管理しクラウドで実行される**GitHubホステッドランナー**と、ユーザーが管理するマシンで実行される**セルフホステッドランナー**です。このデモでは、Windows上の**セルフホステッドランナー**を使用します。

GitHubでセルフホステッドランナーを作成するには：

GitHubリポジトリで、Settings → Actions → Runners → New self-hosted runnerの順に移動します。

![](fig-09)

続いて、GitHubに表示される手順に従ってランナーを設定します。まず、GitHubの画面で適切なオペレーティングシステム（ここではWindows）を選択し、ローカルマシンでPowerShellを開いて（「管理者として実行」を推奨）、表示されたセットアップ用のコマンドを実行します。設定が完了すると、セルフホステッドランナーが最新の設定で登録され、使用できる状態になります。

![](fig-10)

最後に、GitHubランナーを起動してリポジトリに接続します。

![](fig-11)

### 3. ビルド用のメインメソッドを作成する

ワークフローファイルを設定する前に、4Dプロジェクト内に2つのメインメソッド、compileMethodとbuildMethodを作成しておく必要があります。これらのメソッドは、GitHubの自動ワークフローの中でTool4Dから呼び出されるエントリーポイントになります。

- compileMethod：このメソッドは、プロジェクト全体をコンパイルし、ソースコードにシンタックスエラーがないことを確認します。4Dに組み込まれているCompile projectコマンドを使って、プロジェクト全体をコンパイルします。このステップにより、エラーのない有効なコードだけがビルドの段階に進むため、デプロイ時の失敗を防げます。

```4d
// Log that the compilation process has started
LOG EVENT(Into system standard outputs; "Compilation starts\r\n")

// Declare variables
var $projectPath : Text
var $result : Integer
var $compilationReturn : Object

// Retrieve the project path passed through the --user-param parameter in the Tool4D CLI
$result := Get database parameter(User param value; $projectPath)

// If a valid project path is provided, compile the project and log the result
If ($projectPath#"")
    $compilationReturn := Compile project(File($projectPath))
    LOG EVENT(Into system standard outputs; "Compilation returns : \r\n" + JSON Stringify($compilationReturn; *))
End if
```

- buildMethod：このメソッドには、Build4Dコンポーネントを使って最終的なクライアント/サーバーアプリケーションをビルドする処理を記述します。対象となる配布形態に応じて、必要なビルド設定（例：クライアント/サーバー構成、フォルダーのパス、バージョン情報など）を含める必要があります。buildClient()とbuildServer()は、「ビルドシナリオ」の章で紹介したものです。

```4d
// Log the launch of the build process
LOG EVENT(Into system standard outputs; "✅ Starting Build Process\r\n")

// Declare result objects
var $resultClient; $resultServer : Object

// Run the client build
LOG EVENT(Into system standard outputs; "📦 Running buildClient...\r\n")
$resultClient := buildClient()
LOG EVENT(Into system standard outputs; "📦 buildClient result: " + JSON Stringify($resultClient) + "\r\n")

// Check if client build succeeded
If ($resultClient.success)
    // Proceed with server build
    LOG EVENT(Into system standard outputs; "🖥️ Running buildServer...\r\n")
    $resultServer := buildServer()
    LOG EVENT(Into system standard outputs; "🖥️ buildServer result: " + JSON Stringify($resultServer) + "\r\n")

    // Final check for both builds
    If ($resultServer.success)
        LOG EVENT(Into system standard outputs; "✅ All builds succeeded!\r\n")
    Else
        LOG EVENT(Into system standard outputs; "❌ Server build failed.\r\n")
    End if
Else
    // Client build failed – stop early
    LOG EVENT(Into system standard outputs; "❌ Client build failed. Aborting server build.\r\n")
End if
```

### 4. ワークフローファイルを作成する

このデモでは、2つのワークフローを使用します。ひとつはプロジェクトのコンパイルと検証用、もうひとつはBuild4Dコンポーネントを使ったプロジェクトのビルド用です。ワークフローを作成するには、GitHubのActionsセクションに移動するか、リポジトリの.github/workflowsフォルダーにワークフローファイルを追加します。

- コンパイル用ワークフロー：Windowsのセルフホステッドランナー上でTool4Dを使って4Dプロジェクトのコンパイルを自動化し、コンパイル結果を確認します。

```yaml
name: Compile 4D Project

on:
  push:
    paths:
      - 'Project/**'           # Trigger workflow only if files inside the 'Project' folder change
  workflow_dispatch:           # Also allow manual triggering of the workflow at any time

jobs:
  compile:
    runs-on: [self-hosted, Windows]  # Run this job on a self-hosted Windows 64-bit runner

    env:
      TOOL4D_PATH: C:\Users\Admin\Downloads\tool4d_win\tool4d\Tool4D.exe  # Environment variable for Tool4D executable path

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4  # Step to clone the repo so the runner has access to project files

      - name: Compile with Tool4D
        shell: cmd  # Use Windows CMD shell for this step
        run: |
          %TOOL4D_PATH% --project "C:\Users\Admin\Desktop\demo-Build4D-Win\Project\demo-Build4D-Win.4DProject"  --dataless --log-level=0 --user-param "C:/Users/Admin/Desktop/demo-Build4D-Win/Project/demo-Build4D-Win.4DProject" --skip-onstartup --startup-method "compileMethod"  > compile_output.txt
          # Run Tool4D to compile the 4D project using the 'compileMethod' startup method
          # Output is redirected to compile_output.txt for later analysis

      - name: Check compilation result
        shell: powershell  # Use PowerShell to analyze the compilation output
        run: |
          $content = Get-Content compile_output.txt -Raw  # Read entire output log file
          Write-Output "📄 Tool4D Output:"
          Write-Output $content  # Print the output content in the workflow logs

          # Check if output contains failure indicators: success=false or errors present
          if ($content -match '"success"\s*:\s*false' -or $content -match '"errors"\s*:\s*\[[^\]]+') {
              Write-Output "❌ Compilation completed with errors!"
              exit 1  # Fail the workflow if errors detected
          } else {
              Write-Output "✅ Compilation succeeded with no errors!"
          }
```

- ビルド用ワークフロー：Windowsのセルフホステッドランナー上でTool4Dを使って4Dのクライアント/サーバーアプリケーションのビルドを自動化し、ビルド結果を報告します。

```yaml
name: Build 4D Project

on:
  workflow_dispatch:           # Still allow manual trigger anytime

jobs:
  build:
    runs-on: [self-hosted, Windows, X64]     # Run this job on a self-hosted Windows 64-bit runner

    env:
      TOOL4D_PATH: C:\Users\Admin\Downloads\tool4d_win\tool4d\Tool4D.exe  # Path to the Tool4D executable

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4   # Clone the repository so the runner has access to the project files

      - name: Build with Tool4D
        shell: cmd      # Use Windows CMD shell for this step
        run: |
          %TOOL4D_PATH% --project "C:\Users\Admin\Desktop\demo-Build4D-Win\Project\demo-Build4D-Win.4DProject" --dataless --skip-onstartup --startup-method "buildMethod" > build_output.txt
          # Execute Tool4D to build the 4D project using the 'buildMethod' startup method
          echo "📄 Tool4D Build Output:"
          type build_output.txt

      - name: Check build result
        shell: powershell        # Use Windows PowerShell for this step
        run: |
          $content = Get-Content build_output.txt -Raw
          # Verify the build result if it has been succeeded or failed
          if ($content -notmatch '✅ All builds succeeded!') {
              Write-Output "❌ Build did not complete successfully."
              exit 1
          } else {
              Write-Output "✅ Build log confirms successful execution."
          }
```

### 5. コンパイルとビルドのワークフローを実行する

ワークフローを設定したら、次はそれらをトリガーしてコンパイルとビルドの処理を開始します。手動で実行することも、設定したトリガーに基づいて自動で実行することもできます。

#### コンパイル用ワークフローを実行する

Actionsで「Compile 4D Project」をクリックして、ワークフローを手動で実行します。

![](fig-12)

コンパイル用ワークフローを実行すると、成功と失敗の2つのシナリオが考えられます。

##### コンパイルの成功

プロジェクトがエラーなくコンパイルされ、ソースコードが有効でビルドの段階に進めることが確認されます。ログにはコンパイルの成功が示され、パイプラインは次に進みます。

しばらくすると、ワークフローが成功します。

![](fig-13)

詳細を確認するには、ワークフロー名をクリックし、各ステップを順に確認します。

![](fig-14)

***注：*** *プッシュ時には自動でトリガーされます（この例ではマージ…）*

![](fig-15)

##### コンパイルの失敗

コンパイルでエラーが検出されると、ワークフローは停止してエラーを報告します。詳細なログから問題を特定できるため、開発者は次のビルドを試みる前に問題を解決できます。このデモでは、コンパイルを失敗させるために、host_startup()メソッドに意図的にシンタックスエラーを入れています。

![](fig-16)

変更をGitHubにプッシュすると、コンパイル用ワークフローが自動でトリガーされ、エラーが報告されます。

![](fig-17)

エラーを確認するには、ワークフローの実行結果で**Compile**ジョブのログを参照します。これにより、ビルドの処理に進む前に問題を確実に解決できます。

![](fig-18)

#### ビルド用ワークフローを実行する

コンパイル用ワークフローが正常に完了したら、**Actions**タブで「**Build 4D Project**」を選択し、「**Run workflow**」をクリックして、ビルド用ワークフローを手動で実行できます。

このステップでbuildMethodが実行され、クライアント/サーバーアプリケーションが生成されます。

![](fig-19)

ビルド用ワークフローを実行すると、成功と失敗の2つのシナリオが考えられます。

##### ビルドの成功

クライアント/サーバーアプリケーションが正常にビルドされます。ワークフローはエラーなく完了し、ログに成功メッセージが表示されて、ビルド処理が期待どおりに実行されたことが確認できます。

![](fig-20)

セルフホステッドランナーを設定したローカルマシンでは、指定した出力先フォルダーにビルドされたアプリケーションが作成されています。

![](fig-21)

クライアントとサーバーのアプリケーションを実行すると、次のような結果になります：

クライアント側：ホストデータベースの開始メソッド内でアラートが表示されます。

![](fig-22)

サーバー側：クライアントがサーバーに正常に接続されています。

![](fig-23)

##### ビルドの失敗

ビルド中に問題（例：設定の誤り、ファイルの欠落、ロジックのエラー）が発生すると、ワークフローは停止し、失敗をログに記録します。これらのログは、ビルドを再実行する前に問題を特定して解決するのに役立ちます。

たとえば、出力先フォルダーの行をコメントアウトします。

![](fig-24)

コンパイルは成功しました。

![](fig-25)

しかし、ビルドを実行すると、ジョブの詳細に次のエラーが表示されました：

*“tool4d.4DRT [-10716] Object or Collection Expected. (task=-1, taskName=Main task)”*

![](fig-26)

デモの手順を簡単にまとめます：

1. **4DプロジェクトをGitHubにプッシュ**し、GitHub ActionsでCIを利用できるようにします。
2. **Windowsのセルフホステッドランナーを設定**し、ローカルでビルドを実行できるようにします。
3. **2つのワークフローを作成します：**
    - コンパイル用ワークフロー：**compileMethod**でコンパイルの成功を確認します。
    - ビルド用ワークフロー：**buildMethod**でクライアント/サーバーアプリケーションをビルドします。
4. **ログを取得し、エラーや成功を示すメッセージを確認**して、ワークフローの状態を判定します。
5. **ワークフローを実行します：**コンパイルはプッシュ時に、ビルドは手動で実行します。
6. **結果を確認します：**コンパイルが成功すればビルドに進めます。失敗した場合は詳細なログをもとに修正します。

## まとめ

このテクニカルノートでは、4Dプロジェクトのビルド処理を簡素化し自動化するために設計されたBuild4Dコンポーネントの基本的な考え方と使い方を説明しました。Build4Dを組み込んで設定する方法と、GitHub Actionsとセルフホステッドランナーを使ってCI/CDパイプラインに組み込む方法を紹介しました。このガイドを参考にすれば、自動ビルドを効率よく構築し、手作業を減らし、一貫したアプリケーションの配布を実現できます。
