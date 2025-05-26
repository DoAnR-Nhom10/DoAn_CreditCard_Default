# Mô tả: Phân chia dữ liệu thành tập huấn luyện và tập kiểm tra, chuẩn bị cho mô hình hóa

source("00_setup_environment.R")

# Đọc dữ liệu đã xử lý từ feature engineering
data <- readRDS(OUTPUT_ENGINEERED_FILE)

# Thiết lập seed để đảm bảo tính tái lập
set.seed(123)

# Sử dụng tidymodels để phân chia dữ liệu
library(tidymodels)

# Phân chia dữ liệu: 80% train, 20% test, với strata để duy trì tỷ lệ biến mục tiêu
split <- initial_split(data, prop = 0.8, strata = default.payment.next.month)
train_data <- training(split)
test_data <- testing(split)

# Kiểm tra kích thước của các tập dữ liệu
cat("Kích thước tập huấn luyện:\n")
dim(train_data)
cat("Kích thước tập kiểm tra:\n")
dim(test_data)

# Kiểm tra tỷ lệ biến mục tiêu trong tập train và test
cat("Tỷ lệ default.payment.next.month trong tập huấn luyện:\n")
prop.table(table(train_data$default.payment.next.month))
cat("Tỷ lệ default.payment.next.month trong tập kiểm tra:\n")
prop.table(table(test_data$default.payment.next.month))

# Lưu các tập dữ liệu
TRAIN_FILE <- paste0(PROCESSED_DIR, "train_data.rds")
TEST_FILE <- paste0(PROCESSED_DIR, "test_data.rds")
saveRDS(train_data, TRAIN_FILE)
saveRDS(test_data, TEST_FILE)
cat("Đã lưu tập huấn luyện vào", TRAIN_FILE, "\n")
cat("Đã lưu tập kiểm tra vào", TEST_FILE, "\n")

# Thông báo hoàn tất
cat("Phân chia dữ liệu hoàn tất!\n")