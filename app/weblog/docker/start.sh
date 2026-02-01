#!/bin/sh
set -e

echo "Starting Laravel application..."

# Wait for database to be ready (if DB_HOST is set)
if [ -n "$DB_HOST" ]; then
    echo "Waiting for database at $DB_HOST..."
    for i in $(seq 1 30); do
        if nc -z "$DB_HOST" 3306 2>/dev/null; then
            echo "Database is ready!"
            break
        fi
        echo "Waiting for database... attempt $i/30"
        sleep 2
    done
fi

# Run Laravel setup commands
cd /var/www/html

# Generate key if not set
if [ -z "$APP_KEY" ] || [ "$APP_KEY" = "base64:" ]; then
    echo "Generating application key..."
    php artisan key:generate --force
fi

# Clear and cache configuration
echo "Caching configuration..."
php artisan config:cache || true
php artisan route:cache || true
php artisan view:cache || true

# Run migrations (with force for production)
echo "Running database migrations..."
php artisan migrate --force || echo "Migration failed or database not available"

# Create storage link
echo "Creating storage link..."
php artisan storage:link --force || true

echo "Laravel setup complete!"

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
