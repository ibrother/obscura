# obscura

Unofficial Docker image for [obscura](https://github.com/h4ckf0r0day/obscura) — the headless browser for AI agents and web scraping.

Automatically tracks upstream releases. Images are built from pre-compiled binaries and pushed to GitHub Container Registry.

## Quick start

```bash
# Start CDP server on port 9222
docker run --rm -p 9222:9222 ghcr.io/ibrother/obscura:latest

# With stealth mode
docker run --rm -p 9222:9222 ghcr.io/ibrother/obscura:latest serve --port 9222 --stealth

# One-shot fetch
docker run --rm ghcr.io/ibrother/obscura:latest fetch https://example.com --eval "document.title"
```

## Tags

| Tag | Description |
|-----|-------------|
| `latest` | Latest upstream release |
| `v0.1.0` | Pinned version |

## Image details

| Property | Value |
|----------|-------|
| Base image | `gcr.io/distroless/cc-debian12` |
| Architecture | `linux/amd64` |
| Exposed port | `9222` |
| Entrypoint | `obscura` |
| Default command | `serve --port 9222` |

## Usage with Puppeteer / Playwright

```js
// Puppeteer
const browser = await puppeteer.connect({
  browserWSEndpoint: 'ws://127.0.0.1:9222/devtools/browser',
});

// Playwright
const browser = await chromium.connectOverCDP({
  endpointURL: 'ws://127.0.0.1:9222',
});
```

## Docker Compose

```yaml
services:
  obscura:
    image: ghcr.io/ibrother/obscura:latest
    ports:
      - "9222:9222"
    command: ["serve", "--port", "9222", "--stealth"]
    restart: unless-stopped
```

## How it works

```
upstream release (h4ckf0r0day/obscura)
        │
        ▼  sync-upstream.yml (daily cron)
  tag created in this repo
        │
        ▼  docker-publish.yml (on tag push)
  download obscura-x86_64-linux.tar.gz
        │
        ▼
  docker buildx → ghcr.io
```

Two workflows handle the automation:

- **`sync-upstream.yml`** — runs daily, checks for new upstream releases, and creates a matching tag in this repo.
- **`docker-publish.yml`** — triggers on tag push, downloads the upstream binary via `robinraju/release-downloader`, builds a distroless image, and pushes to `ghcr.io`.

## License

This repository contains only build tooling. The obscura binary is distributed under the [Apache-2.0 license](https://github.com/h4ckf0r0day/obscura/blob/main/LICENSE) by the original authors.