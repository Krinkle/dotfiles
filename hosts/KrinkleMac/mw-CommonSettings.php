<?php
## Project
$wgMetaNamespace = 'Project';
$wgLanguageCode = 'en';
$wgLocaltimezone = 'Europe/Amsterdam';
$wgSitename = false;
$kgMainServer = false;
$kgCluster = false;

$wgShowHostnames = true;

## Database settings
$wgDBtype = 'mysql';
$wgDBserver = 'localhost';
$wgDBname = false;
$wgDBuser = 'root';
$wgDBpassword = 'root';
$wgDBprefix = '';
$wgDBTableOptions = 'ENGINE=InnoDB, DEFAULT CHARSET=binary';
$wgDBmysql5 = false;

## Caching
$wgMainCacheType = CACHE_ANYTHING;
$wgCacheDirectory = $IP . '/cache';
$wgUseLocalMessageCache = true;
$wgInvalidateCacheOnLocalSettingsChange = false;

## Output
$wgUseGzip = true;
$wgWellFormedXml = false;
$wgUseTidy = true;

## Media
$wgEnableUploads = true;
$wgUseInstantCommons = true;

## Local environment
$wgDiff3 = '/usr/bin/diff3';
$mwLogDir = '/var/log/mediawiki';


##
## Wiki ID
##

function kfGetMainServer() {
	global $kgCluster, $wgServer;
	switch ( $kgCluster ) {
		case 'dev':
			return 'http://krinkle.dev';
		case 'no-ip':
		default:
			return $wgServer;
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
	} else {
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

function kfHttpDump( $key, $value ) {
	header( 'X-Debug- ' . $key . ': ' . json_encode( $value ) );
}

if ( true ) {
	error_reporting( -1 );

	// Tools
	$wgDebugToolbar = false;

	// Types
	$wgShowExceptionDetails = true;
	#$wgDebugRedirects = false;
	$wgShowSQLErrors = true;
	#$wgDebugDumpSql = true;
	#$wgMemCachedDebug = false;

	// Log files
	$wgDebugLogFile = "$mwLogDir/debug-{$wgDBname}.log";
	$wgDBerrorLog = "$mwLogDir/dberror.log";
	$wgRateLimitLog = "$mwLogDir/ratelimit.log";
	$wgDebugLogGroups['resourceloader'] = "$mwLogDir/resourceloader.log";
	$wgDebugLogGroups['exception'] = "$mwLogDir/exception.log";
	#$wgDebugLogGroups['somegroup'] = "$mwLogDir/somegroup.log";

	// ResourceLoader
	$wgResourceLoaderDebug = false;
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
	),
);

if ( !in_array( $wgDBname, $wgConf->getLocalDatabases() ) ) {
	if ( php_sapi_name() === 'cli' ) {
		echo "Error: Specify a wiki database.\n";
	} else {
		$mainServerHtml = htmlspecialchars( $kgMainServer );
		$link = strlen( $_SERVER['REQUEST_URI'] ) > 1
			? "<p style=\"text-align: right;\"><a href=\"{$mainServerHtml}\">&raquo; Go to root domain</a></p>"
			: ''
		;
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
$link
</script>
</html>
HTML;
	}

	exit( 1 );
}

list( $project, $lang ) = $wgConf->siteFromDB( $wgDBname );

$dbSuffix = 'wiki';
$globals = $wgConf->getAll( $wgDBname, $dbSuffix, array(
	'lang' => $lang,
	'project' => $project,
	'Project' => ucfirst( $project ),
));
extract( $globals );

##
## Server paths
##

$wgScriptExtension = '.php';
$wgExtensionAssetsPath = '/extensions';
$EP = dirname( $IP ) . '/extensions';
$SP = $IP . '/skins';

if ( php_sapi_name() === 'cli' ) {
	// Sets $wgServer for CLI
	switch ( $kgCluster ) {
		case 'no-ip':
			$wgServer = 'http://wiki.krinkle.dev';
			break;
		case 'dev':
		default:
			$wgServer = "http://$lang.$project.krinkle.dev";
			break;
	}
}

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
		require_once str_replace(
			array( '$EP', '$SP' ),
			array( $EP, $SP ),
			$path
		);
	}
}


##
## Config
##

unset( $wgGroupPermissions['developer'] );

## Uploads
$wgUploadPath = "$wgScriptPath/images";

$wgLogo = "$wgUploadPath/thumb/3/3f/VisualEditor-logo.local.png/135px-VisualEditor-logo.local.png";

## AbuseFilter
$wgGroupPermissions['sysop']['abusefilter-modify'] = true;
$wgGroupPermissions['*']['abusefilter-log-detail'] = true;
$wgGroupPermissions['*']['abusefilter-view'] = true;
$wgGroupPermissions['*']['abusefilter-log'] = true;
$wgGroupPermissions['sysop']['abusefilter-private'] = true;
$wgGroupPermissions['sysop']['abusefilter-modify-restricted'] = true;
$wgGroupPermissions['sysop']['abusefilter-revert'] = true;
// $wgAvailableRights[] = 'abusefilter-view-private';
// $wgAvailableRights[] = 'abusefilter-log-private';
// $wgAvailableRights[] = 'abusefilter-hidden-log';
// $wgAvailableRights[] = 'abusefilter-hide-log';
// $wgAvailableRights[] = 'abusefilter-modify-global';

## ConfirmEdit
$wgCaptchaClass = 'FancyCaptcha';
$wgCaptchaDirectory = "$wgCacheDirectory/captcha";
$wgGroupPermissions['sysop']['skipcaptcha'] =
$wgGroupPermissions['autoconfirmed']['skipcaptcha'] = false;
if ( true ) {
	$wgCaptchaTriggers['edit'] = true;
}
// $ sudo pip install pil
// $ python captcha.py --wordlist /usr/share/dict/words --key {wgCaptchaSecret} --output {wgCaptchaDirectory} --font '/Library/Fonts/Arial Black.ttf'

## Testing
$wgEnableJavaScriptTest = true;
$wgJavaScriptTestConfig['qunit']['testswarm-injectjs'] = $kgMainServer . '/jquery/testswarm/js/inject.js';
$wgLegacyJavaScriptGlobals = false;

## Spam
$wgSpamRegex = '/spam/i';

## Resource origins
$wgAllowUserJs = $wgAllowUserCss = true;
$wgAllowUserCssPrefs = true;
$wgUseSiteJs = $wgUseSiteCss = true;

## EventLogging
$wgEventLoggingBaseUri = 'http://127.0.0.1:8080/event.gif';
$wgEventLoggingFile = $mwLogDir . '/events.log';

## Rights
$wgGroupPermissions['*']['edit'] = true;
$wgGroupPermissions['script'] = $wgGroupPermissions['bot'];
$wgGroupPermissions['developer']['userrights'] = true;
$wgGroupPermissions['developer']['editinterface'] = true;

## Namespaces
$wgNamespacesWithSubpages[NS_MAIN] = true;
$wgNamespacesWithSubpages[NS_TEMPLATE] = true;

## ActivityMonitor
$wgActivityMonitorRCStreamUrl = 'http://stream.wikimedia.org:80/rc';

## VisualEditor
$wgVisualEditorParsoidURL = 'http://localhost:8000/';
$wgVisualEditorParsoidPrefix = $wgDBname;

$wgDefaultUserOptions['visualeditor-enable'] = 1;
$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

## SpamBlacklist
$wgSpamBlacklistFiles = array( 'http://meta.wikimedia.org/w/index.php?title=Spam_blacklist&action=raw&sb_ver=1' );

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

## Scribunto
$wgScribuntoEngineConf['luastandalone']['errorFile'] = "$mwLogDir/lua-error.log";

$wgScribuntoEngineConf['luastandalone']['luaPath'] = '/usr/local/bin/lua';
$wgScribuntoDefaultEngine = 'luastandalone';

// See https://www.mediawiki.org/wiki/Extension:Scribunto#LuaSandbox
$wgScribuntoDefaultEngine = 'luasandbox';

## TemplateData
$wgTemplateDataUseGUI = true;

## WikiEditor
$wgDefaultUserOptions['usebetatoolbar'] = 1;
$wgDefaultUserOptions['usebetatoolbar-cgd'] = 1;
