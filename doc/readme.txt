GoogleSitemapGenerator Extension
README

Name   : GoogleSitemapGenerator Extension
Version: 3.0.0
Author : MEDIATA Communications GmbH (enhanced with Newssitemap-Module by H.Lindlbauer, lbm-services.de)
Date   : 2009-02-13 / 2010-04-24

Version: 3.2.0
Updated: 2010-04-28
Author : Netmaking AS (cronjob), 
		 Horst Lindlbauer, lbm-services.de (news sitemap module)


1. Description

	The GoogleSitemapGenerator extension generates a xml-sitemap conform to the Google-sitemap-protocol.
	(https://www.google.com/webmasters/tools/docs/en/protocol.html)

	GoogleSitemapGenerator is tested with eZ Publish 4.2.0


2. Installation + configuration

	Please read install.txt for installation and configuration instructions.


3. Using GoogleSitemapGenerator

	3.1 Browse URL http://<eZ Publish path>/<siteaccess>/layout/set/google/googlesitemap/generate/<NodeID>

	Depending on your configuration <siteaccess> is optional!

	    Examples:
	    	1. http://www.example.com/cms/index.php/<siteaccess>/layout/set/google/googlesitemap/generate/123
	    	   The sitemap of the <siteaccess> siteaccess will be displayed, beginning with node 123.
	    	   URLs inside the sitemap look like: http://www.example.com/<path_to_ez_publish_root>/index.php/<siteaccess>/<url_alias_of_node>

	3.2 Register account and login into Google Sitemaps
        https://www.google.com/webmasters/sitemaps/

    3.3 Add your site to Google Sitemaps

    3.4 Append sitemap of your site
    
    
4. Generating Google News Sitemaps according to http://www.google.com/support/webmasters/bin/answer.py?hl=en&answer=74288

	4.1 Browse URL http://<eZ Publish path>/<siteaccess>/layout/set/google/googlenewssitemap/generate/<NodeID>
	
	4.2 Don't forget to adjust additional settings in googlesitemapgenerator.ini.append.php, section 'NewsSitemapSettings' to your needs
	
	4.3 steps 3.2 to 3.4 apply for NewsSitemaps as well, carefully read Google's instructions for submitting news to 
		Google News, provided here: http://www.google.com/support/webmasters/bin/answer.py?answer=74289


5. Using GoogleSitemapGenerator as cronjob
	
	Note that it is not recommended to generate a news sitemap by cronjob. So the cronjob creates a conventional sitemap only.
	If you submit your news sitemap url (see step 4) to Google, it will always retrieve an up-to-date sitemap, because news sitemaps are not cached.
	
	5.1 Set the path and name of StaticSitemapFile in googlesitemapgenerator.ini 
	
	5.2 Set up your crontab with following script: php runcronjobs.php generate-sitemap -s
		
		  