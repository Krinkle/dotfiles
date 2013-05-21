<?php

## Project
$wgMetaNamespace = 'Project';
$wgLanguageCode = 'en';
$wgSitename = false;
$kgMainServer = false;
$kgCluster = false;

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

## Output
$wgWellFormedXml = false;

## Media
$wgEnableUploads  = false;
$wgUseInstantCommons  = true;

## Local environment
$wgDiff3 = '/usr/bin/diff3';


##
## Wiki ID
##

function kfGetMainServer() {
	global $kgCluster;
	switch ( $kgCluster ) {
		case 'no-ip':
			return 'http://krinkle.no-ip.org';
		case 'dev':
			return 'http://krinkle.dev';
		default:
			return false;
	}
}

if ( defined( 'MW_DB' ) ) {
	$wgDBname = MW_DB;
	$kgCluster = 'dev';
} elseif ( getenv( 'MW_DB' ) !== false ) {
	$wgDBname = getenv( 'MW_DB' );
	$kgCluster = 'dev';
} elseif ( isset( $_SERVER['HTTP_HOST'] ) ) {
	$kgCluster = 'dev';
	$m = null;
	preg_match(
		'/(.+?)\.(wikipedia)\.krinkle\.dev/',
		$_SERVER['HTTP_HOST'],
		$m
	);
	if ( isset( $m[1] ) ) {
		$wgDBname = $m[1] . 'wiki';

	// No-IP Free doesn't have wildcard and uses subdirectories instead
	} elseif ( $_SERVER['HTTP_HOST'] === 'krinkle-wiki.no-ip.org' || $_SERVER['HTTP_HOST'] === 'wiki.krinkle.dev' ) {
		$kgCluster = 'no-ip';
		preg_match(
			'#([^/]+)#',
			$_SERVER['REQUEST_URI'],
			$m
		);
		if ( isset( $m[1] ) ) {
			$wgDBname = $m[1];
		}
	}
}

$kgMainServer = kfGetMainServer();

##
## Debug
## http://www.mediawiki.org/wiki/Manual:How_to_debug
##

if ( true ) {
	error_reporting( -1 );

	// Tools
	$wgDebugToolbar = false;

	// Types
	$wgShowExceptionDetails = true;
	#$wgDebugRedirects = false;
	#$wgShowSQLErrors = true;
	#$wgDebugDumpSql  = true;
	#$wgMemCachedDebug = false;

	// Log files
	$mwLogDir = '/var/log/mediawiki';
	$wgDBerrorLog = "$mwLogDir/dberror.log";
	#$wgRateLimitLog = "$mwLogDir/ratelimit.log";
	$wgDebugLogFile = "$mwLogDir/debug.log";
	#$wgDebugLogGroups['somegroup'] = "$mwLogDir/debug-somegroup.log";

	// ResourceLoader
	$wgDebugRawPage = true; // wmbug.com/47960
	$wgResourceLoaderMaxage['versioned']['server'] = 1;
	$wgResourceLoaderMaxage['versioned']['client'] = 1;
	$wgResourceLoaderMaxage['unversioned']['server'] = 1;
	$wgResourceLoaderMaxage['unversioned']['client'] = 1;
}


##
## Profiler
##

if ( false ) {

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
	)
);

if ( !in_array( $wgDBname, $wgConf->getLocalDatabases() ) ) {
	if ( php_sapi_name() === 'cli' ) {
		echo "Error: Specify a wiki database.\n";
	} else {
		$mainServerHtml = htmlspecialchars( $kgMainServer );
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
<p style="text-align: right;"><a href="{$mainServerHtml}">&raquo; Go to root domain</a></p>
</script>
</html>
HTML;
	}

	exit( 1 );
}

list( $project, $lang ) = $wgConf->siteFromDB( $wgDBname );

$dbSuffix = 'wiki';
$globals = $wgConf->getAll( $wgDBname, $dbSuffix, array(
	'lang'    => $lang,
	'project'    => $project,
	'Project'    => ucfirst( $project ),
));
extract( $globals );


##
## Server paths
##

$wgScriptExtension  = '.php';
$wgExtensionAssetsPath = '/extensions';
$EP = dirname( $IP ) . '/extensions';

switch ( $kgCluster ) {
	case 'no-ip':
		$wgArticlePath = "/$wgDBname/wiki/$1";
		$wgScriptPath = "/$wgDBname/w";
		break;
	case 'dev':
	default:
		$wgArticlePath = '/wiki/$1';
		$wgScriptPath = '/w';
}


if ( isset( $kfExtensions ) ) {
	foreach ( $kfExtensions as $path ) {
		require_once str_replace( '$EP', $EP, $path );
	}
}


##
## Config
##

unset( $wgGroupPermissions['developer'] );

## Testing
$wgEnableJavaScriptTest = true;
$wgJavaScriptTestConfig['qunit']['testswarm-injectjs'] = $kgMainServer . '/jquery/testswarm/js/inject.js';
$wgLegacyJavaScriptGlobals = false;

## Resource origins
$wgAllowUserJs = false;
$wgAllowUserCss = false;
$wgAllowUserCssPrefs = true;
$wgUseSiteJs = true;
$wgUseSiteCss = true;

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
$wgVisualEditorEnableExperimentalCode = true;

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

