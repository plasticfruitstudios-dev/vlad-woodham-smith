import type { APIRoute } from 'astro';
import { getCollection } from 'astro:content';

// Same URL set and format as the hand-maintained legacy sitemap.xml:
// homepage + the four sections + info + every project page. 404 stays out.
// Served at /sitemap.xml, which GSC already has on file.
export const GET: APIRoute = async () => {
  const projects = await getCollection('projects');
  // Bump when content meaningfully changes; a per-build timestamp would restamp
  // all 29 URLs every deploy and devalue the lastmod signal in GSC.
  const lastmod = '2026-07-15';
  const urls = [
    '', 'moving-image', 'stills', 'colour', 'info',
    ...projects.map((p) => p.id).sort(),
  ];
  const body =
    '<?xml version="1.0" encoding="UTF-8"?>\n' +
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' +
    urls.map((u) =>
      `  <url>\n    <loc>https://vladws.com/${u}</loc>\n    <lastmod>${lastmod}</lastmod>\n  </url>`
    ).join('\n') +
    '\n</urlset>\n';
  return new Response(body, { headers: { 'Content-Type': 'application/xml' } });
};
