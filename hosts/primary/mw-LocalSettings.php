<?php
/*
This file is meant to be copied to:
~/Development/mediawiki/LocalSettings.mine.php

Then, in ~/Development/mediawiki/Localsettings.php:

```php
require_once __DIR__ . "/LocalSettings.mine.php"; // add this line
```

This is currently written for MediaWiki-Docker, and thus we assume
the following two are already dealt with:

- Set MW_LOG_DIR to something reachable and useful.
- Include "$IP/includes/DevelopmentSettings.php";
*/

##
## Temporary
##

// ini_set( 'display_errors', 0 );
// $wgDebugToolbar = true;
// $wgDevelopmentWarnings = true;

##
## Profiler
##

if ( extension_loaded( 'tideways' ) ) {
	if ( isset( $_GET['forceprofile'] ) || PHP_SAPI === 'cli' ) {
		$wgProfiler = [
			'class'  => ProfilerXhprof::class,
			'flags'  => TIDEWAYS_FLAGS_CPU | TIDEWAYS_FLAGS_NO_BUILTINS,
			'output' => 'text',
		];
	}
}

##
## Traffic
##

// $wgUseSquid = true;

##
## Cache
##

$wgMainCacheType = CACHE_ACCEL;

$wgParserCacheType = CACHE_DB;
// $wgSessionCacheType = CACHE_DB;

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

##
## Skins
##

wfLoadSkin('Vector');
// wfLoadSkin('MonoBook');
// wfLoadSkin('MinervaNeue');
// wfLoadSkin('Nostalgia');

##
## Tarball extensions
##

// wfLoadExtension('Cite');
// wfLoadExtension('CiteThisPage');
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
// wfLoadExtension('EventStreamConfig');
// wfLoadExtension('EventLogging');
// wfLoadExtension('Echo');
// wfLoadExtension('GlobalCssJs');
// wfLoadExtension('MobileFrontend');
// wfLoadExtension('NavigationTiming');
// wfLoadExtension('SyntaxHighlight_GeSHi');
// wfLoadExtension('TemplateData');
// wfLoadExtension('UniversalLanguageSelector');
// wfLoadExtension('VisualEditor');

// EventLogging
$wgEventLoggingBaseUri = '/beacon/event';
// $wgEventLoggingDBname = $wgDBname;

// ULS
// $wgULSCompactLanguageLinksBetaFeature = false;

// GlobalCssJs
$wgUseGlobalSiteCssJs = true;
$wgGlobalCssJsConfig['wiki'] = wfWikiID();
$wgGlobalCssJsConfig['source'] = 'local';

##
## Misc extensions
##

// wfLoadExtension('CategoryTree');
// wfLoadExtension('DiscussionTools');
// wfLoadExtension('Linter');
// wfLoadExtension('MultimediaViewer');
// wfLoadExtension('WikiLambda');
// wfLoadExtension('WikimediaEvents');
// wfLoadExtension('InputBox');

// CategoryTree
$wgCategoryTreeSidebarRoot = 'Category:All';

// DiscussionTools
$wgLocaltimezone = 'UTC'; // DiscussionTools requires this.
$wgFragmentMode = [ 'html5' ]; // DiscussionTools requires this.
// $wgDiscussionToolsTalkPageParserCacheExpiry = 60;

// Wikibase
// $wgWikimediaJenkinsCI = true;
// require_once "$IP/extensions/Wikibase/Wikibase.php";

// NavigationTiming
// $wgNavigationTimingSamplingFactor = 1;

// WikimediaEvents
$wgWMEStatsdBaseUri = '/beacon/statsv';
