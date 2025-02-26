# V2025-02-25
# ***本文件用于批量整理CVI导出的txt报告至excel***
# ***请将本文件，tidy_function.R,以及待处理的txt文件夹置于同一文件夹内***


# ——————————————————————————————————————————————————————————————————————————————
# 加载必要的包
library(stringi)  # 用于读取文件
library(readr)  # 用于读取文件
library(openxlsx)  # 用于写入Excel文件
source("tidy_function.R")

# ——————————————————————————————————————————————————————————————————————————————
# 待处理数据文件所在的文件夹
data_folder <- "my_data"

# ——————————————————————————————————————————————————————————————————————————————
# 设置提取标志

data_entry_lists <- list()


## 举个例子
## 1-3级关键词中如有特殊字符，需要转义，如“*”需要写成“\\*”

# data_entry_lists <- append(data_entry_lists, list(list(
#   data_name = "批量提取心功能", # 数据名称，可以根据需要随意命名
#   measure_index = "SAX 3D 功能", # 1级关键词，一般设置为模块名称
#   mode_index = "LV 临床结果", # 2级关键词，一般设置为子模块名称
#   data_index = c("EDV", "ESV", "^SV", "HR", "CO", "EF", "MyoMass_diast"), # 3级关键词，一般设置为需要提取的数据名称
#   data_cols = list("col A" = 1, "col B" = 2, "col C" = 3, "col D" = 5), 
#        # 附加功能，可删除，用于提取三级关键词后的某列数据，引号中列名可自命名
#   data_rows = list("row I" = 5, "row II" = 6, "row III" = 7)
#        # 附加功能，可删除，用于提取三级关键词后的某行数据，引号中行名可自命名
# )))


# ***左室心功能***
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "左室心功能",
  measure_index = "SAX 3D 功能",
  mode_index = "LV 临床结果",
  data_index = c("EDV", "ESV", "^SV", "HR", "CO", "EF", "MyoMass_diast")
)))

# ***右室心功能***
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "右室心功能",
  measure_index = "SAX 3D 功能",
  mode_index = "RV 临床结果",
  data_index = c("EDV", "ESV", "^SV", "HR", "CO", "EF")
)))

# ***多长轴分析***
## 2CV 心功能
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "多长轴_2CV",
  measure_index = "双平面 LV/LA/RA 功能和 Strain",
  mode_index = "单平面 2CV \\*\\*\\*",
  data_index = c("EDV", "ESV", "^SV", "HR", "CO", "EF", "心肌质量（舒张期）",
                 "LA 容积 LVED", "LA 面积 LVED", "LA 容积 LVES", "LA 面积 LVES",
                 "最小左心房容积", "最小左心房面积", "最大左心房容积", "最大左心房面积","LA EF")
)))

## 4CV 心功能
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "多长轴_4CV",
  measure_index = "双平面 LV/LA/RA 功能和 Strain",
  mode_index = "单平面 4CV \\*\\*\\*",
  data_index = c("EDV", "ESV", "^SV", "HR", "CO", "EF", "心肌质量（舒张期）",
                 "LA 容积 LVED", "LA 面积 LVED", "LA 容积 LVES", "LA 面积 LVES",
                 "RA 容积 LVED", "RA 面积 LVED", "RA 容积 LVES", "RA 面积 LVES",
                 "最小左心房容积", "最小左心房面积", "最大左心房容积", "最大左心房面积","LA EF",
                 "最小右心房容积", "最小右心房面积", "最大右心房容积", "最大右心房面积","RA EF")
)))

## 2_4CV 心功能
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "多长轴_2_4CV",
  measure_index = "双平面 LV/LA/RA 功能和 Strain",
  mode_index = "双平面 2CV / 4CV\\*\\*\\*",
  data_index = c("EDV", "ESV", "SV", "HR", "CO", "EF", "心肌质量（舒张期）",
                 "LA 容积 LVEDV", "LA 容积 LVES",
                 "最小左心房容积", "最大左心房容积", "LA EF")
)))

# 2CV strain
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "长轴Strain_2CV",
  measure_index = "长轴 Strain\\*\\*\\*",
  mode_index = "单平面 2CV",
  data_index = c("LV 长轴 Strain", "LV AV 交界 Strain", "LA 长轴 Strain", "LA AV 交界 Strain")
)))

# 4CV strain
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "长轴Strain_4CV",
  measure_index = "长轴 Strain\\*\\*\\*",
  mode_index = "单平面 4CV",
  data_index = c("LV 长轴 Strain", "LV AV 交界 Strain", "LA 长轴 Strain", "LA AV 交界 Strain",
                 "RA 长轴 Strain", "RA AV 交界 Strain")
)))

# 2_4CV strain
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "长轴Strain_2_4CV",
  measure_index = "长轴 Strain\\*\\*\\*",
  mode_index = "平均 2CV 和 4CV",
  data_index = c("平均 LV 长轴 Strain", "平均 LV AV 交界 Strain", 
                 "平均 LA 长轴 Strain", "平均 LA AV 交界 Strain")
)))

# ***整体strain***
## 左室整体strain 短轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "左室整体Strain_SAX",
  measure_index = "Global Measurements Report",
  mode_index = "Left Ventricle    ",
  data_index = regex_and("SAX", "Global"),
  data_cols = list("pGRS" = 3, "pGCS" = 4)
)))

## 左室整体strain 长轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "左室整体Strain_LAX",
  measure_index = "Global Measurements Report",
  mode_index = "Left Ventricle    ",
  data_index = regex_and("LAX", "Global"),
  data_cols = list("pGRS" = 3, "pGLS" = 5)
)))

## 右室整体strain 短轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "右室整体Strain_SAX",
  measure_index = "Global Measurements Report",
  mode_index = "Right Ventricle    ",
  data_index = regex_and("SAX", "Global"),
  data_cols = list("pGRS" = 3, "pGCS" = 4)
)))

## 右室整体strain 长轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "右室整体Strain_LAX",
  measure_index = "Global Measurements Report",
  mode_index = "Right Ventricle    ",
  data_index = regex_and("LAX", "Global"),
  data_cols = list("pGRS" = 3, "pGLS" = 5)
)))

# ***LGE***
## 仅适用于未勾选灰区分析的组织信号分析报告
## 如需T2及灰区分析结果，请另行书写entry_lists
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "LGE",
  measure_index = "延迟强化",
  mode_index = "阈值类型",
  data_index = "容积",
  data_cols = list("心肌容量" = 7, "LGE容积" = 14, "MVO容积" = 15, "LGE+MVO" = 17)
)))

# ***T2 Mapping***
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "T2 value",
  measure_index = "Global Myocardial T2",
  mode_index = "slice",
  data_index = c("^1", "^2", "^3"),
  data_cols = list("mean" = 2, "median" = 3)
)))

# ***T2* Mapping***
## 需要分层面提取
###层面1
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "T2*_slice1",
  measure_index = "T2\\* ",
  mode_index = "层面 1",
  data_index = c("T2 \\(ms\\)","T2 错误\\(ms\\)")
)))

###层面2
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "T2*_slice2",
  measure_index = "T2\\* ",
  mode_index = "层面 2",
  data_index = c("T2 \\(ms\\)","T2 错误\\(ms\\)")
)))

###层面3
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "T2*_slice3",
  measure_index = "T2\\* ",
  mode_index = "层面 3",
  data_index = c("T2 \\(ms\\)","T2 错误\\(ms\\)")
)))
# ——————————————————————————————————————————————————————————————————————————————
# 执行提取函数，获取提取结果
extracted_data_frame <- extract_data_from_txt_files(data_entry_lists, data_folder)

# **查看结果**
# print(extracted_data_frame)

# current time stamps
current_time <- format(Sys.time(), "%Y_%m_%d_%H_%M_%S")

# **导出结果**
write.xlsx(extracted_data_frame, paste("results-", current_time, ".xlsx", sep = ''), keepNA = TRUE)
