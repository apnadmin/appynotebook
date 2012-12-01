/**
 *	UI Layout Callback: resizeTabLayout
 *
 *	Requires Layout 1.3.0.rc29.15 or later
 *
 *	This callback is used when a tab-panel is the container for a layout
 *	The tab-layout can be initialized either before or after the tabs are created
 *	Assign this callback to the tabs.show event:
 *	- if the layout HAS been fully initialized already, it will be resized
 *	- if the layout has NOT fully initialized, it will attempt to do so
 *		- if it cannot initialize, it will try again next time the tab is accessed
 *
 *	SAMPLE:
 *	$("#elem").tabs({ show: $.layout.callbacks.resizeTabLayout });
 *
 *	Version:	1.0 - 2011-06-25
 *	Author:		Kevin Dalman (kevin.dalman@gmail.com)
 */
;(function ($) {
var fN	= "resizeTabLayout"
,	_	= $.layout
;

// make sure the callbacks branch exists
if (!_.callbacks) _.callbacks = {};

// this callback is should be bound to the tabs.show callback
_.callbacks[ fN ] = function (evt, ui) {
	var	$panel = $(ui.panel)
	,	layout	= $panel.data("layout");
	if ( !layout ) // search 1-level below the tab-panel itself
		$panel.children().each(function(){
			layout = $(this).data("layout");
			if (layout) return false; // BREAK
		});
	// if layout is not fully initialized, resizeAll will trigger it to complete
	if ( layout ) layout.resizeAll();
};
})( jQuery );