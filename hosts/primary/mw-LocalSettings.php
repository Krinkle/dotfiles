<?php
#
# This file is meant to be located at:
# ~/Development/mediawiki-docker-dev/config/mediawiki/LocalSettings.mine.php.
#
# Then, in ~/Development/mediawiki/Localsettings.php:
#
# ```diff
#   require_once __DIR__ . "/.docker/LocalSettings.php";
# + require_once __DIR__ . "/.docker/LocalSettings.mine.php";
# ```

##
## Development
##

require_once "$IP/includes/DevelopmentSettings.php";
// $wgDebugToolbar = true;
// $wgDebugRawPage = true;
// $wgDevelopmentWarnings = true;

// $wgMainCacheType = CACHE_ACCEL;

// $wgParserCacheType = CACHE_DB;
// $wgSessionCacheType = CACHE_DB;

##
## Traffic
##

// $wgUseSquid = true;

##
## Cache
##

// Needed for $wgLocalisationCacheConf['store'] = 'array';
$wgCacheDirectory = $wgTmpDirectory;

##
## ResourceLoader
##

$wgAllowUserCss = $wgAllowUserJs = true;

// $wgResourceLoaderEnableJSProfiler = true;

##
## Media
##

$wgUseInstantCommons = true;

// $wgGenerateThumbnailOnParse = false;

##
## Localisation
##

$wgLocalisationCacheConf['store'] = 'array';

##
## Skins
##

wfLoadSkin('Vector');
// wfLoadSkin('MonoBook');
// wfLoadSkin('MinervaNeue');

##
## Tarball extensions
##

wfLoadExtension('Cite');
// wfLoadExtension('Gadgets');
// wfLoadExtension('Interwiki');
// wfLoadExtension('ParserFunctions');
// wfLoadExtension('WikiEditor');

##
## WMF CI Gate extensions
##

// wfLoadExtension('AbuseFilter');
// wfLoadExtension('CodeEditor');
// wfLoadExtension('ContentTranslation');
// wfLoadExtension('EventLogging');
// wfLoadExtension('GlobalCssJs');
// wfLoadExtension('NavigationTiming');
// wfLoadExtension('TemplateData');
// wfLoadExtension('UniversalLanguageSelector');
// wfLoadExtension('VisualEditor');

// EventLogging
$wgEventLoggingBaseUri = '/event';

// ULS
$wgULSCompactLanguageLinksBetaFeature = false;

// GlobalCssJs
$wgUseGlobalSiteCssJs = true;
$wgGlobalCssJsConfig['wiki'] = wfWikiID();
$wgGlobalCssJsConfig['source'] = 'local';

##
## Misc extensions
##

// wfLoadExtension('CategoryTree');
// wfLoadExtension('MultimediaViewer');
// wfLoadExtension('WikimediaEvents');

// CategoryTree
// $wgCategoryTreeSidebarRoot = 'Category:All';

// Wikibase
// $wgWikimediaJenkinsCI = true;
// require_once "$IP/extensions/Wikibase/Wikibase.php";

// NavigationTiming
// $wgNavigationTimingSamplingFactor = 1;
