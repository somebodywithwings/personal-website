---
title: "Docs"
---

## Stack

Static site built with [Hugo](https://gohugo.io), deployed on Cloudflare Workers (via Workers Builds, triggered on every push to `main`). No backend, no database — everything is markdown files compiled to static HTML.

Repo structure:

```
content/
  _index.md          → homepage (about page)
  blog/               → blog posts
  knowledge/          → Obsidian vault — notes and reference write-ups
  novels/
    <novel-slug>/
      _index.md       → novel intro page
      chapter-01.md   → chapters, ordered by "weight" in frontmatter
  docs/
    _index.md         → this page
layouts/               → HTML templates (Hugo)
static/
  css/style.css        → all site styling
  images/logo.png       → site logo / favicon source
wrangler.jsonc          → Cloudflare Workers deploy config
build.sh                 → installs Hugo and runs the build on Cloudflare
hugo.yaml                → site config (title, menu, etc.)
```

## Posting a blog entry

```
hugo new blog/my-post-title.md
```
Or just create the file by hand in `content/blog/`. Minimum frontmatter:
```
---
title: "My Post Title"
date: 2026-07-20
---
```
Write the body in markdown below the `---`. Push to `main` — Cloudflare rebuilds and deploys automatically, usually within a minute or two.

**Date gotcha:** Hugo hides posts with a future date relative to the build server's clock (UTC). If you set today's date and it doesn't show up immediately, it's not broken — it'll appear once UTC catches up, or just backdate by a day to be safe.

## Adding a knowledge note

Write it directly in Obsidian, inside the `content/knowledge/` vault. Give it frontmatter (title + date) like the blog example above. Commit and push the same way. Obsidian's `[[wikilinks]]` don't render as working links on the site — use standard markdown links (`[text](/knowledge/slug/)`) if you want to cross-link notes.

## Adding a new novel

```
content/novels/<slug>/_index.md      → novel title + short intro
content/novels/<slug>/chapter-01.md  → weight: 1
content/novels/<slug>/chapter-02.md  → weight: 2
```
`weight` controls chapter order (not date). Each chapter page automatically gets prev/next chapter navigation at the bottom, generated from sibling pages sorted by weight.

## Local preview

Install Hugo, then from the repo root:
```
hugo server -D
```
Visit `http://localhost:1313`. Changes to content or templates hot-reload.

## Deploying

Every push to `main` triggers a Cloudflare Workers Build automatically:
1. Clones the repo
2. Runs `build.sh` (installs Hugo, runs `hugo --minify` → outputs to `public/`)
3. Runs `npx wrangler deploy`, which uploads `public/` as the live site

No manual deploy step needed under normal use. To deploy manually from your machine instead: `npx wrangler login` once, then `npx wrangler deploy` from the repo root.

## Site-wide settings

`hugo.yaml` controls the site title, top nav menu, and description. `static/css/style.css` is the entire stylesheet — no build step, no framework, just plain CSS with a few custom properties (`--bg`, `--fg`, `--accent`, etc.) for easy recoloring, including automatic dark mode via `prefers-color-scheme`.

## RTL / Farsi pages

Add `direction: rtl` to any page's frontmatter to flip that specific page to right-to-left layout. To add a real Farsi web font (e.g. Vazirmatn) site-wide, add its `<link>` tag in `layouts/partials/header.html`.
