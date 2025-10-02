#!/bin/sh
# Tac gia script: @VanillaNahida
# File nay dung de tu dong tai cac file can thiet cho du an, tu dong tao thu muc
# Hien tai chi ho tro he thong Ubuntu phien ban X86, cac he thong khac chua duoc kiem tra

# Dinh nghia ham xu ly ngat
handle_interrupt() {
    echo ""
    echo "Qua trinh cai dat bi nguoi dung ngat (Ctrl+C hoac Esc)"
    echo "Neu muon cai dat lai, vui long chay lai script"
    exit 1
}

# Thiet lap bat tin hieu, xu ly Ctrl+C
trap handle_interrupt SIGINT

# Xu ly phim Esc
# Luu cai dat terminal
old_stty_settings=$(stty -g)
# Thiet lap terminal phan hoi ngay lap tuc, khong hien thi
stty -icanon -echo min 1 time 0

# Tien trinh nen phat hien phim Esc
(while true; do
    read -r key
    if [[ $key == $'\e' ]]; then
        # Phat hien phim Esc, kich hoat xu ly ngat
        kill -SIGINT $$
        break
    fi
done) &

# Khi script ket thuc, khoi phuc cai dat terminal
trap 'stty "$old_stty_settings"' EXIT


# In ky tu mau
echo -e "\e[1;32m"  # Thiet lap mau xanh la sang
cat << "EOF"
Tac gia script: @Bilibili VanillaNahida
 __      __            _  _  _            _   _         _      _      _        
 \ \    / /           (_)| || |          | \ | |       | |    (_)    | |       
  \ \  / /__ _  _ __   _ | || |  __ _    |  \| |  __ _ | |__   _ __| |  __ _ 
   \ \/ // _` || '_ \ | || || | / _` |   | . ` | / _` || '_ \ | | / _` | / _` |
    \  /| (_| || | | || || || || (_| |   | |\  || (_| || | | || || (_| || (_| |
     \/  \__,_||_| |_||_||_||_| \__,_|   |_| \_| \__,_||_| |_||_| \__,_| \__,_|                                                                                                                                                                                                                               
EOF
echo -e "\e[0m"  # Reset mau
echo -e "\e[1;36m  Script cai dat tu dong Xiaozhi Server - Phien ban 0.2 - Cap nhat 20/08/2025 \e[0m\n"
sleep 1



# Kiem tra va cai dat whiptail
check_whiptail() {
    if ! command -v whiptail &> /dev/null; then
        echo "Dang cai dat whiptail..."
        apt update
        apt install -y whiptail
    fi
}

check_whiptail

# Tao hop thoai xac nhan
whiptail --title "Xac nhan cai dat" --yesno "Chuan bi cai dat Xiaozhi Server, ban co muon tiep tuc?" \
  --yes-button "Tiep tuc" --no-button "Thoat" 10 50

# Thuc thi theo lua chon cua nguoi dung
case $? in
  0)
    ;;
  1)
    exit 1
    ;;
esac

# Kiem tra quyen root
if [ $EUID -ne 0 ]; then
    whiptail --title "Loi quyen" --msgbox "Vui long chay script nay voi quyen root" 10 50
    exit 1
fi

# Kiem tra phien ban he thong
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" != "debian" ] && [ "$ID" != "ubuntu" ]; then
        whiptail --title "Loi he thong" --msgbox "Script nay chi ho tro he thong Debian/Ubuntu" 10 60
        exit 1
    fi
else
    whiptail --title "Loi he thong" --msgbox "Khong the xac dinh phien ban he thong, script nay chi ho tro Debian/Ubuntu" 10 60
    exit 1
fi

# Ham tai file cau hinh
check_and_download() {
    local filepath=$1
    local url=$2
    if [ ! -f "$filepath" ]; then
        if ! curl -fL --progress-bar "$url" -o "$filepath"; then
            whiptail --title "Loi" --msgbox "Tai file ${filepath} that bai" 10 50
            exit 1
        fi
    else
        echo "File ${filepath} da ton tai, bo qua buoc tai"
    fi
}

# Kiem tra da cai dat chua
check_installed() {
    # Kiem tra thu muc co ton tai va khong rong
    if [ -d "/opt/xiaozhi-server/" ] && [ "$(ls -A /opt/xiaozhi-server/)" ]; then
        DIR_CHECK=1
    else
        DIR_CHECK=0
    fi
    
    # Kiem tra container co ton tai
    if docker inspect xiaozhi-esp32-server > /dev/null 2>&1; then
        CONTAINER_CHECK=1
    else
        CONTAINER_CHECK=0
    fi
    
    # Hai lan kiem tra deu thanh cong
    if [ $DIR_CHECK -eq 1 ] && [ $CONTAINER_CHECK -eq 1 ]; then
        return 0  # Da cai dat
    else
        return 1  # Chua cai dat
    fi
}

# Lien quan den cap nhat
if check_installed; then
    if whiptail --title "Phat hien da cai dat" --yesno "Phat hien Xiaozhi Server da cai dat, ban co muon nang cap?" 10 60; then
        # Nguoi dung chon nang cap, thuc hien don dep
        echo "Bat dau qua trinh nang cap..."
        
        # Dung va xoa tat ca dich vu docker-compose
        docker compose -f /opt/xiaozhi-server/docker-compose_all.yml down
        
        # Dung va xoa cac container cu the (xem xet container co the khong ton tai)
        containers=(
            "xiaozhi-esp32-server"
            "xiaozhi-esp32-server-web"
            "xiaozhi-esp32-server-db"
            "xiaozhi-esp32-server-redis"
        )
        
        for container in "${containers[@]}"; do
            if docker ps -a --format '{{.Names}}' | grep -q "^${container}$"; then
                docker stop "$container" >/dev/null 2>&1 && \
                docker rm "$container" >/dev/null 2>&1 && \
                echo "Da xoa thanh cong container: $container"
            else
                echo "Container khong ton tai, bo qua: $container"
            fi
        done
        
        # Xoa cac image cu the (xem xet image co the khong ton tai)
        images=(
            "ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:server_latest"
            "ghcr.nju.edu.cn/xinnan-tech/xiaozhi-esp32-server:web_latest"
        )
        
        for image in "${images[@]}"; do
            if docker images --format '{{.Repository}}:{{.Tag}}' | grep -q "^${image}$"; then
                docker rmi "$image" >/dev/null 2>&1 && \
                echo "Da xoa thanh cong image: $image"
            else
                echo "Image khong ton tai, bo qua: $image"
            fi
        done
        
        echo "Hoan thanh tat ca thao tac don dep"
        
        # Sao luu file cau hinh cu
        mkdir -p /opt/xiaozhi-server/backup/
        if [ -f /opt/xiaozhi-server/data/.config.yaml ]; then
            cp /opt/xiaozhi-server/data/.config.yaml /opt/xiaozhi-server/backup/.config.yaml
            echo "Da sao luu file cau hinh cu vao /opt/xiaozhi-server/backup/.config.yaml"
        fi
        
        # Tai phien ban moi nhat cua file cau hinh
        check_and_download "/opt/xiaozhi-server/docker-compose_all.yml" "https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/docker-compose_all.yml"
        check_and_download "/opt/xiaozhi-server/data/.config.yaml" "https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/config_from_api.yaml"
        
        # Khoi dong dich vu Docker
        echo "Bat dau khoi dong phien ban moi nhat..."
        # Sau khi nang cap xong danh dau, bo qua buoc tai xuong sau
        UPGRADE_COMPLETED=1
        docker compose -f /opt/xiaozhi-server/docker-compose_all.yml up -d
    else
          whiptail --title "Bo qua nang cap" --msgbox "Da huy nang cap, se tiep tuc su dung phien ban hien tai." 10 50
          # Bo qua nang cap, tiep tuc thuc hien quy trinh cai dat sau
    fi
fi


# Kiem tra cai dat curl
if ! command -v curl &> /dev/null; then
    echo "------------------------------------------------------------"
    echo "Chua phat hien curl, dang cai dat..."
    apt update
    apt install -y curl
else
    echo "------------------------------------------------------------"
    echo "curl da duoc cai dat, bo qua buoc cai dat"
fi

# Kiem tra cai dat Docker
if ! command -v docker &> /dev/null; then
    echo "------------------------------------------------------------"
    echo "Chua phat hien Docker, dang cai dat..."
    
    # Su dung nguon mirror trong nuoc thay the nguon chinh thuc
    DISTRO=$(lsb_release -cs)
    MIRROR_URL="https://mirrors.aliyun.com/docker-ce/linux/ubuntu"
    GPG_URL="https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg"
    
    # Cai dat cac thu vien co ban
    apt update
    apt install -y apt-transport-https ca-certificates curl software-properties-common gnupg
    
    # Tao thu muc khoa va them khoa nguon mirror trong nuoc
    mkdir -p /etc/apt/keyrings
    curl -fsSL "$GPG_URL" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    
    # Them nguon mirror trong nuoc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] $MIRROR_URL $DISTRO stable" \
        > /etc/apt/sources.list.d/docker.list
    
    # Them khoa nguon chinh thuc du phong (tranh khoa nguon trong nuoc xac thuc that bai)
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8 2>/dev/null || \
    echo "Canh bao: Mot so khoa them that bai, tiep tuc thu cai dat..."
    
    # Cai dat Docker
    apt update
    apt install -y docker-ce docker-ce-cli containerd.io
    
    # Khoi dong dich vu
    systemctl start docker
    systemctl enable docker
    
    # Kiem tra cai dat thanh cong chua
    if docker --version; then
        echo "------------------------------------------------------------"
        echo "Docker da cai dat thanh cong!"
    else
        whiptail --title "Loi" --msgbox "Cai dat Docker that bai, vui long kiem tra log." 10 50
        exit 1
    fi
else
    echo "Docker da duoc cai dat, bo qua buoc cai dat"
fi

# Cau hinh nguon Docker image
MIRROR_OPTIONS=(
    "1" "Xuanyuan Mirror (Khuyen nghi)"
    "2" "Tencent Cloud Mirror"
    "3" "USTC Mirror"
    "4" "NetEase 163 Mirror"
    "5" "Huawei Cloud Mirror"
    "6" "Aliyun Mirror"
    "7" "Tu chinh mirror"
    "8" "Bo qua cau hinh"
)

MIRROR_CHOICE=$(whiptail --title "Chon nguon Docker image" --menu "Vui long chon nguon Docker image muon su dung" 20 60 10 \
"${MIRROR_OPTIONS[@]}" 3>&1 1>&2 2>&3) || {
    echo "Nguoi dung huy chon, thoat script"
    exit 1
}

case $MIRROR_CHOICE in
    1) MIRROR_URL="https://docker.xuanyuan.me" ;; 
    2) MIRROR_URL="https://mirror.ccs.tencentyun.com" ;; 
    3) MIRROR_URL="https://docker.mirrors.ustc.edu.cn" ;; 
    4) MIRROR_URL="https://hub-mirror.c.163.com" ;; 
    5) MIRROR_URL="https://05f073ad3c0010ea0f4bc00b7105ec20.mirror.swr.myhuaweicloud.com" ;; 
    6) MIRROR_URL="https://registry.aliyuncs.com" ;; 
    7) MIRROR_URL=$(whiptail --title "Tu chinh nguon image" --inputbox "Vui long nhap URL day du cua nguon image:" 10 60 3>&1 1>&2 2>&3) ;; 
    8) MIRROR_URL="" ;; 
esac

if [ -n "$MIRROR_URL" ]; then
    mkdir -p /etc/docker
    if [ -f /etc/docker/daemon.json ]; then
        cp /etc/docker/daemon.json /etc/docker/daemon.json.bak
    fi
    cat > /etc/docker/daemon.json <<EOF
{
    "dns": ["8.8.8.8", "114.114.114.114"],
    "registry-mirrors": ["$MIRROR_URL"]
}
EOF
    whiptail --title "Cau hinh thanh cong" --msgbox "Da them thanh cong nguon image: $MIRROR_URL\nVui long nhan Enter de khoi dong lai dich vu Docker va tiep tuc..." 12 60
    echo "------------------------------------------------------------"
    echo "Bat dau khoi dong lai dich vu Docker..."
    systemctl restart docker.service
fi

# Tao thu muc cai dat
echo "------------------------------------------------------------"
echo "Bat dau tao thu muc cai dat..."
# Kiem tra va tao thu muc du lieu
if [ ! -d /opt/xiaozhi-server/data ]; then
    mkdir -p /opt/xiaozhi-server/data
    echo "Da tao thu muc du lieu: /opt/xiaozhi-server/data"
else
    echo "Thu muc xiaozhi-server/data da ton tai, bo qua buoc tao"
fi

# Kiem tra va tao thu muc model
if [ ! -d /opt/xiaozhi-server/models/SenseVoiceSmall ]; then
    mkdir -p /opt/xiaozhi-server/models/SenseVoiceSmall
    echo "Da tao thu muc model: /opt/xiaozhi-server/models/SenseVoiceSmall"
else
    echo "Thu muc xiaozhi-server/models/SenseVoiceSmall da ton tai, bo qua buoc tao"
fi

echo "------------------------------------------------------------"
echo "Bat dau tai model nhan dang giong noi"
# Tai file model
MODEL_PATH="/opt/xiaozhi-server/models/SenseVoiceSmall/model.pt"
if [ ! -f "$MODEL_PATH" ]; then
    (
    for i in {1..20}; do
        echo $((i*5))
        sleep 0.5
    done
    ) | whiptail --title "Dang tai" --gauge "Bat dau tai model nhan dang giong noi..." 10 60 0
    curl -fL --progress-bar https://modelscope.cn/models/iic/SenseVoiceSmall/resolve/master/model.pt -o "$MODEL_PATH" || {
        whiptail --title "Loi" --msgbox "Tai file model.pt that bai" 10 50
        exit 1
    }
else
    echo "File model.pt da ton tai, bo qua buoc tai"
fi

# Neu khong phai nang cap hoan tat, moi thuc hien tai
if [ -z "$UPGRADE_COMPLETED" ]; then
    check_and_download "/opt/xiaozhi-server/docker-compose_all.yml" "https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/docker-compose_all.yml"
    check_and_download "/opt/xiaozhi-server/data/.config.yaml" "https://ghfast.top/https://raw.githubusercontent.com/xinnan-tech/xiaozhi-esp32-server/refs/heads/main/main/xiaozhi-server/config_from_api.yaml"
fi

# Khoi dong dich vu Docker
(
echo "------------------------------------------------------------"
echo "Dang pull Docker image..."
echo "Dieu nay co the mat vai phut, vui long cho"
docker compose -f /opt/xiaozhi-server/docker-compose_all.yml up -d

if [ $? -ne 0 ]; then
    whiptail --title "Loi" --msgbox "Khoi dong dich vu Docker that bai, vui long thu doi nguon image va chay lai script" 10 60
    exit 1
fi

echo "------------------------------------------------------------"
echo "Dang kiem tra trang thai khoi dong dich vu..."
TIMEOUT=300
START_TIME=$(date +%s)
while true; do
    CURRENT_TIME=$(date +%s)
    if [ $((CURRENT_TIME - START_TIME)) -gt $TIMEOUT ]; then
        whiptail --title "Loi" --msgbox "Khoi dong dich vu timeout, khong tim thay noi dung log mong doi trong thoi gian quy dinh" 10 60
        exit 1
    fi
    
    if docker logs xiaozhi-esp32-server-web 2>&1 | grep -q "Started AdminApplication in"; then
        break
    fi
    sleep 1
done

    echo "Server khoi dong thanh cong! Dang hoan thanh cau hinh..."
    echo "Dang khoi dong dich vu..."
    docker compose -f /opt/xiaozhi-server/docker-compose_all.yml up -d
    echo "Khoi dong dich vu hoan tat!"
)

# Cau hinh khoa bi mat

# Lay dia chi IP cong cong cua server
PUBLIC_IP=$(hostname -I | awk '{print $1}')
whiptail --title "Cau hinh khoa bi mat server" --msgbox "Vui long su dung trinh duyet, truy cap link duoi day, mo Smart Control Console va dang ky tai khoan: \n\nDia chi noi bo: http://127.0.0.1:8002/\nDia chi cong khai: http://$PUBLIC_IP:8002/ (Neu la may chu cloud vui long mo port 8000 8001 8002 trong nhom bao mat server).\n\nNguoi dung dang ky dau tien la Super Admin, cac nguoi dung dang ky sau la nguoi dung thuong. Nguoi dung thuong chi co the bind thiet bi va cau hinh agent; Super Admin co the quan ly model, quan ly nguoi dung, cau hinh tham so, v.v.\n\nSau khi dang ky xong vui long nhan Enter de tiep tuc" 18 70
SECRET_KEY=$(whiptail --title "Cau hinh khoa bi mat server" --inputbox "Vui long dung tai khoan Super Admin dang nhap Smart Control Console\nDia chi noi bo: http://127.0.0.1:8002/\nDia chi cong khai: http://$PUBLIC_IP:8002/\nO menu tren cung Tim tu dien tham so → Quan ly tham so tim ma tham so: server.secret (Khoa bi mat server) \nSao chep gia tri tham so va nhap vao o nhap duoi\n\nVui long nhap khoa bi mat (de trong se bo qua cau hinh):" 15 60 3>&1 1>&2 2>&3)

if [ -n "$SECRET_KEY" ]; then
    python3 -c "
import sys, yaml; 
config_path = '/opt/xiaozhi-server/data/.config.yaml'; 
with open(config_path, 'r') as f: 
    config = yaml.safe_load(f) or {}; 
config['manager-api'] = {'url': 'http://xiaozhi-esp32-server-web:8002/xiaozhi', 'secret': '$SECRET_KEY'}; 
with open(config_path, 'w') as f: 
    yaml.dump(config, f); 
"
    docker restart xiaozhi-esp32-server
fi

# Lay va hien thi thong tin dia chi
LOCAL_IP=$(hostname -I | awk '{print $1}')

# Sua loi lay file log khong duoc ws, doi sang hard code
whiptail --title "Cai dat hoan tat!" --msgbox "\
Cac dia chi lien quan den server nhu sau:\n\
Dia chi truy cap giao dien quan tri: http://$LOCAL_IP:8002\n\
Dia chi OTA: http://$LOCAL_IP:8002/xiaozhi/ota/\n\
Dia chi interface phan tich thi giac: http://$LOCAL_IP:8003/mcp/vision/explain\n\
Dia chi WebSocket: ws://$LOCAL_IP:8000/xiaozhi/v1/\n\
\nCai dat hoan tat! Cam on ban da su dung!\nNhan Enter de thoat..." 16 70