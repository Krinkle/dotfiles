<?php
##
## Prepare site config
##
$wgPortalServer = false;
$kgCluster = false;
$kgLogDir = '/var/log/mediawiki';

// Extract wgDBname and kgCluster
if ( defined( 'MW_DB' ) ) {
	$kgCluster = 'dev';
	$wgDBname = MW_DB;
} elseif ( getenv( 'MW_DB' ) !== false ) {
	$kgCluster = 'dev';
	$wgDBname = getenv( 'MW_DB' );
} elseif ( isset( $_SERVER['HTTP_HOST'] ) ) {
	// Example: http://alpha.wikipedia.krinkle.dev/w
	$m = null;
	preg_match(
		'/(.+?)\.(wikipedia)\.krinkle\.dev/',
		$_SERVER['HTTP_HOST'],
		$m
	);
	if ( isset( $m[1] ) ) {
		$kgCluster = 'dev';
		$wgDBname = $m[1] . 'wiki';

	} else {
		// When wildcard domains can't be used (e.g. No-IP, or libraries
		// that require hostname to be 'localhost' such as Google reCAPTCHA)
		// Example: http://localhost/alphawiki/w
		$m = null;
		preg_match( '#([^/]+)#', $_SERVER['REQUEST_URI'], $m );
		if ( isset( $m[1] ) ) {
			$kgCluster = 'no-wildcard';
			$wgDBname = $m[1];
		}
	}
}

$wgPortalServer = $kgCluster === 'dev' ? 'http://krinkle.dev' : $wgServer;

// Must be called after setting $wgConf->wikis
function kfGetServerInfos() {
	global $kgCluster, $wgConf;
	$vars = array();
	foreach ( $wgConf->wikis as $dbname ) {
		if ( $kgCluster === 'dev' ) {
			$vars[ 'wgCanonicalServer' ][ $dbname ] = 'http://$lang.wikipedia.krinkle.dev';
			$vars[ 'wgScriptPath' ][ $dbname ] = '/w';
			$vars[ 'wgArticlePath' ][ $dbname ] = '/wiki/$1';
		} elseif ( $kgCluster === 'no-wildcard' ) {
			$vars[ 'wgCanonicalServer' ][ $dbname ] = false;
			$vars[ 'wgScriptPath' ][ $dbname ] = "/$dbname/w";
			$vars[ 'wgArticlePath' ][ $dbname ] = "/$dbname/wiki/$1";
		}
	}
	return $vars;
}

##
## Debug
##

if ( true ) {
	error_reporting( -1 );

	$wgShowHostnames = true;
	$wgShowExceptionDetails = true;
	$wgShowSQLErrors = true;
	#$wgDebugRedirects = false;
	#$wgDebugDumpSql = true;
	#$wgMemCachedDebug = false;

	// Tools
	$wgDebugToolbar = false;

	// Log files
	$wgDebugLogFile = "$kgLogDir/debug-{$wgDBname}.log";
	$wgDBerrorLog = "$kgLogDir/dberror.log";
	$wgRateLimitLog = "$kgLogDir/ratelimit.log";
	$wgDebugLogGroups['resourceloader'] = "$kgLogDir/resourceloader.log";
	$wgDebugLogGroups['exception'] = "$kgLogDir/exception.log";
	$wgDebugLogGroups['exception-json'] = "$kgLogDir/exception.json";
	$wgDebugLogGroups['error'] = "$kgLogDir/error.log";
	$wgDebugLogGroups['error-json'] = "$kgLogDir/error.json";
	#$wgDebugLogGroups['somegroup'] = "$kgLogDir/somegroup.log";
}

##
## Database
##

if ( $wgDBname === 'sqlitewiki' ) {
	$wgDBtype = 'sqlite';
	$wgDBserver = '';
	$wgDBuser = '';
	$wgSQLiteDataDir = dirname( $IP ) . '/_data';
} else {
	$wgDBtype = 'mysql';
	$wgDBserver = 'localhost';
	$wgDBuser = 'root';
	$wgDBpassword = 'root';
	$wgDBTableOptions = 'ENGINE=InnoDB, DEFAULT CHARSET=binary';
}

##
## Profiler
##

// $wgStatsdServer = 'localhost';

// // See profileinfo.php
// $wgEnableProfileInfo = true;

// // See StartProfiler.php
// $wgProfiler['class'] = 'ProfilerXhprof';
// $wgProfiler['output'] = array( 'ProfilerOutputDb' );
// $wgProfiler['sampling'] = 1;

##
## Site config
##

$wgConf->suffixes = array(
	'wikipedia' => 'wiki',
);

$wgConf->wikis = array(
	'alphawiki',
	'betawiki',
	'sqlitewiki',
);

$wgConf->settings = kfGetServerInfos() + array(
	'wgSitename' => array(
		'default' => '$lang.$Project',
	),
	'wgMetaNamespace' => array(
		'default' => 'Project',
	),
	'wgLanguageCode' => array(
		'default' => 'en',
	),
	'wgLocaltimezone' => array(
		'default' => 'Europe/London',
	),
);

$wgLocalDatabases =& $wgConf->getLocalDatabases();
if ( !in_array( $wgDBname, $wgLocalDatabases ) ) {
	if ( php_sapi_name() === 'cli' ) {
		echo "Error: Unknown wiki '$wgDBname'.\n";
	} else {
		$portalServerHtml = htmlspecialchars( $wgPortalServer );
		$link = strlen( $_SERVER['REQUEST_URI'] ) > 1
			? "<p style=\"text-align: right;\"><a href=\"{$portalServerHtml}\">&raquo; Go to root domain</a></p>"
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
<p>This domain points to the Krinkle Dev server, but is not recognised there.<br><em>That’s all we know.</em></p>
$link
</script>
</html>
HTML;
	}
	exit( 1 );
}

list( $project, $lang ) = $wgConf->siteFromDB( $wgDBname );

$globals = $wgConf->getAll( $wgDBname, 'wiki', array(
	'lang' => $lang,
	'Project' => ucfirst( $project ),
));
extract( $globals );

// Set $wgServer for CLI
if ( php_sapi_name() === 'cli' ) {
	$wgServer = "http://$lang.$project.krinkle.dev";
}

##
## Load extensions
##

$wgExtensionDirectory = dirname( $IP ) . '/extensions';

if ( isset( $kfIncludes ) ) {
	foreach ( $kfIncludes as $path ) {
		require_once str_replace(
			array( '$EP', '$SP' ),
			array( $wgExtensionDirectory, $wgStyleDirectory ),
			$path
		);
	}
}

if ( isset( $kfExtensions ) ) {
	wfLoadExtensions( $kfExtensions );
}

if ( isset( $kfSkins ) ) {
	wfLoadSkins( $kfSkins );
}

##
## Config
##

## User rights
unset( $wgGroupPermissions['developer'] );
$wgGroupPermissions['bureaucrat']['userrights-interwiki'] = true;

// Example user group for testing cross-wiki user rights
$wgGroupPermissions['debuglocal-' . $wgDBname]['edit'] = true;

## Caching
$wgMainCacheType = CACHE_DB;
$wgCacheDirectory = $IP . '/cache';
$wgUseLocalMessageCache = true;
$wgInvalidateCacheOnLocalSettingsChange = false;

## Media
$wgUseInstantCommons = true;
$wgEnableUploads = true;
$wgFileCacheDepth = 0;
$wgUploadPath = "$wgScriptPath/images";

## Output
$wgUseGzip = true;
$wgWellFormedXml = false;
$wgUseTidy = true;

## Server environment
$wgDiff3 = '/usr/bin/diff3';
$wgShellLocale = 'en_US.UTF-8';

## ResourceLoader
$wgResourceLoaderMaxage['unversioned']['server'] =
$wgResourceLoaderMaxage['unversioned']['server'] =
$wgResourceLoaderMaxage['versioned']['server'] =
$wgResourceLoaderMaxage['versioned']['client'] = 1;
$wgResourceLoaderStorageEnabled = false;

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

## CentralAuth
$wgGroupPermissions['steward']['globalgrouppermissions'] = true;
$wgGroupPermissions['steward']['globalgroupmembership'] = true;

## ConfirmEdit
#$wgCaptchaClass = 'ReCaptchaNoCaptcha';
// https://www.google.com/recaptcha/admin
#$wgReCaptchaSiteKey = '';
#$wgReCaptchaSecretKey = '';

$wgGroupPermissions['sysop']['skipcaptcha'] =
$wgGroupPermissions['autoconfirmed']['skipcaptcha'] = false;

$wgCaptchaTriggers['edit'] =
$wgCaptchaTriggers['create'] =
$wgCaptchaTriggers['sendemail'] =
$wgCaptchaTriggers['addurl'] =
$wgCaptchaTriggers['createaccount'] =
$wgCaptchaTriggers['badlogin'] = true;

## Testing
$wgEnableJavaScriptTest = true;
$wgLegacyJavaScriptGlobals = false;

## Spam
$wgSpamRegex = '/thisisspam/i';

## Resource origins
$wgAllowUserJs = $wgAllowUserCss = true;
$wgAllowUserCssPrefs = true;
$wgUseSiteJs = $wgUseSiteCss = true;

## Search
$wgEnableCanonicalServerLink = true;

## EventLogging
$wgEventLoggingFile = "$kgLogDir/events.log";
$wgEventLoggingDBname = 'alphawiki';
$wgEventLoggingBaseUri = 'http://localhost:8080/event.gif';
$wgEventLoggingSchemaApiUri = 'http://meta.wikimedia.org/w/api.php';

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
$wgVisualEditorParsoidURL = 'http://localhost:8000';
$wgVisualEditorParsoidPrefix = $wgDBname;

$wgDefaultUserOptions['visualeditor-enable'] = 1;
$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

## SpamBlacklist
$wgSpamBlacklistFiles = array( 'https://meta.wikimedia.org/w/index.php?title=Spam_blacklist&action=raw&sb_ver=1' );

## MaintenanceShell
$wgGroupPermissions['developer']['maintenanceshell'] = true;

## GlobalUserPage
$wgGlobalUserPageAPIUrl = 'http://beta.wikipedia.krinkle.dev/w/api.php';
$wgGlobalUserPageDBname = 'betawiki';

## Gadgets
$wgGadgetEnableSharing = true;

$wgGroupPermissions['gadgetartists']['gadgets-edit'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-create'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-edit'] = true;
$wgGroupPermissions['gadgetmanagers']['gadgets-definition-delete'] = true;

## Interwiki
$wgGroupPermissions['developer']['interwiki'] = true;

## Scribunto
$wgScribuntoEngineConf['luastandalone']['errorFile'] = "$kgLogDir/lua-error.log";
$wgScribuntoEngineConf['luastandalone']['luaPath'] = '/usr/local/bin/lua';
$wgScribuntoDefaultEngine = 'luastandalone';

// See https://www.mediawiki.org/wiki/Extension:Scribunto#LuaSandbox
$wgScribuntoDefaultEngine = 'luasandbox';

## TemplateData
$wgTemplateDataUseGUI = true;

## WikiEditor
$wgDefaultUserOptions['usebetatoolbar'] = 1;
$wgDefaultUserOptions['usebetatoolbar-cgd'] = 1;
