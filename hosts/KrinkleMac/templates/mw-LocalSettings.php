<?php
/**
 * Further documentation for configuration settings:
 * https://www.mediawiki.org/wiki/Manual:Configuration_settings
 */

$kfIncludes = array(
	// '$EP/CentralNotice/CentralNotice.php',
	// '$EP/EventLogging/EventLogging.php',
	// '$EP/Gadgets/Gadgets.php',
	// '$EP/Interwiki/Interwiki.php',
	// '$EP/MaintenanceShell/MaintenanceShell.php',
	// '$EP/MobileFrontend/MobileFrontend.php',
	// '$EP/VisualEditor/VisualEditor.php',
	// '$EP/VisualEditor/VisualEditor.php',
	// '$EP/WikiEditor/WikiEditor.php',
	// '$EP/WikimediaEvents/WikimediaEvents.php',

	'$SP/Vector/Vector.php',
	// '$SP/MonoBook/MonoBook.php',
);

$kfExtensions = array(
	'Cite',
	'GlobalCssJs',
	'ParserFunctions',
	'WikiEditor',
	'TemplateData',
	'SyntaxHighlight_GeSHi',
);

// Include symlinked settings from Krinkle Dotfiles
require_once __DIR__ . '/CommonSettings.php';

// Keys
$wgSecretKey = '***';
$wgUpgradeKey = '***';
$wgCaptchaSecret = '***';

// Misc toggles
#$wgResourceLoaderStorageEnabled = false;
#$wgUseInstantCommons = false;
