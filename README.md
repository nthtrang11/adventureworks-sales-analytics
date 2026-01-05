## 📊 Customer Sales Performance Dashboard

**(AdventureWorks – Internet Sales)**

### 🎯 Mục tiêu phân tích

Dashboard được xây dựng nhằm:

* Theo dõi **hiệu quả doanh thu Internet Sales** theo **khách hàng, sản phẩm và thời gian**
* So sánh **Sales thực tế với Budget**
* Hỗ trợ người dùng phân tích linh hoạt theo **năm, tháng, danh mục sản phẩm và địa lý khách hàng**

---

## 🗂️ Mô hình dữ liệu (Star Schema)

Hệ thống sử dụng **mô hình Star Schema**, gồm 1 bảng FACT và 3 bảng DIM:

### 1️⃣ DIM_Customer

Chứa thông tin mô tả khách hàng:

* CustomerKey
* CustomerName
* City
* Country
* Other demographic attributes

👉 Dùng để:

* Phân tích doanh thu theo **khách hàng**
* Lọc dữ liệu theo **thành phố / khu vực**

---

### 2️⃣ DIM_Product

Chứa thông tin sản phẩm:

* ProductKey
* ProductName
* SubCategory
* Category

👉 Dùng để:

* Phân tích **Sales theo Product Name**
* So sánh hiệu suất giữa **Category / SubCategory**

---

### 3️⃣ DIM_Date

Bảng thời gian chuẩn hóa (2024–2026):

* DateKey
* Year
* Month
* MonthName
* Quarter

👉 Dùng cho:

* Slicer **Year / Month**
* Phân tích xu hướng theo thời gian
* Đảm bảo tính nhất quán thời gian giữa Sales và Budget

---

### 4️⃣ FACT_InternetSales

Bảng dữ liệu giao dịch trung tâm:

* OrderDateKey
* CustomerKey
* ProductKey
* SalesAmount
* BudgetAmount

👉 Là nguồn chính cho:

* KPI Sales
* So sánh **Actual vs Budget**
* Tổng hợp doanh thu theo các chiều phân tích

---

## 📈 Nội dung Dashboard

### 🔹 KPI Card – Sales Performance

* Hiển thị **tổng doanh thu**
* So sánh với **Budget**
* Chỉ báo tăng/giảm giúp đánh giá nhanh hiệu quả kinh doanh

---

### 🔹 Sales by Customer

* Bar chart thể hiện **Top Customers theo Sales**
* Giúp xác định nhóm khách hàng mang lại giá trị cao

---

### 🔹 Sales by Product Name

* Phân tích doanh thu theo từng sản phẩm
* Hỗ trợ đánh giá **sản phẩm chủ lực**

---

### 🔹 Sales by Product Category

* Donut chart thể hiện cơ cấu doanh thu theo Category
* Giúp nhìn nhanh tỷ trọng Bikes / Accessories / Clothing

---

### 🔹 Customer × Month Matrix

* Bảng heatmap thể hiện:

  * Doanh thu theo **khách hàng – từng tháng**
  * Màu sắc giúp nhận diện thời điểm mua cao/thấp
* Có tổng doanh thu theo từng khách hàng

---

## 🎛️ Bộ lọc (Slicers)

* Year
* Month
* Customer City
* Category / SubCategory
* Product Name

👉 Cho phép người dùng **drill-down và slice dữ liệu linh hoạt**.

---

## ✨ Giá trị phân tích

Dashboard giúp:

* Hiểu hành vi mua hàng của khách theo thời gian
* Xác định sản phẩm & khách hàng mang lại doanh thu cao
* Theo dõi mức độ đạt Budget
* Hỗ trợ ra quyết định kinh doanh dựa trên dữ liệu

Link dashboard: https://app.powerbi.com/reportEmbed?reportId=879f65ed-889a-41d4-80a0-8a491ba942f9&autoAuth=true&ctid=2a141a9b-4ef4-4094-a1e5-59bf690777c6
