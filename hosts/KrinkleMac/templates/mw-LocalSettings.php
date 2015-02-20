<?php
# Further documentation for configuration settings:
# https://www.mediawiki.org/wiki/Manual:Configuration_settings

## Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
	exit;
}

$kfIncludes = array(
	#'$EP/Cite/Cite.php',
	#'$EP/EventLogging/EventLogging.php',
	#'$EP/Gadgets/Gadgets.php',
	#'$EP/Interwiki/Interwiki.php',
	#'$EP/MaintenanceShell/MaintenanceShell.php',
	#'$EP/ParserFunctions/ParserFunctions.php',
	#'$EP/SyntaxHighlight_GeSHi/SyntaxHighlight_GeSHi.php',
	#'$EP/TemplateData/TemplateData.php',
	#'$EP/VisualEditor/VisualEditor.php',
	#'$EP/WikiEditor/WikiEditor.php',
	'$SP/Vector/Vector.php',
);

## Include symlinked settings from Krinkle Dotfiles
require_once __DIR__ . '/CommonSettings.php';

## Local environment
$wgDiff3 = '/usr/bin/diff3';
$wgShellLocale = 'en_US.UTF-8';

## Keys
$wgSecretKey = '***';
$wgUpgradeKey = '***';
$wgCaptchaSecret = '***';

## Misc
#$wgUseRCPatrol = false;
#$wgLegacyJavaScriptGlobals = true;
