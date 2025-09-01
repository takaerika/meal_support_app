#!/usr/bin/env bash
set -euo pipefail

echo "[render-build] bundle install"
bundle install --without development test --path vendor/bundle
echo "[render-build] assets:precompile (RAILS_ENV=production)"
export RAILS_ENV=production
bundle exec rake assets:precompile
bundle exec rake assets:clean
echo "[render-build] done"