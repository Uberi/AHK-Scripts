var disqus_config;var DsqLocal;var disqus_callback;var disqus_callback_params;var disqus_category_id;var disqus_container_id;var disqus_custom_strings;var disqus_def_email;var disqus_def_name;var disqus_default_text;var disqus_dev;var disqus_developer;var disqus_domain;var disqus_facebook_forum;var disqus_facebook_key;var disqus_frame_theme;var disqus_identifier;var disqus_iframe_css;var disqus_message;var disqus_shortname;var disqus_thread_slug;var disqus_skip_auth;var disqus_sort;var disqus_title;var disqus_url;var disqus_per_page;var DISQUS=(function(h,d){var e=0,b={running:false,timer:null,queue:[],beat:function(){if(b.queue.length===0){return b.stop()}try{if(b.queue[0][0]()){b.queue.shift()[1]()}}catch(j){if(!(j instanceof a.AssertionError)){throw j}}},stop:function(){b.running=false;clearInterval(b.timer)},start:function(){b.running=true;b.timer=setInterval(b.beat,100)}},f=h.getElementsByTagName("head")[0]||h.getElementsByTagName("body")[0],i={pool:[],add:function(j){i.pool.push(j)},drain:function(){while(i.pool.length>0){i.pool.shift()()}}},g={},a={config:{},browser:{ie:/msie/i.test(navigator.userAgent)&&!/opera/i.test(navigator.userAgent),ie6:(!d.XMLHttpRequest)?true:false,ie7:(h.all&&!d.opera&&d.XMLHttpRequest)?true:false,webkit:navigator.userAgent.indexOf("AppleWebKit/")>-1,opera:!!(d.opera&&d.opera.buildNumber),gecko:navigator.userAgent.indexOf("Gecko/")>-1,mobile:/(iPhone|Android|iPod|iPad|webOS|Mobile Safari|Windows Phone)/i.test(navigator.userAgent),quirks:(h.compatMode&&h.compatMode==="BackCompat")?true:false},blocks:{},status:null,modules:{}};a.settings={realtime_url:"http://rt.disqus.com/forums/realtime.js",urls:{unmerged_profiles:"http://disqus.com/embed/profile/unmerged_profiles/"},minify_js:true,debug:false,disqus_url:"http://disqus.com",uploads_url:"http://media.disqus.com/uploads",recaptcha_public_key:"6LdKMrwSAAAAAPPLVhQE9LPRW4LUSZb810_iaa8u",media_url:"http://mediacdn.disqus.com/1298083962"};a.AssertionError=function(j){this.message=j};a.AssertionError.prototype.toString=function(){return"AssertionError: "+this.message};a.assert=function(k,j){if(!k){throw new a.AssertionError(j)}};a.contains=function(j,m){for(var k=0,l=j.length;k<l;k++){if(j[k]==m){return true}}return false};a.defer=function(j,k){b.queue.push([j,k]);b.beat();if(!b.running){b.start()}};a.each=function(n,o){var l=n.length,m=Array.prototype.forEach;if(!isNaN(l)){if(m){m.call(n,o)}else{for(var k=0;k<l;k++){o(n[k],k,n)}}}else{for(var j in n){if(n.hasOwnProperty(j)){o(n[j],j,n)}}}};a.extend=function(){var k,j;if(arguments.length<=1){k=a;j=[arguments[0]||{}]}else{k=arguments[0]||{};j=Array.prototype.slice.call(arguments,1)}DISQUS.each(j,function(l){DISQUS.each(l,function(n,m){k[m]=n})});return k};a.partial=function(){var k=arguments[0],j=Array.prototype.slice.call(arguments,1);return function(){var n=Array.prototype.slice.call(arguments),o=[];for(var l=0,m=j.length;l<m;l++){o.push(j[l]===undefined?n.shift():j[l])}while(n.length>0){o.push(n.shift())}return k.apply(this,o)}};a.getGuid=function(){return e++};a.serialize=function(k,n,l){if(typeof n!="undefined"){k+=(~k.indexOf("?")?(k.charAt(k.length-1)=="&"?"":"&"):"?");DISQUS.each(n,function(p,o){k+=o;if(p!==null){k+="="+encodeURIComponent(p)}k+="&"})}if(l){var m={};m[(new Date()).getTime()]=null;return a.serialize(k,m)}var j=k.length;return(k.charAt(j-1)=="&"?k.slice(0,j-1):k)};a.useSSL=function(l){if(!d.location.href.match("/^https/")){return}var k,m=["disqus_url","media_url","realtime_url","uploads_url"];l=l||a.settings;for(var j=0;j<m.length;j++){k=m[j];if(typeof l[k]=="string"){l[k]=l[k].replace(/^http/,"https")}}};a.useSSL();a.ready=function(k){function j(){var m=a.settings.media_url,l=m+"/javascript/embed/dtpl/",o=m+"/build/system/",n;DISQUS.status="loading";DISQUS.requireStylesheet(m+"/styles/dtpl/defaults.css");if(DISQUS.settings.debug){n=[l+"dtpl.js",l+"utils.js",l+"sandbox.js",l+"tooltip.js",l+"comm.js",l+"ui.js",l+"compat.js",o+"defaults.js",m+"/js/src/lib/easyxdm.js",m+"/js/src/json.js",DISQUS.settings.media_url+"/js/src/lib/stacktrace.js"]}else{n=[o+"disqus.js"]}DISQUS.requireSet(n,DISQUS.settings.debug,function(){DISQUS.status="ready";i.drain()})}switch(DISQUS.status){case"ready":k();break;case"loading":i.add(k);break;case null:i.add(k);j();break}};function c(k){var j=k.currentTarget||k.srcElement;var l=j.getAttribute("data-callback-id");if(k.type==="load"||/^(complete|loaded)$/.test(j.readyState)){if(typeof l!==null){g[l]()}if(j.removeEventListener){j.removeEventListener("load",c,false)}else{j.detachEvent("onreadystatechange",c)}}}a.require=function(k,n,l,o){var j=h.createElement("script");j.src=DISQUS.serialize(k,n,l);j.async=true;j.charset="UTF-8";if(o){var m=DISQUS.getGuid();g[m]=o;j.setAttribute("data-callback-id",m);if(j.addEventListener){j.addEventListener("load",c,false)}else{j.attachEvent("onreadystatechange",c)}}f.appendChild(j);return DISQUS};a.requireSet=function(l,k,m){var j=l.length;DISQUS.each(l,function(n){DISQUS.require(n,{},k,function(){if(--j===0){m()}})})};a.requireStylesheet=function(j,m,k){var l=h.createElement("link");l.rel="stylesheet";l.type="text/css";l.href=DISQUS.serialize(j,m,k);f.appendChild(l);return a};a.addBlocks=function(l,m){var k=DISQUS.modules;if(typeof m!="undefined"){return(function(){if(l=="all"){m();k.dtpl_defaults=true;k.dtpl_theme=true}else{if(l=="defaults"){m();k.dtpl_defaults=true}else{if(l=="theme"){if(k.dtpl_defaults){m();k.dtpl_theme=true}else{DISQUS.addJob(function(){return k.dtpl_defaults},function(){DISQUS.addBlocks(l,m)})}}}}}())}var j=function(){return{Builder:DISQUS.strings.Builder,renderBlock:DISQUS.renderBlock,each:DISQUS.each,extend:DISQUS.extend,blocks:DISQUS.blocks,interpolate:DISQUS.strings.interpolate}};if(typeof l=="undefined"){return function(n){n(j());k.dtpl_defaults=true;k.dtpl_theme=true}}else{if(l=="defaults"){return function(n){n(j());k.dtpl_defaults=true}}else{if(l=="theme"){if(k.dtpl_defaults){return function(n){n(j());k.dtpl_theme=true}}return function(n){DISQUS.addJob(function(){return k.dtpl_defaults},function(){DISQUS.addBlocks(l)(n)})}}}}};a.renderBlock=function(j,l){var k=DISQUS.blocks[j];if(typeof k=="undefined"){throw"Block "+j+" was not found!"}return DISQUS.sandbox.wrap(j,k,l)};return a}(document,window));(function(){var b={},a;a={translations:{},setGlobalContext:function(c){DISQUS.extend(b,c)},get:function(c){return a.translations[c]||c},interpolate:function(e,d){var c=[d||{},b];function f(h){for(var g=0,j=c.length;g<j;g++){if(c[g][h]!==undefined){return String(c[g][h])}}throw"Key "+h+"not found in context"}return e.replace(/%\(\w+\)s/g,function(g){return f(g.slice(2,-2))})},pluralize:function(d,e,c){return(d!=1)?c||"s":e||""},trim:function(e){e=e.replace(/^\s\s*/,"");var c=/\s/,d=e.length;while(c.test(e.charAt(--d))){}return e.slice(0,d+1)},capitalize:function(c){return c.charAt(0).toUpperCase()+c.slice(1)}};a.Builder=function(){this.value=DISQUS.browser.ie?[]:""};a.Builder.prototype.put=(function(){return(DISQUS.browser.ie?function(c){this.value.push(c)}:function(c){this.value+=c})}());a.Builder.prototype.compile=function(){if(DISQUS.browser.ie){this.value=this.value.join("")}return this.value};DISQUS.extend({strings:a})}());(function(){DISQUS.addJob=DISQUS.defer;DISQUS.getResourceURL=DISQUS.serialize;DISQUS.lang={contains:DISQUS.contains,forEach:DISQUS.each,extend:DISQUS.extend,trim:DISQUS.strings.trim,partial:DISQUS.partial}}());(function(n,k){var l=n.getElementsByTagName("head")[0]||n.getElementById("disqus_thread"),q=n.getElementsByTagName("meta"),j=false,e=["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","TkSuQmCC"],p=["R0lGODlhEAALAPQAAP///z2LqeLt8dvp7u7090GNqz2LqV+fuJ/F1IW2ycrf51aatHWs","waXJ14i4ys3h6FmctUCMqniuw+vz9eHs8fb5+meku+Tu8vT4+cfd5bbT3tbm7PH2+AAA","AAAAAAAAACH/C05FVFNDQVBFMi4wAwEAAAAh/hpDcmVhdGVkIHdpdGggYWpheGxvYWQu","aW5mbwAh+QQJCwAAACwAAAAAEAALAAAFLSAgjmRpnqSgCuLKAq5AEIM4zDVw03ve27if","DgfkEYe04kDIDC5zrtYKRa2WQgAh+QQJCwAAACwAAAAAEAALAAAFJGBhGAVgnqhpHIeR","vsDawqns0qeN5+y967tYLyicBYE7EYkYAgAh+QQJCwAAACwAAAAAEAALAAAFNiAgjoth","LOOIJAkiGgxjpGKiKMkbz7SN6zIawJcDwIK9W/HISxGBzdHTuBNOmcJVCyoUlk7CEAAh","+QQJCwAAACwAAAAAEAALAAAFNSAgjqQIRRFUAo3jNGIkSdHqPI8Tz3V55zuaDacDyIQ+","YrBH+hWPzJFzOQQaeavWi7oqnVIhACH5BAkLAAAALAAAAAAQAAsAAAUyICCOZGme1rJY","5kRRk7hI0mJSVUXJtF3iOl7tltsBZsNfUegjAY3I5sgFY55KqdX1GgIAIfkECQsAAAAs","AAAAABAACwAABTcgII5kaZ4kcV2EqLJipmnZhWGXaOOitm2aXQ4g7P2Ct2ER4AMul00k","j5g0Al8tADY2y6C+4FIIACH5BAkLAAAALAAAAAAQAAsAAAUvICCOZGme5ERRk6iy7qpy","HCVStA3gNa/7txxwlwv2isSacYUc+l4tADQGQ1mvpBAAIfkECQsAAAAsAAAAABAACwAA","BS8gII5kaZ7kRFGTqLLuqnIcJVK0DeA1r/u3HHCXC/aKxJpxhRz6Xi0ANAZDWa+kEAA7","AAAAAAAAAAAA"];function m(s,r){return s.hasAttribute?s.hasAttribute(r):s.getAttribute(r)!==null}function g(s,r,t){return m(s,r)&&s.getAttribute(r)==t}function f(){var r;function w(x){return !m(x,"src")&&m(x,"name")&&parseInt(x.getAttribute("name"),10)&&x.innerHTML===""}for(var t=0,u=q.length;t<u;t++){if(g(q[t],"name","generator")&&g(q[t],"content","blogger")){r=n.getElementsByTagName("A");for(var s=0,v=r.length;s<v;s++){if(w(r[s])){return r[s].getAttribute("name")}}}}return null}function i(t){for(var r=0,s=t.length;r<s;r++){if(t.charCodeAt(r)>256){return true}}return false}function b(){var r=k.location.href,v=k.location.hash,u=DsqLocal||{},t=f();DISQUS.extend(DISQUS.config,{container_id:disqus_container_id||"disqus_thread",page:{url:disqus_url||r,title:disqus_title||"",sort:disqus_sort||"",per_page:disqus_per_page||null,category_id:disqus_category_id||"",developer:+disqus_developer,identifier:disqus_identifier||""},trackback_url:u.trackback_url||null,trackbacks:u.trackbacks||null});if(t){DISQUS.config.page.blogger_id=t}if(!disqus_message||(DISQUS.browser.ie&&i(disqus_message))){DISQUS.config.message=""}else{if(disqus_message.length>400){DISQUS.config.message=disqus_message.substring(0,disqus_message.indexOf(" ",350))}else{DISQUS.config.message=disqus_message}}if(typeof disqus_require_moderation_s!="undefined"){DISQUS.config.page.require_mod_s=disqus_require_moderation_s}if(typeof disqus_remote_auth_s2!="undefined"){DISQUS.config.page.remote_auth_s2=disqus_remote_auth_s2}if(typeof disqus_author_s2!="undefined"){DISQUS.config.page.author_s2=disqus_author_s2}if(typeof disqus_per_page!="undefined"){DISQUS.config.page.per_page=disqus_per_page}if(typeof disqus_thread_slug!="undefined"){DISQUS.config.page.slug=disqus_thread_slug}var s;if(v){s=v.match(/comment\-([0-9]+)/);if(s){DISQUS.config.page.anchor_post_id=s[1]}}DISQUS.config.callback_params=disqus_callback_params||null;if(typeof disqus_callback=="function"){DISQUS.config.callbacks.afterRender.push(function(){disqus_callback(DISQUS.config.callback_params)})}if(typeof disqus_custom_strings=="object"){DISQUS.config.custom_strings=disqus_custom_strings}DISQUS.extend(DISQUS.config,{domain:disqus_domain||(disqus_dev?"dev.disqus.org":"disqus.com"),shortname:disqus_shortname||DISQUS.getShortname(),iframe_css:disqus_iframe_css||"",facebook_forum:disqus_facebook_forum||null,facebook_key:disqus_facebook_key||null,def_name:disqus_def_name,def_email:disqus_def_email,def_text:disqus_default_text||"",skip_auth:disqus_skip_auth||false,templatePreview:!!(k.parent!=k&&v.match(/dsqpreview/))});DISQUS.config.json_url="//"+DISQUS.config.shortname+"."+DISQUS.config.domain+"/thread.js";if(typeof disqus_config=="function"){disqus_config.call(DISQUS.config)}}function o(){DISQUS.jsonData={ready:false};DISQUS.require(DISQUS.config.json_url,DISQUS.config.page,true);var t=n.getElementById("dsq-content")||n.createElement("div");t.id="dsq-content";t.style.display="none";function s(y,v,x,A,z,w){return"<"+["img",'width="'+y+'"','height="'+v+'"','alt="'+A+'"','src="data:image/'+x+";base64,"+z+'"',(w?'style="'+w+'"':"")].join(" ")+">"}var u=n.createElement("div");u.id="dsq-content-stub";u.innerHTML=DISQUS.browser.ie6?"...":s(71,17,"png","DISQUS",e.join(""))+s(16,11,"gif","...",p.join(""),"margin:0 0 3px 5px");var r=n.getElementById(DISQUS.config.container_id);r.appendChild(t);r.appendChild(u);DISQUS.ready(function(){DISQUS.initThread(function(){u.style.display="none"})})}function d(A){var v=n.getElementById("dsq-content");var t=DISQUS.settings.media_url+"/javascript/embed/dtpl/";var y=DISQUS.settings.media_url+"/build/system/";var s=DISQUS.settings.media_url+"/build/lang/";var r=DISQUS.jsonData.forum.template.css;var z=DISQUS.jsonData.forum.template.url;var w;(function(){var B=DISQUS.jsonData;DISQUS.strings.setGlobalContext({profile_url:B.urls.request_user_profile,disqus_url:B.settings.disqus_url,media_url:B.settings.media_url,request_username:B.request.username,request_display_username:B.request.display_username,forum_name:B.forum.name})})();DISQUS.callback(DISQUS.config.callbacks.preInit);if(DISQUS.browser.mobile&&!DISQUS.jsonData.forum.mobile_theme_disabled){r=DISQUS.jsonData.forum.template.mobile.css;z=DISQUS.jsonData.forum.template.mobile.url}else{if(DISQUS.config.template){r=DISQUS.config.template.css;z=DISQUS.config.template.js}else{if(DISQUS.config.templatePreview&&DISQUS.jsonData.forum.template.preview){z=DISQUS.jsonData.forum.template.preview.url;r=DISQUS.jsonData.forum.template.preview.css}}}if(!DISQUS.jsonData.settings.debug){var u=n.createElement("iframe");u.style.display="none";u.src=DISQUS.jsonData.urls.stats;n.body.appendChild(u)}if(!k.disqus_no_style&&r){DISQUS.requireStylesheet(r,{},DISQUS.jsonData.settings.debug)}w=[z];var x=k.location.search;if(~x.indexOf("fbc_channel=1")||~x.indexOf("fb_xd_fragment")){DISQUS.require(z,{},DISQUS.settings.debug,function(){DISQUS.registerActions();new DISQUS.comm.FacebookLoginBox()});return}if(DISQUS.config.language){if(DISQUS.config.language!="en"){w.push(s+DISQUS.config.language+".js")}}else{if(DISQUS.jsonData.forum.language!="en"){w.push(s+DISQUS.jsonData.forum.language+".js")}}DISQUS.comm.Default.create();DISQUS.requireSet(w,DISQUS.jsonData.settings.debug,function(){if(DISQUS.config.custom_strings){DISQUS.lang.extend(DISQUS.strings.translations,DISQUS.config.custom_strings)}if(DISQUS.config.def_text===""){DISQUS.config.def_text=DISQUS.strings.get("Type your comment here.")}DISQUS.nodes.addClass(v,"clearfix");var B=v.parentNode;B.removeChild(v);v.innerHTML=DISQUS.renderBlock("thread");B.appendChild(v);DISQUS.callback(DISQUS.config.callbacks.onInit);DISQUS.registerActions();DISQUS.dtpl.actions.fire("thread.initialize");DISQUS.callback(DISQUS.config.callbacks.afterRender);DISQUS.nodes.container=DISQUS.nodes.get("#dsq-content");v.style.display="block";A();var D,C;if(DISQUS.config.page.anchor_post_id){DISQUS.nodes.scrollTo("#dsq-comment-"+DISQUS.config.page.anchor_post_id)}DISQUS.dtpl.actions.fire("thread.ready")})}function a(){for(var r=0,s=q.length;r<s;r++){if(q[r].getAttribute("name")=="viewport"){return true}}return false}DISQUS.extend({cache:{buttonsToRestore:[],popupProfileCache:{},popupStatusCache:{},toggledReplies:{},postSharing:{},realtime:{interval:null,ongoing_request:null,prev_script:null,last_checked:null,newPosts:[]}},states:{edit:{},realtime:false,useLoginWindow:false,loginDisabled:false,metaViewport:a()},curPageId:"dsq-comments",frames:{},config:{template:null,callbacks:{preData:[],preInit:[],onInit:[],afterRender:[],onReady:[],onPaginate:[],onNewComment:[],preReset:[]}},jsonData:null,isReady:false,getShortname:function(){function u(z){var A=(z.getAttribute?z.getAttribute("src"):z.src),y=[/https?:\/\/(www\.)?disqus\.com\/forums\/([\w_\-]+)/i,/https?:\/\/(www\.)?([\w_\-]+)\.disqus\.com/i,/https?:\/\/(www\.)?dev\.disqus\.org\/forums\/([\w_\-]+)/i,/https?:\/\/(www\.)?([\w_\-]+)\.dev\.disqus\.org/i],v=y.length;if(A){for(var x=0;x<v;x++){var w=A.match(y[x]);if(w&&w.length&&w.length==3){return w[2]}}}return null}var r=n.getElementsByTagName("script");for(var t=r.length-1;t>=0;t--){var s=u(r[t]);if(s!==null){return s}}return null},callback:function(w){var t,v,r;var u=function(x){if(k.console&&console.log){console.log(x)}};if(arguments.length>1){r=Array.prototype.slice.call(arguments,1)}for(t=0;t<w.length;t++){v=w[t];if(typeof v!="function"){continue}try{v.apply({},r||[])}catch(s){if(DISQUS.settings.debug){throw s}if(s.toString().search("Dsq")>-1){u("WARNING: This page uses deprecated Disqus APIs. See blog.disqus.com for more info")}else{u(s)}}}},reset:function(r){var s=DISQUS.nodes.get("#"+DISQUS.config.container_id);r=r||{};DISQUS.comm.reset();DISQUS.jsonData=null;DISQUS.sandbox.invalidateGlobals();DISQUS.status=null;s.innerHTML="";DISQUS.callback(DISQUS.config.callbacks.preReset);DISQUS.each(DISQUS.config.callbacks,function(u,t){DISQUS.config.callbacks[t]=[]});if(!r.reload){return}b();if(r.config){r.config.call(DISQUS.config)}o()},reload:function(r){DISQUS.require(DISQUS.config.json_url,DISQUS.config.page,true,function(){j=true;if(typeof r=="function"){r()}})},redraw:function(s){var r;if(j||s){DISQUS.sandbox.invalidateGlobals();r=DISQUS.nodes.get("#dsq-content");r.innerHTML=DISQUS.renderBlock("thread");DISQUS.frames=[];DISQUS.dtpl.actions.fire("thread.initialize");j=false}},initThread:function(u){var r,w,x,s,t;function y(A){var B=k.onload;if(typeof k.onload!="function"){k.onload=A}else{k.onload=function(){if(B){B()}A()}}}function z(){var A,E,B;if(!DISQUS.isReady){if(!t){t=k.setInterval(z,500)}return}if(t){clearInterval(t)}A=n.getElementById(disqus_container_id);E=n.getElementsByTagName("iframe");B=n.getElementById("dsq-content");if(B){for(var C=0,D=E.length;C<D;C++){E[C].style.width=B.offsetWidth}}}if(DISQUS.browser.ie&&DISQUS.config.frame_theme!=="cnn2"){y(z)}x=n.createElement("style");l.appendChild(x);DISQUS.cache.inlineStylesheet=x.sheet;if(!DISQUS.cache.inlineStylesheet){DISQUS.cache.inlineStylesheet=n.styleSheets[n.styleSheets.length-1]}if(DISQUS.browser.ie6||DISQUS.browser.ie7){s={b:(DISQUS.browser.ie6?"ie6":"ie7")}}DISQUS.requireStylesheet("http://"+DISQUS.config.domain+"/forums/"+DISQUS.config.shortname+"/styles.css",s);DISQUS.callback(DISQUS.config.callbacks.preData);w=n.getElementById("dsq-content")||n.createElement("div");w.id="dsq-content";w.style.display="none";r=n.getElementById(DISQUS.config.container_id);r.appendChild(w);DISQUS.container=n.getElementById("dsq-content");try{if(DISQUS.browser.ie6){n.execCommand("BackgroundImageCache",false,true)}}catch(v){}if(DISQUS.jsonData===null){DISQUS.require(DISQUS.config.json_url,DISQUS.config.page,true,function(){d(u)})}else{DISQUS.addJob(function(){return DISQUS.jsonData&&DISQUS.jsonData.ready},function(){d(u)})}}});b();o();function c(r){return Date.UTC(r.getUTCFullYear(),r.getUTCMonth(),r.getUTCDate(),r.getUTCHours(),r.getUTCMinutes(),r.getUTCSeconds(),r.getUTCMilliseconds())}var h=c(new Date());DISQUS.config.callbacks.onReady.push(function(){var s=DISQUS.comm.Default.recover(),r=c(new Date());s.log("load:start",h);s.log("load:length",r-h)});DISQUS.config.callbacks.afterRender.push(function(){var s=DISQUS.comm.Default.recover(),r=DISQUS.jsonData;if(r.context.switches.sigma){s.enable(r.context.sigma_chance)}if(r.forum.id){s.log("info:forum_id",r.forum.id)}if(r.thread.id){s.log("info:thread_id",r.thread.id)}if(r.request.user_type){s.log("info:user_type",r.request.user_type)}if(r.request.user_id){s.log("info:user_id",r.request.user_id)}});DISQUS.config.callbacks.onReady.push(function(){var v=false,s=false,y=DISQUS.comm.Default.recover(),r=n.getElementById("dsq-new-post"),u=null,x=n.getElementById("dsq-comments"),w=DISQUS.nodes.getPosition(x)[1]+x.offsetHeight;if(r){u=DISQUS.nodes.getPosition(r)[1]+r.offsetHeight}function t(){function z(B){var C=DISQUS.window.getScrollPosition()[1],A=C+DISQUS.window.getSize()[1];return((B>=C)&&(B<=A))}if((!v)&&r&&z(u)){v=true;y.log("viewed:comment_box",1)}if((!s)&&x&&z(w)){s=true;y.log("viewed:comments",1)}if((!r||v)&&s){DISQUS.events.remove(k,"scroll",t)}}t();DISQUS.events.add(k,"scroll",t);DISQUS.config.callbacks.preReset.push(function(){DISQUS.events.remove(k,"scroll",t)})})})(document,window);