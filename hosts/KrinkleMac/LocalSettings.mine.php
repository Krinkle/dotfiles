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

require_once "$IP/includes/DevelopmentSettings.php";
// $wgDebugRawPage = true;
// $wgDevelopmentWarnings = true;


##
## Traffic
##

// $wgUseSquid = true;

##
## ResourceLoader
##

$wgAllowUserCss = $wgAllowUserJs = true;

##
## Media
##

// $wgGenerateThumbnailOnParse = false;

##
## Skins
##

wfLoadSkin('Vector');
// wfLoadSkin('MinervaNeue');

##
## Extensions
##

// require_once "$IP/extensions/Collection/Collection.php";
// wfLoadExtension('MobileFrontend');

// wfLoadExtension('CategoryTree');
// $wgCategoryTreeSidebarRoot = 'Category:All';

wfLoadExtension('EventLogging');
$wgEventLoggingBaseUri = '/event';

wfLoadExtension('NavigationTiming');
$wgNavigationTimingSamplingFactor = 1;
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

// wfLoadExtension('GlobalCssJs');
// $wgUseGlobalSiteCssJs = true;
// $wgGlobalCssJsConfig['wiki'] = wfWikiID();
// $wgGlobalCssJsConfig['source'] = 'local';

// wfLoadExtension('ORES');
// // From ORES/tests/selenium/LocalSettings.php
// $wgOresWikiId = 'testwiki';
// $wgOresModels = [
// 	'damaging' => true,
// 	'goodfaith' => true,
// 	'reverted' => false,
// 	'wp10' => false,
// 	'draftquality' => false
// ];
