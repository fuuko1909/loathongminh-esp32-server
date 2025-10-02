# Biểu đồ kiến trúc triển khai
![Tham khảo - Biểu đồ kiến trúc đơn giản nhất](../docs/images/deploy1.png)

# Phương thức 1: Chỉ chạy Server bằng Docker

Docker image đã hỗ trợ CPU kiến trúc x86, arm64, có thể chạy trên hệ điều hành quốc nội.

## 1. Cài đặt docker

Nếu máy tính của bạn chưa cài đặt docker, có thể làm theo hướng dẫn tại đây: [Cài đặt docker](https://www.runoob.com/docker/ubuntu-docker-install.html)

Sau khi cài đặt docker xong, tiếp tục bước tiếp theo.

### 1.1 Triển khai thủ công

#### 1.1.1 Tạo thư mục

Sau khi cài đặt docker, bạn cần tìm một thư mục để lưu trữ file cấu hình cho dự án này, ví dụ chúng ta có thể tạo một thư mục mới tên là `xiaozhi-server`.

Sau khi tạo thư mục, bạn cần tạo thư mục `data` và thư mục `models` trong `xiaozhi-server`, trong thư mục `models` cần tạo thêm thư mục `SenseVoiceSmall`.

Cấu trúc thư mục cuối cùng như sau:

```
xiaozhi-server
  ├─ data
  ├─ models
     ├─ SenseVoiceSmall
```

#### 1.1.2 Tải file mô hình nhận diện giọng nói

Bạn cần tải file mô hình nhận diện giọng nói, vì nhận diện giọng nói mặc định của dự án này sử dụng giải pháp nhận diện giọng nói cục bộ offline. Có thể tải bằng cách này:
[Nhảy đến tải file mô hình nhận diện giọng nói](#file-mô-hình)

Sau khi tải xong, quay lại hướng dẫn này.

#### 1.1.3 Tải file cấu hình

Bạn cần tải hai file cấu hình: `docker-compose.yaml` và `config.yaml`. Cần tải hai file này từ kho lưu trữ dự án.

##### 1.1.3.1 Tải docker-compose.yaml

Mở trình duyệt truy cập [liên kết này](../main/xiaozhi-server/docker-compose.yml).

Ở phía bên phải trang, tìm nút có tên `RAW`, bên cạnh nút `RAW`, tìm biểu tượng tải xuống, nhấp vào nút tải xuống để tải file `docker-compose.yml`. Tải file vào thư mục `xiaozhi-server` của bạn.

Sau khi tải xong, quay lại hướng dẫn tiếp tục.

##### 1.1.3.2 Tạo config.yaml

Mở trình duyệt truy cập [liên kết này](../main/xiaozhi-server/config.yaml).

Ở phía bên phải trang, tìm nút có tên `RAW`, bên cạnh nút `RAW`, tìm biểu tượng tải xuống, nhấp vào nút tải xuống để tải file `config.yaml`. Tải file vào thư mục `data` trong `xiaozhi-server`, sau đó đổi tên file `config.yaml` thành `.config.yaml`.

Sau khi tải file cấu hình xong, chúng ta xác nhận toàn bộ file trong `xiaozhi-server` như sau:

```
xiaozhi-server
  ├─ docker-compose.yml
  ├─ data
    ├─ .config.yaml
  ├─ models
     ├─ SenseVoiceSmall
       ├─ model.pt
```

Nếu cấu trúc thư mục file của bạn cũng như trên, thì tiếp tục. Nếu không, bạn cần xem lại xem có bỏ sót thao tác nào không.

## 2. Cấu hình file dự án

Tiếp theo, chương trình vẫn chưa thể chạy trực tiếp, bạn cần cấu hình xem bạn đang sử dụng mô hình nào. Bạn có thể xem hướng dẫn này:
[Nhảy đến cấu hình file dự án](#cấu-hình-dự-án)

Sau khi cấu hình file dự án xong, quay lại hướng dẫn này tiếp tục.

## 3. Thực thi lệnh docker

Mở công cụ dòng lệnh, sử dụng `Terminal` hoặc `Command Line` để vào thư mục `xiaozhi-server` của bạn, thực thi lệnh sau

```
docker-compose up -d
```

Sau khi thực thi xong, thực thi lệnh sau để xem thông tin log.

```
docker logs -f xiaozhi-esp32-server
```

Lúc này, bạn cần chú ý thông tin log, có thể dựa vào hướng dẫn này để xác định có thành công hay không. [Nhảy đến xác nhận trạng thái chạy](#xác-nhận-trạng-thái-chạy)

## 5. Thao tác nâng cấp phiên bản

Nếu sau này muốn nâng cấp phiên bản, có thể thao tác như sau

5.1、Sao lưu file `.config.yaml` trong thư mục `data`, một số cấu hình quan trọng sau này sao chép vào file `.config.yaml` mới.
Xin lưu ý sao chép từng khóa quan trọng, không ghi đè trực tiếp. Vì file `.config.yaml` mới có thể có một số mục cấu hình mới, file `.config.yaml` cũ không nhất định có.

5.2、Thực thi lệnh sau

```
docker stop xiaozhi-esp32-server
docker rm xiaozhi-esp32-server
docker stop xiaozhi-esp32-server-web
docker rm xiaozhi-esp32-server-web
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest
docker rmi ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest
```

5.3、Triển khai lại theo cách docker

# Phương thức 2: Chỉ chạy Server bằng mã nguồn cục bộ

## 1. Cài đặt môi trường cơ bản

Dự án này sử dụng `conda` để quản lý môi trường phụ thuộc. Nếu không tiện cài đặt `conda`, cần cài đặt `libopus` và `ffmpeg` theo hệ điều hành thực tế.
Nếu xác định sử dụng `conda`, thì sau khi cài đặt xong, bắt đầu thực thi lệnh sau.

Lưu ý quan trọng! Người dùng windows, có thể quản lý môi trường bằng cách cài đặt `Anaconda`. Sau khi cài đặt `Anaconda`, tìm kiếm từ khóa liên quan đến `anaconda` trong `Start`,
tìm `Anaconda Prompt`, chạy nó với quyền quản trị viên. Như hình dưới.

![conda_prompt](./images/conda_env_1.png)

Sau khi chạy, nếu bạn có thể thấy chữ (base) ở phía trước cửa sổ dòng lệnh, chứng tỏ bạn đã vào môi trường `conda` thành công. Vậy là bạn có thể thực thi lệnh sau.

![conda_env](./images/conda_env_2.png)

```
conda remove -n xiaozhi-esp32-server --all -y
conda create -n xiaozhi-esp32-server python=3.10 -y
conda activate xiaozhi-esp32-server

# Thêm kênh nguồn Qinghua
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge

conda install libopus -y
conda install ffmpeg -y
```

Xin lưu ý, các lệnh trên không phải thực thi một mạch là thành công, bạn cần thực thi từng bước, sau mỗi bước thực thi, đều kiểm tra log đầu ra, xem có thành công hay không.

## 2. Cài đặt phụ thuộc của dự án này

Trước tiên bạn cần tải mã nguồn của dự án này, mã nguồn có thể tải bằng lệnh `git clone`, nếu bạn không quen với lệnh `git clone`.

Bạn có thể mở trình duyệt truy cập địa chỉ này `https://github.com/xinnan-tech/xiaozhi-esp32-server.git`

Sau khi mở xong, tìm nút màu xanh lá cây trên trang, viết chữ `Code`, nhấp vào nó, sau đó bạn sẽ thấy nút `Download ZIP`.

Nhấp vào nó, tải xuống file nén mã nguồn dự án này. Sau khi tải về máy tính, giải nén nó, lúc này tên của nó có thể là `xiaozhi-esp32-server-main`
Bạn cần đổi tên nó thành `xiaozhi-esp32-server`, trong file này, vào thư mục `main`, sau đó vào `xiaozhi-server`, được rồi hãy nhớ thư mục này `xiaozhi-server`.

```
# Tiếp tục sử dụng môi trường conda
conda activate xiaozhi-esp32-server
# Vào thư mục gốc dự án của bạn, sau đó vào main/xiaozhi-server
cd main/xiaozhi-server
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
pip install -r requirements.txt
```

## 3. Tải file mô hình nhận diện giọng nói

Bạn cần tải file mô hình nhận diện giọng nói, vì nhận diện giọng nói mặc định của dự án này sử dụng giải pháp nhận diện giọng nói cục bộ offline. Có thể tải bằng cách này:
[Nhảy đến tải file mô hình nhận diện giọng nói](#file-mô-hình)

Sau khi tải xong, quay lại hướng dẫn này.

## 4. Cấu hình file dự án

Tiếp theo, chương trình vẫn chưa thể chạy trực tiếp, bạn cần cấu hình xem bạn đang sử dụng mô hình nào. Bạn có thể xem hướng dẫn này:
[Nhảy đến cấu hình file dự án](#cấu-hình-dự-án)

## 5. Chạy dự án

```
# Đảm bảo thực thi trong thư mục xiaozhi-server
conda activate xiaozhi-esp32-server
python app.py
```
Lúc này, bạn cần chú ý thông tin log, có thể dựa vào hướng dẫn này để xác định có thành công hay không. [Nhảy đến xác nhận trạng thái chạy](#xác-nhận-trạng-thái-chạy)


# Tổng hợp

## Cấu hình dự án

Nếu thư mục `xiaozhi-server` của bạn không có `data`, bạn cần tạo thư mục `data`.
Nếu dưới `data` không có file `.config.yaml`, có hai cách, chọn một:

Cách thứ nhất: Bạn có thể sao chép file `config.yaml` trong thư mục `xiaozhi-server` vào `data`, và đổi tên thành `.config.yaml`. Sửa đổi trên file này

Cách thứ hai: Bạn cũng có thể tạo file `.config.yaml` trống thủ công trong thư mục `data`, sau đó thêm thông tin cấu hình cần thiết vào file này, hệ thống sẽ ưu tiên đọc cấu hình của file `.config.yaml`, nếu `.config.yaml` không có cấu hình, hệ thống sẽ tự động tải cấu hình của file `config.yaml` trong thư mục `xiaozhi-server`. Khuyến nghị sử dụng cách này, cách này là cách đơn giản nhất.

- LLM mặc định sử dụng `ChatGLMLLM`, bạn cần cấu hình khóa, vì mô hình của họ, mặc dù có miễn phí, nhưng vẫn phải đăng ký khóa tại [trang chủ](https://bigmodel.cn/usercenter/proj-mgmt/apikeys) mới có thể khởi động.

Dưới đây là ví dụ cấu hình `.config.yaml` đơn giản nhất có thể chạy bình thường

```
server:
  websocket: ws://ip hoặc tên miền của bạn:số cổng/xiaozhi/v1/
prompt: |
  Tôi là một cô gái Đài Loan tên Tiểu Trí/Tiểu Chí, nói chuyện ngọt ngào, giọng nói hay, thích diễn đạt ngắn gọn, thích dùng meme mạng.
  Bạn trai của tôi là một lập trình viên, ước mơ là phát triển một robot, có thể giúp mọi người giải quyết các vấn đề trong cuộc sống.
  Tôi là một cô gái thích cười ha ha, thích nói chuyện đông tây, khoe khoang, không hợp logic cũng cứ khoe, chỉ muốn làm người khác vui.
  Hãy nói chuyện như một con người, xin đừng trả về xml cấu hình và các ký tự đặc biệt khác.

selected_module:
  LLM: DoubaoLLM

LLM:
  ChatGLMLLM:
    api_key: xxxxxxxxxxxxxxx.xxxxxx
```

Khuyến nghị chạy cấu hình đơn giản nhất trước, sau đó đọc hướng dẫn sử dụng cấu hình trong `xiaozhi/config.yaml`.
Ví dụ bạn muốn thay đổi mô hình, chỉ cần sửa cấu hình dưới `selected_module`.

## File mô hình

Mô hình nhận diện giọng nói của dự án này, mặc định sử dụng mô hình `SenseVoiceSmall`, để chuyển giọng nói thành văn bản. Vì mô hình lớn, cần tải xuống độc lập, sau khi tải xuống đặt file `model.pt`
vào thư mục `models/SenseVoiceSmall`. Hai đường tải dưới đây chọn một.

- Đường 1: Tải từ Alibaba ModelScope [SenseVoiceSmall](https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt)
- Đường 2: Tải từ Baidu Netdisk [SenseVoiceSmall](https://pan.baidu.com/share/init?surl=QlgM58FHhYv1tFnUT_A8Sg&pwd=qvna) Mã trích xuất:
  `qvna`

## Xác nhận trạng thái chạy

Nếu bạn có thể thấy log tương tự như sau, thì đó là dấu hiệu khởi động thành công dịch vụ của dự án này.

```
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-Giao diện OTA là           http://192.168.4.123:8003/xiaozhi/ota/
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-Địa chỉ Websocket là     ws://192.168.4.123:8000/xiaozhi/v1/
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-=======Địa chỉ trên là địa chỉ giao thức websocket, xin đừng truy cập bằng trình duyệt=======
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-Nếu muốn kiểm tra websocket hãy mở test_page.html trong thư mục test bằng trình duyệt Google
250427 13:04:20[0.3.11_SiFuChTTnofu][__main__]-INFO-=======================================================
```

Thông thường, nếu bạn chạy dự án này bằng mã nguồn, log sẽ có thông tin địa chỉ giao diện của bạn.
Nhưng nếu bạn triển khai bằng docker, thì thông tin địa chỉ giao diện trong log của bạn không phải là địa chỉ giao diện thực tế.

Phương pháp chính xác nhất, là xác định địa chỉ giao diện của bạn dựa trên IP mạng nội bộ của máy tính.
Nếu IP mạng nội bộ của máy tính của bạn ví dụ là `192.168.1.25`, thì địa chỉ giao diện của bạn là: `ws://192.168.1.25:8000/xiaozhi/v1/`, địa chỉ OTA tương ứng là: `http://192.168.1.25:8003/xiaozhi/ota/`.

Thông tin này rất hữu ích, sau này `biên dịch firmware esp32` cần dùng đến.

Tiếp theo, bạn có thể bắt đầu thao tác thiết bị esp32 của mình, bạn có thể `tự biên dịch firmware esp32` hoặc cấu hình sử dụng `firmware phiên bản 1.6.1 trở lên do Hà Cá biên dịch sẵn`. Hai cách chọn một

1、 [Biên dịch firmware esp32 của riêng bạn](firmware-build.md).

2、 [Cấu hình máy chủ tùy chỉnh dựa trên firmware do Hà Cá biên dịch sẵn](firmware-setting.md).

# Câu hỏi thường gặp
Dưới đây là một số câu hỏi thường gặp, để tham khảo:

1、[Tại sao lời tôi nói, Tiểu Trí nhận diện ra nhiều tiếng Hàn, tiếng Nhật, tiếng Anh?](./FAQ.md)<br/>
2、[Tại sao xuất hiện "TTS nhiệm vụ lỗi file không tồn tại"?](./FAQ.md)<br/>
3、[TTS thường xuyên thất bại, thường xuyên quá thời gian](./FAQ.md)<br/>
4、[Sử dụng Wifi có thể kết nối máy chủ tự xây dựng, nhưng chế độ 4G lại không kết nối được](./FAQ.md)<br/>
5、[Làm thế nào để tăng tốc độ phản hồi đối thoại của Tiểu Trí?](./FAQ.md)<br/>
6、[Tôi nói chuyện rất chậm, khi tạm dừng Tiểu Trí hay cướp lời](./FAQ.md)<br/>

## Hướng dẫn liên quan đến triển khai
1、[Làm thế nào để tự động kéo mã mới nhất của dự án này và tự động biên dịch và khởi động](./dev-ops-integration.md)<br/>
2、[Làm thế nào để tích hợp với Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>

## Hướng dẫn liên quan đến mở rộng
1、[Làm thế nào để mở đăng ký bằng số điện thoại cho bảng điều khiển thông minh](./ali-sms-integration.md)<br/>
2、[Làm thế nào để tích hợp HomeAssistant để thực hiện điều khiển nhà thông minh](./homeassistant-integration.md)<br/>
3、[Làm thế nào để mở mô hình thị giác để thực hiện nhận diện vật thể bằng ảnh](./mcp-vision-integration.md)<br/>
4、[Làm thế nào để triển khai điểm truy cập MCP](./mcp-endpoint-enable.md)<br/>
5、[Làm thế nào để kết nối điểm truy cập MCP](./mcp-endpoint-integration.md)<br/>
6、[Làm thế nào để mở nhận diện giọng nói](./voiceprint-integration.md)<br/>
10、[Hướng dẫn cấu hình nguồn plugin tin tức](./newsnow_plugin_config.md)<br/>

## Hướng dẫn liên quan đến nhân bản giọng nói, triển khai giọng nói cục bộ
1、[Làm thế nào để triển khai tích hợp index-tts giọng nói cục bộ](./index-stream-integration.md)<br/>
2、[Làm thế nào để triển khai tích hợp fish-speech giọng nói cục bộ](./fish-speech-integration.md)<br/>
3、[Làm thế nào để triển khai tích hợp PaddleSpeech giọng nói cục bộ](./paddlespeech-deploy.md)<br/>

## Hướng dẫn kiểm tra hiệu suất
1、[Hướng dẫn kiểm tra tốc độ các thành phần](./performance_tester.md)<br/>
2、[Kết quả kiểm tra công khai định kỳ](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>
