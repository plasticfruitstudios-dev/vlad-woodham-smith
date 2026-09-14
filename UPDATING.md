# How this site works (for future us)

The site is an [Astro](https://astro.build) project — the same codebase as
plasticfruit.co.uk and itsjesslikethat.com, themed for Vlad (black `#000000`, white
text, red accent `#ff0000`, text wordmark, four sections: moving image / stills /
colour / info). Astro is a build tool: it reads the files in `src/` and generates
plain HTML into `dist/`, which is what visitors get. No JavaScript framework runs in
the browser — the output is static HTML, same as the old hand-written site, just
generated instead of copy-pasted.

## Day-to-day

- **Add or edit a project**: edit its file in `src/content/projects/<page>.yaml`
  (credits, titles, image lists — it's all plain text). The build regenerates the
  page, its cards on the grids, and the sitemap.
  - Slug prefixes decide the section: `col-*` pages belong to **colour** (nav +
    back link), everything else with a player to **moving image**, `stills-*` to
    **stills**.
  - A credit line with `day: true` renders as a red sub-heading (e.g. "day i").
  - Film pages use a `vimeo:` block; a non-Vimeo main player (YouTube) uses
    `embed: { src, aspect, title }` instead.
  - Every image needs `alt` text — the build fails without it.
- **Change which cards appear on the home/moving-image/stills/colour grids, or
  their sizes/positions**: edit `src/data/grid-*.json`.
- **New cover loop**: `bash scripts/make-loop.sh <master> <start> <seconds> <name>`
  writes `public/videos/<name>.mp4` plus its poster (frame 0) to both poster folders.
- **Site-wide things** (nav, footer, loader, meta tags): `src/layouts/Base.astro`
  and `src/components/` — each exists exactly once. Name, domain, the default meta
  description and the Person structured data live in `src/lib/site.js`.
- **Styles**: `src/styles/` — `global.css` is shared (colours are the `--bg`,
  `--accent`, `--plate` tokens at the top); the others are per page family.
- **Static files** (videos, stills, fonts, favicon): `public/` — served at the
  same URLs, e.g. `public/videos/x.mp4` → `vladws.com/videos/x.mp4`. Images shown
  on pages also have a copy under `src/assets/` so the build can make AVIF/WebP
  sizes; keep both in sync when replacing a picture.

## Commands

```
npm install      # once per machine (Node version: see .nvmrc)
npm run dev      # local preview at localhost:4321
npm run build    # generate dist/
python3 scripts/verify-dist.py   # check every link/asset/sitemap entry resolves
git push origin main   # deploy — Cloudflare Pages builds and publishes
```

## Deploy (Cloudflare Pages)

Project `vladws` (origin vladws.pages.dev), git-connected to this repo, serving the
apex domain vladws.com (there is no www). Build settings (dashboard → the project →
Settings → Build):
- Build command: `npm run build`
- Build output directory: `dist`

## Maintenance

Dependencies are pinned by `package-lock.json`. About once a quarter, ask Claude to
run a dependency update and verify the build. If the toolchain ever becomes a
problem: `npm run build` and commit the contents of `dist/` as a plain static site —
that's exactly the architecture the site had before, so it's always a safe exit
(the last hand-written version is tagged `pre-astro`).

## What the checks cover (and what they don't)

- The Astro build enforces the content schema — a page missing its description,
  player or alt text fails here. `scripts/verify-dist.py` then checks every
  asset/link/sitemap reference resolves, no file is over Cloudflare Pages' 25 MiB
  limit, and every indexable page carries title/description/canonical. **This
  validates structure, routes and assets — it is not a visual or behavioural test.**
- The migration was verified against the legacy hand-written pages with a
  field-level parity check (titles, meta/OG tags, JSON-LD, credits, back links,
  grid card layout values, sitemap URLs) plus browser screenshots and behaviour
  checks. The pre-Astro HTML is kept locally in `_archive/legacy-html/` (not
  deployed, not in git) and in git at tag `pre-astro`.
- **`scripts/smoke-live.sh`** tests the live URL matrix (http/https, .html,
  trailing slash — one-hop redirects), the old `diamond-store` URLs, real-404
  behaviour, and sitemap/robots. Run it after any deploy that changes routing.
