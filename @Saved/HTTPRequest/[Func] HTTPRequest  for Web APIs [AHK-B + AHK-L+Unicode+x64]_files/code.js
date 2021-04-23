/* by Titan - v2.23 (GPL: http://creativecommons.org/licenses/GPL/2.0/) */

window.onload = function () {
	
	this.expand = function (e) {
		var d, t;
		if (this.nodeType == 1) {
			d = this; t = this.parentNode.parentNode.parentNode.parentNode.getElementsByTagName('b')[0];
			if ((document.getSelection && document.getSelection()) || (document.selection && document.selection.createRange().text))
				{ return; }
		}
		else {
			d = e.parentNode.parentNode.parentNode.parentNode.parentNode.getElementsByTagName('div')[0];
			t = e.parentNode.parentNode;
		}
		if (d.offsetHeight == p[2]) {
			d.style.height = '100%'; d.style.overflow = 'hidden'; t.innerHTML = t.innerHTML.replace(l[0], l[1]);
		} else {
			d.style.height = p[2] + 'px'; d.style.overflow = 'auto'; t.innerHTML = t.innerHTML.replace(l[1], l[0]);
			d = 0; while(t) { d += t.offsetTop; t = t.offsetParent; }
			if (document.body.scrollTop > d) { window.scrollTo(0, d - 5); }
		}
	};
	
	this.copy = function (e) {
		var d = e.parentNode.parentNode.parentNode.parentNode.parentNode.getElementsByTagName('div')[0], s = false;
		if (d.innerText) { d = d.innerText.replace(/ ((?:\r)?\n|$)/g, '$1'); }
		else {
			d = d.innerHTML.replace(/<br\s*\/?>/gi, '\n').replace(/<[^>]*>/g, '').
			replace(/&nbsp;/gi, ' ').replace(/&amp;/gi, '&').replace(/&lt;/gi, '<').replace(/&gt;/gi, '>');
		}
		if (p[6]) { d = d.replace(/   /g, '\t'); }
		if (window.clipboardData) { s = window.clipboardData.setData('Text', d); }
		else {
			swf.innerHTML = '<embed src="copyclip.swf" FlashVars="clipboard=' +
				encodeURIComponent(d.replace(/\\/g, '\\ ').replace(/\n/g, '\\n')) +
				'" width="0" height="0" type="application/x-shockwave-flash"></embed>'; s = true;
		}
		alert(l[!s + 3]);
	};
	
	function pref(s) {
		var c = document.cookie + ';', e = [], n, p, v, a = [], i;
		for (i = 1; i < s.length; i++) {
			e = s[i].split('='); n = s[0] + e[0] + '='; p = c.indexOf(n);
			v = p > -1 ? c.substr(p += n.length, c.indexOf(';', p) - p) : e[1];
			a[i] = v == '0' ? false : v == '1' ? true : v;
		}
		return a;
	}
	
	var l = ['Expand', 'Collapse', 'Copy', 'Code copied to clipboard.', 'Code could not be copied to the clipboard.'],
		// cookie prefix [0], enabled [1], height [2], toolbar [3], click [4], auto [5], tab [6], style [7], expand/collapse [8]
		p = pref(['codeblock-', 'enabled=1', 'height=200', 'toolbar=1', 'click=1', 'auto=1', 'tab=0', 'style=color: #008000', 'ex=1']),
		e = document.getElementsByTagName('td'), sl = '<span style="' + p[7] + '">', sr = '</span>', i, swf,
		jsp = '<a href="javascript:;" onclick="javascript:',
		cl = window.clipboardData || navigator.plugins['Shockwave Flash'] && /\d+/.exec(navigator.plugins['Shockwave Flash'].description)[0] < 10;
	
	try {
		if (!p[1]) { return; }
		if (cl) { swf = document.createElement('div'); document.body.appendChild(swf); }
		for (i in e) {
			if (e[i].className == 'code') {
				c = '\n' + e[i].innerHTML.replace(/\n/g, '').replace(/<br\s*\/?>/gi, '\n').replace(/&nbsp;|\xA0/gi, '\xA0 ');
				f = /\n\s*#CommentFlag\s*([^\n]+)/.exec(c); t = e[i].parentNode.parentNode.getElementsByTagName('b')[0];
				r = new RegExp('(\\n|\\s)(' + (f ? f[1] : ';') + '.*)', 'gi'); ex = p[8] && e[i].offsetHeight > p[2] * 1.1; ec = '';
				e[i].innerHTML = '<div>' + c.replace(r, '$1' + sl + '$2' + sr).
					replace(/(\n\s*)\/\*/g, '$1' + sl + '\/*').replace(/(\n\s*\*\/)/g, '$1' + sr).
					replace(/\xA0 /g, '&nbsp;').substr(1).replace(/\n/g, '<br />') + '</div>';
				if (p[3] && (cl || ex)) {
					t.innerHTML = 'Code (' + (ex ? jsp + 'expand(this);">' + l[0] + '</a>' + (cl ? ' - ' : '') : '') +
						(cl ? jsp + 'copy(this);">' + l[2] + '</a>' : '') + '):';
				}
				if (ex && p[5]) {
					ec = e[i].getElementsByTagName('div')[0]; ec.style.height = p[2] + 'px'; ec.style.overflow = 'auto';
					if (p[4]) { ec.onclick = expand; }
				}
			}
		}
	} catch(e) { }
};