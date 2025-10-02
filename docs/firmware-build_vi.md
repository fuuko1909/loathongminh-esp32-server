# Biên dịch firmware esp32

## Bước 1 Chuẩn bị địa chỉ ota của bạn

Nếu bạn sử dụng phiên bản 0.3.12 của dự án này, dù là triển khai Server đơn giản hay triển khai toàn bộ module, đều sẽ có địa chỉ ota.

Do cách thiết lập địa chỉ OTA của triển khai Server đơn giản và triển khai toàn bộ module khác nhau, xin bạn chọn cách cụ thể dưới đây:

### Nếu bạn dùng triển khai Server đơn giản
Lúc này, xin bạn mở trình duyệt truy cập địa chỉ ota của bạn, ví dụ địa chỉ ota của tôi
```
http://192.168.1.25:8003/xiaozhi/ota/
```
Nếu hiển thị "Giao diện OTA chạy bình thường, địa chỉ websocket gửi đến thiết bị là: ws://xxx:8000/xiaozhi/v1/

Bạn có thể sử dụng `test_page.html` đi kèm dự án để kiểm tra xem có thể kết nối với địa chỉ websocket mà trang ota xuất ra không.

Nếu không truy cập được, bạn cần sửa địa chỉ `server.websocket` trong file cấu hình `.config.yaml`, khởi động lại rồi kiểm tra lại, cho đến khi `test_page.html` có thể truy cập bình thường.

Sau khi thành công, xin tiếp tục bước 2

### Nếu bạn dùng triển khai toàn bộ module
Lúc này, xin bạn mở trình duyệt truy cập địa chỉ ota của bạn, ví dụ địa chỉ ota của tôi
```
http://192.168.1.25:8002/xiaozhi/ota/
```

Nếu hiển thị "Giao diện OTA chạy bình thường, số lượng cụm websocket: X". Vậy thì tiếp tục bước 2.

Nếu hiển thị "Giao diện OTA chạy không bình thường", có lẽ là bạn chưa cấu hình địa chỉ `Websocket` trong `Bảng điều khiển thông minh`. Vậy thì:

- 1、Sử dụng quản trị viên siêu cấp đăng nhập bảng điều khiển thông minh

- 2、Nhấp vào `Quản lý tham số` trong menu trên cùng

- 3、Tìm mục `server.websocket` trong danh sách, nhập địa chỉ `Websocket` của bạn. Ví dụ của tôi là

```
ws://192.168.1.25:8000/xiaozhi/v1/
```

Sau khi cấu hình xong, sử dụng trình duyệt làm mới địa chỉ giao diện ota của bạn, xem có bình thường chưa. Nếu vẫn không bình thường, hãy xác nhận lại xem Websocket có khởi động bình thường không, có cấu hình địa chỉ Websocket không.

## Bước 2 Cấu hình môi trường
Trước tiên cấu hình môi trường dự án theo hướng dẫn này [《Windows thiết lập môi trường phát triển ESP IDF 5.3.2 và biên dịch Tiểu Trí》](https://icnynnzcwou8.feishu.cn/wiki/JEYDwTTALi5s2zkGlFGcDiRknXf)

## Bước 3 Mở file cấu hình
Sau khi cấu hình môi trường biên dịch xong, tải mã nguồn dự án xiaozhi-esp32 của Hà Cá,

Tải từ đây mã nguồn dự án [xiaozhi-esp32 của Hà Cá](https://github.com/78/xiaozhi-esp32).

Sau khi tải xong, mở file `xiaozhi-esp32/main/Kconfig.projbuild`.

## Bước 4 Sửa địa chỉ OTA

Tìm nội dung `default` của `OTA_URL`, sửa `https://api.tenclass.net/xiaozhi/ota/`
   thành địa chỉ của bạn, ví dụ, địa chỉ giao diện của tôi là `http://192.168.1.25:8002/xiaozhi/ota/`, thì sửa nội dung thành cái này.

Trước khi sửa:
```
config OTA_URL
    string "Default OTA URL"
    default "https://api.tenclass.net/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```
Sau khi sửa:
```
config OTA_URL
    string "Default OTA URL"
    default "http://192.168.1.25:8002/xiaozhi/ota/"
    help
        The application will access this URL to check for new firmwares and server address.
```

## Bước 4 Thiết lập tham số biên dịch

Thiết lập tham số biên dịch

```
# Dòng lệnh terminal vào thư mục gốc xiaozhi-esp32
cd xiaozhi-esp32
# Ví dụ tôi sử dụng board là esp32s3, nên thiết lập mục tiêu biên dịch là esp32s3, nếu board của bạn là model khác, xin thay thế bằng model tương ứng
idf.py set-target esp32s3
# Vào cấu hình menu
idf.py menuconfig
```

Sau khi vào cấu hình menu, vào `Xiaozhi Assistant`, thiết lập `BOARD_TYPE` thành model cụ thể của board bạn
Lưu thoát, quay lại dòng lệnh terminal.

## Bước 5 Biên dịch firmware

```
idf.py build
```

## Bước 6 Đóng gói firmware bin

```
cd scripts
python release.py
```

Sau khi lệnh đóng gói trên thực thi xong, sẽ tạo file firmware `merged-binary.bin` trong thư mục `build` dưới thư mục gốc dự án.
File `merged-binary.bin` này chính là file firmware cần ghi vào phần cứng.

Lưu ý: Nếu sau khi thực thi lệnh thứ hai, báo lỗi liên quan đến "zip", xin bỏ qua lỗi này, chỉ cần file firmware `merged-binary.bin` được tạo trong thư mục `build`
, không ảnh hưởng quá lớn đến bạn, xin tiếp tục.

## Bước 7 Ghi firmware
   Kết nối thiết bị esp32 với máy tính, sử dụng trình duyệt chrome, mở địa chỉ sau

```
https://espressif.github.io/esp-launchpad/
```

Mở hướng dẫn này, [Công cụ Flash/Ghi firmware từ đầu cuối web (không có môi trường phát triển IDF)](https://ccnphfhqs21z.feishu.cn/wiki/Zpz4wXBtdimBrLk25WdcXzxcnNS).
Lật đến: `Cách hai: ESP-Launchpad ghi từ đầu cuối web trình duyệt`, bắt đầu từ `3. Ghi firmware/Tải xuống board phát triển`, làm theo hướng dẫn.

Sau khi ghi thành công và kết nối mạng thành công, thông qua từ đánh thức đánh thức Tiểu Trí, chú ý thông tin console mà đầu server xuất ra.

## Câu hỏi thường gặp
Dưới đây là một số câu hỏi thường gặp, để tham khảo:

[1、Tại sao lời tôi nói, Tiểu Trí nhận diện ra nhiều tiếng Hàn, tiếng Nhật, tiếng Anh](./FAQ.md)

[2、Tại sao xuất hiện "TTS nhiệm vụ lỗi file không tồn tại"?](./FAQ.md)

[3、TTS thường xuyên thất bại, thường xuyên quá thời gian](./FAQ.md)

[4、Sử dụng Wifi có thể kết nối máy chủ tự xây dựng, nhưng chế độ 4G lại không kết nối được](./FAQ.md)

[5、Làm thế nào để tăng tốc độ phản hồi đối thoại của Tiểu Trí?](./FAQ.md)

[6、Tôi nói chuyện rất chậm, khi tạm dừng Tiểu Trí hay cướp lời](./FAQ.md)

[7、Tôi muốn thông qua Tiểu Trí điều khiển đèn điện, điều hòa, bật tắt máy từ xa và các thao tác khác](./FAQ.md)
