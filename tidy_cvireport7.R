# V2.1
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


# paste("keyword1", "keyword2", sep = ".*")  # 与，保持前后顺序， “与” 逻辑关键词的书写范例
# paste("keyword1", "keyword2", sep = "|")  # 或，保持前后顺序， “或” 逻辑关键词的书写范例

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
  data_name = "SAX3D LV & RV Function",
  measure_index = "SAX 3D Function",
  mode_index = "Clinical Results LV",
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
  data_index = c(paste("SAX", "Global", sep = ".*")),
  data_cols = list("pGRS" = 3, "pGCS" = 4)
)))

## 左室整体strain 长轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "左室整体Strain_LAX",
  measure_index = "Global Measurements Report",
  mode_index = "Left Ventricle    ",
  data_index = c(paste("LAX", "Global", sep = ".*")),
  data_cols = list("pGRS" = 3, "pGLS" = 5)
)))

## 右室整体strain 短轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "右室整体Strain_SAX",
  measure_index = "Global Measurements Report",
  mode_index = "Right Ventricle    ",
  data_index = c(paste("SAX", "Global", sep = ".*")),
  data_cols = list("pGRS" = 3, "pGCS" = 4)
)))

## 右室整体strain 长轴
data_entry_lists <- append(data_entry_lists, list(list(
  data_name = "右室整体Strain_LAX",
  measure_index = "Global Measurements Report",
  mode_index = "Right Ventricle    ",
  data_index = c(paste("LAX", "Global", sep = ".*")),
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
# extracted_data_frame <- extract_data_from_txt_files(data_entry_lists, data_folder)

# 定义调试模式变量
debug_mode <- FALSE

# 获取待处理txt文件列表
current_work_director <- getwd()
data_folder_path <- file.path(current_work_director, data_folder)
file_list <- list.files(data_folder_path, pattern = "\\.txt$", full.names = TRUE)

# ——————————————————————————————————————————————————————————————————————————————
# 预定义函数
find_first_line_with_keyword <- function(text_lines, keyword, startLine = 1) {
  # 使用grep()函数找到包含关键字的行号
  line_number <- grep(keyword, text_lines[(startLine):length(text_lines)])[1]
  if (!is.na(line_number)) {
    line_number <- line_number + startLine - 1
  }
  return(line_number)  # 返回行号
}

find_patient_info <- function(text_lines, keyword) {
  # 使用grep()函数找到包含关键字的行号
  line_number <- grep(keyword, text_lines)[1]
  return(strsplit(text_lines[line_number], "\t")[[1]][2])
}

extracted_patient_list <- list()
extracted_data_frame<- data.frame()

for (file_path in file_list){
  
  if (debug_mode) {print(paste("File Path: ", file_path))}  # 调式模式
  
  # 每个txt提取的输出数据是一个list
  patient_data <- list()
  
  # read txt file, automatically guess encoding
  txt_raw <- iconv(list(readBin(file_path, raw(), file.info(file_path)$size)), 
                   from=readr::guess_encoding(file_path)$encoding[1])
  
  text_lines <- unlist(stringi::stri_split_lines(txt_raw))
  
  # 提取基本参数
  patient_data$patient_name <- find_patient_info(text_lines[1:50], "患者")
  patient_data$patient_ID <- find_patient_info(text_lines[1:50], "患者编号")
  patient_data$exam_date <- find_patient_info(text_lines[1:50], "病例日期")
  patient_data$exam_ID <- find_patient_info(text_lines[1:50], "检查编号")
  patient_data$source <- file_path
  
  # 输出的一行数据
  data_to_save <- patient_data
  
  # 提取目标数据
  for (data_entry in data_entry_lists){
    
    if (debug_mode) {print(paste("Data Name: ", data_entry$data_name))}  # 调式模式
    
    # 检查data_entry列表中是否存在名为data_row的元素
    data_row_exists <- "data_rows" %in% names(data_entry)
    
    # 如果存在，则将data_row_numbers设置为data_entry中data_row的值
    # 如果不存在，则将data_row_numbers设置为总行数
    data_rows <- if (data_row_exists) {
      data_entry[["data_rows"]]
    } else {
      setNames(rep(list(1), length(data_entry$data_index)), data_entry$data_index)
    }
    
    # 检查data_entry列表中是否存在名为data_col的元素
    data_col_exists <- "data_cols" %in% names(data_entry)
    
    # 如果存在，则将data_col_numbers设置为data_entry中data_col的值
    # 如果不存在，则将data_col_numbers设置为2
    data_cols <- if (data_col_exists) {
      data_entry[["data_cols"]]
    } else {
      list(2)
    }
    
    if(is.na(measure_line_number <- find_first_line_with_keyword(text_lines, data_entry$measure_index))){
      data_extraced <- matrix(NA, nrow = length(data_rows), ncol = length(data_cols))
    }else if(is.na(mode_line_number <- find_first_line_with_keyword(text_lines, data_entry$mode_index, measure_line_number))){
      data_extraced <- matrix(NA, nrow = length(data_rows), ncol = length(data_cols))
    }else{
      # find data line numbers to extract data
      data_line_numbers <- unlist(lapply(data_entry$data_index, function(data_name) {
        find_first_line_with_keyword(text_lines, data_name, mode_line_number)
      }))
      
      # 如果存在，对data_line_numbers做相应处理
      if (data_row_exists) {
        data_line_numbers <- data_line_numbers[1] + unlist(data_rows) - 1
      }
      
      if (debug_mode) {print(paste("Data Line Numbers: ", data_line_numbers))}  # 调式模式
      
      # extract data from the txt lines
      data_lines <- text_lines[data_line_numbers]
      
      # 处理每一行，补齐缺失值，确保所有行的列数一致，才能导出为table
      max_columns <- max(sapply(data_lines, function(line) length(strsplit(line, "\t")[[1]])), unlist(data_cols))
      
      # 处理每一行，补齐缺失值，确保所有行的列数一致，才能导出为table
      processed_lines <- lapply(data_lines, function(line) {
        cols <- strsplit(line, "\t")[[1]]
        if (length(cols) < max_columns) {
          cols <- c(cols, rep(NA, max_columns - length(cols)))
        }
        return(cols)
      })
      
      # 将处理后的数据转换为matrix
      data_table <- as.matrix(do.call(rbind, processed_lines))
      
      data_extraced <- data_table[,unlist(data_cols)]
      
      if (debug_mode) {print(paste("Data Extraced: ", data_extraced))}  # 调式模式
    }
    
    # 将整理好的data添加到patient
    patient_data[[data_entry$data_name]] <- data_extraced
    
    data_extraced <- as.vector(t(data_extraced))  # 矩阵按行展开成向量
    
    # 为提取的数据取名字
    data_names <- if(data_col_exists){
      outer(names(data_cols), names(data_rows), function(x, y) paste(y, x, sep = ","))
    } else{
      data_entry$data_index
    }
    
    data_name_prefix <- data_entry$data_name
    # data_name_prefix <- paste(data_entry$measure_index, data_entry$mode_index, sep = "-")
    
    data_names <- sapply(data_names, function(x) paste(data_name_prefix, "-[" , x, "]", sep = ""))
    
    names(data_extraced) <- as.vector(t(data_names))  # 矩阵按行展开成向量
    
    # 将数据添加到输出的一行数据
    data_to_save <- append(data_to_save, data_extraced)
    
  }
  
  # 将patient添加到最终结果
  extracted_patient_list <- c(extracted_patient_list, list(patient_data))
  
  extracted_data_frame <- rbind(extracted_data_frame, as.data.frame(data_to_save, check.names = FALSE))
  
}

# **查看结果**
# print(extracted_data_frame)

# current time stamps
current_time <- format(Sys.time(), "%Y_%m_%d_%H_%M_%S")

# **导出结果**
write.xlsx(extracted_data_frame, paste("results-", current_time, ".xlsx", sep = ''), keepNA = TRUE)
