<?php
/**
 * Further documentation for configuration settings:
 * https://www.mediawiki.org/wiki/Manual:Configuration_settings
 */

require_once "$IP/extensions/EventLogging/EventLogging.php";

wfLoadExtension( 'WikimediaEvents' );
wfLoadExtension( 'BetaFeatures' );
wfLoadExtension( 'Cite' );
wfLoadExtension( 'cldr' );
wfLoadExtension( 'GlobalCssJs' );
wfLoadExtension( 'Interwiki' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
wfLoadExtension( 'TemplateData' );
wfLoadExtension( 'VisualEditor' );
wfLoadExtension( 'WikiEditor' );

wfLoadSkin( 'Vector' );
wfLoadSkin( 'MonoBook' );

// Include symlinked settings from Krinkle Dotfiles
require_once __DIR__ . '/CommonSettings.php';

// Keys
$wgSecretKey = '***';
$wgUpgradeKey = '***';
$wgCaptchaSecret = '***';

// Misc toggles
#$wgReadOnly = 'Testing read-only mode.';
#$wgResourceLoaderStorageEnabled = true;
#$wgLegacyJavaScriptGlobals = true;
#$wgUseInstantCommons = false;
#$wgWellFormedXml = true;
