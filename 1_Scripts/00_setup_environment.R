# Mô tả: Thiết lập môi trường, cài đặt thư viện, đường dẫn file, và seed

# Thiết lập seed để đảm bảo tính tái lập
set.seed(123)

# Cài đặt và tải các thư viện cần thiết
packages <- c("tidyverse", "gridExtra", "corrplot", "fastDummies", "tidymodels")
installed <- packages %in% rownames(installed.packages())
if (any(!installed)) {
  install.packages(packages[!installed])
}

# Tải thư viện
lapply(packages, library, character.only = TRUE)

# Định nghĩa đường dẫn thư mục
DATA_DIR <- "../0_Data/"
RAW_DIR <- paste0(DATA_DIR, "raw/")
PROCESSED_DIR <- paste0(DATA_DIR, "processed/")
METADATA_DIR <- paste0(DATA_DIR, "metadata/")
RESULTS_DIR <- "../3_Results/"
EDA_PLOTS_DIR <- paste0(RESULTS_DIR, "eda_plots/")
MODELS_DIR <- "../2_Models/"


# Định nghĩa các hằng số
INPUT_FILE <- paste0(RAW_DIR, "UCI_Credit_Card.csv")
OUTPUT_CLEAN_FILE <- paste0(PROCESSED_DIR, "clean_default.csv")

# Thông báo hoàn tất
cat("Môi trường đã được thiết lập thành công!\n")