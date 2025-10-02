# Phương thức 2: Chạy Source Code Local - Toàn Bộ Module

## Tổng quan

Phương thức này chạy tất cả các module (Server + Web + Database + Redis) từ source code trên máy local, phù hợp cho môi trường development hoặc khi bạn cần tùy chỉnh code.

---

## Bước 1: Cài đặt môi trường Conda

### 1.1. Cài đặt Conda (nếu chưa có)

**Đối với Windows:**
- Tải và cài đặt [Anaconda](https://www.anaconda.com/download) hoặc [Miniconda](https://docs.conda.io/en/latest/miniconda.html)
- Sau khi cài đặt, tìm kiếm "Anaconda Prompt" trong Start Menu
- Chạy với quyền Administrator

**Đối với Linux/macOS:**
```bash
# Tai Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Hoac tai Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-latest-Linux-x86_64.sh
bash Anaconda3-latest-Linux-x86_64.sh
```

### 1.2. Tạo môi trường Conda

```bash
# Xoa moi truong cu (neu co)
conda remove -n xiaozhi-esp32-server --all -y

# Tao moi truong moi voi Python 3.10
conda create -n xiaozhi-esp32-server python=3.10 -y

# Kich hoat moi truong
conda activate xiaozhi-esp32-server
```

### 1.3. Thêm kênh Tsinghua (tùy chọn - tăng tốc download tại Trung Quốc)

```bash
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge
```

### 1.4. Cài đặt thư viện hệ thống

```bash
# Cai dat libopus va ffmpeg
conda install libopus -y
conda install ffmpeg -y
```

**Lưu ý:** Nếu không dùng Conda, bạn cần cài đặt `libopus` và `ffmpeg` theo hệ điều hành:

```bash
# Ubuntu/Debian
sudo apt-get install libopus-dev ffmpeg -y

# CentOS/RHEL
sudo yum install opus-devel ffmpeg -y

# macOS
brew install opus ffmpeg
```

---

## Bước 2: Tải source code

### 2.1. Clone repository

```bash
git clone https://github.com/xinnan-tech/xiaozhi-esp32-server.git
cd xiaozhi-esp32-server/main/xiaozhi-server
```

### 2.2. Hoặc tải file ZIP

1. Truy cập: https://github.com/xinnan-tech/xiaozhi-esp32-server
2. Click nút **Code** (màu xanh)
3. Chọn **Download ZIP**
4. Giải nén và di chuyển vào thư mục: `xiaozhi-esp32-server-main/main/xiaozhi-server`

---

## Bước 3: Cài đặt Python dependencies

```bash
# Di chuyen vao thu muc xiaozhi-server
cd xiaozhi-esp32-server/main/xiaozhi-server

# (Tuy chon) Thiet lap PyPI mirror de tang toc download
pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

# Cai dat cac thu vien Python
pip install -r requirements.txt
```

**Lưu ý:** Quá trình này có thể mất vài phút tùy theo tốc độ mạng.

---

## Bước 4: Cài đặt MySQL và Redis

### 4.1. Cài đặt MySQL 8.0

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql

# Tao database
sudo mysql -e "CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'xiaozhi'@'localhost' IDENTIFIED BY '123456';"
sudo mysql -e "GRANT ALL PRIVILEGES ON xiaozhi_esp32_server.* TO 'xiaozhi'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

**macOS:**
```bash
brew install mysql@8.0
brew services start mysql@8.0

# Tao database
mysql -uroot -e "CREATE DATABASE xiaozhi_esp32_server CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -uroot -e "CREATE USER 'xiaozhi'@'localhost' IDENTIFIED BY '123456';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON xiaozhi_esp32_server.* TO 'xiaozhi'@'localhost';"
```

**Windows:**
- Tải MySQL Installer từ: https://dev.mysql.com/downloads/installer/
- Cài đặt MySQL Server 8.0
- Sử dụng MySQL Workbench để tạo database `xiaozhi_esp32_server`

### 4.2. Cài đặt Redis

**Ubuntu/Debian:**
```bash
sudo apt install redis-server -y
sudo systemctl start redis
sudo systemctl enable redis
```

**macOS:**
```bash
brew install redis
brew services start redis
```

**Windows:**
- Tải Redis từ: https://github.com/microsoftarchive/redis/releases
- Hoặc sử dụng Docker: `docker run -d -p 6379:6379 redis:alpine`

---

## Bước 5: Tải model nhận dạng giọng nói

```bash
# Tao thu muc models
mkdir -p models/SenseVoiceSmall

# Tai model file (chon mot cach)

# Cach 1: Tu Hugging Face
wget -O models/SenseVoiceSmall/model.pt \
  https://huggingface.co/FunAudioLLM/SenseVoiceSmall/resolve/main/model.pt

# Cach 2: Tu ModelScope
wget -O models/SenseVoiceSmall/model.pt \
  https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt

# Cach 3: Tu Google Drive (neu bi chan o Trung Quoc)
# Lien he de lay link download
```

---

## Bước 6: Cấu hình file config

### 6.1. Tạo file cấu hình

```bash
# Tao thu muc data
mkdir -p data

# Tai file config mau cho che do full module
wget -O data/.config.yaml \
  https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/main/main/xiaozhi-server/config_from_api.yaml
```

### 6.2. Chỉnh sửa file `.config.yaml`

```bash
# Mo file de chinh sua
nano data/.config.yaml
# Hoac vim data/.config.yaml
```

**Nội dung cần cấu hình:**

```yaml
server:
  ip: 0.0.0.0
  port: 8000
  http_port: 8003
  vision_explain: http://127.0.0.1:8003/mcp/vision/explain

manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: your-secret-key-here  # Se cap nhat sau

# Database configuration
database:
  host: localhost
  port: 3306
  username: xiaozhi
  password: 123456
  database: xiaozhi_esp32_server

# Redis configuration
redis:
  host: localhost
  port: 6379
  password: ""  # De trong neu Redis khong co password
```

---

## Bước 7: Chạy Web Management Console

### 7.1. Cài đặt Java (nếu chưa có)

```bash
# Ubuntu/Debian
sudo apt install openjdk-17-jdk -y

# macOS
brew install openjdk@17

# Windows
# Tai tu: https://adoptium.net/
```

### 7.2. Clone và build Web Console

```bash
# Clone repository manager
cd ..  # Quay lai thu muc main
git clone https://github.com/xinnan-tech/xiaozhi-esp32-server.git xiaozhi-web
cd xiaozhi-web/manager-api

# Build project
./mvnw clean package -DskipTests

# Hoac su dung Maven da cai dat
mvn clean package -DskipTests
```

### 7.3. Cấu hình application.yml

```bash
nano src/main/resources/application.yml
```

Chỉnh sửa:

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/xiaozhi_esp32_server?useUnicode=true&characterEncoding=UTF-8
    username: xiaozhi
    password: 123456
  
  redis:
    host: localhost
    port: 6379
    password: ""

server:
  port: 8002
```

### 7.4. Chạy Web Console

```bash
# Chay tu JAR file
java -jar target/xiaozhi-admin-*.jar

# Hoac chay truc tiep bang Maven
./mvnw spring-boot:run
```

---

## Bước 8: Đăng ký Super Admin và lấy Secret Key

### 8.1. Truy cập Web Console

Mở trình duyệt và truy cập:
```
http://localhost:8002
```

### 8.2. Đăng ký tài khoản đầu tiên

- Click **Đăng ký** (Register)
- Điền thông tin:
  - Username: `admin`
  - Password: `admin@123` (hoặc mật khẩu mạnh)
  - Email: `admin@example.com`
- **Tài khoản đầu tiên sẽ tự động trở thành Super Admin**

### 8.3. Lấy Server Secret Key

1. Đăng nhập vào Web Console
2. Vào **系统管理** (System Management) → **服务器配置** (Server Config)
3. Tìm mục **服务器密钥** (Server Secret)
4. Copy giá trị secret key

### 8.4. Cập nhật vào file config

```bash
# Mo file config
nano data/.config.yaml

# Cap nhat dong secret
manager-api:
  url: http://127.0.0.1:8002/xiaozhi
  secret: <PASTE_SECRET_KEY_HERE>
```

---

## Bước 9: Chạy xiaozhi-server

```bash
# Quay lai thu muc xiaozhi-server
cd ../../xiaozhi-server

# Kich hoat moi truong conda
conda activate xiaozhi-esp32-server

# Chay server
python app.py
```

**Hoặc chạy dưới dạng service (Linux):**

```bash
# Tao service file
sudo nano /etc/systemd/system/xiaozhi-server.service
```

Nội dung:

```ini
[Unit]
Description=Xiaozhi ESP32 Server
After=network.target mysql.service redis.service

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/xiaozhi-esp32-server/main/xiaozhi-server
ExecStart=/home/your-username/miniconda3/envs/xiaozhi-esp32-server/bin/python app.py
Restart=always

[Install]
WantedBy=multi-user.target
```

Khởi động service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable xiaozhi-server
sudo systemctl start xiaozhi-server
sudo systemctl status xiaozhi-server
```

---

## Bước 10: Kiểm tra và Test

### 10.1. Kiểm tra logs

```bash
# Kiem tra log cua xiaozhi-server
tail -f logs/xiaozhi-server.log

# Kiem tra MySQL
sudo systemctl status mysql

# Kiem tra Redis
redis-cli ping  # Should return PONG
```

### 10.2. Test WebSocket

```bash
# Test voi wscat (neu da cai dat)
npm install -g wscat
wscat -c ws://localhost:8000/xiaozhi/v1/

# Hoac su dung test page trong project
# Mo file: test_page.html trong trinh duyet
```

### 10.3. Test API endpoints

```bash
# Test health check
curl http://localhost:8000/health

# Test HTTP server
curl http://localhost:8003/health

# Test Web Console
curl http://localhost:8002/xiaozhi/doc.html
```

---

## Bước 11: Cấu hình LLM và TTS

### 11.1. Cấu hình qua Web Console

1. Truy cập: http://localhost:8002
2. Vào **模型配置** (Model Configuration)
3. Cấu hình:
   - **LLM**: Chọn provider (Ollama, OpenAI, Zhipu AI, etc.)
   - **TTS**: Chọn Edge TTS hoặc các provider khác
   - **ASR**: Mặc định dùng FunASR local

### 11.2. Hoặc cấu hình qua file

Chỉnh sửa `data/.config.yaml`:

```yaml
llm:
  provider: ollama
  base_url: http://localhost:11434/v1
  model: qwen2.5:3b
  api_key: ollama

tts:
  provider: edge
  voice: vi-VN-HoaiMyNeural
  rate: +0%

asr:
  provider: funasr
  model_path: /path/to/models/SenseVoiceSmall
```

---

## Tổng kết các lệnh quan trọng

```bash
# Kich hoat moi truong
conda activate xiaozhi-esp32-server

# Chay server
cd xiaozhi-esp32-server/main/xiaozhi-server
python app.py

# Chay Web Console (tab khac)
cd xiaozhi-esp32-server/manager-api
java -jar target/xiaozhi-admin-*.jar

# Kiem tra trang thai
sudo systemctl status mysql redis xiaozhi-server

# Xem logs
tail -f logs/xiaozhi-server.log
```

---

## Lưu ý quan trọng

1. **Môi trường Conda**: Luôn nhớ activate môi trường trước khi chạy
2. **Database**: Đảm bảo MySQL và Redis đã chạy
3. **Firewall**: Mở ports 8000, 8002, 8003 nếu cần truy cập từ xa
4. **Secret Key**: Phải khớp giữa Web Console và file config
5. **Model file**: Đảm bảo `model.pt` đã download đầy đủ (khoảng 1.9GB)

---

## Troubleshooting

### Lỗi kết nối MySQL
```bash
# Kiem tra MySQL dang chay
sudo systemctl status mysql

# Kiem tra ket noi
mysql -u xiaozhi -p123456 xiaozhi_esp32_server
```

### Lỗi kết nối Redis
```bash
# Kiem tra Redis
redis-cli ping

# Neu khong chay
sudo systemctl start redis
```

### Lỗi import Python
```bash
# Cai dat lai dependencies
pip install -r requirements.txt --force-reinstall
```

### Port đã được sử dụng
```bash
# Tim tien trinh dang su dung port
sudo lsof -i :8000
sudo lsof -i :8002

# Kill tien trinh
sudo kill -9 <PID>
```