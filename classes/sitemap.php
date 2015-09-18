<?php 

require_once( 'kernel/common/template.php' );
class sitemap
{
	function sitemap()
	{
		$this->ini = eZINI::instance( 'googlesitemapgenerator.ini' );
		$this->siteIni = eZINI::instance( 'site.ini' );
	}
	function genereate( $nodeID=2)
	{
		$tpl 	= templateInit();
		$tpl->setVariable( "start_node_id", $nodeID );
		$tpl->setVariable( "sitemap_siteurl", $this->siteIni->variable( 'SiteSettings', 'SiteURL' ) . '/' );
		$data 	= $tpl->fetch( "design:googlesitemap/generate.tpl" );
		
		$dataToFile = '<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.google.com/schemas/sitemap/0.9">' . $data . '</urlset>';
		$file = $this->ini->variable( 'PathSettings', 'StaticSitemapFile' );
		
	
		   if (!$handle = fopen($file, 'w+')) {
		   		echo 'Error: Could not open file ' .$file. ' for writing.'.PHP_EOL;
				 return false;
				 exit;
		   }
		
		   // Write $somecontent to our opened file.
		   if (fwrite($handle, $dataToFile) === FALSE) {
			echo 'error';
		   }
		echo "\t file created: " . $file. PHP_EOL; 
		   fclose($handle);
		$this->ping($file);
	}
	function ping($filepath)
	{
		$file=substr($filepath, strrpos($filepath, "/")+1);
		$siteurl = $this->siteIni->variable( 'SiteSettings', 'SiteURL' );
		if (strpos($siteurl, "index.php")!==false) $siteurl = substr($siteurl, 0, strrpos($siteurl, "index.php"));
		$i = strlen($siteurl)-1; 
		if($siteurl[$i] !== "/") $siteurl .= "/" ;
		$pingurl = 'http://www.google.com/webmasters/tools/ping?sitemap=';
		$sitemap = 'http://' . $siteurl .$file;
		echo "\t file to ping to : ". $sitemap .PHP_EOL;
		$ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $pingurl.$sitemap);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        $output = curl_exec($ch);
        curl_close($ch);	
	}
}
?>