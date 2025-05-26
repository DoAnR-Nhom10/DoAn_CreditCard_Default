```markdown
# Dự đoán Khả năng Vỡ nợ Thẻ Tín dụng (Credit Card Default Prediction)

## Tổng quan Dự án

Dự án này nhằm mục đích dự đoán khả năng vỡ nợ thẻ tín dụng dựa trên Bộ dữ liệu thẻ tín dụng UCI (`UCI_Credit_Card.csv`). Bộ dữ liệu này chứa thông tin nhân khẩu học, lịch sử tín dụng và hành vi thanh toán của khách hàng thẻ tín dụng tại Đài Loan. Mục tiêu là xây dựng và đánh giá các mô hình học máy để xác định khách hàng có nguy cơ vỡ nợ thanh toán thẻ tín dụng, qua đó cung cấp thông tin chi tiết thực tế cho các tổ chức tài chính để quản lý rủi ro tín dụng hiệu quả hơn.

Dự án tuân theo một quy trình có cấu trúc, bao gồm:
- Thu thập dữ liệu
- Tiền xử lý dữ liệu
- Phân tích dữ liệu khám phá (EDA)
- Kỹ thuật tạo đặc trưng (Feature Engineering)
- Huấn luyện mô hình
- Tinh chỉnh siêu tham số (Hyperparameter Tuning)
- Đánh giá mô hình

Ba mô hình học máy chính được triển khai và so sánh:
1.  **Hồi quy Logistic (Logistic Regression)**
2.  **Rừng Ngẫu nhiên (Random Forest)**
3.  **XGBoost**

Dự án tập trung vào việc xử lý dữ liệu mất cân bằng và tối ưu hóa các độ đo hiệu suất quan trọng như AUC-ROC, Precision, Recall và F1-Score.

## Mô tả Tập dữ liệu

-   **Nguồn:** Kho lưu trữ Máy học UCI (UCI Machine Learning Repository).
-   **Tên file:** `UCI_Credit_Card.csv`
-   **Số lượng bản ghi:** Khoảng 30,000
-   **Số lượng thuộc tính:** 24

Các thuộc tính chính bao gồm:
-   **Thông tin nhân khẩu học:** `AGE` (Tuổi), `SEX` (Giới tính), `EDUCATION` (Trình độ học vấn), `MARRIAGE` (Tình trạng hôn nhân).
-   **Lịch sử tín dụng:**
    -   `LIMIT_BAL`: Hạn mức tín dụng.
    -   `PAY_0` đến `PAY_6`: Tình trạng thanh toán (tháng 4/2005 - tháng 9/2005).
    -   `BILL_AMT1` đến `BILL_AMT6`: Số tiền trên sao kê (tháng 4/2005 - tháng 9/2005).
    -   `PAY_AMT1` đến `PAY_AMT6`: Số tiền thanh toán (tháng 4/2005 - tháng 9/2005).
-   **Biến mục tiêu:** `default.payment.next.month` (1 = vỡ nợ, 0 = không vỡ nợ).

Bộ dữ liệu có sự mất cân bằng ở mức độ vừa phải, với tỷ lệ khách hàng vỡ nợ (lớp 1) thấp hơn so với tỷ lệ không vỡ nợ (lớp 0).

## Cấu trúc Dự án

```
DoAn_CreditCard_Default_Prediction/
├── 0_Data/
│   ├── raw/
│   │   └── UCI_Credit_Card.csv                   # Dữ liệu thô
│   ├── processed/
│   │   ├── clean_default.csv                     # Dữ liệu đã làm sạch sau tiền xử lý
│   │   ├── features_engineered.rds               # Dữ liệu sau khi tạo đặc trưng
│   │   ├── train_data.rds                        # Tập dữ liệu huấn luyện
│   │   ├── test_data.rds                         # Tập dữ liệu kiểm tra
│   └── metadata/
│       └── data_description.txt                  # Mô tả các cột của bộ dữ liệu
├── 1_Scripts/
│   ├── 00_setup_environment.R                    # Thiết lập môi trường, thư viện và hằng số
│   ├── 01_data_ingestion_preparation.R           # Tải, làm sạch và tiền xử lý dữ liệu
│   ├── 02_exploratory_data_analysis.Rmd          # Phân tích dữ liệu khám phá (EDA) với trực quan hóa và kiểm định thống kê
│   ├── 03_feature_engineering.R                  # Tạo và chuẩn hóa đặc trưng
│   ├── 04_preprocessing_for_modeling.R           # Chia tập huấn luyện/kiểm tra và tiền xử lý cho mô hình hóa
│   ├── 05_model_training.R                       # Huấn luyện mô hình Hồi quy Logistic, Rừng Ngẫu nhiên và XGBoost
│   ├── 06_hyperparameter_tuning.Rmd              # Tinh chỉnh siêu tham số cho Rừng Ngẫu nhiên và XGBoost
│   ├── 07_model_evaluation.Rmd                   # Đánh giá và so sánh mô hình
│   └── 1_Scripts.Rproj                           # File RStudio
├── 2_Models/
│   ├── logistic_regression_final.rds             # Mô hình Hồi quy Logistic đã huấn luyện
│   ├── random_forest_final.rds                   # Mô hình Rừng Ngẫu nhiên đã huấn luyện (chưa tune)
│   ├── random_forest_tuned_final.rds             # Mô hình Rừng Ngẫu nhiên đã tinh chỉnh
│   ├── xgboost_final.rds                         # Mô hình XGBoost đã huấn luyện (chưa tune)
│   ├── xgboost_tuned_final.rds                   # Mô hình XGBoost đã tinh chỉnh
├── 3_Results/
│   ├── eda_plots/
│   │   ├── bivariate_categorical_target.png      # Biến phân loại vs. Biến mục tiêu
│   │   ├── bivariate_numeric_target.png          # Biến số vs. Biến mục tiêu
│   │   ├── correlation_matrix.png                # Ma trận tương quan
│   │   ├── default_by_education_sex.png          # Tỷ lệ vỡ nợ theo trình độ học vấn và giới tính
│   │   ├── eda_summary_plots.png                 # Các biểu đồ tổng hợp EDA
│   │   ├── education_marriage_distribution_clean_default.png # Phân phối trình độ học vấn và tình trạng hôn nhân
│   │   ├── scatter_limit_bal_avg_bill.png        # Biểu đồ phân tán LIMIT_BAL vs. AVG_BILL
│   │   └── univariate_categorical.png            # Phân phối của các biến phân loại
│   ├── model_performance/
│   │   ├── roc_curves_comparison_final.png       # Đường cong ROC so sánh các mô hình
│   │   ├── pr_curves_comparison_final.png        # Đường cong Precision-Recall
│   │   └── performance_metrics_summary_final.csv # Bảng tổng hợp các độ đo hiệu suất mô hình
│   ├── feature_importance/
│   │   ├── rf_feature_importance_final.png       # Độ quan trọng của đặc trưng từ Rừng Ngẫu nhiên
│   │   └── xgb_feature_importance_final.png      # Độ quan trọng của đặc trưng từ XGBoost
├── 4_Report/
│   ├── DoAn_CreditCard_Report.Rmd                # Báo cáo chính (R Markdown)
│   ├── Nhóm 10 - Báo Cáo.pdf                     # Báo cáo đã biên dịch (PDF)
│   ├── Nhóm 10 - PPT.pdf                         # Slide thuyết trình
├── .gitignore                                    # Các file/thư mục bị bỏ qua bởi Git
├── README.md                                     # Tổng quan và hướng dẫn dự án
```

## Yêu cầu Hệ thống và Thư viện

Dự án yêu cầu các gói R sau, được cài đặt và tải trong `00_setup_environment.R`:

```R
packages <- c("tidyverse", "gridExtra", "corrplot", "fastDummies", 
              "tidymodels", "DMwR", "randomForest", "xgboost", 
              "pROC", "caret", "themis", "knitr", "broom", 
              "patchwork", "vip", "kableExtra")
```

Đảm bảo bạn đã cài đặt:
-   **R:** Phiên bản 4.0 trở lên.
-   **RStudio:** Phiên bản mới nhất được khuyến nghị.

Để cài đặt các gói cần thiết, chạy lệnh sau trong R Console:
```R
source("1_Scripts/00_setup_environment.R")
```

## Quy trình Làm việc

Dự án tuân theo một quy trình có cấu trúc:

1.  **Thiết lập Môi trường (`00_setup_environment.R`)**:
    *   Cài đặt và tải các gói cần thiết.
    *   Đặt seed để đảm bảo tính tái lặp (`set.seed(123)`).
    *   Định nghĩa đường dẫn tệp và các hằng số cho dữ liệu, kết quả và mô hình.

2.  **Thu thập và Tiền xử lý Dữ liệu (`01_data_ingestion_preparation.R`)**:
    *   Tải bộ dữ liệu (`UCI_Credit_Card.csv`).
    *   Kiểm tra cấu trúc dữ liệu, các giá trị thiếu và giá trị ngoại lai.
    *   Xử lý các giá trị không hợp lệ trong `EDUCATION` và `MARRIAGE` (ví dụ: `EDUCATION`: 0, 5, 6 → 4; `MARRIAGE`: 0 → 3).
    *   Chuyển đổi các biến phân loại thành kiểu `factor`.
    *   Lưu dữ liệu đã làm sạch vào `0_Data/processed/clean_default.csv`.

3.  **Phân tích Dữ liệu Khám phá (`02_exploratory_data_analysis.Rmd`)**:
    *   Thực hiện phân tích đơn biến và đa biến bằng cách sử dụng các hình ảnh trực quan (biểu đồ histogram, biểu đồ mật độ, biểu đồ hộp, biểu đồ cột, biểu đồ phân tán, ma trận tương quan).
    *   Thực hiện các kiểm định thống kê cơ bản (kiểm định t, kiểm định chi bình phương) để khám phá mối quan hệ giữa các biến và biến mục tiêu (`default.payment.next.month`).
    *   Lưu các biểu đồ EDA vào `3_Results/eda_plots/`.

4.  **Kỹ thuật Tạo Đặc trưng (`03_feature_engineering.R`)**:
    *   Tạo các đặc trưng mới: tỷ lệ sử dụng tín dụng, tổng số tháng trả trễ, số dư hóa đơn trung bình và số tiền thanh toán trung bình.
    *   Xử lý các giá trị vô hạn/NaN trong các đặc trưng mới (nếu có).
    *   Chuẩn hóa (scale) các biến số.
    *   Lưu dữ liệu đã tạo đặc trưng vào `0_Data/processed/features_engineered.rds`.

5.  **Tiền xử lý cho Mô hình hóa (`04_preprocessing_for_modeling.R`)**:
    *   Chia dữ liệu thành tập huấn luyện (80%) và tập kiểm tra (20%) bằng `tidymodels::initial_split()` với phương pháp phân tầng (stratification) để duy trì tỷ lệ của biến mục tiêu.
    *   Lưu tập huấn luyện và kiểm tra vào `0_Data/processed/train_data.rds` và `0_Data/processed/test_data.rds`.

6.  **Huấn luyện Mô hình (`05_model_training.R`)**:
    *   Huấn luyện ba mô hình: Hồi quy Logistic, Rừng Ngẫu nhiên và XGBoost.
    *   Xử lý mất cân bằng dữ liệu trên tập huấn luyện bằng kỹ thuật SMOTE (`themis::smote`).
    *   Thực hiện mã hóa one-hot cho các biến phân loại (nếu cần thiết cho mô hình).
    *   Lưu các mô hình đã huấn luyện (chưa tinh chỉnh) vào `2_Models/`.

7.  **Tinh chỉnh Siêu tham số (`06_hyperparameter_tuning.Rmd`)**:
    *   Tinh chỉnh Rừng Ngẫu nhiên (ví dụ: `mtry`, `ntree`/`trees`, `min_n`) bằng Grid Search.
    *   Tinh chỉnh XGBoost (ví dụ: `mtry`, `trees`, `min_n`, `learn_rate`, `tree_depth`, `sample_size`) bằng Random Search.
    *   Sử dụng K-Fold Cross-Validation (ví dụ: 5-fold) với ROC-AUC làm độ đo tối ưu hóa.
    *   Lưu các mô hình đã tinh chỉnh vào `2_Models/random_forest_tuned_final.rds` và `2_Models/xgboost_tuned_final.rds`.

8.  **Đánh giá Mô hình (`07_model_evaluation.Rmd`)**:
    *   Đánh giá tất cả các mô hình (bao gồm cả mô hình đã tinh chỉnh) trên tập kiểm tra bằng các độ đo: Accuracy, Precision, Recall, F1-Score, AUC-ROC và AUC-PR.
    *   Tạo đường cong ROC và Precision-Recall để so sánh trực quan các mô hình.
    *   Phân tích độ quan trọng của đặc trưng (Feature Importance) cho Rừng Ngẫu nhiên và XGBoost.
    *   Lưu kết quả (độ đo, biểu đồ) vào `3_Results/model_performance/` và `3_Results/feature_importance/`.

## Cách chạy Dự án

1.  **Sao chép (Clone) Kho lưu trữ**:
    ```bash
    git clone <repository-url>
    cd DoAn_CreditCard_Default_Prediction
    ```

2.  **Thiết lập Môi trường**:
    *   Mở dự án trong RStudio bằng cách nhấp đúp vào file `DoAn_CreditCard_Default.Rproj`.
    *   Chạy script `1_Scripts/00_setup_environment.R` để cài đặt các thư viện cần thiết và thiết lập đường dẫn:
        ```R
        source("1_Scripts/00_setup_environment.R")
        ```

3.  **Chuẩn bị Bộ dữ liệu**:
    *   Đảm bảo file `UCI_Credit_Card.csv` nằm trong thư mục `0_Data/raw/`.

4.  **Thực thi các Scripts theo thứ tự**:
    Chạy các scripts từ `01` đến `07` trong thư mục `1_Scripts/` theo đúng trình tự. Bạn có thể chạy từng file `.R` bằng lệnh `source()` và render các file `.Rmd` bằng `rmarkdown::render()`:
    ```R
    # Trong R Console
    source("1_Scripts/01_data_ingestion_preparation.R")
    source("1_Scripts/03_feature_engineering.R")
    rmarkdown::render("1_Scripts/02_exploratory_data_analysis.Rmd")
    source("1_Scripts/04_preprocessing_for_modeling.R")
    source("1_Scripts/05_model_training.R")
    rmarkdown::render("1_Scripts/06_hyperparameter_tuning.Rmd")
    rmarkdown::render("1_Scripts/07_model_evaluation.Rmd")
    ```
    **Lưu ý:** Việc render các file `.Rmd` sẽ tạo ra các file HTML (hoặc định dạng khác nếu bạn cấu hình) chứa các phân tích và kết quả.

5.  **Xem Kết quả**:
    *   Các biểu đồ EDA được lưu trong `3_Results/eda_plots/`.
    *   Các độ đo hiệu suất mô hình và biểu đồ so sánh (ROC, PR curves) có trong `3_Results/model_performance/`.
    *   Các biểu đồ về độ quan trọng của đặc trưng nằm trong `3_Results/feature_importance/`.
    *   Báo cáo cuối cùng (nếu đã biên dịch từ `.Rmd`) nằm trong `4_Report/DoAn_CreditCard_Report.pdf`.

## Những Phát hiện Chính (Dự kiến)

### Thông tin chi tiết từ Dữ liệu:
*   Bộ dữ liệu thể hiện sự mất cân bằng, với khoảng 22% trường hợp vỡ nợ.
*   Các đặc trưng như `PAY_0` (tình trạng thanh toán gần nhất), `LIMIT_BAL` (hạn mức tín dụng), và `PAY_AMT1` (số tiền thanh toán gần nhất) dự kiến sẽ có ảnh hưởng lớn đến việc dự đoán tình trạng vỡ nợ.
*   Hạn mức tín dụng cao hơn có thể liên quan đến tỷ lệ vỡ nợ thấp hơn, tuy nhiên vẫn có sự chồng chéo đáng kể giữa hai nhóm.
*   Trình độ học vấn và tình trạng hôn nhân có thể cho thấy sự khác biệt trong tỷ lệ vỡ nợ.

### Hiệu suất Mô hình:
*   **XGBoost (đã tinh chỉnh)** thường được kỳ vọng sẽ vượt trội hơn Rừng Ngẫu nhiên và Hồi quy Logistic về AUC-ROC và AUC-PR, đặc biệt quan trọng đối với lớp thiểu số (vỡ nợ).
*   **Rừng Ngẫu nhiên** cung cấp hiệu suất mạnh mẽ và khả năng diễn giải độ quan trọng của đặc trưng tốt.
*   **Hồi quy Logistic** đóng vai trò là một mô hình cơ sở (baseline) vững chắc với các hệ số dễ hiểu, nhưng có thể kém hiệu quả hơn các mô hình phức tạp.

### Ý nghĩa Thực tiễn:
*   Các mô hình này có thể hỗ trợ các tổ chức tài chính trong việc xác định khách hàng có rủi ro cao, từ đó tối ưu hóa việc phân bổ tín dụng và giảm thiểu tổn thất liên quan đến vỡ nợ.
*   Việc tập trung vào chỉ số **Recall** đối với lớp vỡ nợ (default class) giúp đảm bảo giảm thiểu tối đa các trường hợp bỏ sót khách hàng có khả năng vỡ nợ, điều này rất quan trọng đối với việc quản lý rủi ro.

## Hạn chế và Hướng Phát triển Tương lai

### Hạn chế:
*   Bộ dữ liệu này chỉ bao gồm khách hàng Đài Loan trong một khoảng thời gian cụ thể, điều này có thể hạn chế khả năng khái quát hóa của mô hình cho các thị trường hoặc thời điểm khác.
*   Các đặc điểm kinh tế hoặc hành vi bổ sung (ví dụ: chỉ số kinh tế vĩ mô, mô hình chi tiêu chi tiết) có thể cải thiện khả năng dự đoán của mô hình.
*   Kỹ thuật SMOTE, mặc dù hữu ích, có thể tạo ra nhiễu từ dữ liệu tổng hợp, có khả năng ảnh hưởng đến độ bền của mô hình trên dữ liệu thực tế hoàn toàn mới.

### Hướng Phát triển Tương lai:
*   Khám phá các mô hình học sâu (ví dụ: Mạng Nơ-ron) để có khả năng đạt hiệu suất tốt hơn trên tập dữ liệu lớn và phức tạp.
*   Triển khai kỹ thuật điều chỉnh ngưỡng quyết định (threshold tuning) để tối ưu hóa mô hình cho các mục tiêu kinh doanh cụ thể (ví dụ: tối đa hóa Recall trong khi vẫn duy trì Precision ở mức chấp nhận được).
*   Kết hợp các nguồn dữ liệu bên ngoài (ví dụ: các chỉ số kinh tế, thông tin từ các văn phòng tín dụng) để tăng cường khả năng dự đoán.
*   Nghiên cứu và giải quyết các cân nhắc về mặt đạo đức và công bằng trong việc chấm điểm tín dụng, đảm bảo mô hình không phân biệt đối xử với các nhóm nhân khẩu học nhất định.

## Tài liệu Tham khảo
-   **UCI Machine Learning Repository:** [Default of Credit Card Clients Dataset](https://archive.ics.uci.edu/ml/datasets/default+of+credit+card+clients)
-   **Các gói R:** `tidyverse`, `tidymodels`, `randomForest`, `xgboost`, `pROC`, `caret`, `themis`, `vip`, v.v.
-   Tài liệu về tinh chỉnh siêu tham số và đánh giá mô hình từ `tidymodels` và `caret`.
```