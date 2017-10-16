<?php
##
## Setup
##
if ( PHP_SAPI === 'cli' && !defined( 'MW_DB' ) ) {
  define( 'MW_DB', 'default' );
}

require_once __DIR__ . '/LocalSettings.php';

##
## Development
##

#require_once "$IP/includes/DevelopmentSettings.php";
#$wgDebugRawPage = true;
#$wgDevelopmentWarnings = true;

$wgMainCacheType = CACHE_ACCEL;

$wgParserCacheType = CACHE_DB;
$wgSessionCacheType = CACHE_DB;

##
## ResourceLoader
##

$wgAllowUserCss = $wgAllowUserJs = true;

##
## Skins
##

wfLoadSkin('Vector');
#wfLoadSkin('MinervaNeue');

##
## Extensions
##

#require_once "$IP/extensions/Collection/Collection.php";
#wfLoadExtension('MobileFrontend');

wfLoadExtension('CategoryTree');

wfLoadExtension('EventLogging');
$wgEventLoggingBaseUri = '/event';

wfLoadExtension('NavigationTiming');
$wgNavigationTimingSamplingFactor = false;
// $wgNavigationTimingOversampleFactor = [
//   'geo' => [
//
//   ],
//   'userAgent' => [
//     'Safari' => 3,
//     'Chrome' => 3,
//     'Firefox' => 1,
//     'Gecko' => 3,
//   ]
// ];

wfLoadExtension('GlobalCssJs');
$wgUseGlobalSiteCssJs = true;
$wgGlobalCssJsConfig['wiki'] = wfWikiID();
$wgGlobalCssJsConfig['source'] = 'local';
