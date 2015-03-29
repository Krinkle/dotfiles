<?php
## Project
$wgMetaNamespace = 'Project';
$wgLanguageCode = 'en';
$wgLocaltimezone = 'Europe/London';
$wgSitename = false;
$kgMainServer = false;
$kgCluster = false;

$wgShowHostnames = true;

## Database settings
$wgDBname = false;

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
$wgUseInstantCommons = true;
$wgEnableUploads = true;
$wgFileCacheDepth = 0;

## Local environment
$wgDiff3 = '/usr/bin/diff3';
$wgShellLocale = 'en_US.UTF-8';
$mwLogDir = '/var/log/mediawiki';


##
## Wiki ID
##

function kfGetMainServer() {
	global $kgCluster, $wgServer;
	switch ( $kgCluster ) {
		case 'dev':
			return 'http://krinkle.dev';
		case 'no-wildcard':
		default:
			return $wgServer;
	}
}

/**
 * Call after $wgConf->wikis is set.
 */
function kfGetServerInfos() {
	global $kgCluster, $wgConf, $kgMainServer;

	$vars = array(
		'wgCanonicalServer' => array(),
		'wgScriptPath' => array(),
	);
	foreach ( $wgConf->wikis as $wiki ) {
		list( $project, $lang ) = $wgConf->siteFromDB( $wiki );
		if ( $kgCluster === 'dev' ) {
			$vars[ 'wgCanonicalServer' ][ $wiki ] = 'http://' . $lang . '.wikipedia.krinkle.dev';
			$vars[ 'wgScriptPath' ][ $wiki ] = '/w';
		} elseif ( $kgCluster === 'no-wildcard' ) {
			$vars[ 'wgCanonicalServer' ][ $wiki ] = $kgMainServer;
			$vars[ 'wgScriptPath' ][ $wiki ] = '/' . $wiki;
		}
	}
	return $vars;
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

	// Wildcardless domains for use with No-IP or for external libraries that
	// require hostname to be 'localhost' when testing (e.g. Google reCAPTCHA).
	} else {
		$kgCluster = 'no-wildcard';
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
	$wgDebugLogGroups['exception-json'] = "$mwLogDir/exception.json";
	$wgDebugLogGroups['error'] = "$mwLogDir/error.log";
	$wgDebugLogGroups['error-json'] = "$mwLogDir/error.json";
	#$wgDebugLogGroups['somegroup'] = "$mwLogDir/somegroup.log";

	// ResourceLoader
	$wgResourceLoaderStorageEnabled = false;
	$wgResourceLoaderDebug = false;
	$wgDebugRawPage = false; // wmbug.com/47960
	// $wgResourceLoaderMaxage['versioned']['server'] = 1;
	// $wgResourceLoaderMaxage['versioned']['client'] = 1;
	$wgResourceLoaderMaxage['unversioned']['server'] = 1;
	$wgResourceLoaderMaxage['unversioned']['client'] = 1;
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
	$wgDBmysql5 = false;
}


##
## Profiler
##

if ( false ) {
	$wgStatsdServer = 'localhost';

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
	'sqlitewiki',
);

$wgConf->settings = kfGetServerInfos() + array(
	'wgSitename' => array(
		'default' => '$lang.$Project',
	)
);

$wgLocalDatabases =& $wgConf->getLocalDatabases();

if ( !in_array( $wgDBname, $wgLocalDatabases ) ) {
	if ( php_sapi_name() === 'cli' ) {
		echo "Error: Unknown wiki '$wgDBname'.\n";
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

$wgExtensionDirectory = dirname( $IP ) . '/extensions';
$wgStyleDirectory = dirname( $IP ) . '/skins';
$wgExtensionAssetsPath = '/extensions';
$wgStylePath = $wgLocalStylePath = '/skins';

if ( php_sapi_name() === 'cli' ) {
	// Sets $wgServer for CLI
	switch ( $kgCluster ) {
		case 'no-wildcard':
			$wgServer = 'http://wiki.krinkle.dev';
			break;
		case 'dev':
		default:
			$wgServer = "http://$lang.$project.krinkle.dev";
			break;
	}
}

switch ( $kgCluster ) {
	case 'no-wildcard':
		$wgArticlePath = "/$wgDBname/wiki/$1";
		$wgScriptPath = "/$wgDBname/w";
		break;
	case 'dev':
	default:
		$wgArticlePath = '/wiki/$1';
		$wgScriptPath = '/w';
}


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
	foreach ( $kfExtensions as $ext ) {
		ExtensionRegistry::getInstance()->load( "$wgExtensionDirectory/$ext/extension.json" );
	}
}


##
## Config
##

unset( $wgGroupPermissions['developer'] );

## User rights
$wgGroupPermissions['bureaucrat']['userrights-interwiki'] = true;

// Example user group for testing cross-wiki user rights
$wgGroupPermissions['debuglocal-' . $wgDBname]['edit'] = true;

## Uploads
$wgUploadPath = "$wgScriptPath/images";

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
$wgEventLoggingFile = $mwLogDir . '/events.log';
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
$wgSpamBlacklistFiles = array( 'http://meta.wikimedia.org/w/index.php?title=Spam_blacklist&action=raw&sb_ver=1' );

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
