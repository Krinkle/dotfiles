<?php
/**
 * This file is meant to be copied or hardlinked to:
 * ~/Development/mediawiki/LocalSettings.mine.php
 *
 * Then, add this line to ~/Development/mediawiki/Localsettings.php:
 *
 * ```php
 * require_once __DIR__ . "/LocalSettings.mine.php";
 * ```
 *
 * I use Quickstart, and thus we assume:
 * - MW_LOG_DIR is set to a writable path in composer.json.
 * - "$IP/includes/DevelopmentSettings.php" is already included.
 */

##
## Temporary
##

// Ad-hoc debugging
// $wgDebugDumpSql = true;
// $wgDebugRawPage = true;
// $wgDebugToolbar = true;
$wgDebugLogGroups['silenced-error'] = false;

// ini_set( 'display_errors', 0 );
// $wgDevelopmentWarnings = true;

##
## Profiler
##

if ( extension_loaded( 'xhprof' ) ) {
	if ( isset( $_GET['forceprofile'] ) || PHP_SAPI === 'cli' ) {
		$wgProfiler = [
			'class'  => ProfilerXhprof::class,
			'flags'  => XHPROF_FLAGS_CPU | XHPROF_FLAGS_NO_BUILTINS,
			'output' => 'text',
			// 'thresholdMs' => 0.01, // lower threshold to show stuff on fast requests too
			// 'running' => true, // profile Setup.php too
		];
		// xhprof_enable( XHPROF_FLAGS_CPU | XHPROF_FLAGS_NO_BUILTINS );
	}
}

// Use ?forceflame=1 to generate a trace log, written to /w/logs/speedscope.json
if ( extension_loaded( 'excimer' ) && isset( $_GET['forceflame'] ) ) {
	$excimer = new ExcimerProfiler();
	$excimer->setPeriod( 0.0001 ); // 0.1ms
	$excimer->setEventType( EXCIMER_REAL );
	$excimer->start();
	register_shutdown_function( function () use ( $excimer ) {
		$excimer->stop();
		$data = $excimer->getLog()->getSpeedscopeData();
		$data['profiles'][0]['name'] = $_SERVER['REQUEST_URI'];
		file_put_contents( MW_INSTALL_PATH . '/logs/speedscope-' . ( new DateTime )->format( 'Y-m-d_His_v' ) . '-' . MW_ENTRY_POINT . '.json',
				json_encode( $data, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE ) );
	} );
}

##
## Stats
##
## This was originally `while true; do nc -ul -w0 8125; done`,
## but that causes stats to arrive incompletely with the majority
## of stats lost between loop iterations since each iteration will
## open the port for 1 UDP connection, and then restart.
##
## $ brew install socat
## $ socat -u UDP-RECVFROM:8125,fork -
##

// $wgStatsTarget = 'udp://127.0.0.1:8125';
// $wgStatsFormat = 'dogstatsd';

##
## Traffic
##

// $wgUseSquid = true;

##
## Authentication
##

// $wgLoginLanguageSelector = true;

##
## Cache
##

$wgMainCacheType = CACHE_ACCEL;
$wgParserCacheType = CACHE_DB;
$wgSessionCacheType = CACHE_DB;

// Enable full debug logs and StatsD metrics with APCu as main cache (like CACHE_DB or Memcached)
// by using 'apcu' instead of CACHE_ACCEL. The latter uses the LocalServerObjectCache service,
// which disables logging/stats.
// $wgMainCacheType = 'apcu';

// $wgMiserMode = true;

// $wgPoolCountClientConf = [
//   'servers' => [ '127.0.0.1' ],
//   'timeout' => 0.5,
//   'connect_timeout' => 0.1,
// ];
// $wgPoolCounterConf = [ 'ArticleView' => [
// 	'class' => 'PoolCounter_Client',
// 	'fastStale' => true,
// 	'timeout' => 10, // wait timeout in seconds
// 	'workers' => 2, // maximum number of active threads in each pool
// 	'maxqueue' => 10, // maximum number of total threads in each pool
// ] ];

##
## ResourceLoader
##

$wgAllowUserCss = $wgAllowUserJs = true;

// $wgResourceLoaderEnableJSProfiler = true;

// $wgResourceModules['example1'] = [
// 	'group' => 'example',
//  	'scripts' => [
//  		[ 'name' => 'example1.js', 'content' => "// Comment\nconsole.log( 'example1' );\n" ],
//  	],
//  ];
// $wgResourceModules['example2'] = [
// 	'group' => 'example',
//  	'scripts' => [
//  		[ 'name' => 'example2a.js', 'content' => "// Comment\nconsole.log( 'example2a' );\n" ],
//  		[ 'name' => 'example2b.js', 'content' => "/*@nomin*/\n// Comment\nconsole.log( 'example2b' );\n" ],
//  		[ 'name' => 'example2c.js', 'content' => "// Comment\nconsole.log( 'example2c' );\n" ],
//  	],
//  ];
// $wgResourceModules['example3'] = [
// 	'group' => 'example',
//  	'scripts' => [
//  		[ 'name' => 'example3a.js', 'content' => "// Comment\nconsole.log( 'example3a' );\n" ],
//  		[ 'name' => 'example3b.js', 'content' => "// Comment\nconsole.log( 'example3b' );\n" ],
//  	],
//  ];
//  $wgHooks['BeforePageDisplay'][] = function ( $out ) {
//  	$out->addModules(['example1', 'example2', 'example3']);
//  };

##
## Multimedia
##

$wgLogo = '/mw-config/images/installer-logo.png';
$wgLogos = false;

$wgUseInstantCommons = true;

// $wgGenerateThumbnailOnParse = false;

// $wgLockManagers[] = [
// 	'name' => 'locky-mc-lock-face',
// 	'class' => 'MemcLockManager',
// 	'lockServers' => [
// 		'127.0.0.1:11211',
// 	],
// ];

##
## Recent changes & Watchlist
##

// $wgWatchersMaxAge = 1800 * 24 * 3600;

##
## Notifications
##

// $wgEnableSpecialMute = true;
// $wgEnableUserEmailMuteList = true;
// $wgEchoPerUserBlacklist = true;

##
## Localisation
##

##
## Parser
##

// Default is 20kB which is smaller than chaarts.css (51kB).
// Increase to 10x the default
$wgMaxArticleSize = 20480;

$wgFragmentMode = [ 'html5' ]; // DiscussionTools requires this.

##
## Shellbox
##

$wgPhpCli = PHP_BINARY;

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

// wfLoadExtension('AbuseFilter');
// wfLoadExtension('CategoryTree');
// wfLoadExtension('Cite');
// wfLoadExtension('CiteThisPage');
// wfLoadExtension('CodeEditor');
// wfLoadExtension('ConfirmEdit');
// wfLoadExtension('Gadgets');
// wfLoadExtension('ImageMap');
// wfLoadExtension('InputBox');
// wfLoadExtension('Interwiki');
// wfLoadExtension('Math');
// wfLoadExtension('ParserFunctions');
// wfLoadExtension('PdfHandler');
// wfLoadExtension('Poem');
// wfLoadExtension('SpamBlacklist');
// wfLoadExtension('SyntaxHighlight_GeSHi');
// wfLoadExtension('TemplateData');
// wfLoadExtension('TextExtracts');
// wfLoadExtension('VisualEditor');
// wfLoadExtension('WikiEditor');

##
## WMF CI Gate extensions
##

// wfLoadExtension('ContentTranslation');
// wfLoadExtension('Echo');
// wfLoadExtension('EventLogging');
// wfLoadExtension('EventStreamConfig');
// wfLoadExtension('GlobalCssJs');
// wfLoadExtension('MobileFrontend');
// wfLoadExtension('NavigationTiming');
// wfLoadExtension('UniversalLanguageSelector');

##
## Misc extensions
##

// wfLoadExtension('AntiSpoof');
// wfLoadExtension('ApiFeatureUsage');
// wfLoadExtension('CommunityConfiguration');
// wfLoadExtension('CentralAuth');
// wfLoadExtension('cldr');
// wfLoadExtension('DiscussionTools');
// wfLoadExtension('EventBus');
// wfLoadExtension('Flow');
// wfLoadExtension('GrowthExperiments');
// wfLoadExtension('GlobalBlocking');
// wfLoadExtension('GlobalUserPage');
// wfLoadExtension('GuidedTour');
// wfLoadExtension('JsonConfig');
// wfLoadExtension('MassMessage');
// wfLoadExtension('MediaModeration');
// wfLoadExtension('MultimediaViewer');
// wfLoadExtension('Nuke');
// wfLoadExtension('PageTriage');
// wfLoadExtension('Scribunto');
// wfLoadExtension('TemplateSandbox');
// wfLoadExtension('TemplateStyles');
// wfLoadExtension('TitleKey');
// wfLoadExtension('UploadWizard');
// wfLoadExtension('UrlShortener');
// wfLoadExtension('WikiLambda');
// wfLoadExtension('WikimediaEvents');
// wfLoadExtension('WikimediaMaintenance');
// wfLoadExtension('examples');

// examples
// $wgExampleEnableWelcome = false;

// CategoryTree
$wgCategoryTreeSidebarRoot = 'Category:All';

// ConfirmEdit
// wfLoadExtension('ConfirmEdit/FancyCaptcha');
// $wgCaptchaClass = 'FancyCaptcha';
// $wgCaptchaTriggers['createaccount'] = true;

// DiscussionTools
// $wgDiscussionToolsTalkPageParserCacheExpiry = 60;

// EventLogging
$wgEventLoggingBaseUri = '/beacon/event';
// $wgEventLoggingDBname = $wgDBname;

// GlobalCssJs
$wgUseGlobalSiteCssJs = true;
$wgGlobalCssJsConfig['wiki'] = $wgDBname;
$wgGlobalCssJsConfig['source'] = 'local';

// GlobalBlocking
// $wgGroupPermissions['sysop']['globalblock'] = true;

// Interwiki
$wgGroupPermissions['sysop']['interwiki'] = true;

// Math
// $wgMathValidModes = [ 'source', 'mathml', 'native', 'mathjax' ];

// MobileFrontend
// $wgMFMobileHeader = 'Foobar';
// $wgMFCustomSiteModules = true;

// NavigationTiming
// $wgNavigationTimingSamplingFactor = 1;

// TitleKey
// $wgSearchType = MediaWiki\Extension\TitleKey\SearchEngine::class;

// ULS
// $wgULSCompactLanguageLinksBetaFeature = false;

// Wikibase
// define( 'MW_QUIBBLE_CI', true );
// require_once "$IP/extensions/Wikibase/Wikibase.php";

// WikimediaEvents
$wgWMEStatsdBaseUri = '/beacon/statsv';
// $wgWMENewPHPVersion = '8.1';
// $wgWMENewPHPSamplingRate = 0;

// CommunityConfiguration
// wfLoadExtension('CommunityConfiguration');
// $wgCommunityConfigurationProviders = [
// 	'foo' => [
// 		'store' => [
// 			'type' => 'wikipage',
// 			'args' => [ 'MediaWiki:Foo.json' ],
// 		],
// 		'validator' => [
// 			'type' => 'jsonschema',
// 			'args' => [ FooSchema::class ]
// 		],
// 		'type' => 'mw-config',
// 	],
// ];
// use MediaWiki\Extension\CommunityConfiguration\Schema\JsonSchema;
// use MediaWiki\MediaWikiServices;
// $wgExtensionFunctions[] = function () {
// 	class FooSchema extends JsonSchema {
// 		public const FooThing = [
// 			JsonSchema::TYPE => JsonSchema::TYPE_STRING,
// 			JsonSchema::DEFAULT => 'initial',
// 		];
// 	}
// 	class SpecialFooConfig extends SpecialPage {
// 		public function __construct() {
// 			parent::__construct( 'FooConfig' );
// 		}
// 		public function execute( $par ) {
// 			$this->getOutput()->setPageTitle( 'Foo Config' );
// 			$this->getOutput()->addHtml(
// 				Html::element( 'p', [], 'The value of FooThing is:' )
// 				. Html::element( 'pre', [], $this->getFooThing() )
// 			);
// 		}
// 		private function getFooThing() {
// 			$reader = MediaWikiServices::getInstance()->get( 'CommunityConfiguration.WikiPageConfigReader' );
// 			return $reader->get( 'FooThing' );
// 		}
// 	}
// };
// $wgSpecialPages['FooConfig'] = 'SpecialFooConfig';
// $wgHooks['LocalisationCacheRecache'][] = function ( $localisationCache, $code, &$allData ) {
// 	$allData['specialPageAliases']['FooConfig'] = ['FooConfig'];
// };
