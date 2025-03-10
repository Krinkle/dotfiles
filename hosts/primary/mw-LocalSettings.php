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
 * This is currently written for MediaWiki-Docker, and thus we assume:
 * - MW_LOG_DIR is set to something writable.
 * - "$IP/includes/DevelopmentSettings.php" is already included.
 */

##
## Temporary
##

// Ad-hoc debugging
// $wgDebugDumpSql = true;
// $wgDebugRawPage = true;
// $wgDebugToolbar = true;

// ini_set( 'display_errors', 0 );
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
## $ while true; do nc -ul -w0 8125; done
## $ while true; do nc -ul -w0 8126; done
##

// $wgStatsdServer = '127.0.0.1:8125';
// $wgStatsTarget = 'udp://127.0.0.1:8126';
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

$wgMainCacheType = CACHE_ACCELL;

$wgParserCacheType = CACHE_DB;
$wgSessionCacheType = CACHE_DB;

##
## ResourceLoader
##

$wgAllowUserCss = $wgAllowUserJs = true;

// $wgResourceLoaderEnableJSProfiler = true;

##
## Multimedia
##

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

// wfLoadExtension('ApiFeatureUsage');
// wfLoadExtension('CommunityConfiguration');
// wfLoadExtension('DiscussionTools');
// wfLoadExtension('EventBus');
// wfLoadExtension('Flow');
// wfLoadExtension('GrowthExperiments');
// wfLoadExtension('GlobalBlocking');
// wfLoadExtension('Linter');
// wfLoadExtension('MultimediaViewer');
// wfLoadExtension('PageTriage');
// wfLoadExtension('TitleKey');
// wfLoadExtension('WikiLambda');
// wfLoadExtension('WikimediaEvents');
// wfLoadExtension('WikimediaMaintenance');
// wfLoadExtension('examples');

// examples
// $wgExampleEnableWelcome = false;

// CategoryTree
$wgCategoryTreeSidebarRoot = 'Category:All';

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
// $wgGroupPermissions['sysop']['interwiki'] = true;

// Math
// $wgMathValidModes = [ 'source', 'mathml', 'native', 'mathjax' ];

// NavigationTiming
// $wgNavigationTimingSamplingFactor = 1;

// TitleKey
// $wgSearchType = MediaWiki\Extension\TitleKey\SearchEngine::class;

// ULS
// $wgULSCompactLanguageLinksBetaFeature = false;

// Wikibase
// $wgWikimediaJenkinsCI = true;
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
