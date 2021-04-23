/*
// JoomlaWorks "Disqus Comment System" Plugin for Joomla! 1.5.x - Version 2.2
// Copyright (c) 2006 - 2009 JoomlaWorks Ltd. All rights reserved.
// Released under the GNU/GPL license: http://www.gnu.org/copyleft/gpl.html
// More info at http://www.joomlaworks.gr
// Designed and developed by the JoomlaWorks team
// ***Last update: November 14th, 2009***
*/

window.addEvent('domready',function(){

		// Disqus Comments Counter
		if(typeof disqusSubDomain != "undefined"){
			var links = document.getElementsByTagName('a');
			var query = '?';
			for(var i = 0; i < links.length; i++) {
				if(links[i].href.indexOf('#disqus_thread') >= 0) query += 'url' + i + '=' + encodeURIComponent(links[i].href) + '&';
			}
			var disqusScript = document.createElement('script');
			disqusScript.setAttribute('charset','utf-8');
			disqusScript.setAttribute('type','text/javascript');
			disqusScript.setAttribute('src','http://disqus.com/forums/' + disqusSubDomain + '/get_num_replies.js' + query + '');
			var b = document.getElementsByTagName('body')[0];
			b.appendChild(disqusScript);
		}
    
    // Smooth Scroll
    new SmoothScroll({
        duration: 500
    });
    
		// End
    
});
