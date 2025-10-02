# Sơ đồ kiến trúc triển khai
![Tham khảo - Sơ đồ kiến trúc cài đặt toàn bộ module](../docs/images/deploy2.png)

# Phương thức 1: Chạy toàn bộ module bằng Docker

Từ phiên bản `0.8.2` trở đi, Docker image của dự án này chỉ hỗ trợ `kiến trúc x86`. Nếu cần triển khai trên CPU `kiến trúc arm64`, vui lòng tham khảo [hướng dẫn này](docker-build.md) để biên dịch `image arm64` trên máy của bạn.

## 1. Cài đặt Docker

Nếu máy tính của bạn chưa cài đặt Docker, bạn có thể làm theo hướng dẫn tại đây: [Cài đặt Docker](https://www.runoob.com/docker/ubuntu-docker-install.html)

Docker cài đặt toàn bộ module có hai cách, bạn có thể [sử dụng script tự động](./Deployment_all.md#11-懒人脚本) (tác giả [@VanillaNahida](https://github.com/VanillaNahida))  
Script sẽ tự động tải xuống các file và file cấu hình cần thiết, hoặc bạn có thể [triển khai thủ công](./Deployment_all.md#12-手动部署) từ đầu.

### 1.1 Script tự động (Lazy Script)

Triển khai đơn giản, có thể tham khảo [video hướng dẫn](https://www.bilibili.com/video/BV17bbvzHExd/), hướng dẫn văn bản như sau:

> [!NOTE]  
> Hiện tại chỉ hỗ trợ triển khai một lệnh trên Ubuntu server, các hệ thống khác chưa thử nghiệm, có thể gặp một số lỗi lạ

Sử dụng công cụ SSH kết nối đến server, thực thi script sau với quyền root:

```bash
sudo bash -c "$(wget -qO- https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/main/docker-setup.sh)"
```

Script sẽ tự động hoàn thành các thao tác sau:
> 1. Cài đặt Docker
> 2. Cấu hình nguồn image
> 3. Tải xuống/Pull image
> 4. Tải xuống file model nhận dạng giọng nói
> 5. Hướng dẫn cấu hình server

Sau khi thực thi xong và cấu hình đơn giản, tham khảo [4. Chạy chương trình](#4-chạy-chương-trình) và [5. Khởi động lại xiaozhi-esp32-server](#5khởi-động-lại-xiaozhi-esp32-server) về 3 việc quan trọng nhất cần làm, hoàn thành 3 cấu hình này là có thể sử dụng.

### 1.2 Triển khai thủ công

#### 1.2.1 Tạo thư mục

Sau khi cài đặt xong, bạn cần tìm một thư mục để đặt các file cấu hình cho dự án này, ví dụ chúng ta có thể tạo một thư mục mới tên là `xiaozhi-server`.

Sau khi tạo thư mục, bạn cần tạo thư mục `data` và thư mục `models` bên trong `xiaozhi-server`, trong `models` còn cần tạo thêm thư mục `SenseVoiceSmall`.

Cấu trúc thư mục cuối cùng như sau:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.2.2 Tải xuống file model nhận dạng giọng nói

Model nhận dạng giọng nói của dự án này mặc định sử dụng model `SenseVoiceSmall` để chuyển giọng nói thành văn bản. Do model khá lớn nên cần tải xuống riêng, sau khi tải xong đặt file `model.pt` vào thư mục `models/SenseVoiceSmall`. Chọn một trong hai đường link tải xuống dưới đây:

- Đường link 1: Tải từ Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Đường link 2: Tải từ Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) Mã: `qvna`

#### 1.2.3 Tải xuống file cấu hình

Bạn cần tải xuống hai file cấu hình: `docker-compose_all.yaml` và `config_from_api.yaml`. Cần tải từ repository của dự án.

##### 1.2.3.1 Tải docker-compose_all.yaml

Dùng trình duyệt mở [link này](../main/xiaozhi-server/docker-compose_all.yml).

Ở phía bên phải trang, tìm nút có tên `RAW`, bên cạnh nút `RAW`, tìm biểu tượng tải xuống, click vào nút tải xuống để tải file `docker-compose_all.yml`. Đặt file vào thư mục `xiaozhi-server` của bạn.

Hoặc thực thi trực tiếp lệnh sau để tải xuống:
```bash
wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/docker-compose_all.yml
```

Sau khi tải xong, quay lại hướng dẫn này và tiếp tục.

##### 1.2.3.2 Tải config_from_api.yaml

Dùng trình duyệt mở [link này](../main/xiaozhi-server/config_from_api.yaml).

Ở phía bên phải trang, tìm nút có tên `RAW`, bên cạnh nút `RAW`, tìm biểu tượng tải xuống, click vào nút tải xuống để tải file `config_from_api.yaml`. Đặt file vào thư mục `data` bên trong `xiaozhi-server`, sau đó đổi tên file `config_from_api.yaml` thành `.config.yaml`.

Hoặc thực thi trực tiếp lệnh sau để tải và lưu:
```bash
wget https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/config_from_api.yaml
```

Sau khi tải xong file cấu hình, chúng ta xác nhận lại toàn bộ file trong `xiaozhi-server` như sau:

```
xiaozhi-server
  ├─ docker-compose_all.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

Nếu cấu trúc thư mục file của bạn giống như trên, hãy tiếp tục. Nếu không, hãy xem lại xem có bỏ sót thao tác nào không.

## 2. Sao lưu dữ liệu

Nếu trước đó bạn đã chạy thành công Smart Control Console, nếu trên đó có lưu thông tin khóa API của bạn, vui lòng sao chép các dữ liệu quan trọng từ Smart Control Console trước. Vì trong quá trình nâng cấp, có thể ghi đè lên dữ liệu cũ.

## 3. Xóa các image và container phiên bản cũ

Tiếp theo mở công cụ dòng lệnh, sử dụng `Terminal` hoặc `Command Line` để vào thư mục `xiaozhi-server` của bạn, thực thi các lệnh sau:

```bash
docker compose -f docker-compose_all.yml down

docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server

docker stop xiaozhi-esp32-server-web
docker rm xiaozhi-esp32-server-web

docker stop xiaozhi-esp32-server-db
docker rm xiaozhi-esp32-server-db

docker stop xiaozhi-esp32-server-redis
docker rm xiaozhi-esp32-server-redis

docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest
```

## 4. Chạy chương trình

Thực thi lệnh sau để khởi động container phiên bản mới:

```bash
docker compose -f docker-compose_all.yml up -d
```

Sau khi thực thi xong, thực thi lệnh sau để xem thông tin log:

```bash
docker logs -f xiaozhi-esp32-server-web
```

Khi bạn thấy log xuất ra, nghĩa là `Smart Control Console` của bạn đã khởi động thành công:

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

Lưu ý: Lúc này chỉ có `Smart Control Console` có thể chạy, nếu port 8000 `xiaozhi-esp32-server` báo lỗi, tạm thời đừng quan tâm.

Lúc này, bạn cần dùng trình duyệt mở `Smart Control Console`, link: http://127.0.0.1:8002, đăng ký người dùng đầu tiên. Người dùng đầu tiên chính là Super Admin, các người dùng sau đó đều là người dùng thường. Người dùng thường chỉ có thể bind thiết bị và cấu hình agent; Super Admin có thể quản lý model, quản lý người dùng, cấu hình tham số, v.v.

Tiếp theo cần làm ba việc quan trọng:

### Việc quan trọng thứ nhất

Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm dữ liệu đầu tiên trong danh sách, mã tham số là `server.secret`, copy giá trị `Giá trị tham số` của nó.

Cần giải thích về `server.secret`, `Giá trị tham số` này rất quan trọng, vai trò là để đầu `Server` của chúng ta kết nối với `manager-api`. `server.secret` là khóa bí mật được tạo ngẫu nhiên mỗi khi triển khai module manager từ đầu.

Sau khi copy `Giá trị tham số`, mở file `.config.yaml` trong thư mục `data` của `xiaozhi-server`. Lúc này nội dung file cấu hình của bạn sẽ như thế này:

```yaml
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: gia-tri-server.secret-cua-ban
```

1. Copy `Giá trị tham số` của `server.secret` vừa copy từ `Smart Control Console` vào `secret` trong file `.config.yaml`.

Kết quả tương tự như sau:

```yaml
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

## 9. Chạy dự án

```bash
# Đảm bảo thực thi trong thư mục xiaozhi-server
conda activate xiaozhi-esp32-server
python app.py
```

Nếu bạn thấy log tương tự như sau, đây là dấu hiệu service của dự án khởi động thành công:

```
25-02-23 12:01:09[core.websocket_server] - INFO - Server đang chạy tại ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======Địa chỉ trên là địa chỉ giao thức websocket, vui lòng không truy cập bằng trình duyệt=======
25-02-23 12:01:09[core.websocket_server] - INFO - Nếu muốn test websocket hãy dùng Chrome mở test_page.html trong thư mục test
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Do bạn triển khai toàn bộ module, nên bạn có hai interface quan trọng:

**Interface OTA:**
```
http://ip-lan-cua-may-tinh:8002/xiaozhi/ota/
```

**Interface Websocket:**
```
ws://ip-lan-cua-may-tinh:8000/xiaozhi/v1/
```

Bạn nhất định phải ghi hai địa chỉ interface trên vào Smart Control Console: Chúng sẽ ảnh hưởng đến việc cấp phát địa chỉ websocket và chức năng tự động nâng cấp.

1. Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm mã tham số `server.websocket`, nhập `Interface Websocket` của bạn.

2. Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm mã tham số `server.ota`, nhập `Interface OTA` của bạn.

Tiếp theo, bạn có thể bắt đầu thao tác với thiết bị esp32 của mình, bạn có thể `tự biên dịch firmware esp32` hoặc cấu hình sử dụng `firmware phiên bản 1.6.1 trở lên do anh Xia biên dịch`. Chọn một trong hai:

1. [Biên dịch firmware esp32 của riêng bạn](firmware-build.md).

2. [Cấu hình server tùy chỉnh dựa trên firmware anh Xia đã biên dịch](firmware-setting.md).

---

# Câu hỏi thường gặp

Dưới đây là một số câu hỏi thường gặp, để tham khảo:

1. [Tại sao những gì tôi nói, Xiaozhi nhận dạng ra nhiều tiếng Hàn, tiếng Nhật, tiếng Anh?](./FAQ.md)
2. [Tại sao xuất hiện lỗi "TTS task error - File không tồn tại"?](./FAQ.md)
3. [TTS thường xuyên thất bại, thường xuyên timeout](./FAQ.md)
4. [Dùng Wifi có thể kết nối server tự dựng, nhưng chế độ 4G lại không kết nối được](./FAQ.md)
5. [Làm thế nào để tăng tốc độ phản hồi đối thoại của Xiaozhi?](./FAQ.md)
6. [Tôi nói chậm, khi dừng lại Xiaozhi hay tranh lấy lời](./FAQ.md)

## Hướng dẫn liên quan đến triển khai

1. [Làm thế nào để tự động pull code mới nhất của dự án, tự động biên dịch và khởi động](./dev-ops-integration.md)
2. [Làm thế nào để tích hợp với Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)

## Hướng dẫn mở rộng

1. [Làm thế nào để bật đăng ký Smart Control Console bằng số điện thoại](./ali-sms-integration.md)
2. [Làm thế nào để tích hợp HomeAssistant thực hiện điều khiển smart home](./homeassistant-integration.md)
3. [Làm thế nào để bật model thị giác thực hiện chụp ảnh nhận dạng vật thể](./mcp-vision-integration.md)
4. [Làm thế nào để triển khai điểm truy cập MCP](./mcp-endpoint-enable.md)
5. [Làm thế nào để kết nối điểm truy cập MCP](./mcp-endpoint-integration.md)
6. [Làm thế nào để bật nhận dạng vân giọng nói](./voiceprint-integration.md)
7. [Hướng dẫn cấu hình nguồn plugin tin tức](./newsnow_plugin_config.md)
8. [Hướng dẫn sử dụng plugin thời tiết](./weather-integration.md)

## Hướng dẫn liên quan đến nhân bản giọng nói, triển khai giọng nói local

1. [Làm thế nào để triển khai tích hợp giọng nói local index-tts](./index-stream-integration.md)
2. [Làm thế nào để triển khai tích hợp giọng nói local fish-speech](./fish-speech-integration.md)
3. [Làm thế nào để triển khai tích hợp giọng nói local PaddleSpeech](./paddlespeech-deploy.md)

## Hướng dẫn kiểm tra hiệu năng

1. [Hướng dẫn kiểm tra tốc độ các thành phần](./performance_tester.md)
2. [Kết quả kiểm tra công khai định kỳ](https://github.com/xinnan-tech/xiaozhi-performance-research)

---

# Tổng kết

## So sánh hai phương thức triển khai

| Tiêu chí | Docker (Phương thức 1) | Source Code Local (Phương thức 2) |
|----------|------------------------|-------------------------------------|
| **Độ phức tạp** | ⭐⭐ Thấp | ⭐⭐⭐⭐ Cao |
| **Thời gian setup** | ~15-30 phút | ~1-2 giờ |
| **Yêu cầu kiến thức** | Docker cơ bản | Python, Java, MySQL, Redis, Node.js |
| **Phù hợp cho** | Production, người dùng cuối | Development, developer |
| **Ưu điểm** | Nhanh, dễ dàng, ít lỗi | Linh hoạt, dễ debug, dễ sửa code |
| **Nhược điểm** | Khó tùy chỉnh code | Phức tạp, dễ lỗi nếu thiếu kinh nghiệm |
| **Khuyến nghị** | ✅ Cho người mới | ✅ Cho developer có kinh nghiệm |

## Checklist triển khai thành công

### Phương thức Docker:
- [ ] Docker đã cài đặt và chạy
- [ ] Đã tạo thư mục `xiaozhi-server` với cấu trúc đúng
- [ ] Đã tải file `model.pt` (1.9GB) vào `models/SenseVoiceSmall/`
- [ ] Đã tải và cấu hình `docker-compose_all.yml`
- [ ] Đã tải và đổi tên `config_from_api.yaml` → `.config.yaml`
- [ ] Đã chạy `docker compose up -d` thành công
- [ ] Web Console khởi động tại http://localhost:8002
- [ ] Đã đăng ký Super Admin (người dùng đầu tiên)
- [ ] Đã copy `server.secret` và cập nhật vào `.config.yaml`
- [ ] Đã cấu hình API key cho LLM (Zhipu AI hoặc khác)
- [ ] Đã restart `xiaozhi-esp32-server` và kiểm tra log
- [ ] Đã cập nhật `server.websocket` và `server.ota` trong Smart Control Console

### Phương thức Source Code:
- [ ] MySQL đã cài đặt và tạo database `xiaozhi_esp32_server`
- [ ] Redis đã cài đặt và chạy
- [ ] JDK 21 đã cài đặt
- [ ] Maven đã cài đặt
- [ ] Node.js đã cài đặt
- [ ] Conda/Anaconda đã cài đặt
- [ ] Đã tạo môi trường conda `xiaozhi-esp32-server`
- [ ] Đã cài đặt `libopus` và `ffmpeg`
- [ ] Đã clone source code
- [ ] Đã cài đặt Python dependencies (`pip install -r requirements.txt`)
- [ ] Đã tải file `model.pt` vào đúng thư mục
- [ ] manager-api (Java) đã chạy thành công
- [ ] manager-web (Vue) đã chạy thành công
- [ ] xiaozhi-server (Python) đã chạy thành công
- [ ] Tất cả 3 service đều chạy đồng thời không lỗi

## Ports quan trọng cần nhớ

| Port | Service | Mô tả |
|------|---------|-------|
| **8000** | xiaozhi-server WebSocket | Kết nối ESP32 devices |
| **8001** | manager-web (dev) | Web Console - Development mode |
| **8002** | manager-api | Backend API & Web Console - Production |
| **8003** | xiaozhi-server HTTP | Visual analysis API |
| **3306** | MySQL | Database |
| **6379** | Redis | Cache |

## Gợi ý troubleshooting nhanh

### Docker không khởi động:
```bash
# Kiem tra Docker service
sudo systemctl status docker
sudo systemctl start docker

# Kiem tra logs
docker logs xiaozhi-esp32-server
docker logs xiaozhi-esp32-server-web
```

### Secret key không khớp:
```bash
# Lay secret tu database
docker exec -it xiaozhi-esp32-server-db mysql -uroot -p123456 \
  -e "USE xiaozhi_esp32_server; SELECT config_value FROM sys_config WHERE config_key='server.secret';"

# Cap nhat vao config
nano data/.config.yaml
```

### Port bị chiếm:
```bash
# Kiem tra port dang su dung
sudo lsof -i :8000
sudo lsof -i :8002

# Dung container cu
docker stop $(docker ps -aq)
```

## Lời khuyên cuối cùng

💡 **Người mới bắt đầu**: Sử dụng **Phương thức 1 - Docker** với script tự động

🔧 **Developer muốn tùy chỉnh**: Sử dụng **Phương thức 2 - Source Code**

🚀 **Production deployment**: Sử dụng **Docker** + cấu hình Nginx reverse proxy

📚 **Học tập và nghiên cứu**: Sử dụng **Source Code** để hiểu rõ kiến trúc hệ thốngSmart Control Console` vào `secret` trong file `.config.yaml`.

2. Vì bạn triển khai bằng Docker, đổi `url` thành `http://xiaozhi-esp32-server-web:8002/xiaozhi`

3. Vì bạn triển khai bằng Docker, đổi `url` thành `http://xiaozhi-esp32-server-web:8002/xiaozhi`

4. Vì bạn triển khai bằng Docker, đổi `url` thành `http://xiaozhi-esp32-server-web:8002/xiaozhi`

Kết quả tương tự như sau:

```yaml
manager-api:
  url: http://xiaozhi-esp32-server-web:8002/xiaozhi
  secret: 12345678-xxxx-xxxx-xxxx-123456789000
```

Sau khi lưu, tiếp tục làm việc quan trọng thứ hai.

### Việc quan trọng thứ hai

Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Cấu hình Model`, sau đó ở thanh bên trái click vào `Mô hình ngôn ngữ lớn`, tìm dữ liệu đầu tiên `智谱AI` (Zhipu AI), click nút `Sửa`,
sau khi hộp thoại sửa hiện ra, điền API key `智谱AI` mà bạn đã đăng ký vào `API密钥`. Sau đó click Lưu.

## 5. Khởi động lại xiaozhi-esp32-server

Tiếp theo mở công cụ dòng lệnh, sử dụng `Terminal` hoặc `Command Line` nhập:

```bash
docker restart xiaozhi-esp32-server
docker logs -f xiaozhi-esp32-server
```

Nếu bạn thấy log tương tự như sau, đây là dấu hiệu Server khởi động thành công:

```
25-02-23 12:01:09[core.websocket_server] - INFO - Địa chỉ Websocket là ws://xxx.xx.xx.xx:8000/xiaozhi/v1/
25-02-23 12:01:09[core.websocket_server] - INFO - =======Địa chỉ trên là địa chỉ giao thức websocket, vui lòng không truy cập bằng trình duyệt=======
25-02-23 12:01:09[core.websocket_server] - INFO - Nếu muốn test websocket hãy dùng Chrome mở test_page.html trong thư mục test
25-02-23 12:01:09[core.websocket_server] - INFO - =======================================================
```

Do bạn triển khai toàn bộ module, nên bạn có hai interface quan trọng cần ghi vào esp32.

Interface OTA:
```
http://ip-lan-cua-may-chu:8002/xiaozhi/ota/
```

Interface Websocket:
```
ws://ip-cua-may-chu:8000/xiaozhi/v1/
```

### Việc quan trọng thứ ba

Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm mã tham số `server.websocket`, nhập `Interface Websocket` của bạn.

Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm mã tham số `server.ota`, nhập `Interface OTA` của bạn.

Tiếp theo, bạn có thể bắt đầu thao tác với thiết bị esp32 của mình, bạn có thể `tự biên dịch firmware esp32` hoặc cấu hình sử dụng `firmware phiên bản 1.6.1 trở lên do anh Xia biên dịch`. Chọn một trong hai:

1. [Biên dịch firmware esp32 của riêng bạn](firmware-build.md).

2. [Cấu hình server tùy chỉnh dựa trên firmware anh Xia đã biên dịch](firmware-setting.md).

---

# Phương thức 2: Chạy source code local - Toàn bộ module

## 1. Cài đặt cơ sở dữ liệu MySQL

Nếu máy đã cài đặt MySQL, có thể trực tiếp tạo database tên `xiaozhi_esp32_server` trong database.

```sql
CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

Nếu chưa có MySQL, bạn có thể cài đặt MySQL qua Docker:

```bash
docker run --name xiaozhi-esp32-server-db \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -p 3306:3306 \
  -e MYSQL_DATABASE=xiaozhi_esp32_server \
  -e MYSQL_INITDB_ARGS="--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci" \
  -e TZ=Asia/Shanghai \
  -d mysql:latest
```

## 2. Cài đặt Redis

Nếu chưa có Redis, bạn có thể cài đặt Redis qua Docker:

```bash
docker run --name xiaozhi-esp32-server-redis -d -p 6379:6379 redis
```

## 3. Chạy chương trình manager-api

### 3.1 Cài đặt JDK21, thiết lập biến môi trường JDK

### 3.2 Cài đặt Maven, thiết lập biến môi trường Maven

### 3.3 Sử dụng công cụ lập trình VSCode, cài đặt các plugin liên quan đến môi trường Java

### 3.4 Sử dụng VSCode load module manager-api

Trong `src/main/resources/application-dev.yml` cấu hình thông tin kết nối database:

```yaml
spring:
  datasource:
    username: root
    password: 123456
```

Trong `src/main/resources/application-dev.yml` cấu hình thông tin kết nối Redis:

```yaml
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password:
      database: 0
```

### 3.5 Chạy chương trình chính

Dự án này là dự án SpringBoot, cách khởi động:
Mở `Application.java` chạy method `Main` để khởi động

```
Đường dẫn:
src/main/java/xiaozhi/AdminApplication.java
```

Khi bạn thấy log xuất ra, nghĩa là `manager-api` của bạn đã khởi động thành công:

```
2025-xx-xx 22:11:12.445 [main] INFO  c.a.d.s.b.a.DruidDataSourceAutoConfigure - Init DruidDataSource
2025-xx-xx 21:28:53.873 [main] INFO  xiaozhi.AdminApplication - Started AdminApplication in 16.057 seconds (process running for 17.941)
http://localhost:8002/xiaozhi/doc.html
```

## 4. Chạy chương trình manager-web

### 4.1 Cài đặt Node.js

### 4.2 Sử dụng VSCode load module manager-web

Terminal vào thư mục manager-web:

```bash
npm install
```

Sau đó khởi động:

```bash
npm run serve
```

Lưu ý: Nếu interface manager-api của bạn không ở `http://localhost:8002`, vui lòng sửa đường dẫn trong `main/manager-web/.env.development` khi phát triển.

Sau khi chạy thành công, bạn cần dùng trình duyệt mở `Smart Control Console`, link: http://127.0.0.1:8001, đăng ký người dùng đầu tiên. Người dùng đầu tiên chính là Super Admin, các người dùng sau đó đều là người dùng thường. Người dùng thường chỉ có thể bind thiết bị và cấu hình agent; Super Admin có thể quản lý model, quản lý người dùng, cấu hình tham số, v.v.

**Quan trọng:** Sau khi đăng ký thành công, dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Cấu hình Model`, sau đó ở thanh bên trái click vào `Mô hình ngôn ngữ lớn`, tìm dữ liệu đầu tiên `智谱AI`, click nút `Sửa`, sau khi hộp thoại sửa hiện ra, điền API key `智谱AI` mà bạn đã đăng ký vào `API密钥`. Sau đó click Lưu.

**Quan trọng:** Sau khi đăng ký thành công, dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Cấu hình Model`, sau đó ở thanh bên trái click vào `Mô hình ngôn ngữ lớn`, tìm dữ liệu đầu tiên `智谱AI`, click nút `Sửa`, sau khi hộp thoại sửa hiện ra, điền API key `智谱AI` mà bạn đã đăng ký vào `API密钥`. Sau đó click Lưu.

**Quan trọng:** Sau khi đăng ký thành công, dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Cấu hình Model`, sau đó ở thanh bên trái click vào `Mô hình ngôn ngữ lớn`, tìm dữ liệu đầu tiên `智谱AI`, click nút `Sửa`, sau khi hộp thoại sửa hiện ra, điền API key `智谱AI` mà bạn đã đăng ký vào `API密钥`. Sau đó click Lưu.

## 5. Cài đặt môi trường Python

Dự án này sử dụng `conda` quản lý môi trường phụ thuộc. Nếu không tiện cài đặt `conda`, cần cài đặt `libopus` và `ffmpeg` theo hệ điều hành thực tế.
Nếu xác định dùng `conda`, sau khi cài đặt xong, bắt đầu thực thi các lệnh sau.

**Lưu ý quan trọng!** Người dùng Windows có thể cài đặt `Anaconda` để quản lý môi trường. Sau khi cài đặt `Anaconda`, tìm kiếm từ khóa liên quan đến `anaconda` ở `Start`, 
tìm `Anaconda Prompt`, chạy với quyền administrator như hình dưới.

![conda_prompt](./images/conda_env_1.png)

Sau khi chạy, nếu bạn thấy cửa sổ command line phía trước có chữ (base), nghĩa là bạn đã vào được môi trường `conda`. Khi đó bạn có thể thực thi các lệnh sau.

![conda_env](./images/conda_env_2.png)

```bash
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server

# Thêm kênh Tsinghua source
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda install libopus -y
conda install ffmpeg -y
```

Lưu ý: Các lệnh trên không phải thực thi một mạch là thành công, bạn cần thực thi từng bước, sau mỗi bước thực thi xong đều kiểm tra log xuất ra, xem có thành công hay không.

## 6. Cài đặt dependencies của dự án

Trước tiên bạn cần tải source code của dự án, source code có thể tải qua lệnh `git clone`, nếu bạn không quen với lệnh `git clone`.

Bạn có thể dùng trình duyệt mở địa chỉ này: `https://github.com/xinnan-tech/xiaozhi-esp32-server.git`

Sau khi mở, tìm một nút màu xanh trên trang, có ghi chữ `Code`, click vào nó, sau đó bạn sẽ thấy nút `Download ZIP`.

Click vào nó, tải file nén source code của dự án. Sau khi tải về máy, giải nén, lúc này tên của nó có thể là `xiaozhi-esp32-server-main`
bạn cần đổi tên thành `xiaozhi-esp32-server`, trong file này, vào thư mục `main`, rồi vào `xiaozhi-server`, hãy nhớ thư mục `xiaozhi-server` này.

```bash
# Tiếp tục dùng môi trường conda
conda activate xiaozhi-esp32-server

# Vào thư mục gốc của dự án, rồi vào main/xiaozhi-server
cd main/xiaozhi-server

pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip install -r requirements.txt
```

## 7. Tải xuống file model nhận dạng giọng nói

Model nhận dạng giọng nói của dự án này mặc định sử dụng model `SenseVoiceSmall` để chuyển giọng nói thành văn bản. Do model khá lớn nên cần tải xuống riêng, sau khi tải xong đặt file `model.pt` vào thư mục `models/SenseVoiceSmall`. Chọn một trong hai đường link tải xuống dưới đây:

- Đường link 1: Tải từ Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Đường link 2: Tải từ Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) Mã: `qvna`

## 8. Cấu hình file dự án

Dùng tài khoản Super Admin đăng nhập Smart Control Console, ở menu trên cùng tìm `Quản lý tham số`, tìm dữ liệu đầu tiên trong danh sách, mã tham số là `server.secret`, copy `Giá trị tham số` của nó.

Cần giải thích về `server.secret`, `Giá trị tham số` này rất quan trọng, vai trò là để đầu `Server` của chúng ta kết nối với `manager-api`. `server.secret` là khóa bí mật được tạo ngẫu nhiên mỗi khi triển khai module manager từ đầu.

Nếu thư mục `xiaozhi-server` của bạn không có `data`, bạn cần tạo thư mục `data`.
Nếu trong `data` không có file `.config.yaml`, bạn có thể copy file `config_from_api.yaml` trong thư mục `xiaozhi-server` vào `data`, và đổi tên thành `.config.yaml`

Sau khi copy `Giá trị tham số`, mở file `.config.yaml` trong thư mục `data` của `xiaozhi-server`. Lúc này nội dung file cấu hình của bạn sẽ như thế này:

```yaml
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: gia-tri-server.secret-cua-ban
```

Copy `Giá trị tham số` của `server.secret` vừa copy từ `