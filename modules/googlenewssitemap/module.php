<?php

$Module = array( "name" => "googlenewssitemap" );

$ViewList = array();
$ViewList['generate'] = array(
 							'script' => 'generate.php',
						    'functions' => array( 'generate' ),
						    'params' => array( 'NodeID' ) );

$FunctionList['generate'] = array( );
?>