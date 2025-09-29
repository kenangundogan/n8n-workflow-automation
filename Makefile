# n8n Docker Kurulum Yardımcıları

.PHONY: help setup start stop restart logs status clean backup restore

# Varsayılan hedef
help: ## Bu yardım mesajını göster
	@echo "n8n Docker Kurulum Komutları:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## İlk kurulum (environment dosyası kopyala)
	@echo "🔧 Environment dosyası hazırlanıyor..."
	@cp environment.env .env
	@echo "✅ Kurulum hazır! 'make start' ile başlatabilirsiniz."

start: ## Servisleri başlat
	@echo "🚀 n8n servisleri başlatılıyor..."
	@docker-compose up -d
	@echo "✅ Servisler başlatıldı!"
	@echo "🌐 n8n: http://localhost:5678"
	@echo "👤 Kullanıcı: admin / Şifre: admin123"

stop: ## Servisleri durdur
	@echo "⏹️  Servisler durduruluyor..."
	@docker-compose down
	@echo "✅ Servisler durduruldu!"

restart: stop start ## Servisleri yeniden başlat

logs: ## Logları göster
	@docker-compose logs -f

logs-n8n: ## Sadece n8n loglarını göster
	@docker-compose logs -f n8n

logs-postgres: ## Sadece PostgreSQL loglarını göster
	@docker-compose logs -f postgres

status: ## Servis durumunu kontrol et
	@echo "📊 Servis Durumu:"
	@docker-compose ps
	@echo ""
	@echo "🔗 Bağlantı Testi:"
	@curl -s -o /dev/null -w "n8n Web UI: %{http_code}\n" http://localhost:5678 || echo "n8n Web UI: Erişilemiyor"

clean: ## Tüm verileri temizle (DİKKAT: Veriler silinir!)
	@echo "⚠️  UYARI: Bu işlem tüm verileri silecek!"
	@read -p "Devam etmek istediğinizden emin misiniz? (y/N): " confirm && [ "$$confirm" = "y" ]
	@docker-compose down -v
	@docker volume prune -f
	@echo "🗑️  Veriler temizlendi!"

backup: ## Veritabanını yedekle
	@echo "💾 Veritabanı yedekleniyor..."
	@mkdir -p backups
	@docker-compose exec -T postgres pg_dump -U n8n n8n > backups/n8n_backup_$(shell date +%Y%m%d_%H%M%S).sql
	@echo "✅ Yedek oluşturuldu: backups/ klasörüne bakın"

restore: ## Veritabanını geri yükle (backup dosyası belirtin: make restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then echo "❌ Hata: FILE parametresi gerekli. Örnek: make restore FILE=backup.sql"; exit 1; fi
	@echo "📥 Veritabanı geri yükleniyor: $(FILE)"
	@docker-compose exec -T postgres psql -U n8n -d n8n < $(FILE)
	@echo "✅ Veritabanı geri yüklendi!"

update: ## n8n'i güncelle
	@echo "🔄 n8n güncelleniyor..."
	@docker-compose pull n8n
	@docker-compose up -d n8n
	@echo "✅ n8n güncellendi!"

shell-n8n: ## n8n konteynerine bağlan
	@docker-compose exec n8n sh

shell-postgres: ## PostgreSQL konteynerine bağlan
	@docker-compose exec postgres psql -U n8n -d n8n
