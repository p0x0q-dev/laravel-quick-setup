# laravel-quick-setup

このリポジトリは，Laravel環境のDockerビルドが遅い問題を受け，
laravel/php/composer/npm/apacheのビルド済みイメージを提供することを目的としています。

- 2026-05-28: Deploy pipeline verification rebuild

## タグ

| タグ | ベース | 備考 |
|---|---|---|
| `p0x0q/laravel-quick-setup:php8.3-apache` | `php:8.3-apache` | PHP2Shell (CVE-2026-109618/109619) 対応の移行先。新規・移行はこちらを使う |
| `p0x0q/laravel-quick-setup:php8.1-apache` | `php:8.1-apache` | 従来タグ (互換のため残置) |

`main` への push に加え、週次 (日曜 18:00 UTC) と手動 (`workflow_dispatch`) でも両タグをリビルドし、公式イメージのセキュリティ修正を取り込む。
