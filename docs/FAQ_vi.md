# Câu hỏi thường gặp ❓

### 1、Tại sao lời tôi nói, Tiểu Trí nhận diện ra nhiều tiếng Hàn, tiếng Nhật, tiếng Anh? 🇰🇷

Đề xuất: Kiểm tra xem `models/SenseVoiceSmall` đã có file `model.pt` chưa, nếu chưa có thì cần tải xuống, xem tại đây [Tải file mô hình nhận diện giọng nói](Deployment.md#file-mô-hình)

### 2、Tại sao xuất hiện "TTS nhiệm vụ lỗi file không tồn tại"? 📁

Đề xuất: Kiểm tra xem đã cài đặt đúng thư viện `libopus` và `ffmpeg` bằng `conda` chưa.

Nếu chưa cài đặt, hãy cài đặt

```
conda install conda-forge::libopus
conda install conda-forge::ffmpeg
```

### 3、TTS thường xuyên thất bại, thường xuyên quá thời gian ⏰

Đề xuất: Nếu `EdgeTTS` thường xuyên thất bại, trước tiên hãy kiểm tra xem có sử dụng proxy (thang) không. Nếu có sử dụng, hãy thử tắt proxy rồi thử lại;  
Nếu sử dụng TTS Đậu Báo của Huoshan Engine, khi thường xuyên thất bại nên sử dụng phiên bản trả phí, vì phiên bản thử nghiệm chỉ hỗ trợ 2 kết nối đồng thời.

### 4、Sử dụng Wifi có thể kết nối máy chủ tự xây dựng, nhưng chế độ 4G lại không kết nối được 🔐

Nguyên nhân: Firmware của Hà Cá, chế độ 4G cần sử dụng kết nối an toàn.

Giải pháp: Hiện có hai phương pháp có thể giải quyết. Chọn một:

1、Sửa mã. Tham khảo video này để giải quyết https://www.bilibili.com/video/BV18MfTYoE85

2、Sử dụng nginx cấu hình chứng chỉ ssl. Tham khảo hướng dẫn https://icnt94i5ctj4.feishu.cn/docx/GnYOdMNJOoRCljx1ctecsj9cnRe

### 5、Làm thế nào để tăng tốc độ phản hồi đối thoại của Tiểu Trí? ⚡

Dự án này cấu hình mặc định là giải pháp chi phí thấp, đề xuất người mới bắt đầu sử dụng mô hình miễn phí mặc định trước, giải quyết vấn đề "chạy được", sau đó tối ưu "chạy nhanh".  
Nếu cần nâng cao tốc độ phản hồi, có thể thử thay đổi các thành phần. Từ phiên bản `0.5.2`, dự án hỗ trợ cấu hình luồng, so với phiên bản cũ, tốc độ phản hồi tăng khoảng `2.5 giây`, cải thiện đáng kể trải nghiệm người dùng.

| Tên module | Cài đặt miễn phí hoàn toàn cho người mới bắt đầu | Cấu hình luồng |
|:---:|:---:|:---:|
| ASR(Nhận diện giọng nói) | FunASR(Cục bộ) | 👍FunASR(Chế độ GPU cục bộ) |
| LLM(Mô hình lớn) | ChatGLMLLM(Zhipu glm-4-flash) | 👍AliLLM(qwen3-235b-a22b-instruct-2507) hoặc 👍DoubaoLLM(doubao-1-5-pro-32k-250115) |
| VLLM(Mô hình lớn thị giác) | ChatGLMVLLM(Zhipu glm-4v-flash) | 👍QwenVLVLLM(Qianwen qwen2.5-vl-3b-instructh) |
| TTS(Tổng hợp giọng nói) | ✅LinkeraiTTS(Lingxi luồng) | 👍HuoshanDoubleStreamTTS(Tổng hợp giọng nói luồng kép Huoshan) hoặc 👍AliyunStreamTTS(Tổng hợp giọng nói luồng Aliyun) |
| Intent(Nhận diện ý định) | function_call(Gọi hàm) | function_call(Gọi hàm) |
| Memory(Chức năng ghi nhớ) | mem_local_short(Ghi nhớ ngắn hạn cục bộ) | mem_local_short(Ghi nhớ ngắn hạn cục bộ) |

Nếu bạn quan tâm đến thời gian tiêu tốn của các thành phần, hãy tham khảo [Báo cáo kiểm tra hiệu suất các thành phần của Tiểu Trí](https://github.com/xinnan-tech/xiaozhi-performance-research), có thể thực tế kiểm tra trong môi trường của bạn theo phương pháp kiểm tra trong báo cáo.

### 6、Tôi nói chuyện rất chậm, khi tạm dừng Tiểu Trí hay cướp lời 🗣️

Đề xuất: Tìm phần sau trong file cấu hình, điều chỉnh giá trị `min_silence_duration_ms` lớn hơn (ví dụ đổi thành `1000`):

```yaml
VAD:
  SileroVAD:
    threshold: 0.5
    model_dir: models/snakers4_silero-vad
    min_silence_duration_ms: 700  # Nếu tạm dừng nói chuyện dài, có thể điều chỉnh giá trị này lớn hơn
```

### 7、Hướng dẫn liên quan đến triển khai
1、[Làm thế nào để triển khai đơn giản nhất](./Deployment.md)<br/>
2、[Làm thế nào để triển khai toàn bộ module](./Deployment_all.md)<br/>
2、[Làm thế nào để triển khai cổng MQTT mở giao thức MQTT+UDP](./mqtt-gateway-integration.md)<br/>
3、[Làm thế nào để tự động kéo mã mới nhất của dự án này và tự động biên dịch và khởi động](./dev-ops-integration.md)<br/>
4、[Làm thế nào để tích hợp với Nginx](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues/791)<br/>

### 8、Hướng dẫn liên quan đến biên dịch firmware
1、[Làm thế nào để tự biên dịch firmware Tiểu Trí](./firmware-build.md)<br/>
2、[Làm thế nào để sửa địa chỉ OTA dựa trên firmware do Hà Cá biên dịch sẵn](./firmware-setting.md)<br/>

### 8、Hướng dẫn liên quan đến mở rộng
1、[Làm thế nào để mở đăng ký bằng số điện thoại cho bảng điều khiển thông minh](./ali-sms-integration.md)<br/>
2、[Làm thế nào để tích hợp HomeAssistant để thực hiện điều khiển nhà thông minh](./homeassistant-integration.md)<br/>
3、[Làm thế nào để mở mô hình thị giác để thực hiện nhận diện vật thể bằng ảnh](./mcp-vision-integration.md)<br/>
4、[Làm thế nào để triển khai điểm truy cập MCP](./mcp-endpoint-enable.md)<br/>
5、[Làm thế nào để kết nối điểm truy cập MCP](./mcp-endpoint-integration.md)<br/>
6、[Làm thế nào để mở nhận diện giọng nói](./voiceprint-integration.md)<br/>
10、[Hướng dẫn cấu hình nguồn plugin tin tức](./newsnow_plugin_config.md)<br/>

### 9、Hướng dẫn liên quan đến nhân bản giọng nói, triển khai giọng nói cục bộ
1、[Làm thế nào để triển khai tích hợp index-tts giọng nói cục bộ](./index-stream-integration.md)<br/>
2、[Làm thế nào để triển khai tích hợp fish-speech giọng nói cục bộ](./fish-speech-integration.md)<br/>
3、[Làm thế nào để triển khai tích hợp PaddleSpeech giọng nói cục bộ](./paddlespeech-deploy.md)<br/>

### 10、Hướng dẫn kiểm tra hiệu suất
1、[Hướng dẫn kiểm tra tốc độ các thành phần](./performance_tester.md)<br/>
2、[Kết quả kiểm tra công khai định kỳ](https://github.com/xinnan-tech/xiaozhi-performance-research)<br/>

### 13、Thêm câu hỏi, có thể liên hệ với chúng tôi để phản hồi 💬

Có thể gửi câu hỏi của bạn tại [issues](https://github.com/xinnan-tech/xiaozhi-esp32-server/issues).
