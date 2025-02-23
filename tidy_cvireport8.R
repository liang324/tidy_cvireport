# 批量整理txt报告

# TODO
# data names

# ——————————————————————————————————————————————————————————————————————————————
# 加载必要的包
library(stringi)  # 用于读取文件
library(readr)  # 用于读取文件
library(openxlsx)  # 用于写入Excel文件
source("tidy_function.R")

# ——————————————————————————————————————————————————————————————————————————————
# 设置提取标志
# paste("keyword1", "keyword2", sep = ".*")  # 与，保持前后顺序
# paste("keyword1", "keyword2", sep = "|")  # 或

data_entry_lists <- list()

data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "data1",
  measure_index = "长轴 Strain",
  mode_index = "单平面 4CV",
  data_index = c("LV 长轴 Strain", "LV 长轴差异", "RA 长轴 Strain")
)))

data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "data2",
  measure_index = "长轴 Strain",
  mode_index = "单平面 4CV",
  data_index = c("LV 长轴 Strain", "LV 长轴差异", "RA 长轴 Strain"),
  data_cols = list("col A" = 1, "col B" = 2)
)))

data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "data3",
  measure_index = "长轴 Strain",
  mode_index = "单平面 4CV",
  data_index = c("长轴 Strain（相位）"),
  data_cols = list("col A" = 1, "col B" = 2, "col C" = 3, "col D" = 5),
  data_rows = list("row I" = 5, "row II" = 6, "row III" = 7)
)))

# ——————————————————————————————————————————————————————————————————————————————
# 待处理数据文件所在的文件夹
data_folder <- "my_data"

# ——————————————————————————————————————————————————————————————————————————————
# 执行提取函数，获取提取结果
extracted_data_frame <- extract_data_from_txt_files(data_entry_lists, data_folder)

# **查看结果**
# print(extracted_data_frame)

# current time stamps
current_time <- format(Sys.time(), "%Y_%m_%d_%H_%M_%S")

# **导出结果**
write.xlsx(extracted_data_frame, paste("results-", current_time, ".xlsx", sep = ''), keepNA = TRUE)

