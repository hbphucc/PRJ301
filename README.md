# FashionShop
## Mô tả dự án (Project Overview)
FashionShop là một hệ thống website thương mại điện tử chuyên cung cấp các mặt hàng thời trang nam và nữ. Ứng dụng cung cấp một quy trình mua sắm hoàn chỉnh từ khâu duyệt sản phẩm, thêm vào giỏ hàng, đến khi hoàn tất thanh toán. Song song đó, hệ thống tích hợp một trang quản trị Admin giúp chủ cửa hàng dễ dàng kiểm soát kho hàng, danh mục và theo dõi trạng thái đơn hàng.
## Đối tượng mục tiêu (Target Audience)
- Người tiêu dùng (Users): Khách hàng nam, nữ có nhu cầu mua sắm quần áo trực tuyến, cần một giao diện trực quan, dễ tìm kiếm, dễ lọc sản phẩm (theo size, màu sắc, giá cả) và thanh toán nhanh gọn.
- Người quản lý (Admin): Chủ cửa hàng hoặc nhân viên vận hành cần một công cụ tập trung để thao tác trực tiếp với dữ liệu sản phẩm, doanh thu và xử lý đơn đặt hàng hàng ngày.
## Công nghệ sử dụng (Tech Stack)
- Backend: Java (Servlet & JSP) - Xử lý logic nghiệp vụ và điều hướng luồng dữ liệu.
- Database: SQL (SQL Server) - Quản lý dữ liệu quan hệ (Người dùng, Sản phẩm, Đơn hàng) và sử dụng JDBC để tương tác.
- Frontend: HTML5, CSS3, JavaScript - Xây dựng giao diện tĩnh và xử lý các tương tác người dùng cơ bản phía client.
- Kiến trúc: Mô hình MVC (Model - View - Controller).
- Công cụ & Môi trường: NetBeans / IDE tương đương, Git & GitHub (Quản lý phiên bản), Apache Tomcat (Web Server).
## Về mặt Kỹ thuật (Hard Skills):
- Làm chủ luồng Web: Hiểu sâu sắc cách một request (yêu cầu) đi từ trình duyệt web (Client) xuống server Java, truy vấn SQL và trả về giao diện JSP.
- Quản lý trạng thái (State Management): Biết cách áp dụng Session và Cookie để lưu trữ thông tin giỏ hàng và duy trì trạng thái đăng nhập của người dùng.
- Thiết kế Cơ sở dữ liệu: Nâng cao kỹ năng thiết kế các bảng (Tables) chuẩn hóa và tối ưu hóa các câu lệnh truy vấn SQL có điều kiện phức tạp (như khi làm bộ lọc sản phẩm).
## Về mặt Tư duy (Mindset & Soft Skills):
- Product Mindset (Tư duy làm sản phẩm): Không chỉ viết code cho chạy được, mà còn biết đặt mình vào vị trí của người mua hàng để thiết kế luồng click chuột sao cho mượt mà, ít lỗi nhất.
- System Thinking (Tư duy hệ thống): Nhìn thấy bức tranh tổng thể về cách dữ liệu liên kết với nhau (Ví dụ: Xóa một danh mục thì các sản phẩm thuộc danh mục đó sẽ ra sao?).
- Kỹ năng tự quản lý: Khả năng chia nhỏ một khối lượng công việc khổng lồ thành các module nhỏ (User, Cart, Admin) để giải quyết từng bước mà không bị ngợp.
graph TB
    Browser["🌐 Browser"]

    subgraph WebLayer ["Web Layer"]
        AF["AuthFilter\n(bảo vệ /admin, /cart, /order)"]
        MC["MainController\n(User actions)"]
        AC["AdminController\n(Admin actions)"]
    end

    subgraph JSPViews ["JSP Views"]
        direction TB
        subgraph UserPages ["Trang người dùng"]
            V1["index.jsp"]
            V2["productDetail.jsp"]
            V3["cart.jsp"]
            V4["checkout.jsp"]
            V5["orderHistory.jsp"]
            V6["orderDetail.jsp"]
            V7["profile.jsp"]
            V8["login.jsp / register.jsp"]
        end
        subgraph AdminPages ["Trang admin"]
            A1["dashboard.jsp"]
            A2["productList/Form.jsp"]
            A3["categoryList.jsp"]
            A4["orderList/Detail.jsp"]
            A5["userList.jsp"]
        end
    end

    subgraph DAOLayer ["DAO Layer"]
        D1["ClothesDAO"]
        D2["UserDAO"]
        D3["OrderDAO"]
    end

    subgraph DTOLayer ["DTO Layer"]
        DT1["ClothesDTO"]
        DT2["UserDTO"]
        DT3["OrderDTO"]
        DT4["CartItem"]
        DT5["CategoryDTO"]
        DT6["OrderDetailDTO"]
    end

    DB[("🗄️ SQL Server")]

    Browser --> AF
    AF -->|"role=admin"| AC
    AF -->|"role=customer"| MC
    MC --> V1 & V2 & V3 & V4 & V5 & V6 & V7 & V8
    AC --> A1 & A2 & A3 & A4 & A5
    MC --> D1 & D2 & D3
    AC --> D1 & D2 & D3
    D1 --> DT1 & DT5
    D2 --> DT2
    D3 --> DT3 & DT4 & DT6
    D1 & D2 & D3 --> DB
