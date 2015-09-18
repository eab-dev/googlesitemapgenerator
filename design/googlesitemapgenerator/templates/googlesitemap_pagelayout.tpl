<?xml version="1.0" encoding="UTF-8"?>
{if eq($module_result.ui_component, 'googlesitemap')} 
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" >
{else}
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" 
		xmlns:n="http://www.google.com/schemas/sitemap-news/0.9">
{/if}
{$module_result.content}
</urlset>