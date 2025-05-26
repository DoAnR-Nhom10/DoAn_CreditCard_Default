# Mô tả: Tạo đặc trưng mới và chuẩn hóa dữ liệu

source("00_setup_environment.R")

# Đọc dữ liệu đã xử lý
data <- read.csv(OUTPUT_CLEAN_FILE, stringsAsFactors = FALSE)

# Tạo các biến mới
data <- data %>%
  mutate(
    CREDIT_UTILIZATION = ifelse(BILL_AMT1 > 0, PAY_AMT1 / BILL_AMT1, 0),  # Tỷ lệ sử dụng tín dụng
    TOTAL_DELAY = rowSums(select(., starts_with("PAY_")) > 0),  # Tổng số tháng trả trễ
    AVG_BILL = rowMeans(select(., starts_with("BILL_AMT"))),  # Số dư trung bình
    AVG_PAY = rowMeans(select(., starts_with("PAY_AMT")))  # Số tiền thanh toán trung bình
  )

# Xử lý giá trị Inf/NaN trong CREDIT_UTILIZATION
cat("Số lượng giá trị Inf/NaN trong CREDIT_UTILIZATION:\n")
sum(is.infinite(data$CREDIT_UTILIZATION) | is.nan(data$CREDIT_UTILIZATION))
data$CREDIT_UTILIZATION[is.infinite(data$CREDIT_UTILIZATION) | is.nan(data$CREDIT_UTILIZATION)] <- 0

# Chuẩn hóa các biến số
num_vars <- c("LIMIT_BAL", "AGE", paste0("BILL_AMT", 1:6), paste0("PAY_AMT", 1:6), 
              "CREDIT_UTILIZATION", "TOTAL_DELAY", "AVG_BILL", "AVG_PAY")
data[num_vars] <- scale(data[num_vars])

# Chuyển lại các biến phân loại thành factor
data$EDUCATION <- as.factor(data$EDUCATION)
data$MARRIAGE <- as.factor(data$MARRIAGE)
data$SEX <- as.factor(data$SEX)
data$default.payment.next.month <- as.factor(data$default.payment.next.month)

# Lưu dữ liệu sau feature engineering
OUTPUT_ENGINEERED_FILE <- paste0(PROCESSED_DIR, "features_engineered.rds")
saveRDS(data, OUTPUT_ENGINEERED_FILE)
cat("Đã lưu dữ liệu sau feature engineering vào", OUTPUT_ENGINEERED_FILE, "\n")

OUTPUT_ENGINEERED_CSV <- paste0(PROCESSED_DIR, "clean_default.csv") 
write.csv(data, OUTPUT_ENGINEERED_CSV, row.names = FALSE) 
cat("Saved engineered data to", OUTPUT_ENGINEERED_CSV, "\n")