# BACKGROUND FUNCTION
# NOT FOR EDIT
# ——————————————————————————————————————————————————————————————————————————————
# 提取函数
extract_data_from_txt_files <- function(data_entry_lists, data_folder){
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

  return(extracted_data_frame)  # 输出提取表格
  
}