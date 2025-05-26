# Mô tả: Huấn luyện 3 mô hình học máy (Logistic Regression, Random Forest, XGBoost) và xử lý mất cân bằng dữ liệu

source("00_setup_environment.R")

# Tải các thư viện bổ sung
library(DMwR)      # Cho SMOTE
library(randomForest)
library(xgboost)
library(pROC)      # Để tính ROC-AUC
library(caret)     # Để đánh giá mô hình
library(fastDummies)  # Cho one-hot encoding
library(themis)

# Thiết lập seed để đảm bảo tính tái lập
set.seed(123)

# Định nghĩa đường dẫn thư mục mô hình nếu chưa có
if (!exists("MODELS_DIR")) {
  MODELS_DIR <- "../2_Models/"
}

# Đọc dữ liệu huấn luyện và kiểm tra
train_data <- readRDS(paste0(PROCESSED_DIR, "train_data.rds"))
test_data <- readRDS(paste0(PROCESSED_DIR, "test_data.rds"))

# Kiểm tra tỷ lệ mất cân bằng của biến mục tiêu
cat("Tỷ lệ default.payment.next.month trong tập huấn luyện:\n")
table(train_data$default.payment.next.month)
prop.table(table(train_data$default.payment.next.month))

# Xử lý mất cân bằng dữ liệu bằng SMOTE
train_data_balanced <- SMOTE(
  default.payment.next.month ~ .,
  data = train_data,
  perc.over = 200,  # Tăng lớp thiểu số lên 200%
  perc.under = 100  # Giữ 100% lớp đa số
)

# Kiểm tra tỷ lệ sau khi cân bằng
cat("Tỷ lệ default.payment.next.month sau SMOTE:\n")
table(train_data_balanced$default.payment.next.month)
prop.table(table(train_data_balanced$default.payment.next.month))

# Đảm bảo biến mục tiêu là factor
train_data_balanced$default.payment.next.month <- as.factor(train_data_balanced$default.payment.next.month)
test_data$default.payment.next.month <- as.factor(test_data$default.payment.next.month)

# One-hot encoding cho các biến phân loại
categorical_vars <- c("EDUCATION", "MARRIAGE", "SEX")
train_data_balanced <- dummy_cols(train_data_balanced, select_columns = categorical_vars, remove_selected_columns = TRUE)
test_data <- dummy_cols(test_data, select_columns = categorical_vars, remove_selected_columns = TRUE)

# Đảm bảo tất cả các cột trong test_data khớp với train_data_balanced
# Thêm các cột thiếu trong test_data (nếu có) và gán giá trị 0
missing_cols <- setdiff(names(train_data_balanced), names(test_data))
for (col in missing_cols) {
  test_data[[col]] <- 0
}
# Loại bỏ các cột dư trong test_data (nếu có)
test_data <- test_data[, names(train_data_balanced)]

# Chuẩn bị dữ liệu cho XGBoost (chuyển thành xgb.DMatrix)
predictors <- setdiff(names(train_data_balanced), "default.payment.next.month")
train_matrix <- as.matrix(train_data_balanced[, predictors])
test_matrix <- as.matrix(test_data[, predictors])

# Kiểm tra xem train_matrix có phải là numeric không
if (!is.numeric(train_matrix)) {
  cat("Các cột không phải kiểu numeric trong train_matrix:\n")
  print(names(train_data_balanced[, predictors])[sapply(train_data_balanced[, predictors], function(x) !is.numeric(x))])
  stop("train_matrix chứa các cột không phải numeric")
}
if (!is.numeric(test_matrix)) {
  cat("Các cột không phải kiểu numeric trong test_matrix:\n")
  print(names(test_data[, predictors])[sapply(test_data[, predictors], function(x) !is.numeric(x))])
  stop("test_matrix chứa các cột không phải numeric")
}

train_labels <- as.numeric(train_data_balanced$default.payment.next.month) - 1  # XGBoost yêu cầu nhãn 0/1
test_labels <- as.numeric(test_data$default.payment.next.month) - 1

xgb_train <- xgb.DMatrix(data = train_matrix, label = train_labels)
xgb_test <- xgb.DMatrix(data = test_matrix, label = test_labels)

# 1. Huấn luyện Logistic Regression
cat("\n--- Huấn luyện Logistic Regression ---\n")
model_lr <- glm(
  default.payment.next.month ~ .,
  data = train_data_balanced,
  family = binomial(link = "logit")
)

# In tóm tắt mô hình Logistic Regression
cat("Tóm tắt Logistic Regression:\n")
summary(model_lr)

# Dự đoán trên tập kiểm tra
lr_pred_prob <- predict(model_lr, newdata = test_data, type = "response")
lr_pred <- ifelse(lr_pred_prob > 0.5, 1, 0)
lr_pred <- factor(lr_pred, levels = c(0, 1))

# Đánh giá mô hình
lr_conf_matrix <- confusionMatrix(lr_pred, test_data$default.payment.next.month, positive = "1")
cat("Ma trận nhầm lẫn Logistic Regression:\n")
print(lr_conf_matrix)

lr_roc <- roc(test_labels, lr_pred_prob)
cat("AUC của Logistic Regression:", auc(lr_roc), "\n")

# Lưu mô hình
saveRDS(model_lr, paste0(MODELS_DIR, "logistic_regression_final.rds"))
cat("Đã lưu mô hình Logistic Regression vào", paste0(MODELS_DIR, "logistic_regression_final.rds"), "\n")

# 2. Huấn luyện Random Forest
cat("\n--- Huấn luyện Random Forest ---\n")
model_rf <- randomForest(
  default.payment.next.month ~ .,
  data = train_data_balanced,
  ntree = 500,
  mtry = sqrt(ncol(train_data_balanced) - 1),  # Số biến thử ngẫu nhiên
  importance = TRUE,
  classwt = c(1, 1)  # Trọng số lớp cân bằng
)

# Dự đoán trên tập kiểm tra
rf_pred <- predict(model_rf, newdata = test_data)
rf_pred_prob <- predict(model_rf, newdata = test_data, type = "prob")[, 2]

# Đánh giá mô hình
rf_conf_matrix <- confusionMatrix(rf_pred, test_data$default.payment.next.month, positive = "1")
cat("Ma trận nhầm lẫn Random Forest:\n")
print(rf_conf_matrix)

rf_roc <- roc(test_labels, rf_pred_prob)
cat("AUC của Random Forest:", auc(rf_roc), "\n")

# Lưu mô hình
saveRDS(model_rf, paste0(MODELS_DIR, "random_forest_final.rds"))
cat("Đã lưu mô hình Random Forest vào", paste0(MODELS_DIR, "random_forest_final.rds"), "\n")

# 3. Huấn luyện XGBoost
cat("\n--- Huấn luyện XGBoost ---\n")
# Tìm số vòng lặp tối ưu bằng cross-validation
xgb_params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  max_depth = 6,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8,
  scale_pos_weight = sum(train_labels == 0) / sum(train_labels == 1)  # Xử lý mất cân bằng
)

xgb_cv <- xgb.cv(
  params = xgb_params,
  data = xgb_train,
  nrounds = 1000,
  nfold = 5,
  early_stopping_rounds = 50,
  verbose = 0
)

best_nrounds <- xgb_cv$best_iteration
cat("Số vòng lặp tối ưu cho XGBoost:", best_nrounds, "\n")

# Huấn luyện mô hình XGBoost
model_xgb <- xgboost(
  data = xgb_train,
  params = xgb_params,
  nrounds = best_nrounds,
  verbose = 0
)

# Dự đoán trên tập kiểm tra
xgb_pred_prob <- predict(model_xgb, xgb_test)
xgb_pred <- ifelse(xgb_pred_prob > 0.5, 1, 0)
xgb_pred <- factor(xgb_pred, levels = c(0, 1))

# Đánh giá mô hình
xgb_conf_matrix <- confusionMatrix(xgb_pred, test_data$default.payment.next.month, positive = "1")
cat("Ma trận nhầm lẫn XGBoost:\n")
print(xgb_conf_matrix)

xgb_roc <- roc(test_labels, xgb_pred_prob)
cat("AUC của XGBoost:", auc(xgb_roc), "\n")

# Lưu mô hình
saveRDS(model_xgb, paste0(MODELS_DIR, "xgboost_final.rds"))
cat("Đã lưu mô hình XGBoost vào", paste0(MODELS_DIR, "xgboost_final.rds"), "\n")

# Tạo và lưu biểu đồ ROC
png(paste0(RESULTS_DIR, "model_performance/roc_curves_comparison.png"), width = 800, height = 600)
plot(lr_roc, col = "blue", main = "So sánh ROC Curves")
plot(rf_roc, col = "green", add = TRUE)
plot(xgb_roc, col = "red", add = TRUE)
legend("bottomright", 
       legend = c("Logistic Regression", "Random Forest", "XGBoost"),
       col = c("blue", "green", "red"), lty = 1)
dev.off()
cat("Đã lưu biểu đồ ROC vào", paste0(RESULTS_DIR, "model_performance/roc_curves_comparison.png"), "\n")

# Tạo biểu đồ tổng hợp hiệu suất
performance_summary <- data.frame(
  Model = c("Logistic Regression", "Random Forest", "XGBoost"),
  Accuracy = c(
    lr_conf_matrix$overall["Accuracy"],
    rf_conf_matrix$overall["Accuracy"],
    xgb_conf_matrix$overall["Accuracy"]
  ),
  Precision = c(
    lr_conf_matrix$byClass["Precision"],
    rf_conf_matrix$byClass["Precision"],
    xgb_conf_matrix$byClass["Precision"]
  ),
  Recall = c(
    lr_conf_matrix$byClass["Recall"],
    rf_conf_matrix$byClass["Recall"],
    xgb_conf_matrix$byClass["Recall"]
  ),
  F1 = c(
    lr_conf_matrix$byClass["F1"],
    rf_conf_matrix$byClass["F1"],
    xgb_conf_matrix$byClass["F1"]
  ),
  AUC = c(auc(lr_roc), auc(rf_roc), auc(xgb_roc))
)

# Lưu bảng tổng hợp
write.csv(performance_summary, paste0(RESULTS_DIR, "model_performance/performance_metrics_summary.csv"), row.names = FALSE)
cat("Đã lưu bảng tổng hợp hiệu suất vào", paste0(RESULTS_DIR, "model_performance/performance_metrics_summary.csv"), "\n")

# Thông báo hoàn tất
cat("Huấn luyện mô hình hoàn tất!\n")