<?php

require_once( 'kernel/common/template.php' );

$googlesitemapgeneratorINI = eZINI::instance( 'googlesitemapgenerator.ini' );
$ezPublishDir = $googlesitemapgeneratorINI->variableArray( 'PathSettings', 'EZPublishDirectory' );

$Module = $Params['Module'];
if ( isset( $Params["NodeID"] ) ) {
	$NodeID = $Params["NodeID"];
}
else {
	$NodeID = 2;
}

$tpl = templateInit();

$tpl->setVariable( "start_node_id", $NodeID );

header( 'Content-Type: text/xml' );

$Result = array();
$Result['content'] = $tpl->fetch( "design:googlesitemap/generate.tpl" );

?>
