# n8n Docker Kurulumu

Bu proje, n8n workflow automation aracını Docker ile yerel olarak çalıştırmanızı sağlar.

## Gereksinimler

- Docker (20.10.0 veya üzeri)
- Docker Compose (2.0.0 veya üzeri)

### Platform Desteği
- ✅ Intel/AMD64 sistemler
- ✅ Apple Silicon (M1/M2) Mac'ler
- ✅ Linux (x86_64)
- ✅ Windows (WSL2 ile)

## Kurulum

### 1. Projeyi İndirin
```bash
git clone https://github.com/kenangundogan/n8n-workflow-automation.git
cd n8n
```

### 2. Environment Dosyasını Hazırlayın
```bash
cp environment.env .env
```

**Önemli:** Üretim ortamında `environment.env` dosyasındaki şifreleri değiştirin!

### 3. Docker Konteynerlerini Başlatın

**Seçenek A: Makefile ile (Önerilen)**
```bash
make setup  # İlk kurulum
make start  # Servisleri başlat
```

**Seçenek B: Docker Compose ile**
```bash
docker-compose up -d
```

### 4. n8n'e Erişin
Tarayıcınızda şu adrese gidin: http://localhost:5678

**İlk Kurulum:**
- İlk erişimde hesap oluşturma ekranı açılacak
- Email ve güçlü şifre ile hesabınızı oluşturun

## Kullanım

### Makefile Komutları (Önerilen)
```bash
make help          # Tüm komutları listele
make start         # Servisleri başlat
make stop          # Servisleri durdur
make restart       # Servisleri yeniden başlat
make logs          # Tüm logları göster
make logs-n8n      # Sadece n8n logları
make status        # Servis durumunu kontrol et
make backup        # Veritabanını yedekle
make restore FILE=backup.sql  # Veritabanını geri yükle
make clean         # Tüm verileri temizle (DİKKAT!)
make update        # n8n'i güncelle
```

### Manuel Docker Compose Komutları

#### Konteynerları Durdurma
```bash
docker-compose down
```

#### Logları Görüntüleme
```bash
docker-compose logs -f n8n
```

#### Veritabanı Yedekleme
```bash
docker-compose exec postgres pg_dump -U n8n n8n > backup.sql
```

#### Veritabanı Geri Yükleme
```bash
docker-compose exec -T postgres psql -U n8n -d n8n < backup.sql
```

## Yapılandırma

### Environment Değişkenleri

| Değişken | Açıklama | Varsayılan |
|----------|----------|------------|
| `POSTGRES_USER` | PostgreSQL kullanıcı adı | n8n |
| `POSTGRES_PASSWORD` | PostgreSQL şifresi | N8n_P0stgr3s_S3cur3_K3y_2025_X7Z |
| `POSTGRES_DB` | PostgreSQL veritabanı adı | n8n |
| `GENERIC_TIMEZONE` | Zaman dilimi | Europe/Istanbul |

### Portlar

- **n8n Web Interface:** 5678
- **PostgreSQL:** 5432 (sadece konteyner içi)

## Veri Kalıcılığı

Verileriniz Docker volume'larında saklanır:
- `n8n_data`: n8n workflow'ları ve ayarları
- `postgres_data`: PostgreSQL veritabanı

## Sorun Giderme

### Konteynerlar başlamıyor
```bash
# Tüm logları görüntüle
docker-compose logs

# Sadece n8n logları
docker-compose logs n8n

# Canlı log takibi
docker-compose logs -f
```

### n8n konteyneri yeniden başlatılıyor (Exit Code 139)
Bu genellikle Apple Silicon Mac'lerde görülür. Docker Compose dosyasında `platform: linux/amd64` satırının olduğundan emin olun.

### Veritabanı bağlantı sorunu
```bash
# PostgreSQL bağlantısını test et
docker-compose exec postgres psql -U n8n -d n8n -c "SELECT 1;"

# PostgreSQL durumunu kontrol et
docker-compose exec postgres pg_isready -U n8n -d n8n
```

### n8n'e erişilemiyor
```bash
# Port kullanımını kontrol et
lsof -i :5678

# Konteyner durumunu kontrol et
docker-compose ps

# n8n servisini test et
curl -I http://localhost:5678
```

### Docker volume sorunları
```bash
# Volume'ları temizle (DİKKAT: Tüm veriler silinir!)
docker-compose down -v
docker volume prune

# Yeniden başlat
docker-compose up -d
```

### Performans sorunları
- Docker Desktop'ta kaynak limitlerini artırın (RAM: 4GB+, CPU: 2+ core)
- Disk alanının yeterli olduğundan emin olun (minimum 2GB boş alan)

## Güvenlik

⚠️ **Önemli Güvenlik Notları:**

1. Üretim ortamında varsayılan şifreleri değiştirin
2. HTTPS kullanın (reverse proxy ile)
3. Güvenlik duvarı kurallarını yapılandırın
4. Düzenli yedekleme yapın

## Destek

Sorunlar için GitHub Issues kullanın veya n8n dokümantasyonunu inceleyin:
- [n8n Dokümantasyonu](https://docs.n8n.io/)
- [n8n Community](https://community.n8n.io/)

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE.md](LICENSE.md) dosyasına bakın.

## Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## Yazar

**Kenan Gündoğan** - *İlk geliştirici* - [GitHub](https://github.com/kenangundogan)
