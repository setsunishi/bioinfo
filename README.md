# 生物情報処理演習（統計学的仮説検定シリーズ）

名古屋大学 農学部・資源生物科学科「生物情報処理演習」の講義スライド・インタラクティブWeb教材・自動採点対応ワークブックのリポジトリです。

## 📁 ディレクトリ構成

本リポジトリ（`bioinfo`）は、講義回（テーマ）ごとのサブフォルダで構成されています。

```text
bioinfo/
├── index.html                        # 演習シリーズ全体ポータル表紙
├── README.md                         # 本ドキュメント（Remote Agent 引き継ぎ仕様含む）
├── paired_t_test/                    # 【第7回】検定①：1標本t検定 & 対応のあるt検定（完成版）
│   ├── index.html                    # 第7回 学生向けポータル（表紙）
│   ├── slieds.html / slides.html     # Web講義スライド（全33枚、KaTeX・コピーボタン付）
│   ├── slides.md                     # スライド原稿 Markdown
│   ├── 生物情報処理演習_検定1_改善版スライド.pptx # PowerPoint版スライド
│   ├── ひな型.Rmd                    # R Markdown 演習ひな型
│   ├── kadai7_interactive.html       # 学生用インタラクティブ課題ワークブック（提出用HTML出力機能付）
│   ├── grader_dashboard.html         # 【教員用・非公開リンク】ドラッグ＆ドロップ一括採点ダッシュボード
│   ├── grade_submissions.R           # 【教員用・非公開リンク】Rによる提出HTML一括採点スクリプト
│   └── kadai/                        # 演習用データセット
│       ├── table1.xlsx               # Genotype A（24系統：出穂後5日 SW5 / 35日 SW35 茎葉重）
│       ├── table2.xlsx               # Genotype B（52系統：出穂後5日 SW5 / 35日 SW35 茎葉重）
│       └── 検定1_課題ファイル.xlsx    # 元データブック
├── unpaired_t_test/                  # 【第8回】検定②：独立2標本のt検定（Student vs Welch）（完成版）
│   ├── index.html                    # 第8回 学生向けポータル（表紙）
│   ├── slieds.html / slides.html     # Web講義スライド（全33枚、KaTeX・コピーボタン付）
│   ├── slides.md                     # スライド原稿 Markdown
│   ├── 生物情報処理演習_検定2_改善版スライド.pptx # PowerPoint版スライド
│   ├── ひな型.Rmd                    # R Markdown 演習ひな型（コピーボタン付）
│   ├── kadai8_interactive.html       # 学生用インタラクティブ課題ワークブック（提出用HTML出力機能付）
│   ├── grader_dashboard.html         # 【教員用・非公開リンク】ドラッグ＆ドロップ一括採点ダッシュボード
│   ├── grade_submissions.R           # 【教員用・非公開リンク】Rによる提出HTML一括採点スクリプト
│   ├── kadai.txt / kinoko.csv        # Rmd直接実行用データ（kadai/内と同内容）
│   └── kadai/                        # 演習用データセット一式
│       ├── kadai.txt                 # イネ76系統データ（Genotype A: 24, B: 52, SW5 / SW35 / SW5_35）
│       ├── kadai_独立2群の検定.xlsx   # Excel版課題データブック
│       ├── kinoko.csv                # 斜面（Shita vs Ue）のキノコ傘長データ（計129本）
│       └── kinoko_reidai.xlsx        # キノコ例題Excelブック
├── 2025lecture7/                     # 【過去資料】第7回（対応のあるt検定）元資料一式
├── 2025lecture8/                     # 【過去資料】第8回（独立2群のt検定）元資料 & 試作HTML一式
├── 2025lecture9/                     # 【次回作成用】第9回（1元配置分散分析・多重比較）元資料一式
├── 2025lecture10/                    # 【次回作成用】第10回（2元配置分散分析・交互作用）元資料一式
└── 2025lecture11/                    # 【次回作成用】第11回（ノンパラメトリック検定）元資料一式
```

> **重要（教員用採点ファイルについて）**  
> `grader_dashboard.html` および `grade_submissions.R` は管理・継続開発のため同じフォルダ（`paired_t_test/`、`unpaired_t_test/`）内に配置していますが、**学生向けの表紙（`index.html`）からは一切リンクしていません**。

---

## 🗺️ カリキュラム全体構成（全5回シリーズ）

1. **第7回（`paired_t_test/`）**：1標本t検定・対応のあるt検定（同一株の前後比較、個体差ノイズ相殺）
2. **第8回（`unpaired_t_test/`）**：対応のない2標本t検定（独立2群比較、Student vs Welch）
3. **第9回（`one_way_anova/` 予定）**：1元配置分散分析（One-way ANOVA）と多重比較（Tukey / Dunnett）
4. **第10回（`two_way_anova/` 予定）**：2元配置分散分析（Two-way ANOVA）と交互作用
5. **第11回（`non_parametric/` 予定）**：ノンパラメトリック検定（Wilcoxon / Mann-Whitney / Kruskal-Wallis）

---

## 🤖 Remote Agent 引き継ぎ・開発ガイドライン

Remote Agent で本リポジトリの作業を継続する際は、以下の設計方針・仕様に従ってください。

### 1. 教育的デザインの柱（第7回 `paired_t_test` の実装仕様）
- **数理ステップの丁寧な接続**：母標準偏差 $\sigma$ 既知の $Z$ 値 $\rightarrow$ 標本標準偏差 $s$ で代用する $t$ 統計量 $\rightarrow$ 自由度 $df = n-1$ の $t$ 分布 $\rightarrow$ 裾野の面積としての $p$ 値。
- **2大「Wow!（納得・発見）」体験の組み込み**：
  1. **統計的ノイズキャンセリング（発展4）**：`table2.xlsx` に対して本来の `paired = TRUE`（$t = 10.106, df = 51, p = 8.986 \times 10^{-14}$）と、あえて対応を無視した `paired = FALSE`（Welch検定：$t = 4.487, df = 97.35, p = 1.978 \times 10^{-5}$）を比較させ、個体差を差し引くことで $p$ 値が約10億倍シャープになることを体感させる。
  2. **逆走個体の探偵ワーク（発展5）**：`table2.xlsx`（52系統）は平均では $-11.84\text{ g}$ 激減するが、個体別の差 `SW35 - SW5` を見ると **系統8（$+6.61\text{ g}$）、系統11（$+7.07\text{ g}$）、系統28（$+3.09\text{ g}$）の3系統だけが増加**していることを発見させ、生物学的・実験的理由を考察させる。
- **カリキュラム範囲**：QTL解析やGWASは本演習の範囲外のため扱わず、全5回の検定シリーズの基礎として位置づける。

### 2. 第7回データの正解値リファレンス
- **課題1（`table1.xlsx`, Genotype A, $n = 24$, 両側）**：
  - $t = 1.4210$, $df = 23$, $p = 0.1688$, 95% CI $[-1.007, 5.426]$, 平均差 $2.209\text{ g}$ $\rightarrow$ 有意差なし（Stay-green性）
- **課題2（`table2.xlsx`, Genotype B, $n = 52$, 両側）**：
  - $t = 10.106$, $df = 51$, $p = 8.986 \times 10^{-14}$, 95% CI $[9.486, 14.189]$, 平均差 $11.838\text{ g}$ $\rightarrow$ 1%水準で有意な減少（枯れ上がり）
- **課題3（`table2.xlsx`, Genotype B, 片側 `alternative = "greater"` on `SW5, SW35`）**：
  - $t = 10.106$, $df = 51$, $p = 4.493 \times 10^{-14}$（両側検定の半分）

### 3. 教育的デザインの柱（第8回 `unpaired_t_test` の実装仕様）
- **数理ステップの丁寧な接続**：独立2群の平均差の分散加法性 $\text{Var}(\bar{X}_A - \bar{X}_B) = \frac{\sigma_A^2}{n_A} + \frac{\sigma_B^2}{n_B}$ $\rightarrow$ プール分散 $s_p^2$ を用いる Student の $t$ 検定（$df = n_A + n_B - 2$）と等分散性を仮定しない Welch の $t$ 検定（Welch-Satterthwaite の自由度） $\rightarrow$ 2段階検定の多重性問題を避け最初から Welch 法をデフォルトとする現代統計学の推奨。
- **2大「Wow!（納得・発見）」体験の組み込み**：
  1. **スナップショットの罠と変化量（Delta）の逆転劇（発展4）**：出穂後5日目（`SW5`：$p = 0.139$）も35日目（`SW35`：$p = 0.258$）も単独時点ではGenotype AとBに有意差がないのに、個体ごとの減少量（`SW5_35 = SW5 - SW35`）で比較すると $t = -4.9457, p = 9.193 \times 10^{-6}$ という圧倒的な有意差が現れる（平均のクロスオーバー＋個体差ノイズ半減のダブル効果）。さらに片側検定（`alternative = "less"`）で $p = 4.596 \times 10^{-6}$ となることを確認させる。
  2. **$p = 0.05096$ のジレンマと Welch の安心感（発展5）**：`kinoko.csv`（斜面下側 `Shita` $n = 61$ vs 上側 `Ue` $n = 68$）の等分散検定 `var.test(Length ~ Shamen, data = kinoko)` が $F = 1.635, p = 0.05096$ という $\alpha = 0.05$ 境界線上の値になることを体験させ、Student（$p = 0.0001273$）でも Welch（$p = 0.0001626, df = 113.35$）でも頑健に有意差が示せることを確認させる。

### 4. 第8回データの正解値リファレンス（`kadai.txt`: Genotype A $n = 24$, Genotype B $n = 52$）
- **課題1（`SW5 ~ Genotype`, 両側）**：
  - 平均：A = $47.451\text{ g}$ ($SD = 15.458$), B = $53.126\text{ g}$ ($SD = 14.849$)
  - 等分散検定 `var.test`：$F = 1.0837$, $df = (23, 51)$, $p = 0.7865$
  - Student (`var.equal = TRUE`)：$t = -1.5288$, $df = 74$, $p = 0.1306$
  - Welch (`var.equal = FALSE`)：$t = -1.5060$, $df = 43.226$, $p = 0.1393$ $\rightarrow$ 有意差なし
- **課題2（`SW35 ~ Genotype`, 両側）**：
  - 平均：A = $45.242\text{ g}$ ($SD = 14.796$), B = $41.288\text{ g}$ ($SD = 11.891$)
  - 等分散検定 `var.test`：$F = 1.5483$, $df = (23, 51)$, $p = 0.1947$
  - Student (`var.equal = TRUE`)：$t = 1.2455$, $df = 74$, $p = 0.2169$
  - Welch (`var.equal = FALSE`)：$t = 1.1491$, $df = 37.263$, $p = 0.2579$ $\rightarrow$ 有意差なし
- **課題3（`SW5_35 ~ Genotype`, 両側）**：
  - 平均：A = $2.209\text{ g}$ ($SD = 7.618$), B = $11.838\text{ g}$ ($SD = 8.447$)
  - 等分散検定 `var.test`：$F = 0.8134$, $df = (23, 51)$, $p = 0.6000$
  - Student (`var.equal = TRUE`)：$t = -4.7593$, $df = 74$, $p = 9.394 \times 10^{-6}$
  - Welch (`var.equal = FALSE`)：$t = -4.9457$, $df = 49.342$, $p = 9.193 \times 10^{-6}$ $\rightarrow$ 1%水準で極めて有意な差
- **発展4（`SW5_35 ~ Genotype`, 片側 `alternative = "less"`）**：
  - Welch：$t = -4.9457$, $df = 49.342$, $p = 4.596 \times 10^{-6}$（Student：$p = 4.697 \times 10^{-6}$）
- **発展5（`kinoko.csv`, `Length ~ Shamen`, 両側）**：
  - 等分散検定 `var.test`：$F = 1.6350$, $df = (60, 67)$, $p = 0.05096$
  - Student (`var.equal = TRUE`)：$t = -3.9532$, $df = 127$, $p = 0.0001273$
  - Welch (`var.equal = FALSE`)：$t = -3.9014$, $df = 113.35$, $p = 0.0001626$

### 5. UI / コードブロック規約
- すべてのRコードブロックにはワンクリック「📋 コピー」ボタンを付与する。
- コードブロック（`.code-box`）は上下に余計な空白が入らないよう、`<code>` 内の先頭・末尾の改行を除去し、コンパクトなパディング（`padding: 8px 14px;`）を維持する。
- 学生用課題ページ（`kadai7_interactive.html` / `kadai8_interactive.html`）から出力される提出用HTMLには `<script id="grading-data" type="application/json">` として解答JSONが埋め込まれ、`grader_dashboard.html`（ブラウザ上でのドラッグ＆ドロップ）または `grade_submissions.R` で即座に一括採点・CSV出力ができる仕組みになっている。
