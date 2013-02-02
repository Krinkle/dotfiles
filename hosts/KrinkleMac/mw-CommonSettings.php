<?php

## Project
$wgMetaNamespace = 'Project';
$wgLanguageCode = 'en';
$wgSitename = false;

## Database settings
$wgDBtype           = 'mysql';
$wgDBserver         = 'localhost';
$wgDBname           = false;
$wgDBuser           = 'root';
$wgDBpassword       = 'root';
$wgDBprefix         = '';
$wgDBTableOptions   = 'ENGINE=InnoDB, DEFAULT CHARSET=binary';
$wgDBmysql5         = false;

## Caching
$wgMainCacheType = CACHE_ANYTHING;
$wgMemCachedServers = array();
$wgCacheDirectory = $IP . '/cache';
$wgUseLocalMessageCache = true;

## Media
$wgEnableUploads  = false;
$wgUseInstantCommons  = true;

## Local environment
$wgDiff3 = '/usr/bin/diff3';


##
## Wiki ID
##

if ( defined( 'MW_DB' ) ) {
	$wgDBname = MW_DB;
	$kgServerTLD = 'krinkle.dev';
} elseif ( isset( $_SERVER['HTTP_HOST'] ) ) {
	$m = null;
	preg_match(
		'/(.+?).(wikipedia).(krinkle.dev|krinkle.no-ip.org)/',
		$_SERVER['HTTP_HOST'],
		$m
	);
	if ( isset( $m[1] ) ) {
		$wgDBname = $m[1] . 'wiki';
		$kgServerTLD = $m[3];
	}
}


##
## Server paths
##

$wgScriptExtension  = '.php';
$wgArticlePath = '/wiki/$1';
$wgScriptPath = '/w';
$wgExtensionAssetsPath = '/extensions';
$EP = dirname( $IP ) . '/extensions';

if ( isset( $kfExtensions ) ) {
	foreach ( $kfExtensions as $path ) {
		require_once( str_replace( '$EP', $EP, $path ) );
	}
}

##
## Debug
##

if ( true ) {
	error_reporting( -1 );

	# Tools
	$wgDebugToolbar = false;

	# Types
	$wgShowExceptionDetails = true;

	#$wgDebugRedirects = false;

	#$wgShowSQLErrors = true;
	#$wgDebugDumpSql  = true;

	#$wgMemCachedDebug = false;

	# Log files
	$mwLogDir = '/var/log/mediawiki';

	$wgDBerrorLog = "$mwLogDir/dberror.log";
	$wgRateLimitLog = "$mwLogDir/ratelimit.log";
	$wgDebugLogFile = "$mwLogDir/debug.log";
	#$wgDebugLogGroups['x'] = "$mwLogDir/debug-x.log";

	# ResourceLoader
	$wgResourceLoaderMaxage['versioned']['server'] = 1;
	$wgResourceLoaderMaxage['versioned']['client'] = 1;
	$wgResourceLoaderMaxage['unversioned']['server'] = 1;
	$wgResourceLoaderMaxage['unversioned']['client'] = 1;
}


##
## Profiler
##

if ( true ) {

	$wgProfiler['class'] = 'Profiler';

	# maintenance/archives/patch-profiling.sql
	$wgProfileToDatabase = true;

	# profileinfo.php
	$wgEnableProfileInfo = true;
}


##
## Wiki config
##

$wgConf->suffixes = array(
	// 'wikipedia',
	'wiki',
);

$wgConf->wikis = array(
	'alphawiki',
	'betawiki',
	'gammawiki',
);

$wgConf->settings = array(
	'wgSitename' => array(
		'default' => '$lang.$Project',
		'alphawiki' => 'Wikipedia 2.0alpha',
	),
	'wgResourceLoaderSources' => array(
		'+alphawiki' => array(
			'betawiki' => array(
				'loadScript' => '//beta.wikipedia.$tld/w/load.php',
				'apiScript' => '//beta.wikipedia.$tld/w/api.php',
			),
		),
		'+betawiki' => array(
			'alphawiki' => array(
				'loadScript' => '//alpha.wikipedia.$tld/w/load.php',
				'apiScript' => '//alpha.wikipedia.$tld/w/api.php',
			),
		),
	),
	'wgGadgetRepositories' => array(
		'+alphawiki' => array(
			array(
				'class' => 'ForeignAPIGadgetRepo',
				'source' => 'betawiki',
			),
		),
	),
);

if ( !in_array( $wgDBname, $wgConf->getLocalDatabases() ) ) {
	if ( php_sapi_name() === 'cli' ) {
		echo "Error: Specify a wiki database.\n";
	} else {
		echo <<<HTML
<!DOCTYPE html>
<html lang=en>
<meta charset="utf-8">
<title>Unconfigured domain</title>
<style>
* { margin: 0; padding: 0; }
body { background: #fff; margin: 7% auto 0; padding: 2em 1em 1em; font: 14px/21px sans-serif; color: #333; max-width: 560px; }
img { float: left; margin: 0 2em 2em 0; }
a img { border: 0; }
h1 { margin-top: 1em; font-size: 1.2em; }
p { margin: 0.7em 0 1em 0; }
a { color: #0645AD; text-decoration: none; }
a:hover { text-decoration: underline; }
em { font-style: normal; color: #777; }
</style>
<h1>Domain not configured</h1>
<p>This domain points to the Krinkle Dev server, but is not configured in Apache.<br><em>That’s all we know.</em></p>
<script>
	var a = document.createElement('a');
	a.href = '//' + location.host.split('.').slice(-2).join('.');
	a.innerHTML = '&raquo; Go to root domain';
	document.write('<p style="text-align: right;">' + a.outerHTML + '</p>');
</script>
</html>
HTML;
	}

	exit( 1 );
}

list( $project, $lang ) = $wgConf->siteFromDB( $wgDBname );

$wgServer = "//$lang.$project.$kgServerTLD";

$dbSuffix = 'wiki';
$globals = $wgConf->getAll( $wgDBname, $dbSuffix, array(
	'lang'    => $lang,
	'project'    => $project,
	'Project'    => ucfirst( $project ),
	'tld'     => $kgServerTLD
));
extract( $globals );


##
## Config
##

unset( $wgGroupPermissions['developer'] );

# Core

## Testing
$wgEnableJavaScriptTest = true;
$wgJavaScriptTestConfig['qunit']['testswarm-injectjs'] = 'http://' . $kgServerTLD . '/jquery/testswarm/js/inject.js';
$wgLegacyJavaScriptGlobals = false;

## Rights
$wgGroupPermissions['*']['edit'] = true;
$wgGroupPermissions['script'] = $wgGroupPermissions['bot'];
$wgGroupPermissions['developer']['userrights']  = true;
$wgGroupPermissions['developer']['editinterface']  = true;

## Vector
$wgVectorUseSimpleSearch = true;
$wgVectorUseIconWatch = true;

## VisualEditor
$wgVisualEditorParsoidURL = 'http://localhost:8000/';

define( 'NS_VISUALEDITOR', 2500 );
define( 'NS_VISUALEDITOR_TALK', 2501 );
$wgExtraNamespaces[NS_VISUALEDITOR] = 'VisualEditor';
$wgExtraNamespaces[NS_VISUALEDITOR_TALK] = 'VisualEditor_talk';
$wgVisualEditorNamespaces[] = NS_VISUALEDITOR;

$wgDefaultUserOptions['visualeditor-enable'] = 1;
$wgHiddenPrefs[] = 'visualeditor-enable';

## OnlineStatusBar
$wgOnlineStatusBarDefaultEnabled = true;

## MaintenanceShell
$wgGroupPermissions['developer']['maintenanceshell'] = true;

## Gadgets
$wgGadgetEnableSharing = true;

$wgGroupPermissions['gadgetartists']['gadgets-edit'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-create'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-edit'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-delete'] = true;

## Naryam
$wgNarayamEnabledByDefault = true;

## Interwiki
$wgGroupPermissions['developer']['interwiki'] = true;

