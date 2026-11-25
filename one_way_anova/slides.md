---
title: "生物情報処理演習 第9回"
subtitle: "統計学的仮説検定 ③ 〜1元配置分散分析（One-way ANOVA）と多重比較〜"
author: "生物情報処理演習"
date: "2026-11-24"
output: powerpoint_presentation
---

# 今日のゴール（What & Why）

### 「3群以上の平均値」を科学的に正しく比較するための武器を手に入れる

- **1. なぜ3群以上に「t検定の繰り返し」を使ってはいけないのか理解する**
  - 比較回数とともに偽陽性（第1種の過誤）が膨れ上がる**「多重検定の罠」**を数理で掴む
- **2. 1元配置分散分析（One-way ANOVA）の核心「変動の分割」を理解する**
  - なぜ「平均の比較」なのに「分散」を分析するのか？（群間分散 vs 群内誤差分散の $F$比）
- **3. 多重比較（Tukey-Kramer / Bonferroni / Holm / Dunnett）を使い分ける**
  - どのペアに差があるかを特定し、論文標準の**アルファベット表記（CLD: `a, b, bc`）**を描画する
- **4. 2大「Wow!」体験で多群検定の真髄を掴む**
  - 【Wow①】6群15ペア比較での補正法（Tukey / Bonferroni / Holm / Dunnett）の検出力の違い
  - 【Wow②】2群のとき「独立2群のt検定」と「1-way ANOVA」で **$t^2 = F$・$p$値が完全一致する**数学的感動！

# 生物統計・仮説検定ロードマップ（全5回）

### 5回シリーズの第3弾：実験科学で頻出する「3群以上（多群）の比較」

::: columns
::: {.column width="50%"}
- **第7回：1標本 & 対応のあるt検定**
  - 同一株の前後比較（引き算によるノイズ相殺）
- **第8回（前回）：独立2群の検定（対応なし）**
  - 異なる2群の比較（Student vs Welch）
- **👉 第9回（本日）：1元配置分散分析と多重比較**
  - **1つの要因で分けられた3群以上の比較（ANOVA・Tukey・Dunnett）**
:::
::: {.column width="50%"}
- **第10回（次回）：2元配置分散分析（2-way ANOVA）**
  - 2つの要因（例：品種×肥料）の主効果と「交互作用」
- **第11回：ノンパラメトリック検定**
  - 正規性が仮定できない場合の順位和検定

> **💡 前回（第8回）からのステップアップ**
> 前回マスターした**「スタック形式（1データ1行）」**と**「チルダ（`Y ~ X`）記法」**が、今回の分散分析でもそのまま主役として大活躍します！
:::
:::

# 本日のタイムラインと「練習／提出課題」の区分

### どこが練習で、どこが提出課題かを最初にクリアにして進めよう！

::: columns
::: {.column width="50%"}
### Part 1：講義・理論編 ＆ 授業内練習（約40分）
1. 3群以上でt検定を繰り返してはいけない理由（多重性の罠）
2. 1元配置分散分析の原理：**「変動（平方和）の分割」**と分散分析表
3. 多重比較の4大手法（Tukey-Kramer / Bonferroni / Holm / Dunnett）とCLD
4. **【授業内練習（提出不要）】**：トマト4種肥料の糖度データ（`トマト糖度スタック形式.xlsx`）で一連のRコードとDunnett法を体験
:::
::: {.column width="50%"}
### Part 2：本日の提出課題（全5問・100点満点）
- **Web課題ワークブック（`kadai9_interactive.html`）に入力して提出！**
  - **課題1（20点）**：ニワトリ6種飼料（`niwatori.csv`）の可視化・正規性・等分散性検定
  - **課題2（20点）**：ニワトリ体重の1元配置分散分析（`aov` & `oneway.test`）
  - **課題3（20点）**：Tukey-Kramer法による15ペア多重比較とCLD（`a, b, c`）
  - **発展4（20点）**：Bonferroni法とHolm法の検出力比較【Wow①】
  - **発展5（20点）**：2群データ（`kadai2_t_vs_ANOVA.csv`）で証明する **$t^2 = F$ の完全一致**【Wow②】
:::
:::

# 生成AI活用ガイド（第9回編）

### 分散分析表や多重比較（CLD）の読み解きにAIを賢く使おう！

::: columns
::: {.column width="50%"}
### ⭕ 理解が深まる良い質問例
- 「`summary(aov(Taiju ~ Esa))` の分散分析表に出てくる `Df`, `Sum Sq`, `Mean Sq`, `F value` の意味と計算関係を教えて」
- 「Compact Letter Display（CLD）で `linseed` が `"bc"`、`meatmeal` が `"ac"` になったとき、どの群とどの群に有意差があるの？」
- 「Bonferroni法よりHolm法の方が $p$値が小さくなりやすい理由を直感的に教えて」
:::
::: {.column width="50%"}
### △ もったいない使い方
- 「課題1〜5の答えと考察を全部書いて」
  - 本日のハイライトである**「なぜ平均の比較なのに分散の比 $F$ を見るのか？」「なぜ2群だと $t$値の2乗がピタリと $F$値になるのか？」**は、実際にRStudioで自分の手で数値を出して確かめることで一生モノの理解になります！
:::
:::

# 【復習】第7回・第8回のおさらいと「3群以上」への拡張

### これまでは「2群まで」だった。今日からは「3群以上（多群）」の世界へ！

::: columns
::: {.column width="50%"}
### これまでに学んだ 1群・2群の t検定
- **1標本 t検定**：`t.test(x, mu = 8)`
- **対応のある2群**：`t.test(x, y, paired = TRUE)`
  - 同一株の前後比較（差をとって1標本へ）
- **対応のない独立2群**：`t.test(Y ~ X, var.equal = FALSE)`
  - 別々の個体群（Genotype A vs B）の比較
:::
::: {.column width="50%"}
### しかし実際の生物・農学実験では…
- **例1（肥料試験）**：無肥料 vs 油粕 vs 骨粉 vs 化学肥料（**4群**）
- **例2（飼料試験）**：6種類のタンパク源飼料で育てたニワトリの体重（**6群**）
- **例3（濃度試験）**：対照区（0 mM）、1 mM、5 mM、10 mM、50 mM（**5群**）
- $\rightarrow$ **3群以上あるとき、2群ずつのt検定を繰り返してはいけないのか？**
:::
:::

# 【理論】なぜ3群以上に「t検定の繰り返し」を使ってはいけないのか？

### 比較ペア数 $m = \binom{a}{2}$ が増えると、「少なくとも1回間違う確率」が爆発する！

::: columns
::: {.column width="50%"}
### 3群（A, B, C）で3回 t検定を繰り返すと…
- 比較ペアは **A vs B、B vs C、A vs C の3通り**。
- もし本当は3群とも母平均が全く同じ（**全ペアで帰無仮説 $H_0$ が正しい**）としよう。
- 1回の検定で正しく「差がない」と判定できる確率は $1 - 0.05 = 0.95$（95%）。
- 3回すべてで間違えない確率は：
  $$(0.95)^3 = 0.857375 \approx 85.7\%$$
- つまり、**少なくとも1つのペアで誤って「有意差あり（偽陽性）」と判定してしまう確率（家族単位の過誤率 FWER）**は：
  $$1 - (0.95)^3 = 0.142625 \approx \mathbf{14.3\%}$$
  （本来5%に抑えるはずの危険率が**約3倍（20回に3回）**に跳ね上がる！）
:::
::: {.column width="50%"}
### 群数 $a$ が増えると偽陽性率はここまで膨張する！
$$P(\text{少なくとも1回誤棄却}) = 1 - (1 - \alpha)^m, \quad m = \frac{a(a-1)}{2}$$

| 群数 $a$ | 総当たりペア数 $m$ | すべて正しい確率 $0.95^m$ | **誤って有意が出る確率** |
|:---:|:---:|:---:|:---:|
| **2群** | 1 通り | $95.0\%$ | **$5.0\%$**（基準） |
| **3群** | 3 通り | $85.7\%$ | **$14.3\%$** |
| **4群** | 6 通り | $73.5\%$ | **$26.5\%$**（4回に1回誤報！） |
| **5群** | 10 通り | $59.9\%$ | **$40.1\%$** |
| **6群** | **15 通り** | $46.3\%$ | **$53.7\%$（半分以上が誤報！）** |
| **10群** | 45 通り | $9.9\%$ | **$90.1\%$（ほぼ確実に誤報！）** |
:::
:::

# 【理論】多群比較の2大アプローチ：分散分析（ANOVA）と多重比較

### 目的と統計学的コンセプトの違いを整理しよう

::: columns
::: {.column width="50%"}
### 1. 一元配置分散分析（One-way ANOVA）
- **問い**：「$a$ 個のグループ全体のどこかに、平均値の差（要因の効果）があるか？」
- **帰無仮説 $H_0$**：すべての群の母平均が等しい（$\mu_1 = \mu_2 = \dots = \mu_a$）
- **対立仮説 $H_1$**：少なくとも1つの群の母平均が異なる
- **特徴**：全体の変動を「群間」と「群内」に分割して1回の $F$検定で全体を判定する（**どのペアに差があるかは特定できない**）。
:::
::: {.column width="50%"}
### 2. 多重比較（Multiple Comparison）
- **問い**：「具体的に**どのグループとどのグループの間**に有意な差があるのか？」
- **方法**：検定を繰り返すことで膨らむ危険率（FWER）を**あらかじめ厳しい側に補正**した上で、ペアごとの比較を行う（Tukey-Kramer法、Bonferroni法、Holm法、Dunnett法など）。
- **現代の立ち位置**：どの群間に差があるかを知りたい場合はANOVAの結果にかかわらず多重比較を行ってよいが、**「変動の分割」という統計学の最重要概念**を理解するために本授業ではANOVAと多重比較の両方を実践する！
:::
:::

# 【理論】なぜ「平均」の比較なのに「分散」分析（ANOVA）と呼ぶのか？

### データのばらつきを「群間のばらつき（シグナル）」と「群内のばらつき（ノイズ）」に分割する！

::: columns
::: {.column width="50%"}
### 群間変動（Between-group variation）
- 各グループの平均値 $\bar{X}_1, \bar{X}_2, \dots, \bar{X}_a$ が、全体平均 $\bar{X}$ の周りでどれくらい離れているか。
- これを自由度で割ったものが **「平均の分散（群間平均平方 $V_A$）」**。
- **意味**：**要因（肥料や飼料の違い）によって生じたばらつき（＋誤差）＝ シグナル！**
:::
::: {.column width="50%"}
### 群内変動（Within-group / Residual variation）
- 各グループの中での個体ごとのばらつき（平均からのズレ）。
- これを自由度で割ったものが **「分散の平均（群内平均平方・誤差分散 $V_R$）」**。
- **意味**：同じ処理を受けた個体同士でも生じる**純粋な実験誤差・個体差 ＝ ノイズ！**
:::
:::

> **💡 分散分析（Analysis of Variance: ANOVA）の閃き**
> もしグループ間で本当に平均値に差があるなら、**「群間のばらつき（平均の分散 $V_A$）」が「群内のばらつき（誤差分散 $V_R$）」よりもずっと大きくなるはずだ！**

# 【理論】変動（平方和）の分割と自由度の分割

### 総平方和 $S_T$ は「群間平方和 $S_A$」と「群内（残差）平方和 $S_R$」にピタリと分解される！

$$\sum_{i=1}^{a}\sum_{j=1}^{n_i} (X_{ij} - \bar{X})^2 = \sum_{i=1}^{a} n_i (\bar{X}_i - \bar{X})^2 + \sum_{i=1}^{a}\sum_{j=1}^{n_i} (X_{ij} - \bar{X}_i)^2$$

::: columns
::: {.column width="50%"}
### 平方和（Sum of Squares: `Sum Sq`）の分割
- **$S_T$（総平方和）**：全データ $N$ 個の全体平均 $\bar{X}$ からのズレの2乗和
- **$S_A$（群間平方和）**：各群の平均 $\bar{X}_i$ と全体平均 $\bar{X}$ のズレの2乗和
- **$S_R$（群内・残差平方和）**：各データ $X_{ij}$ とその群の平均 $\bar{X}_i$ のズレの2乗和
- **恒等式**：**$S_T = S_A + S_R$**
:::
::: {.column width="50%"}
### 自由度（Degrees of Freedom: `Df`）の分割
- 全データ数を $N$、グループ数（群数）を $a$ とすると：
  - **総自由度**：$df_T = N - 1$
  - **群間自由度（要因A）**：**$df_A = a - 1$**（群数 $- 1$）
  - **群内自由度（残差 `Residuals`）**：**$df_R = N - a$**（全個体数 $-$ 群数）
- **恒等式**：**$(N - 1) = (a - 1) + (N - a)$**
:::
:::

# 【理論】分散分析表（ANOVA Table）と $F$検定の仕組み

### Rの `summary(aov(Y ~ X))` が出力する表の読み方を完全マスターしよう！

| 要因 (Source) | 自由度 (`Df`) | 平方和 (`Sum Sq`) | 平均平方 / 不偏分散 (`Mean Sq`) | $F$値 (`F value`) | $p$値 (`Pr(>F)`) |
|:---|:---:|:---:|:---:|:---:|:---:|
| **要因 $A$（群間）** | $df_A = a - 1$ | $S_A$ | $V_A = \dfrac{S_A}{a - 1}$ | **$F = \dfrac{V_A}{V_R}$** | $F(a-1, N-a)$ の上側確率 |
| **残差 `Residuals`（群内）** | $df_R = N - a$ | $S_R$ | $V_R = \dfrac{S_R}{N - a}$ | — | — |
| **全体（Total）** | $N - 1$ | $S_T = S_A + S_R$ | — | — | — |

- **なぜ ANOVA の $F$検定は「片側検定（上側のみ）」なのか？**
  - 帰無仮説 $H_0$（全群の母平均が等しい）が正しいとき、群間分散 $V_A$ も群内分散 $V_R$ も同じ誤差分散 $\sigma^2$ の推定値となるため、**$F = V_A / V_R \approx 1$** になる。
  - 群間に本物の差があるときだけ分子 $V_A$ が膨らんで **$F \gg 1$（右側）** になるため、**$F$分布の右裾（$F$が大きい側）の面積だけ**を $p$値として判定する！

# 【理論】第8回の $F$検定（等分散検定）と 第9回の $F$検定（ANOVA）の違い

### 同じ「R.A. Fisher の $F$分布」を使うが、比較しているものが違う！

::: columns
::: {.column width="50%"}
### 第8回：2群の等分散性の検定（`var.test`）
- **目的**：2つのグループの**「母分散（ばらつき）が等しいか」**を調べる。
- **計算式**：$F = \dfrac{s_1^2}{s_2^2}$（群1の不偏分散 $\div$ 群2の不偏分散）
- **検定の向き**：$s_1^2 > s_2^2$ でも $s_1^2 < s_2^2$ でも不等分散なので**両側検定**。
- **$p > 0.05$ のとき**：「等分散とみなせる」
:::
::: {.column width="50%"}
### 第9回：1元配置分散分析（`aov` / `oneway.test`）
- **目的**：3群以上の**「母平均に差があるか」**を分散の比を使って調べる。
- **計算式**：$F = \dfrac{V_A\text{（群間分散：平均の分散）}}{V_R\text{（群内分散：誤差分散）}}$
- **検定の向き**：群間分散 $V_A$ が誤差分散 $V_R$ より大きいかだけを調べる**片側（上側）検定**。
- **$p < 0.05$ のとき**：「群間の平均値に有意な差がある！」
:::
:::

# 【理論】多群比較の前提条件と検定選びのフローチャート

### パラメトリック検定（ANOVA）に進む前の2つのチェックポイント

::: columns
::: {.column width="50%"}
### 前提条件①：各群の正規性（Normality）
- **Shapiro-Wilk 検定（`shapiro.test`）** または **Kolmogorov-Smirnov (Lilliefors) 検定（`lillie.test`）**
- **帰無仮説 $H_0$**：母集団は**正規分布に従っている**
- **判定**：**$p > 0.05$ なら正規分布とみなせる**（棄却されない）。
- Rでは `tapply(数値列, 因子列, shapiro.test)` で全群を一括チェックできる！
:::
::: {.column width="50%"}
### 前提条件②：3群以上の等分散性（Homoscedasticity）
- 2群のときは `var.test()` だったが、**3群以上の等分散検定は Bartlett（バートレット）検定（`bartlett.test`）**を使う！
- **帰無仮説 $H_0$**：すべての群の**母分散は等しい（$\sigma_1^2 = \dots = \sigma_a^2$）**
- **判定**：
  - **$p > 0.05$**：等分散とみなせる $\rightarrow$ 通常のANOVA（`aov`）へ！
  - **$p < 0.05$**：不等分散 $\rightarrow$ **WelchのANOVA（`oneway.test`）** または第11回のノンパラメトリック検定（Kruskal-Wallis検定）へ！
:::
:::

# 【理論】多重比較（Multiple Comparisons）の4大手法

### 「どのペアに差があるか」を、全体の誤判定率（5%）を守りながら特定する！

| 手法名 | 比較のタイプ | 数理的特徴・メリット・注意点 | Rでの実行関数 |
|:---|:---:|:---|:---|
| **① Tukey-Kramer法**<br>(Tukey's HSD) | **総当たり**<br>(全ペア比較) | スチューデント化された範囲分布を用いる**総当たり比較の王道**。5群以上でも高い検出力を維持するため**最も推奨される**。 | `TukeyHSD(aov_obj)`<br>または `glht(..., mcp(X="Tukey"))` |
| **② Bonferroni法** | **総当たり**<br>(任意ペア可) | 有意水準 $\alpha$ を比較総数 $m$ で割る（または $p$値を $m$ 倍する）超シンプルな方法。**群数が増えると厳しすぎて検出力が激減する（保守的）**。 | `pairwise.t.test(..., p.adjust.method="bonferroni")` |
| **③ Holm法** | **総当たり**<br>(段階的補正) | $p$値が小さい順に「$\times m, \times (m-1), \times (m-2)\dots$」と段階的に補正する方法。**Bonferroni法より常に検出力が高い（$p$値が小さい）上位互換！** | `pairwise.t.test(..., p.adjust.method="holm")` |
| **④ Dunnett法** | **対照群との比較**<br>(1 対 多) | **1つの対照区（Control / 無処理区）と他の処理区だけ**を比較（$a-1$ 通り）。比較回数が少ないため、対照区との差を最も鋭敏に検出できる！ | `glht(..., mcp(X="Dunnett"))` |

# 【理論】Bonferroni法 vs Holm法：なぜHolm法の方が検出力が高いのか？

### 比較ペア数 $m$ で一律に割る Bonferroni と、段階的にハードルを緩める Holm

::: columns
::: {.column width="50%"}
### Bonferroni法（一律補正）
- $a$ 群の総当たりペア数 $m = \binom{a}{2}$ に対し、すべてのペアの有意水準を一律に $\alpha / m$ に厳しくする（Rの出力では各ペアの $p$値を一律に **$m$ 倍**した調整済み $p$値 `p adj` を表示、上限 $1.0$）。
  - 3群（$m=3$）：$5\% \div 3 \approx 1.67\%$（$p$値を3倍）
  - 4群（$m=6$）：$5\% \div 6 \approx 0.83\%$（$p$値を6倍）
  - **6群（$m=15$）：$5\% \div 15 \approx 0.33\%$（$p$値を15倍！）**
- ペア数が増えるほどハードルが極端に高くなり、本当は差があるペアまで見逃しやすくなる（第2種の過誤 $\beta$ の増大）。
:::
::: {.column width="50%"}
### Holm法（ステップダウン法）の賢い仕組み
1. 全 $m$ ペアの補正前 $p$値を**小さい順（$p_{(1)} \le p_{(2)} \le \dots \le p_{(m)}$）**に並べる。
2. 一番小さい $p_{(1)}$ は **$m$ 倍**（Bonferroniと同じ）で判定する。
3. そこで帰無仮説が棄却されたら、残りの仮説は最大でも $m-1$ 個しかないので、2番目に小さい $p_{(2)}$ は **$(m-1)$ 倍**、3番目は **$(m-2)$ 倍**…、最大の $p_{(m)}$ は **1倍**で補正する！
- $\rightarrow$ **全体の危険率5%を厳密に守ったまま、2番目以降のペアの $p$値が Bonferroni より必ず小さくなり、検出力がアップする！**
:::
:::

# 【理論】論文グラフの標準語：Compact Letter Display（CLD: `a, b, c`）

### 6群・15ペアの結果を一目で伝える「アルファベット文字表記」のルール

::: columns
::: {.column width="50%"}
### CLD（アルファベット表記）の鉄則
- 各グループの上に `a`, `b`, `c`, `ab`, `bc` などの文字を振る。
- **ルール①：異なる文字だけを持つグループ間には「有意差あり（$p < 0.05$）」！**
  - 例：`a` と `b`、`a` と `bc`、`b` と `c` はいずれも共通の文字を持たないので**有意差あり**！
- **ルール②：同じ文字を1つでも共有しているグループ間には「有意差なし」！**
  - 例：`a` と `a` はもちろん、**`a` と `ab`（`a`を共有）**や、**`ab` と `b`（`b`を共有）**の間には**有意差はない**！
:::
::: {.column width="50%"}
### Rで CLD を自動付与する黄金コード（`multcomp`）
```r
library(multcomp)
# 1. 分散分析モデルを作成
anova_result <- aov(Y ~ X, data = df)

# 2. Tukey-Kramer多重比較を実行
tukey_result <- glht(anova_result,
                     linfct = mcp(X = "Tukey"))

# 3. CLD文字を抽出して箱ひげ図に描画！
cld(tukey_result)
par(mar = c(5.1, 4.1, 6, 2.1)) # 上余白を広げる
plot(cld(tukey_result))
```
:::
:::

# 【実践 Step 0】RStudioの準備（ファイルDL・作業ディレクトリ・パッケージ）

### スライド単体で見返しても迷わない！ ハンズオンを始める前の3ステップ

::: columns
::: {.column width="50%"}
### Step 0-1：データの保存と作業ディレクトリ設定
1. 第9回Webページのダウンロード欄から以下のファイルを同じフォルダ（例：`lecture9` フォルダ）に保存する：
   - 練習用：`トマト糖度スタック形式.xlsx`
   - 課題用：**`niwatori.csv`**、**`kadai2_t_vs_ANOVA.csv`**
2. RStudio上部メニューの **`Session` $\rightarrow$ `Set Working Directory` $\rightarrow$ `Choose Directory...`** をクリックし、ファイルを保存したフォルダを選択する。
:::
::: {.column width="50%"}
### Step 0-2：必須パッケージのインストール（初回のみ）
- RStudioの **Console（左下画面）** に以下の1行を貼り付けて Enter を押す：
```r
install.packages(c("multcomp", "nortest", "readxl"))
```
- ※ 一度インストールすれば、次回からは `library(multcomp)` だけで呼び出せます！
:::
:::

# 【授業内練習 1】トマト4種肥料と糖度データの読み込み（提出不要）

### ワイド形式ではなく「スタック形式」で読み込み、グループ列を因子（Factor）にする

::: columns
::: {.column width="50%"}
### データ読み込みと因子化＋可視化コード
```r
library(readxl)
renshu <- read_xlsx("トマト糖度スタック形式.xlsx")
# Fertilizer列をcharacterからfactor（因子）に変換
renshu$Fertilizer <- as.factor(renshu$Fertilizer)
summary(renshu)

# 箱ひげ図＋ドットプロット
boxplot(renshu$BRIX ~ renshu$Fertilizer, ylab="BRIX")
stripchart(renshu$BRIX ~ renshu$Fertilizer,
           vertical=TRUE, method="jitter", add=TRUE)
```
:::
::: {.column width="50%"}
### 各試験区のサンプル数と平均糖度（BRIX）
- **`BonePowder`（骨粉）**：$n = 16$, 平均 $6.900$（分散 $1.885$）
- **`Chemical`（化学肥料）**：$n = 14$, 平均 $7.329$（分散 $0.716$）
- **`NoFertilizer`（無肥料）**：$n = 16$, 平均 $5.888$（分散 $0.897$）
- **`OilCake`（油粕）**：$n = 16$, 平均 $6.319$（分散 $1.688$）
- 全データ数 $N = 62$、グループ数 $a = 4$。
- 箱ひげ図を見ると `Chemical` が高く `NoFertilizer` が低そうだが、ばらつきも重なっている。検定で確かめよう！
:::
:::

# 【授業内練習 2】トマト糖度の前提条件チェックと1元配置分散分析

### 正規性（Shapiro-Wilk）$\rightarrow$ 等分散性（Bartlett）$\rightarrow$ ANOVA（`aov` / `oneway.test`）

```r
# ① 各群の正規性の検定（Shapiro-Wilk検定）：すべて p > 0.05 ならOK
tapply(renshu$BRIX, renshu$Fertilizer, shapiro.test)

# ② 4群の等分散性の検定（Bartlett検定）：p > 0.05 なら等分散
bartlett.test(BRIX ~ Fertilizer, data = renshu)

# ③ 等分散を仮定した1元配置分散分析（aov）と WelchのANOVA（oneway.test）
anova_result <- aov(BRIX ~ Fertilizer, data = renshu)
summary(anova_result)
oneway.test(BRIX ~ Fertilizer, data = renshu, var.equal = FALSE)
```

- **実行結果の確認**：
  - **Shapiro-Wilk検定**：`BonePowder` $p=0.623$, `Chemical` $p=0.185$, `NoFertilizer` $p=0.975$, `OilCake` $p=0.752$（全群 $p > 0.05$ で正規分布とみなせる）
  - **Bartlett検定**：$K^2 = 4.4335, df = 3, \mathbf{p = 0.2183 (> 0.05)}$ $\rightarrow$ 4群は等分散とみなせる！
  - **1元配置分散分析 (`aov`)**：群間 $df = 3, S_A = 18.25, V_A = 6.082$ ／ 残差 $df = 58, S_R = 76.37, V_R = 1.317$ $\rightarrow$ **$F = 4.619, p = 0.00577 (< 0.01)$**（1%水準で有意！肥料によって糖度に差がある！）

# 【授業内練習 3】トマト糖度の多重比較：総当たり（Tukey）vs 対照比較（Dunnett）

### 比較の目的に応じて Tukey-Kramer法 と Dunnett法 で結果がどう変わるか注目！

::: columns
::: {.column width="50%"}
### ① Tukey-Kramer法（全6ペア総当たり）
```r
library(multcomp)
TukeyHSD(anova_result, "Fertilizer")
tukey_result <- glht(anova_result,
                linfct = mcp(Fertilizer = "Tukey"))
cld(tukey_result)
```
- **結果**：6ペアのうち **`Chemical - NoFertilizer`（差 $+1.441$, $p = 0.00596$）の1ペアのみが有意**！
- `BonePowder - NoFertilizer`（差 $+1.013$）は **$p = 0.0712 (> 0.05)$** で惜しくも有意にならず。
- **CLD**：`Chemical = "a"`, `NoFertilizer = "b"`, `BonePowder = "ab"`, `OilCake = "ab"`。
:::
::: {.column width="50%"}
### ② Dunnett法（`NoFertilizer` を対照区に指定）
```r
# NoFertilizer を基準（対照群 ref）に設定
renshu$Fertilizer <- relevel(renshu$Fertilizer,
                             ref = "NoFertilizer")
anova_ref <- aov(BRIX ~ Fertilizer, data = renshu)
dunnett_res <- glht(anova_ref,
               linfct = mcp(Fertilizer = "Dunnett"))
summary(dunnett_res)
```
- **結果（3ペアのみ比較）**：
  - `Chemical vs NoFertilizer`：**$p = 0.0031$ (\*\*)**
  - `BonePowder vs NoFertilizer`：**$p = 0.0410$ (\*) $\leftarrow$ 有意になった！**
  - `OilCake vs NoFertilizer`：$p = 0.5864$ (ns)
- **💡 教訓**：対照区との比較に絞ると多重性のペナルティが減り（6ペア $\to$ 3ペア）、骨粉の効果も検出できる！
:::
:::

# 【実践】本日の提出課題の全体像（全5問・Web課題と完全連動）

### ここからは提出課題！ `niwatori.csv` と `kadai2_t_vs_ANOVA.csv` を解析しよう

- **実験背景（課題1〜3・発展課題4：`niwatori.csv`）**：
  - 孵化したばかりのニワトリ（全71羽）に**6種類のタンパク源飼料（`Esa`）**を6週間与え続け、体重（`Taiju`, 単位: g）を測定した著名な生物統計データセット（`chickwts` 由来）。
  - 6種類の飼料：`casein`（カゼイン, 12羽）、`horsebean`（ソラマメ, 10羽）、`linseed`（アマニ, 12羽）、`meatmeal`（肉骨粉, 11羽）、`soybean`（大豆, 14羽）、`sun_ower`（ヒマワリ, 12羽）。
- **本日の提出課題リスト（`kadai9_interactive.html` に入力してHTMLを提出）**：
  - **課題1（20点）**：`niwatori.csv` の箱ひげ図＋ドットプロット、Shapiro-Wilk正規性検定、Bartlett等分散性検定
  - **課題2（20点）**：1元配置分散分析（`aov` と `oneway.test`）による分散分析表（$df, F, p$）の算出
  - **課題3（20点）**：Tukey-Kramer法（`TukeyHSD` & `multcomp::cld`）による全15ペア比較とCLD文字の特定
  - **発展課題4（20点）**：Bonferroni法とHolm法の比較（調整済み $p$値 と CLD の比較考察）
  - **発展課題5（20点）**：`kadai2_t_vs_ANOVA.csv`（イネ2群データ）を用いた **t検定と1-way ANOVAの同値性（$t^2 = F$）** の証明

# 【提出課題 1】ニワトリ6種飼料の可視化・正規性・等分散性の検定

### 分散分析の前提条件（各群の正規性と6群の等分散性）が満たされているか確認せよ

```r
niwatori <- read.csv("niwatori.csv", stringsAsFactors = TRUE)
summary(niwatori)

# (1)(2) 箱ひげ図とドットプロットを重ねて描く
boxplot(niwatori$Taiju ~ niwatori$Esa, ylab = "Weight (g)", xlab = "Feed (Esa)")
stripchart(niwatori$Taiju ~ niwatori$Esa, vertical = TRUE, method = "jitter", add = TRUE)

# (3) 各群の正規性の検定（Shapiro-Wilk検定）
tapply(niwatori$Taiju, niwatori$Esa, shapiro.test)

# (4) 6群の等分散性の検定（Bartlett検定）
tapply(niwatori$Taiju, niwatori$Esa, var)
bartlett.test(Taiju ~ Esa, data = niwatori)
```

::: columns
::: {.column width="50%"}
### 課題1のR実行結果
- **Shapiro-Wilk正規性検定の $p$値**：
  - `casein`: $0.259$, `horsebean`: $0.526$, `linseed`: $0.903$, `meatmeal`: $0.961$, `soybean`: $0.506$, `sun_ower`: $0.360$
  - $\rightarrow$ **全6群すべてで $p > 0.05$（正規分布とみなせる）**
:::
::: {.column width="50%"}
### Bartlett等分散性検定の結果
- `Bartlett's K-squared = 3.2597, df = 5, p-value = 0.66`
- **$p = 0.660 (> 0.05)$** のため帰無仮説は棄却されず、**6群の等分散性は否定されない（等分散とみなせる）**！
- $\rightarrow$ これで堂々と1元配置分散分析に進める！
:::
:::

# 【提出課題 2】ニワトリ体重の1元配置分散分析（ANOVA）

### 飼料（`Esa`）によってニワトリの体重（`Taiju`）に差があるといえるか？

```r
# 各飼料グループの平均体重を表示
tapply(niwatori$Taiju, niwatori$Esa, mean)

# 等分散を仮定した1元配置分散分析（aov）
anova_result <- aov(Taiju ~ Esa, data = niwatori)
summary(anova_result)

# （参考）等分散を仮定しないWelchのANOVA
oneway.test(Taiju ~ Esa, data = niwatori, var.equal = FALSE)
```

::: columns
::: {.column width="50%"}
### 分散分析表（`summary(anova_result)`）の数値
- **群別平均**：`horsebean` $160.2\text{ g}$ 〜 `sun_ower` $328.9\text{ g}$（2倍以上の差！）
- **群間（`Esa`）**：
  - 自由度 **`Df = 5`**（$= 6 - 1$）
  - 平方和 `Sum Sq = 231129`、平均平方 `Mean Sq = 46226`
- **群内・残差（`Residuals`）**：
  - 自由度 **`Df = 65`**（$= 71 - 6$）
  - 平方和 `Sum Sq = 195556`、平均平方 `Mean Sq = 3009`
:::
::: {.column width="50%"}
### $F$値・$p$値と統計的判定
- **$F$値（`F value`）**：$46226 \div 3009 = \mathbf{15.365}$（表示は **`15.37`**）
- **$p$値（`Pr(>F)`）**：**`5.94e-10`**（$= 5.94 \times 10^{-10} < 0.001$）
- （WelchのANOVAでも $F = 20.021, df = (5, 29.99), p = 9.13 \times 10^{-9}$）
- **結論**：帰無仮説は0.1%水準で高度に棄却され、**飼料の種類によってニワトリの体重には極めて有意な差がある！**
:::
:::

# 【提出課題 3】Tukey-Kramer法による多重比較とCLD（アルファベット表記）

### 6種類の飼料（全15ペア）のうち、どの飼料とどの飼料の間に有意差があるのか？

```r
# ① R標準の TukeyHSD で全15ペアの調整済みp値を確認
TukeyHSD(anova_result, "Esa", ordered = TRUE)

# ② multcomp パッケージで CLD (a, b, c) を付与して箱ひげ図を描画
library(multcomp)
tukey_result <- glht(anova_result, linfct = mcp(Esa = "Tukey"))
summary(tukey_result)
cld(tukey_result)
par(mar = c(5.1, 4.1, 6, 2.1))
plot(cld(tukey_result))
```

::: columns
::: {.column width="50%"}
### 総当たり比較の数と有意ペア数
- 飼料は **$6$ 種類**あるので、総当たり比較ペア数は：
  $$\binom{6}{2} = \frac{6 \times 5}{2} = \mathbf{15\text{ 通り}}$$
- `TukeyHSD` の出力で `p adj < 0.05` となる**有意な組み合わせは 15通り中 `8通り`**！
:::
::: {.column width="50%"}
### `cld(tukey_result)` のアルファベット出力
| 飼料 (`Esa`) | 平均体重 (g) | CLD文字 | グループ解釈 |
|:---|:---:|:---:|:---|
| **`sun_ower`** | $328.9$ | **`"a"`** | トップ集団（高体重） |
| **`casein`** | $323.6$ | **`"a"`** | トップ集団（高体重） |
| **`meatmeal`** | $276.9$ | **`"ac"`** | `a`と`c`の中間（両方と差なし） |
| **`soybean`** | $246.4$ | **`"c"`** | 中位集団（`a`や`b`と有意差あり） |
| **`linseed`** | $218.8$ | **`"bc"`** | `b`と`c`の中間 |
| **`horsebean`** | $160.2$ | **`"b"`** | 低体重集団 |
:::
:::

# 【発展課題 4・Wow①】Bonferroni法 vs Holm法の多重比較と検出力の比較

### 同じ15ペア総当たりでも、補正アルゴリズムによって調整済み $p$値 はどう変わるか？

```r
# ① Bonferroni法による多重比較とCLD
pairwise.t.test(niwatori$Taiju, niwatori$Esa, p.adjust.method = "bonferroni")
bonf_summary <- summary(glht(anova_result, linfct = mcp(Esa = "Tukey")), test = adjusted("bonferroni"))
bonf_summary
cld(bonf_summary)

# ② Holm法による多重比較とCLD
pairwise.t.test(niwatori$Taiju, niwatori$Esa, p.adjust.method = "holm")
holm_summary <- summary(glht(anova_result, linfct = mcp(Esa = "Tukey")), test = adjusted("holm"))
holm_summary
cld(holm_summary)
```

::: columns
::: {.column width="50%"}
### 3手法の調整済み $p$値 徹底比較（主要ペア）
| 比較ペア | Tukey-Kramer | Bonferroni | Holm法 |
|:---|:---:|:---:|:---:|
| `sun_ower - horsebean` | $< 10^{-7}$ | $1.23 \times 10^{-8}$ | $1.23 \times 10^{-8}$ |
| `meatmeal - horsebean` | $0.000106$ | $0.000112$ | **$0.0000897$** |
| `linseed - casein` | $0.000210$ | $0.000224$ | **$0.000164$** |
| **`soybean - casein`** | **$0.00837$** | **$0.00998$** | **$0.00532$** |
| `meatmeal - linseed` | $0.1277$ | $0.2022$ | **$0.0944$** |
| `linseed - horsebean` | $0.1413$ | $0.2283$ | **$0.0944$** |
:::
::: {.column width="50%"}
### 発展課題4の考察ポイント
1. **有意ペア数とCLDの一致**：今回のデータでは群間差が非常に明確なため、Tukey・Bonferroni・Holm のいずれも有意ペアは**8通り**、CLDも `a, b, bc, ac, c, a` で一致した。
2. **$p$値の大小関係（重要！）**：個別ペアの調整済み $p$値を見ると、**Holm法は Bonferroni法よりも常に小さい（または等しい）$p$値**を与えており、段階的補正によって検出力の低下を防いでいることが確認できる！
:::
:::

# 【発展課題 5・Wow②】t検定と1-way ANOVAの驚くべき関係（$t^2 = F$）

### 2群データ（`kadai2_t_vs_ANOVA.csv`）に t検定 と ANOVA の両方をかけると何が起きるか？

```r
dataset <- read.csv("kadai2_t_vs_ANOVA.csv", stringsAsFactors = TRUE)

# (1) 等分散仮定のStudentのt検定 と t^2
x_eq <- t.test(SW5_35 ~ Genotype, data = dataset, alternative = "two.sided", var.equal = TRUE)
x_eq; as.numeric(x_eq$statistic^2)

# (2) 等分散仮定の1元配置分散分析 (aov)
summary(aov(SW5_35 ~ Genotype, data = dataset))

# (3) 等分散を仮定しないWelchのt検定 と t^2
x_welch <- t.test(SW5_35 ~ Genotype, data = dataset, alternative = "two.sided", var.equal = FALSE)
x_welch; as.numeric(x_welch$statistic^2)

# (4) 等分散を仮定しないWelchのANOVA (oneway.test)
oneway.test(SW5_35 ~ Genotype, data = dataset, var.equal = FALSE)
```

| 比較条件 | 独立2群の t検定 (`t.test`) | $t$値の2乗 ($t^2$) | 1元配置分散分析 (`aov` / `oneway.test`) | 結論 |
|:---|:---:|:---:|:---:|:---|
| **等分散を仮定**<br>(Student vs `aov`) | $t = -4.7593, df = 74$<br>**$p = 9.394 \times 10^{-6}$** | **$(-4.7593)^2 = \mathbf{22.651}$** | **$F = \mathbf{22.651}$**, $df = (1, 74)$<br>**$p = 9.394 \times 10^{-6}$** | **$t^2 = F$ かつ $p$値が完全一致！** |
| **等分散を仮定しない**<br>(Welch t vs Welch ANOVA) | $t = -4.9457, df = 49.342$<br>**$p = 9.193 \times 10^{-6}$** | **$(-4.9457)^2 = \mathbf{24.460}$** | **$F = \mathbf{24.460}$**, $df = (1, 49.342)$<br>**$p = 9.193 \times 10^{-6}$** | **Welchでも $t^2 = F$・$p$値が完全一致！** |

# 【Wow②の数理】なぜ2群のとき「$t^2 = F$」が厳密に成り立つのか？

### この一致は偶然ではない！ 分子も分母もまったく同じ量を2乗しているから！

::: columns
::: {.column width="50%"}
### 2群（$a = 2$）での Student の $t$統計量の2乗
$$t = \frac{\bar{X}_1 - \bar{X}_2}{\sqrt{s_p^2 \left(\frac{1}{n_1} + \frac{1}{n_2}\right)}}$$
- 両辺を2乗すると：
$$t^2 = \frac{(\bar{X}_1 - \bar{X}_2)^2}{s_p^2 \left(\frac{n_1 + n_2}{n_1 n_2}\right)} = \frac{\dfrac{n_1 n_2}{n_1 + n_2}(\bar{X}_1 - \bar{X}_2)^2}{s_p^2}$$
:::
::: {.column width="50%"}
### 2群（$a = 2, df_A = 1$）での ANOVA の $F$統計量
- 2群の群間平方和 $S_A$ を展開すると：
$$S_A = n_1(\bar{X}_1 - \bar{X})^2 + n_2(\bar{X}_2 - \bar{X})^2 = \frac{n_1 n_2}{n_1 + n_2}(\bar{X}_1 - \bar{X}_2)^2$$
- 自由度 $df_A = 2 - 1 = 1$ なので $V_A = S_A / 1 = S_A$。
- 一方、群内誤差分散 $V_R = S_R / (n_1 + n_2 - 2)$ はプールされた分散 $s_p^2$ そのもの！
$$\therefore F = \frac{V_A}{V_R} = \frac{\dfrac{n_1 n_2}{n_1 + n_2}(\bar{X}_1 - \bar{X}_2)^2}{s_p^2} = \mathbf{t^2}$$
:::
:::

> **💡 統計学の美しい統一理解**
> 自由度 $df$ の $t$分布に従う確率変数を2乗すると、必ず第1自由度 $1$、第2自由度 $df$ の **$F(1, df)$ 分布**に従う。つまり**「1元配置分散分析は、独立2群のt検定を3群以上へとそのまま拡張した一般化手法である」**！

# 【実践】本日の課題1〜3・発展4〜5の正解リファレンス一覧

### 自分でRStudioを実行したあと、以下の数値と一致しているか答え合わせしよう！

| 課題 | 解析対象・手法 | 主要な出力統計量 | $p$値 | 統計的判定・結論 |
|:---:|:---|:---|:---:|:---|
| **課題1** | `niwatori.csv` (6群, $N=71$)<br>Shapiro-Wilk & Bartlett検定 | 全6群 Shapiro $p \ge 0.259$<br>Bartlett $K^2 = 3.2597, df = 5$ | Bartlett<br>**$p = 0.6600$** | **正規性・等分散性ともに満たす**<br>($p > 0.05$ のため等分散) |
| **課題2** | 1元配置分散分析 (`aov`)<br>Welch ANOVA (`oneway.test`) | `aov`: $df=(5, 65)$, **$F = 15.37$**<br>Welch: $df=(5, 29.99)$, **$F = 20.02$** | **`5.94e-10`**<br>(`9.13e-09`) | **極めて有意 ($p < 0.001$)**<br>飼料間で体重に明確な差あり |
| **課題3** | Tukey-Kramer多重比較<br>(`TukeyHSD` & `cld`) | 総当たり **$15$ 通り**中 **`8` 通り**が有意<br>CLD: `casein="a", horsebean="b", linseed="bc", meatmeal="ac", soybean="c", sun_ower="a"` | 最小ペア<br>$< 10^{-7}$ | `sun_ower`・`casein` が最高体重、<br>`horsebean` が最低体重 |
| **発展4** | Bonferroni法 vs Holm法<br>(`pairwise.t.test` & `glht`) | 有意ペア数はどちらも **`8` 通り**<br>`soybean-casein`: Bonf $0.00998$ vs Holm **$0.00532$** | Holm $\le$ Bonf<br>(常にHolmが小) | **Holm法は段階的補正により**<br>**Bonferroni法より検出力が高い** |
| **発展5** | `kadai2_t_vs_ANOVA.csv`<br>t検定 vs ANOVA ($t^2 = F$) | 等分散: $t = -4.7593 \implies \mathbf{t^2 = F = 22.651}$<br>Welch: $t = -4.9457 \implies \mathbf{t^2 = F = 24.460}$ | 等分散: `9.394e-06`<br>Welch: `9.193e-06` | **2群では独立t検定(両側)と**<br>**1-way ANOVAは数学的に完全同値** |

# 【実践】提出課題ワークブック（`kadai9_interactive.html`）の提出手順

### スライドとWebで完全統一！ 以下の手順でHTMLレポートを書き出して提出しよう

- **Step 1：Web課題ワークブック（`kadai9_interactive.html`）を開く**
  - 第9回ポータルページ（`one_way_anova/index.html`）の「📝 インタラクティブWeb課題を開く」をクリック。
- **Step 2：学籍番号・氏名と課題1〜3・発展課題4＆5を入力して検証**
  - 各カードの「🔍 検証する」ボタンを押すと、その場で自動採点（各20点×5問＝100点満点）されます。
  - 各課題の「グラフの印象・生物学的／統計学的考察」および最後の「総合考察」を自分の言葉で記入します。
- **Step 3：「📥 提出用レポートHTMLを書き出す」をクリックして提出！**
  - 画面下部の青いボタンを押すと、`学籍番号_氏名_第9回課題レポート.html` がダウンロードされます。**このHTMLファイルを提出してください。**
  - ※ `ひな型.Rmd` は手元のRStudioで全コードを一括実行したり、グラフ付きHTML（Knit）を手元で確認するための補助教材として活用してください。

# トラブルシューティング（第9回でよくあるエラーと解決策）

### エラーが出ても慌てずここをチェック！

::: columns
::: {.column width="50%"}
### ⚠️ `there is no package called 'multcomp'`
- **原因**: `multcomp`（または `nortest`）が未インストール。
- **対策**: RStudioのConsoleで `install.packages("multcomp")` を実行する。

### ⚠️ `glht()` で `not a factor` エラーが出る
- **原因**: `Esa` 列が文字列（`character`）のままになっている。
- **対策**: `niwatori <- read.csv("niwatori.csv", stringsAsFactors = TRUE)` で読み込むか、`niwatori$Esa <- as.factor(niwatori$Esa)` を実行してから `aov()` をやり直す。
:::
::: {.column width="50%"}
### ⚠️ `plot(cld(...))` で上のアルファベット文字が見切れる
- **原因**: Rの標準グラフ余白（上マージン `4.1`）が狭いため、箱ひげ図の上の `a, b, c` が枠外にはみ出る。
- **対策**: `plot()` の直前に `par(mar = c(5.1, 4.1, 6, 2.1))` を実行して上マージンを `6` に広げる。

### ⚠️ `pairwise.t.test` で `"Bonferroni"` と書いたらエラー
- **原因**: Rは引数の大文字・小文字を厳密に区別する。
- **対策**: 必ずすべて小文字で `p.adjust.method = "bonferroni"` または `"holm"` と記述する（一方で `mcp(Esa = "Tukey")` や `"Dunnett"` は先頭が大文字！）。
:::
:::

# 本日のまとめと次回（第10回）への予告

### 1. 本日マスターした3大ポイント
- **多重検定の罠と1元配置分散分析（One-way ANOVA）**: 3群以上でt検定を繰り返すと偽陽性が急増すること、そしてANOVAは全体のばらつきを「群間分散（シグナル）」と「群内誤差分散（ノイズ）」に分割して $F = V_A / V_R$ で検定し、2群のときは $t^2 = F$ でt検定と完全に一致すること。
- **多重比較の使い分け**: 総当たり比較の王道 **Tukey-Kramer法**、段階的補正でBonferroniを改良した **Holm法**、対照群との比較に特化した **Dunnett法** の特徴と検出力の違い。
- **Compact Letter Display (CLD)**: 異なるアルファベット間（例: `a` と `b`、`a` と `bc`）は有意差あり、同じ文字を共有する群間（例: `a` と `ac`）は有意差なしと読み解く論文標準の表現法。

### 2. 次回（第10回）への予告：もし要因が「2つ（品種×肥料など）」あったら？
- 今日は「飼料の種類だけ」「肥料の種類だけ」という**1つの要因（1元配置）**でした。
- 次回は**「イネの品種（要因A）× 肥料の種類（要因B）」のように2つの要因を同時に調べる「2元配置分散分析（Two-way ANOVA）」**と、片方の要因の効果がもう片方の要因によって劇的に変わる**「交互作用（Interaction）」**を学びます！
