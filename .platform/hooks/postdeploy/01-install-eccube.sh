#!/bin/bash

APP_DIR="/var/www/html"
DB_DIR="/var/lib/eccube"
DB_PATH="$DB_DIR/eccube.db"
USER="webapp"
ENV_FILE="$APP_DIR/.env"
ENV_INSTALL_FILE="$APP_DIR/.env.dist"

# .env がない場合のみ .env.dist からコピー
if [ ! -f "$ENV_FILE" ] && [ -f "$ENV_INSTALL_FILE" ]; then
  echo ".env が見つかりません。.env.dist からコピーします..."
  cp "$ENV_INSTALL_FILE" "$ENV_FILE"
  chown webapp:webapp "$ENV_FILE"
  chmod 644 "$ENV_FILE"
fi

# SQLite データベースが存在しない場合は初回デプロイ
if [ ! -f "$DB_PATH" ]; then
  echo "EC-CUBE のデータベースが見つかりません。初回インストールを実行します..."

  sudo -u $USER php $APP_DIR/bin/console eccube:install --no-interaction

else
  echo "既存のデータベースが見つかりました。マイグレーションを実行します..."

  sudo -u $USER php $APP_DIR/bin/console doctrine:migrations:migrate --no-interaction

  # キャッシュクリア
  sudo -u $USER php $APP_DIR/bin/console cache:clear
fi
