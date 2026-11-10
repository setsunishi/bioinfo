# ==============================================================================
# 生物情報処理演習 第7回：提出課題一括自動採点スクリプト (grade_submissions.R)
# ==============================================================================
# 使い方:
# 1. 学生から提出されたHTMLファイル群を、このスクリプトと同じフォルダ（または submissions フォルダ）に置きます。
# 2. RStudio で本スクリプトを開き、実行（Source）します。
# 3. 同フォルダに「採点結果_第7回.csv」が自動出力されます！
# ==============================================================================

library(jsonlite)

# 提出ファイルの検索
submission_files <- list.files(pattern = ".*_第7回課題レポート\\.html$", full.names = TRUE)

if (length(submission_files) == 0) {
  # フォルダ配下も探す
  submission_files <- list.files(pattern = "\\.html$", recursive = TRUE, full.names = TRUE)
  submission_files <- submission_files[!grepl("kadai7_interactive|生物情報処理演習|ひな型|index|grader", submission_files)]
}

cat("====================================================\n")
cat(sprintf("🔍 見つかった提出ファイル数: %d 件\n", length(submission_files)))
cat("====================================================\n")

if (length(submission_files) == 0) {
  stop("提出HTMLファイルが見つかりませんでした。ファイルを配置して再実行してください。")
}

records <- list()

for (f in submission_files) {
  html_text <- readLines(f, warn = FALSE, encoding = "UTF-8")
  html_full <- paste(html_text, collapse = "\n")
  
  # 1. 埋め込みJSONメタデータを抽出
  json_match <- regmatches(html_full, regexec('<script id="submission-metadata" type="application/json"[^>]*>\\s*(.*?)\\s*<\\/script>', html_full))[[1]]
  
  if (length(json_match) >= 2) {
    meta_json <- json_match[2]
    data <- tryCatch({
      fromJSON(meta_json)
    }, error = function(e) NULL)
    
    if (!is.null(data)) {
      records[[length(records) + 1]] <- data.frame(
        ファイル名 = basename(f),
        学籍番号   = data$studentId,
        氏名       = data$studentName,
        提出日時   = data$submissionDate,
        客観得点合計 = data$score,
        課題1得点 = data$scoresDetail$q1,
        課題2得点 = data$scoresDetail$q2,
        課題3得点 = data$scoresDetail$q3,
        発展4得点 = data$scoresDetail$q4,
        発展5得点 = data$scoresDetail$q5,
        逆走系統回答 = data$q5$reversedIdx,
        課題1考察 = data$q1$text,
        課題2考察 = data$q2$text,
        発展4考察 = data$q4$text,
        発展5考察 = data$q5$text,
        総合考察  = data$overallText,
        stringsAsFactors = FALSE
      )
      cat(sprintf("✓ 読み込み成功: %s (%s %s) 得点: %d/100\n", basename(f), data$studentId, data$studentName, data$score))
    }
  } else {
    cat(sprintf("⚠️ メタデータが見つかりません: %s\n", basename(f)))
  }
}

if (length(records) > 0) {
  df_result <- do.call(rbind, records)
  
  # 学籍番号順にソート
  df_result <- df_result[order(df_result$学籍番号), ]
  
  output_csv <- "採点結果_第7回.csv"
  # UTF-8 with BOM で保存（Windows / Mac Excel でダブルクリックしても文字化けしない）
  con <- file(output_csv, open = "wb")
  writeBin(as.raw(c(0xEF, 0xBB, 0xBF)), con) # BOM付与
  write.table(df_result, file = con, sep = ",", row.names = FALSE, qmethod = "double", fileEncoding = "UTF-8")
  close(con)
  
  cat("\n====================================================\n")
  cat(sprintf("🎉 一括採点が完了しました！ 出力先: %s\n", output_csv))
  cat(sprintf("平均点: %.1f 点 (満点: 100点)\n", mean(df_result$客観得点合計)))
  cat("====================================================\n")
} else {
  cat("有効な提出データが抽出できませんでした。\n")
}
