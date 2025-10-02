# Hướng dẫn Tiếng Việt - Xiaozhi ESP32 Server

[![Banners](docs/images/banner1.png)](https://github.com/xinnan-tech/xiaozhi-esp32-server)

<h1 align="center">Dịch vụ Backend Xiaozhi ESP32 Server</h1>

<p align="center">
Dự án này dựa trên lý thuyết và công nghệ trí tuệ nhân tạo cộng sinh để phát triển hệ thống phần cứng và phần mềm thiết bị thông minh<br/>Là dự án phần cứng thông minh mã nguồn mở
cung cấp dịch vụ backend cho dự án <a href="https://github.com/78/xiaozhi-esp32">xiaozhi-esp32</a><br/>
Theo <a href="https://ccnphfhqs21z.feishu.cn/wiki/M0XiwldO9iJwHikpXD5cEx71nKh">Giao thức truyền thông Xiaozhi</a> sử dụng Python, Java, Vue để triển khai<br/>
Hỗ trợ giao thức MQTT+UDP, giao thức WebSocket, điểm truy cập MCP, nhận dạng giọng nói
</p>

<p align="center">
<a href="./README_en.md">English</a>
· <a href="./docs/FAQ.md">Câu hỏi thường gặp</a>
· <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/issues">Báo cáo vấn đề</a>
· <a href="./README.md#%E9%83%A8%E7%BD%B2%E6%96%87%E6%A1%A3">Tài liệu triển khai</a>
· <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/releases">Nhật ký cập nhật</a>
</p>
<p align="center">
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/releases">
    <img alt="GitHub Contributors" src="https://img.shields.io/github/v/release/xinnan-tech/xiaozhi-esp32-server?logo=docker" />
  </a>
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/graphs/contributors">
    <img alt="GitHub Contributors" src="https://img.shields.io/github/contributors/xinnan-tech/xiaozhi-esp32-server?logo=github" />
  </a>
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/issues">
    <img alt="Issues" src="https://img.shields.io/github/issues/xinnan-tech/xiaozhi-esp32-server?color=0088ff" />
  </a>
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/pulls">
    <img alt="GitHub pull requests" src="https://img.shields.io/github/issues-pr/xinnan-tech/xiaozhi-esp32-server?color=0088ff" />
  </a>
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/LICENSE">
    <img alt="GitHub pull requests" src="https://img.shields.io/badge/license-MIT-white?labelColor=black" />
  </a>
  <a href="https://github.com/xinnan-tech/xiaozhi-esp32-server">
    <img alt="stars" src="https://img.shields.io/github/stars/xinnan-tech/xiaozhi-esp32-server?color=ffcb47&labelColor=black" />
  </a>
</p>

<p align="center">
Được dẫn dắt bởi nhóm của Giáo sư Siyuan Liu (Đại học Công nghệ Nam Trung Quốc)
</br>
刘思源教授团队主导研发（华南理工大学）
</br>
<img src="./docs/images/hnlg.jpg" alt="华南理工大学" width="50%">
</p>

---

## Đối tượng sử dụng 👥

Dự án này cần sử dụng kết hợp với thiết bị phần cứng ESP32. Nếu bạn đã mua thiết bị phần cứng ESP32 liên quan, đã kết nối thành công với dịch vụ backend do Hà Cá triển khai và muốn tự xây dựng dịch vụ backend `xiaozhi-esp32` của riêng mình, thì dự án này rất phù hợp với bạn.

Muốn xem hiệu quả sử dụng? Hãy xem video 🎥

<table>
  <tr>
    <td>
        <a href="https://www.bilibili.com/video/BV1C1tCzUEZh" target="_blank">
         <picture>
           <img alt="小智医疗救护车场景" src="docs/images/demo1.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1zUW5zJEkq" target="_blank">
         <picture>
           <img alt="MQTT指令下发" src="docs/images/demo4.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1CDKWemEU6" target="_blank">
         <picture>
           <img alt="自定义音色" src="docs/images/demo2.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV12yA2egEaC" target="_blank">
         <picture>
           <img alt="使用粤语交流" src="docs/images/demo3.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1pNXWYGEx1" target="_blank">
         <picture>
           <img alt="控制家电开关" src="docs/images/demo5.png" />
         </picture>
        </a>
    </td>
  </tr>
  <tr>
    <td>
        <a href="https://www.bilibili.com/video/BV1vchQzaEse" target="_blank">
         <picture>
           <img alt="自定义音色" src="docs/images/demo6.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1VC96Y5EMH" target="_blank">
         <picture>
           <img alt="播放音乐" src="docs/images/demo7.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1Z8XuYZEAS" target="_blank">
         <picture>
           <img alt="天气插件" src="docs/images/demo8.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV178XuYfEpi" target="_blank">
         <picture>
           <img alt="IOT指令控制设备" src="docs/images/demo9.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV17LXWYvENb" target="_blank">
         <picture>
           <img alt="播报新闻" src="docs/images/demo0.png" />
         </picture>
        </a>
    </td>
  </tr>
  <tr>
    <td>
      <a href="https://www.bilibili.com/video/BV12J7WzBEaH" target="_blank">
         <picture>
           <img alt="实时打断" src="docs/images/demo10.png" />
         </picture>
        </a>
    </td>
    <td>
      <a href="https://www.bilibili.com/video/BV1Co76z7EvK" target="_blank">
         <picture>
           <img alt="拍照识物品" src="docs/images/demo12.png" />
         </picture>
        </a>
    </td>
    <td>
      <a href="https://www.bilibili.com/video/BV1TJ7WzzEo6" target="_blank">
         <picture>
           <img alt="多指令任务" src="docs/images/demo11.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1ZQKUzYExM" target="_blank">
         <picture>
           <img alt="MCP接入点" src="docs/images/demo13.png" />
         </picture>
        </a>
    </td>
    <td>
        <a href="https://www.bilibili.com/video/BV1Exu3zqEDe" target="_blank">
         <picture>
           <img alt="声纹识别" src="docs/images/demo14.png" />
         </picture>
        </a>
    </td>
  </tr>
</table>

---

## Cảnh báo ⚠️

1、Dự án này là phần mềm mã nguồn mở, phần mềm này và bất kỳ nhà cung cấp dịch vụ API bên thứ ba nào (bao gồm nhưng không giới hạn ở nền tảng nhận dạng giọng nói, mô hình lớn, tổng hợp giọng nói) đều không có quan hệ hợp tác thương mại, không cung cấp bất kỳ hình thức bảo đảm nào về chất lượng dịch vụ và an toàn vốn.
Khuyến nghị người dùng ưu tiên lựa chọn nhà cung cấp dịch vụ có giấy phép kinh doanh liên quan và đọc kỹ thỏa thuận dịch vụ và chính sách bảo mật của họ. Phần mềm này không lưu trữ bất kỳ khóa tài khoản nào, không tham gia vào luồng tiền, không chịu rủi ro mất tiền nạp.

2、Chức năng của dự án này chưa hoàn thiện và chưa thông qua đánh giá an ninh mạng, vui lòng không sử dụng trong môi trường sản xuất. Nếu bạn triển khai dự án này trong môi trường mạng công cộng để học tập, vui lòng thực hiện các biện pháp bảo vệ cần thiết.

---

## Tài liệu triển khai

![Banners](docs/images/banner2.png)

Dự án này cung cấp hai cách triển khai, vui lòng chọn theo nhu cầu cụ thể của bạn:

#### 🚀 Lựa chọn phương thức triển khai
| Phương thức triển khai | Đặc điểm | Kịch bản sử dụng | Tài liệu triển khai | Yêu cầu cấu hình | Video hướng dẫn | 
|---------|------|---------|---------|---------|---------|
| **Cài đặt đơn giản nhất** | Đối thoại thông minh, IOT, MCP, nhận thức thị giác | Môi trường cấu hình thấp, dữ liệu lưu trữ trong file cấu hình, không cần cơ sở dữ liệu | [①Phiên bản Docker](./docs/Deployment.md#%E6%96%B9%E5%BC%8F%E4%B8%80docker%E5%8F%AA%E8%BF%90%E8%A1%8Cserver) / [②Triển khai mã nguồn](./docs/Deployment.md#%E6%96%B9%E5%BC%8F%E4%BA%8C%E6%9C%AC%E5%9C%B0%E6%BA%90%E7%A0%81%E5%8F%AA%E8%BF%90%E8%A1%8Cserver)| Nếu sử dụng `FunASR` cần 2 nhân 4GB RAM, nếu toàn bộ API, cần 2 nhân 2GB RAM | - | 
| **Cài đặt toàn bộ module** | Đối thoại thông minh, IOT, điểm truy cập MCP, nhận dạng giọng nói, nhận thức thị giác, OTA, bảng điều khiển thông minh | Trải nghiệm chức năng hoàn chỉnh, dữ liệu lưu trữ trong cơ sở dữ liệu |[①Phiên bản Docker](./docs/Deployment_all.md#%E6%96%B9%E5%BC%8F%E4%B8%80docker%E8%BF%90%E8%A1%8C%E5%85%A8%E6%A8%A1%E5%9D%97) / [②Triển khai mã nguồn](./docs/Deployment_all.md#%E6%96%B9%E5%BC%8F%E4%BA%8C%E6%9C%AC%E5%9C%B0%E6%BA%90%E7%A0%81%E8%BF%90%E8%A1%8C%E5%85%A8%E6%A8%A1%E5%9D%97) / [③Hướng dẫn cập nhật tự động triển khai mã nguồn](./docs/dev-ops-integration.md) | Nếu sử dụng `FunASR` cần 4 nhân 8GB RAM, nếu toàn bộ API, cần 2 nhân 4GB RAM| [Video hướng dẫn khởi động mã nguồn cục bộ](https://www.bilibili.com/video/BV1wBJhz4Ewe) | 

Câu hỏi thường gặp và hướng dẫn liên quan, có thể tham khảo [liên kết này](./docs/FAQ.md)

> 💡 Gợi ý: Dưới đây là nền tảng thử nghiệm sau khi triển khai theo mã mới nhất, có thể ghi để thử nghiệm, đồng thời là 6, dữ liệu sẽ được xóa mỗi ngày,

```
Địa chỉ bảng điều khiển thông minh: https://2662r3426b.vicp.fun
Bảng điều khiển thông minh (phiên bản h5): https://2662r3426b.vicp.fun/h5/index.html

Công cụ kiểm tra dịch vụ: https://2662r3426b.vicp.fun/test/
Địa chỉ giao diện OTA: https://2662r3426b.vicp.fun/xiaozhi/ota/
Địa chỉ giao diện Websocket: wss://2662r3426b.vicp.fun/xiaozhi/v1/
```

#### 🚩 Giải thích và đề xuất cấu hình
> [!Note]
> Dự án này cung cấp hai phương án cấu hình:
> 
> 1. Cấu hình `Nhập môn hoàn toàn miễn phí`: Phù hợp cho sử dụng cá nhân gia đình, tất cả các thành phần đều sử dụng phương án miễn phí, không cần trả thêm phí.
> 
> 2. Cấu hình `Luồng`: Phù hợp cho các kịch bản trình diễn, đào tạo, hơn 2 đồng thời, sử dụng công nghệ xử lý luồng, tốc độ phản hồi nhanh hơn, trải nghiệm tốt hơn.
> 
> Từ phiên bản `0.5.2`, dự án hỗ trợ cấu hình luồng, so với phiên bản cũ, tốc độ phản hồi tăng khoảng `2.5 giây`, cải thiện đáng kể trải nghiệm người dùng.

| Tên module | Cài đặt nhập môn hoàn toàn miễn phí | Cấu hình luồng |
|:---:|:---:|:---:|
| ASR(Nhận dạng giọng nói) | FunASR(cục bộ) | 👍FunASR(chế độ GPU cục bộ) |
| LLM(Mô hình lớn) | ChatGLMLLM(Zhipu glm-4-flash) | 👍AliLLM(qwen3-235b-a22b-instruct-2507) hoặc 👍DoubaoLLM(doubao-1-5-pro-32k-250115) |
| VLLM(Mô hình thị giác lớn) | ChatGLMVLLM(Zhipu glm-4v-flash) | 👍QwenVLVLLM(Qianwen qwen2.5-vl-3b-instructh) |
| TTS(Tổng hợp giọng nói) | ✅LinkeraiTTS(Lingxi luồng) | 👍HuoshanDoubleStreamTTS(Huoshan tổng hợp giọng nói luồng kép) hoặc 👍AliyunStreamTTS(Aliyun tổng hợp giọng nói luồng) |
| Intent(Nhận dạng ý định) | function_call(gọi hàm) | function_call(gọi hàm) |
| Memory(Chức năng ghi nhớ) | mem_local_short(ghi nhớ ngắn hạn cục bộ) | mem_local_short(ghi nhớ ngắn hạn cục bộ) |

Nếu bạn quan tâm đến thời gian tiêu thụ của các thành phần, vui lòng tham khảo [Báo cáo kiểm tra hiệu suất các thành phần Xiaozhi](https://github.com/xinnan-tech/xiaozhi-performance-research), có thể thực hiện kiểm tra thực tế trong môi trường của bạn theo phương pháp kiểm tra trong báo cáo.

#### 🔧 Công cụ kiểm tra
Dự án này cung cấp các công cụ kiểm tra sau để giúp bạn xác minh hệ thống và lựa chọn mô hình phù hợp:

| Tên công cụ | Vị trí | Phương pháp sử dụng | Giải thích chức năng |
|:---:|:---|:---:|:---:|
| Công cụ kiểm tra tương tác âm thanh | main》xiaozhi-server》test》test_page.html | Sử dụng trình duyệt Chrome để mở trực tiếp | Kiểm tra chức năng phát và nhận âm thanh, xác minh xử lý âm thanh phía Python có bình thường không |
| Công cụ kiểm tra phản hồi mô hình | main》xiaozhi-server》performance_tester.py | Thực thi `python performance_tester.py` | Kiểm tra tốc độ phản hồi của ba module cốt lõi: ASR(nhận dạng giọng nói), LLM(mô hình lớn), VLLM(mô hình thị giác), TTS(tổng hợp giọng nói) |

> 💡 Gợi ý: Khi kiểm tra tốc độ mô hình, chỉ kiểm tra các mô hình đã cấu hình khóa.

---

## Danh sách chức năng ✨
### Đã triển khai ✅
![Vui lòng tham khảo - Sơ đồ kiến trúc cài đặt toàn bộ module](docs/images/deploy2.png)
| Module chức năng | Mô tả |
|:---:|:---|
| Kiến trúc cốt lõi | Dựa trên [Cổng MQTT+UDP](https://github.com/xinnan-tech/xiaozhi-esp32-server/blob/main/docs/mqtt-gateway-integration.md), WebSocket, máy chủ HTTP, cung cấp hệ thống quản lý và xác thực bảng điều khiển hoàn chỉnh |
| Tương tác giọng nói | Hỗ trợ ASR(nhận dạng giọng nói) luồng, TTS(tổng hợp giọng nói) luồng, VAD(phát hiện hoạt động giọng nói), hỗ trợ nhận dạng đa ngôn ngữ và xử lý giọng nói |
| Nhận dạng giọng nói | Hỗ trợ đăng ký, quản lý và nhận dạng giọng nói đa người dùng, xử lý song song với ASR, nhận dạng danh tính người nói theo thời gian thực và truyền cho LLM để phản hồi cá nhân hóa |
| Đối thoại thông minh | Hỗ trợ nhiều LLM(mô hình ngôn ngữ lớn), thực hiện đối thoại thông minh |
| Nhận thức thị giác | Hỗ trợ nhiều VLLM(mô hình thị giác lớn), thực hiện tương tác đa phương thức |
| Nhận dạng ý định | Hỗ trợ nhận dạng ý định LLM, gọi hàm Function Call, cung cấp cơ chế xử lý ý định dạng plugin |
| Hệ thống ghi nhớ | Hỗ trợ ghi nhớ ngắn hạn cục bộ, ghi nhớ giao diện mem0ai, có chức năng tổng kết ghi nhớ |
| Gọi công cụ | Hỗ trợ giao thức IOT máy khách, giao thức MCP máy khách, giao thức MCP máy chủ, giao thức điểm truy cập MCP, hàm công cụ tùy chỉnh |
| Phát lệnh | Dựa trên giao thức MQTT, hỗ trợ phát lệnh MCP từ bảng điều khiển thông minh đến thiết bị ESP32 |
| Quản lý backend | Cung cấp giao diện quản lý web, hỗ trợ quản lý người dùng, cấu hình hệ thống và quản lý thiết bị; giao diện hỗ trợ hiển thị tiếng Trung giản thể, tiếng Trung phồn thể, tiếng Anh |
| Công cụ kiểm tra | Cung cấp công cụ kiểm tra hiệu suất, công cụ kiểm tra mô hình thị giác và công cụ kiểm tra tương tác âm thanh |
| Hỗ trợ triển khai | Hỗ trợ triển khai Docker và triển khai cục bộ, cung cấp quản lý file cấu hình hoàn chỉnh |
| Hệ thống plugin | Hỗ trợ mở rộng plugin chức năng, phát triển plugin tùy chỉnh và tải nóng plugin |

### Đang phát triển 🚧

Muốn hiểu kế hoạch phát triển cụ thể, [vui lòng nhấp vào đây](https://github.com/users/xinnan-tech/projects/3). Câu hỏi thường gặp và hướng dẫn liên quan, có thể tham khảo [liên kết này](./docs/FAQ.md)

Nếu bạn là nhà phát triển phần mềm, đây là [《Thư ngỏ gửi nhà phát triển》](docs/contributor_open_letter.md), chào mừng tham gia!

---

## Hệ sinh thái sản phẩm 👬
Xiaozhi là một hệ sinh thái, khi bạn sử dụng sản phẩm này, bạn cũng có thể xem các [dự án xuất sắc khác](https://github.com/78/xiaozhi-esp32?tab=readme-ov-file#%E7%9B%B8%E5%85%B3%E5%BC%80%E6%BA%90%E9%A1%B9%E7%9B%AE) trong hệ sinh thái này

---

## Danh sách nền tảng/thành phần được hỗ trợ bởi dự án này 📋
### LLM Mô hình ngôn ngữ

| Phương thức sử dụng | Nền tảng hỗ trợ | Nền tảng miễn phí |
|:---:|:---:|:---:|
| Gọi giao diện openai | Ali Bailian, Huoshan Engine Doubao, ShenDu QiuSuo, Zhipu ChatGLM, Gemini | Zhipu ChatGLM, Gemini |
| Gọi giao diện ollama | Ollama | - |
| Gọi giao diện dify | Dify | - |
| Gọi giao diện fastgpt | Fastgpt | - |
| Gọi giao diện coze | Coze | - |
| Gọi giao diện xinference | Xinference | - |
| Gọi giao diện homeassistant | HomeAssistant | - |

Trên thực tế, bất kỳ LLM nào hỗ trợ gọi giao diện openai đều có thể kết nối sử dụng.

---

### VLLM Mô hình thị giác

| Phương thức sử dụng | Nền tảng hỗ trợ | Nền tảng miễn phí |
|:---:|:---:|:---:|
| Gọi giao diện openai | Ali Bailian, Zhipu ChatGLMVLLM | Zhipu ChatGLMVLLM |

Trên thực tế, bất kỳ VLLM nào hỗ trợ gọi giao diện openai đều có thể kết nối sử dụng.

---

### TTS Tổng hợp giọng nói

| Phương thức sử dụng | Nền tảng hỗ trợ | Nền tảng miễn phí |
|:---:|:---:|:---:|
| Gọi giao diện | EdgeTTS, Huoshan Engine Doubao TTS, Tencent Cloud, Aliyun TTS, Aliyun Stream TTS, CosyVoiceSiliconflow, TTS302AI, CozeCnTTS, GizwitsTTS, ACGNTTS, OpenAITTS, Lingxi Stream TTS, MinimaxTTS, Huoshan Double Stream TTS | Lingxi Stream TTS, EdgeTTS, CosyVoiceSiliconflow(một phần) |
| Dịch vụ cục bộ | FishSpeech, GPT_SOVITS_V2, GPT_SOVITS_V3, Index-TTS, PaddleSpeech | Index-TTS, PaddleSpeech, FishSpeech, GPT_SOVITS_V2, GPT_SOVITS_V3 |

---

### VAD Phát hiện hoạt động giọng nói

| Loại  |   Tên nền tảng    | Phương thức sử dụng | Chế độ tính phí | Ghi chú |
|:---:|:---------:|:----:|:----:|:--:|
| VAD | SileroVAD | Sử dụng cục bộ |  Miễn phí  |    |

---

### ASR Nhận dạng giọng nói

| Phương thức sử dụng | Nền tảng hỗ trợ | Nền tảng miễn phí |
|:---:|:---:|:---:|
| Sử dụng cục bộ | FunASR, SherpaASR | FunASR, SherpaASR |
| Gọi giao diện | DoubaoASR, Doubao Stream ASR, FunASRServer, TencentASR, AliyunASR, Aliyun Stream ASR, Baidu ASR, OpenAI ASR | FunASRServer |

---

### Voiceprint Nhận dạng giọng nói

| Phương thức sử dụng | Nền tảng hỗ trợ | Nền tảng miễn phí |
|:---:|:---:|:---:|
| Sử dụng cục bộ | 3D-Speaker | 3D-Speaker |

---

### Memory Lưu trữ ghi nhớ

|   Loại   |      Tên nền tảng       | Phương thức sử dụng |   Chế độ tính phí    | Ghi chú |
|:------:|:---------------:|:----:|:---------:|:--:|
| Memory |     mem0ai      | Gọi giao diện | 1000 lần/tháng hạn ngạch |    |
| Memory | mem_local_short | Tổng kết cục bộ |    Miễn phí     |    |
| Memory |     nomem       | Chế độ không ghi nhớ |    Miễn phí     |    |

---

### Intent Nhận dạng ý định

|   Loại   |     Tên nền tảng      | Phương thức sử dụng |  Chế độ tính phí   |          Ghi chú           |
|:------:|:-------------:|:----:|:-------:|:---------------------:|
| Intent |  intent_llm   | Gọi giao diện | Tính phí theo LLM |     Thông qua mô hình lớn nhận dạng ý định, tính phổ biến mạnh     |
| Intent | function_call | Gọi giao diện | Tính phí theo LLM | Thông qua gọi hàm mô hình lớn hoàn thành ý định, tốc độ nhanh, hiệu quả tốt |
| Intent |    nointent   | Chế độ không nhận dạng ý định |    Miễn phí     |    Không thực hiện nhận dạng ý định, trực tiếp trả về kết quả đối thoại     |

---

## Lời cảm ơn 🙏

| Logo | Dự án/Công ty | Giải thích |
|:---:|:---:|:---|
| <img src="./docs/images/logo_bailing.png" width="160"> | [Bailing Voice Dialogue Robot](https://github.com/wwbin2017/bailing) | Dự án này được truyền cảm hứng từ [Bailing Voice Dialogue Robot](https://github.com/wwbin2017/bailing) và được triển khai dựa trên đó |
| <img src="./docs/images/logo_tenclass.png" width="160"> | [Shi Fang Rong Hai](https://www.tenclass.com/) | Cảm ơn [Shi Fang Rong Hai](https://www.tenclass.com/) đã xây dựng giao thức truyền thông tiêu chuẩn cho hệ sinh thái Xiaozhi, giải pháp tương thích đa thiết bị và thực hành mẫu cho kịch bản đồng thời cao; cung cấp hỗ trợ tài liệu kỹ thuật toàn chuỗi cho dự án này |
| <img src="./docs/images/logo_xuanfeng.png" width="160"> | [Xuanfeng Technology](https://github.com/Eric0308) | Cảm ơn [Xuanfeng Technology](https://github.com/Eric0308) đã đóng góp mã triển khai khung gọi hàm, giao thức truyền thông MCP và cơ chế gọi plugin, thông qua hệ thống điều phối lệnh tiêu chuẩn hóa và khả năng mở rộng động, đã cải thiện đáng kể hiệu quả tương tác và khả năng mở rộng chức năng của thiết bị đầu cuối (IoT) |
| <img src="./docs/images/logo_junsen.png" width="160"> | [huangjunsen](https://github.com/huangjunsen0406) | Cảm ơn [huangjunsen](https://github.com/huangjunsen0406) đã đóng góp module `Bảng điều khiển thông minh di động`, thực hiện điều khiển và tương tác thời gian thực hiệu quả trên thiết bị di động đa nền tảng, cải thiện đáng kể tính tiện lợi và hiệu quả quản lý của hệ thống trong kịch bản di động |
| <img src="./docs/images/logo_huiyuan.png" width="160"> | [Huiyuan Design](http://ui.kwd988.net/) | Cảm ơn [Huiyuan Design](http://ui.kwd988.net/) đã cung cấp giải pháp hình ảnh chuyên nghiệp cho dự án này, sử dụng kinh nghiệm thiết kế thực tế phục vụ hơn nghìn doanh nghiệp để trao quyền cho trải nghiệm người dùng sản phẩm của dự án này |
| <img src="./docs/images/logo_qinren.png" width="160"> | [Xi'an Qinren Information Technology](https://www.029app.com/) | Cảm ơn [Xi'an Qinren Information Technology](https://www.029app.com/) đã đào sâu hệ thống hình ảnh của dự án này, đảm bảo tính nhất quán và khả năng mở rộng của phong cách thiết kế tổng thể trong các ứng dụng đa kịch bản |
| <img src="./docs/images/logo_contributors.png" width="160"> | [Người đóng góp mã](https://github.com/xinnan-tech/xiaozhi-esp32-server/graphs/contributors) | Cảm ơn [tất cả người đóng góp mã](https://github.com/xinnan-tech/xiaozhi-esp32-server/graphs/contributors), sự đóng góp của bạn đã làm cho dự án trở nên mạnh mẽ và vững chắc hơn. |


<a href="https://star-history.com/#xinnan-tech/xiaozhi-esp32-server&Date">

 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=xinnan-tech/xiaozhi-esp32-server&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=xinnan-tech/xiaozhi-esp32-server&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=xinnan-tech/xiaozhi-esp32-server&type=Date" />
 </picture>
</a>
