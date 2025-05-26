# Mô tả: Đọc dữ liệu, kiểm tra cấu trúc, xử lý giá trị thiếu và bất thường, chuyển đổi kiểu dữ liệu

source("00_setup_environment.R")
# Đọc dữ liệu
data <- read.csv(INPUT_FILE, stringsAsFactors = FALSE)

# Kiểm tra cấu trúc dữ liệu
cat("Cấu trúc dữ liệu:\n")
str(data)
cat("Tóm tắt dữ liệu:\n")
summary(data)
cat("Kích thước dữ liệu:\n")
dim(data)
cat("Tên các cột:\n")
colnames(data)

# Kiểm tra giá trị thiếu
cat("Kiểm tra giá trị thiếu:\n")
colSums(is.na(data))

# Xử lý giá trị bất thường trong EDUCATION
cat("Tần suất EDUCATION trước xử lý:\n")
table(data$EDUCATION)
data$EDUCATION[data$EDUCATION %in% c(0, 5, 6)] <- 4
cat("Tần suất EDUCATION sau xử lý:\n")
table(data$EDUCATION)

# Xử lý giá trị bất thường trong MARRIAGE
cat("Tần suất MARRIAGE trước xử lý:\n")
table(data$MARRIAGE)
data$MARRIAGE[data$MARRIAGE == 0] <- 3
cat("Tần suất MARRIAGE sau xử lý:\n")
table(data$MARRIAGE)

# Chuyển biến thành factor
data$EDUCATION <- as.factor(data$EDUCATION)
data$MARRIAGE <- as.factor(data$MARRIAGE)
data$SEX <- as.factor(data$SEX)
data$default.payment.next.month <- as.factor(data$default.payment.next.month)

# Lưu dữ liệu đã xử lý
write.csv(data, OUTPUT_CLEAN_FILE, row.names = FALSE)
cat("Đã lưu dữ liệu đã xử lý vào", OUTPUT_CLEAN_FILE, "\n")


data_clean <- read.csv(OUTPUT_CLEAN_FILE, stringsAsFactors = FALSE)

# Cấu trúc 
cat("Cấu trúc dữ liệu clean_default.csv:\n")
str(data_clean)

# Kiểm tra tần suất giá trị trong EDUCATION
cat("Tần suất giá trị trong EDUCATION:\n")
table(data_clean$EDUCATION)
# Kiểm tra xem có giá trị bất thường nào 
education_outliers <- data_clean$EDUCATION[!data_clean$EDUCATION %in% c(1, 2, 3, 4)]
if (length(education_outliers) > 0) {
  cat("Giá trị bất thường trong EDUCATION:\n")
  print(unique(education_outliers))
} else {
  cat("Không có giá trị bất thường trong EDUCATION (tất cả giá trị thuộc {1, 2, 3, 4}).\n")
}

# Kiểm tra tần suất giá trị trong MARRIAGE
cat("\nTần suất giá trị trong MARRIAGE:\n")
table(data_clean$MARRIAGE)
# Kiểm tra xem có giá trị bất thường nào (0, hoặc khác 1,2,3)
marriage_outliers <- data_clean$MARRIAGE[!data_clean$MARRIAGE %in% c(1, 2, 3)]
if (length(marriage_outliers) > 0) {
  cat("Giá trị bất thường trong MARRIAGE:\n")
  print(unique(marriage_outliers))
} else {
  cat("Không có giá trị bất thường trong MARRIAGE (tất cả giá trị thuộc {1, 2, 3}).\n")
}

library(ggplot2)
library(gridExtra)
# Biểu đồ trực quan khi EDUCATION và MARRIAGE không còn giá trị bất thường
# Trực quan hóa phân phối của EDUCATION và MARRIAGE
# EDUCATION
p1 <- ggplot(data_clean, aes(x = as.factor(EDUCATION))) +
  geom_bar(fill = "purple", alpha = 0.7) +
  labs(title = "Phân phối EDUCATION",
       x = "1=Graduate, 2=University, 3=High School, 4=Others",
       y = "Số lượng") +
  theme_minimal()

# MARRIAGE
p2 <- ggplot(data_clean, aes(x = as.factor(MARRIAGE))) +
  geom_bar(fill = "orange", alpha = 0.7) +
  labs(title = "Phân phối MARRIAGE",
       x = "1=Married, 2=Single, 3=Others",
       y = "Số lượng") +
  theme_minimal()
combined_plot <- arrangeGrob(p1, p2, ncol = 2)
ggsave(
  filename = paste0(EDA_PLOTS_DIR, "education_marriage_distribution_clean_default.png"),
  plot = combined_plot,
  width = 10,
  height = 5
)

library(grid) 
grid.draw(combined_plot)