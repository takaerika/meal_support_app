#!/usr/bin/env bash
set -euo pipefail
export RAILS_ENV=production
echo "[render-start] rails db:migrate"
bundle exec rails db:migrate
echo "[render-start] boot app (puma)"
exec bundle exec puma -C config/puma.rb