/*!
 * Raphael 1.5.2 - JavaScript Vector Library
 * NB: Atlassian patched version - see line 1101 in unminified version
 * minified using uglifyJS at http://marijnhaverbeke.nl/uglifyjs
 *
 * Copyright (c) 2010 Dmitry Baranovskiy (http://raphaeljs.com)
 * Licensed under the MIT (http://raphaeljs.com/license.html) license.
 */
(function(){function cD(a,b,c,d,e,f){function o(a,b){var c,d,e,f,j,k;for(e=a,k=0;k<8;k++){f=m(e)-a;if(B(f)<b)return e;j=(3*i*e+2*h)*e+g;if(B(j)<1e-6)break;e=e-f/j}c=0,d=1,e=a;if(e<c)return c;if(e>d)return d;while(c<d){f=m(e);if(B(f-a)<b)return e;a>f?c=e:d=e,e=(d-c)/2+c}return e}function n(a,b){var c=o(a,b);return((l*c+k)*c+j)*c}function m(a){return((i*a+h)*a+g)*a}var g=3*b,h=3*(d-b)-g,i=1-g-h,j=3*c,k=3*(e-c)-j,l=1-j-k;return n(a,1/(200*f))}function cC(b){return function(c,d,e,f){var g={back:b};a.is(e,"function")?f=e:g.rot=e,c&&c.constructor==bO&&(c=c.attrs.path),c&&(g.along=c);return this.animate(g,d,f)}}function cq(){return this.x+q+this.y}function bn(a,b,c){function d(){var g=Array[e].slice.call(arguments,0),h=g[v]("►"),i=d.cache=d.cache||{},j=d.count=d.count||[];if(i[f](h))return c?c(i[h]):i[h];j[w]>=1e3&&delete i[j.shift()],j[L](h),i[h]=a[m](b,g);return c?c(i[h]):i[h]}return d}function bi(){var a=[],b=0;for(;b<32;b++)a[b]=(~~(y.random()*16))[H](16);a[12]=4,a[16]=(a[16]&3|8)[H](16);return"r-"+a[v]("")}function a(){if(a.is(arguments[0],G)){var b=arguments[0],d=bW[m](a,b.splice(0,3+a.is(b[0],E))),e=d.set();for(var g=0,h=b[w];g<h;g++){var i=b[g]||{};c[f](i.type)&&e[L](d[i.type]().attr(i))}return e}return bW[m](a,arguments)}a.version="1.5.2";var b=/[, ]+/,c={circle:1,rect:1,path:1,ellipse:1,text:1,image:1},d=/\{(\d+)\}/g,e="prototype",f="hasOwnProperty",g=document,h=window,i={was:Object[e][f].call(h,"Raphael"),is:h.Raphael},j=function(){this.customAttributes={}},k,l="appendChild",m="apply",n="concat",o="createTouch"in g,p="",q=" ",r=String,s="split",t="click dblclick mousedown mousemove mouseout mouseover mouseup touchstart touchmove touchend orientationchange touchcancel gesturestart gesturechange gestureend"[s](q),u={mousedown:"touchstart",mousemove:"touchmove",mouseup:"touchend"},v="join",w="length",x=r[e].toLowerCase,y=Math,z=y.max,A=y.min,B=y.abs,C=y.pow,D=y.PI,E="number",F="string",G="array",H="toString",I="fill",J=Object[e][H],K={},L="push",M=/^url\(['"]?([^\)]+?)['"]?\)$/i,N=/^\s*((#[a-f\d]{6})|(#[a-f\d]{3})|rgba?\(\s*([\d\.]+%?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\)|hsba?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\)|hsla?\(\s*([\d\.]+(?:deg|\xb0|%)?\s*,\s*[\d\.]+%?\s*,\s*[\d\.]+(?:%?\s*,\s*[\d\.]+)?)%?\s*\))\s*$/i,O={NaN:1,Infinity:1,"-Infinity":1},P=/^(?:cubic-)?bezier\(([^,]+),([^,]+),([^,]+),([^\)]+)\)/,Q=y.round,R="setAttribute",S=parseFloat,T=parseInt,U=" progid:DXImageTransform.Microsoft",V="webkitTapHighlightColor",W=r[e].toUpperCase,X={blur:0,"clip-rect":"0 0 1e9 1e9",cursor:"default",cx:0,cy:0,fill:"#fff","fill-opacity":1,font:'10px "Arial"',"font-family":'"Arial"',"font-size":"10","font-style":"normal","font-weight":400,gradient:0,height:0,href:"http://raphaeljs.com/",opacity:1,path:"M0,0",r:0,rotation:0,rx:0,ry:0,scale:"1 1",src:"",stroke:"#000","stroke-dasharray":"","stroke-linecap":"butt","stroke-linejoin":"butt","stroke-miterlimit":0,"stroke-opacity":1,"stroke-width":1,target:"_blank","text-anchor":"middle",title:"Raphael",translation:"0 0",width:0,x:0,y:0},Y={along:"along",blur:E,"clip-rect":"csv",cx:E,cy:E,fill:"colour","fill-opacity":E,"font-size":E,height:E,opacity:E,path:"path",r:E,rotation:"csv",rx:E,ry:E,scale:"csv",stroke:"colour","stroke-opacity":E,"stroke-width":E,translation:"csv",width:E,x:E,y:E},Z="replace",$=/^(from|to|\d+%?)/,_=/\s*,\s*/,ba={hs:1,rg:1},bb=/,?([achlmqrstvxz]),?/gi,bc=/([achlmqstvz])[\s,]*((-?\d*\.?\d*(?:e[-+]?\d+)?\s*,?\s*)+)/ig,bd=/(-?\d*\.?\d*(?:e[-+]?\d+)?)\s*,?\s*/ig,be=/^r(?:\(([^,]+?)\s*,\s*([^\)]+?)\))?/,bf=function(a,b){return a.key-b.key};a.type=h.SVGAngle||g.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure","1.1")?"SVG":"VML";if(a.type=="VML"){var bg=g.createElement("div"),bh;bg.innerHTML='<v:shape adj="1"/>',bh=bg.firstChild,bh.style.behavior="url(#default#VML)";if(!bh||typeof bh.adj!="object")return a.type=null;bg=null}a.svg=!(a.vml=a.type=="VML"),j[e]=a[e],k=j[e],a._id=0,a._oid=0,a.fn={},a.is=function(a,b){b=x.call(b);if(b=="finite")return!O[f](+a);return b=="null"&&a===null||b==typeof a||b=="object"&&a===Object(a)||b=="array"&&Array.isArray&&Array.isArray(a)||J.call(a).slice(8,-1).toLowerCase()==b},a.angle=function(b,c,d,e,f,g){if(f==null){var h=b-d,i=c-e;if(!h&&!i)return 0;return((h<0)*180+y.atan(-i/-h)*180/D+360)%360}return a.angle(b,c,f,g)-a.angle(d,e,f,g)},a.rad=function(a){return a%360*D/180},a.deg=function(a){return a*180/D%360},a.snapTo=function(b,c,d){d=a.is(d,"finite")?d:10;if(a.is(b,G)){var e=b.length;while(e--)if(B(b[e]-c)<=d)return b[e]}else{b=+b;var f=c%b;if(f<d)return c-f;if(f>b-d)return c-f+b}return c},a.setWindow=function(a){h=a,g=h.document};var bj=function(b){if(a.vml){var c=/^\s+|\s+$/g,d;try{var e=new ActiveXObject("htmlfile");e.write("<body>"),e.close(),d=e.body}catch(f){d=createPopup().document.body}var h=d.createTextRange();bj=bn(function(a){try{d.style.color=r(a)[Z](c,p);var b=h.queryCommandValue("ForeColor");b=(b&255)<<16|b&65280|(b&16711680)>>>16;return"#"+("000000"+b[H](16)).slice(-6)}catch(e){return"none"}})}else{var i=g.createElement("i");i.title="Raphaël Colour Picker",i.style.display="none",g.body[l](i),bj=bn(function(a){i.style.color=a;return g.defaultView.getComputedStyle(i,p).getPropertyValue("color")})}return bj(b)},bk=function(){return"hsb("+[this.h,this.s,this.b]+")"},bl=function(){return"hsl("+[this.h,this.s,this.l]+")"},bm=function(){return this.hex};a.hsb2rgb=function(b,c,d,e){a.is(b,"object")&&"h"in b&&"s"in b&&"b"in b&&(d=b.b,c=b.s,b=b.h,e=b.o);return a.hsl2rgb(b,c,d/2,e)},a.hsl2rgb=function(b,c,d,e){a.is(b,"object")&&"h"in b&&"s"in b&&"l"in b&&(d=b.l,c=b.s,b=b.h);if(b>1||c>1||d>1)b/=360,c/=100,d/=100;var f={},g=["r","g","b"],h,i,j,k,l,m;if(!c)f={r:d,g:d,b:d};else{d<.5?h=d*(1+c):h=d+c-d*c,i=2*d-h;for(var n=0;n<3;n++)j=b+1/3*-(n-1),j<0&&j++,j>1&&j--,j*6<1?f[g[n]]=i+(h-i)*6*j:j*2<1?f[g[n]]=h:j*3<2?f[g[n]]=i+(h-i)*(2/3-j)*6:f[g[n]]=i}f.r*=255,f.g*=255,f.b*=255,f.hex="#"+(16777216|f.b|f.g<<8|f.r<<16).toString(16).slice(1),a.is(e,"finite")&&(f.opacity=e),f.toString=bm;return f},a.rgb2hsb=function(b,c,d){c==null&&a.is(b,"object")&&"r"in b&&"g"in b&&"b"in b&&(d=b.b,c=b.g,b=b.r);if(c==null&&a.is(b,F)){var e=a.getRGB(b);b=e.r,c=e.g,d=e.b}if(b>1||c>1||d>1)b/=255,c/=255,d/=255;var f=z(b,c,d),g=A(b,c,d),h,i,j=f;if(g==f)return{h:0,s:0,b:f,toString:bk};var k=f-g;i=k/f,b==f?h=(c-d)/k:c==f?h=2+(d-b)/k:h=4+(b-c)/k,h/=6,h<0&&h++,h>1&&h--;return{h:h,s:i,b:j,toString:bk}},a.rgb2hsl=function(b,c,d){c==null&&a.is(b,"object")&&"r"in b&&"g"in b&&"b"in b&&(d=b.b,c=b.g,b=b.r);if(c==null&&a.is(b,F)){var e=a.getRGB(b);b=e.r,c=e.g,d=e.b}if(b>1||c>1||d>1)b/=255,c/=255,d/=255;var f=z(b,c,d),g=A(b,c,d),h,i,j=(f+g)/2,k;if(g==f)k={h:0,s:0,l:j};else{var l=f-g;i=j<.5?l/(f+g):l/(2-f-g),b==f?h=(c-d)/l:c==f?h=2+(d-b)/l:h=4+(b-c)/l,h/=6,h<0&&h++,h>1&&h--,k={h:h,s:i,l:j}}k.toString=bl;return k},a._path2string=function(){return this.join(",")[Z](bb,"$1")},a.getRGB=bn(function(b){if(!b||!!((b=r(b)).indexOf("-")+1))return{r:-1,g:-1,b:-1,hex:"none",error:1};if(b=="none")return{r:-1,g:-1,b:-1,hex:"none"};!ba[f](b.toLowerCase().substring(0,2))&&b.charAt()!="#"&&(b=bj(b));var c,d,e,g,h,i,j,k=b.match(N);if(k){k[2]&&(g=T(k[2].substring(5),16),e=T(k[2].substring(3,5),16),d=T(k[2].substring(1,3),16)),k[3]&&(g=T((i=k[3].charAt(3))+i,16),e=T((i=k[3].charAt(2))+i,16),d=T((i=k[3].charAt(1))+i,16)),k[4]&&(j=k[4][s](_),d=S(j[0]),j[0].slice(-1)=="%"&&(d*=2.55),e=S(j[1]),j[1].slice(-1)=="%"&&(e*=2.55),g=S(j[2]),j[2].slice(-1)=="%"&&(g*=2.55),k[1].toLowerCase().slice(0,4)=="rgba"&&(h=S(j[3])),j[3]&&j[3].slice(-1)=="%"&&(h/=100));if(k[5]){j=k[5][s](_),d=S(j[0]),j[0].slice(-1)=="%"&&(d*=2.55),e=S(j[1]),j[1].slice(-1)=="%"&&(e*=2.55),g=S(j[2]),j[2].slice(-1)=="%"&&(g*=2.55),(j[0].slice(-3)=="deg"||j[0].slice(-1)=="°")&&(d/=360),k[1].toLowerCase().slice(0,4)=="hsba"&&(h=S(j[3])),j[3]&&j[3].slice(-1)=="%"&&(h/=100);return a.hsb2rgb(d,e,g,h)}if(k[6]){j=k[6][s](_),d=S(j[0]),j[0].slice(-1)=="%"&&(d*=2.55),e=S(j[1]),j[1].slice(-1)=="%"&&(e*=2.55),g=S(j[2]),j[2].slice(-1)=="%"&&(g*=2.55),(j[0].slice(-3)=="deg"||j[0].slice(-1)=="°")&&(d/=360),k[1].toLowerCase().slice(0,4)=="hsla"&&(h=S(j[3])),j[3]&&j[3].slice(-1)=="%"&&(h/=100);return a.hsl2rgb(d,e,g,h)}k={r:d,g:e,b:g},k.hex="#"+(16777216|g|e<<8|d<<16).toString(16).slice(1),a.is(h,"finite")&&(k.opacity=h);return k}return{r:-1,g:-1,b:-1,hex:"none",error:1}},a),a.getColor=function(a){var b=this.getColor.start=this.getColor.start||{h:0,s:1,b:a||.75},c=this.hsb2rgb(b.h,b.s,b.b);b.h+=.075,b.h>1&&(b.h=0,b.s-=.2,b.s<=0&&(this.getColor.start={h:0,s:1,b:b.b}));return c.hex},a.getColor.reset=function(){delete this.start},a.parsePathString=bn(function(b){if(!b)return null;var c={a:7,c:6,h:1,l:2,m:2,q:4,s:4,t:2,v:1,z:0},d=[];a.is(b,G)&&a.is(b[0],G)&&(d=bp(b)),d[w]||r(b)[Z](bc,function(a,b,e){var f=[],g=x.call(b);e[Z](bd,function(a,b){b&&f[L](+b)}),g=="m"&&f[w]>2&&(d[L]([b][n](f.splice(0,2))),g="l",b=b=="m"?"l":"L");while(f[w]>=c[g]){d[L]([b][n](f.splice(0,c[g])));if(!c[g])break}}),d[H]=a._path2string;return d}),a.findDotsAtSegment=function(a,b,c,d,e,f,g,h,i){var j=1-i,k=C(j,3)*a+C(j,2)*3*i*c+j*3*i*i*e+C(i,3)*g,l=C(j,3)*b+C(j,2)*3*i*d+j*3*i*i*f+C(i,3)*h,m=a+2*i*(c-a)+i*i*(e-2*c+a),n=b+2*i*(d-b)+i*i*(f-2*d+b),o=c+2*i*(e-c)+i*i*(g-2*e+c),p=d+2*i*(f-d)+i*i*(h-2*f+d),q=(1-i)*a+i*c,r=(1-i)*b+i*d,s=(1-i)*e+i*g,t=(1-i)*f+i*h,u=90-y.atan((m-o)/(n-p))*180/D;(m>o||n<p)&&(u+=180);return{x:k,y:l,m:{x:m,y:n},n:{x:o,y:p},start:{x:q,y:r},end:{x:s,y:t},alpha:u}};var bo=bn(function(a){if(!a)return{x:0,y:0,width:0,height:0};a=bx(a);var b=0,c=0,d=[],e=[],f;for(var g=0,h=a[w];g<h;g++){f=a[g];if(f[0]=="M")b=f[1],c=f[2],d[L](b),e[L](c);else{var i=bw(b,c,f[1],f[2],f[3],f[4],f[5],f[6]);d=d[n](i.min.x,i.max.x),e=e[n](i.min.y,i.max.y),b=f[5],c=f[6]}}var j=A[m](0,d),k=A[m](0,e);return{x:j,y:k,width:z[m](0,d)-j,height:z[m](0,e)-k}}),bp=function(b){var c=[];if(!a.is(b,G)||!a.is(b&&b[0],G))b=a.parsePathString(b);for(var d=0,e=b[w];d<e;d++){c[d]=[];for(var f=0,g=b[d][w];f<g;f++)c[d][f]=b[d][f]}c[H]=a._path2string;return c},bq=bn(function(b){if(!a.is(b,G)||!a.is(b&&b[0],G))b=a.parsePathString(b);var c=[],d=0,e=0,f=0,g=0,h=0;b[0][0]=="M"&&(d=b[0][1],e=b[0][2],f=d,g=e,h++,c[L](["M",d,e]));for(var i=h,j=b[w];i<j;i++){var k=c[i]=[],l=b[i];if(l[0]!=x.call(l[0])){k[0]=x.call(l[0]);switch(k[0]){case"a":k[1]=l[1],k[2]=l[2],k[3]=l[3],k[4]=l[4],k[5]=l[5],k[6]=+(l[6]-d).toFixed(3),k[7]=+(l[7]-e).toFixed(3);break;case"v":k[1]=+(l[1]-e).toFixed(3);break;case"m":f=l[1],g=l[2];default:for(var m=1,n=l[w];m<n;m++)k[m]=+(l[m]-(m%2?d:e)).toFixed(3)}}else{k=c[i]=[],l[0]=="m"&&(f=l[1]+d,g=l[2]+e);for(var o=0,p=l[w];o<p;o++)c[i][o]=l[o]}var q=c[i][w];switch(c[i][0]){case"z":d=f,e=g;break;case"h":d+=+c[i][q-1];break;case"v":e+=+c[i][q-1];break;default:d+=+c[i][q-2],e+=+c[i][q-1]}}c[H]=a._path2string;return c},0,bp),br=bn(function(b){if(!a.is(b,G)||!a.is(b&&b[0],G))b=a.parsePathString(b);var c=[],d=0,e=0,f=0,g=0,h=0;b[0][0]=="M"&&(d=+b[0][1],e=+b[0][2],f=d,g=e,h++,c[0]=["M",d,e]);for(var i=h,j=b[w];i<j;i++){var k=c[i]=[],l=b[i];if(l[0]!=W.call(l[0])){k[0]=W.call(l[0]);switch(k[0]){case"A":k[1]=l[1],k[2]=l[2],k[3]=l[3],k[4]=l[4],k[5]=l[5],k[6]=+(l[6]+d),k[7]=+(l[7]+e);break;case"V":k[1]=+l[1]+e;break;case"H":k[1]=+l[1]+d;break;case"M":f=+l[1]+d,g=+l[2]+e;default:for(var m=1,n=l[w];m<n;m++)k[m]=+l[m]+(m%2?d:e)}}else for(var o=0,p=l[w];o<p;o++)c[i][o]=l[o];switch(k[0]){case"Z":d=f,e=g;break;case"H":d=k[1];break;case"V":e=k[1];break;case"M":f=c[i][c[i][w]-2],g=c[i][c[i][w]-1];default:d=c[i][c[i][w]-2],e=c[i][c[i][w]-1]}}c[H]=a._path2string;return c},null,bp),bs=function(a,b,c,d){return[a,b,c,d,c,d]},bt=function(a,b,c,d,e,f){var g=1/3,h=2/3;return[g*a+h*c,g*b+h*d,g*e+h*c,g*f+h*d,e,f]},bu=function(a,b,c,d,e,f,g,h,i,j){var k=D*120/180,l=D/180*(+e||0),m=[],o,p=bn(function(a,b,c){var d=a*y.cos(c)-b*y.sin(c),e=a*y.sin(c)+b*y.cos(c);return{x:d,y:e}});if(!j){o=p(a,b,-l),a=o.x,b=o.y,o=p(h,i,-l),h=o.x,i=o.y;var q=y.cos(D/180*e),r=y.sin(D/180*e),t=(a-h)/2,u=(b-i)/2,x=t*t/(c*c)+u*u/(d*d);x>1&&(x=y.sqrt(x),c=x*c,d=x*d);var z=c*c,A=d*d,C=(f==g?-1:1)*y.sqrt(B((z*A-z*u*u-A*t*t)/(z*u*u+A*t*t))),E=C*c*u/d+(a+h)/2,F=C*-d*t/c+(b+i)/2,G=y.asin(((b-F)/d).toFixed(9)),H=y.asin(((i-F)/d).toFixed(9));G=a<E?D-G:G,H=h<E?D-H:H,G<0&&(G=D*2+G),H<0&&(H=D*2+H),g&&G>H&&(G=G-D*2),!g&&H>G&&(H=H-D*2)}else G=j[0],H=j[1],E=j[2],F=j[3];var I=H-G;if(B(I)>k){var J=H,K=h,L=i;H=G+k*(g&&H>G?1:-1),h=E+c*y.cos(H),i=F+d*y.sin(H),m=bu(h,i,c,d,e,0,g,K,L,[H,J,E,F])}I=H-G;var M=y.cos(G),N=y.sin(G),O=y.cos(H),P=y.sin(H),Q=y.tan(I/4),R=4/3*c*Q,S=4/3*d*Q,T=[a,b],U=[a+R*N,b-S*M],V=[h+R*P,i-S*O],W=[h,i];U[0]=2*T[0]-U[0],U[1]=2*T[1]-U[1];if(j)return[U,V,W][n](m);m=[U,V,W][n](m)[v]()[s](",");var X=[];for(var Y=0,Z=m[w];Y<Z;Y++)X[Y]=Y%2?p(m[Y-1],m[Y],l).y:p(m[Y],m[Y+1],l).x;return X},bv=function(a,b,c,d,e,f,g,h,i){var j=1-i;return{x:C(j,3)*a+C(j,2)*3*i*c+j*3*i*i*e+C(i,3)*g,y:C(j,3)*b+C(j,2)*3*i*d+j*3*i*i*f+C(i,3)*h}},bw=bn(function(a,b,c,d,e,f,g,h){var i=e-2*c+a-(g-2*e+c),j=2*(c-a)-2*(e-c),k=a-c,l=(-j+y.sqrt(j*j-4*i*k))/2/i,n=(-j-y.sqrt(j*j-4*i*k))/2/i,o=[b,h],p=[a,g],q;B(l)>"1e12"&&(l=.5),B(n)>"1e12"&&(n=.5),l>0&&l<1&&(q=bv(a,b,c,d,e,f,g,h,l),p[L](q.x),o[L](q.y)),n>0&&n<1&&(q=bv(a,b,c,d,e,f,g,h,n),p[L](q.x),o[L](q.y)),i=f-2*d+b-(h-2*f+d),j=2*(d-b)-2*(f-d),k=b-d,l=(-j+y.sqrt(j*j-4*i*k))/2/i,n=(-j-y.sqrt(j*j-4*i*k))/2/i,B(l)>"1e12"&&(l=.5),B(n)>"1e12"&&(n=.5),l>0&&l<1&&(q=bv(a,b,c,d,e,f,g,h,l),p[L](q.x),o[L](q.y)),n>0&&n<1&&(q=bv(a,b,c,d,e,f,g,h,n),p[L](q.x),o[L](q.y));return{min:{x:A[m](0,p),y:A[m](0,o)},max:{x:z[m](0,p),y:z[m](0,o)}}}),bx=bn(function(a,b){var c=br(a),d=b&&br(b),e={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},f={x:0,y:0,bx:0,by:0,X:0,Y:0,qx:null,qy:null},g=function(a,b){var c,d;if(!a)return["C",b.x,b.y,b.x,b.y,b.x,b.y];!(a[0]in{T:1,Q:1})&&(b.qx=b.qy=null);switch(a[0]){case"M":b.X=a[1],b.Y=a[2];break;case"A":a=["C"][n](bu[m](0,[b.x,b.y][n](a.slice(1))));break;case"S":c=b.x+(b.x-(b.bx||b.x)),d=b.y+(b.y-(b.by||b.y)),a=["C",c,d][n](a.slice(1));break;case"T":b.qx=b.x+(b.x-(b.qx||b.x)),b.qy=b.y+(b.y-(b.qy||b.y)),a=["C"][n](bt(b.x,b.y,b.qx,b.qy,a[1],a[2]));break;case"Q":b.qx=a[1],b.qy=a[2],a=["C"][n](bt(b.x,b.y,a[1],a[2],a[3],a[4]));break;case"L":a=["C"][n](bs(b.x,b.y,a[1],a[2]));break;case"H":a=["C"][n](bs(b.x,b.y,a[1],b.y));break;case"V":a=["C"][n](bs(b.x,b.y,b.x,a[1]));break;case"Z":a=["C"][n](bs(b.x,b.y,b.X,b.Y))}return a},h=function(a,b){if(a[b][w]>7){a[b].shift();var e=a[b];while(e[w])a.splice(b++,0,["C"][n](e.splice(0,6)));a.splice(b,1),k=z(c[w],d&&d[w]||0)}},i=function(a,b,e,f,g){a&&b&&a[g][0]=="M"&&b[g][0]!="M"&&(b.splice(g,0,["M",f.x,f.y]),e.bx=0,e.by=0,e.x=a[g][1],e.y=a[g][2],k=z(c[w],d&&d[w]||0))};for(var j=0,k=z(c[w],d&&d[w]||0);j<k;j++){c[j]=g(c[j],e),h(c,j),d&&(d[j]=g(d[j],f)),d&&h(d,j),i(c,d,e,f,j),i(d,c,f,e,j);var l=c[j],o=d&&d[j],p=l[w],q=d&&o[w];e.x=l[p-2],e.y=l[p-1],e.bx=S(l[p-4])||e.x,e.by=S(l[p-3])||e.y,f.bx=d&&(S(o[q-4])||f.x),f.by=d&&(S(o[q-3])||f.y),f.x=d&&o[q-2],f.y=d&&o[q-1]}return d?[c,d]:c},null,bp),by=bn(function(b){var c=[];for(var d=0,e=b[w];d<e;d++){var f={},g=b[d].match(/^([^:]*):?([\d\.]*)/);f.color=a.getRGB(g[1]);if(f.color.error)return null;f.color=f.color.hex,g[2]&&(f.offset=g[2]+"%"),c[L](f)}for(d=1,e=c[w]-1;d<e;d++)if(!c[d].offset){var h=S(c[d-1].offset||0),i=0;for(var j=d+1;j<e;j++)if(c[j].offset){i=c[j].offset;break}i||(i=100,j=e),i=S(i);var k=(i-h)/(j-d+1);for(;d<j;d++)h+=k,c[d].offset=h+"%"}return c}),bz=function(b,c,d,e){var f;if(!a.is(b,F)&&!a.is(b,"object"))return{container:1,x:b,y:c,width:d,height:e};f=a.is(b,F)?g.getElementById(b):b;if(f.tagName)return c==null?{container:f,width:f.style.pixelWidth||f.offsetWidth,height:f.style.pixelHeight||f.offsetHeight}:{container:f,width:c,height:d}},bA=function(a,b){var c=this;for(var d in b)if(b[f](d)&&!(d in a))switch(typeof b[d]){case"function":(function(b){a[d]=a===c?b:function(){return b[m](c,arguments)}})(b[d]);break;case"object":a[d]=a[d]||{},bA.call(this,a[d],b[d]);break;default:a[d]=b[d]}},bB=function(a,b){a==b.top&&(b.top=a.prev),a==b.bottom&&(b.bottom=a.next),a.next&&(a.next.prev=a.prev),a.prev&&(a.prev.next=a.next)},bC=function(a,b){b.top!==a&&(bB(a,b),a.next=null,a.prev=b.top,b.top.next=a,b.top=a)},bD=function(a,b){b.bottom!==a&&(bB(a,b),a.next=b.bottom,a.prev=null,b.bottom.prev=a,b.bottom=a)},bE=function(a,b,c){bB(a,c),b==c.top&&(c.top=a),b.next&&(b.next.prev=a),a.next=b.next,a.prev=b,b.next=a},bF=function(a,b,c){bB(a,c),b==c.bottom&&(c.bottom=a),b.prev&&(b.prev.next=a),a.prev=b.prev,b.prev=a,a.next=b},bG=function(a){return function(){throw new Error("Raphaël: you are calling to method “"+a+"” of removed object")}};a.pathToRelative=bq;if(a.svg){k.svgns="http://www.w3.org/2000/svg",k.xlink="http://www.w3.org/1999/xlink",Q=function(a){return+a+(~~a===a)*.5};var bH=function(a,b){if(!b){a=g.createElementNS(k.svgns,a),a.style&&(a.style.webkitTapHighlightColor="rgba(0,0,0,0)");return a}for(var c in b)b[f](c)&&a[R](c,r(b[c]))};a[H]=function(){return"Your browser supports SVG.\nYou are running Raphaël "+this.version};var bI=function(a,b){var c=bH("path");b.canvas&&b.canvas[l](c);var d=new bO(c,b);d.type="path",bL(d,{fill:"none",stroke:"#000",path:a});return d},bJ=function(a,b,c){var d="linear",e=.5,f=.5,h=a.style;b=r(b)[Z](be,function(a,b,c){d="radial";if(b&&c){e=S(b),f=S(c);var g=(f>.5)*2-1;C(e-.5,2)+C(f-.5,2)>.25&&(f=y.sqrt(.25-C(e-.5,2))*g+.5)&&f!=.5&&(f=f.toFixed(5)-1e-5*g)}return p}),b=b[s](/\s*\-\s*/);if(d=="linear"){var i=b.shift();i=-S(i);if(isNaN(i))return null;var j=[0,0,y.cos(i*D/180),y.sin(i*D/180)],k=1/(z(B(j[2]),B(j[3]))||1);j[2]*=k,j[3]*=k,j[2]<0&&(j[0]=-j[2],j[2]=0),j[3]<0&&(j[1]=-j[3],j[3]=0)}var m=by(b);if(!m)return null;var n=a.getAttribute(I);n=n.match(/^url\(#(.*)\)$/),n&&c.defs.removeChild(g.getElementById(n[1]));var o=bH(d+"Gradient");o.id=bi(),bH(o,d=="radial"?{fx:e,fy:f}:{x1:j[0],y1:j[1],x2:j[2],y2:j[3]}),c.defs[l](o);for(var q=0,t=m[w];q<t;q++){var u=bH("stop");bH(u,{offset:m[q].offset?m[q].offset:q?"100%":"0%","stop-color":m[q].color||"#fff"}),o[l](u)}bH(a,{fill:"url(#"+o.id+")",opacity:1,"fill-opacity":1}),h.fill=p,h.opacity=1,h.fillOpacity=1;return 1},bK=function(b){var c=b.getBBox();bH(b.pattern,{patternTransform:a.format("translate({0},{1})",c.x,c.y)})},bL=function(c,d){var e={"":[0],none:[0],"-":[3,1],".":[1,1],"-.":[3,1,1,1],"-..":[3,1,1,1,1,1],". ":[1,3],"- ":[4,3],"--":[8,3],"- .":[4,3,1,3],"--.":[8,3,1,3],"--..":[8,3,1,3,1,3]},h=c.node,i=c.attrs,j=c.rotate(),k=function(a,b){b=e[x.call(b)];if(b){var c=a.attrs["stroke-width"]||"1",f=({round:c,square:c,butt:0})[a.attrs["stroke-linecap"]||d["stroke-linecap"]]||0,g=[],i=b[w];while(i--)g[i]=b[i]*c+(i%2?1:-1)*f;bH(h,{"stroke-dasharray":g[v](",")})}};d[f]("rotation")&&(j=d.rotation);var m=r(j)[s](b);m.length-1?(m[1]=+m[1],m[2]=+m[2]):m=null,S(j)&&c.rotate(0,!0);for(var n in d)if(d[f](n)){if(!X[f](n))continue;var o=d[n];i[n]=o;switch(n){case"blur":c.blur(o);break;case"rotation":c.rotate(o,!0);break;case"href":case"title":case"target":var t=h.parentNode;if(x.call(t.tagName)!="a"){var u=bH("a");t.insertBefore(u,h),u[l](h),t=u}n=="target"&&o=="blank"?t.setAttributeNS(c.paper.xlink,"show","new"):t.setAttributeNS(c.paper.xlink,n,o);break;case"cursor":h.style.cursor=o;break;case"clip-rect":var y=r(o)[s](b);if(y[w]==4){c.clip&&c.clip.parentNode.parentNode.removeChild(c.clip.parentNode);var z=bH("clipPath"),A=bH("rect");z.id=bi(),bH(A,{x:y[0],y:y[1],width:y[2],height:y[3]}),z[l](A),c.paper.defs[l](z),bH(h,{"clip-path":"url(#"+z.id+")"}),c.clip=A}if(!o){var B=g.getElementById(h.getAttribute("clip-path")[Z](/(^url\(#|\)$)/g,p));B&&B.parentNode.removeChild(B),bH(h,{"clip-path":p}),delete c.clip}break;case"path":c.type=="path"&&bH(h,{d:o?i.path=br(o):"M0,0"});break;case"width":h[R](n,o);if(i.fx)n="x",o=i.x;else break;case"x":i.fx&&(o=-i.x-(i.width||0));case"rx":if(n=="rx"&&c.type=="rect")break;case"cx":m&&(n=="x"||n=="cx")&&(m[1]+=o-i[n]),h[R](n,o),c.pattern&&bK(c);break;case"height":h[R](n,o);if(i.fy)n="y",o=i.y;else break;case"y":i.fy&&(o=-i.y-(i.height||0));case"ry":if(n=="ry"&&c.type=="rect")break;case"cy":m&&(n=="y"||n=="cy")&&(m[2]+=o-i[n]),h[R](n,o),c.pattern&&bK(c);break;case"r":c.type=="rect"?bH(h,{rx:o,ry:o}):h[R](n,o);break;case"src":c.type=="image"&&h.setAttributeNS(c.paper.xlink,"href",o);break;case"stroke-width":h.style.strokeWidth=o,h[R](n,o),i["stroke-dasharray"]&&k(c,i["stroke-dasharray"]);break;case"stroke-dasharray":k(c,o);break;case"translation":var C=r(o)[s](b);C[0]=+C[0]||0,C[1]=+C[1]||0,m&&(m[1]+=C[0],m[2]+=C[1]),cB.call(c,C[0],C[1]);break;case"scale":C=r(o)[s](b),c.scale(+C[0]||1,+C[1]||+C[0]||1,isNaN(S(C[2]))?null:+C[2],isNaN(S(C[3]))?null:+C[3]);break;case I:var D=r(o).match(M);if(D){z=bH("pattern");var E=bH("image");z.id=bi(),bH(z,{x:0,y:0,patternUnits:"userSpaceOnUse",height:1,width:1}),bH(E,{x:0,y:0}),E.setAttributeNS(c.paper.xlink,"href",D[1]),z[l](E);var F=g.createElement("img");F.style.cssText="position:absolute;left:-9999em;top-9999em",F.onload=function(){bH(z,{width:this.offsetWidth,height:this.offsetHeight}),bH(E,{width:this.offsetWidth,height:this.offsetHeight}),g.body.removeChild(this),c.paper.safari()},g.body[l](F),F.src=D[1],c.paper.defs[l](z),h.style.fill="url(#"+z.id+")",bH(h,{fill:"url(#"+z.id+")"}),c.pattern=z,c.pattern&&bK(c);break}var G=a.getRGB(o);if(!G.error)delete d.gradient,delete i.gradient,!a.is(i.opacity,"undefined")&&a.is(d.opacity,"undefined")&&bH(h,{opacity:i.opacity}),!a.is(i["fill-opacity"],"undefined")&&a.is(d["fill-opacity"],"undefined")&&bH(h,{"fill-opacity":i["fill-opacity"]});else if((({circle:1,ellipse:1})[f](c.type)||r(o).charAt()!="r")&&bJ(h,o,c.paper)){i.gradient=o,i.fill="none";break}G[f]("opacity")&&bH(h,{"fill-opacity":G.opacity>1?G.opacity/100:G.opacity});case"stroke":G=a.getRGB(o),h[R](n,G.hex),n=="stroke"&&G[f]("opacity")&&bH(h,{"stroke-opacity":G.opacity>1?G.opacity/100:G.opacity});break;case"gradient":(({circle:1,ellipse:1})[f](c.type)||r(o).charAt()!="r")&&bJ(h,o,c.paper);break;case"opacity":i.gradient&&!i[f]("stroke-opacity")&&bH(h,{"stroke-opacity":o>1?o/100:o});case"fill-opacity":if(i.gradient){var H=g.getElementById(h.getAttribute(I)[Z](/^url\(#|\)$/g,p));if(H){var J=H.getElementsByTagName("stop");J[J[w]-1][R]("stop-opacity",o)}break};default:n=="font-size"&&(o=T(o,10)+"px");var K=n[Z](/(\-.)/g,function(a){return W.call(a.substring(1))});h.style[K]=o,h[R](n,o)}}bN(c,d),m?c.rotate(m.join(q)):S(j)&&c.rotate(j,!0)},bM=1.2,bN=function(b,c){if(b.type=="text"&&!!(c[f]("text")||c[f]("font")||c[f]("font-size")||c[f]("x")||c[f]("y"))){var d=b.attrs,e=b.node,h=e.firstChild?T(g.defaultView.getComputedStyle(e.firstChild,p).getPropertyValue("font-size"),10):10;if(c[f]("text")){d.text=c.text;while(e.firstChild)e.removeChild(e.firstChild);var i=r(c.text)[s]("\n");for(var j=0,k=i[w];j<k;j++)if(i[j]){var m=bH("tspan");j&&bH(m,{dy:h*bM,x:d.x}),m[l](g.createTextNode(i[j])),e[l](m)}}else{i=e.getElementsByTagName("tspan");for(j=0,k=i[w];j<k;j++)j&&bH(i[j],{dy:h*bM,x:d.x})}bH(e,{y:d.y});var n=b.getBBox(),o=d.y-(n.y+n.height/2);o&&a.is(o,"finite")&&bH(e,{y:d.y+o})}},bO=function(b,c){var d=0,e=0;this[0]=b,this.id=a._oid++,this.node=b,b.raphael=this,this.paper=c,this.attrs=this.attrs||{},this.transformations=[],this._={tx:0,ty:0,rt:{deg:0,cx:0,cy:0},sx:1,sy:1},!c.bottom&&(c.bottom=this),this.prev=c.top,c.top&&(c.top.next=this),c.top=this,this.next=null},bP=bO[e];bO[e].rotate=function(c,d,e){if(this.removed)return this;if(c==null){if(this._.rt.cx)return[this._.rt.deg,this._.rt.cx,this._.rt.cy][v](q);return this._.rt.deg}var f=this.getBBox();c=r(c)[s](b),c[w]-1&&(d=S(c[1]),e=S(c[2])),c=S(c[0]),d!=null&&d!==!1?this._.rt.deg=c:this._.rt.deg+=c,e==null&&(d=null),this._.rt.cx=d,this._.rt.cy=e,d=d==null?f.x+f.width/2:d,e=e==null?f.y+f.height/2:e,this._.rt.deg?(this.transformations[0]=a.format("rotate({0} {1} {2})",this._.rt.deg,d,e),this.clip&&bH(this.clip,{transform:a.format("rotate({0} {1} {2})",-this._.rt.deg,d,e)})):(this.transformations[0]=p,this.clip&&bH(this.clip,{transform:p})),bH(this.node,{transform:this.transformations[v](q)});return this},bO[e].hide=function(){!this.removed&&(this.node.style.display="none");return this},bO[e].show=function(){!this.removed&&(this.node.style.display="");return this},bO[e].remove=function(){if(!this.removed){bB(this,this.paper),this.node.parentNode.removeChild(this.node);for(var a in this)delete this[a];this.removed=!0}},bO[e].getBBox=function(){if(this.removed)return this;if(this.type=="path")return bo(this.attrs.path);if(this.node.style.display=="none"){this.show();var a=!0}var b={};try{b=this.node.getBBox()}catch(c){}finally{b=b||{}}if(this.type=="text"){b={x:b.x,y:Infinity,width:0,height:0};for(var d=0,e=this.node.getNumberOfChars();d<e;d++){var f=this.node.getExtentOfChar(d);f.y<b.y&&(b.y=f.y),f.y+f.height-b.y>b.height&&(b.height=f.y+f.height-b.y),f.x+f.width-b.x>b.width&&(b.width=f.x+f.width-b.x)}}a&&this.hide();return b},bO[e].attr=function(b,c){if(this.removed)return this;if(b==null){var d={};for(var e in this.attrs)this.attrs[f](e)&&(d[e]=this.attrs[e]);this._.rt.deg&&(d.rotation=this.rotate()),(this._.sx!=1||this._.sy!=1)&&(d.scale=this.scale()),d.gradient&&d.fill=="none"&&(d.fill=d.gradient)&&delete d.gradient;return d}if(c==null&&a.is(b,F)){if(b=="translation")return cB.call(this);if(b=="rotation")return this.rotate();if(b=="scale")return this.scale();if(b==I&&this.attrs.fill=="none"&&this.attrs.gradient)return this.attrs.gradient;return this.attrs[b]}if(c==null&&a.is(b,G)){var g={};for(var h=0,i=b.length;h<i;h++)g[b[h]]=this.attr(b[h]);return g}if(c!=null){var j={};j[b]=c}else b!=null&&a.is(b,"object")&&(j=b);for(var k in this.paper.customAttributes)if(this.paper.customAttributes[f](k)&&j[f](k)&&a.is(this.paper.customAttributes[k],"function")){var l=this.paper.customAttributes[k].apply(this,[][n](j[k]));this.attrs[k]=j[k];for(var m in l)l[f](m)&&(j[m]=l[m])}bL(this,j);return this},bO[e].toFront=function(){if(this.removed)return this;this.node.parentNode[l](this.node);var a=this.paper;a.top!=this&&bC(this,a);return this},bO[e].toBack=function(){if(this.removed)return this;if(this.node.parentNode.firstChild!=this.node){this.node.parentNode.insertBefore(this.node,this.node.parentNode.firstChild),bD(this,this.paper);var a=this.paper}return this},bO[e].insertAfter=function(a){if(this.removed)return this;var b=a.node||a[a.length-1].node;b.nextSibling?b.parentNode.insertBefore(this.node,b.nextSibling):b.parentNode[l](this.node),bE(this,a,this.paper);return this},bO[e].insertBefore=function(a){if(this.removed)return this;var b=a.node||a[0].node;b.parentNode.insertBefore(this.node,b),bF(this,a,this.paper);return this},bO[e].blur=function(a){var b=this;if(+a!==0){var c=bH("filter"),d=bH("feGaussianBlur");b.attrs.blur=a,c.id=bi(),bH(d,{stdDeviation:+a||1.5}),c.appendChild(d),b.paper.defs.appendChild(c),b._blur=c,bH(b.node,{filter:"url(#"+c.id+")"})}else b._blur&&(b._blur.parentNode.removeChild(b._blur),delete b._blur,delete b.attrs.blur),b.node.removeAttribute("filter")};var bQ=function(a,b,c,d){var e=bH("circle");a.canvas&&a.canvas[l](e);var f=new bO(e,a);f.attrs={cx:b,cy:c,r:d,fill:"none",stroke:"#000"},f.type="circle",bH(e,f.attrs);return f},bR=function(a,b,c,d,e,f){var g=bH("rect");a.canvas&&a.canvas[l](g);var h=new bO(g,a);h.attrs={x:b,y:c,width:d,height:e,r:f||0,rx:f||0,ry:f||0,fill:"none",stroke:"#000"},h.type="rect",bH(g,h.attrs);return h},bS=function(a,b,c,d,e){var f=bH("ellipse");a.canvas&&a.canvas[l](f);var g=new bO(f,a);g.attrs={cx:b,cy:c,rx:d,ry:e,fill:"none",stroke:"#000"},g.type="ellipse",bH(f,g.attrs);return g},bT=function(a,b,c,d,e,f){var g=bH("image");bH(g,{x:c,y:d,width:e,height:f,preserveAspectRatio:"none"}),g.setAttributeNS(a.xlink,"href",b),a.canvas&&a.canvas[l](g);var h=new bO(g,a);h.attrs={x:c,y:d,width:e,height:f,src:b},h.type="image";return h},bU=function(a,b,c,d){var e=bH("text");bH(e,{x:b,y:c,"text-anchor":"middle"}),a.canvas&&a.canvas[l](e);var f=new bO(e,a);f.attrs={x:b,y:c,"text-anchor":"middle",text:d,font:X.font,stroke:"none",fill:"#000"},f.type="text",bL(f,f.attrs);return f},bV=function(a,b){this.width=a||this.width,this.height=b||this.height,this.canvas[R]("width",this.width),this.canvas[R]("height",this.height);return this},bW=function(){var b=bz[m](0,arguments),c=b&&b.container,d=b.x,e=b.y,f=b.width,h=b.height;if(!c)throw new Error("SVG container not found.");var i=bH("svg");d=d||0,e=e||0,f=f||512,h=h||342,bH(i,{xmlns:"http://www.w3.org/2000/svg",version:1.1,width:f,height:h}),c==1?(i.style.cssText="position:absolute;left:"+d+"px;top:"+e+"px",g.body[l](i)):c.firstChild?c.insertBefore(i,c.firstChild):c[l](i),c=new j,c.width=f,c.height=h,c.canvas=i,bA.call(c,c,a.fn),c.clear();return c};k.clear=function(){var a=this.canvas;while(a.firstChild)a.removeChild(a.firstChild);this.bottom=this.top=null,(this.desc=bH("desc"))[l](g.createTextNode("Created with Raphaël")),a[l](this.desc),a[l](this.defs=bH("defs"))},k.remove=function(){this.canvas.parentNode&&this.canvas.parentNode.removeChild(this.canvas);for(var a in this)this[a]=bG(a)}}if(a.vml){var bX={M:"m",L:"l",C:"c",Z:"x",m:"t",l:"r",c:"v",z:"x"},bY=/([clmz]),?([^clmz]*)/gi,bZ=/ progid:\S+Blur\([^\)]+\)/g,b$=/-?[^,\s-]+/g,b_=1e3+q+1e3,ca=10,cb={path:1,rect:1},cc=function(a){var b=/[ahqstv]/ig,c=br;r(a).match(b)&&(c=bx),b=/[clmz]/g;if(c==br&&!r(a).match(b)){var d=r(a)[Z](bY,function(a,b,c){var d=[],e=x.call(b)=="m",f=bX[b];c[Z](b$,function(a){e&&d[w]==2&&(f+=d+bX[b=="m"?"l":"L"],d=[]),d[L](Q(a*ca))});return f+d});return d}var e=c(a),f,g;d=[];for(var h=0,i=e[w];h<i;h++){f=e[h],g=x.call(e[h][0]),g=="z"&&(g="x");for(var j=1,k=f[w];j<k;j++)g+=Q(f[j]*ca)+(j!=k-1?",":p);d[L](g)}return d[v](q)};a[H]=function(){return"Your browser doesn’t support SVG. Falling down to VML.\nYou are running Raphaël "+this.version},bI=function(a,b){var c=ce("group");c.style.cssText="position:absolute;left:0;top:0;width:"+b.width+"px;height:"+b.height+"px",c.coordsize=b.coordsize,c.coordorigin=b.coordorigin;var d=ce("shape"),e=d.style;e.width=b.width+"px",e.height=b.height+"px",d.coordsize=b_,d.coordorigin=b.coordorigin,c[l](d);var f=new bO(d,c,b),g={fill:"none",stroke:"#000"};a&&(g.path=a),f.type="path",f.path=[],f.Path=p,bL(f,g),b.canvas[l](c);return f},bL=function(c,d){c.attrs=c.attrs||{};var e=c.node,h=c.attrs,i=e.style,j,k=(d.x!=h.x||d.y!=h.y||d.width!=h.width||d.height!=h.height||d.r!=h.r)&&c.type=="rect",m=c;for(var n in d)d[f](n)&&(h[n]=d[n]);k&&(h.path=cd(h.x,h.y,h.width,h.height,h.r),c.X=h.x,c.Y=h.y,c.W=h.width,c.H=h.height),d.href&&(e.href=d.href),d.title&&(e.title=d.title),d.target&&(e.target=d.target),d.cursor&&(i.cursor=d.cursor),"blur"in d&&c.blur(d.blur);if(d.path&&c.type=="path"||k)e.path=cc(h.path);d.rotation!=null&&c.rotate(d.rotation,!0),d.translation&&(j=r(d.translation)[s](b),cB.call(c,j[0],j[1]),c._.rt.cx!=null&&(c._.rt.cx+=+j[0],c._.rt.cy+=+j[1],c.setBox(c.attrs,j[0],j[1]))),d.scale&&(j=r(d.scale)[s](b),c.scale(+j[0]||1,+j[1]||+j[0]||1,+j[2]||null,+j[3]||null));if("clip-rect"in d){var o=r(d["clip-rect"])[s](b);if(o[w]==4){o[2]=+o[2]+ +o[0],o[3]=+o[3]+ +o[1];var q=e.clipRect||g.createElement("div"),t=q.style,u=e.parentNode;t.clip=a.format("rect({1}px {2}px {3}px {0}px)",o),e.clipRect||(t.position="absolute",t.top=0,t.left=0,t.width=c.paper.width+"px",t.height=c.paper.height+"px",u.parentNode.insertBefore(q,u),q[l](u),e.clipRect=q)}d["clip-rect"]||e.clipRect&&(e.clipRect.style.clip=p)}c.type=="image"&&d.src&&(e.src=d.src),c.type=="image"&&d.opacity&&(e.filterOpacity=U+".Alpha(opacity="+d.opacity*100+")",i.filter=(e.filterMatrix||p)+(e.filterOpacity||p)),d.font&&(i.font=d.font),d["font-family"]&&(i.fontFamily='"'+d["font-family"][s](",")[0][Z](/^['"]+|['"]+$/g,p)+'"'),d["font-size"]&&(i.fontSize=d["font-size"]),d["font-weight"]&&(i.fontWeight=d["font-weight"]),d["font-style"]&&(i.fontStyle=d["font-style"]);if(d.opacity!=null||d["stroke-width"]!=null||d.fill!=null||d.stroke!=null||d["stroke-width"]!=null||d["stroke-opacity"]!=null||d["fill-opacity"]!=null||d["stroke-dasharray"]!=null||d["stroke-miterlimit"]!=null||d["stroke-linejoin"]!=null||d["stroke-linecap"]!=null){e=c.shape||e;var v=e.getElementsByTagName(I)&&e.getElementsByTagName(I)[0],x=!1;!v&&(x=v=ce(I));if("fill-opacity"in d||"opacity"in d){var y=((+h["fill-opacity"]+1||2)-1)*((+h.opacity+1||2)-1)*((+a.getRGB(d.fill).o+1||2)-1);y=A(z(y,0),1),v.opacity=y}d.fill&&(v.on=!0);if(v.on==null||d.fill=="none")v.on=!1;if(v.on&&d.fill){var B=d.fill.match(M);B?(v.src=B[1],v.type="tile"):(v.color=a.getRGB(d.fill).hex,v.src=p,v.type="solid",a.getRGB(d.fill).error&&(m.type in{circle:1,ellipse:1}||r(d.fill).charAt()!="r")&&bJ(m,d.fill)&&(h.fill="none",h.gradient=d.fill))}x&&e[l](v);var C=e.getElementsByTagName("stroke")&&e.getElementsByTagName("stroke")[0],D=!1;!C&&(D=C=ce("stroke"));if(d.stroke&&d.stroke!="none"||d["stroke-width"]||d["stroke-opacity"]!=null||d["stroke-dasharray"]||d["stroke-miterlimit"]||d["stroke-linejoin"]||d["stroke-linecap"])C.on=!0;(d.stroke=="none"||C.on==null||d.stroke==0||d["stroke-width"]==0)&&(C.on=!1);var E=a.getRGB(d.stroke);C.on&&d.stroke&&(C.color=E.hex),y=((+h["stroke-opacity"]+1||2)-1)*((+h.opacity+1||2)-1)*((+E.o+1||2)-1);var F=(S(d["stroke-width"])||1)*.75;y=A(z(y,0),1),d["stroke-width"]==null&&(F=h["stroke-width"]),d["stroke-width"]&&(C.weight=F),F&&F<1&&(y*=F)&&(C.weight=1),C.opacity=y,d["stroke-linejoin"]&&(C.joinstyle=d["stroke-linejoin"]||"miter"),C.miterlimit=d["stroke-miterlimit"]||8,d["stroke-linecap"]&&(C.endcap=d["stroke-linecap"]=="butt"?"flat":d["stroke-linecap"]=="square"?"square":"round");if(d["stroke-dasharray"]){var G={"-":"shortdash",".":"shortdot","-.":"shortdashdot","-..":"shortdashdotdot",". ":"dot","- ":"dash","--":"longdash","- .":"dashdot","--.":"longdashdot","--..":"longdashdotdot"};C.dashstyle=G[f](d["stroke-dasharray"])?G[d["stroke-dasharray"]]:p}D&&e[l](C)}if(m.type=="text"){i=m.paper.span.style,h.font&&(i.font=h.font),h["font-family"]&&(i.fontFamily=h["font-family"]),h["font-size"]&&(i.fontSize=h["font-size"]),h["font-weight"]&&(i.fontWeight=h["font-weight"]),h["font-style"]&&(i.fontStyle=h["font-style"]),m.node.string&&(m.paper.span.innerHTML=r(m.node.string)[Z](/</g,"&#60;")[Z](/&/g,"&#38;")[Z](/\n/g,"<br>")),m.W=h.w=m.paper.span.offsetWidth,m.H=h.h=m.paper.span.offsetHeight,m.X=h.x,m.Y=h.y+Q(m.H/2);switch(h["text-anchor"]){case"start":m.node.style["v-text-align"]="left",m.bbx=Q(m.W/2);break;case"end":m.node.style["v-text-align"]="right",m.bbx=-Q(m.W/2);break;default:m.node.style["v-text-align"]="center"}}},bJ=function(a,b){a.attrs=a.attrs||{};var c=a.attrs,d,e="linear",f=".5 .5";a.attrs.gradient=b,b=r(b)[Z](be,function(a,b,c){e="radial",b&&c&&(b=S(b),c=S(c),C(b-.5,2)+C(c-.5,2)>.25&&(c=y.sqrt(.25-C(b-.5,2))*((c>.5)*2-1)+.5),f=b+q+c);return p}),b=b[s](/\s*\-\s*/);if(e=="linear"){var g=b.shift();g=-S(g);if(isNaN(g))return null}var h=by(b);if(!h)return null;a=a.shape||a.node,d=a.getElementsByTagName(I)[0]||ce(I),!d.parentNode&&a.appendChild(d);if(h[w]){d.on=!0,d.method="none",d.color=h[0].color,d.color2=h[h[w]-1].color;var i=[];for(var j=0,k=h[w];j<k;j++)h[j].offset&&i[L](h[j].offset+q+h[j].color);d.colors&&(d.colors.value=i[w]?i[v]():"0% "+d.color),e=="radial"?(d.type="gradientradial",d.focus="100%",d.focussize=f,d.focusposition=f):(d.type="gradient",d.angle=(270-g)%360)}return 1},bO=function(b,c,d){var e=0,f=0,g=0,h=1;this[0]=b,this.id=a._oid++,this.node=b,b.raphael=this,this.X=0,this.Y=0,this.attrs={},this.Group=c,this.paper=d,this._={tx:0,ty:0,rt:{deg:0},sx:1,sy:1},!d.bottom&&(d.bottom=this),this.prev=d.top,d.top&&(d.top.next=this),d.top=this,this.next=null},bP=bO[e],bP.rotate=function(a,c,d){if(this.removed)return this;if(a==null){if(this._.rt.cx)return[this._.rt.deg,this._.rt.cx,this._.rt.cy][v](q);return this._.rt.deg}a=r(a)[s](b),a[w]-1&&(c=S(a[1]),d=S(a[2])),a=S(a[0]),c!=null?this._.rt.deg=a:this._.rt.deg+=a,d==null&&(c=null),this._.rt.cx=c,this._.rt.cy=d,this.setBox(this.attrs,c,d),this.Group.style.rotation=this._.rt.deg;return this},bP.setBox=function(a,b,c){if(this.removed)return this;var d=this.Group.style,e=this.shape&&this.shape.style||this.node.style;a=a||{};for(var g in a)a[f](g)&&(this.attrs[g]=a[g]);b=b||this._.rt.cx,c=c||this._.rt.cy;var h=this.attrs,i,j,k,l;switch(this.type){case"circle":i=h.cx-h.r,j=h.cy-h.r,k=l=h.r*2;break;case"ellipse":i=h.cx-h.rx,j=h.cy-h.ry,k=h.rx*2,l=h.ry*2;break;case"image":i=+h.x,j=+h.y,k=h.width||0,l=h.height||0;break;case"text":this.textpath.v=["m",Q(h.x),", ",Q(h.y-2),"l",Q(h.x)+1,", ",Q(h.y-2)][v](p),i=h.x-Q(this.W/2),j=h.y-this.H/2,k=this.W,l=this.H;break;case"rect":case"path":if(!this.attrs.path)i=0,j=0,k=this.paper.width,l=this.paper.height;else{var m=bo(this.attrs.path);i=m.x,j=m.y,k=m.width,l=m.height}break;default:i=0,j=0,k=this.paper.width,l=this.paper.height}b=b==null?i+k/2:b,c=c==null?j+l/2:c;var n=b-this.paper.width/2,o=c-this.paper.height/2,q;d.left!=(q=n+"px")&&(d.left=q),d.top!=(q=o+"px")&&(d.top=q),this.X=cb[f](this.type)?-n:i,this.Y=cb[f](this.type)?-o:j,this.W=k,this.H=l,cb[f](this.type)?(e.left!=(q=-n*ca+"px")&&(e.left=q),e.top!=(q=-o*ca+"px")&&(e.top=q)):this.type=="text"?(e.left!=(q=-n+"px")&&(e.left=q),e.top!=(q=-o+"px")&&(e.top=q)):(d.width!=(q=this.paper.width+"px")&&(d.width=q),d.height!=(q=this.paper.height+"px")&&(d.height=q),e.left!=(q=i-n+"px")&&(e.left=q),e.top!=(q=j-o+"px")&&(e.top=q),e.width!=(q=k+"px")&&(e.width=q),e.height!=(q=l+"px")&&(e.height=q))},bP.hide=function(){!this.removed&&(this.Group.style.display="none");return this},bP.show=function(){!this.removed&&(this.Group.style.display="block");return this},bP.getBBox=function(){if(this.removed)return this;if(cb[f](this.type))return bo(this.attrs.path);return{x:this.X+(this.bbx||0),y:this.Y,width:this.W,height:this.H}},bP.remove=function(){if(!this.removed){bB(this,this.paper),this.node.parentNode.removeChild(this.node),this.Group.parentNode.removeChild(this.Group),this.shape&&this.shape.parentNode.removeChild(this.shape);for(var a in this)delete this[a];this.removed=!0}},bP.attr=function(b,c){if(this.removed)return this;if(b==null){var d={};for(var e in this.attrs)this.attrs[f](e)&&(d[e]=this.attrs[e]);this._.rt.deg&&(d.rotation=this.rotate()),(this._.sx!=1||this._.sy!=1)&&(d.scale=this.scale()),d.gradient&&d.fill=="none"&&(d.fill=d.gradient)&&delete d.gradient;return d}if(c==null&&a.is(b,"string")){if(b=="translation")return cB.call(this);if(b=="rotation")return this.rotate();if(b=="scale")return this.scale();if(b==I&&this.attrs.fill=="none"&&this.attrs.gradient)return this.attrs.gradient;return this.attrs[b]}if(this.attrs&&c==null&&a.is(b,G)){var g,h={};for(e=0,g=b[w];e<g;e++)h[b[e]]=this.attr(b[e]);return h}var i;c!=null&&(i={},i[b]=c),c==null&&a.is(b,"object")&&(i=b);if(i){for(var j in this.paper.customAttributes)if(this.paper.customAttributes[f](j)&&i[f](j)&&a.is(this.paper.customAttributes[j],"function")){var k=this.paper.customAttributes[j].apply(this,[][n](i[j]));this.attrs[j]=i[j];for(var l in k)k[f](l)&&(i[l]=k[l])}i.text&&this.type=="text"&&(this.node.string=i.text),bL(this,i),i.gradient&&(({circle:1,ellipse:1})[f](this.type)||r(i.gradient).charAt()!="r")&&bJ(this,i.gradient),(!cb[f](this.type)||this._.rt.deg)&&this.setBox(this.attrs)}return this},bP.toFront=function(){!this.removed&&this.Group.parentNode[l](this.Group),this.paper.top!=this&&bC(this,this.paper);return this},bP.toBack=function(){if(this.removed)return this;this.Group.parentNode.firstChild!=this.Group&&(this.Group.parentNode.insertBefore(this.Group,this.Group.parentNode.firstChild),bD(this,this.paper));return this},bP.insertAfter=function(a){if(this.removed)return this;a.constructor==cE&&(a=a[a.length-1]),a.Group.nextSibling?a.Group.parentNode.insertBefore(this.Group,a.Group.nextSibling):a.Group.parentNode[l](this.Group),bE(this,a,this.paper);return this},bP.insertBefore=function(a){if(this.removed)return this;a.constructor==cE&&(a=a[0]),a.Group.parentNode.insertBefore(this.Group,a.Group),bF(this,a,this.paper);return this},bP.blur=function(b){var c=this.node.runtimeStyle,d=c.filter;d=d.replace(bZ,p),+b!==0?(this.attrs.blur=b,c.filter=d+q+U+".Blur(pixelradius="+(+b||1.5)+")",c.margin=a.format("-{0}px 0 0 -{0}px",Q(+b||1.5))):(c.filter=d,c.margin=0,delete this.attrs.blur)},bQ=function(a,b,c,d){var e=ce("group"),f=ce("oval"),g=f.style;e.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px",e.coordsize=b_,e.coordorigin=a.coordorigin,e[l](f);var h=new bO(f,e,a);h.type="circle",bL(h,{stroke:"#000",fill:"none"}),h.attrs.cx=b,h.attrs.cy=c,h.attrs.r=d,h.setBox({x:b-d,y:c-d,width:d*2,height:d*2}),a.canvas[l](e);return h};function cd(b,c,d,e,f){return f?a.format("M{0},{1}l{2},0a{3},{3},0,0,1,{3},{3}l0,{5}a{3},{3},0,0,1,{4},{3}l{6},0a{3},{3},0,0,1,{4},{4}l0,{7}a{3},{3},0,0,1,{3},{4}z",b+f,c,d-f*2,f,-f,e-f*2,f*2-d,f*2-e):a.format("M{0},{1}l{2},0,0,{3},{4},0z",b,c,d,e,-d)}bR=function(a,b,c,d,e,f){var g=cd(b,c,d,e,f),h=a.path(g),i=h.attrs;h.X=i.x=b,h.Y=i.y=c,h.W=i.width=d,h.H=i.height=e,i.r=f,i.path=g,h.type="rect";return h},bS=function(a,b,c,d,e){var f=ce("group"),g=ce("oval"),h=g.style;f.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px",f.coordsize=b_,f.coordorigin=a.coordorigin,f[l](g);var i=new bO(g,f,a);i.type="ellipse",bL(i,{stroke:"#000"}),i.attrs.cx=b,i.attrs.cy=c,i.attrs.rx=d,i.attrs.ry=e,i.setBox({x:b-d,y:c-e,width:d*2,height:e*2}),a.canvas[l](f);return i},bT=function(a,b,c,d,e,f){var g=ce("group"),h=ce("image");g.style.cssText="position:absolute;left:0;top:0;width:"+a.width+"px;height:"+a.height+"px",g.coordsize=b_,g.coordorigin=a.coordorigin,h.src=b,g[l](h);var i=new bO(h,g,a);i.type="image",i.attrs.src=b,i.attrs.x=c,i.attrs.y=d,i.attrs.w=e,i.attrs.h=f,i.setBox({x:c,y:d,width:e,height:f}),a.canvas[l](g);return i},bU=function(b,c,d,e){var f=ce("group"),g=ce("shape"),h=g.style,i=ce("path"),j=i.style,k=ce("textpath");f.style.cssText="position:absolute;left:0;top:0;width:"+b.width+"px;height:"+b.height+"px",f.coordsize=b_,f.coordorigin=b.coordorigin,i.v=a.format("m{0},{1}l{2},{1}",Q(c*10),Q(d*10),Q(c*10)+1),i.textpathok=!0,h.width=b.width,h.height=b.height,k.string=r(e),k.on=!0,g[l](k),g[l](i),f[l](g);var m=new bO(k,f,b);m.shape=g,m.textpath=i,m.type="text",m.attrs.text=e,m.attrs.x=c,m.attrs.y=d,m.attrs.w=1,m.attrs.h=1,bL(m,{font:X.font,stroke:"none",fill:"#000"}),m.setBox(),b.canvas[l](f);return m},bV=function(a,b){var c=this.canvas.style;a==+a&&(a+="px"),b==+b&&(b+="px"),c.width=a,c.height=b,c.clip="rect(0 "+a+" "+b+" 0)";return this};var ce;g.createStyleSheet().addRule(".rvml","behavior:url(#default#VML)");try{!g.namespaces.rvml&&g.namespaces.add("rvml","urn:schemas-microsoft-com:vml"),ce=function(a){return g.createElement("<rvml:"+a+' class="rvml">')}}catch(cf){ce=function(a){return g.createElement("<"+a+' xmlns="urn:schemas-microsoft.com:vml" class="rvml">')}}bW=function(){var b=bz[m](0,arguments),c=b.container,d=b.height,e,f=b.width,h=b.x,i=b.y;if(!c)throw new Error("VML container not found.");var k=new j,n=k.canvas=g.createElement("div"),o=n.style;h=h||0,i=i||0,f=f||512,d=d||342,f==+f&&(f+="px"),d==+d&&(d+="px"),k.width=1e3,k.height=1e3,k.coordsize=ca*1e3+q+ca*1e3,k.coordorigin="0 0",k.span=g.createElement("span"),k.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;",n[l](k.span),o.cssText=a.format("top:0;left:0;width:{0};height:{1};display:inline-block;position:relative;clip:rect(0 {0} {1} 0);overflow:hidden",f,d),c==1?(g.body[l](n),o.left=h+"px",o.top=i+"px",o.position="absolute"):c.firstChild?c.insertBefore(n,c.firstChild):c[l](n),bA.call(k,k,a.fn);return k},k.clear=function(){this.canvas.innerHTML=p,this.span=g.createElement("span"),this.span.style.cssText="position:absolute;left:-9999em;top:-9999em;padding:0;margin:0;line-height:1;display:inline;",this.canvas[l](this.span),this.bottom=this.top=null},k.remove=function(){this.canvas.parentNode.removeChild(this.canvas);for(var a in this)this[a]=bG(a);return!0}}var cg=navigator.userAgent.match(/Version\/(.*?)\s/);navigator.vendor=="Apple Computer, Inc."&&(cg&&cg[1]<4||navigator.platform.slice(0,2)=="iP")?k.safari=function(){var a=this.rect(-99,-99,this.width+99,this.height+99).attr({stroke:"none"});h.setTimeout(function(){a.remove()})}:k.safari=function(){};var ch=function(){this.returnValue=!1},ci=function(){return this.originalEvent.preventDefault()},cj=function(){this.cancelBubble=!0},ck=function(){return this.originalEvent.stopPropagation()},cl=function(){if(g.addEventListener)return function(a,b,c,d){var e=o&&u[b]?u[b]:b,g=function(e){if(o&&u[f](b))for(var g=0,h=e.targetTouches&&e.targetTouches.length;g<h;g++)if(e.targetTouches[g].target==a){var i=e;e=e.targetTouches[g],e.originalEvent=i,e.preventDefault=ci,e.stopPropagation=ck;break}return c.call(d,e)};a.addEventListener(e,g,!1);return function(){a.removeEventListener(e,g,!1);return!0}};if(g.attachEvent)return function(a,b,c,d){var e=function(a){a=a||h.event,a.preventDefault=a.preventDefault||ch,a.stopPropagation=a.stopPropagation||cj;return c.call(d,a)};a.attachEvent("on"+b,e);var f=function(){a.detachEvent("on"+b,e);return!0};return f}}(),cm=[],cn=function(a){var b=a.clientX,c=a.clientY,d=g.documentElement.scrollTop||g.body.scrollTop,e=g.documentElement.scrollLeft||g.body.scrollLeft,f,h=cm.length;while(h--){f=cm[h];if(o){var i=a.touches.length,j;while(i--){j=a.touches[i];if(j.identifier==f.el._drag.id){b=j.clientX,c=j.clientY,(a.originalEvent?a.originalEvent:a).preventDefault();break}}}else a.preventDefault();b+=e,c+=d,f.move&&f.move.call(f.move_scope||f.el,b-f.el._drag.x,c-f.el._drag.y,b,c,a)}},co=function(b){a.unmousemove(cn).unmouseup(co);var c=cm.length,d;while(c--)d=cm[c],d.el._drag={},d.end&&d.end.call(d.end_scope||d.start_scope||d.move_scope||d.el,b);cm=[]};for(var cp=t[w];cp--;)(function(b){a[b]=bO[e][b]=function(c,d){a.is(c,"function")&&(this.events=this.events||[],this.events.push({name:b,f:c,unbind:cl(this.shape||this.node||g,b,c,d||this)}));return this},a["un"+b]=bO[e]["un"+b]=function(a){var c=this.events,d=c[w];while(d--)if(c[d].name==b&&c[d].f==a){c[d].unbind(),c.splice(d,1),!c.length&&delete this.events;return this}return this}})(t[cp]);bP.hover=function(a,b,c,d){return this.mouseover(a,c).mouseout(b,d||c)},bP.unhover=function(a,b){return this.unmouseover(a).unmouseout(b)},bP.drag=function(b,c,d,e,f,h){this._drag={},this.mousedown(function(i){(i.originalEvent||i).preventDefault();var j=g.documentElement.scrollTop||g.body.scrollTop,k=g.documentElement.scrollLeft||g.body.scrollLeft;this._drag.x=i.clientX+k,this._drag.y=i.clientY+j,this._drag.id=i.identifier,c&&c.call(f||e||this,i.clientX+k,i.clientY+j,i),!cm.length&&a.mousemove(cn).mouseup(co),cm.push({el:this,move:b,end:d,move_scope:e,start_scope:f,end_scope:h})});return this},bP.undrag=function(b,c,d){var e=cm.length;while(e--)cm[e].el==this&&cm[e].move==b&&cm[e].end==d&&cm.splice(e++,1);!cm.length&&a.unmousemove(cn).unmouseup(co)},k.circle=function(a,b,c){return bQ(this,a||0,b||0,c||0)},k.rect=function(a,b,c,d,e){return bR(this,a||0,b||0,c||0,d||0,e||0)},k.ellipse=function(a,b,c,d){return bS(this,a||0,b||0,c||0,d||0)},k.path=function(b){b&&!a.is(b,F)&&!a.is(b[0],G)&&(b+=p);return bI(a.format[m](a,arguments),this)},k.image=function(a,b,c,d,e){return bT(this,a||"about:blank",b||0,c||0,d||0,e||0)},k.text=function(a,b,c){return bU(this,a||0,b||0,r(c))},k.set=function(a){arguments[w]>1&&(a=Array[e].splice.call(arguments,0,arguments[w]));return new cE(a)},k.setSize=bV,k.top=k.bottom=null,k.raphael=a,bP.resetScale=function(){if(this.removed)return this;this._.sx=1,this._.sy=1,this.attrs.scale="1 1"},bP.scale=function(a,b,c,d){if(this.removed)return this;if(a==null&&b==null)return{x:this._.sx,y:this._.sy,toString:cq};b=b||a,!+b&&(b=a);var e,f,g,h,i=this.attrs;if(a!=0){var j=this.getBBox(),k=j.x+j.width/2,l=j.y+j.height/2,m=B(a/this._.sx),o=B(b/this._.sy);c=+c||c==0?c:k,d=+d||d==0?d:l;var r=this._.sx>0,s=this._.sy>0,t=~~(a/B(a)),u=~~(b/B(b)),x=m*t,y=o*u,z=this.node.style,A=c+B(k-c)*x*(k>c==r?1:-1),C=d+B(l-d)*y*(l>d==s?1:-1),D=a*t>b*u?o:m;switch(this.type){case"rect":case"image":var E=i.width*m,F=i.height*o;this.attr({height:F,r:i.r*D,width:E,x:A-E/2,y:C-F/2});break;case"circle":case"ellipse":this.attr({rx:i.rx*m,ry:i.ry*o,r:i.r*D,cx:A,cy:C});break;case"text":this.attr({x:A,y:C});break;case"path":var G=bq(i.path),H=!0,I=r?x:m,J=s?y:o;for(var K=0,L=G[w];K<L;K++){var M=G[K],N=W.call(M[0]);if(N=="M"&&H)continue;H=!1;if(N=="A")M[G[K][w]-2]*=I,M[G[K][w]-1]*=J,M[1]*=m,M[2]*=o,M[5]=+(t+u?!!+M[5]:!+M[5]);else if(N=="H")for(var O=1,P=M[w];O<P;O++)M[O]*=I;else if(N=="V")for(O=1,P=M[w];O<P;O++)M[O]*=J;else for(O=1,P=M[w];O<P;O++)M[O]*=O%2?I:J}var Q=bo(G);e=A-Q.x-Q.width/2,f=C-Q.y-Q.height/2,G[0][1]+=e,G[0][2]+=f,this.attr({path:G})}this.type in{text:1,image:1}&&(t!=1||u!=1)?this.transformations?(this.transformations[2]="scale("[n](t,",",u,")"),this.node[R]("transform",this.transformations[v](q)),e=t==-1?-i.x-(E||0):i.x,f=u==-1?-i.y-(F||0):i.y,this.attr({x:e,y:f}),i.fx=t-1,i.fy=u-1):(this.node.filterMatrix=U+".Matrix(M11="[n](t,", M12=0, M21=0, M22=",u,", Dx=0, Dy=0, sizingmethod='auto expand', filtertype='bilinear')"),z.filter=(this.node.filterMatrix||p)+(this.node.filterOpacity||p)):this.transformations?(this.transformations[2]=p,this.node[R]("transform",this.transformations[v](q)),i.fx=0,i.fy=0):(this.node.filterMatrix=p,z.filter=(this.node.filterMatrix||p)+(this.node.filterOpacity||p)),i.scale=[a,b,c,d][v](q),this._.sx=a,this._.sy=b}return this},bP.clone=function(){if(this.removed)return null;var a=this.attr();delete a.scale,delete a.translation;return this.paper[this.type]().attr(a)};var cr={},cs=function(b,c,d,e,f,g,h,i,j){var k=0,l=100,m=[b,c,d,e,f,g,h,i].join(),n=cr[m],o,p;!n&&(cr[m]=n={data:[]}),n.timer&&clearTimeout(n.timer),n.timer=setTimeout(function(){delete cr[m]},2e3);if(j!=null){var q=cs(b,c,d,e,f,g,h,i);l=~~q*10}for(var r=0;r<l+1;r++){n.data[j]>r?p=n.data[r*l]:(p=a.findDotsAtSegment(b,c,d,e,f,g,h,i,r/l),n.data[r]=p),r&&(k+=C(C(o.x-p.x,2)+C(o.y-p.y,2),.5));if(j!=null&&k>=j)return p;o=p}if(j==null)return k},ct=function(b,c){return function(d,e,f){d=bx(d);var g,h,i,j,k="",l={},m,n=0;for(var o=0,p=d.length;o<p;o++){i=d[o];if(i[0]=="M")g=+i[1],h=+i[2];else{j=cs(g,h,i[1],i[2],i[3],i[4],i[5],i[6]);if(n+j>e){if(c&&!l.start){m=cs(g,h,i[1],i[2],i[3],i[4],i[5],i[6],e-n),k+=["C",m.start.x,m.start.y,m.m.x,m.m.y,m.x,m.y];if(f)return k;l.start=k,k=["M",m.x,m.y+"C",m.n.x,m.n.y,m.end.x,m.end.y,i[5],i[6]][v](),n+=j,g=+i[5],h=+i[6];continue}if(!b&&!c){m=cs(g,h,i[1],i[2],i[3],i[4],i[5],i[6],e-n);return{x:m.x,y:m.y,alpha:m.alpha}}}n+=j,g=+i[5],h=+i[6]}k+=i}l.end=k,m=b?n:c?l:a.findDotsAtSegment(g,h,i[1],i[2],i[3],i[4],i[5],i[6],1),m.alpha&&(m={x:m.x,y:m.y,alpha:m.alpha});return m}},cu=ct(1),cv=ct(),cw=ct(0,1);bP.getTotalLength=function(){if(this.type=="path"){if(this.node.getTotalLength)return this.node.getTotalLength();return cu(this.attrs.path)}},bP.getPointAtLength=function(a){if(this.type=="path")return cv(this.attrs.path,a)},bP.getSubpath=function(a,b){if(this.type=="path"){if(B(this.getTotalLength()-b)<"1e-6")return cw(this.attrs.path,a).end;var c=cw(this.attrs.path,b,1);return a?cw(c,a).end:c}},a.easing_formulas={linear:function(a){return a},"<":function(a){return C(a,3)},">":function(a){return C(a-1,3)+1},"<>":function(a){a=a*2;if(a<1)return C(a,3)/2;a-=2;return(C(a,3)+2)/2},backIn:function(a){var b=1.70158;return a*a*((b+1)*a-b)},backOut:function(a){a=a-1;var b=1.70158;return a*a*((b+1)*a+b)+1},elastic:function(a){if(a==0||a==1)return a;var b=.3,c=b/4;return C(2,-10*a)*y.sin((a-c)*2*D/b)+1},bounce:function(a){var b=7.5625,c=2.75,d;a<1/c?d=b*a*a:a<2/c?(a-=1.5/c,d=b*a*a+.75):a<2.5/c?(a-=2.25/c,d=b*a*a+.9375):(a-=2.625/c,d=b*a*a+.984375);return d}};var cx=[],cy=function(){var b=+(new Date);for(var c=0;c<cx[w];c++){var d=cx[c];if(d.stop||d.el.removed)continue;var e=b-d.start,g=d.ms,h=d.easing,i=d.from,j=d.diff,k=d.to,l=d.t,m=d.el,n={},o;if(e<g){var r=h(e/g);for(var s in i)if(i[f](s)){switch(Y[s]){case"along":o=r*g*j[s],k.back&&(o=k.len-o);var t=cv(k[s],o);m.translate(j.sx-j.x||0,j.sy-j.y||0),j.x=t.x,j.y=t.y,m.translate(t.x-j.sx,t.y-j.sy),k.rot&&m.rotate(j.r+t.alpha,t.x,t.y);break;case E:o=+i[s]+r*g*j[s];break;case"colour":o="rgb("+[cA(Q(i[s].r+r*g*j[s].r)),cA(Q(i[s].g+r*g*j[s].g)),cA(Q(i[s].b+r*g*j[s].b))][v](",")+")";break;case"path":o=[];for(var u=0,x=i[s][w];u<x;u++){o[u]=[i[s][u][0]];for(var y=1,z=i[s][u][w];y<z;y++)o[u][y]=+i[s][u][y]+r*g*j[s][u][y];o[u]=o[u][v](q)}o=o[v](q);break;case"csv":switch(s){case"translation":var A=r*g*j[s][0]-l.x,B=r*g*j[s][1]-l.y;l.x+=A,l.y+=B,o=A+q+B;break;case"rotation":o=+i[s][0]+r*g*j[s][0],i[s][1]&&(o+=","+i[s][1]+","+i[s][2]);break;case"scale":o=[+i[s][0]+r*g*j[s][0],+i[s][1]+r*g*j[s][1],2 in k[s]?k[s][2]:p,3 in k[s]?k[s][3]:p][v](q);break;case"clip-rect":o=[],u=4;while(u--)o[u]=+i[s][u]+r*g*j[s][u]}break;default:var C=[].concat(i[s]);o=[],u=m.paper.customAttributes[s].length;while(u--)o[u]=+C[u]+r*g*j[s][u]}n[s]=o}m.attr(n),m._run&&m._run.call(m)}else k.along&&(t=cv(k.along,k.len*!k.back),m.translate(j.sx-(j.x||0)+t.x-j.sx,j.sy-(j.y||0)+t.y-j.sy),k.rot&&m.rotate(j.r+t.alpha,t.x,t.y)),(l.x||l.y)&&m.translate(-l.x,-l.y),k.scale&&(k.scale+=p),m.attr(k),cx.splice(c--,1)}a.svg&&m&&m.paper&&m.paper.safari(),cx[w]&&setTimeout(cy)},cz=function(b,c,d,e,f){var g=d-e;c.timeouts.push(setTimeout(function(){a.is(f,"function")&&f.call(c),c.animate(b,g,b.easing)},e))},cA=function(a){return z(A(a,255),0)},cB=function(a,b){if(a==null)return{x:this._.tx,y:this._.ty,toString:cq};this._.tx+=+a,this._.ty+=+b;switch(this.type){case"circle":case"ellipse":this.attr({cx:+a+this.attrs.cx,cy:+b+this.attrs.cy});break;case"rect":case"image":case"text":this.attr({x:+a+this.attrs.x,y:+b+this.attrs.y});break;case"path":var c=bq(this.attrs.path);c[0][1]+=+a,c[0][2]+=+b,this.attr({path:c})}return this};bP.animateWith=function(a,b,c,d,e){for(var f=0,g=cx.length;f<g;f++)cx[f].el.id==a.id&&(b.start=cx[f].start);return this.animate(b,c,d,e)},bP.animateAlong=cC(),bP.animateAlongBack=cC(1),bP.onAnimation=function(a){this._run=a||0;return this},bP.animate=function(c,d,e,g){var h=this;h.timeouts=h.timeouts||[];if(a.is(e,"function")||!e)g=e||null;if(h.removed){g&&g.call(h);return h}var i={},j={},k=!1,l={};for(var m in c)if(c[f](m))if(Y[f](m)||h.paper.customAttributes[f](m)){k=!0,i[m]=h.attr(m),i[m]==null&&(i[m]=X[m]),j[m]=c[m];switch(Y[m]){case"along":var n=cu(c[m]),o=cv(c[m],n*!!c.back),p=h.getBBox();l[m]=n/d,l.tx=p.x,l.ty=p.y,l.sx=o.x,l.sy=o.y,j.rot=c.rot,j.back=c.back,j.len=n,c.rot&&(l.r=S(h.rotate())||0);break;case E:l[m]=(j[m]-i[m])/d;break;case"colour":i[m]=a.getRGB(i[m]);var q=a.getRGB(j[m]);l[m]={r:(q.r-i[m].r)/d,g:(q.g-i[m].g)/d,b:(q.b-i[m].b)/d};break;case"path":var t=bx(i[m],j[m]);i[m]=t[0];var u=t[1];l[m]=[];for(var v=0,x=i[m][w];v<x;v++){l[m][v]=[0];for(var y=1,z=i[m][v][w];y<z;y++)l[m][v][y]=(u[v][y]-i[m][v][y])/d}break;case"csv":var A=r(c[m])[s](b),B=r(i[m])[s](b);switch(m){case"translation":i[m]=[0,0],l[m]=[A[0]/d,A[1]/d];break;case"rotation":i[m]=B[1]==A[1]&&B[2]==A[2]?B:[0,A[1],A[2]],l[m]=[(A[0]-i[m][0])/d,0,0];break;case"scale":c[m]=A,i[m]=r(i[m])[s](b),l[m]=[(A[0]-i[m][0])/d,(A[1]-i[m][1])/d,0,0];break;case"clip-rect":i[m]=r(i[m])[s](b),l[m]=[],v=4;while(v--)l[m][v]=(A[v]-i[m][v])/d}j[m]=A;break;default:A=[].concat(c[m]),B=[].concat(i[m]),l[m]=[],v=h.paper.customAttributes[m][w];while(v--)l[m][v]=((A[v]||0)-(B[v]||0))/d}}if(!k){var C=[],D;for(var F in c)c[f](F)&&$.test(F)&&(m={value:c[F]},F=="from"&&(F=0),F=="to"&&(F=100),m.key=T(F,10),C.push(m));C.sort(bf),C[0].key&&C.unshift({key:0,value:h.attrs});for(v=0,x=C[w];v<x;v++)cz(C[v].value,h,d/100*C[v].key,d/100*(C[v-1]&&C[v-1].key||0),C[v-1]&&C[v-1].value.callback);D=C[C[w]-1].value.callback,D&&h.timeouts.push(setTimeout(function(){D.call(h)},d))}else{var G=a.easing_formulas[e];if(!G){G=r(e).match(P);if(G&&G[w]==5){var H=G;G=function(a){return cD(a,+H[1],+H[2],+H[3],+H[4],d)}}else G=function(a){return a}}cx.push({start:c.start||+(new Date),ms:d,easing:G,from:i,diff:l,to:j,el:h,t:{x:0,y:0}}),a.is(g,"function")&&(h._ac=setTimeout(function(){g.call(h)},d)),cx[w]==1&&setTimeout(cy)}return this},bP.stop=function(){for(var a=0;a<cx.length;a++)cx[a].el.id==this.id&&cx.splice(a--,1);for(a=0,ii=this.timeouts&&this.timeouts.length;a<ii;a++)clearTimeout(this.timeouts[a]);this.timeouts=[],clearTimeout(this._ac),delete this._ac;return this},bP.translate=function(a,b){return this.attr({translation:a+" "+b})},bP[H]=function(){return"Raphaël’s object"},a.ae=cx;var cE=function(a){this.items=[],this[w]=0,this.type="set";if(a)for(var b=0,c=a[w];b<c;b++)a[b]&&(a[b].constructor==bO||a[b].constructor==cE)&&(this[this.items[w]]=this.items[this.items[w]]=a[b],this[w]++)};cE[e][L]=function(){var a,b;for(var c=0,d=arguments[w];c<d;c++)a=arguments[c],a&&(a.constructor==bO||a.constructor==cE)&&(b=this.items[w],this[b]=this.items[b]=a,this[w]++);return this},cE[e].pop=function(){delete this[this[w]--];return this.items.pop()};for(var cF in bP)bP[f](cF)&&(cE[e][cF]=function(a){return function(){for(var b=0,c=this.items[w];b<c;b++)this.items[b][a][m](this.items[b],arguments);return this}}(cF));cE[e].attr=function(b,c){if(b&&a.is(b,G)&&a.is(b[0],"object"))for(var d=0,e=b[w];d<e;d++)this.items[d].attr(b[d]);else for(var f=0,g=this.items[w];f<g;f++)this.items[f].attr(b,c);return this},cE[e].animate=function(b,c,d,e){(a.is(d,"function")||!d)&&(e=d||null);var f=this.items[w],g=f,h,i=this,j;e&&(j=function(){!--f&&e.call(i)}),d=a.is(d,F)?d:j,h=this.items[--g].animate(b,c,d,j);while(g--)this.items[g]&&!this.items[g].removed&&this.items[g].animateWith(h,b,c,d,j);return this},cE[e].insertAfter=function(a){var b=this.items[w];while(b--)this.items[b].insertAfter(a);return this},cE[e].getBBox=function(){var a=[],b=[],c=[],d=[];for(var e=this.items[w];e--;){var f=this.items[e].getBBox();a[L](f.x),b[L](f.y),c[L](f.x+f.width),d[L](f.y+f.height)}a=A[m](0,a),b=A[m](0,b);return{x:a,y:b,width:z[m](0,c)-a,height:z[m](0,d)-b}},cE[e].clone=function(a){a=new cE;for(var b=0,c=this.items[w];b<c;b++)a[L](this.items[b].clone());return a},a.registerFont=function(a){if(!a.face)return a;this.fonts=this.fonts||{};var b={w:a.w,face:{},glyphs:{}},c=a.face["font-family"];for(var d in a.face)a.face[f](d)&&(b.face[d]=a.face[d]);this.fonts[c]?this.fonts[c][L](b):this.fonts[c]=[b];if(!a.svg){b.face["units-per-em"]=T(a.face["units-per-em"],10);for(var e in a.glyphs)if(a.glyphs[f](e)){var g=a.glyphs[e];b.glyphs[e]={w:g.w,k:{},d:g.d&&"M"+g.d[Z](/[mlcxtrv]/g,function(a){return({l:"L",c:"C",x:"z",t:"m",r:"l",v:"c"})[a]||"M"})+"z"};if(g.k)for(var h in g.k)g[f](h)&&(b.glyphs[e].k[h]=g.k[h])}}return a},k.getFont=function(b,c,d,e){e=e||"normal",d=d||"normal",c=+c||({normal:400,bold:700,lighter:300,bolder:800})[c]||400;if(!!a.fonts){var g=a.fonts[b];if(!g){var h=new RegExp("(^|\\s)"+b[Z](/[^\w\d\s+!~.:_-]/g,p)+"(\\s|$)","i");for(var i in a.fonts)if(a.fonts[f](i)&&h.test(i)){g=a.fonts[i];break}}var j;if(g)for(var k=0,l=g[w];k<l;k++){j=g[k];if(j.face["font-weight"]==c&&(j.face["font-style"]==d||!j.face["font-style"])&&j.face["font-stretch"]==e)break}return j}},k.print=function(c,d,e,f,g,h,i){h=h||"middle",i=z(A(i||0,1),-1);var j=this.set(),k=r(e)[s](p),l=0,m=p,n;a.is(f,e)&&(f=this.getFont(f));if(f){n=(g||16)/f.face["units-per-em"];var o=f.face.bbox.split(b),q=+o[0],t=+o[1]+(h=="baseline"?o[3]-o[1]+ +f.face.descent:(o[3]-o[1])/2);for(var u=0,v=k[w];u<v;u++){var x=u&&f.glyphs[k[u-1]]||{},y=f.glyphs[k[u]];l+=u?(x.w||f.w)+(x.k&&x.k[k[u]]||0)+f.w*i:0,y&&y.d&&j[L](this.path(y.d).attr({fill:"#000",stroke:"none",translation:[l,0]}))}j.scale(n,n,q,t).translate(c-q,d-t)}return j},a.format=function(b,c){var e=a.is(c,G)?[0][n](c):arguments;b&&a.is(b,F)&&e[w]-1&&(b=b[Z](d,function(a,b){return e[++b]==null?p:e[b]}));return b||p},a.ninja=function(){i.was?h.Raphael=i.is:delete Raphael;return a},a.el=bP,a.st=cE[e],i.was?h.Raphael=a:Raphael=a})()
if(window.Raphael){Raphael.shadow=function(K,J,L,F,Q){Q=Q||{};var B=jQuery(Q.target),N=jQuery("<div/>",{"class":"aui-shadow"}),A=Q.shadow||Q.color||"#000",P=Q.size*10||0,O=Q.offsetSize||3,M=Q.zindex||0,H=Q.radius||0,G="0.4",D=Q.blur||3,C,I,E;L+=P+2*D;F+=P+2*D;if(Raphael.shadow.BOX_SHADOW_SUPPORT){B.addClass("aui-box-shadow");return N.addClass("hidden")}if(K===0&&J===0&&B.length>0){E=B.offset();K=O-D+E.left;J=O-D+E.top}if(jQuery.browser.msie&&jQuery.browser.version<"9"){A="#f0f0f0";G="0.2"}N.css({position:"absolute",left:K,top:J,width:L,height:F,zIndex:M});if(B.length>0){N.appendTo(document.body);C=Raphael(N[0],L,F,H)}else{C=Raphael(K,J,L,F,H)}C.canvas.style.position="absolute";I=C.rect(D,D,L-2*D,F-2*D).attr({fill:A,stroke:A,blur:""+D,opacity:G});return N};Raphael.shadow.BOX_SHADOW_SUPPORT=(function(){var C=document.documentElement.style;var A=["boxShadow","MozBoxShadow","WebkitBoxShadow","msBoxShadow"];for(var B=0;B<A.length;B++){if(A[B] in C){return true}}return false})()};
(function(a,b){function ci(a){return d.isWindow(a)?a:a.nodeType===9?a.defaultView||a.parentWindow:!1}function cf(a){if(!b_[a]){var b=d("<"+a+">").appendTo("body"),c=b.css("display");b.remove();if(c==="none"||c==="")c="block";b_[a]=c}return b_[a]}function ce(a,b){var c={};d.each(cd.concat.apply([],cd.slice(0,b)),function(){c[this]=a});return c}function b$(){try{return new a.ActiveXObject("Microsoft.XMLHTTP")}catch(b){}}function bZ(){try{return new a.XMLHttpRequest}catch(b){}}function bY(){d(a).unload(function(){for(var a in bW)bW[a](0,1)})}function bS(a,c){a.dataFilter&&(c=a.dataFilter(c,a.dataType));var e=a.dataTypes,f={},g,h,i=e.length,j,k=e[0],l,m,n,o,p;for(g=1;g<i;g++){if(g===1)for(h in a.converters)typeof h=="string"&&(f[h.toLowerCase()]=a.converters[h]);l=k,k=e[g];if(k==="*")k=l;else if(l!=="*"&&l!==k){m=l+" "+k,n=f[m]||f["* "+k];if(!n){p=b;for(o in f){j=o.split(" ");if(j[0]===l||j[0]==="*"){p=f[j[1]+" "+k];if(p){o=f[o],o===!0?n=p:p===!0&&(n=o);break}}}}!n&&!p&&d.error("No conversion from "+m.replace(" "," to ")),n!==!0&&(c=n?n(c):p(o(c)))}}return c}function bR(a,c,d){var e=a.contents,f=a.dataTypes,g=a.responseFields,h,i,j,k;for(i in g)i in d&&(c[g[i]]=d[i]);while(f[0]==="*")f.shift(),h===b&&(h=a.mimeType||c.getResponseHeader("content-type"));if(h)for(i in e)if(e[i]&&e[i].test(h)){f.unshift(i);break}if(f[0]in d)j=f[0];else{for(i in d){if(!f[0]||a.converters[i+" "+f[0]]){j=i;break}k||(k=i)}j=j||k}if(j){j!==f[0]&&f.unshift(j);return d[j]}}function bQ(a,b,c,e){if(d.isArray(b)&&b.length)d.each(b,function(b,f){c||bs.test(a)?e(a,f):bQ(a+"["+(typeof f=="object"||d.isArray(f)?b:"")+"]",f,c,e)});else if(!c&&b!=null&&typeof b=="object")if(d.isArray(b)||d.isEmptyObject(b))e(a,"");else for(var f in b)bQ(a+"["+f+"]",b[f],c,e);else e(a,b)}function bP(a,c,d,e,f,g){f=f||c.dataTypes[0],g=g||{},g[f]=!0;var h=a[f],i=0,j=h?h.length:0,k=a===bJ,l;for(;i<j&&(k||!l);i++)l=h[i](c,d,e),typeof l=="string"&&(!k||g[l]?l=b:(c.dataTypes.unshift(l),l=bP(a,c,d,e,l,g)));(k||!l)&&!g["*"]&&(l=bP(a,c,d,e,"*",g));return l}function bO(a){return function(b,c){typeof b!="string"&&(c=b,b="*");if(d.isFunction(c)){var e=b.toLowerCase().split(bD),f=0,g=e.length,h,i,j;for(;f<g;f++)h=e[f],j=/^\+/.test(h),j&&(h=h.substr(1)||"*"),i=a[h]=a[h]||[],i[j?"unshift":"push"](c)}}}function bq(a,b,c){var e=b==="width"?bk:bl,f=b==="width"?a.offsetWidth:a.offsetHeight;if(c==="border")return f;d.each(e,function(){c||(f-=parseFloat(d.css(a,"padding"+this))||0),c==="margin"?f+=parseFloat(d.css(a,"margin"+this))||0:f-=parseFloat(d.css(a,"border"+this+"Width"))||0});return f}function bc(a,b){b.src?d.ajax({url:b.src,async:!1,dataType:"script"}):d.globalEval(b.text||b.textContent||b.innerHTML||""),b.parentNode&&b.parentNode.removeChild(b)}function bb(a){return"getElementsByTagName"in a?a.getElementsByTagName("*"):"querySelectorAll"in a?a.querySelectorAll("*"):[]}function ba(a,b){if(b.nodeType===1){var c=b.nodeName.toLowerCase();b.clearAttributes(),b.mergeAttributes(a);if(c==="object")b.outerHTML=a.outerHTML;else if(c!=="input"||a.type!=="checkbox"&&a.type!=="radio"){if(c==="option")b.selected=a.defaultSelected;else if(c==="input"||c==="textarea")b.defaultValue=a.defaultValue}else a.checked&&(b.defaultChecked=b.checked=a.checked),b.value!==a.value&&(b.value=a.value);b.removeAttribute(d.expando)}}function _(a,b){if(b.nodeType===1&&!!d.hasData(a)){var c=d.expando,e=d.data(a),f=d.data(b,e);if(e=e[c]){var g=e.events;f=f[c]=d.extend({},e);if(g){delete f.handle,f.events={};for(var h in g)for(var i=0,j=g[h].length;i<j;i++)d.event.add(b,h+(g[h][i].namespace?".":"")+g[h][i].namespace,g[h][i],g[h][i].data)}}}}function $(a,b){return d.nodeName(a,"table")?a.getElementsByTagName("tbody")[0]||a.appendChild(a.ownerDocument.createElement("tbody")):a}function Q(a,b,c){if(d.isFunction(b))return d.grep(a,function(a,d){var e=!!b.call(a,d,a);return e===c});if(b.nodeType)return d.grep(a,function(a,d){return a===b===c});if(typeof b=="string"){var e=d.grep(a,function(a){return a.nodeType===1});if(L.test(b))return d.filter(b,e,!c);b=d.filter(b,e)}return d.grep(a,function(a,e){return d.inArray(a,b)>=0===c})}function P(a){return!a||!a.parentNode||a.parentNode.nodeType===11}function H(a,b){return(a&&a!=="*"?a+".":"")+b.replace(t,"`").replace(u,"&")}function G(a){var b,c,e,f,g,h,i,j,k,l,m,n,o,p=[],q=[],s=d._data(this,"events");if(!(a.liveFired===this||!s||!s.live||a.target.disabled||a.button&&a.type==="click")){a.namespace&&(n=new RegExp("(^|\\.)"+a.namespace.split(".").join("\\.(?:.*\\.)?")+"(\\.|$)")),a.liveFired=this;var t=s.live.slice(0);for(i=0;i<t.length;i++)g=t[i],g.origType.replace(r,"")===a.type?q.push(g.selector):t.splice(i--,1);f=d(a.target).closest(q,a.currentTarget);for(j=0,k=f.length;j<k;j++){m=f[j];for(i=0;i<t.length;i++){g=t[i];if(m.selector===g.selector&&(!n||n.test(g.namespace))&&!m.elem.disabled){h=m.elem,e=null;if(g.preType==="mouseenter"||g.preType==="mouseleave")a.type=g.preType,e=d(a.relatedTarget).closest(g.selector)[0];(!e||e!==h)&&p.push({elem:h,handleObj:g,level:m.level})}}}for(j=0,k=p.length;j<k;j++){f=p[j];if(c&&f.level>c)break;a.currentTarget=f.elem,a.data=f.handleObj.data,a.handleObj=f.handleObj,o=f.handleObj.origHandler.apply(f.elem,arguments);if(o===!1||a.isPropagationStopped()){c=f.level,o===!1&&(b=!1);if(a.isImmediatePropagationStopped())break}}return b}}function E(a,c,e){var f=d.extend({},e[0]);f.type=a,f.originalEvent={},f.liveFired=b,d.event.handle.call(c,f),f.isDefaultPrevented()&&e[0].preventDefault()}function y(){return!0}function x(){return!1}function i(a){for(var b in a)if(b!=="toJSON")return!1;return!0}function h(a,c,e){if(e===b&&a.nodeType===1){e=a.getAttribute("data-"+c);if(typeof e=="string"){try{e=e==="true"?!0:e==="false"?!1:e==="null"?null:d.isNaN(e)?g.test(e)?d.parseJSON(e):e:parseFloat(e)}catch(f){}d.data(a,c,e)}else e=b}return e}var c=a.document,d=function(){function G(){if(!d.isReady){try{c.documentElement.doScroll("left")}catch(a){setTimeout(G,1);return}d.ready()}}var d=function(a,b){return new d.fn.init(a,b,g)},e=a.jQuery,f=a.$,g,h=/^(?:[^<]*(<[\w\W]+>)[^>]*$|#([\w\-]+)$)/,i=/\S/,j=/^\s+/,k=/\s+$/,l=/\d/,m=/^<(\w+)\s*\/?>(?:<\/\1>)?$/,n=/^[\],:{}\s]*$/,o=/\\(?:["\\\/bfnrt]|u[0-9a-fA-F]{4})/g,p=/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,q=/(?:^|:|,)(?:\s*\[)+/g,r=/(webkit)[ \/]([\w.]+)/,s=/(opera)(?:.*version)?[ \/]([\w.]+)/,t=/(msie) ([\w.]+)/,u=/(mozilla)(?:.*? rv:([\w.]+))?/,v=navigator.userAgent,w,x,y,z=Object.prototype.toString,A=Object.prototype.hasOwnProperty,B=Array.prototype.push,C=Array.prototype.slice,D=String.prototype.trim,E=Array.prototype.indexOf,F={};d.fn=d.prototype={constructor:d,init:function(a,e,f){var g,i,j,k;if(!a)return this;if(a.nodeType){this.context=this[0]=a,this.length=1;return this}if(a==="body"&&!e&&c.body){this.context=c,this[0]=c.body,this.selector="body",this.length=1;return this}if(typeof a=="string"){g=h.exec(a);if(g&&(g[1]||!e)){if(g[1]){e=e instanceof d?e[0]:e,k=e?e.ownerDocument||e:c,j=m.exec(a),j?d.isPlainObject(e)?(a=[c.createElement(j[1])],d.fn.attr.call(a,e,!0)):a=[k.createElement(j[1])]:(j=d.buildFragment([g[1]],[k]),a=(j.cacheable?d.clone(j.fragment):j.fragment).childNodes);return d.merge(this,a)}i=c.getElementById(g[2]);if(i&&i.parentNode){if(i.id!==g[2])return f.find(a);this.length=1,this[0]=i}this.context=c,this.selector=a;return this}return!e||e.jquery?(e||f).find(a):this.constructor(e).find(a)}if(d.isFunction(a))return f.ready(a);a.selector!==b&&(this.selector=a.selector,this.context=a.context);return d.makeArray(a,this)},selector:"",jquery:"1.5.2",length:0,size:function(){return this.length},toArray:function(){return C.call(this,0)},get:function(a){return a==null?this.toArray():a<0?this[this.length+a]:this[a]},pushStack:function(a,b,c){var e=this.constructor();d.isArray(a)?B.apply(e,a):d.merge(e,a),e.prevObject=this,e.context=this.context,b==="find"?e.selector=this.selector+(this.selector?" ":"")+c:b&&(e.selector=this.selector+"."+b+"("+c+")");return e},each:function(a,b){return d.each(this,a,b)},ready:function(a){d.bindReady(),x.done(a);return this},eq:function(a){return a===-1?this.slice(a):this.slice(a,+a+1)},first:function(){return this.eq(0)},last:function(){return this.eq(-1)},slice:function(){return this.pushStack(C.apply(this,arguments),"slice",C.call(arguments).join(","))},map:function(a){return this.pushStack(d.map(this,function(b,c){return a.call(b,c,b)}))},end:function(){return this.prevObject||this.constructor(null)},push:B,sort:[].sort,splice:[].splice},d.fn.init.prototype=d.fn,d.extend=d.fn.extend=function(){var a,c,e,f,g,h,i=arguments[0]||{},j=1,k=arguments.length,l=!1;typeof i=="boolean"&&(l=i,i=arguments[1]||{},j=2),typeof i!="object"&&!d.isFunction(i)&&(i={}),k===j&&(i=this,--j);for(;j<k;j++)if((a=arguments[j])!=null)for(c in a){e=i[c],f=a[c];if(i===f)continue;l&&f&&(d.isPlainObject(f)||(g=d.isArray(f)))?(g?(g=!1,h=e&&d.isArray(e)?e:[]):h=e&&d.isPlainObject(e)?e:{},i[c]=d.extend(l,h,f)):f!==b&&(i[c]=f)}return i},d.extend({noConflict:function(b){a.$=f,b&&(a.jQuery=e);return d},isReady:!1,readyWait:1,ready:function(a){a===!0&&d.readyWait--;if(!d.readyWait||a!==!0&&!d.isReady){if(!c.body)return setTimeout(d.ready,1);d.isReady=!0;if(a!==!0&&--d.readyWait>0)return;x.resolveWith(c,[d]),d.fn.trigger&&d(c).trigger("ready").unbind("ready")}},bindReady:function(){if(!x){x=d._Deferred();if(c.readyState==="complete")return setTimeout(d.ready,1);if(c.addEventListener)c.addEventListener("DOMContentLoaded",y,!1),a.addEventListener("load",d.ready,!1);else if(c.attachEvent){c.attachEvent("onreadystatechange",y),a.attachEvent("onload",d.ready);var b=!1;try{b=a.frameElement==null}catch(e){}c.documentElement.doScroll&&b&&G()}}},isFunction:function(a){return d.type(a)==="function"},isArray:Array.isArray||function(a){return d.type(a)==="array"},isWindow:function(a){return a&&typeof a=="object"&&"setInterval"in a},isNaN:function(a){return a==null||!l.test(a)||isNaN(a)},type:function(a){return a==null?String(a):F[z.call(a)]||"object"},isPlainObject:function(a){if(!a||d.type(a)!=="object"||a.nodeType||d.isWindow(a))return!1;if(a.constructor&&!A.call(a,"constructor")&&!A.call(a.constructor.prototype,"isPrototypeOf"))return!1;var c;for(c in a);return c===b||A.call(a,c)},isEmptyObject:function(a){for(var b in a)return!1;return!0},error:function(a){throw a},parseJSON:function(b){if(typeof b!="string"||!b)return null;b=d.trim(b);if(n.test(b.replace(o,"@").replace(p,"]").replace(q,"")))return a.JSON&&a.JSON.parse?a.JSON.parse(b):(new Function("return "+b))();d.error("Invalid JSON: "+b)},parseXML:function(b,c,e){a.DOMParser?(e=new DOMParser,c=e.parseFromString(b,"text/xml")):(c=new ActiveXObject("Microsoft.XMLDOM"),c.async="false",c.loadXML(b)),e=c.documentElement,(!e||!e.nodeName||e.nodeName==="parsererror")&&d.error("Invalid XML: "+b);return c},noop:function(){},globalEval:function(a){if(a&&i.test(a)){var b=c.head||c.getElementsByTagName("head")[0]||c.documentElement,e=c.createElement("script");d.support.scriptEval()?e.appendChild(c.createTextNode(a)):e.text=a,b.insertBefore(e,b.firstChild),b.removeChild(e)}},nodeName:function(a,b){return a.nodeName&&a.nodeName.toUpperCase()===b.toUpperCase()},each:function(a,c,e){var f,g=0,h=a.length,i=h===b||d.isFunction(a);if(e){if(i){for(f in a)if(c.apply(a[f],e)===!1)break}else for(;g<h;)if(c.apply(a[g++],e)===!1)break}else if(i){for(f in a)if(c.call(a[f],f,a[f])===!1)break}else for(var j=a[0];g<h&&c.call(j,g,j)!==!1;j=a[++g]);return a},trim:D?function(a){return a==null?"":D.call(a)}:function(a){return a==null?"":a.toString().replace(j,"").replace(k,"")},makeArray:function(a,b){var c=b||[];if(a!=null){var e=d.type(a);a.length==null||e==="string"||e==="function"||e==="regexp"||d.isWindow(a)?B.call(c,a):d.merge(c,a)}return c},inArray:function(a,b){if(b.indexOf)return b.indexOf(a);for(var c=0,d=b.length;c<d;c++)if(b[c]===a)return c;return-1},merge:function(a,c){var d=a.length,e=0;if(typeof c.length=="number")for(var f=c.length;e<f;e++)a[d++]=c[e];else while(c[e]!==b)a[d++]=c[e++];a.length=d;return a},grep:function(a,b,c){var d=[],e;c=!!c;for(var f=0,g=a.length;f<g;f++)e=!!b(a[f],f),c!==e&&d.push(a[f]);return d},map:function(a,b,c){var d=[],e;for(var f=0,g=a.length;f<g;f++)e=b(a[f],f,c),e!=null&&(d[d.length]=e);return d.concat.apply([],d)},guid:1,proxy:function(a,c,e){arguments.length===2&&(typeof c=="string"?(e=a,a=e[c],c=b):c&&!d.isFunction(c)&&(e=c,c=b)),!c&&a&&(c=function(){return a.apply(e||this,arguments)}),a&&(c.guid=a.guid=a.guid||c.guid||d.guid++);return c},access:function(a,c,e,f,g,h){var i=a.length;if(typeof c=="object"){for(var j in c)d.access(a,j,c[j],f,g,e);return a}if(e!==b){f=!h&&f&&d.isFunction(e);for(var k=0;k<i;k++)g(a[k],c,f?e.call(a[k],k,g(a[k],c)):e,h);return a}return i?g(a[0],c):b},now:function(){return(new Date).getTime()},uaMatch:function(a){a=a.toLowerCase();var b=r.exec(a)||s.exec(a)||t.exec(a)||a.indexOf("compatible")<0&&u.exec(a)||[];return{browser:b[1]||"",version:b[2]||"0"}},sub:function(){function a(b,c){return new a.fn.init(b,c)}d.extend(!0,a,this),a.superclass=this,a.fn=a.prototype=this(),a.fn.constructor=a,a.subclass=this.subclass,a.fn.init=function(b,c){c&&c instanceof d&&!(c instanceof a)&&(c=a(c));return d.fn.init.call(this,b,c,e)},a.fn.init.prototype=a.fn;var e=a(c);return a},browser:{}}),d.each("Boolean Number String Function Array Date RegExp Object".split(" "),function(a,b){F["[object "+b+"]"]=b.toLowerCase()}),w=d.uaMatch(v),w.browser&&(d.browser[w.browser]=!0,d.browser.version=w.version),d.browser.webkit&&(d.browser.safari=!0),E&&(d.inArray=function(a,b){return E.call(b,a)}),i.test("\u00a0")&&(j=/^[\s\xA0]+/,k=/[\s\xA0]+$/),g=d(c),c.addEventListener?y=function(){c.removeEventListener("DOMContentLoaded",y,!1),d.ready()}:c.attachEvent&&(y=function(){c.readyState==="complete"&&(c.detachEvent("onreadystatechange",y),d.ready())});return d}(),e="then done fail isResolved isRejected promise".split(" "),f=[].slice;d.extend({_Deferred:function(){var a=[],b,c,e,f={done:function(){if(!e){var c=arguments,g,h,i,j,k;b&&(k=b,b=0);for(g=0,h=c.length;g<h;g++)i=c[g],j=d.type(i),j==="array"?f.done.apply(f,i):j==="function"&&a.push(i);k&&f.resolveWith(k[0],k[1])}return this},resolveWith:function(d,f){if(!e&&!b&&!c){f=f||[],c=1;try{while(a[0])a.shift().apply(d,f)}finally{b=[d,f],c=0}}return this},resolve:function(){f.resolveWith(this,arguments);return this},isResolved:function(){return!!c||!!b},cancel:function(){e=1,a=[];return this}};return f},Deferred:function(a){var b=d._Deferred(),c=d._Deferred(),f;d.extend(b,{then:function(a,c){b.done(a).fail(c);return this},fail:c.done,rejectWith:c.resolveWith,reject:c.resolve,isRejected:c.isResolved,promise:function(a){if(a==null){if(f)return f;f=a={}}var c=e.length;while(c--)a[e[c]]=b[e[c]];return a}}),b.done(c.cancel).fail(b.cancel),delete b.cancel,a&&a.call(b,b);return b},when:function(a){function i(a){return function(c){b[a]=arguments.length>1?f.call(arguments,0):c,--g||h.resolveWith(h,f.call(b,0))}}var b=arguments,c=0,e=b.length,g=e,h=e<=1&&a&&d.isFunction(a.promise)?a:d.Deferred();if(e>1){for(;c<e;c++)b[c]&&d.isFunction(b[c].promise)?b[c].promise().then(i(c),h.reject):--g;g||h.resolveWith(h,b)}else h!==a&&h.resolveWith(h,e?[a]:[]);return h.promise()}}),function(){d.support={};var b=c.createElement("div");b.style.display="none",b.innerHTML="   <link/><table></table><a href='/a' style='color:red;float:left;opacity:.55;'>a</a><input type='checkbox'/>";var e=b.getElementsByTagName("*"),f=b.getElementsByTagName("a")[0],g=c.createElement("select"),h=g.appendChild(c.createElement("option")),i=b.getElementsByTagName("input")[0];if(!(!e||!e.length||!f)){d.support={leadingWhitespace:b.firstChild.nodeType===3,tbody:!b.getElementsByTagName("tbody").length,htmlSerialize:!!b.getElementsByTagName("link").length,style:/red/.test(f.getAttribute("style")),hrefNormalized:f.getAttribute("href")==="/a",opacity:/^0.55$/.test(f.style.opacity),cssFloat:!!f.style.cssFloat,checkOn:i.value==="on",optSelected:h.selected,deleteExpando:!0,optDisabled:!1,checkClone:!1,noCloneEvent:!0,noCloneChecked:!0,boxModel:null,inlineBlockNeedsLayout:!1,shrinkWrapBlocks:!1,reliableHiddenOffsets:!0,reliableMarginRight:!0},i.checked=!0,d.support.noCloneChecked=i.cloneNode(!0).checked,g.disabled=!0,d.support.optDisabled=!h.disabled;var j=null;d.support.scriptEval=function(){if(j===null){var b=c.documentElement,e=c.createElement("script"),f="script"+d.now();try{e.appendChild(c.createTextNode("window."+f+"=1;"))}catch(g){}b.insertBefore(e,b.firstChild),a[f]?(j=!0,delete a[f]):j=!1,b.removeChild(e)}return j};try{delete b.test}catch(k){d.support.deleteExpando=!1}!b.addEventListener&&b.attachEvent&&b.fireEvent&&(b.attachEvent("onclick",function l(){d.support.noCloneEvent=!1,b.detachEvent("onclick",l)}),b.cloneNode(!0).fireEvent("onclick")),b=c.createElement("div"),b.innerHTML="<input type='radio' name='radiotest' checked='checked'/>";var m=c.createDocumentFragment();m.appendChild(b.firstChild),d.support.checkClone=m.cloneNode(!0).cloneNode(!0).lastChild.checked,d(function(){var a=c.createElement("div"),b=c.getElementsByTagName("body")[0];if(!!b){a.style.width=a.style.paddingLeft="1px",b.appendChild(a),d.boxModel=d.support.boxModel=a.offsetWidth===2,"zoom"in a.style&&(a.style.display="inline",a.style.zoom=1,d.support.inlineBlockNeedsLayout=a.offsetWidth===2,a.style.display="",a.innerHTML="<div style='width:4px;'></div>",d.support.shrinkWrapBlocks=a.offsetWidth!==2),a.innerHTML="<table><tr><td style='padding:0;border:0;display:none'></td><td>t</td></tr></table>";var e=a.getElementsByTagName("td");d.support.reliableHiddenOffsets=e[0].offsetHeight===0,e[0].style.display="",e[1].style.display="none",d.support.reliableHiddenOffsets=d.support.reliableHiddenOffsets&&e[0].offsetHeight===0,a.innerHTML="",c.defaultView&&c.defaultView.getComputedStyle&&(a.style.width="1px",a.style.marginRight="0",d.support.reliableMarginRight=(parseInt((c.defaultView.getComputedStyle(a,null)||{marginRight:0}).marginRight,10)||0)===0),b.removeChild(a).style.display="none",a=e=null}});var n=function(a){var b=c.createElement("div");a="on"+a;if(!b.attachEvent)return!0;var d=a in b;d||(b.setAttribute(a,"return;"),d=typeof b[a]=="function");return d};d.support.submitBubbles=n("submit"),d.support.changeBubbles=n("change"),b=e=f=null}}();var g=/^(?:\{.*\}|\[.*\])$/;d.extend({cache:{},uuid:0,expando:"jQuery"+(d.fn.jquery+Math.random()).replace(/\D/g,""),noData:{embed:!0,object:"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",applet:!0},hasData:function(a){a=a.nodeType?d.cache[a[d.expando]]:a[d.expando];return!!a&&!i(a)},data:function(a,c,e,f){if(!!d.acceptData(a)){var g=d.expando,h=typeof c=="string",i,j=a.nodeType,k=j?d.cache:a,l=j?a[d.expando]:a[d.expando]&&d.expando;if((!l||f&&l&&!k[l][g])&&h&&e===b)return;l||(j?a[d.expando]=l=++d.uuid:l=d.expando),k[l]||(k[l]={},j||(k[l].toJSON=d.noop));if(typeof c=="object"||typeof c=="function")f?k[l][g]=d.extend(k[l][g],c):k[l]=d.extend(k[l],c);i=k[l],f&&(i[g]||(i[g]={}),i=i[g]),e!==b&&(i[c]=e);if(c==="events"&&!i[c])return i[g]&&i[g].events;return h?i[c]:i}},removeData:function(a,b,c){if(!!d.acceptData(a)){var e=d.expando,f=a.nodeType,g=f?d.cache:a,h=f?a[d.expando]:d.expando;if(!g[h])return;if(b){var j=c?g[h][e]:g[h];if(j){delete j[b];if(!i(j))return}}if(c){delete g[h][e];if(!i(g[h]))return}var k=g[h][e];d.support.deleteExpando||!d.isWindow(g)?delete g[h]:g[h]=null,k?(g[h]={},f||(g[h].toJSON=d.noop),g[h][e]=k):f&&(d.support.deleteExpando?delete a[d.expando]:a.removeAttribute?a.removeAttribute(d.expando):a[d.expando]=null)}},_data:function(a,b,c){return d.data(a,b,c,!0)},acceptData:function(a){if(a.nodeName){var b=d.noData[a.nodeName.toLowerCase()];if(b)return b!==!0&&a.getAttribute("classid")===b}return!0}}),d.fn.extend({data:function(a,c){var e=null;if(typeof a=="undefined"){if(this.length){e=d.data(this[0]);if(this[0].nodeType===1){var f=this[0].attributes,g;for(var i=0,j=f.length;i<j;i++)g=f[i].name,g.indexOf("data-")===0&&(g=g.substr(5),h(this[0],g,e[g]))}}return e}if(typeof a=="object")return this.each(function(){d.data(this,a)});var k=a.split(".");k[1]=k[1]?"."+k[1]:"";if(c===b){e=this.triggerHandler("getData"+k[1]+"!",[k[0]]),e===b&&this.length&&(e=d.data(this[0],a),e=h(this[0],a,e));return e===b&&k[1]?this.data(k[0]):e}return this.each(function(){var b=d(this),e=[k[0],c];b.triggerHandler("setData"+k[1]+"!",e),d.data(this,a,c),b.triggerHandler("changeData"+k[1]+"!",e)})},removeData:function(a){return this.each(function(){d.removeData(this,a)})}}),d.extend({queue:function(a,b,c){if(!!a){b=(b||"fx")+"queue";var e=d._data(a,b);if(!c)return e||[];!e||d.isArray(c)?e=d._data(a,b,d.makeArray(c)):e.push(c);return e}},dequeue:function(a,b){b=b||"fx";var c=d.queue(a,b),e=c.shift();e==="inprogress"&&(e=c.shift()),e&&(b==="fx"&&c.unshift("inprogress"),e.call(a,function(){d.dequeue(a,b)})),c.length||d.removeData(a,b+"queue",!0)}}),d.fn.extend({queue:function(a,c){typeof a!="string"&&(c=a,a="fx");if(c===b)return d.queue(this[0],a);return this.each(function(b){var e=d.queue(this,a,c);a==="fx"&&e[0]!=="inprogress"&&d.dequeue(this,a)})},dequeue:function(a){return this.each(function(){d.dequeue(this,a)})},delay:function(a,b){a=d.fx?d.fx.speeds[a]||a:a,b=b||"fx";return this.queue(b,function(){var c=this;setTimeout(function(){d.dequeue(c,b)},a)})},clearQueue:function(a){return this.queue(a||"fx",[])}});var j=/[\n\t\r]/g,k=/\s+/,l=/\r/g,m=/^(?:href|src|style)$/,n=/^(?:button|input)$/i,o=/^(?:button|input|object|select|textarea)$/i,p=/^a(?:rea)?$/i,q=/^(?:radio|checkbox)$/i;d.props={"for":"htmlFor","class":"className",readonly:"readOnly",maxlength:"maxLength",cellspacing:"cellSpacing",rowspan:"rowSpan",colspan:"colSpan",tabindex:"tabIndex",usemap:"useMap",frameborder:"frameBorder"},d.fn.extend({attr:function(a,b){return d.access(this,a,b,!0,d.attr)},removeAttr:function(a,b){return this.each(function(){d.attr(this,a,""),this.nodeType===1&&this.removeAttribute(a)})},addClass:function(a){if(d.isFunction(a))return this.each(function(b){var c=d(this);c.addClass(a.call(this,b,c.attr("class")))});if(a&&typeof a=="string"){var b=(a||"").split(k);for(var c=0,e=this.length;c<e;c++){var f=this[c];if(f.nodeType===1)if(!f.className)f.className=a;else{var g=" "+f.className+" ",h=f.className;for(var i=0,j=b.length;i<j;i++)g.indexOf(" "+b[i]+" ")<0&&(h+=" "+b[i]);f.className=d.trim(h)}}}return this},removeClass:function(a){if(d.isFunction(a))return this.each(function(b){var c=d(this);c.removeClass(a.call(this,b,c.attr("class")))});if(a&&typeof a=="string"||a===b){var c=(a||"").split(k);for(var e=0,f=this.length;e<f;e++){var g=this[e];if(g.nodeType===1&&g.className)if(a){var h=(" "+g.className+" ").replace(j," ");for(var i=0,l=c.length;i<l;i++)h=h.replace(" "+c[i]+" "," ");g.className=d.trim(h)}else g.className=""}}return this},toggleClass:function(a,b){var c=typeof a,e=typeof b=="boolean";if(d.isFunction(a))return this.each(function(c){var e=d(this);e.toggleClass(a.call(this,c,e.attr("class"),b),b)});return this.each(function(){if(c==="string"){var f,g=0,h=d(this),i=b,j=a.split(k);while(f=j[g++])i=e?i:!h.hasClass(f),h[i?"addClass":"removeClass"](f)}else if(c==="undefined"||c==="boolean")this.className&&d._data(this,"__className__",this.className),this.className=this.className||a===!1?"":d._data(this,"__className__")||""})},hasClass:function(a){var b=" "+a+" ";for(var c=0,d=this.length;c<d;c++)if((" "+this[c].className+" ").replace(j," ").indexOf(b)>-1)return!0;return!1},val:function(a){if(!arguments.length){var c=this[0];if(c){if(d.nodeName(c,"option")){var e=c.attributes.value;return!e||e.specified?c.value:c.text}if(d.nodeName(c,"select")){var f=c.selectedIndex,g=[],h=c.options,i=c.type==="select-one";if(f<0)return null;for(var j=i?f:0,k=i?f+1:h.length;j<k;j++){var m=h[j];if(m.selected&&(d.support.optDisabled?!m.disabled:m.getAttribute("disabled")===null)&&(!m.parentNode.disabled||!d.nodeName(m.parentNode,"optgroup"))){a=d(m).val();if(i)return a;g.push(a)}}if(i&&!g.length&&h.length)return d(h[f]).val();return g}if(q.test(c.type)&&!d.support.checkOn)return c.getAttribute("value")===null?"on":c.value;return(c.value||"").replace(l,"")}return b}var n=d.isFunction(a);return this.each(function(b){var c=d(this),e=a;if(this.nodeType===1){n&&(e=a.call(this,b,c.val())),e==null?e="":typeof e=="number"?e+="":d.isArray(e)&&(e=d.map(e,function(a){return a==null?"":a+""}));if(d.isArray(e)&&q.test(this.type))this.checked=d.inArray(c.val(),e)>=0;else if(d.nodeName(this,"select")){var f=d.makeArray(e);d("option",this).each(function(){this.selected=d.inArray(d(this).val(),f)>=0}),f.length||(this.selectedIndex=-1)}else this.value=e}})}}),d.extend({attrFn:{val:!0,css:!0,html:!0,text:!0,data:!0,width:!0,height:!0,offset:!0},attr:function(a,c,e,f){if(!a||a.nodeType===3||a.nodeType===8||a.nodeType===2)return b;if(f&&c in d.attrFn)return d(a)[c](e);var g=a.nodeType!==1||!d.isXMLDoc(a),h=e!==b;c=g&&d.props[c]||c;if(a.nodeType===1){var i=m.test(c);if(c==="selected"&&!d.support.optSelected){var j=a.parentNode;j&&(j.selectedIndex,j.parentNode&&j.parentNode.selectedIndex)}if((c in a||a[c]!==b)&&g&&!i){h&&(c==="type"&&n.test(a.nodeName)&&a.parentNode&&d.error("type property can't be changed"),e===null?a.nodeType===1&&a.removeAttribute(c):a[c]=e);if(d.nodeName(a,"form")&&a.getAttributeNode(c))return a.getAttributeNode(c).nodeValue;if(c==="tabIndex"){var k=a.getAttributeNode("tabIndex");return k&&k.specified?k.value:o.test(a.nodeName)||p.test(a.nodeName)&&a.href?0:b}return a[c]}if(!d.support.style&&g&&c==="style"){h&&(a.style.cssText=""+e);return a.style.cssText}h&&a.setAttribute(c,""+e);if(!a.attributes[c]&&a.hasAttribute&&!a.hasAttribute(c))return b;var l=!d.support.hrefNormalized&&g&&i?a.getAttribute(c,2):a.getAttribute(c);return l===null?b:l}h&&(a[c]=e);return a[c]}});var r=/\.(.*)$/,s=/^(?:textarea|input|select)$/i,t=/\./g,u=/ /g,v=/[^\w\s.|`]/g,w=function(a){return a.replace(v,"\\$&")};d.event={add:function(c,e,f,g){if(c.nodeType!==3&&c.nodeType!==8){try{d.isWindow(c)&&c!==a&&!c.frameElement&&(c=a)}catch(h){}if(f===!1)f=x;else if(!f)return;var i,j;f.handler&&(i=f,f=i.handler),f.guid||(f.guid=d.guid++);var k=d._data(c);if(!k)return;var l=k.events,m=k.handle;l||(k.events=l={}),m||(k.handle=m=function(a){return typeof d!="undefined"&&d.event.triggered!==a.type?d.event.handle.apply(m.elem,arguments):b}),m.elem=c,e=e.split(" ");var n,o=0,p;while(n=e[o++]){j=i?d.extend({},i):{handler:f,data:g},n.indexOf(".")>-1?(p=n.split("."),n=p.shift(),j.namespace=p.slice(0).sort().join(".")):(p=[],j.namespace=""),j.type=n,j.guid||(j.guid=f.guid);var q=l[n],r=d.event.special[n]||{};if(!q){q=l[n]=[];if(!r.setup||r.setup.call(c,g,p,m)===!1)c.addEventListener?c.addEventListener(n,m,!1):c.attachEvent&&c.attachEvent("on"+n,m)}r.add&&(r.add.call(c,j),j.handler.guid||(j.handler.guid=f.guid)),q.push(j),d.event.global[n]=!0}c=null}},global:{},remove:function(a,c,e,f){if(a.nodeType!==3&&a.nodeType!==8){e===!1&&(e=x);var g,h,i,j,k=0,l,m,n,o,p,q,r,s=d.hasData(a)&&d._data(a),t=s&&s.events;if(!s||!t)return;c&&c.type&&(e=c.handler,c=c.type);if(!c||typeof c=="string"&&c.charAt(0)==="."){c=c||"";for(h in t)d.event.remove(a,h+c);return}c=c.split(" ");while(h=c[k++]){r=h,q=null,l=h.indexOf(".")<0,m=[],l||(m=h.split("."),h=m.shift(),n=new RegExp("(^|\\.)"+d.map(m.slice(0).sort(),w).join("\\.(?:.*\\.)?")+"(\\.|$)")),p=t[h];if(!p)continue;if(!e){for(j=0;j<p.length;j++){q=p[j];if(l||n.test(q.namespace))d.event.remove(a,r,q.handler,j),p.splice(j--,1)}continue}o=d.event.special[h]||{};for(j=f||0;j<p.length;j++){q=p[j];if(e.guid===q.guid){if(l||n.test(q.namespace))f==null&&p.splice(j--,1),o.remove&&o.remove.call(a,q);if(f!=null)break}}if(p.length===0||f!=null&&p.length===1)(!o.teardown||o.teardown.call(a,m)===!1)&&d.removeEvent(a,h,s.handle),g=null,delete t[h]}if(d.isEmptyObject(t)){var u=s.handle;u&&(u.elem=null),delete s.events,delete s.handle,d.isEmptyObject(s)&&d.removeData(a,b,!0)}}},trigger:function(a,c,e){var f=a.type||a,g=arguments[3];if(!g){a=typeof a=="object"?a[d.expando]?a:d.extend(d.Event(f),a):d.Event(f),f.indexOf("!")>=0&&(a.type=f=f.slice(0,-1),a.exclusive=!0),e||(a.stopPropagation(),d.event.global[f]&&d.each(d.cache,function(){var b=d.expando,e=this[b];e&&e.events&&e.events[f]&&d.event.trigger(a,c,e.handle.elem)}));if(!e||e.nodeType===3||e.nodeType===8)return b;a.result=b,a.target=e,c=d.makeArray(c),c.unshift(a)}a.currentTarget=e;var h=d._data(e,"handle");h&&h.apply(e,c);var i=e.parentNode||e.ownerDocument;try{e&&e.nodeName&&d.noData[e.nodeName.toLowerCase()]||e["on"+f]&&e["on"+f].apply(e,c)===!1&&(a.result=!1,a.preventDefault())}catch(j){}if(!a.isPropagationStopped()&&i)d.event.trigger(a,c,i,!0);else if(!a.isDefaultPrevented()){var k,l=a.target,m=f.replace(r,""),n=d.nodeName(l,"a")&&m==="click",o=d.event.special[m]||{};if((!o._default||o._default.call(e,a)===!1)&&!n&&!(l&&l.nodeName&&d.noData[l.nodeName.toLowerCase()])){try{l[m]&&(k=l["on"+m],k&&(l["on"+m]=null),d.event.triggered=a.type,l[m]())}catch(p){}k&&(l["on"+m]=k),d.event.triggered=b}}},handle:function(c){var e,f,g,h,i,j=[],k=d.makeArray(arguments);c=k[0]=d.event.fix(c||a.event),c.currentTarget=this,e=c.type.indexOf(".")<0&&!c.exclusive,e||(g=c.type.split("."),c.type=g.shift(),j=g.slice(0).sort(),h=new RegExp("(^|\\.)"+j.join("\\.(?:.*\\.)?")+"(\\.|$)")),c.namespace=c.namespace||j.join("."),i=d._data(this,"events"),f=(i||{})[c.type];if(i&&f){f=f.slice(0);for(var l=0,m=f.length;l<m;l++){var n=f[l];if(e||h.test(n.namespace)){c.handler=n.handler,c.data=n.data,c.handleObj=n;var o=n.handler.apply(this,k);o!==b&&(c.result=o,o===!1&&(c.preventDefault(),c.stopPropagation()));if(c.isImmediatePropagationStopped())break}}}return c.result},props:"altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode layerX layerY metaKey newValue offsetX offsetY pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target toElement view wheelDelta which".split(" "),fix:function(a){if(a[d.expando])return a;var e=a;a=d.Event(e);for(var f=this.props.length,g;f;)g=this.props[--f],a[g]=e[g];a.target||(a.target=a.srcElement||c),a.target.nodeType===3&&(a.target=a.target.parentNode),!a.relatedTarget&&a.fromElement&&(a.relatedTarget=a.fromElement===a.target?a.toElement:a.fromElement);if(a.pageX==null&&a.clientX!=null){var h=c.documentElement,i=c.body;a.pageX=a.clientX+(h&&h.scrollLeft||i&&i.scrollLeft||0)-(h&&h.clientLeft||i&&i.clientLeft||0),a.pageY=a.clientY+(h&&h.scrollTop||i&&i.scrollTop||0)-(h&&h.clientTop||i&&i.clientTop||0)}a.which==null&&(a.charCode!=null||a.keyCode!=null)&&(a.which=a.charCode!=null?a.charCode:a.keyCode),!a.metaKey&&a.ctrlKey&&(a.metaKey=a.ctrlKey),!a.which&&a.button!==b&&(a.which=a.button&1?1:a.button&2?3:a.button&4?2:0);return a},guid:1e8,proxy:d.proxy,special:{ready:{setup:d.bindReady,teardown:d.noop},live:{add:function(a){d.event.add(this,H(a.origType,a.selector),d.extend({},a,{handler:G,guid:a.handler.guid}))},remove:function(a){d.event.remove(this,H(a.origType,a.selector),a)}},beforeunload:{setup:function(a,b,c){d.isWindow(this)&&(this.onbeforeunload=c)},teardown:function(a,b){this.onbeforeunload===b&&(this.onbeforeunload=null)}}}},d.removeEvent=c.removeEventListener?function(a,b,c){a.removeEventListener&&a.removeEventListener(b,c,!1)}:function(a,b,c){a.detachEvent&&a.detachEvent("on"+b,c)},d.Event=function(a){if(!this.preventDefault)return new d.Event(a);a&&a.type?(this.originalEvent=a,this.type=a.type,this.isDefaultPrevented=a.defaultPrevented||a.returnValue===!1||a.getPreventDefault&&a.getPreventDefault()?y:x):this.type=a,this.timeStamp=d.now(),this[d.expando]=!0},d.Event.prototype={preventDefault:function(){this.isDefaultPrevented=y;var a=this.originalEvent;!a||(a.preventDefault?a.preventDefault():a.returnValue=!1)},stopPropagation:function(){this.isPropagationStopped=y;var a=this.originalEvent;!a||(a.stopPropagation&&a.stopPropagation(),a.cancelBubble=!0)},stopImmediatePropagation:function(){this.isImmediatePropagationStopped=y,this.stopPropagation()},isDefaultPrevented:x,isPropagationStopped:x,isImmediatePropagationStopped:x};var z=function(a){var b=a.relatedTarget;try{if(b&&b!==c&&!b.parentNode)return;while(b&&b!==this)b=b.parentNode;b!==this&&(a.type=a.data,d.event.handle.apply(this,arguments))}catch(e){}},A=function(a){a.type=a.data,d.event.handle.apply(this,arguments)};d.each({mouseenter:"mouseover",mouseleave:"mouseout"},function(a,b){d.event.special[a]={setup:function(c){d.event.add(this,b,c&&c.selector?A:z,a)},teardown:function(a){d.event.remove(this,b,a&&a.selector?A:z)}}}),d.support.submitBubbles||(d.event.special.submit={setup:function(a,b){if(this.nodeName&&this.nodeName.toLowerCase()!=="form")d.event.add(this,"click.specialSubmit",function(a){var b=a.target,c=b.type;(c==="submit"||c==="image")&&d(b).closest("form").length&&E("submit",this,arguments)}),d.event.add(this,"keypress.specialSubmit",function(a){var b=a.target,c=b.type;(c==="text"||c==="password")&&d(b).closest("form").length&&a.keyCode===13&&E("submit",this,arguments)});else return!1},teardown:function(a){d.event.remove(this,".specialSubmit")}});if(!d.support.changeBubbles){var B,C=function(a){var b=a.type,c=a.value;b==="radio"||b==="checkbox"?c=a.checked:b==="select-multiple"?c=a.selectedIndex>-1?d.map(a.options,function(a){return a.selected}).join("-"):"":a.nodeName.toLowerCase()==="select"&&(c=a.selectedIndex);return c},D=function D(a){var c=a.target,e,f;if(!!s.test(c.nodeName)&&!c.readOnly){e=d._data(c,"_change_data"),f=C(c),(a.type!=="focusout"||c.type!=="radio")&&d._data(c,"_change_data",f);if(e===b||f===e)return;if(e!=null||f)a.type="change",a.liveFired=b,d.event.trigger(a,arguments[1],c)}};d.event.special.change={filters:{focusout:D,beforedeactivate:D,click:function(a){var b=a.target,c=b.type;(c==="radio"||c==="checkbox"||b.nodeName.toLowerCase()==="select")&&D.call(this,a)},keydown:function(a){var b=a.target,c=b.type;(a.keyCode===13&&b.nodeName.toLowerCase()!=="textarea"||a.keyCode===32&&(c==="checkbox"||c==="radio")||c==="select-multiple")&&D.call(this,a)},beforeactivate:function(a){var b=a.target;d._data(b,"_change_data",C(b))}},setup:function(a,b){if(this.type==="file")return!1;for(var c in B)d.event.add(this,c+".specialChange",B[c]);return s.test(this.nodeName)},teardown:function(a){d.event.remove(this,".specialChange");return s.test(this.nodeName)}},B=d.event.special.change.filters,B.focus=B.beforeactivate}c.addEventListener&&d.each({focus:"focusin",blur:"focusout"},function(a,b){function f(a){var c=d.event.fix(a);c.type=b,c.originalEvent={},d.event.trigger(c,null,c.target),c.isDefaultPrevented()&&a.preventDefault()}var e=0;d.event.special[b]={setup:function(){e++===0&&c.addEventListener(a,f,!0)},teardown:function(){--e===0&&c.removeEventListener(a,f,!0)}}}),d.each(["bind","one"],function(a,c){d.fn[c]=function(a,e,f){if(typeof a=="object"){for(var g in a)this[c](g,e,a[g],f);return this}if(d.isFunction(e)||e===!1)f=e,e=b;var h=c==="one"?d.proxy(f,function(a){d(this).unbind(a,h);return f.apply(this,arguments)}):f;if(a==="unload"&&c!=="one")this.one(a,e,f);else for(var i=0,j=this.length;i<j;i++)d.event.add(this[i],a,h,e);return this}}),d.fn.extend({unbind:function(a,b){if(typeof a=="object"&&!a.preventDefault)for(var c in a)this.unbind(c,a[c]);else for(var e=0,f=this.length;e<f;e++)d.event.remove(this[e],a,b);return this},delegate:function(a,b,c,d){return this.live(b,c,d,a)},undelegate:function(a,b,c){return arguments.length===0?this.unbind("live"):this.die(b,null,c,a)},trigger:function(a,b){return this.each(function(){d.event.trigger(a,b,this)})},triggerHandler:function(a,b){if(this[0]){var c=d.Event(a);c.preventDefault(),c.stopPropagation(),d.event.trigger(c,b,this[0]);return c.result}},toggle:function(a){var b=arguments,c=1;while(c<b.length)d.proxy(a,b[c++]);return this.click(d.proxy(a,function(e){var f=(d._data(this,"lastToggle"+a.guid)||0)%c;d._data(this,"lastToggle"+a.guid,f+1),e.preventDefault();return b[f].apply(this,arguments)||!1}))},hover:function(a,b){return this.mouseenter(a).mouseleave(b||a)}});var F={focus:"focusin",blur:"focusout",mouseenter:"mouseover",mouseleave:"mouseout"};d.each(["live","die"],function(a,c){d.fn[c]=function(a,e,f,g){var h,i=0,j,k,l,m=g||this.selector,n=g?this:d(this.context);if(typeof a=="object"&&!a.preventDefault){for(var o in a)n[c](o,e,a[o],m);return this}d.isFunction(e)&&(f=e,e=b),a=(a||"").split(" ");while((h=a[i++])!=null){j=r.exec(h),k="",j&&(k=j[0],h=h.replace(r,""));if(h==="hover"){a.push("mouseenter"+k,"mouseleave"+k);continue}l=h,h==="focus"||h==="blur"?(a.push(F[h]+k),h=h+k):h=(F[h]||h)+k;if(c==="live")for(var p=0,q=n.length;p<q;p++)d.event.add(n[p],"live."+H(h,m),{data:e,selector:m,handler:f,origType:h,origHandler:f,preType:l});else n.unbind("live."+H(h,m),f)}return this}}),d.each("blur focus focusin focusout load resize scroll unload click dblclick mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave change select submit keydown keypress keyup error".split(" "),function(a,b){d.fn[b]=function(a,c){c==null&&(c=a,a=null);return arguments.length>0?this.bind(b,a,c):this.trigger(b)},d.attrFn&&(d.attrFn[b]=!0)}),function(){function u(a,b,c,d,e,f){for(var g=0,h=d.length;g<h;g++){var i=d[g];if(i){var j=!1;i=i[a];while(i){if(i.sizcache===c){j=d[i.sizset];break}if(i.nodeType===1){f||(i.sizcache=c,i.sizset=g);if(typeof b!="string"){if(i===b){j=!0;break}}else if(k.filter(b,[i]).length>0){j=i;break}}i=i[a]}d[g]=j}}}function t(a,b,c,d,e,f){for(var g=0,h=d.length;g<h;g++){var i=d[g];if(i){var j=!1;i=i[a];while(i){if(i.sizcache===c){j=d[i.sizset];break}i.nodeType===1&&!f&&(i.sizcache=c,i.sizset=g);if(i.nodeName.toLowerCase()===b){j=i;break}i=i[a]}d[g]=j}}}var a=/((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^\[\]]*\]|['"][^'"]*['"]|[^\[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?((?:.|\r|\n)*)/g,e=0,f=Object.prototype.toString,g=!1,h=!0,i=/\\/g,j=/\W/;[0,0].sort(function(){h=!1;return 0});var k=function(b,d,e,g){e=e||[],d=d||c;var h=d;if(d.nodeType!==1&&d.nodeType!==9)return[];if(!b||typeof b!="string")return e;var i,j,n,o,q,r,s,t,u=!0,w=k.isXML(d),x=[],y=b;do{a.exec(""),i=a.exec(y);if(i){y=i[3],x.push(i[1]);if(i[2]){o=i[3];break}}}while(i);if(x.length>1&&m.exec(b))if(x.length===2&&l.relative[x[0]])j=v(x[0]+x[1],d);else{j=l.relative[x[0]]?[d]:k(x.shift(),d);while(x.length)b=x.shift(),l.relative[b]&&(b+=x.shift()),j=v(b,j)}else{!g&&x.length>1&&d.nodeType===9&&!w&&l.match.ID.test(x[0])&&!l.match.ID.test(x[x.length-1])&&(q=k.find(x.shift(),d,w),d=q.expr?k.filter(q.expr,q.set)[0]:q.set[0]);if(d){q=g?{expr:x.pop(),set:p(g)}:k.find(x.pop(),x.length===1&&(x[0]==="~"||x[0]==="+")&&d.parentNode?d.parentNode:d,w),j=q.expr?k.filter(q.expr,q.set):q.set,x.length>0?n=p(j):u=!1;while(x.length)r=x.pop(),s=r,l.relative[r]?s=x.pop():r="",s==null&&(s=d),l.relative[r](n,s,w)}else n=x=[]}n||(n=j),n||k.error(r||b);if(f.call(n)==="[object Array]")if(!u)e.push.apply(e,n);else if(d&&d.nodeType===1)for(t=0;n[t]!=null;t++)n[t]&&(n[t]===!0||n[t].nodeType===1&&k.contains(d,n[t]))&&e.push(j[t]);else for(t=0;n[t]!=null;t++)n[t]&&n[t].nodeType===1&&e.push(j[t]);else p(n,e);o&&(k(o,h,e,g),k.uniqueSort(e));return e};k.uniqueSort=function(a){if(r){g=h,a.sort(r);if(g)for(var b=1;b<a.length;b++)a[b]===a[b-1]&&a.splice(b--,1)}return a},k.matches=function(a,b){return k(a,null,null,b)},k.matchesSelector=function(a,b){return k(b,null,null,[a]).length>0},k.find=function(a,b,c){var d;if(!a)return[];for(var e=0,f=l.order.length;e<f;e++){var g,h=l.order[e];if(g=l.leftMatch[h].exec(a)){var j=g[1];g.splice(1,1);if(j.substr(j.length-1)!=="\\"){g[1]=(g[1]||"").replace(i,""),d=l.find[h](g,b,c);if(d!=null){a=a.replace(l.match[h],"");break}}}}d||(d=typeof b.getElementsByTagName!="undefined"?b.getElementsByTagName("*"):[]);return{set:d,expr:a}},k.filter=function(a,c,d,e){var f,g,h=a,i=[],j=c,m=c&&c[0]&&k.isXML(c[0]);while(a&&c.length){for(var n in l.filter)if((f=l.leftMatch[n].exec(a))!=null&&f[2]){var o,p,q=l.filter[n],r=f[1];g=!1,f.splice(1,1);if(r.substr(r.length-1)==="\\")continue;j===i&&(i=[]);if(l.preFilter[n]){f=l.preFilter[n](f,j,d,i,e,m);if(!f)g=o=!0;else if(f===!0)continue}if(f)for(var s=0;(p=j[s])!=null;s++)if(p){o=q(p,f,s,j);var t=e^!!o;d&&o!=null?t?g=!0:j[s]=!1:t&&(i.push(p),g=!0)}if(o!==b){d||(j=i),a=a.replace(l.match[n],"");if(!g)return[];break}}if(a===h)if(g==null)k.error(a);else break;h=a}return j},k.error=function(a){throw"Syntax error, unrecognized expression: "+a};var l=k.selectors={order:["ID","NAME","TAG"],match:{ID:/#((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,CLASS:/\.((?:[\w\u00c0-\uFFFF\-]|\\.)+)/,NAME:/\[name=['"]*((?:[\w\u00c0-\uFFFF\-]|\\.)+)['"]*\]/,ATTR:/\[\s*((?:[\w\u00c0-\uFFFF\-]|\\.)+)\s*(?:(\S?=)\s*(?:(['"])(.*?)\3|(#?(?:[\w\u00c0-\uFFFF\-]|\\.)*)|)|)\s*\]/,TAG:/^((?:[\w\u00c0-\uFFFF\*\-]|\\.)+)/,CHILD:/:(only|nth|last|first)-child(?:\(\s*(even|odd|(?:[+\-]?\d+|(?:[+\-]?\d*)?n\s*(?:[+\-]\s*\d+)?))\s*\))?/,POS:/:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^\-]|$)/,PSEUDO:/:((?:[\w\u00c0-\uFFFF\-]|\\.)+)(?:\((['"]?)((?:\([^\)]+\)|[^\(\)]*)+)\2\))?/},leftMatch:{},attrMap:{"class":"className","for":"htmlFor"},attrHandle:{href:function(a){return a.getAttribute("href")},type:function(a){return a.getAttribute("type")}},relative:{"+":function(a,b){var c=typeof b=="string",d=c&&!j.test(b),e=c&&!d;d&&(b=b.toLowerCase());for(var f=0,g=a.length,h;f<g;f++)if(h=a[f]){while((h=h.previousSibling)&&h.nodeType!==1);a[f]=e||h&&h.nodeName.toLowerCase()===b?h||!1:h===b}e&&k.filter(b,a,!0)},">":function(a,b){var c,d=typeof b=="string",e=0,f=a.length;if(d&&!j.test(b)){b=b.toLowerCase();for(;e<f;e++){c=a[e];if(c){var g=c.parentNode;a[e]=g.nodeName.toLowerCase()===b?g:!1}}}else{for(;e<f;e++)c=a[e],c&&(a[e]=d?c.parentNode:c.parentNode===b);d&&k.filter(b,a,!0)}},"":function(a,b,c){var d,f=e++,g=u;typeof b=="string"&&!j.test(b)&&(b=b.toLowerCase(),d=b,g=t),g("parentNode",b,f,a,d,c)},"~":function(a,b,c){var d,f=e++,g=u;typeof b=="string"&&!j.test(b)&&(b=b.toLowerCase(),d=b,g=t),g("previousSibling",b,f,a,d,c)}},find:{ID:function(a,b,c){if(typeof b.getElementById!="undefined"&&!c){var d=b.getElementById(a[1]);return d&&d.parentNode?[d]:[]}},NAME:function(a,b){if(typeof b.getElementsByName!="undefined"){var c=[],d=b.getElementsByName(a[1]);for(var e=0,f=d.length;e<f;e++)d[e].getAttribute("name")===a[1]&&c.push(d[e]);return c.length===0?null:c}},TAG:function(a,b){if(typeof b.getElementsByTagName!="undefined")return b.getElementsByTagName(a[1])}},preFilter:{CLASS:function(a,b,c,d,e,f){a=" "+a[1].replace(i,"")+" ";if(f)return a;for(var g=0,h;(h=b[g])!=null;g++)h&&(e^(h.className&&(" "+h.className+" ").replace(/[\t\n\r]/g," ").indexOf(a)>=0)?c||d.push(h):c&&(b[g]=!1));return!1},ID:function(a){return a[1].replace(i,"")},TAG:function(a,b){return a[1].replace(i,"").toLowerCase()},CHILD:function(a){if(a[1]==="nth"){a[2]||k.error(a[0]),a[2]=a[2].replace(/^\+|\s*/g,"");var b=/(-?)(\d*)(?:n([+\-]?\d*))?/.exec(a[2]==="even"&&"2n"||a[2]==="odd"&&"2n+1"||!/\D/.test(a[2])&&"0n+"+a[2]||a[2]);a[2]=b[1]+(b[2]||1)-0,a[3]=b[3]-0}else a[2]&&k.error(a[0]);a[0]=e++;return a},ATTR:function(a,b,c,d,e,f){var g=a[1]=a[1].replace(i,"");!f&&l.attrMap[g]&&(a[1]=l.attrMap[g]),a[4]=(a[4]||a[5]||"").replace(i,""),a[2]==="~="&&(a[4]=" "+a[4]+" ");return a},PSEUDO:function(b,c,d,e,f){if(b[1]==="not")if((a.exec(b[3])||"").length>1||/^\w/.test(b[3]))b[3]=k(b[3],null,null,c);else{var g=k.filter(b[3],c,d,!0^f);d||e.push.apply(e,g);return!1}else if(l.match.POS.test(b[0])||l.match.CHILD.test(b[0]))return!0;return b},POS:function(a){a.unshift(!0);return a}},filters:{enabled:function(a){return a.disabled===!1&&a.type!=="hidden"},disabled:function(a){return a.disabled===!0},checked:function(a){return a.checked===!0},selected:function(a){a.parentNode&&a.parentNode.selectedIndex;return a.selected===!0},parent:function(a){return!!a.firstChild},empty:function(a){return!a.firstChild},has:function(a,b,c){return!!k(c[3],a).length},header:function(a){return/h\d/i.test(a.nodeName)},text:function(a){var b=a.getAttribute("type"),c=a.type;return"text"===c&&(b===c||b===null)},radio:function(a){return"radio"===a.type},checkbox:function(a){return"checkbox"===a.type},file:function(a){return"file"===a.type},password:function(a){return"password"===a.type},submit:function(a){return"submit"===a.type},image:function(a){return"image"===a.type},reset:function(a){return"reset"===a.type},button:function(a){return"button"===a.type||a.nodeName.toLowerCase()==="button"},input:function(a){return/input|select|textarea|button/i.test(a.nodeName)}},setFilters:{first:function(a,b){return b===0},last:function(a,b,c,d){return b===d.length-1},even:function(a,b){return b%2===0},odd:function(a,b){return b%2===1},lt:function(a,b,c){return b<c[3]-0},gt:function(a,b,c){return b>c[3]-0},nth:function(a,b,c){return c[3]-0===b},eq:function(a,b,c){return c[3]-0===b}},filter:{PSEUDO:function(a,b,c,d){var e=b[1],f=l.filters[e];if(f)return f(a,c,b,d);if(e==="contains")return(a.textContent||a.innerText||k.getText([a])||"").indexOf(b[3])>=0;if(e==="not"){var g=b[3];for(var h=0,i=g.length;h<i;h++)if(g[h]===a)return!1;return!0}k.error(e)},CHILD:function(a,b){var c=b[1],d=a;switch(c){case"only":case"first":while(d=d.previousSibling)if(d.nodeType===1)return!1;if(c==="first")return!0;d=a;case"last":while(d=d.nextSibling)if(d.nodeType===1)return!1;return!0;case"nth":var e=b[2],f=b[3];if(e===1&&f===0)return!0;var g=b[0],h=a.parentNode;if(h&&(h.sizcache!==g||!a.nodeIndex)){var i=0;for(d=h.firstChild;d;d=d.nextSibling)d.nodeType===1&&(d.nodeIndex=++i);h.sizcache=g}var j=a.nodeIndex-f;return e===0?j===0:j%e===0&&j/e>=0}},ID:function(a,b){return a.nodeType===1&&a.getAttribute("id")===b},TAG:function(a,b){return b==="*"&&a.nodeType===1||a.nodeName.toLowerCase()===b},CLASS:function(a,b){return(" "+(a.className||a.getAttribute("class"))+" ").indexOf(b)>-1},ATTR:function(a,b){var c=b[1],d=l.attrHandle[c]?l.attrHandle[c](a):a[c]!=null?a[c]:a.getAttribute(c),e=d+"",f=b[2],g=b[4];return d==null?f==="!=":f==="="?e===g:f==="*="?e.indexOf(g)>=0:f==="~="?(" "+e+" ").indexOf(g)>=0:g?f==="!="?e!==g:f==="^="?e.indexOf(g)===0:f==="$="?e.substr(e.length-g.length)===g:f==="|="?e===g||e.substr(0,g.length+1)===g+"-":!1:e&&d!==!1},POS:function(a,b,c,d){var e=b[2],f=l.setFilters[e];if(f)return f(a,c,b,d)}}},m=l.match.POS,n=function(a,b){return"\\"+(b-0+1)};for(var o in l.match)l.match[o]=new RegExp(l.match[o].source+/(?![^\[]*\])(?![^\(]*\))/.source),l.leftMatch[o]=new RegExp(/(^(?:.|\r|\n)*?)/.source+l.match[o].source.replace(/\\(\d+)/g,n));var p=function(a,b){a=Array.prototype.slice.call(a,0);if(b){b.push.apply(b,a);return b}return a};try{Array.prototype.slice.call(c.documentElement.childNodes,0)[0].nodeType}catch(q){p=function(a,b){var c=0,d=b||[];if(f.call(a)==="[object Array]")Array.prototype.push.apply(d,a);else if(typeof a.length=="number")for(var e=a.length;c<e;c++)d.push(a[c]);else for(;a[c];c++)d.push(a[c]);return d}}var r,s;c.documentElement.compareDocumentPosition?r=function(a,b){if(a===b){g=!0;return 0}if(!a.compareDocumentPosition||!b.compareDocumentPosition)return a.compareDocumentPosition?-1:1;return a.compareDocumentPosition(b)&4?-1:1}:(r=function(a,b){var c,d,e=[],f=[],h=a.parentNode,i=b.parentNode,j=h;if(a===b){g=!0;return 0}if(h===i)return s(a,b);if(!h)return-1;if(!i)return 1;while(j)e.unshift(j),j=j.parentNode;j=i;while(j)f.unshift(j),j=j.parentNode;c=e.length,d=f.length;for(var k=0;k<c&&k<d;k++)if(e[k]!==f[k])return s(e[k],f[k]);return k===c?s(a,f[k],-1):s(e[k],b,1)},s=function(a,b,c){if(a===b)return c;var d=a.nextSibling;while(d){if(d===b)return-1;d=d.nextSibling}return 1}),k.getText=function(a){var b="",c;for(var d=0;a[d];d++)c=a[d],c.nodeType===3||c.nodeType===4?b+=c.nodeValue:c.nodeType!==8&&(b+=k.getText(c.childNodes));return b},function(){var a=c.createElement("div"),d="script"+(new Date).getTime(),e=c.documentElement;a.innerHTML="<a name='"+d+"'/>",e.insertBefore(a,e.firstChild),c.getElementById(d)&&(l.find.ID=function(a,c,d){if(typeof c.getElementById!="undefined"&&!d){var e=c.getElementById(a[1]);return e?e.id===a[1]||typeof e.getAttributeNode!="undefined"&&e.getAttributeNode("id").nodeValue===a[1]?[e]:b:[]}},l.filter.ID=function(a,b){var c=typeof a.getAttributeNode!="undefined"&&a.getAttributeNode("id");return a.nodeType===1&&c&&c.nodeValue===b}),e.removeChild(a),e=a=null}(),function(){var a=c.createElement("div");a.appendChild(c.createComment("")),a.getElementsByTagName("*").length>0&&(l.find.TAG=function(a,b){var c=b.getElementsByTagName(a[1]);if(a[1]==="*"){var d=[];for(var e=0;c[e];e++)c[e].nodeType===1&&d.push(c[e]);c=d}return c}),a.innerHTML="<a href='#'></a>",a.firstChild&&typeof a.firstChild.getAttribute!="undefined"&&a.firstChild.getAttribute("href")!=="#"&&(l.attrHandle.href=function(a){return a.getAttribute("href",2)}),a=null}(),c.querySelectorAll&&function(){var a=k,b=c.createElement("div"),d="__sizzle__";b.innerHTML="<p class='TEST'></p>";if(!b.querySelectorAll||b.querySelectorAll(".TEST").length!==0){k=function(b,e,f,g){e=e||c;if(!g&&!k.isXML(e)){var h=/^(\w+$)|^\.([\w\-]+$)|^#([\w\-]+$)/.exec(b);if(h&&(e.nodeType===1||e.nodeType===9)){if(h[1])return p(e.getElementsByTagName(b),f);if(h[2]&&l.find.CLASS&&e.getElementsByClassName)return p(e.getElementsByClassName(h[2]),f)}if(e.nodeType===9){if(b==="body"&&e.body)return p([e.body],f);if(h&&h[3]){var i=e.getElementById(h[3]);if(!i||!i.parentNode)return p([],f);if(i.id===h[3])return p([i],f)}try{return p(e.querySelectorAll(b),f)}catch(j){}}else if(e.nodeType===1&&e.nodeName.toLowerCase()!=="object"){var m=e,n=e.getAttribute("id"),o=n||d,q=e.parentNode,r=/^\s*[+~]/.test(b);n?o=o.replace(/'/g,"\\$&"):e.setAttribute("id",o),r&&q&&(e=e.parentNode);try{if(!r||q)return p(e.querySelectorAll("[id='"+o+"'] "+b),f)}catch(s){}finally{n||m.removeAttribute("id")}}}return a(b,e,f,g)};for(var e in a)k[e]=a[e];b=null}}(),function(){var a=c.documentElement,b=a.matchesSelector||a.mozMatchesSelector||a.webkitMatchesSelector||a.msMatchesSelector;if(b){var d=!b.call(c.createElement("div"),"div"),e=!1;try{b.call(c.documentElement,"[test!='']:sizzle")}catch(f){e=!0}k.matchesSelector=function(a,c){c=c.replace(/\=\s*([^'"\]]*)\s*\]/g,"='$1']");if(!k.isXML(a))try{if(e||!l.match.PSEUDO.test(c)&&!/!=/.test(c)){var f=b.call(a,c);if(f||!d||a.document&&a.document.nodeType!==11)return f}}catch(g){}return k(c,null,null,[a]).length>0}}}(),function(){var a=c.createElement("div");a.innerHTML="<div class='test e'></div><div class='test'></div>";if(!!a.getElementsByClassName&&a.getElementsByClassName("e").length!==0){a.lastChild.className="e";if(a.getElementsByClassName("e").length===1)return;l.order.splice(1,0,"CLASS"),l.find.CLASS=function(a,b,c){if(typeof b.getElementsByClassName!="undefined"&&!c)return b.getElementsByClassName(a[1])},a=null}}(),c.documentElement.contains?k.contains=function(a,b){return a!==b&&(a.contains?a.contains(b):!0)}:c.documentElement.compareDocumentPosition?k.contains=function(a,b){return!!(a.compareDocumentPosition(b)&16)}:k.contains=function(){return!1},k.isXML=function(a){var b=(a?a.ownerDocument||a:0).documentElement;return b?b.nodeName!=="HTML":!1};var v=function(a,b){var c,d=[],e="",f=b.nodeType?[b]:b;while(c=l.match.PSEUDO.exec(a))e+=c[0],a=a.replace(l.match.PSEUDO,"");a=l.relative[a]?a+"*":a;for(var g=0,h=f.length;g<h;g++)k(a,f[g],d);return k.filter(e,d)};d.find=k,d.expr=k.selectors,d.expr[":"]=d.expr.filters,d.unique=k.uniqueSort,d.text=k.getText,d.isXMLDoc=k.isXML,d.contains=k.contains}();var I=/Until$/,J=/^(?:parents|prevUntil|prevAll)/,K=/,/,L=/^.[^:#\[\.,]*$/,M=Array.prototype.slice,N=d.expr.match.POS,O={children:!0,contents:!0,next:!0,prev:!0};d.fn.extend({find:function(a){var b=this.pushStack("","find",a),c=0;for(var e=0,f=this.length;e<f;e++){c=b.length,d.find(a,this[e],b);if(e>0)for(var g=c;g<b.length;g++)for(var h=0;h<c;h++)if(b[h]===b[g]){b.splice(g--,1);break}}return b},has:function(a){var b=d(a);return this.filter(function(){for(var a=0,c=b.length;a<c;a++)if(d.contains(this,b[a]))return!0})},not:function(a){return this.pushStack(Q(this,a,!1),"not",a)},filter:function(a){return this.pushStack(Q(this,a,!0),"filter",a)},is:function(a){return!!a&&d.filter(a,this).length>0},closest:function(a,b){var c=[],e,f,g=this[0];if(d.isArray(a)){var h,i,j={},k=1;if(g&&a.length){for(e=0,f=a.length;e<f;e++)i=a[e],j[i]||(j[i]=d.expr.match.POS.test(i)?d(i,b||this.context):i);while(g&&g.ownerDocument&&g!==b){for(i in j)h=j[i],(h.jquery?h.index(g)>-1:d(g).is(h))&&c.push({selector:i,elem:g,level:k});g=g.parentNode,k++}}return c}var l=N.test(a)?d(a,b||this.context):null;for(e=0,f=this.length;e<f;e++){g=this[e];while(g){if(l?l.index(g)>-1:d.find.matchesSelector(g,a)){c.push(g);break}g=g.parentNode;if(!g||!g.ownerDocument||g===b)break}}c=c.length>1?d.unique(c):c;return this.pushStack(c,"closest",a)},index:function(a){if(!a||typeof a=="string")return d.inArray(this[0],a?d(a):this.parent().children());return d.inArray(a.jquery?a[0]:a,this)},add:function(a,b){var c=typeof a=="string"?d(a,b):d.makeArray(a),e=d.merge(this.get(),c);return this.pushStack(P(c[0])||P(e[0])?e:d.unique(e))},andSelf:function(){return this.add(this.prevObject)}}),d.each({parent:function(a){var b=a.parentNode;return b&&b.nodeType!==11?b:null},parents:function(a){return d.dir(a,"parentNode")},parentsUntil:function(a,b,c){return d.dir(a,"parentNode",c)},next:function(a){return d.nth(a,2,"nextSibling")},prev:function(a){return d.nth(a,2,"previousSibling")},nextAll:function(a){return d.dir(a,"nextSibling")},prevAll:function(a){return d.dir(a,"previousSibling")},nextUntil:function(a,b,c){return d.dir(a,"nextSibling",c)},prevUntil:function(a,b,c){return d.dir(a,"previousSibling",c)},siblings:function(a){return d.sibling(a.parentNode.firstChild,a)},children:function(a){return d.sibling(a.firstChild)},contents:function(a){return d.nodeName(a,"iframe")?a.contentDocument||a.contentWindow.document:d.makeArray(a.childNodes)}},function(a,b){d.fn[a]=function(c,e){var f=d.map(this,b,c),g=M.call(arguments);I.test(a)||(e=c),e&&typeof e=="string"&&(f=d.filter(e,f)),f=this.length>1&&!O[a]?d.unique(f):f,(this.length>1||K.test(e))&&J.test(a)&&(f=f.reverse());return this.pushStack(f,a,g.join(","))}}),d.extend({filter:function(a,b,c){c&&(a=":not("+a+")");return b.length===1?d.find.matchesSelector(b[0],a)?[b[0]]:[]:d.find.matches(a,b)},dir:function(a,c,e){var f=[],g=a[c];while(g&&g.nodeType!==9&&(e===b||g.nodeType!==1||!d(g).is(e)))g.nodeType===1&&f.push(g),g=g[c];return f},nth:function(a,b,c,d){b=b||1;var e=0;for(;a;a=a[c])if(a.nodeType===1&&++e===b)break;return a},sibling:function(a,b){var c=[];for(;a;a=a.nextSibling)a.nodeType===1&&a!==b&&c.push(a);return c}});var R=/ jQuery\d+="(?:\d+|null)"/g,S=/^\s+/,T=/<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/ig,U=/<([\w:]+)/,V=/<tbody/i,W=/<|&#?\w+;/,X=/<(?:script|object|embed|option|style)/i,Y=/checked\s*(?:[^=]|=\s*.checked.)/i,Z={option:[1,"<select multiple='multiple'>","</select>"],legend:[1,"<fieldset>","</fieldset>"],thead:[1,"<table>","</table>"],tr:[2,"<table><tbody>","</tbody></table>"],td:[3,"<table><tbody><tr>","</tr></tbody></table>"],col:[2,"<table><tbody></tbody><colgroup>","</colgroup></table>"],area:[1,"<map>","</map>"],_default:[0,"",""]};Z.optgroup=Z.option,Z.tbody=Z.tfoot=Z.colgroup=Z.caption=Z.thead,Z.th=Z.td,d.support.htmlSerialize||(Z._default=[1,"div<div>","</div>"]),d.fn.extend({text:function(a){if(d.isFunction(a))return this.each(function(b){var c=d(this);c.text(a.call(this,b,c.text()))});if(typeof a!="object"&&a!==b)return this.empty().append((this[0]&&this[0].ownerDocument||c).createTextNode(a));return d.text(this)},wrapAll:function(a){if(d.isFunction(a))return this.each(function(b){d(this).wrapAll(a.call(this,b))});if(this[0]){var b=d(a,this[0].ownerDocument).eq(0).clone(!0);this[0].parentNode&&b.insertBefore(this[0]),b.map(function(){var a=this;while(a.firstChild&&a.firstChild.nodeType===1)a=a.firstChild;return a}).append(this)}return this},wrapInner:function(a){if(d.isFunction(a))return this.each(function(b){d(this).wrapInner(a.call(this,b))});return this.each(function(){var b=d(this),c=b.contents();c.length?c.wrapAll(a):b.append(a)})},wrap:function(a){return this.each(function(){d(this).wrapAll(a)})},unwrap:function(){return this.parent().each(function(){d.nodeName(this,"body")||d(this).replaceWith(this.childNodes)}).end()},append:function(){return this.domManip(arguments,!0,function(a){this.nodeType===1&&this.appendChild(a)})},prepend:function(){return this.domManip(arguments,!0,function(a){this.nodeType===1&&this.insertBefore(a,this.firstChild)})},before:function(){if(this[0]&&this[0].parentNode)return this.domManip(arguments,!1,function(a){this.parentNode.insertBefore(a,this)});if(arguments.length){var a=d(arguments[0]);a.push.apply(a,this.toArray());return this.pushStack(a,"before",arguments)}},after:function(){if(this[0]&&this[0].parentNode)return this.domManip(arguments,!1,function(a){this.parentNode.insertBefore(a,this.nextSibling)});if(arguments.length){var a=this.pushStack(this,"after",arguments);a.push.apply(a,d(arguments[0]).toArray());return a}},remove:function(a,b){for(var c=0,e;(e=this[c])!=null;c++)if(!a||d.filter(a,[e]).length)!b&&e.nodeType===1&&(d.cleanData(e.getElementsByTagName("*")),d.cleanData([e])),e.parentNode&&e.parentNode.removeChild(e);return this},empty:function(){for(var a=0,b;(b=this[a])!=null;a++){b.nodeType===1&&d.cleanData(b.getElementsByTagName("*"));while(b.firstChild)b.removeChild(b.firstChild)}return this},clone:function(a,b){a=a==null?!1:a,b=b==null?a:b;return this.map(function(){return d.clone(this,a,b)})},html:function(a){if(a===b)return this[0]&&this[0].nodeType===1?this[0].innerHTML.replace(R,""):null;if(typeof a=="string"&&!X.test(a)&&(d.support.leadingWhitespace||!S.test(a))&&!Z[(U.exec(a)||["",""])[1].toLowerCase()]){a=a.replace(T,"<$1></$2>");try{for(var c=0,e=this.length;c<e;c++)this[c].nodeType===1&&(d.cleanData(this[c].getElementsByTagName("*")),this[c].innerHTML=a)}catch(f){this.empty().append(a)}}else d.isFunction(a)?this.each(function(b){var c=d(this);c.html(a.call(this,b,c.html()))}):this.empty().append(a);return this},replaceWith:function(a){if(this[0]&&this[0].parentNode){if(d.isFunction(a))return this.each(function(b){var c=d(this),e=c.html();c.replaceWith(a.call(this,b,e))});typeof a!="string"&&(a=d(a).detach());return this.each(function(){var b=this.nextSibling,c=this.parentNode;d(this).remove(),b?d(b).before(a):d(c).append(a)})}return this.length?this.pushStack(d(d.isFunction(a)?a():a),"replaceWith",a):this},detach:function(a){return this.remove(a,!0)},domManip:function(a,c,e){var f,g,h,i,j=a[0],k=[];if(!d.support.checkClone&&arguments.length===3&&typeof j=="string"&&Y.test(j))return this.each(function(){d(this).domManip(a,c,e,!0)});if(d.isFunction(j))return this.each(function(f){var g=d(this);a[0]=j.call(this,f,c?g.html():b),g.domManip(a,c,e)});if(this[0]){i=j&&j.parentNode,d.support.parentNode&&i&&i.nodeType===11&&i.childNodes.length===this.length?f={fragment:i}:f=d.buildFragment(a,this,k),h=f.fragment,h.childNodes.length===1?g=h=h.firstChild:g=h.firstChild;if(g){c=c&&d.nodeName(g,"tr");for(var l=0,m=this.length,n=m-1;l<m;l++)e.call(c?$(this[l],g):this[l],f.cacheable||m>1&&l<n?d.clone(h,!0,!0):h)}k.length&&d.each(k,bc)}return this}}),d.buildFragment=function(a,b,e){var f,g,h,i=b&&b[0]?b[0].ownerDocument||b[0]:c;a.length===1&&typeof a[0]=="string"&&a[0].length<512&&i===c&&a[0].charAt(0)==="<"&&!X.test(a[0])&&(d.support.checkClone||!Y.test(a[0]))&&(g=!0,h=d.fragments[a[0]],h&&h!==1&&(f=h)),f||(f=i.createDocumentFragment(),d.clean(a,i,f,e)),g&&(d.fragments[a[0]]=h?f:1);return{fragment:f,cacheable:g}},d.fragments={},d.each({appendTo:"append",prependTo:"prepend",insertBefore:"before",insertAfter:"after",replaceAll:"replaceWith"},function(a,b){d.fn[a]=function(c){var e=[],f=d(c),g=this.length===1&&this[0].parentNode;if(g&&g.nodeType===11&&g.childNodes.length===1&&f.length===1){f[b](this[0]);return this}for(var h=0,i=f.length;h<i;h++){var j=(h>0?this.clone(!0):this).get();d(f[h])[b](j),e=e.concat(j)}return this.pushStack(e,a,f.selector)}}),d.extend({clone:function(a,b,c){var e=a.cloneNode(!0),f,g,h;if((!d.support.noCloneEvent||!d.support.noCloneChecked)&&(a.nodeType===1||a.nodeType===11)&&!d.isXMLDoc(a)){ba(a,e),f=bb(a),g=bb(e);for(h=0;f[h];++h)ba(f[h],g[h])}if(b){_(a,e);if(c){f=bb(a),g=bb(e);for(h=0;f[h];++h)_(f[h],g[h])}}f=g=null;return e},clean:function(a,b,e,f){b=b||c,typeof b.createElement=="undefined"&&(b=b.ownerDocument||b[0]&&b[0].ownerDocument||c);var g=[];for(var h=0,i;(i=a[h])!=null;h++){typeof i=="number"&&(i+="");if(!i)continue;if(typeof i=="string"&&!W.test(i))i=b.createTextNode(i);else if(typeof i=="string"){i=i.replace(T,"<$1></$2>");var j=(U.exec(i)||["",""])[1].toLowerCase(),k=Z[j]||Z._default,l=k[0],m=b.createElement("div");m.innerHTML=k[1]+i+k[2];while(l--)m=m.lastChild;if(!d.support.tbody){var n=V.test(i),o=j==="table"&&!n?m.firstChild&&m.firstChild.childNodes:k[1]==="<table>"&&!n?m.childNodes:[];for(var p=o.length-1;p>=0;--p)d.nodeName(o[p],"tbody")&&!o[p].childNodes.length&&o[p].parentNode.removeChild(o[p])}!d.support.leadingWhitespace&&S.test(i)&&m.insertBefore(b.createTextNode(S.exec(i)[0]),m.firstChild),i=m.childNodes}i.nodeType?g.push(i):g=d.merge(g,i)}if(e)for(h=0;g[h];h++)f&&d.nodeName(g[h],"script")&&(!g[h].type||g[h].type.toLowerCase()==="text/javascript")?f.push(g[h].parentNode?g[h].parentNode.removeChild(g[h]):g[h]):(g[h].nodeType===1&&g.splice.apply(g,[h+1,0].concat(d.makeArray(g[h].getElementsByTagName("script")))),e.appendChild(g[h]));return g},cleanData:function(a){var b,c,e=d.cache,f=d.expando,g=d.event.special,h=d.support.deleteExpando;for(var i=0,j;(j=a[i])!=null;i++){if(j.nodeName&&d.noData[j.nodeName.toLowerCase()])continue;c=j[d.expando];if(c){b=e[c]&&e[c][f];if(b&&b.events){for(var k in b.events)g[k]?d.event.remove(j,k):d.removeEvent(j,k,b.handle);b.handle&&(b.handle.elem=null)}h?delete j[d.expando]:j.removeAttribute&&j.removeAttribute(d.expando),delete e[c]}}}});var bd=/alpha\([^)]*\)/i,be=/opacity=([^)]*)/,bf=/-([a-z])/ig,bg=/([A-Z]|^ms)/g,bh=/^-?\d+(?:px)?$/i,bi=/^-?\d/,bj={position:"absolute",visibility:"hidden",display:"block"},bk=["Left","Right"],bl=["Top","Bottom"],bm,bn,bo,bp=function(a,b){return b.toUpperCase()};d.fn.css=function(a,c){if(arguments.length===2&&c===b)return this;return d.access(this,a,c,!0,function(a,c,e){return e!==b?d.style(a,c,e):d.css(a,c)})},d.extend({cssHooks:{opacity:{get:function(a,b){if(b){var c=bm(a,"opacity","opacity");return c===""?"1":c}return a.style.opacity}}},cssNumber:{zIndex:!0,fontWeight:!0,opacity:!0,zoom:!0,lineHeight:!0},cssProps:{"float":d.support.cssFloat?"cssFloat":"styleFloat"},style:function(a,c,e,f){if(!!a&&a.nodeType!==3&&a.nodeType!==8&&!!a.style){var g,h=d.camelCase(c),i=a.style,j=d.cssHooks[h];c=d.cssProps[h]||h;if(e===b){if(j&&"get"in j&&(g=j.get(a,!1,f))!==b)return g;return i[c]}if(typeof e=="number"&&isNaN(e)||e==null)return;typeof e=="number"&&!d.cssNumber[h]&&(e+="px");if(!j||!("set"in j)||(e=j.set(a,e))!==b)try{i[c]=e}catch(k){}}},css:function(a,c,e){var f,g=d.camelCase(c),h=d.cssHooks[g];c=d.cssProps[g]||g;if(h&&"get"in h&&(f=h.get(a,!0,e))!==b)return f;if(bm)return bm(a,c,g)},swap:function(a,b,c){var d={};for(var e in b)d[e]=a.style[e],a.style[e]=b[e];c.call(a);for(e in b)a.style[e]=d[e]},camelCase:function(a){return a.replace(bf,bp)}}),d.curCSS=d.css,d.each(["height","width"],function(a,b){d.cssHooks[b]={get:function(a,c,e){var f;if(c){a.offsetWidth!==0?f=bq(a,b,e):d.swap(a,bj,function(){f=bq(a,b,e)});if(f<=0){f=bm(a,b,b),f==="0px"&&bo&&(f=bo(a,b,b));if(f!=null)return f===""||f==="auto"?"0px":f}if(f<0||f==null){f=a.style[b];return f===""||f==="auto"?"0px":f}return typeof f=="string"?f:f+"px"}},set:function(a,b){if(!bh.test(b))return b;b=parseFloat(b);if(b>=0)return b+"px"}}}),d.support.opacity||(d.cssHooks.opacity={get:function(a,b){return be.test((b&&a.currentStyle?a.currentStyle.filter:a.style.filter)||"")?parseFloat(RegExp.$1)/100+"":b?"1":""},set:function(a,b){var c=a.style;c.zoom=1;var e=d.isNaN(b)?"":"alpha(opacity="+b*100+")",f=c.filter||"";c.filter=bd.test(f)?f.replace(bd,e):c.filter+" "+e}}),d(function(){d.support.reliableMarginRight||(d.cssHooks.marginRight={get:function(a,b){var c;d.swap(a,{display:"inline-block"},function(){b?c=bm(a,"margin-right","marginRight"):c=a.style.marginRight});return c}})}),c.defaultView&&c.defaultView.getComputedStyle&&(bn=function(a,c,e){var f,g,h;e=e.replace(bg,"-$1").toLowerCase();if(!(g=a.ownerDocument.defaultView))return b;if(h=g.getComputedStyle(a,null))f=h.getPropertyValue(e),f===""&&!d.contains(a.ownerDocument.documentElement,a)&&(f=d.style(a,e));return f}),c.documentElement.currentStyle&&(bo=function(a,b){var c,d=a.currentStyle&&a.currentStyle[b],e=a.runtimeStyle&&a.runtimeStyle[b],f=a.style;!bh.test(d)&&bi.test(d)&&(c=f.left,e&&(a.runtimeStyle.left=a.currentStyle.left),f.left=b==="fontSize"?"1em":d||0,d=f.pixelLeft+"px",f.left=c,e&&(a.runtimeStyle.left=e));return d===""?"auto":d}),bm=bn||bo,d.expr&&d.expr.filters&&(d.expr.filters.hidden=function(a){var b=a.offsetWidth,c=a.offsetHeight;return b===0&&c===0||!d.support.reliableHiddenOffsets&&(a.style.display||d.css(a,"display"))==="none"},d.expr.filters.visible=function(a){return!d.expr.filters.hidden(a)});var br=/%20/g,bs=/\[\]$/,bt=/\r?\n/g,bu=/#.*$/,bv=/^(.*?):[ \t]*([^\r\n]*)\r?$/mg,bw=/^(?:color|date|datetime|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,bx=/^(?:about|app|app\-storage|.+\-extension|file|widget):$/,by=/^(?:GET|HEAD)$/,bz=/^\/\//,bA=/\?/,bB=/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,bC=/^(?:select|textarea)/i,bD=/\s+/,bE=/([?&])_=[^&]*/,bF=/(^|\-)([a-z])/g,bG=function(a,b,c){return b+c.toUpperCase()},bH=/^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+))?)?/,bI=d.fn.load,bJ={},bK={},bL,bM;try{bL=c.location.href}catch(bN){bL=c.createElement("a"),bL.href="",bL=bL.href}bM=bH.exec(bL.toLowerCase())||[],d.fn.extend({load:function(a,c,e){if(typeof a!="string"&&bI)return bI.apply(this,arguments);if(!this.length)return this;var f=a.indexOf(" ");if(f>=0){var g=a.slice(f,a.length);a=a.slice(0,f)}var h="GET";c&&(d.isFunction(c)?(e=c,c=b):typeof c=="object"&&(c=d.param(c,d.ajaxSettings.traditional),h="POST"));var i=this;d.ajax({url:a,type:h,dataType:"html",data:c,complete:function(a,b,c){c=a.responseText,a.isResolved()&&(a.done(function(a){c=a}),i.html(g?d("<div>").append(c.replace(bB,"")).find(g):c)),e&&i.each(e,[c,b,a])}});return this},serialize:function(){return d.param(this.serializeArray())},serializeArray:function(){return this.map(function(){return this.elements?d.makeArray(this.elements):this}).filter(function(){return this.name&&!this.disabled&&(this.checked||bC.test(this.nodeName)||bw.test(this.type))}).map(function(a,b){var c=d(this).val();return c==null?null:d.isArray(c)?d.map(c,function(a,c){return{name:b.name,value:a.replace(bt,"\r\n")}}):{name:b.name,value:c.replace(bt,"\r\n")}}).get()}}),d.each("ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split(" "),function(a,b){d.fn[b]=function(a){return this.bind(b,a)}}),d.each(["get","post"],function(a,c){d[c]=function(a,e,f,g){d.isFunction(e)&&(g=g||f,f=e,e=b);return d.ajax({type:c,url:a,data:e,success:f,dataType:g})}}),d.extend({getScript:function(a,c){return d.get(a,b,c,"script")},getJSON:function(a,b,c){return d.get(a,b,c,"json")},ajaxSetup:function(a,b){b?d.extend(!0,a,d.ajaxSettings,b):(b=a,a=d.extend(!0,d.ajaxSettings,b));for(var c in{context:1,url:1})c in b?a[c]=b[c]:c in d.ajaxSettings&&(a[c]=d.ajaxSettings[c]);return a},ajaxSettings:{url:bL,isLocal:bx.test(bM[1]),global:!0,type:"GET",contentType:"application/x-www-form-urlencoded",processData:!0,async:!0,accepts:{xml:"application/xml, text/xml",html:"text/html",text:"text/plain",json:"application/json, text/javascript","*":"*/*"},contents:{xml:/xml/,html:/html/,json:/json/},responseFields:{xml:"responseXML",text:"responseText"},converters:{"* text":a.String,"text html":!0,"text json":d.parseJSON,"text xml":d.parseXML}},ajaxPrefilter:bO(bJ),ajaxTransport:bO(bK),ajax:function(a,c){function v(a,c,l,n){if(r!==2){r=2,p&&clearTimeout(p),o=b,m=n||"",u.readyState=a?4:0;var q,t,v,w=l?bR(e,u,l):b,x,y;if(a>=200&&a<300||a===304){if(e.ifModified){if(x=u.getResponseHeader("Last-Modified"))d.lastModified[k]=x;if(y=u.getResponseHeader("Etag"))d.etag[k]=y}if(a===304)c="notmodified",q=!0;else try{t=bS(e,w),c="success",q=!0}catch(z){c="parsererror",v=z}}else{v=c;if(!c||a)c="error",a<0&&(a=0)}u.status=a,u.statusText=c,q?h.resolveWith(f,[t,c,u]):h.rejectWith(f,[u,c,v]),u.statusCode(j),j=b,s&&g.trigger("ajax"+(q?"Success":"Error"),[u,e,q?t:v]),i.resolveWith(f,[u,c]),s&&(g.trigger("ajaxComplete",[u,e]),--d.active||d.event.trigger("ajaxStop"))}}typeof a=="object"&&(c=a,a=b),c=c||{};var e=d.ajaxSetup({},c),f=e.context||e,g=f!==e&&(f.nodeType||f instanceof d)?d(f):d.event,h=d.Deferred(),i=d._Deferred(),j=e.statusCode||{},k,l={},m,n,o,p,q,r=0,s,t,u={readyState:0,setRequestHeader:function(a,b){r||(l[a.toLowerCase().replace(bF,bG)]=b);return this},getAllResponseHeaders:function(){return r===2?m:null},getResponseHeader:function(a){var c;if(r===2){if(!n){n={};while(c=bv.exec(m))n[c[1].toLowerCase()]=c[2]}c=n[a.toLowerCase()]}return c===b?null:c},overrideMimeType:function(a){r||(e.mimeType=a);return this},abort:function(a){a=a||"abort",o&&o.abort(a),v(0,a);return this}};h.promise(u),u.success=u.done,u.error=u.fail,u.complete=i.done,u.statusCode=function(a){if(a){var b;if(r<2)for(b in a)j[b]=[j[b],a[b]];else b=a[u.status],u.then(b,b)}return this},e.url=((a||e.url)+"").replace(bu,"").replace(bz,bM[1]+"//"),e.dataTypes=d.trim(e.dataType||"*").toLowerCase().split(bD),e.crossDomain==null&&(q=bH.exec(e.url.toLowerCase()),e.crossDomain=!(!q||q[1]==bM[1]&&q[2]==bM[2]&&(q[3]||(q[1]==="http:"?80:443))==(bM[3]||(bM[1]==="http:"?80:443)))),e.data&&e.processData&&typeof e.data!="string"&&(e.data=d.param(e.data,e.traditional)),bP(bJ,e,c,u);if(r===2)return!1;s=e.global,e.type=e.type.toUpperCase(),e.hasContent=!by.test(e.type),s&&d.active++===0&&d.event.trigger("ajaxStart");if(!e.hasContent){e.data&&(e.url+=(bA.test(e.url)?"&":"?")+e.data),k=e.url;if(e.cache===!1){var w=d.now(),x=e.url.replace(bE,"$1_="+w);e.url=x+(x===e.url?(bA.test(e.url)?"&":"?")+"_="+w:"")}}if(e.data&&e.hasContent&&e.contentType!==!1||c.contentType)l["Content-Type"]=e.contentType;e.ifModified&&(k=k||e.url,d.lastModified[k]&&(l["If-Modified-Since"]=d.lastModified[k]),d.etag[k]&&(l["If-None-Match"]=d.etag[k])),l.Accept=e.dataTypes[0]&&e.accepts[e.dataTypes[0]]?e.accepts[e.dataTypes[0]]+(e.dataTypes[0]!=="*"?", */*; q=0.01":""):e.accepts["*"];for(t in e.headers)u.setRequestHeader(t,e.headers[t]);if(e.beforeSend&&(e.beforeSend.call(f,u,e)===!1||r===2)){u.abort();return!1}for(t in{success:1,error:1,complete:1})u[t](e[t]);o=bP(bK,e,c,u);if(!o)v(-1,"No Transport");else{u.readyState=1,s&&g.trigger("ajaxSend",[u,e]),e.async&&e.timeout>0&&(p=setTimeout(function(){u.abort("timeout")},e.timeout));try{r=1,o.send(l,v)}catch(y){status<2?v(-1,y):d.error(y)}}return u},param:function(a,c){var e=[],f=function(a,b){b=d.isFunction(b)?b():b,e[e.length]=encodeURIComponent(a)+"="+encodeURIComponent(b)};c===b&&(c=d.ajaxSettings.traditional);if(d.isArray(a)||a.jquery&&!d.isPlainObject(a))d.each(a,function(){f(this.name,this.value)});else for(var g in a)bQ(g,a[g],c,f);return e.join("&").replace(br,"+")}}),d.extend({active:0,lastModified:{},etag:{}});var bT=d.now(),bU=/(\=)\?(&|$)|\?\?/i;d.ajaxSetup({jsonp:"callback",jsonpCallback:function(){return d.expando+"_"+bT++}}),d.ajaxPrefilter("json jsonp",function(b,c,e){var f=typeof b.data=="string";if(b.dataTypes[0]==="jsonp"||c.jsonpCallback||c.jsonp!=null||b.jsonp!==!1&&(bU.test(b.url)||f&&bU.test(b.data))){var g,h=b.jsonpCallback=d.isFunction(b.jsonpCallback)?b.jsonpCallback():b.jsonpCallback,i=a[h],j=b.url,k=b.data,l="$1"+h+"$2",m=function(){a[h]=i,g&&d.isFunction(i)&&a[h](g[0])};b.jsonp!==!1&&(j=j.replace(bU,l),b.url===j&&(f&&(k=k.replace(bU,l)),b.data===k&&(j+=(/\?/.test(j)?"&":"?")+b.jsonp+"="+h))),b.url=j,b.data=k,a[h]=function(a){g=[a]},e.then(m,m),b.converters["script json"]=function(){g||d.error(h+" was not called");return g[0]},b.dataTypes[0]="json";return"script"}}),d.ajaxSetup({accepts:{script:"text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"},contents:{script:/javascript|ecmascript/},converters:{"text script":function(a){d.globalEval(a);return a}}}),d.ajaxPrefilter("script",function(a){a.cache===b&&(a.cache=!1),a.crossDomain&&(a.type="GET",a.global=!1)}),d.ajaxTransport("script",function(a){if(a.crossDomain){var d,e=c.head||c.getElementsByTagName("head")[0]||c.documentElement;return{send:function(f,g){d=c.createElement("script"),d.async="async",a.scriptCharset&&(d.charset=a.scriptCharset),d.src=a.url,d.onload=d.onreadystatechange=function(a,c){if(!d.readyState||/loaded|complete/.test(d.readyState))d.onload=d.onreadystatechange=null,e&&d.parentNode&&e.removeChild(d),d=b,c||g(200,"success")},e.insertBefore(d,e.firstChild)},abort:function(){d&&d.onload(0,1)}}}});var bV=d.now(),bW,bX;d.ajaxSettings.xhr=a.ActiveXObject?function(){return!this.isLocal&&bZ()||b$()}:bZ,bX=d.ajaxSettings.xhr(),d.support.ajax=!!bX,d.support.cors=bX&&"withCredentials"in bX,bX=b,d.support.ajax&&d.ajaxTransport(function(a){if(!a.crossDomain||d.support.cors){var c;return{send:function(e,f){var g=a.xhr(),h,i;a.username?g.open(a.type,a.url,a.async,a.username,a.password):g.open(a.type,a.url,a.async);if(a.xhrFields)for(i in a.xhrFields)g[i]=a.xhrFields[i];a.mimeType&&g.overrideMimeType&&g.overrideMimeType(a.mimeType),!a.crossDomain&&!e["X-Requested-With"]&&(e["X-Requested-With"]="XMLHttpRequest");try{for(i in e)g.setRequestHeader(i,e[i])}catch(j){}g.send(a.hasContent&&a.data||null),c=function(e,i){var j,k,l,m,n;try{if(c&&(i||g.readyState===4)){c=b,h&&(g.onreadystatechange=d.noop,delete bW[h]);if(i)g.readyState!==4&&g.abort();else{j=g.status,l=g.getAllResponseHeaders(),m={},n=g.responseXML,n&&n.documentElement&&(m.xml=n),m.text=g.responseText;try{k=g.statusText}catch(o){k=""}!j&&a.isLocal&&!a.crossDomain?j=m.text?200:404:j===1223&&(j=204)}}}catch(p){i||f(-1,p)}m&&f(j,k,m,l)},!a.async||g.readyState===4?c():(bW||(bW={},bY()),h=bV++,g.onreadystatechange=bW[h]=c)},abort:function(){c&&c(0,1)}}}});var b_={},ca=/^(?:toggle|show|hide)$/,cb=/^([+\-]=)?([\d+.\-]+)([a-z%]*)$/i,cc,cd=[["height","marginTop","marginBottom","paddingTop","paddingBottom"],["width","marginLeft","marginRight","paddingLeft","paddingRight"],["opacity"]];d.fn.extend({show:function(a,b,c){var e,f;if(a||a===0)return this.animate(ce("show",3),a,b,c);for(var g=0,h=this.length;g<h;g++)e=this[g],f=e.style.display,!d._data(e,"olddisplay")&&f==="none"&&(f=e.style.display=""),f===""&&d.css(e,"display")==="none"&&d._data(e,"olddisplay",cf(e.nodeName));for(g=0;g<h;g++){e=this[g],f=e.style.display;if(f===""||f==="none")e.style.display=d._data(e,"olddisplay")||""}return this},hide:function(a,b,c){if(a||a===0)return this.animate(ce("hide",3),a,b,c);for(var e=0,f=this.length;e<f;e++){var g=d.css(this[e],"display");g!=="none"&&!d._data(this[e],"olddisplay")&&d._data(this[e],"olddisplay",g)}for(e=0;e<f;e++)this[e].style.display="none";return this},_toggle:d.fn.toggle,toggle:function(a,b,c){var e=typeof a=="boolean";d.isFunction(a)&&d.isFunction(b)?this._toggle.apply(this,arguments):a==null||e?this.each(function(){var b=e?a:d(this).is(":hidden");d(this)[b?"show":"hide"]()}):this.animate(ce("toggle",3),a,b,c);return this},fadeTo:function(a,b,c,d){return this.filter(":hidden").css("opacity",0).show().end().animate({opacity:b},a,c,d)},animate:function(a,b,c,e){var f=d.speed(b,c,e);if(d.isEmptyObject(a))return this.each(f.complete);return this[f.queue===!1?"each":"queue"](function(){var b=d.extend({},f),c,e=this.nodeType===1,g=e&&d(this).is(":hidden"),h=this;for(c in a){var i=d.camelCase(c);c!==i&&(a[i]=a[c],delete a[c],c=i);if(a[c]==="hide"&&g||a[c]==="show"&&!g)return b.complete.call(this);if(e&&(c==="height"||c==="width")){b.overflow=[this.style.overflow,this.style.overflowX,this.style.overflowY];if(d.css(this,"display")==="inline"&&d.css(this,"float")==="none")if(!d.support.inlineBlockNeedsLayout)this.style.display="inline-block";else{var j=cf(this.nodeName);j==="inline"?this.style.display="inline-block":(this.style.display="inline",this.style.zoom=1)}}d.isArray(a[c])&&((b.specialEasing=b.specialEasing||{})[c]=a[c][1],a[c]=a[c][0])}b.overflow!=null&&(this.style.overflow="hidden"),b.curAnim=d.extend({},a),d.each(a,function(c,e){var f=new d.fx(h,b,c);if(ca.test(e))f[e==="toggle"?g?"show":"hide":e](a);else{var i=cb.exec(e),j=f.cur();if(i){var k=parseFloat(i[2]),l=i[3]||(d.cssNumber[c]?"":"px");l!=="px"&&(d.style(h,c,(k||1)+l),j=(k||1)/f.cur()*j,d.style(h,c,j+l)),i[1]&&(k=(i[1]==="-="?-1:1)*k+j),f.custom(j,k,l)}else f.custom(j,e,"")}});return!0})},stop:function(a,b){var c=d.timers;a&&this.queue([]),this.each(function(){for(var a=c.length-1;a>=0;a--)c[a].elem===this&&(b&&c[a](!0),c.splice(a,1))}),b||this.dequeue();return this}}),d.each({slideDown:ce("show",1),slideUp:ce("hide",1),slideToggle:ce("toggle",1),fadeIn:{opacity:"show"},fadeOut:{opacity:"hide"},fadeToggle:{opacity:"toggle"}},function(a,b){d.fn[a]=function(a,c,d){return this.animate(b,a,c,d)}}),d.extend({speed:function(a,b,c){var e=a&&typeof a=="object"?d.extend({},a):{complete:c||!c&&b||d.isFunction(a)&&a,duration:a,easing:c&&b||b&&!d.isFunction(b)&&b};e.duration=d.fx.off?0:typeof e.duration=="number"?e.duration:e.duration in d.fx.speeds?d.fx.speeds[e.duration]:d.fx.speeds._default,e.old=e.complete,e.complete=function(){e.queue!==!1&&d(this).dequeue(),d.isFunction(e.old)&&e.old.call(this)};return e},easing:{linear:function(a,b,c,d){return c+d*a},swing:function(a,b,c,d){return(-Math.cos(a*Math.PI)/2+.5)*d+c}},timers:[],fx:function(a,b,c){this.options=b,this.elem=a,this.prop=c,b.orig||(b.orig={})}}),d.fx.prototype={update:function(){this.options.step&&this.options.step.call(this.elem,this.now,this),(d.fx.step[this.prop]||d.fx.step._default)(this)},cur:function(){if(this.elem[this.prop]!=null&&(!this.elem.style||this.elem.style[this.prop]==null))return this.elem[this.prop];var a,b=d.css(this.elem,this.prop);return isNaN(a=parseFloat(b))?!b||b==="auto"?0:b:a},custom:function(a,b,c){function g(a){return e.step(a)}var e=this,f=d.fx;this.startTime=d.now(),this.start=a,this.end=b,this.unit=c||this.unit||(d.cssNumber[this.prop]?"":"px"),this.now=this.start,this.pos=this.state=0,g.elem=this.elem,g()&&d.timers.push(g)&&!cc&&(cc=setInterval(f.tick,f.interval))},show:function(){this.options.orig[this.prop]=d.style(this.elem,this.prop),this.options.show=!0,this.custom(this.prop==="width"||this.prop==="height"?1:0,this.cur()),d(this.elem).show()},hide:function(){this.options.orig[this.prop]=d.style(this.elem,this.prop),this.options.hide=!0,this.custom(this.cur(),0)},step:function(a){var b=d.now(),c=!0;if(a||b>=this.options.duration+this.startTime){this.now=this.end,this.pos=this.state=1,this.update(),this.options.curAnim[this.prop]=!0;for(var e in this.options.curAnim)this.options.curAnim[e]!==!0&&(c=!1);if(c){if(this.options.overflow!=null&&!d.support.shrinkWrapBlocks){var f=this.elem,g=this.options;d.each(["","X","Y"],function(a,b){f.style["overflow"+b]=g.overflow[a]})}this.options.hide&&d(this.elem).hide();if(this.options.hide||this.options.show)for(var h in this.options.curAnim)d.style(this.elem,h,this.options.orig[h]);this.options.complete.call(this.elem)}return!1}var i=b-this.startTime;this.state=i/this.options.duration;var j=this.options.specialEasing&&this.options.specialEasing[this.prop],k=this.options.easing||(d.easing.swing?"swing":"linear");this.pos=d.easing[j||k](this.state,i,0,1,this.options.duration),this.now=this.start+(this.end-this.start)*this.pos,this.update();return!0}},d.extend(d.fx,{tick:function(){var a=d.timers;for(var b=0;b<a.length;b++)a[b]()||a.splice(b--,1);a.length||d.fx.stop()},interval:13,stop:function(){clearInterval(cc),cc=null},speeds:{slow:600,fast:200,_default:400},step:{opacity:function(a){d.style(a.elem,"opacity",a.now)},_default:function(a){a.elem.style&&a.elem.style[a.prop]!=null?a.elem.style[a.prop]=(a.prop==="width"||a.prop==="height"?Math.max(0,a.now):a.now)+a.unit:a.elem[a.prop]=a.now}}}),d.expr&&d.expr.filters&&(d.expr.filters.animated=function(a){return d.grep(d.timers,function(b){return a===b.elem}).length});var cg=/^t(?:able|d|h)$/i,ch=/^(?:body|html)$/i;"getBoundingClientRect"in c.documentElement?d.fn.offset=function(a){var b=this[0],c;if(a)return this.each(function(b){d.offset.setOffset(this,a,b)});if(!b||!b.ownerDocument)return null;if(b===b.ownerDocument.body)return d.offset.bodyOffset(b);try{c=b.getBoundingClientRect()}catch(e){}var f=b.ownerDocument,g=f.documentElement;if(!c||!d.contains(g,b))return c?{top:c.top,left:c.left}:{top:0,left:0};var h=f.body,i=ci(f),j=g.clientTop||h.clientTop||0,k=g.clientLeft||h.clientLeft||0,l=i.pageYOffset||d.support.boxModel&&g.scrollTop||h.scrollTop,m=i.pageXOffset||d.support.boxModel&&g.scrollLeft||h.scrollLeft,n=c.top+l-j,o=c.left+m-k;return{top:n,left:o}}:d.fn.offset=function(a){var b=this[0];if(a)return this.each(function(b){d.offset.setOffset(this,a,b)});if(!b||!b.ownerDocument)return null;if(b===b.ownerDocument.body)return d.offset.bodyOffset(b);d.offset.initialize();var c,e=b.offsetParent,f=b,g=b.ownerDocument,h=g.documentElement,i=g.body,j=g.defaultView,k=j?j.getComputedStyle(b,null):b.currentStyle,l=b.offsetTop,m=b.offsetLeft;while((b=b.parentNode)&&b!==i&&b!==h){if(d.offset.supportsFixedPosition&&k.position==="fixed")break;c=j?j.getComputedStyle(b,null):b.currentStyle,l-=b.scrollTop,m-=b.scrollLeft,b===e&&(l+=b.offsetTop,m+=b.offsetLeft,d.offset.doesNotAddBorder&&(!d.offset.doesAddBorderForTableAndCells||!cg.test(b.nodeName))&&(l+=parseFloat(c.borderTopWidth)||0,m+=parseFloat(c.borderLeftWidth)||0),f=e,e=b.offsetParent),d.offset.subtractsBorderForOverflowNotVisible&&c.overflow!=="visible"&&(l+=parseFloat(c.borderTopWidth)||0,m+=parseFloat(c.borderLeftWidth)||0),k=c}if(k.position==="relative"||k.position==="static")l+=i.offsetTop,m+=i.offsetLeft;d.offset.supportsFixedPosition&&k.position==="fixed"&&(l+=Math.max(h.scrollTop,i.scrollTop),m+=Math.max(h.scrollLeft,i.scrollLeft));return{top:l,left:m}},d.offset={initialize:function(){var a=c.body,b=c.createElement("div"),e,f,g,h,i=parseFloat(d.css(a,"marginTop"))||0,j="<div style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;'><div></div></div><table style='position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;' cellpadding='0' cellspacing='0'><tr><td></td></tr></table>";d.extend(b.style,{position:"absolute",top:0,left:0,margin:0,border:0,width:"1px",height:"1px",visibility:"hidden"}),b.innerHTML=j,a.insertBefore(b,a.firstChild),e=b.firstChild,f=e.firstChild,h=e.nextSibling.firstChild.firstChild,this.doesNotAddBorder=f.offsetTop!==5,this.doesAddBorderForTableAndCells=h.offsetTop===5,f.style.position="fixed",f.style.top="20px",this.supportsFixedPosition=f.offsetTop===20||f.offsetTop===15,f.style.position=f.style.top="",e.style.overflow="hidden",e.style.position="relative",this.subtractsBorderForOverflowNotVisible=f.offsetTop===-5,this.doesNotIncludeMarginInBodyOffset=a.offsetTop!==i,a.removeChild(b),d.offset.initialize=d.noop},bodyOffset:function(a){var b=a.offsetTop,c=a.offsetLeft;d.offset.initialize(),d.offset.doesNotIncludeMarginInBodyOffset&&(b+=parseFloat(d.css(a,"marginTop"))||0,c+=parseFloat(d.css(a,"marginLeft"))||0);return{top:b,left:c}},setOffset:function(a,b,c){var e=d.css(a,"position");e==="static"&&(a.style.position="relative");var f=d(a),g=f.offset(),h=d.css(a,"top"),i=d.css(a,"left"),j=(e==="absolute"||e==="fixed")&&d.inArray("auto",[h,i])>-1,k={},l={},m,n;j&&(l=f.position()),m=j?l.top:parseInt(h,10)||0,n=j?l.left:parseInt(i,10)||0,d.isFunction(b)&&(b=b.call(a,c,g)),b.top!=null&&(k.top=b.top-g.top+m),b.left!=null&&(k.left=b.left-g.left+n),"using"in b?b.using.call(a,k):f.css(k)}},d.fn.extend({position:function(){if(!this[0])return null;var a=this[0],b=this.offsetParent(),c=this.offset(),e=ch.test(b[0].nodeName)?{top:0,left:0}:b.offset();c.top-=parseFloat(d.css(a,"marginTop"))||0,c.left-=parseFloat(d.css(a,"marginLeft"))||0,e.top+=parseFloat(d.css(b[0],"borderTopWidth"))||0,e.left+=parseFloat(d.css(b[0],"borderLeftWidth"))||0;return{top:c.top-e.top,left:c.left-e.left}},offsetParent:function(){return this.map(function(){var a=this.offsetParent||c.body;while(a&&!ch.test(a.nodeName)&&d.css(a,"position")==="static")a=a.offsetParent;return a})}}),d.each(["Left","Top"],function(a,c){var e="scroll"+c;d.fn[e]=function(c){var f=this[0],g;if(!f)return null;if(c!==b)return this.each(function(){g=ci(this),g?g.scrollTo(a?d(g).scrollLeft():c,a?c:d(g).scrollTop()):this[e]=c});g=ci(f);return g?"pageXOffset"in g?g[a?"pageYOffset":"pageXOffset"]:d.support.boxModel&&g.document.documentElement[e]||g.document.body[e]:f[e]}}),d.each(["Height","Width"],function(a,c){var e=c.toLowerCase();d.fn["inner"+c]=function(){return this[0]?parseFloat(d.css(this[0],e,"padding")):null},d.fn["outer"+c]=function(a){return this[0]?parseFloat(d.css(this[0],e,a?"margin":"border")):null},d.fn[e]=function(a){var f=this[0];if(!f)return a==null?null:this;if(d.isFunction(a))return this.each(function(b){var c=d(this);c[e](a.call(this,b,c[e]()))});if(d.isWindow(f)){var g=f.document.documentElement["client"+c];return f.document.compatMode==="CSS1Compat"&&g||f.document.body["client"+c]||g}if(f.nodeType===9)return Math.max(f.documentElement["client"+c],f.body["scroll"+c],f.documentElement["scroll"+c],f.body["offset"+c],f.documentElement["offset"+c]);if(a===b){var h=d.css(f,e),i=parseFloat(h);return d.isNaN(i)?h:i}return this.css(e,typeof a=="string"?a:a+"px")}}),a.jQuery=a.$=d})(window)
jQuery.noConflict();
jQuery.os={};var jQueryOSplatform=navigator.platform.toLowerCase();jQuery.os.windows=(jQueryOSplatform.indexOf("win")!=-1);jQuery.os.mac=(jQueryOSplatform.indexOf("mac")!=-1);jQuery.os.linux=(jQueryOSplatform.indexOf("linux")!=-1);
/**
 * Atlassian custom download containing:
 * CORE - Core, Widget, Mouse
 * INTERACTIONS - Draggable, Sortable
 * Load jquery-ui-other for droppable and other resources.
 * This load profile will be updated to something more logical in a future version.
 */
/*!
 * jQuery UI 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI
 */
(function(c,j){function k(a){return!c(a).parents().andSelf().filter(function(){return c.curCSS(this,"visibility")==="hidden"||c.expr.filters.hidden(this)}).length}c.ui=c.ui||{};if(!c.ui.version){c.extend(c.ui,{version:"1.8.11",keyCode:{ALT:18,BACKSPACE:8,CAPS_LOCK:20,COMMA:188,COMMAND:91,COMMAND_LEFT:91,COMMAND_RIGHT:93,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,MENU:93,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,
NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38,WINDOWS:91}});c.fn.extend({_focus:c.fn.focus,focus:function(a,b){return typeof a==="number"?this.each(function(){var d=this;setTimeout(function(){c(d).focus();b&&b.call(d)},a)}):this._focus.apply(this,arguments)},scrollParent:function(){var a;a=c.browser.msie&&/(static|relative)/.test(this.css("position"))||/absolute/.test(this.css("position"))?this.parents().filter(function(){return/(relative|absolute|fixed)/.test(c.curCSS(this,
"position",1))&&/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0):this.parents().filter(function(){return/(auto|scroll)/.test(c.curCSS(this,"overflow",1)+c.curCSS(this,"overflow-y",1)+c.curCSS(this,"overflow-x",1))}).eq(0);return/fixed/.test(this.css("position"))||!a.length?c(document):a},zIndex:function(a){if(a!==j)return this.css("zIndex",a);if(this.length){a=c(this[0]);for(var b;a.length&&a[0]!==document;){b=a.css("position");
if(b==="absolute"||b==="relative"||b==="fixed"){b=parseInt(a.css("zIndex"),10);if(!isNaN(b)&&b!==0)return b}a=a.parent()}}return 0},disableSelection:function(){return this.bind((c.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",function(a){a.preventDefault()})},enableSelection:function(){return this.unbind(".ui-disableSelection")}});c.each(["Width","Height"],function(a,b){function d(f,g,l,m){c.each(e,function(){g-=parseFloat(c.curCSS(f,"padding"+this,true))||0;if(l)g-=parseFloat(c.curCSS(f,
"border"+this+"Width",true))||0;if(m)g-=parseFloat(c.curCSS(f,"margin"+this,true))||0});return g}var e=b==="Width"?["Left","Right"]:["Top","Bottom"],h=b.toLowerCase(),i={innerWidth:c.fn.innerWidth,innerHeight:c.fn.innerHeight,outerWidth:c.fn.outerWidth,outerHeight:c.fn.outerHeight};c.fn["inner"+b]=function(f){if(f===j)return i["inner"+b].call(this);return this.each(function(){c(this).css(h,d(this,f)+"px")})};c.fn["outer"+b]=function(f,g){if(typeof f!=="number")return i["outer"+b].call(this,f);return this.each(function(){c(this).css(h,
d(this,f,true,g)+"px")})}});c.extend(c.expr[":"],{data:function(a,b,d){return!!c.data(a,d[3])},focusable:function(a){var b=a.nodeName.toLowerCase(),d=c.attr(a,"tabindex");if("area"===b){b=a.parentNode;d=b.name;if(!a.href||!d||b.nodeName.toLowerCase()!=="map")return false;a=c("img[usemap=#"+d+"]")[0];return!!a&&k(a)}return(/input|select|textarea|button|object/.test(b)?!a.disabled:"a"==b?a.href||!isNaN(d):!isNaN(d))&&k(a)},tabbable:function(a){var b=c.attr(a,"tabindex");return(isNaN(b)||b>=0)&&c(a).is(":focusable")}});
c(function(){var a=document.body,b=a.appendChild(b=document.createElement("div"));c.extend(b.style,{minHeight:"100px",height:"auto",padding:0,borderWidth:0});c.support.minHeight=b.offsetHeight===100;c.support.selectstart="onselectstart"in b;a.removeChild(b).style.display="none"});c.extend(c.ui,{plugin:{add:function(a,b,d){a=c.ui[a].prototype;for(var e in d){a.plugins[e]=a.plugins[e]||[];a.plugins[e].push([b,d[e]])}},call:function(a,b,d){if((b=a.plugins[b])&&a.element[0].parentNode)for(var e=0;e<b.length;e++)a.options[b[e][0]]&&
b[e][1].apply(a.element,d)}},contains:function(a,b){return document.compareDocumentPosition?a.compareDocumentPosition(b)&16:a!==b&&a.contains(b)},hasScroll:function(a,b){if(c(a).css("overflow")==="hidden")return false;b=b&&b==="left"?"scrollLeft":"scrollTop";var d=false;if(a[b]>0)return true;a[b]=1;d=a[b]>0;a[b]=0;return d},isOverAxis:function(a,b,d){return a>b&&a<b+d},isOver:function(a,b,d,e,h,i){return c.ui.isOverAxis(a,d,h)&&c.ui.isOverAxis(b,e,i)}})}})(jQuery);
;/*!
 * jQuery UI Widget 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Widget
 */
(function(b,j){if(b.cleanData){var k=b.cleanData;b.cleanData=function(a){for(var c=0,d;(d=a[c])!=null;c++)b(d).triggerHandler("remove");k(a)}}else{var l=b.fn.remove;b.fn.remove=function(a,c){return this.each(function(){if(!c)if(!a||b.filter(a,[this]).length)b("*",this).add([this]).each(function(){b(this).triggerHandler("remove")});return l.call(b(this),a,c)})}}b.widget=function(a,c,d){var e=a.split(".")[0],f;a=a.split(".")[1];f=e+"-"+a;if(!d){d=c;c=b.Widget}b.expr[":"][f]=function(h){return!!b.data(h,
a)};b[e]=b[e]||{};b[e][a]=function(h,g){arguments.length&&this._createWidget(h,g)};c=new c;c.options=b.extend(true,{},c.options);b[e][a].prototype=b.extend(true,c,{namespace:e,widgetName:a,widgetEventPrefix:b[e][a].prototype.widgetEventPrefix||a,widgetBaseClass:f},d);b.widget.bridge(a,b[e][a])};b.widget.bridge=function(a,c){b.fn[a]=function(d){var e=typeof d==="string",f=Array.prototype.slice.call(arguments,1),h=this;d=!e&&f.length?b.extend.apply(null,[true,d].concat(f)):d;if(e&&d.charAt(0)==="_")return h;
e?this.each(function(){var g=b.data(this,a),i=g&&b.isFunction(g[d])?g[d].apply(g,f):g;if(i!==g&&i!==j){h=i;return false}}):this.each(function(){var g=b.data(this,a);g?g.option(d||{})._init():b.data(this,a,new c(d,this))});return h}};b.Widget=function(a,c){arguments.length&&this._createWidget(a,c)};b.Widget.prototype={widgetName:"widget",widgetEventPrefix:"",options:{disabled:false},_createWidget:function(a,c){b.data(c,this.widgetName,this);this.element=b(c);this.options=b.extend(true,{},this.options,
this._getCreateOptions(),a);var d=this;this.element.bind("remove."+this.widgetName,function(){d.destroy()});this._create();this._trigger("create");this._init()},_getCreateOptions:function(){return b.metadata&&b.metadata.get(this.element[0])[this.widgetName]},_create:function(){},_init:function(){},destroy:function(){this.element.unbind("."+this.widgetName).removeData(this.widgetName);this.widget().unbind("."+this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass+"-disabled ui-state-disabled")},
widget:function(){return this.element},option:function(a,c){var d=a;if(arguments.length===0)return b.extend({},this.options);if(typeof a==="string"){if(c===j)return this.options[a];d={};d[a]=c}this._setOptions(d);return this},_setOptions:function(a){var c=this;b.each(a,function(d,e){c._setOption(d,e)});return this},_setOption:function(a,c){this.options[a]=c;if(a==="disabled")this.widget()[c?"addClass":"removeClass"](this.widgetBaseClass+"-disabled ui-state-disabled").attr("aria-disabled",c);return this},
enable:function(){return this._setOption("disabled",false)},disable:function(){return this._setOption("disabled",true)},_trigger:function(a,c,d){var e=this.options[a];c=b.Event(c);c.type=(a===this.widgetEventPrefix?a:this.widgetEventPrefix+a).toLowerCase();d=d||{};if(c.originalEvent){a=b.event.props.length;for(var f;a;){f=b.event.props[--a];c[f]=c.originalEvent[f]}}this.element.trigger(c,d);return!(b.isFunction(e)&&e.call(this.element[0],c,d)===false||c.isDefaultPrevented())}}})(jQuery);
;/*!
 * jQuery UI Mouse 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Mouse
 *
 * Depends:
 *	jquery.ui.widget.js
 */
(function(b){b.widget("ui.mouse",{options:{cancel:":input,option",distance:1,delay:0},_mouseInit:function(){var a=this;this.element.bind("mousedown."+this.widgetName,function(c){return a._mouseDown(c)}).bind("click."+this.widgetName,function(c){if(true===b.data(c.target,a.widgetName+".preventClickEvent")){b.removeData(c.target,a.widgetName+".preventClickEvent");c.stopImmediatePropagation();return false}});this.started=false},_mouseDestroy:function(){this.element.unbind("."+this.widgetName)},_mouseDown:function(a){a.originalEvent=
a.originalEvent||{};if(!a.originalEvent.mouseHandled){this._mouseStarted&&this._mouseUp(a);this._mouseDownEvent=a;var c=this,e=a.which==1,f=typeof this.options.cancel=="string"?b(a.target).parents().add(a.target).filter(this.options.cancel).length:false;if(!e||f||!this._mouseCapture(a))return true;this.mouseDelayMet=!this.options.delay;if(!this.mouseDelayMet)this._mouseDelayTimer=setTimeout(function(){c.mouseDelayMet=true},this.options.delay);if(this._mouseDistanceMet(a)&&this._mouseDelayMet(a)){this._mouseStarted=
this._mouseStart(a)!==false;if(!this._mouseStarted){a.preventDefault();return true}}true===b.data(a.target,this.widgetName+".preventClickEvent")&&b.removeData(a.target,this.widgetName+".preventClickEvent");this._mouseMoveDelegate=function(d){return c._mouseMove(d)};this._mouseUpDelegate=function(d){return c._mouseUp(d)};b(document).bind("mousemove."+this.widgetName,this._mouseMoveDelegate).bind("mouseup."+this.widgetName,this._mouseUpDelegate);a.preventDefault();return a.originalEvent.mouseHandled=
true}},_mouseMove:function(a){if(b.browser.msie&&!(document.documentMode>=9)&&!a.button)return this._mouseUp(a);if(this._mouseStarted){this._mouseDrag(a);return a.preventDefault()}if(this._mouseDistanceMet(a)&&this._mouseDelayMet(a))(this._mouseStarted=this._mouseStart(this._mouseDownEvent,a)!==false)?this._mouseDrag(a):this._mouseUp(a);return!this._mouseStarted},_mouseUp:function(a){b(document).unbind("mousemove."+this.widgetName,this._mouseMoveDelegate).unbind("mouseup."+this.widgetName,this._mouseUpDelegate);
if(this._mouseStarted){this._mouseStarted=false;a.target==this._mouseDownEvent.target&&b.data(a.target,this.widgetName+".preventClickEvent",true);this._mouseStop(a)}return false},_mouseDistanceMet:function(a){return Math.max(Math.abs(this._mouseDownEvent.pageX-a.pageX),Math.abs(this._mouseDownEvent.pageY-a.pageY))>=this.options.distance},_mouseDelayMet:function(){return this.mouseDelayMet},_mouseStart:function(){},_mouseDrag:function(){},_mouseStop:function(){},_mouseCapture:function(){return true}})})(jQuery);
;/*
 * jQuery UI Draggable 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Draggables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function(d){d.widget("ui.draggable",d.ui.mouse,{widgetEventPrefix:"drag",options:{addClasses:true,appendTo:"parent",axis:false,connectToSortable:false,containment:false,cursor:"auto",cursorAt:false,grid:false,handle:false,helper:"original",iframeFix:false,opacity:false,refreshPositions:false,revert:false,revertDuration:500,scope:"default",scroll:true,scrollSensitivity:20,scrollSpeed:20,snap:false,snapMode:"both",snapTolerance:20,stack:false,zIndex:false},_create:function(){if(this.options.helper==
"original"&&!/^(?:r|a|f)/.test(this.element.css("position")))this.element[0].style.position="relative";this.options.addClasses&&this.element.addClass("ui-draggable");this.options.disabled&&this.element.addClass("ui-draggable-disabled");this._mouseInit()},destroy:function(){if(this.element.data("draggable")){this.element.removeData("draggable").unbind(".draggable").removeClass("ui-draggable ui-draggable-dragging ui-draggable-disabled");this._mouseDestroy();return this}},_mouseCapture:function(a){var b=
this.options;if(this.helper||b.disabled||d(a.target).is(".ui-resizable-handle"))return false;this.handle=this._getHandle(a);if(!this.handle)return false;return true},_mouseStart:function(a){var b=this.options;this.helper=this._createHelper(a);this._cacheHelperProportions();if(d.ui.ddmanager)d.ui.ddmanager.current=this;this._cacheMargins();this.cssPosition=this.helper.css("position");this.scrollParent=this.helper.scrollParent();this.offset=this.positionAbs=this.element.offset();this.offset={top:this.offset.top-
this.margins.top,left:this.offset.left-this.margins.left};d.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});this.originalPosition=this.position=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;b.cursorAt&&this._adjustOffsetFromHelper(b.cursorAt);b.containment&&this._setContainment();if(this._trigger("start",a)===false){this._clear();return false}this._cacheHelperProportions();
d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,a);this.helper.addClass("ui-draggable-dragging");this._mouseDrag(a,true);return true},_mouseDrag:function(a,b){this.position=this._generatePosition(a);this.positionAbs=this._convertPositionTo("absolute");if(!b){b=this._uiHash();if(this._trigger("drag",a,b)===false){this._mouseUp({});return false}this.position=b.position}if(!this.options.axis||this.options.axis!="y")this.helper[0].style.left=this.position.left+"px";if(!this.options.axis||
this.options.axis!="x")this.helper[0].style.top=this.position.top+"px";d.ui.ddmanager&&d.ui.ddmanager.drag(this,a);return false},_mouseStop:function(a){var b=false;if(d.ui.ddmanager&&!this.options.dropBehaviour)b=d.ui.ddmanager.drop(this,a);if(this.dropped){b=this.dropped;this.dropped=false}if((!this.element[0]||!this.element[0].parentNode)&&this.options.helper=="original")return false;if(this.options.revert=="invalid"&&!b||this.options.revert=="valid"&&b||this.options.revert===true||d.isFunction(this.options.revert)&&
this.options.revert.call(this.element,b)){var c=this;d(this.helper).animate(this.originalPosition,parseInt(this.options.revertDuration,10),function(){c._trigger("stop",a)!==false&&c._clear()})}else this._trigger("stop",a)!==false&&this._clear();return false},cancel:function(){this.helper.is(".ui-draggable-dragging")?this._mouseUp({}):this._clear();return this},_getHandle:function(a){var b=!this.options.handle||!d(this.options.handle,this.element).length?true:false;d(this.options.handle,this.element).find("*").andSelf().each(function(){if(this==
a.target)b=true});return b},_createHelper:function(a){var b=this.options;a=d.isFunction(b.helper)?d(b.helper.apply(this.element[0],[a])):b.helper=="clone"?this.element.clone():this.element;a.parents("body").length||a.appendTo(b.appendTo=="parent"?this.element[0].parentNode:b.appendTo);a[0]!=this.element[0]&&!/(fixed|absolute)/.test(a.css("position"))&&a.css("position","absolute");return a},_adjustOffsetFromHelper:function(a){if(typeof a=="string")a=a.split(" ");if(d.isArray(a))a={left:+a[0],top:+a[1]||
0};if("left"in a)this.offset.click.left=a.left+this.margins.left;if("right"in a)this.offset.click.left=this.helperProportions.width-a.right+this.margins.left;if("top"in a)this.offset.click.top=a.top+this.margins.top;if("bottom"in a)this.offset.click.top=this.helperProportions.height-a.bottom+this.margins.top},_getParentOffset:function(){this.offsetParent=this.helper.offsetParent();var a=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],
this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();a.top+=this.scrollParent.scrollTop()}if(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&d.browser.msie)a={top:0,left:0};return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=this.element.position();return{top:a.top-
(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else return{top:0,left:0}},_cacheMargins:function(){this.margins={left:parseInt(this.element.css("marginLeft"),10)||0,top:parseInt(this.element.css("marginTop"),10)||0,right:parseInt(this.element.css("marginRight"),10)||0,bottom:parseInt(this.element.css("marginBottom"),10)||0}},_cacheHelperProportions:function(){this.helperProportions={width:this.helper.outerWidth(),
height:this.helper.outerHeight()}},_setContainment:function(){var a=this.options;if(a.containment=="parent")a.containment=this.helper[0].parentNode;if(a.containment=="document"||a.containment=="window")this.containment=[(a.containment=="document"?0:d(window).scrollLeft())-this.offset.relative.left-this.offset.parent.left,(a.containment=="document"?0:d(window).scrollTop())-this.offset.relative.top-this.offset.parent.top,(a.containment=="document"?0:d(window).scrollLeft())+d(a.containment=="document"?
document:window).width()-this.helperProportions.width-this.margins.left,(a.containment=="document"?0:d(window).scrollTop())+(d(a.containment=="document"?document:window).height()||document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top];if(!/^(document|window|parent)$/.test(a.containment)&&a.containment.constructor!=Array){var b=d(a.containment)[0];if(b){a=d(a.containment).offset();var c=d(b).css("overflow")!="hidden";this.containment=[a.left+(parseInt(d(b).css("borderLeftWidth"),
10)||0)+(parseInt(d(b).css("paddingLeft"),10)||0),a.top+(parseInt(d(b).css("borderTopWidth"),10)||0)+(parseInt(d(b).css("paddingTop"),10)||0),a.left+(c?Math.max(b.scrollWidth,b.offsetWidth):b.offsetWidth)-(parseInt(d(b).css("borderLeftWidth"),10)||0)-(parseInt(d(b).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left-this.margins.right,a.top+(c?Math.max(b.scrollHeight,b.offsetHeight):b.offsetHeight)-(parseInt(d(b).css("borderTopWidth"),10)||0)-(parseInt(d(b).css("paddingBottom"),
10)||0)-this.helperProportions.height-this.margins.top-this.margins.bottom]}}else if(a.containment.constructor==Array)this.containment=a.containment},_convertPositionTo:function(a,b){if(!b)b=this.position;a=a=="absolute"?1:-1;var c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName);return{top:b.top+this.offset.relative.top*a+this.offset.parent.top*a-(d.browser.safari&&
d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop())*a),left:b.left+this.offset.relative.left*a+this.offset.parent.left*a-(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():f?0:c.scrollLeft())*a)}},_generatePosition:function(a){var b=this.options,c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],
this.offsetParent[0]))?this.offsetParent:this.scrollParent,f=/(html|body)/i.test(c[0].tagName),e=a.pageX,g=a.pageY;if(this.originalPosition){if(this.containment){if(a.pageX-this.offset.click.left<this.containment[0])e=this.containment[0]+this.offset.click.left;if(a.pageY-this.offset.click.top<this.containment[1])g=this.containment[1]+this.offset.click.top;if(a.pageX-this.offset.click.left>this.containment[2])e=this.containment[2]+this.offset.click.left;if(a.pageY-this.offset.click.top>this.containment[3])g=
this.containment[3]+this.offset.click.top}if(b.grid){g=this.originalPageY+Math.round((g-this.originalPageY)/b.grid[1])*b.grid[1];g=this.containment?!(g-this.offset.click.top<this.containment[1]||g-this.offset.click.top>this.containment[3])?g:!(g-this.offset.click.top<this.containment[1])?g-b.grid[1]:g+b.grid[1]:g;e=this.originalPageX+Math.round((e-this.originalPageX)/b.grid[0])*b.grid[0];e=this.containment?!(e-this.offset.click.left<this.containment[0]||e-this.offset.click.left>this.containment[2])?
e:!(e-this.offset.click.left<this.containment[0])?e-b.grid[0]:e+b.grid[0]:e}}return{top:g-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollTop():f?0:c.scrollTop()),left:e-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(d.browser.safari&&d.browser.version<526&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():
f?0:c.scrollLeft())}},_clear:function(){this.helper.removeClass("ui-draggable-dragging");this.helper[0]!=this.element[0]&&!this.cancelHelperRemoval&&this.helper.remove();this.helper=null;this.cancelHelperRemoval=false},_trigger:function(a,b,c){c=c||this._uiHash();d.ui.plugin.call(this,a,[b,c]);if(a=="drag")this.positionAbs=this._convertPositionTo("absolute");return d.Widget.prototype._trigger.call(this,a,b,c)},plugins:{},_uiHash:function(){return{helper:this.helper,position:this.position,originalPosition:this.originalPosition,
offset:this.positionAbs}}});d.extend(d.ui.draggable,{version:"1.8.11"});d.ui.plugin.add("draggable","connectToSortable",{start:function(a,b){var c=d(this).data("draggable"),f=c.options,e=d.extend({},b,{item:c.element});c.sortables=[];d(f.connectToSortable).each(function(){var g=d.data(this,"sortable");if(g&&!g.options.disabled){c.sortables.push({instance:g,shouldRevert:g.options.revert});g.refreshPositions();g._trigger("activate",a,e)}})},stop:function(a,b){var c=d(this).data("draggable"),f=d.extend({},
b,{item:c.element});d.each(c.sortables,function(){if(this.instance.isOver){this.instance.isOver=0;c.cancelHelperRemoval=true;this.instance.cancelHelperRemoval=false;if(this.shouldRevert)this.instance.options.revert=true;this.instance._mouseStop(a);this.instance.options.helper=this.instance.options._helper;c.options.helper=="original"&&this.instance.currentItem.css({top:"auto",left:"auto"})}else{this.instance.cancelHelperRemoval=false;this.instance._trigger("deactivate",a,f)}})},drag:function(a,b){var c=
d(this).data("draggable"),f=this;d.each(c.sortables,function(){this.instance.positionAbs=c.positionAbs;this.instance.helperProportions=c.helperProportions;this.instance.offset.click=c.offset.click;if(this.instance._intersectsWith(this.instance.containerCache)){if(!this.instance.isOver){this.instance.isOver=1;this.instance.currentItem=d(f).clone().appendTo(this.instance.element).data("sortable-item",true);this.instance.options._helper=this.instance.options.helper;this.instance.options.helper=function(){return b.helper[0]};
a.target=this.instance.currentItem[0];this.instance._mouseCapture(a,true);this.instance._mouseStart(a,true,true);this.instance.offset.click.top=c.offset.click.top;this.instance.offset.click.left=c.offset.click.left;this.instance.offset.parent.left-=c.offset.parent.left-this.instance.offset.parent.left;this.instance.offset.parent.top-=c.offset.parent.top-this.instance.offset.parent.top;c._trigger("toSortable",a);c.dropped=this.instance.element;c.currentItem=c.element;this.instance.fromOutside=c}this.instance.currentItem&&
this.instance._mouseDrag(a)}else if(this.instance.isOver){this.instance.isOver=0;this.instance.cancelHelperRemoval=true;this.instance.options.revert=false;this.instance._trigger("out",a,this.instance._uiHash(this.instance));this.instance._mouseStop(a,true);this.instance.options.helper=this.instance.options._helper;this.instance.currentItem.remove();this.instance.placeholder&&this.instance.placeholder.remove();c._trigger("fromSortable",a);c.dropped=false}})}});d.ui.plugin.add("draggable","cursor",
{start:function(){var a=d("body"),b=d(this).data("draggable").options;if(a.css("cursor"))b._cursor=a.css("cursor");a.css("cursor",b.cursor)},stop:function(){var a=d(this).data("draggable").options;a._cursor&&d("body").css("cursor",a._cursor)}});d.ui.plugin.add("draggable","iframeFix",{start:function(){var a=d(this).data("draggable").options;d(a.iframeFix===true?"iframe":a.iframeFix).each(function(){d('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>').css({width:this.offsetWidth+
"px",height:this.offsetHeight+"px",position:"absolute",opacity:"0.001",zIndex:1E3}).css(d(this).offset()).appendTo("body")})},stop:function(){d("div.ui-draggable-iframeFix").each(function(){this.parentNode.removeChild(this)})}});d.ui.plugin.add("draggable","opacity",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("opacity"))b._opacity=a.css("opacity");a.css("opacity",b.opacity)},stop:function(a,b){a=d(this).data("draggable").options;a._opacity&&d(b.helper).css("opacity",
a._opacity)}});d.ui.plugin.add("draggable","scroll",{start:function(){var a=d(this).data("draggable");if(a.scrollParent[0]!=document&&a.scrollParent[0].tagName!="HTML")a.overflowOffset=a.scrollParent.offset()},drag:function(a){var b=d(this).data("draggable"),c=b.options,f=false;if(b.scrollParent[0]!=document&&b.scrollParent[0].tagName!="HTML"){if(!c.axis||c.axis!="x")if(b.overflowOffset.top+b.scrollParent[0].offsetHeight-a.pageY<c.scrollSensitivity)b.scrollParent[0].scrollTop=f=b.scrollParent[0].scrollTop+
c.scrollSpeed;else if(a.pageY-b.overflowOffset.top<c.scrollSensitivity)b.scrollParent[0].scrollTop=f=b.scrollParent[0].scrollTop-c.scrollSpeed;if(!c.axis||c.axis!="y")if(b.overflowOffset.left+b.scrollParent[0].offsetWidth-a.pageX<c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft+c.scrollSpeed;else if(a.pageX-b.overflowOffset.left<c.scrollSensitivity)b.scrollParent[0].scrollLeft=f=b.scrollParent[0].scrollLeft-c.scrollSpeed}else{if(!c.axis||c.axis!="x")if(a.pageY-d(document).scrollTop()<
c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()-c.scrollSpeed);else if(d(window).height()-(a.pageY-d(document).scrollTop())<c.scrollSensitivity)f=d(document).scrollTop(d(document).scrollTop()+c.scrollSpeed);if(!c.axis||c.axis!="y")if(a.pageX-d(document).scrollLeft()<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()-c.scrollSpeed);else if(d(window).width()-(a.pageX-d(document).scrollLeft())<c.scrollSensitivity)f=d(document).scrollLeft(d(document).scrollLeft()+
c.scrollSpeed)}f!==false&&d.ui.ddmanager&&!c.dropBehaviour&&d.ui.ddmanager.prepareOffsets(b,a)}});d.ui.plugin.add("draggable","snap",{start:function(){var a=d(this).data("draggable"),b=a.options;a.snapElements=[];d(b.snap.constructor!=String?b.snap.items||":data(draggable)":b.snap).each(function(){var c=d(this),f=c.offset();this!=a.element[0]&&a.snapElements.push({item:this,width:c.outerWidth(),height:c.outerHeight(),top:f.top,left:f.left})})},drag:function(a,b){for(var c=d(this).data("draggable"),
f=c.options,e=f.snapTolerance,g=b.offset.left,n=g+c.helperProportions.width,m=b.offset.top,o=m+c.helperProportions.height,h=c.snapElements.length-1;h>=0;h--){var i=c.snapElements[h].left,k=i+c.snapElements[h].width,j=c.snapElements[h].top,l=j+c.snapElements[h].height;if(i-e<g&&g<k+e&&j-e<m&&m<l+e||i-e<g&&g<k+e&&j-e<o&&o<l+e||i-e<n&&n<k+e&&j-e<m&&m<l+e||i-e<n&&n<k+e&&j-e<o&&o<l+e){if(f.snapMode!="inner"){var p=Math.abs(j-o)<=e,q=Math.abs(l-m)<=e,r=Math.abs(i-n)<=e,s=Math.abs(k-g)<=e;if(p)b.position.top=
c._convertPositionTo("relative",{top:j-c.helperProportions.height,left:0}).top-c.margins.top;if(q)b.position.top=c._convertPositionTo("relative",{top:l,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:i-c.helperProportions.width}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:k}).left-c.margins.left}var t=p||q||r||s;if(f.snapMode!="outer"){p=Math.abs(j-m)<=e;q=Math.abs(l-o)<=e;r=Math.abs(i-g)<=e;s=Math.abs(k-n)<=e;if(p)b.position.top=
c._convertPositionTo("relative",{top:j,left:0}).top-c.margins.top;if(q)b.position.top=c._convertPositionTo("relative",{top:l-c.helperProportions.height,left:0}).top-c.margins.top;if(r)b.position.left=c._convertPositionTo("relative",{top:0,left:i}).left-c.margins.left;if(s)b.position.left=c._convertPositionTo("relative",{top:0,left:k-c.helperProportions.width}).left-c.margins.left}if(!c.snapElements[h].snapping&&(p||q||r||s||t))c.options.snap.snap&&c.options.snap.snap.call(c.element,a,d.extend(c._uiHash(),
{snapItem:c.snapElements[h].item}));c.snapElements[h].snapping=p||q||r||s||t}else{c.snapElements[h].snapping&&c.options.snap.release&&c.options.snap.release.call(c.element,a,d.extend(c._uiHash(),{snapItem:c.snapElements[h].item}));c.snapElements[h].snapping=false}}}});d.ui.plugin.add("draggable","stack",{start:function(){var a=d(this).data("draggable").options;a=d.makeArray(d(a.stack)).sort(function(c,f){return(parseInt(d(c).css("zIndex"),10)||0)-(parseInt(d(f).css("zIndex"),10)||0)});if(a.length){var b=
parseInt(a[0].style.zIndex)||0;d(a).each(function(c){this.style.zIndex=b+c});this[0].style.zIndex=b+a.length}}});d.ui.plugin.add("draggable","zIndex",{start:function(a,b){a=d(b.helper);b=d(this).data("draggable").options;if(a.css("zIndex"))b._zIndex=a.css("zIndex");a.css("zIndex",b.zIndex)},stop:function(a,b){a=d(this).data("draggable").options;a._zIndex&&d(b.helper).css("zIndex",a._zIndex)}})})(jQuery);
;/*
 * jQuery UI Sortable 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Sortables
 *
 * Depends:
 *	jquery.ui.core.js
 *	jquery.ui.mouse.js
 *	jquery.ui.widget.js
 */
(function(d){d.widget("ui.sortable",d.ui.mouse,{widgetEventPrefix:"sort",options:{appendTo:"parent",axis:false,connectWith:false,containment:false,cursor:"auto",cursorAt:false,dropOnEmpty:true,forcePlaceholderSize:false,forceHelperSize:false,grid:false,handle:false,helper:"original",items:"> *",opacity:false,placeholder:false,revert:false,scroll:true,scrollSensitivity:20,scrollSpeed:20,scope:"default",tolerance:"intersect",zIndex:1E3},_create:function(){this.containerCache={};this.element.addClass("ui-sortable");
this.refresh();this.floating=this.items.length?/left|right/.test(this.items[0].item.css("float"))||/inline|table-cell/.test(this.items[0].item.css("display")):false;this.offset=this.element.offset();this._mouseInit()},destroy:function(){this.element.removeClass("ui-sortable ui-sortable-disabled").removeData("sortable").unbind(".sortable");this._mouseDestroy();for(var a=this.items.length-1;a>=0;a--)this.items[a].item.removeData("sortable-item");return this},_setOption:function(a,b){if(a==="disabled"){this.options[a]=
b;this.widget()[b?"addClass":"removeClass"]("ui-sortable-disabled")}else d.Widget.prototype._setOption.apply(this,arguments)},_mouseCapture:function(a,b){if(this.reverting)return false;if(this.options.disabled||this.options.type=="static")return false;this._refreshItems(a);var c=null,e=this;d(a.target).parents().each(function(){if(d.data(this,"sortable-item")==e){c=d(this);return false}});if(d.data(a.target,"sortable-item")==e)c=d(a.target);if(!c)return false;if(this.options.handle&&!b){var f=false;
d(this.options.handle,c).find("*").andSelf().each(function(){if(this==a.target)f=true});if(!f)return false}this.currentItem=c;this._removeCurrentsFromItems();return true},_mouseStart:function(a,b,c){b=this.options;var e=this;this.currentContainer=this;this.refreshPositions();this.helper=this._createHelper(a);this._cacheHelperProportions();this._cacheMargins();this.scrollParent=this.helper.scrollParent();this.offset=this.currentItem.offset();this.offset={top:this.offset.top-this.margins.top,left:this.offset.left-
this.margins.left};this.helper.css("position","absolute");this.cssPosition=this.helper.css("position");d.extend(this.offset,{click:{left:a.pageX-this.offset.left,top:a.pageY-this.offset.top},parent:this._getParentOffset(),relative:this._getRelativeOffset()});this.originalPosition=this._generatePosition(a);this.originalPageX=a.pageX;this.originalPageY=a.pageY;b.cursorAt&&this._adjustOffsetFromHelper(b.cursorAt);this.domPosition={prev:this.currentItem.prev()[0],parent:this.currentItem.parent()[0]};
this.helper[0]!=this.currentItem[0]&&this.currentItem.hide();this._createPlaceholder();b.containment&&this._setContainment();if(b.cursor){if(d("body").css("cursor"))this._storedCursor=d("body").css("cursor");d("body").css("cursor",b.cursor)}if(b.opacity){if(this.helper.css("opacity"))this._storedOpacity=this.helper.css("opacity");this.helper.css("opacity",b.opacity)}if(b.zIndex){if(this.helper.css("zIndex"))this._storedZIndex=this.helper.css("zIndex");this.helper.css("zIndex",b.zIndex)}if(this.scrollParent[0]!=
document&&this.scrollParent[0].tagName!="HTML")this.overflowOffset=this.scrollParent.offset();this._trigger("start",a,this._uiHash());this._preserveHelperProportions||this._cacheHelperProportions();if(!c)for(c=this.containers.length-1;c>=0;c--)this.containers[c]._trigger("activate",a,e._uiHash(this));if(d.ui.ddmanager)d.ui.ddmanager.current=this;d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,a);this.dragging=true;this.helper.addClass("ui-sortable-helper");this._mouseDrag(a);
return true},_mouseDrag:function(a){this.position=this._generatePosition(a);this.positionAbs=this._convertPositionTo("absolute");if(!this.lastPositionAbs)this.lastPositionAbs=this.positionAbs;if(this.options.scroll){var b=this.options,c=false;if(this.scrollParent[0]!=document&&this.scrollParent[0].tagName!="HTML"){if(this.overflowOffset.top+this.scrollParent[0].offsetHeight-a.pageY<b.scrollSensitivity)this.scrollParent[0].scrollTop=c=this.scrollParent[0].scrollTop+b.scrollSpeed;else if(a.pageY-this.overflowOffset.top<
b.scrollSensitivity)this.scrollParent[0].scrollTop=c=this.scrollParent[0].scrollTop-b.scrollSpeed;if(this.overflowOffset.left+this.scrollParent[0].offsetWidth-a.pageX<b.scrollSensitivity)this.scrollParent[0].scrollLeft=c=this.scrollParent[0].scrollLeft+b.scrollSpeed;else if(a.pageX-this.overflowOffset.left<b.scrollSensitivity)this.scrollParent[0].scrollLeft=c=this.scrollParent[0].scrollLeft-b.scrollSpeed}else{if(a.pageY-d(document).scrollTop()<b.scrollSensitivity)c=d(document).scrollTop(d(document).scrollTop()-
b.scrollSpeed);else if(d(window).height()-(a.pageY-d(document).scrollTop())<b.scrollSensitivity)c=d(document).scrollTop(d(document).scrollTop()+b.scrollSpeed);if(a.pageX-d(document).scrollLeft()<b.scrollSensitivity)c=d(document).scrollLeft(d(document).scrollLeft()-b.scrollSpeed);else if(d(window).width()-(a.pageX-d(document).scrollLeft())<b.scrollSensitivity)c=d(document).scrollLeft(d(document).scrollLeft()+b.scrollSpeed)}c!==false&&d.ui.ddmanager&&!b.dropBehaviour&&d.ui.ddmanager.prepareOffsets(this,
a)}this.positionAbs=this._convertPositionTo("absolute");if(!this.options.axis||this.options.axis!="y")this.helper[0].style.left=this.position.left+"px";if(!this.options.axis||this.options.axis!="x")this.helper[0].style.top=this.position.top+"px";for(b=this.items.length-1;b>=0;b--){c=this.items[b];var e=c.item[0],f=this._intersectsWithPointer(c);if(f)if(e!=this.currentItem[0]&&this.placeholder[f==1?"next":"prev"]()[0]!=e&&!d.ui.contains(this.placeholder[0],e)&&(this.options.type=="semi-dynamic"?!d.ui.contains(this.element[0],
e):true)){this.direction=f==1?"down":"up";if(this.options.tolerance=="pointer"||this._intersectsWithSides(c))this._rearrange(a,c);else break;this._trigger("change",a,this._uiHash());break}}this._contactContainers(a);d.ui.ddmanager&&d.ui.ddmanager.drag(this,a);this._trigger("sort",a,this._uiHash());this.lastPositionAbs=this.positionAbs;return false},_mouseStop:function(a,b){if(a){d.ui.ddmanager&&!this.options.dropBehaviour&&d.ui.ddmanager.drop(this,a);if(this.options.revert){var c=this;b=c.placeholder.offset();
c.reverting=true;d(this.helper).animate({left:b.left-this.offset.parent.left-c.margins.left+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollLeft),top:b.top-this.offset.parent.top-c.margins.top+(this.offsetParent[0]==document.body?0:this.offsetParent[0].scrollTop)},parseInt(this.options.revert,10)||500,function(){c._clear(a)})}else this._clear(a,b);return false}},cancel:function(){var a=this;if(this.dragging){this._mouseUp({target:null});this.options.helper=="original"?this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper"):
this.currentItem.show();for(var b=this.containers.length-1;b>=0;b--){this.containers[b]._trigger("deactivate",null,a._uiHash(this));if(this.containers[b].containerCache.over){this.containers[b]._trigger("out",null,a._uiHash(this));this.containers[b].containerCache.over=0}}}if(this.placeholder){this.placeholder[0].parentNode&&this.placeholder[0].parentNode.removeChild(this.placeholder[0]);this.options.helper!="original"&&this.helper&&this.helper[0].parentNode&&this.helper.remove();d.extend(this,{helper:null,
dragging:false,reverting:false,_noFinalSort:null});this.domPosition.prev?d(this.domPosition.prev).after(this.currentItem):d(this.domPosition.parent).prepend(this.currentItem)}return this},serialize:function(a){var b=this._getItemsAsjQuery(a&&a.connected),c=[];a=a||{};d(b).each(function(){var e=(d(a.item||this).attr(a.attribute||"id")||"").match(a.expression||/(.+)[-=_](.+)/);if(e)c.push((a.key||e[1]+"[]")+"="+(a.key&&a.expression?e[1]:e[2]))});!c.length&&a.key&&c.push(a.key+"=");return c.join("&")},
toArray:function(a){var b=this._getItemsAsjQuery(a&&a.connected),c=[];a=a||{};b.each(function(){c.push(d(a.item||this).attr(a.attribute||"id")||"")});return c},_intersectsWith:function(a){var b=this.positionAbs.left,c=b+this.helperProportions.width,e=this.positionAbs.top,f=e+this.helperProportions.height,g=a.left,h=g+a.width,i=a.top,k=i+a.height,j=this.offset.click.top,l=this.offset.click.left;j=e+j>i&&e+j<k&&b+l>g&&b+l<h;return this.options.tolerance=="pointer"||this.options.forcePointerForContainers||
this.options.tolerance!="pointer"&&this.helperProportions[this.floating?"width":"height"]>a[this.floating?"width":"height"]?j:g<b+this.helperProportions.width/2&&c-this.helperProportions.width/2<h&&i<e+this.helperProportions.height/2&&f-this.helperProportions.height/2<k},_intersectsWithPointer:function(a){var b=d.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,a.top,a.height);a=d.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,a.left,a.width);b=b&&a;a=this._getDragVerticalDirection();
var c=this._getDragHorizontalDirection();if(!b)return false;return this.floating?c&&c=="right"||a=="down"?2:1:a&&(a=="down"?2:1)},_intersectsWithSides:function(a){var b=d.ui.isOverAxis(this.positionAbs.top+this.offset.click.top,a.top+a.height/2,a.height);a=d.ui.isOverAxis(this.positionAbs.left+this.offset.click.left,a.left+a.width/2,a.width);var c=this._getDragVerticalDirection(),e=this._getDragHorizontalDirection();return this.floating&&e?e=="right"&&a||e=="left"&&!a:c&&(c=="down"&&b||c=="up"&&!b)},
_getDragVerticalDirection:function(){var a=this.positionAbs.top-this.lastPositionAbs.top;return a!=0&&(a>0?"down":"up")},_getDragHorizontalDirection:function(){var a=this.positionAbs.left-this.lastPositionAbs.left;return a!=0&&(a>0?"right":"left")},refresh:function(a){this._refreshItems(a);this.refreshPositions();return this},_connectWith:function(){var a=this.options;return a.connectWith.constructor==String?[a.connectWith]:a.connectWith},_getItemsAsjQuery:function(a){var b=[],c=[],e=this._connectWith();
if(e&&a)for(a=e.length-1;a>=0;a--)for(var f=d(e[a]),g=f.length-1;g>=0;g--){var h=d.data(f[g],"sortable");if(h&&h!=this&&!h.options.disabled)c.push([d.isFunction(h.options.items)?h.options.items.call(h.element):d(h.options.items,h.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),h])}c.push([d.isFunction(this.options.items)?this.options.items.call(this.element,null,{options:this.options,item:this.currentItem}):d(this.options.items,this.element).not(".ui-sortable-helper").not(".ui-sortable-placeholder"),
this]);for(a=c.length-1;a>=0;a--)c[a][0].each(function(){b.push(this)});return d(b)},_removeCurrentsFromItems:function(){for(var a=this.currentItem.find(":data(sortable-item)"),b=0;b<this.items.length;b++)for(var c=0;c<a.length;c++)a[c]==this.items[b].item[0]&&this.items.splice(b,1)},_refreshItems:function(a){this.items=[];this.containers=[this];var b=this.items,c=[[d.isFunction(this.options.items)?this.options.items.call(this.element[0],a,{item:this.currentItem}):d(this.options.items,this.element),
this]],e=this._connectWith();if(e)for(var f=e.length-1;f>=0;f--)for(var g=d(e[f]),h=g.length-1;h>=0;h--){var i=d.data(g[h],"sortable");if(i&&i!=this&&!i.options.disabled){c.push([d.isFunction(i.options.items)?i.options.items.call(i.element[0],a,{item:this.currentItem}):d(i.options.items,i.element),i]);this.containers.push(i)}}for(f=c.length-1;f>=0;f--){a=c[f][1];e=c[f][0];h=0;for(g=e.length;h<g;h++){i=d(e[h]);i.data("sortable-item",a);b.push({item:i,instance:a,width:0,height:0,left:0,top:0})}}},refreshPositions:function(a){if(this.offsetParent&&
this.helper)this.offset.parent=this._getParentOffset();for(var b=this.items.length-1;b>=0;b--){var c=this.items[b],e=this.options.toleranceElement?d(this.options.toleranceElement,c.item):c.item;if(!a){c.width=e.outerWidth();c.height=e.outerHeight()}e=e.offset();c.left=e.left;c.top=e.top}if(this.options.custom&&this.options.custom.refreshContainers)this.options.custom.refreshContainers.call(this);else for(b=this.containers.length-1;b>=0;b--){e=this.containers[b].element.offset();this.containers[b].containerCache.left=
e.left;this.containers[b].containerCache.top=e.top;this.containers[b].containerCache.width=this.containers[b].element.outerWidth();this.containers[b].containerCache.height=this.containers[b].element.outerHeight()}return this},_createPlaceholder:function(a){var b=a||this,c=b.options;if(!c.placeholder||c.placeholder.constructor==String){var e=c.placeholder;c.placeholder={element:function(){var f=d(document.createElement(b.currentItem[0].nodeName)).addClass(e||b.currentItem[0].className+" ui-sortable-placeholder").removeClass("ui-sortable-helper")[0];
if(!e)f.style.visibility="hidden";return f},update:function(f,g){if(!(e&&!c.forcePlaceholderSize)){g.height()||g.height(b.currentItem.innerHeight()-parseInt(b.currentItem.css("paddingTop")||0,10)-parseInt(b.currentItem.css("paddingBottom")||0,10));g.width()||g.width(b.currentItem.innerWidth()-parseInt(b.currentItem.css("paddingLeft")||0,10)-parseInt(b.currentItem.css("paddingRight")||0,10))}}}}b.placeholder=d(c.placeholder.element.call(b.element,b.currentItem));b.currentItem.after(b.placeholder);
c.placeholder.update(b,b.placeholder)},_contactContainers:function(a){for(var b=null,c=null,e=this.containers.length-1;e>=0;e--)if(!d.ui.contains(this.currentItem[0],this.containers[e].element[0]))if(this._intersectsWith(this.containers[e].containerCache)){if(!(b&&d.ui.contains(this.containers[e].element[0],b.element[0]))){b=this.containers[e];c=e}}else if(this.containers[e].containerCache.over){this.containers[e]._trigger("out",a,this._uiHash(this));this.containers[e].containerCache.over=0}if(b)if(this.containers.length===
1){this.containers[c]._trigger("over",a,this._uiHash(this));this.containers[c].containerCache.over=1}else if(this.currentContainer!=this.containers[c]){b=1E4;e=null;for(var f=this.positionAbs[this.containers[c].floating?"left":"top"],g=this.items.length-1;g>=0;g--)if(d.ui.contains(this.containers[c].element[0],this.items[g].item[0])){var h=this.items[g][this.containers[c].floating?"left":"top"];if(Math.abs(h-f)<b){b=Math.abs(h-f);e=this.items[g]}}if(e||this.options.dropOnEmpty){this.currentContainer=
this.containers[c];e?this._rearrange(a,e,null,true):this._rearrange(a,null,this.containers[c].element,true);this._trigger("change",a,this._uiHash());this.containers[c]._trigger("change",a,this._uiHash(this));this.options.placeholder.update(this.currentContainer,this.placeholder);this.containers[c]._trigger("over",a,this._uiHash(this));this.containers[c].containerCache.over=1}}},_createHelper:function(a){var b=this.options;a=d.isFunction(b.helper)?d(b.helper.apply(this.element[0],[a,this.currentItem])):
b.helper=="clone"?this.currentItem.clone():this.currentItem;a.parents("body").length||d(b.appendTo!="parent"?b.appendTo:this.currentItem[0].parentNode)[0].appendChild(a[0]);if(a[0]==this.currentItem[0])this._storedCSS={width:this.currentItem[0].style.width,height:this.currentItem[0].style.height,position:this.currentItem.css("position"),top:this.currentItem.css("top"),left:this.currentItem.css("left")};if(a[0].style.width==""||b.forceHelperSize)a.width(this.currentItem.width());if(a[0].style.height==
""||b.forceHelperSize)a.height(this.currentItem.height());return a},_adjustOffsetFromHelper:function(a){if(typeof a=="string")a=a.split(" ");if(d.isArray(a))a={left:+a[0],top:+a[1]||0};if("left"in a)this.offset.click.left=a.left+this.margins.left;if("right"in a)this.offset.click.left=this.helperProportions.width-a.right+this.margins.left;if("top"in a)this.offset.click.top=a.top+this.margins.top;if("bottom"in a)this.offset.click.top=this.helperProportions.height-a.bottom+this.margins.top},_getParentOffset:function(){this.offsetParent=
this.helper.offsetParent();var a=this.offsetParent.offset();if(this.cssPosition=="absolute"&&this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0])){a.left+=this.scrollParent.scrollLeft();a.top+=this.scrollParent.scrollTop()}if(this.offsetParent[0]==document.body||this.offsetParent[0].tagName&&this.offsetParent[0].tagName.toLowerCase()=="html"&&d.browser.msie)a={top:0,left:0};return{top:a.top+(parseInt(this.offsetParent.css("borderTopWidth"),10)||0),left:a.left+(parseInt(this.offsetParent.css("borderLeftWidth"),
10)||0)}},_getRelativeOffset:function(){if(this.cssPosition=="relative"){var a=this.currentItem.position();return{top:a.top-(parseInt(this.helper.css("top"),10)||0)+this.scrollParent.scrollTop(),left:a.left-(parseInt(this.helper.css("left"),10)||0)+this.scrollParent.scrollLeft()}}else return{top:0,left:0}},_cacheMargins:function(){this.margins={left:parseInt(this.currentItem.css("marginLeft"),10)||0,top:parseInt(this.currentItem.css("marginTop"),10)||0}},_cacheHelperProportions:function(){this.helperProportions=
{width:this.helper.outerWidth(),height:this.helper.outerHeight()}},_setContainment:function(){var a=this.options;if(a.containment=="parent")a.containment=this.helper[0].parentNode;if(a.containment=="document"||a.containment=="window")this.containment=[0-this.offset.relative.left-this.offset.parent.left,0-this.offset.relative.top-this.offset.parent.top,d(a.containment=="document"?document:window).width()-this.helperProportions.width-this.margins.left,(d(a.containment=="document"?document:window).height()||
document.body.parentNode.scrollHeight)-this.helperProportions.height-this.margins.top];if(!/^(document|window|parent)$/.test(a.containment)){var b=d(a.containment)[0];a=d(a.containment).offset();var c=d(b).css("overflow")!="hidden";this.containment=[a.left+(parseInt(d(b).css("borderLeftWidth"),10)||0)+(parseInt(d(b).css("paddingLeft"),10)||0)-this.margins.left,a.top+(parseInt(d(b).css("borderTopWidth"),10)||0)+(parseInt(d(b).css("paddingTop"),10)||0)-this.margins.top,a.left+(c?Math.max(b.scrollWidth,
b.offsetWidth):b.offsetWidth)-(parseInt(d(b).css("borderLeftWidth"),10)||0)-(parseInt(d(b).css("paddingRight"),10)||0)-this.helperProportions.width-this.margins.left,a.top+(c?Math.max(b.scrollHeight,b.offsetHeight):b.offsetHeight)-(parseInt(d(b).css("borderTopWidth"),10)||0)-(parseInt(d(b).css("paddingBottom"),10)||0)-this.helperProportions.height-this.margins.top]}},_convertPositionTo:function(a,b){if(!b)b=this.position;a=a=="absolute"?1:-1;var c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=
document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,e=/(html|body)/i.test(c[0].tagName);return{top:b.top+this.offset.relative.top*a+this.offset.parent.top*a-(d.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollTop():e?0:c.scrollTop())*a),left:b.left+this.offset.relative.left*a+this.offset.parent.left*a-(d.browser.safari&&this.cssPosition=="fixed"?0:(this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():
e?0:c.scrollLeft())*a)}},_generatePosition:function(a){var b=this.options,c=this.cssPosition=="absolute"&&!(this.scrollParent[0]!=document&&d.ui.contains(this.scrollParent[0],this.offsetParent[0]))?this.offsetParent:this.scrollParent,e=/(html|body)/i.test(c[0].tagName);if(this.cssPosition=="relative"&&!(this.scrollParent[0]!=document&&this.scrollParent[0]!=this.offsetParent[0]))this.offset.relative=this._getRelativeOffset();var f=a.pageX,g=a.pageY;if(this.originalPosition){if(this.containment){if(a.pageX-
this.offset.click.left<this.containment[0])f=this.containment[0]+this.offset.click.left;if(a.pageY-this.offset.click.top<this.containment[1])g=this.containment[1]+this.offset.click.top;if(a.pageX-this.offset.click.left>this.containment[2])f=this.containment[2]+this.offset.click.left;if(a.pageY-this.offset.click.top>this.containment[3])g=this.containment[3]+this.offset.click.top}if(b.grid){g=this.originalPageY+Math.round((g-this.originalPageY)/b.grid[1])*b.grid[1];g=this.containment?!(g-this.offset.click.top<
this.containment[1]||g-this.offset.click.top>this.containment[3])?g:!(g-this.offset.click.top<this.containment[1])?g-b.grid[1]:g+b.grid[1]:g;f=this.originalPageX+Math.round((f-this.originalPageX)/b.grid[0])*b.grid[0];f=this.containment?!(f-this.offset.click.left<this.containment[0]||f-this.offset.click.left>this.containment[2])?f:!(f-this.offset.click.left<this.containment[0])?f-b.grid[0]:f+b.grid[0]:f}}return{top:g-this.offset.click.top-this.offset.relative.top-this.offset.parent.top+(d.browser.safari&&
this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollTop():e?0:c.scrollTop()),left:f-this.offset.click.left-this.offset.relative.left-this.offset.parent.left+(d.browser.safari&&this.cssPosition=="fixed"?0:this.cssPosition=="fixed"?-this.scrollParent.scrollLeft():e?0:c.scrollLeft())}},_rearrange:function(a,b,c,e){c?c[0].appendChild(this.placeholder[0]):b.item[0].parentNode.insertBefore(this.placeholder[0],this.direction=="down"?b.item[0]:b.item[0].nextSibling);this.counter=
this.counter?++this.counter:1;var f=this,g=this.counter;window.setTimeout(function(){g==f.counter&&f.refreshPositions(!e)},0)},_clear:function(a,b){this.reverting=false;var c=[];!this._noFinalSort&&this.currentItem[0].parentNode&&this.placeholder.before(this.currentItem);this._noFinalSort=null;if(this.helper[0]==this.currentItem[0]){for(var e in this._storedCSS)if(this._storedCSS[e]=="auto"||this._storedCSS[e]=="static")this._storedCSS[e]="";this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper")}else this.currentItem.show();
this.fromOutside&&!b&&c.push(function(f){this._trigger("receive",f,this._uiHash(this.fromOutside))});if((this.fromOutside||this.domPosition.prev!=this.currentItem.prev().not(".ui-sortable-helper")[0]||this.domPosition.parent!=this.currentItem.parent()[0])&&!b)c.push(function(f){this._trigger("update",f,this._uiHash())});if(!d.ui.contains(this.element[0],this.currentItem[0])){b||c.push(function(f){this._trigger("remove",f,this._uiHash())});for(e=this.containers.length-1;e>=0;e--)if(d.ui.contains(this.containers[e].element[0],
this.currentItem[0])&&!b){c.push(function(f){return function(g){f._trigger("receive",g,this._uiHash(this))}}.call(this,this.containers[e]));c.push(function(f){return function(g){f._trigger("update",g,this._uiHash(this))}}.call(this,this.containers[e]))}}for(e=this.containers.length-1;e>=0;e--){b||c.push(function(f){return function(g){f._trigger("deactivate",g,this._uiHash(this))}}.call(this,this.containers[e]));if(this.containers[e].containerCache.over){c.push(function(f){return function(g){f._trigger("out",
g,this._uiHash(this))}}.call(this,this.containers[e]));this.containers[e].containerCache.over=0}}this._storedCursor&&d("body").css("cursor",this._storedCursor);this._storedOpacity&&this.helper.css("opacity",this._storedOpacity);if(this._storedZIndex)this.helper.css("zIndex",this._storedZIndex=="auto"?"":this._storedZIndex);this.dragging=false;if(this.cancelHelperRemoval){if(!b){this._trigger("beforeStop",a,this._uiHash());for(e=0;e<c.length;e++)c[e].call(this,a);this._trigger("stop",a,this._uiHash())}return false}b||
this._trigger("beforeStop",a,this._uiHash());this.placeholder[0].parentNode.removeChild(this.placeholder[0]);this.helper[0]!=this.currentItem[0]&&this.helper.remove();this.helper=null;if(!b){for(e=0;e<c.length;e++)c[e].call(this,a);this._trigger("stop",a,this._uiHash())}this.fromOutside=false;return true},_trigger:function(){d.Widget.prototype._trigger.apply(this,arguments)===false&&this.cancel()},_uiHash:function(a){var b=a||this;return{helper:b.helper,placeholder:b.placeholder||d([]),position:b.position,
originalPosition:b.originalPosition,offset:b.positionAbs,item:b.currentItem,sender:a?a.element:null}}});d.extend(d.ui.sortable,{version:"1.8.11"})})(jQuery);
;
jQuery.ui.draggable.prototype._mouseCapture=(function(A){return function(C){var B=A.call(this,C);if(B&&jQuery.browser.msie){C.stopPropagation()}return B}})(jQuery.ui.draggable.prototype._mouseCapture);
(function(){var _after=1;var _afterThrow=2;var _afterFinally=3;var _before=4;var _around=5;var _intro=6;var _regexEnabled=true;var _arguments="arguments";var _undef="undefined";var getType=(function(){var toString=Object.prototype.toString,toStrings={},nodeTypes={1:"element",3:"textnode",9:"document",11:"fragment"},types="Arguments Array Boolean Date Document Element Error Fragment Function NodeList Null Number Object RegExp String TextNode Undefined Window".split(" ");for(var i=types.length;i--;){var type=types[i],constructor=window[type];if(constructor){try{toStrings[toString.call(new constructor)]=type.toLowerCase()}catch(e){}}}return function(item){return item==null&&(item===undefined?_undef:"null")||item.nodeType&&nodeTypes[item.nodeType]||typeof item.length=="number"&&(item.callee&&_arguments||item.alert&&"window"||item.item&&"nodelist")||toStrings[toString.call(item)]}})();var isFunc=function(obj){return getType(obj)=="function"};var weaveOne=function(source,method,advice){var old=source[method];if(advice.type!=_intro&&!isFunc(old)){var oldObject=old;old=function(){var code=arguments.length>0?_arguments+"[0]":"";for(var i=1;i<arguments.length;i++){code+=","+_arguments+"["+i+"]"}return eval("oldObject("+code+");")}}var aspect;if(advice.type==_after||advice.type==_afterThrow||advice.type==_afterFinally){aspect=function(){var returnValue,exceptionThrown=null;try{returnValue=old.apply(this,arguments)}catch(e){exceptionThrown=e}if(advice.type==_after){if(exceptionThrown==null){returnValue=advice.value.apply(this,[returnValue,method])}else{throw exceptionThrown}}else{if(advice.type==_afterThrow&&exceptionThrown!=null){returnValue=advice.value.apply(this,[exceptionThrown,method])}else{if(advice.type==_afterFinally){returnValue=advice.value.apply(this,[returnValue,exceptionThrown,method])}}}return returnValue}}else{if(advice.type==_before){aspect=function(){advice.value.apply(this,[arguments,method]);return old.apply(this,arguments)}}else{if(advice.type==_intro){aspect=function(){return advice.value.apply(this,arguments)}}else{if(advice.type==_around){aspect=function(){var invocation={object:this,args:Array.prototype.slice.call(arguments)};return advice.value.apply(invocation.object,[{arguments:invocation.args,method:method,proceed:function(){return old.apply(invocation.object,invocation.args)}}])}}}}}aspect.unweave=function(){source[method]=old;pointcut=source=aspect=old=null};source[method]=aspect;return aspect};var search=function(source,pointcut,advice){var methods=[];for(var method in source){var item=null;try{item=source[method]}catch(e){}if(item!=null&&method.match(pointcut.method)&&isFunc(item)){methods[methods.length]={source:source,method:method,advice:advice}}}return methods};var weave=function(pointcut,advice){var source=typeof (pointcut.target.prototype)!=_undef?pointcut.target.prototype:pointcut.target;var advices=[];if(advice.type!=_intro&&typeof (source[pointcut.method])==_undef){var methods=search(pointcut.target,pointcut,advice);if(methods.length==0){methods=search(source,pointcut,advice)}for(var i in methods){advices[advices.length]=weaveOne(methods[i].source,methods[i].method,methods[i].advice)}}else{advices[0]=weaveOne(source,pointcut.method,advice)}return _regexEnabled?advices:advices[0]};jQuery.aop={after:function(pointcut,advice){return weave(pointcut,{type:_after,value:advice})},afterThrow:function(pointcut,advice){return weave(pointcut,{type:_afterThrow,value:advice})},afterFinally:function(pointcut,advice){return weave(pointcut,{type:_afterFinally,value:advice})},before:function(pointcut,advice){return weave(pointcut,{type:_before,value:advice})},around:function(pointcut,advice){return weave(pointcut,{type:_around,value:advice})},introduction:function(pointcut,advice){return weave(pointcut,{type:_intro,value:advice})},setup:function(settings){_regexEnabled=settings.regexMatch}}})();
/*
 * jQuery Form Plugin
 * version: 2.67 (12-MAR-2011)
 * @requires jQuery v1.3.2 or later
 *
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function(B){B.fn.ajaxSubmit=function(Q){if(!this.length){A("ajaxSubmit: skipping submit process - no element selected");return this}if(typeof Q=="function"){Q={success:Q}}var H=this.attr("action");var D=(typeof H==="string")?B.trim(H):"";if(D){D=(D.match(/^([^#]+)/)||[])[1]}D=D||window.location.href||"";Q=B.extend(true,{url:D,type:this[0].getAttribute("method")||"GET",iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},Q);var R={};this.trigger("form-pre-serialize",[this,Q,R]);if(R.veto){A("ajaxSubmit: submit vetoed via form-pre-serialize trigger");return this}if(Q.beforeSerialize&&Q.beforeSerialize(this,Q)===false){A("ajaxSubmit: submit aborted via beforeSerialize callback");return this}var F,N,L=this.formToArray(Q.semantic);if(Q.data){Q.extraData=Q.data;for(F in Q.data){if(Q.data[F] instanceof Array){for(var I in Q.data[F]){L.push({name:F,value:Q.data[F][I]})}}else{N=Q.data[F];N=B.isFunction(N)?N():N;L.push({name:F,value:N})}}}if(Q.beforeSubmit&&Q.beforeSubmit(L,this,Q)===false){A("ajaxSubmit: submit aborted via beforeSubmit callback");return this}this.trigger("form-submit-validate",[L,this,Q,R]);if(R.veto){A("ajaxSubmit: submit vetoed via form-submit-validate trigger");return this}var C=B.param(L);if(Q.type.toUpperCase()=="GET"){Q.url+=(Q.url.indexOf("?")>=0?"&":"?")+C;Q.data=null}else{Q.data=C}var P=this,K=[];if(Q.resetForm){K.push(function(){P.resetForm()})}if(Q.clearForm){K.push(function(){P.clearForm()})}if(!Q.dataType&&Q.target){var O=Q.success||function(){};K.push(function(T){var S=Q.replaceTarget?"replaceWith":"html";B(Q.target)[S](T).each(O,arguments)})}else{if(Q.success){K.push(Q.success)}}Q.success=function(W,T,X){var V=Q.context||Q;for(var U=0,S=K.length;U<S;U++){K[U].apply(V,[W,T,X||P,P])}};var G=B("input:file",this).length>0;var E="multipart/form-data";var J=(P.attr("enctype")==E||P.attr("encoding")==E);if(Q.iframe!==false&&(G||Q.iframe||J)){if(Q.closeKeepAlive){B.get(Q.closeKeepAlive,M)}else{M()}}else{B.ajax(Q)}this.trigger("form-submit-notify",[this,Q]);return this;function M(){var U=P[0];if(B(":input[name=submit],:input[id=submit]",U).length){alert('Error: Form elements must not have name or id of "submit".');return }var a=B.extend(true,{},B.ajaxSettings,Q);a.context=a.context||a;var d="jqFormIO"+(new Date().getTime()),Y="_"+d;var V=B('<iframe id="'+d+'" name="'+d+'" src="'+a.iframeSrc+'" />');var Z=V[0];V.css({position:"absolute",top:"-1000px",left:"-1000px"});var W={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(){A("aborting upload...");var g="aborted";this.aborted=1;V.attr("src",a.iframeSrc);W.error=g;a.error&&a.error.call(a.context,W,"error",g);i&&B.event.trigger("ajaxError",[W,a,g]);a.complete&&a.complete.call(a.context,W,"error")}};var i=a.global;if(i&&!B.active++){B.event.trigger("ajaxStart")}if(i){B.event.trigger("ajaxSend",[W,a])}if(a.beforeSend&&a.beforeSend.call(a.context,W,a)===false){if(a.global){B.active--}return }if(W.aborted){return }var h=0;var X=U.clk;if(X){var e=X.name;if(e&&!X.disabled){a.extraData=a.extraData||{};a.extraData[e]=X.value;if(X.type=="image"){a.extraData[e+".x"]=U.clk_x;a.extraData[e+".y"]=U.clk_y}}}function f(){var o=P.attr("target"),g=P.attr("action");U.setAttribute("target",d);if(U.getAttribute("method")!="POST"){U.setAttribute("method","POST")}if(U.getAttribute("action")!=a.url){U.setAttribute("action",a.url)}if(!a.skipEncodingOverride){P.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"})}if(a.timeout){setTimeout(function(){h=true;c()},a.timeout)}var m=[];try{if(a.extraData){for(var p in a.extraData){m.push(B('<input type="hidden" name="'+p+'" value="'+a.extraData[p]+'" />').appendTo(U)[0])}}V.appendTo("body");Z.attachEvent?Z.attachEvent("onload",c):Z.addEventListener("load",c,false);U.submit()}finally{U.setAttribute("action",g);if(o){U.setAttribute("target",o)}else{P.removeAttr("target")}B(m).remove()}}if(a.forceSync){f()}else{setTimeout(f,10)}var k,l,j=50;function c(){if(W.aborted){return }var r=Z.contentWindow?Z.contentWindow.document:Z.contentDocument?Z.contentDocument:Z.document;if(!r||r.location.href==a.iframeSrc){return }Z.detachEvent?Z.detachEvent("onload",c):Z.removeEventListener("load",c,false);var n=true;try{if(h){throw"timeout"}var s=a.dataType=="xml"||r.XMLDocument||B.isXMLDoc(r);A("isXml="+s);if(!s&&window.opera&&(r.body==null||r.body.innerHTML=="")){if(--j){A("requeing onLoad callback, DOM not available");setTimeout(c,250);return }}W.responseText=r.body?r.body.innerHTML:r.documentElement?r.documentElement.innerHTML:null;W.responseXML=r.XMLDocument?r.XMLDocument:r;W.getResponseHeader=function(u){var t={"content-type":a.dataType};return t[u]};var q=/(json|script)/.test(a.dataType);if(q||a.textarea){var m=r.getElementsByTagName("textarea")[0];if(m){W.responseText=m.value}else{if(q){var p=r.getElementsByTagName("pre")[0];var g=r.getElementsByTagName("body")[0];if(p){W.responseText=p.textContent}else{if(g){W.responseText=g.innerHTML}}}}}else{if(a.dataType=="xml"&&!W.responseXML&&W.responseText!=null){W.responseXML=b(W.responseText)}}k=S(W,a.dataType,a)}catch(o){A("error caught:",o);n=false;W.error=o;a.error&&a.error.call(a.context,W,"error",o);i&&B.event.trigger("ajaxError",[W,a,o])}if(W.aborted){A("upload aborted");n=false}if(n){a.success&&a.success.call(a.context,k,"success",W);i&&B.event.trigger("ajaxSuccess",[W,a])}i&&B.event.trigger("ajaxComplete",[W,a]);if(i&&!--B.active){B.event.trigger("ajaxStop")}a.complete&&a.complete.call(a.context,W,n?"success":"error");setTimeout(function(){V.removeData("form-plugin-onload");V.remove();W.responseXML=null},100)}var b=B.parseXML||function(g,m){if(window.ActiveXObject){m=new ActiveXObject("Microsoft.XMLDOM");m.async="false";m.loadXML(g)}else{m=(new DOMParser()).parseFromString(g,"text/xml")}return(m&&m.documentElement&&m.documentElement.nodeName!="parsererror")?m:null};var T=B.parseJSON||function(g){return window["eval"]("("+g+")")};var S=function(q,o,n){var m=q.getResponseHeader("content-type")||"",g=o==="xml"||!o&&m.indexOf("xml")>=0,p=g?q.responseXML:q.responseText;if(g&&p.documentElement.nodeName==="parsererror"){B.error&&B.error("parsererror")}if(n&&n.dataFilter){p=n.dataFilter(p,o)}if(typeof p==="string"){if(o==="json"||!o&&m.indexOf("json")>=0){p=T(p)}else{if(o==="script"||!o&&m.indexOf("javascript")>=0){B.globalEval(p)}}}return p}}};B.fn.ajaxForm=function(C){if(this.length===0){var D={s:this.selector,c:this.context};if(!B.isReady&&D.s){A("DOM not ready, queuing ajaxForm");B(function(){B(D.s,D.c).ajaxForm(C)});return this}A("terminating; zero elements found by selector"+(B.isReady?"":" (DOM not ready)"));return this}return this.ajaxFormUnbind().bind("submit.form-plugin",function(E){if(!E.isDefaultPrevented()){E.preventDefault();B(this).ajaxSubmit(C)}}).bind("click.form-plugin",function(I){var H=I.target;var F=B(H);if(!(F.is(":submit,input:image"))){var E=F.closest(":submit");if(E.length==0){return }H=E[0]}var G=this;G.clk=H;if(H.type=="image"){if(I.offsetX!=undefined){G.clk_x=I.offsetX;G.clk_y=I.offsetY}else{if(typeof B.fn.offset=="function"){var J=F.offset();G.clk_x=I.pageX-J.left;G.clk_y=I.pageY-J.top}else{G.clk_x=I.pageX-H.offsetLeft;G.clk_y=I.pageY-H.offsetTop}}}setTimeout(function(){G.clk=G.clk_x=G.clk_y=null},100)})};B.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")};B.fn.formToArray=function(N){var M=[];if(this.length===0){return M}var D=this[0];var G=N?D.getElementsByTagName("*"):D.elements;if(!G){return M}var I,H,F,O,E,K,C;for(I=0,K=G.length;I<K;I++){E=G[I];F=E.name;if(!F){continue}if(N&&D.clk&&E.type=="image"){if(!E.disabled&&D.clk==E){M.push({name:F,value:B(E).val()});M.push({name:F+".x",value:D.clk_x},{name:F+".y",value:D.clk_y})}continue}O=B.fieldValue(E,true);if(O&&O.constructor==Array){for(H=0,C=O.length;H<C;H++){M.push({name:F,value:O[H]})}}else{if(O!==null&&typeof O!="undefined"){M.push({name:F,value:O})}}}if(!N&&D.clk){var J=B(D.clk),L=J[0];F=L.name;if(F&&!L.disabled&&L.type=="image"){M.push({name:F,value:J.val()});M.push({name:F+".x",value:D.clk_x},{name:F+".y",value:D.clk_y})}}return M};B.fn.formSerialize=function(C){return B.param(this.formToArray(C))};B.fn.fieldSerialize=function(D){var C=[];this.each(function(){var H=this.name;if(!H){return }var F=B.fieldValue(this,D);if(F&&F.constructor==Array){for(var G=0,E=F.length;G<E;G++){C.push({name:H,value:F[G]})}}else{if(F!==null&&typeof F!="undefined"){C.push({name:this.name,value:F})}}});return B.param(C)};B.fn.fieldValue=function(H){for(var G=[],E=0,C=this.length;E<C;E++){var F=this[E];var D=B.fieldValue(F,H);if(D===null||typeof D=="undefined"||(D.constructor==Array&&!D.length)){continue}D.constructor==Array?B.merge(G,D):G.push(D)}return G};B.fieldValue=function(C,I){var E=C.name,N=C.type,O=C.tagName.toLowerCase();if(I===undefined){I=true}if(I&&(!E||C.disabled||N=="reset"||N=="button"||(N=="checkbox"||N=="radio")&&!C.checked||(N=="submit"||N=="image")&&C.form&&C.form.clk!=C||O=="select"&&C.selectedIndex==-1)){return null}if(O=="select"){var J=C.selectedIndex;if(J<0){return null}var L=[],D=C.options;var G=(N=="select-one");var K=(G?J+1:D.length);for(var F=(G?J:0);F<K;F++){var H=D[F];if(H.selected){var M=H.value;if(!M){M=(H.attributes&&H.attributes.value&&!(H.attributes.value.specified))?H.text:H.value}if(G){return M}L.push(M)}}return L}return B(C).val()};B.fn.clearForm=function(){return this.each(function(){B("input,select,textarea",this).clearFields()})};B.fn.clearFields=B.fn.clearInputs=function(){return this.each(function(){var D=this.type,C=this.tagName.toLowerCase();if(D=="text"||D=="password"||C=="textarea"){this.value=""}else{if(D=="checkbox"||D=="radio"){this.checked=false}else{if(C=="select"){this.selectedIndex=-1}}}})};B.fn.resetForm=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};B.fn.enable=function(C){if(C===undefined){C=true}return this.each(function(){this.disabled=!C})};B.fn.selected=function(C){if(C===undefined){C=true}return this.each(function(){var D=this.type;if(D=="checkbox"||D=="radio"){this.checked=C}else{if(this.tagName.toLowerCase()=="option"){var E=B(this).parent("select");if(C&&E[0]&&E[0].type=="select-one"){E.find("option").selected(false)}this.selected=C}}})};function A(){if(B.fn.ajaxSubmit.debug){var C="[jquery.form] "+Array.prototype.join.call(arguments,"");if(window.console&&window.console.log){window.console.log(C)}else{if(window.opera&&window.opera.postError){window.opera.postError(C)}}}}})(jQuery);
(function(D){function C(G,E){function F(){E.tm=window.setTimeout(function(){E.loadedChars=""},700)}E.loadedChars=E.loadedChars+G;if(!E.tm){F()}else{clearTimeout(E.tm);F()}}function A(E){return !(this!==E.target&&(/textarea|select/i.test(E.target.nodeName)||E.target.type==="text"||E.target.type==="password"))}D.hotKeys={version:"0.8",specialKeys:{8:"backspace",9:"tab",13:"return",16:"shift",17:"ctrl",18:"alt",19:"pause",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"insert",46:"del",96:"0",97:"1",98:"2",91:"meta",99:"3",100:"4",101:"5",102:"6",103:"7",104:"8",105:"9",106:"*",107:"+",109:"-",110:".",111:"/",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12",144:"numlock",145:"scroll",188:",",190:".",191:"/",224:"meta",219:"[",221:"]"},keypressKeys:["<",">","?"],shiftNums:{"`":"~","1":"!","2":"@","3":"#","4":"$","5":"%","6":"^","7":"&","8":"*","9":"(","0":")","-":"_","=":"+",";":":","'":'"',",":"<",".":">","/":"?","\\":"|"}};D.each(D.hotKeys.keypressKeys,function(E,F){D.hotKeys.shiftNums[F]=F});function B(F){var E,G;if(typeof F.data!=="string"){return }E=F.handler;G=F.data.toLowerCase().split(" ");F.loadedChars="";D(this).bind("keydown",function(I){var H;if(!A(I)){return }H=D.hotKeys.specialKeys[I.which];if((H==="alt"||I.altKey)){C("alt+",F)}if((H==="ctrl"||I.ctrlKey)&&!/ctrl\+/.test(F.loadedChars)){C("ctrl+",F)}if(((H!=="ctrl"&&!I.ctrlKey)&&(H==="meta"||I.metaKey))&&!/meta\+/.test(F.loadedChars)){C("meta+",F)}});F.handler=function(K){var J,I,L,H;if(!A(K)){return }I=D.hotKeys.specialKeys[K.which];L=String.fromCharCode(K.which).toLowerCase();H={};if(I){H[I]=true}if(K.shiftKey){H[F.loadedChars+D.hotKeys.shiftNums[L]||I]=true}else{H[F.loadedChars+L]=true}for(J=0,l=G.length;J<l;J++){if(H[G[J]]){F.loadedChars="";return E.apply(this,arguments)}else{if(G[J].charAt(F.loadedChars.length)===L){C(L,F)}}}}}D.each(["keydown","keyup","keypress"],function(){D.event.special[this]={add:B}})})(jQuery);
if(typeof jQuery!="undefined"){var AJS=(function(){var E=[];function F(G){switch(G){case"<":return"&lt;";case">":return"&gt;";case"&":return"&amp;";case"'":return"&#39;";default:return"&quot;"}}var B=/[&"'<>]/g;var D={version:"3.5.2",params:{},$:jQuery,log:function(G){if(typeof console!="undefined"&&console.log){console.log(G)}},I18n:{getText:function(G){return G}},stopEvent:function(G){G.stopPropagation();return false},include:function(G){if(!this.contains(E,G)){E.push(G);var H=document.createElement("script");H.src=G;this.$("body").append(H)}},toggleClassName:function(G,H){if(!(G=this.$(G))){return }G.toggleClass(H)},setVisible:function(H,G){if(!(H=this.$(H))){return }var I=this.$;I(H).each(function(){var J=I(this).hasClass("hidden");if(J&&G){I(this).removeClass("hidden")}else{if(!J&&!G){I(this).addClass("hidden")}}})},setCurrent:function(G,H){if(!(G=this.$(G))){return }if(H){G.addClass("current")}else{G.removeClass("current")}},isVisible:function(G){return !this.$(G).hasClass("hidden")},populateParameters:function(){var G=this;this.$(".parameters input").each(function(){var H=this.value,I=this.title||this.id;if(G.$(this).hasClass("list")){if(G.params[I]){G.params[I].push(H)}else{G.params[I]=[H]}}else{G.params[I]=(H.match(/^(tru|fals)e$/i)?H.toLowerCase()=="true":H)}})},toInit:function(H){var G=this;this.$(function(){try{H.apply(this,arguments)}catch(I){G.log("Failed to run init function: "+I)}});return this},indexOf:function(K,J,H){var I=K.length;if(H==null){H=0}else{if(H<0){H=Math.max(0,I+H)}}for(var G=H;G<I;G++){if(K[G]===J){return G}}return -1},contains:function(H,G){return this.indexOf(H,G)>-1},format:function(I){var G=/^((?:(?:[^']*'){2})*?[^']*?)\{(\d+)\}/,H=/'(?!')/g;AJS.format=function(M){var K=arguments,L="",J=M.match(G);while(J){M=M.substring(J[0].length);L+=J[1].replace(H,"")+(K.length>++J[2]?K[J[2]]:"");J=M.match(G)}return L+=M.replace(H,"")};return AJS.format.apply(AJS,arguments)},firebug:function(){var G=this.$(document.createElement("script"));G.attr("src","http://getfirebug.com/releases/lite/1.2/firebug-lite-compressed.js");this.$("head").append(G);(function(){if(window.firebug){firebug.init()}else{setTimeout(arguments.callee,0)}})()},clone:function(G){return AJS.$(G).clone().removeAttr("id")},alphanum:function(N,M){N=(N+"").toLowerCase();M=(M+"").toLowerCase();var I=/(\d+|\D+)/g,J=N.match(I),G=M.match(I),L=Math.max(J.length,G.length);for(var H=0;H<L;H++){if(H==J.length){return -1}if(H==G.length){return 1}var O=parseInt(J[H],10),K=parseInt(G[H],10);if(O==J[H]&&K==G[H]&&O!=K){return(O-K)/Math.abs(O-K)}if((O!=J[H]||K!=G[H])&&J[H]!=G[H]){return J[H]<G[H]?-1:1}}return 0},dim:function(){if(AJS.dim.dim){AJS.dim.dim.remove();AJS.dim.dim=null}else{AJS.dim.dim=AJS("div").css({width:"100%",height:AJS.$(document).height(),background:"#000",opacity:0.5,position:"absolute",top:0,left:0});AJS.$("body").append(AJS.dim.dim)}},onTextResize:function(H){if(typeof H=="function"){if(AJS.onTextResize["on-text-resize"]){AJS.onTextResize["on-text-resize"].push(function(I){H(I)})}else{var G=AJS("div");G.css({width:"1em",height:"1em",position:"absolute",top:"-9999em",left:"-9999em"});this.$("body").append(G);G.size=G.width();setInterval(function(){if(G.size!=G.width()){G.size=G.width();for(var I=0,J=AJS.onTextResize["on-text-resize"].length;I<J;I++){AJS.onTextResize["on-text-resize"][I](G.size)}}},0);AJS.onTextResize.em=G;AJS.onTextResize["on-text-resize"]=[function(I){H(I)}]}}},unbindTextResize:function(I){for(var G=0,H=AJS.onTextResize["on-text-resize"].length;G<H;G++){if(AJS.onTextResize["on-text-resize"][G]==I){return AJS.onTextResize["on-text-resize"].splice(G,1)}}},escape:function(G){return escape(G).replace(/%u\w{4}/gi,function(H){return unescape(H)})},escapeHtml:function(G){return G.replace(B,F)},filterBySearch:function(K,P,Q){if(P==""){return[]}var I=this.$;var N=(Q&&Q.keywordsField)||"keywords";var M=(Q&&Q.ignoreForCamelCase)?"i":"";var J=(Q&&Q.matchBoundary)?"\\b":"";var H=(Q&&Q.splitRegex)||(/\s+/);var L=P.split(H);var G=[];I.each(L,function(){var S=[new RegExp(J+this,"i")];if(/^([A-Z][a-z]*){2,}$/.test(this)){var R=this.replace(/([A-Z][a-z]*)/g,"\\b$1[^,]*");S.push(new RegExp(R,M))}G.push(S)});var O=[];I.each(K,function(){for(var T=0;T<G.length;T++){var R=false;for(var S=0;S<G[T].length;S++){if(G[T][S].test(this[N])){R=true;break}}if(!R){return }}O.push(this)});return O},drawLogo:function(J){options={};options=AJS.$.extend(J,options);var N=options.scaleFactor||1,M=options.fill||"#fff",L=options.stroke||"#000",I=400*N,G=40*N;strokeWidth=options.strokeWidth||1;if(AJS.$(".aui-logo").size()==0){AJS.$("body").append("<div id='aui-logo' class='aui-logo'><div>")}strokeWidth=options.strokeWidth||1,containerID=options.containerID||".aui-logo";var H=Raphael(containerID,I+50*N,G+100*N);var K=H.path("M 0,0 c 3.5433333,-4.7243333 7.0866667,-9.4486667 10.63,-14.173 -14.173,0 -28.346,0 -42.519,0 C -35.432667,-9.4486667 -38.976333,-4.7243333 -42.52,0 -28.346667,0 -14.173333,0 0,0 z m 277.031,28.346 c -14.17367,0 -28.34733,0 -42.521,0 C 245.14,14.173 255.77,0 266.4,-14.173 c -14.17267,0 -28.34533,0 -42.518,0 C 213.25167,0 202.62133,14.173 191.991,28.346 c -14.17333,0 -28.34667,0 -42.52,0 14.17333,-18.8976667 28.34667,-37.7953333 42.52,-56.693 -7.08667,-9.448667 -14.17333,-18.897333 -21.26,-28.346 -14.173,0 -28.346,0 -42.519,0 7.08667,9.448667 14.17333,18.897333 21.26,28.346 -14.17333,18.8976667 -28.34667,37.7953333 -42.52,56.693 -14.173333,0 -28.346667,0 -42.52,0 10.63,-14.173 21.26,-28.346 31.89,-42.519 -14.390333,0 -28.780667,0 -43.171,0 C 42.520733,1.330715e-4 31.889933,14.174867 21.26,28.347 c -42.520624,6.24e-4 -85.039187,-8.13e-4 -127.559,-0.001 11.220667,-14.961 22.441333,-29.922 33.662,-44.883 -6.496,-8.661 -12.992,-17.322 -19.488,-25.983 5.905333,0 11.810667,0 17.716,0 -10.63,-14.173333 -21.26,-28.346667 -31.89,-42.52 14.173333,0 28.346667,0 42.52,0 10.63,14.173333 21.26,28.346667 31.89,42.52 14.173333,0 28.3466667,0 42.52,0 -10.63,-14.173333 -21.26,-28.346667 -31.89,-42.52 14.1733333,0 28.3466667,0 42.52,0 10.63,14.173333 21.26,28.346667 31.89,42.52 14.390333,0 28.780667,0 43.171,0 -10.63,-14.173333 -21.26,-28.346667 -31.89,-42.52 42.51967,0 85.03933,0 127.559,0 10.63033,14.173333 21.26067,28.346667 31.891,42.52 14.17267,0 28.34533,0 42.518,0 -10.63,-14.173333 -21.26,-28.346667 -31.89,-42.52 14.17367,0 28.34733,0 42.521,0 14.17333,18.897667 28.34667,37.795333 42.52,56.693 -14.17333,18.8976667 -28.34667,37.7953333 -42.52,56.693 z");console.log(G);K.scale(N,-N,0,0);K.translate(120*N,G);K.attr("fill",M);K.attr("stroke",L);K.attr("stroke-width",strokeWidth)}};if(typeof AJS!="undefined"){for(var C in AJS){D[C]=AJS[C]}}var A=function(){var G=null;if(arguments.length&&typeof arguments[0]=="string"){G=arguments.callee.$(document.createElement(arguments[0]));if(arguments.length==2){G.html(arguments[1])}}return G};for(var C in D){A[C]=D[C]}return A})();AJS.$(function(){AJS.populateParameters()})}if(typeof console=="undefined"){console={messages:[],log:function(A){this.messages.push(A)},show:function(){alert(this.messages.join("\n"));this.messages=[]}}}else{console.show=function(){}}AJS.$.ajaxSettings.traditional=true;
AJS=AJS||{};(function(){var A=false;AJS.contextPath=function(){var B=null;var D=[A,window.contextPath,window.Confluence&&Confluence.getContextPath(),window.BAMBOO&&BAMBOO.contextPath,window.FECRU&&FECRU.pageContext];for(var C=0;C<D.length;C++){if(typeof D[C]==="string"){B=D[C];break}}return B}})();
AJS.bind=function(A,C,B){try{return jQuery(window).bind(A,C,B)}catch(D){AJS.log("error while binding: "+D.message)}};AJS.unbind=function(A,B){try{return jQuery(window).unbind(A,B)}catch(C){AJS.log("error while unbinding: "+C.message)}};AJS.trigger=function(A,C){try{return jQuery(window).trigger(A,C)}catch(B){AJS.log("error while triggering: "+B.message)}};
(function(){var E="AJS.conglomerate.cookie";function B(F,I){I=I||"";var H=new RegExp(F+"=([^|]+)"),G=I.match(H);return G&&G[1]}function A(F,H,J){var G=new RegExp("\\s*"+F+"=[^|]+(\\||$)");J=J||"";J=J.replace(G,"")+(J?"|":"");if(H){var I=F+"="+H;if(J.length+I.length<4020){J+=I}}return J}function D(F){var H=new RegExp(F+"=([^;]+)"),G=document.cookie.match(H);return G&&G[1]}function C(F,H,J){var G="";if(J){var I=new Date();I.setTime(+I+J*24*60*60*1000);G="; expires="+I.toGMTString()}document.cookie=F+"="+H+G+";path=/"}AJS.Cookie={save:function(G,H,F){var I=D(E);I=A(G,H,I);C(E,I,F||365)},read:function(G,F){var I=D(E);var H=B(G,I);if(H!=null){return H}return F},erase:function(F){this.save(F,"")}}})();
AJS.dim=function(A){if(!AJS.dim.dim){AJS.dim.dim=AJS("div").addClass("aui-blanket");if(AJS.$.browser.msie){AJS.dim.dim.css({width:"200%",height:Math.max(AJS.$(document).height(),AJS.$(window).height())+"px"})}AJS.$("body").append(AJS.dim.dim);if(AJS.$.browser.msie&&typeof AJS.hasFlash==="undefined"&&A===false){AJS.hasFlash=false;AJS.$("object, embed, iframe").each(function(){if(this.nodeName.toLowerCase()==="iframe"){if(AJS.$(this).contents().find("object, embed").length){AJS.hasFlash=true;return false}}else{AJS.hasFlash=true;return false}})}if(AJS.$.browser.msie&&(A!==false||AJS.hasFlash)){AJS.dim.shim=AJS.$('<iframe frameBorder="0" class="aui-blanket-shim" src="javascript:false;"/>');AJS.dim.shim.css({height:Math.max(AJS.$(document).height(),AJS.$(window).height())+"px"});AJS.$("body").append(AJS.dim.shim)}if(AJS.$.browser.msie&&parseInt(AJS.$.browser.version,10)<8){AJS.dim.cachedOverflow=AJS.$("html").css("overflow");AJS.$("html").css("overflow","hidden")}else{AJS.dim.cachedOverflow=AJS.$("body").css("overflow");AJS.$("body").css("overflow","hidden")}}};AJS.undim=function(){if(AJS.dim.dim){AJS.dim.dim.remove();AJS.dim.dim=null;if(AJS.dim.shim){AJS.dim.shim.remove()}if(AJS.$.browser.msie&&parseInt(AJS.$.browser.version,10)<8){AJS.$("html").css("overflow",AJS.dim.cachedOverflow)}else{AJS.$("body").css("overflow",AJS.dim.cachedOverflow)}if(AJS.$.browser.safari){var A=AJS.$(window).scrollTop();AJS.$(window).scrollTop(10+5*(A==10)).scrollTop(A)}}};AJS.popup=function(I){var D={width:800,height:600,closeOnOutsideClick:false,keypressListener:function(J){if(J.keyCode===27&&B.is(":visible")){F.hide()}}};if(typeof I!="object"){I={width:arguments[0],height:arguments[1],id:arguments[2]};I=AJS.$.extend({},I,arguments[3])}I=AJS.$.extend({},D,I);var B=AJS("div").addClass("aui-popup");if(I.id){B.attr("id",I.id)}var E=3000;AJS.$(".aui-dialog").each(function(){var J=AJS.$(this);E=(J.css("z-index")>E)?J.css("z-index"):E});var G=(function(K,J){I.width=(K=(K||I.width));I.height=(J=(J||I.height));B.css({marginTop:-Math.round(J/2)+"px",marginLeft:-Math.round(K/2)+"px",width:K,height:J,background:"#fff","z-index":parseInt(E,10)+2});return arguments.callee})(I.width,I.height);AJS.$("body").append(B);B.hide();B.enable();var C=AJS.$(".aui-blanket"),A=function(N){var O=false,K=AJS.$(":input:visible:enabled:first",N),J=N.children(":visible");if(K.length&&K[0].tabIndex>=0){K.focus();return O=true}if(N.length&&N[0].tabIndex>=0){N.focus();return O=true}for(var L=0,M=J.length;L<M;L++){O=A(jQuery(J[L]));if(O){break}}return O},H=function(J){if(A(AJS.$(".dialog-page-body",J))){return }if(A(AJS.$(".dialog-button-panel",J))){return }A(AJS.$(".dialog-page-menu",J))};var F={changeSize:function(J,K){if((J&&J!=I.width)||(K&&K!=I.height)){G(J,K);if(this.shadow){this.shadow.remove();this.shadow=null}}this.show()},show:function(){var J=function(){var K=5;if(AJS.$.browser.msie&&~~(AJS.$.browser.version)<9){K=3}AJS.$(document).keydown(I.keypressListener);AJS.dim();C=AJS.$(".aui-blanket");if(C.size()!=0&&I.closeOnOutsideClick){C.click(function(){if(B.is(":visible")){F.hide()}})}B.show();if(!this.shadow){var L=B.offset();this.shadow=Raphael.shadow(L.top,L.left,I.width,I.height,{target:B[0],zindex:(B.css("z-index")-1)});this.shadow.css({position:"fixed",top:"50%",left:"50%",marginLeft:-(I.width/2-K)+"px",marginTop:-(I.height/2-K)+"px"})}AJS.popup.current=this;H(B);AJS.$(document).trigger("showLayer",["popup",this])};J.call(this);this.show=J},hide:function(){AJS.$(document).unbind("keydown",I.keypressListener);C.unbind();this.element.hide();if(this.shadow){this.shadow.remove();this.shadow=null}if(AJS.$(".aui-dialog:visible").size()==0){AJS.undim()}AJS.$(document).trigger("hideLayer",["popup",this]);AJS.popup.current=null;this.enable()},element:B,remove:function(){if(this.shadow){this.shadow.remove();this.shadow=null;this.shadowParent.remove();this.shadowParent=null}B.remove();this.element=null},disable:function(){if(!this.disabled){this.popupBlanket=AJS.$("<div class='dialog-blanket'> </div>").css({height:B.height(),width:B.width()});B.append(this.popupBlanket);this.disabled=true}},enable:function(){if(this.disabled){this.disabled=false;this.popupBlanket.remove();this.popupBlanket=null}}};return F};(function(){function A(J,H,G,I){if(!J.buttonpanel){J.addButtonPanel()}this.page=J;this.onclick=G;this._onclick=function(){return G.call(this,J.dialog,J)===true};this.item=AJS("button",H).addClass("button-panel-button");if(I){this.item.addClass(I)}if(typeof G=="function"){this.item.click(this._onclick)}J.buttonpanel.append(this.item);this.id=J.button.length;J.button[this.id]=this}function B(K,I,H,J,G){if(!K.buttonpanel){K.addButtonPanel()}if(!G){G="#"}this.page=K;this.onclick=H;this._onclick=function(){return H.call(this,K.dialog,K)===true};this.item=AJS("a",I).attr("href",G).addClass("button-panel-link");if(J){this.item.addClass(J)}if(typeof H=="function"){this.item.click(this._onclick)}K.buttonpanel.append(this.item);this.id=K.button.length;K.button[this.id]=this}function D(I,H){var G=I=="left"?-1:1;return function(M){var K=this.page[H];if(this.id!=((G==1)?K.length-1:0)){G*=(M||1);K[this.id+G].item[(G<0?"before":"after")](this.item);K.splice(this.id,1);K.splice(this.id+G,0,this);for(var J=0,L=K.length;J<L;J++){if(H=="panel"&&this.page.curtab==K[J].id){this.page.curtab=J}K[J].id=J}}return this}}function F(G){return function(){this.page[G].splice(this.id,1);for(var H=0,I=this.page[G].length;H<I;H++){this.page[G][H].id=H}this.item.remove()}}A.prototype.moveUp=A.prototype.moveLeft=D("left","button");A.prototype.moveDown=A.prototype.moveRight=D("right","button");A.prototype.remove=F("button");A.prototype.html=function(G){return this.item.html(G)};A.prototype.onclick=function(G){if(typeof G=="undefined"){return this.onclick}else{this.item.unbind("click",this._onclick);this._onclick=function(){return G.call(this,page.dialog,page)===true};if(typeof G=="function"){this.item.click(this._onclick)}}};var E=function(M,N,G,L,J){if(!(G instanceof AJS.$)){G=AJS.$(G)}this.dialog=M.dialog;this.page=M;this.id=M.panel.length;this.button=AJS("button").html(N).addClass("item-button");if(J){this.button[0].id=J}this.item=AJS("li").append(this.button).addClass("page-menu-item");this.body=AJS("div").append(G).addClass("dialog-panel-body").css("height",M.dialog.height+"px");this.padding=10;if(L){this.body.addClass(L)}var I=M.panel.length,K=this;M.menu.append(this.item);M.body.append(this.body);M.panel[I]=this;var H=function(){var O;if(M.curtab+1){O=M.panel[M.curtab];O.body.hide();O.item.removeClass("selected");(typeof O.onblur=="function")&&O.onblur()}M.curtab=K.id;K.body.show();K.item.addClass("selected");(typeof K.onselect=="function")&&K.onselect();(typeof M.ontabchange=="function")&&M.ontabchange(K,O)};if(!this.button.click){AJS.log("atlassian-dialog:Panel:constructor - this.button.click false");this.button.onclick=H}else{this.button.click(H)}H();if(I==0){M.menu.css("display","none")}else{M.menu.show()}};E.prototype.select=function(){this.button.click()};E.prototype.moveUp=E.prototype.moveLeft=D("left","panel");E.prototype.moveDown=E.prototype.moveRight=D("right","panel");E.prototype.remove=F("panel");E.prototype.html=function(G){if(G){this.body.html(G);return this}else{return this.body.html()}};E.prototype.setPadding=function(G){if(!isNaN(+G)){this.body.css("padding",+G);this.padding=+G;this.page.recalcSize()}return this};var C=function(G,H){this.dialog=G;this.id=G.page.length;this.element=AJS("div").addClass("dialog-components");this.body=AJS("div").addClass("dialog-page-body");this.menu=AJS("ul").addClass("dialog-page-menu").css("height",G.height+"px");this.body.append(this.menu);this.curtab;this.panel=[];this.button=[];if(H){this.body.addClass(H)}G.popup.element.append(this.element.append(this.menu).append(this.body));G.page[G.page.length]=this};C.prototype.recalcSize=function(){var G=this.header?43:0;var J=this.buttonpanel?43:0;for(var I=this.panel.length;I--;){var H=this.dialog.height-G-J;this.panel[I].body.css("height",H-this.panel[I].padding*2);this.menu.css("height",H-parseFloat(this.menu.css("padding-top")))}};C.prototype.addButtonPanel=function(){this.buttonpanel=AJS("div").addClass("dialog-button-panel");this.element.append(this.buttonpanel)};C.prototype.addPanel=function(J,G,I,H){new E(this,J,G,I,H);this.recalcSize();return this};C.prototype.addHeader=function(H,G){if(this.header){this.header.remove()}this.header=AJS("h2").html(H||"").addClass("dialog-title");G&&this.header.addClass(G);this.element.prepend(this.header);this.recalcSize();return this};C.prototype.addButton=function(H,G,I){new A(this,H,G,I);this.recalcSize();return this};C.prototype.addLink=function(I,H,J,G){new B(this,I,H,J,G);this.recalcSize();return this};C.prototype.gotoPanel=function(G){this.panel[G.id||G].select()};C.prototype.getCurrentPanel=function(){return this.panel[this.curtab]};C.prototype.hide=function(){this.element.hide()};C.prototype.show=function(){this.element.show()};C.prototype.remove=function(){this.element.remove()};AJS.Dialog=function(I,G,J){var H={};if(!+I){H=Object(I);I=H.width;G=H.height;J=H.id}this.height=G||480;this.width=I||640;this.id=J;H=AJS.$.extend({},H,{width:this.width,height:this.height,id:this.id});this.popup=AJS.popup(H);this.popup.element.addClass("aui-dialog");this.page=[];this.curpage=0;new C(this)};AJS.Dialog.prototype.addHeader=function(H,G){this.page[this.curpage].addHeader(H,G);return this};AJS.Dialog.prototype.addButton=function(H,G,I){this.page[this.curpage].addButton(H,G,I);return this};AJS.Dialog.prototype.addLink=function(I,H,J,G){this.page[this.curpage].addLink(I,H,J,G);return this};AJS.Dialog.prototype.addSubmit=function(H,G){this.page[this.curpage].addButton(H,G,"button-panel-submit-button");return this};AJS.Dialog.prototype.addCancel=function(H,G){this.page[this.curpage].addLink(H,G,"button-panel-cancel-link");return this};AJS.Dialog.prototype.addButtonPanel=function(){this.page[this.curpage].addButtonPanel();return this};AJS.Dialog.prototype.addPanel=function(J,G,I,H){this.page[this.curpage].addPanel(J,G,I,H);return this};AJS.Dialog.prototype.addPage=function(G){new C(this,G);this.page[this.curpage].hide();this.curpage=this.page.length-1;return this};AJS.Dialog.prototype.nextPage=function(){this.page[this.curpage++].hide();if(this.curpage>=this.page.length){this.curpage=0}this.page[this.curpage].show();return this};AJS.Dialog.prototype.prevPage=function(){this.page[this.curpage--].hide();if(this.curpage<0){this.curpage=this.page.length-1}this.page[this.curpage].show();return this};AJS.Dialog.prototype.gotoPage=function(G){this.page[this.curpage].hide();this.curpage=G;if(this.curpage<0){this.curpage=this.page.length-1}else{if(this.curpage>=this.page.length){this.curpage=0}}this.page[this.curpage].show();return this};AJS.Dialog.prototype.getPanel=function(H,I){var G=(I==null)?this.curpage:H;if(I==null){I=H}return this.page[G].panel[I]};AJS.Dialog.prototype.getPage=function(G){return this.page[G]};AJS.Dialog.prototype.getCurrentPanel=function(){return this.page[this.curpage].getCurrentPanel()};AJS.Dialog.prototype.gotoPanel=function(I,H){if(H!=null){var G=I.id||I;this.gotoPage(G)}this.page[this.curpage].gotoPanel(typeof H=="undefined"?I:H)};AJS.Dialog.prototype.show=function(){this.popup.show();AJS.trigger("show.dialog",{dialog:this});return this};AJS.Dialog.prototype.hide=function(){this.popup.hide();AJS.trigger("hide.dialog",{dialog:this});return this};AJS.Dialog.prototype.remove=function(){this.popup.hide();this.popup.remove();AJS.trigger("remove.dialog",{dialog:this})};AJS.Dialog.prototype.disable=function(){this.popup.disable();return this};AJS.Dialog.prototype.enable=function(){this.popup.enable();return this};AJS.Dialog.prototype.get=function(O){var H=[],N=this;var P='#([^"][^ ]*|"[^"]*")';var Q=":(\\d+)";var I="page|panel|button|header";var J="(?:("+I+")(?:"+P+"|"+Q+")?|"+P+")";var L=new RegExp("(?:^|,)\\s*"+J+"(?:\\s+"+J+")?\\s*(?=,|$)","ig");(O+"").replace(L,function(b,R,a,S,Y,X,U,c,Z){R=R&&R.toLowerCase();var T=[];if(R=="page"&&N.page[S]){T.push(N.page[S]);R=X;R=R&&R.toLowerCase();a=U;S=c;Y=Z}else{T=N.page}a=a&&(a+"").replace(/"/g,"");U=U&&(U+"").replace(/"/g,"");Y=Y&&(Y+"").replace(/"/g,"");Z=Z&&(Z+"").replace(/"/g,"");if(R||Y){for(var W=T.length;W--;){if(Y||(R=="panel"&&(a||(!a&&S==null)))){for(var V=T[W].panel.length;V--;){if(T[W].panel[V].button.html()==Y||T[W].panel[V].button.html()==a||(R=="panel"&&!a&&S==null)){H.push(T[W].panel[V])}}}if(Y||(R=="button"&&(a||(!a&&S==null)))){for(var V=T[W].button.length;V--;){if(T[W].button[V].item.html()==Y||T[W].button[V].item.html()==a||(R=="button"&&!a&&S==null)){H.push(T[W].button[V])}}}if(T[W][R]&&T[W][R][S]){H.push(T[W][R][S])}if(R=="header"&&T[W].header){H.push(T[W].header)}}}else{H=H.concat(T)}});var M={length:H.length};for(var K=H.length;K--;){M[K]=H[K];for(var G in H[K]){if(!(G in M)){(function(R){M[R]=function(){for(var S=this.length;S--;){if(typeof this[S][R]=="function"){this[S][R].apply(this[S],arguments)}}}})(G)}}}return M};AJS.Dialog.prototype.updateHeight=function(){var G=0;for(var H=0;this.getPanel(H);H++){if(this.getPanel(H).body.css({height:"auto",display:"block"}).outerHeight()>G){G=this.getPanel(H).body.outerHeight()}if(H!==this.page[this.curpage].curtab){this.getPanel(H).body.css({display:"none"})}}for(H=0;this.getPanel(H);H++){this.getPanel(H).body.css({height:G||this.height})}this.page[0].menu.height(G);this.height=G+87;this.popup.changeSize(undefined,G+87)};AJS.Dialog.prototype.getCurPanel=function(){return this.getPanel(this.page[this.curpage].curtab)};AJS.Dialog.prototype.getCurPanelButton=function(){return this.getCurPanel().button}})();
AJS.dropDown=function(L,E){var U=null,I=[],Q=false,H=AJS.$(document),C={item:"li:has(a)",activeClass:"active",alignment:"right",displayHandler:function(W){return W.name},escapeHandler:function(){this.hide("escape");return false},hideHandler:function(){},moveHandler:function(X,W){},useDisabled:false};AJS.$.extend(C,E);C.alignment={left:"left",right:"right"}[C.alignment.toLowerCase()]||"left";if(L&&L.jquery){U=L}else{if(typeof L=="string"){U=AJS.$(L)}else{if(L&&L.constructor==Array){U=AJS("div").addClass("aui-dropdown").toggleClass("hidden",!!C.isHiddenByDefault);for(var P=0,K=L.length;P<K;P++){var J=AJS("ol");for(var O=0,S=L[P].length;O<S;O++){var M=AJS("li");var G=L[P][O];if(G.href){M.append(AJS("a").html("<span>"+C.displayHandler(G)+"</span>").attr({href:G.href}).addClass(G.className));AJS.$.data(AJS.$("a > span",M)[0],"properties",G)}else{M.html(G.html).addClass(G.className)}if(G.icon){M.prepend(AJS("img").attr("src",G.icon))}if(G.insideSpanIcon){M.children("a").prepend(AJS("span").attr("class","icon"))}AJS.$.data(M[0],"properties",G);J.append(M)}if(P==K-1){J.addClass("last")}U.append(J)}AJS.$("body").append(U)}else{throw new Error("AJS.dropDown function was called with illegal parameter. Should be AJS.$ object, AJS.$ selector or array.")}}}var F=function(){N(+1)};var T=function(){N(-1)};var N=function(Z){var Y=!Q,W=AJS.dropDown.current.$[0],X=AJS.dropDown.current.links,a=W.focused;Q=true;W.focused=(typeof W.focused=="number"?W.focused:-1);if(!AJS.dropDown.current){AJS.log("move - not current, aborting");return true}W.focused=W.focused+Z;if(W.focused<0){W.focused=X.length-1}if(W.focused>X.length-1){W.focused=0}C.moveHandler(AJS.$(X[W.focused]),Z<0?"up":"down");if(Y&&X.length){AJS.$(X[W.focused]).addClass(C.activeClass);Q=false}else{if(!X.length){Q=false}}};var V=function(Y){if(!AJS.dropDown.current){return true}var Z=Y.which,W=AJS.dropDown.current.$[0],X=AJS.dropDown.current.links;AJS.dropDown.current.cleanActive();switch(Z){case 40:F();break;case 38:T();break;case 27:return C.escapeHandler.call(AJS.dropDown.current,Y);case 13:if(W.focused>=0){if(!C.selectionHandler){if(AJS.$(X[W.focused]).attr("nodeName")!="a"){return AJS.$("a",X[W.focused]).trigger("focus")}else{return AJS.$(X[W.focused]).trigger("focus")}}else{return C.selectionHandler.call(AJS.dropDown.current,Y,AJS.$(X[W.focused]))}}return true;default:if(X.length){AJS.$(X[W.focused]).addClass(C.activeClass)}return true}Y.stopPropagation();Y.preventDefault();return false};var A=function(W){if(!((W&&W.which&&(W.which==3))||(W&&W.button&&(W.button==2))||false)){if(AJS.dropDown.current){AJS.dropDown.current.hide("click")}}};var D=function(W){return function(){if(!AJS.dropDown.current){return }AJS.dropDown.current.cleanFocus();this.originalClass=this.className;AJS.$(this).addClass(C.activeClass);AJS.dropDown.current.$[0].focused=W}};var R=function(W){if(W.button||W.metaKey||W.ctrlKey||W.shiftKey){return true}if(AJS.dropDown.current&&C.selectionHandler){C.selectionHandler.call(AJS.dropDown.current,W,AJS.$(this))}};var B=function(X){var W=false;if(X.data("events")){AJS.$.each(X.data("events"),function(Y,Z){AJS.$.each(Z,function(b,a){if(R===a){W=true;return false}})})}return W};U.each(function(){var W=this,Y=AJS.$(this),Z;var X={reset:function(){Z=AJS.$.extend(Z||{},{$:Y,links:AJS.$(C.item||"li:has(a)",W),cleanActive:function(){if(W.focused+1&&Z.links.length){AJS.$(Z.links[W.focused]).removeClass(C.activeClass)}},cleanFocus:function(){Z.cleanActive();W.focused=-1},moveDown:F,moveUp:T,moveFocus:V,getFocusIndex:function(){return(typeof W.focused=="number")?W.focused:-1}});Z.links.each(function(a){var b=AJS.$(this);if(!B(b)){b.hover(D(a),Z.cleanFocus);b.click(R)}});return arguments.callee}(),appear:function(a){if(a){Y.removeClass("hidden");Y.addClass("aui-dropdown-"+C.alignment)}else{Y.addClass("hidden")}},fade:function(a){if(a){Y.fadeIn("fast")}else{Y.fadeOut("fast")}},scroll:function(a){if(a){Y.slideDown("fast")}else{Y.slideUp("fast")}}};Z.addControlProcess=function(b,a){AJS.$.aop.around({target:this,method:b},a)};Z.addCallback=function(b,a){return AJS.$.aop.after({target:this,method:b},a)};Z.reset=X.reset();Z.show=function(a){if(C.useDisabled&&this.$.closest(".aui-dd-parent").hasClass("disabled")){return }this.alignment=C.alignment;A();AJS.dropDown.current=this;this.method=a||this.method||"appear";this.timer=setTimeout(function(){H.click(A)},0);H.keydown(V);if(C.firstSelected&&this.links[0]){D(0).call(this.links[0])}AJS.$(W.offsetParent).css({zIndex:2000});X[this.method](true);AJS.$(document).trigger("showLayer",["dropdown",AJS.dropDown.current])};Z.hide=function(a){this.method=this.method||"appear";AJS.$(Y.get(0).offsetParent).css({zIndex:""});this.cleanFocus();X[this.method](false);H.unbind("click",A).unbind("keydown",V);AJS.$(document).trigger("hideLayer",["dropdown",AJS.dropDown.current]);AJS.dropDown.current=null;return a};Z.addCallback("reset",function(){if(C.firstSelected&&this.links[0]){D(0).call(this.links[0])}});if(!AJS.dropDown.iframes){AJS.dropDown.iframes=[]}AJS.dropDown.createShims=function(){AJS.$("iframe").each(function(a){var b=this;if(!b.shim){b.shim=AJS.$("<div />").addClass("shim hidden").appendTo("body");AJS.dropDown.iframes.push(b)}});return arguments.callee}();Z.addCallback("show",function(){AJS.$(AJS.dropDown.iframes).each(function(){var a=AJS.$(this);if(a.is(":visible")){var b=a.offset();b.height=a.height();b.width=a.width();this.shim.css({left:b.left+"px",top:b.top+"px",height:b.height+"px",width:b.width+"px"}).removeClass("hidden")}})});Z.addCallback("hide",function(){AJS.$(AJS.dropDown.iframes).each(function(){this.shim.addClass("hidden")});C.hideHandler()});(function(){var a=function(){var b=this.$.offset();if(this.shadow){this.shadow.remove()}if(this.$.is(":visible")){this.shadow=Raphael.shadow(0,0,this.$.outerWidth(true),this.$.outerHeight(true),{target:this.$[0]})}};Z.addCallback("reset",a);Z.addCallback("show",a);Z.addCallback("hide",function(){if(this.shadow){this.shadow.remove()}})})();if(AJS.$.browser.msie){(function(){var a=function(){if(this.$.is(":visible")){if(!this.iframeShim){this.iframeShim=AJS.$('<iframe class="dropdown-shim" src="javascript:false;" frameBorder="0" />').insertBefore(this.$)}this.iframeShim.css({display:"block",top:this.$.css("top"),width:this.$.outerWidth()+"px",height:this.$.outerHeight()+"px"});if(C.alignment=="left"){this.iframeShim.css({left:"0px"})}else{this.iframeShim.css({right:"0px"})}}};Z.addCallback("reset",a);Z.addCallback("show",a);Z.addCallback("hide",function(){if(this.iframeShim){this.iframeShim.css({display:"none"})}})})()}I.push(Z)});return I};AJS.dropDown.getAdditionalPropertyValue=function(D,A){var C=D[0];if(!C||(typeof C.tagName!="string")||C.tagName.toLowerCase()!="li"){AJS.log("AJS.dropDown.getAdditionalPropertyValue : item passed in should be an LI element wrapped by jQuery")}var B=AJS.$.data(C,"properties");return B?B[A]:null};AJS.dropDown.removeAllAdditionalProperties=function(A){};AJS.dropDown.Standard=function(H){var C=[],G,B={selector:".aui-dd-parent",dropDown:".aui-dropdown",trigger:".aui-dd-trigger"};AJS.$.extend(B,H);var F=function(I,L,K,J){AJS.$.extend(J,{trigger:I});L.addClass("dd-allocated");K.addClass("hidden");if(B.isHiddenByDefault==false){J.show()}J.addCallback("show",function(){L.addClass("active")});J.addCallback("hide",function(){L.removeClass("active")})};var A=function(K,I,L,J){if(J!=AJS.dropDown.current){L.css({top:I.outerHeight()});J.show();K.stopImmediatePropagation()}K.preventDefault()};if(B.useLiveEvents){var D=[];var E=[];AJS.$(B.trigger).live("click",function(L){var I=AJS.$(this);var N,M,J;var K;if((K=AJS.$.inArray(this,D))>=0){var O=E[K];N=O.parent;M=O.dropdown;J=O.ddcontrol}else{N=I.closest(B.selector);M=N.find(B.dropDown);if(M.length===0){return }J=AJS.dropDown(M,B)[0];if(!J){return }D.push(this);O={parent:N,dropdown:M,ddcontrol:J};F(I,N,M,J);E.push(O)}A(L,I,M,J)})}else{if(this instanceof AJS.$){G=this}else{G=AJS.$(B.selector)}G=G.not(".dd-allocated").filter(":has("+B.dropDown+")").filter(":has("+B.trigger+")");G.each(function(){var L=AJS.$(this),K=AJS.$(B.dropDown,this),I=AJS.$(B.trigger,this),J=AJS.dropDown(K,B)[0];AJS.$.extend(J,{trigger:I});F(I,L,K,J);I.click(function(M){A(M,I,K,J)});C.push(J)})}return C};AJS.dropDown.Ajax=function(C){var B,A={cache:true};AJS.$.extend(A,C||{});B=AJS.dropDown.Standard.call(this,A);AJS.$(B).each(function(){var D=this;AJS.$.extend(D,{getAjaxOptions:function(E){var F=function(G){if(A.formatResults){G=A.formatResults(G)}if(A.cache){D.cache.set(D.getAjaxOptions(),G)}D.refreshSuccess(G)};if(A.ajaxOptions){if(AJS.$.isFunction(A.ajaxOptions)){return AJS.$.extend(A.ajaxOptions.call(D),{success:F})}else{return AJS.$.extend(A.ajaxOptions,{success:F})}}return AJS.$.extend(E,{success:F})},refreshSuccess:function(E){this.$.html(E)},cache:function(){var E={};return{get:function(F){var G=F.data||"";return E[(F.url+G).replace(/[\?\&]/gi,"")]},set:function(F,G){var H=F.data||"";E[(F.url+H).replace(/[\?\&]/gi,"")]=G},reset:function(){E={}}}}(),show:function(E){return function(F){if(A.cache&&!!D.cache.get(D.getAjaxOptions())){D.refreshSuccess(D.cache.get(D.getAjaxOptions()));E.call(D)}else{AJS.$(AJS.$.ajax(D.getAjaxOptions())).throbber({target:D.$,end:function(){D.reset()}});E.call(D);D.shadow.hide();if(D.iframeShim){D.iframeShim.hide()}}}}(D.show),resetCache:function(){D.cache.reset()}});D.addCallback("refreshSuccess",function(){D.reset()})});return B};AJS.$.fn.dropDown=function(B,A){B=(B||"Standard").replace(/^([a-z])/,function(C){return C.toUpperCase()});return AJS.dropDown[B].call(this,A)};
(function(){AJS.icons=AJS.icons||{};AJS.icons.addIcon=function(B,C){AJS.icons[B]=function(E,D){return A(C,E,D)}};AJS.icons.addIcon.init=function(){var D=this.className.split(" "),B=D.length,C=this.className.match(/(^|\s)size-(\d+)(\s|$)/);C=C&&+C[2];while(B--){if(D[B]!="addIcon"&&D[B] in AJS.icons){AJS.icons[D[B]](this,C)}}};function A(E,C,B){B=B||24;var D=Raphael([C,B+1,B+1].concat(E));D.scale(B/24,B/24,0,0)}})();AJS.$(function(){AJS.$(".svg-icon").each(AJS.icons.addIcon.init)});AJS.icons.addIcon("generic",[{stroke:"none",fill:"#999",type:"path",path:"M22.465,8.464c1.944,1.944,1.944,5.126,0,7.07l-6.93,6.93c-1.944,1.945-5.126,1.945-7.07,0l-6.929-6.93c-1.945-1.943-1.945-5.125,0-7.07l6.929-6.93c1.944-1.944,5.126-1.944,7.07,0L22.465,8.464z"},{type:"path",stroke:"none",fill:"90-#999996-#a1a19f:20-#b8b8b7:70-#ccc",path:"M9.172,2.242L9.172,2.242l-6.929,6.93C1.491,9.923,1.077,10.927,1.077,12c0,1.072,0.414,2.076,1.166,2.828l6.929,6.93c0.751,0.752,1.756,1.166,2.828,1.166s2.076-0.414,2.828-1.166l6.93-6.93c0.751-0.752,1.165-1.756,1.165-2.828c0-1.072-0.414-2.076-1.165-2.828l-6.93-6.93C13.269,0.682,10.731,0.682,9.172,2.242z"},{type:"path",stroke:"none",fill:"270-#999996-#a1a19f:20-#b8b8b7:70-#ccc",path:"M7.181,5.869 7.181,17.95 16.974,17.95 16.974,9.205 13.638,5.869"},{type:"path",stroke:"none",fill:"#fff",path:"M12.724,9.619v-2.75H8.181V16.95h7.793v-6.832h-2.75C12.946,10.119,12.724,9.894,12.724,9.619zM13.724,7.369c0,0.521,0,1.32,0,1.75c0.428,0,1.229,0,1.75,0L13.724,7.369z"}]);AJS.icons.addIcon("error",[{type:"path",stroke:"none",fill:"#c00",path:"M7.857,22L2,16.143 2,7.857 7.857,1.999 16.143,1.999 22,7.857 22,16.143 16.143,22z"},{type:"path",stroke:"none",fill:"90-#c00-#d50909-#ed2121-#f33",path:"M8.271,2.999C7.771,3.5,3.501,7.77,3,8.271c0,0.708,0,6.748,0,7.457c0.501,0.5,4.771,4.77,5.271,5.271c0.708,0,6.749,0,7.457,0c0.501-0.502,4.771-4.771,5.271-5.271c0-0.709,0-6.749,0-7.457c-0.501-0.501-4.771-4.771-5.271-5.272C15.021,2.999,8.979,2.999,8.271,2.999z"},{type:"rect",x:5.318,y:9.321,fill:"270-#c00-#d50909-#ed2121-#f33",stroke:"none",width:13.363,height:5.356},{type:"rect",x:6.318,y:10.321,fill:"#fff",stroke:"none",width:11.363,height:3.356}]);AJS.icons.addIcon("success",[{type:"path",stroke:"none",path:"M22,18.801C22,20.559,20.561,22,18.799,22H5.201C3.439,22,2,20.559,2,18.801V5.199C2,3.44,3.439,2,5.201,2h13.598C20.561,2,22,3.44,22,5.199V18.801z",fill:"#393"},{type:"path",path:"M5.201,3C3.987,3,3,3.986,3,5.199v13.602C3,20.014,3.987,21,5.201,21h13.598C20.013,21,21,20.014,21,18.801V5.199C21,3.986,20.013,3,18.799,3H5.201z",stroke:"none",fill:"90-#393-#33a23c-#3c6"},{type:"path",path:"M10.675,12.158c-0.503-0.57-1.644-1.862-1.644-1.862l-3.494,2.833l3.663,5.313l4.503,1.205L17.73,4.624l-4.361-0.056C13.369,4.568,11.424,10.047,10.675,12.158z",stroke:"none",fill:"270-#393-#33a23c-#3c6"},{type:"path",path:"M14.072,5.577 11.05,14.092 8.917,11.677 6.886,13.324 9.815,17.57 12.997,18.422 16.432,5.607",stroke:"none",fill:"#fff"}]);AJS.icons.addIcon("hint",[{type:"path",path:"M22.465,8.464c1.944,1.944,1.944,5.126,0,7.07l-6.93,6.93c-1.944,1.945-5.126,1.945-7.07,0l-6.929-6.93c-1.945-1.943-1.945-5.125,0-7.07l6.929-6.93c1.944-1.944,5.126-1.944,7.07,0L22.465,8.464z",stroke:"none",fill:"#009898"},{type:"path",path:"M9.172,2.242L9.172,2.242l-6.929,6.93C1.491,9.923,1.077,10.927,1.077,12c0,1.072,0.414,2.076,1.166,2.828l6.929,6.93c0.751,0.752,1.756,1.166,2.828,1.166s2.076-0.414,2.828-1.166l6.93-6.93c0.751-0.752,1.165-1.756,1.165-2.828c0-1.072-0.414-2.076-1.165-2.828l-6.93-6.93C13.269,0.682,10.731,0.682,9.172,2.242z",stroke:"none",fill:"270-#099-#00a2a2-#00baba-#0cc"},{type:"path",path:"M12,5.077c-2.679,0-4.857,2.179-4.857,4.857c0,1.897,0.741,2.864,1.337,3.639c0.385,0.502,0.662,0.863,0.761,1.443l0.045,0.264v2.25c0,0.854,0.693,1.547,1.546,1.547h2.338c0.852,0,1.545-0.693,1.545-1.547v-2.254l0.044-0.258c0.1-0.582,0.377-0.943,0.762-1.443c0.596-0.777,1.338-1.743,1.338-3.641C16.857,7.255,14.679,5.077,12,5.077z",stroke:"none",fill:"270-#099-#00a2a2-#00baba-#0cc"},{type:"path",path:"M10.227,14.849c-0.331-1.936-2.084-2.197-2.084-4.915c0-2.131,1.727-3.857,3.857-3.857c2.13,0,3.857,1.727,3.857,3.857c0,2.717-1.754,2.979-2.085,4.915H10.227z M10.285,15.849v1.682c0,0.301,0.246,0.547,0.546,0.547h2.338c0.3,0,0.545-0.246,0.545-0.547v-1.682H10.285z",stroke:"none",fill:"#fff"}]);AJS.icons.addIcon("info",[{type:"circle",cx:12,cy:12,r:10,stroke:"none",fill:"#06c"},{type:"path",path:"M3,12c0,4.962,4.037,9,9,9s9-4.038,9-9s-4.037-9-9-9S3,7.037,3,12z",stroke:"none",fill:"90-#06c-#006FD5-#0087ED-#0099FF"},{type:"path",path:"M9.409,7.472c0,0.694,0.282,1.319,0.729,1.785c-0.288,0-0.729,0-0.729,0v9.425h5.182V9.257c0,0-0.44,0-0.729,0c0.446-0.466,0.729-1.09,0.729-1.785c0-1.429-1.162-2.591-2.591-2.591S9.409,6.043,9.409,7.472z",stroke:"none",fill:"270-#06c-#006FD5-#0087ED-#0099FF"},{type:"path",path:"M13.591,10.257v7.425h-3.182v-7.425H13.591z M12,9.063c0.879,0,1.591-0.712,1.591-1.591S12.879,5.881,12,5.881s-1.591,0.712-1.591,1.591S11.121,9.063,12,9.063z",stroke:"none",fill:"#fff"}]);AJS.icons.addIcon("warning",[{type:"path",path:"M8.595,4.368c1.873-3.245,4.938-3.245,6.811,0c1.873,3.245,4.938,8.554,6.812,11.798c1.874,3.244,0.342,5.898-3.405,5.898c-3.746,0-9.876,0-13.624,0c-3.746,0-5.278-2.654-3.405-5.898C3.656,12.922,6.721,7.613,8.595,4.368z",stroke:"none",fill:"#f90"},{type:"path",path:"M9.461,4.868L2.649,16.666c-0.72,1.246-0.863,2.371-0.404,3.166s1.504,1.232,2.943,1.232h13.624c1.439,0,2.485-0.438,2.944-1.232s0.315-1.92-0.405-3.166L14.539,4.868C13.82,3.622,12.918,2.935,12,2.935S10.181,3.621,9.461,4.868z",stroke:"none",fill:"90-#f90-#ffa209-#ffba21-#fc3"},{type:"path",path:"M9.274,6.187c0,0,0.968,9.68,0.986,9.862c-0.532,0.476-0.881,1.148-0.881,1.916c0,1.433,1.165,2.598,2.597,2.598c1.433,0,2.598-1.165,2.598-2.598c0-0.77-0.351-1.441-0.883-1.918c0.018-0.184,0.988-9.86,0.988-9.86H9.274z",stroke:"none",fill:"270-#f90-#ffa209-#ffba21-#fc3"},{type:"path",path:"M11.177,15.171l-0.798-7.984h3.194l-0.8,7.984H11.177z M11.976,16.368c-0.882,0-1.597,0.716-1.597,1.597c0,0.883,0.715,1.598,1.597,1.598c0.881,0,1.598-0.715,1.598-1.598C13.573,17.084,12.856,16.368,11.976,16.368z",stroke:"none",fill:"#fff"}]);AJS.icons.addIcon("close",[{type:"path",path:"M15.535,12l4.95-4.95c0.977-0.977,0.977-2.559,0-3.536s-2.56-0.977-3.536,0L12,8.464l-4.95-4.95c-0.977-0.977-2.559-0.977-3.536,0s-0.977,2.559,0,3.536L8.464,12l-4.95,4.95c-0.977,0.977-0.977,2.559,0,3.535s2.559,0.977,3.536,0L12,15.535l4.949,4.949c0.977,0.977,2.56,0.977,3.536,0s0.977-2.559,0-3.535L15.535,12z",stroke:"none",fill:"#999"},{type:"path",path:"M18.718,20.217c-0.401,0-0.777-0.156-1.062-0.439L12,14.121l-5.657,5.656c-0.284,0.283-0.66,0.439-1.061,0.439c-0.4,0-0.777-0.156-1.061-0.439c-0.283-0.283-0.439-0.66-0.439-1.061s0.156-0.777,0.439-1.061L9.878,12L4.222,6.343c-0.283-0.284-0.439-0.66-0.439-1.061c0-0.4,0.156-0.777,0.439-1.061c0.284-0.283,0.66-0.439,1.061-0.439c0.401,0,0.777,0.156,1.061,0.439L12,9.878l5.656-5.657c0.284-0.283,0.66-0.439,1.062-0.439c0.4,0,0.776,0.156,1.061,0.439c0.283,0.284,0.439,0.66,0.439,1.061c0,0.401-0.156,0.777-0.439,1.061L14.121,12l5.657,5.657c0.283,0.283,0.439,0.66,0.439,1.061s-0.156,0.777-0.439,1.061C19.494,20.061,19.118,20.217,18.718,20.217L18.718,20.217z",stroke:"none",fill:"90-#999996-#a1a19f-#b8b8b7-#ccc"}]);
(function(A){AJS.InlineDialog=function(T,H,K,I){var R=A.extend(false,AJS.InlineDialog.opts,I);var E;var J;var b;var N=false;var S=false;var Z=false;var a;var P;var B=A('<div id="inline-dialog-'+H+'" class="aui-inline-dialog"><div class="contents"></div><div id="arrow-'+H+'" class="arrow"></div></div>');var G=A("#arrow-"+H,B);var Y=B.find(".contents");Y.css("width",R.width+"px");Y.mouseover(function(c){clearTimeout(J);B.unbind("mouseover")}).mouseout(function(){W()});var V=function(){if(!E){E={popup:B,hide:function(){W(0)},id:H,show:function(){Q()},reset:function(){function d(f,e){f.css(e.popupCss);if(window.Raphael){if(!f.arrowCanvas){f.arrowCanvas=Raphael("arrow-"+H,16,16)}var g=R.getArrowPath,h=A.isFunction(g)?g(e):g;f.arrowCanvas.path(h).attr(R.getArrowAttributes())}G.css(e.arrowCss)}var c=R.calculatePositions(B,P,a,R);d(B,c);B.fadeIn(R.fadeTime,function(){});if(R.displayShadow){if(B.shadow){B.shadow.remove()}B.shadow=Raphael.shadow(0,0,Y.width(),Y.height(),{target:Y}).hide().fadeIn(R.fadeTime)}if(AJS.$.browser.msie){if(A("#inline-dialog-shim-"+H).length==0){A(B).prepend(A('<iframe class = "inline-dialog-shim" id="inline-dialog-shim-'+H+'" frameBorder="0" src="javascript:false;"></iframe>'))}A("#inline-dialog-shim-"+H).css({width:Y.outerWidth(),height:Y.outerHeight()})}}}}return E};var Q=function(){if(B.is(":visible")){return }b=setTimeout(function(){if(!Z||!S){return }R.addActiveClass&&A(T).addClass("active");N=true;F();AJS.InlineDialog.current=V();AJS.$(document).trigger("showLayer",["inlineDialog",V()]);V().reset()},R.showDelay)};var W=function(c){S=false;if(N){c=(c==null)?R.hideDelay:c;clearTimeout(J);clearTimeout(b);if(c!=null){J=setTimeout(function(){U();R.addActiveClass&&A(T).removeClass("active");B.fadeOut(R.fadeTime,function(){R.hideCallback.call(B[0].popup)});if(R.displayShadow){B.shadow.remove();B.shadow=null}B.arrowCanvas.remove();B.arrowCanvas=null;N=false;S=false;AJS.$(document).trigger("hideLayer",["inlineDialog",V()]);AJS.InlineDialog.current=null;if(!R.cacheContent){Z=false;O=false}},c)}}};var X=function(f,c){R.upfrontCallback.call({popup:B,hide:function(){W(0)},id:H,show:function(){Q()}});B.each(function(){if(typeof this.popup!="undefined"){this.popup.hide()}});if(R.closeOthers){AJS.$(".aui-inline-dialog").each(function(){this.popup.hide()})}if(!f){a={x:T.offset().left,y:T.offset().top};P={target:T}}else{a={x:f.pageX,y:f.pageY};P={target:A(f.target)}}if(!N){clearTimeout(b)}S=true;var d=function(){O=false;Z=true;R.initCallback.call({popup:B,hide:function(){W(0)},id:H,show:function(){Q()}});Q()};if(!O){O=true;if(A.isFunction(K)){K(Y,c,d)}else{AJS.$.get(K,function(g,e,h){Y.html(R.responseHandler(g,e,h));Z=true;R.initCallback.call({popup:B,hide:function(){W(0)},id:H,show:function(){Q()}});Q()})}}clearTimeout(J);if(!N){Q()}return false};B[0].popup=V();var O=false;var M=false;var L=function(){if(!M){A(R.container).append(B);M=true}};if(R.onHover){if(R.useLiveEvents){A(T).live("mousemove",function(c){L();X(c,this)}).live("mouseout",function(){W()})}else{A(T).mousemove(function(c){L();X(c,this)}).mouseout(function(){W()})}}else{if(!R.noBind){if(R.useLiveEvents){A(T).live("click",function(c){L();X(c,this);return false}).live("mouseout",function(){W()})}else{A(T).click(function(c){L();X(c,this);return false}).mouseout(function(){W()})}}}var D=false;var C=H+".inline-dialog-check";var F=function(){if(!D){A("body").bind("click."+C,function(d){var c=A(d.target);if(c.closest("#inline-dialog-"+H+" .contents").length===0){W(0)}});D=true}};var U=function(){if(D){A("body").unbind("click."+C)}D=false};B.show=function(c){if(c){c.stopPropagation()}L();X(null,this)};B.hide=function(){W(0)};B.refresh=function(){if(N){V().reset()}};B.getOptions=function(){return R};return B};AJS.InlineDialog.opts={onTop:false,responseHandler:function(C,B,D){return C},closeOthers:true,isRelativeToMouse:false,addActiveClass:true,onHover:false,useLiveEvents:false,noBind:false,fadeTime:100,hideDelay:10000,showDelay:0,width:300,offsetX:0,offsetY:10,container:"body",cacheContent:true,displayShadow:true,hideCallback:function(){},initCallback:function(){},upfrontCallback:function(){},calculatePositions:function(C,J,S,N){var K;var U;var Q;var G=-7;var H;var L;var T=J.target.offset();var O=parseInt(J.target.css("padding-left"))+parseInt(J.target.css("padding-right"));var B=J.target.width()+O;var E=T.left+B/2;var P=(window.pageYOffset||document.documentElement.scrollTop)+A(window).height();var F=10;Q=T.top+J.target.height()+N.offsetY;K=T.left+N.offsetX;var I=T.top>C.height();var D=(Q+C.height())<P;L=(!D&&I)||(N.onTop&&I);var M=A(window).width()-(K+N.width+F);if(L){Q=T.top-C.height()-8;var R=N.displayShadow?(AJS.$.browser.msie?10:9):0;G=C.height()-R}H=E-K;if(N.isRelativeToMouse){if(M<0){U=F;K="auto";H=S.x-(A(window).width()-N.width)}else{K=S.x-20;U="auto";H=S.x-K}}else{if(M<0){U=F;K="auto";H=E-(A(window).width()-N.width)}else{if(N.width<=B/2){H=N.width/2;K=E-N.width/2}}}return{displayAbove:L,popupCss:{left:K,right:U,top:Q},arrowCss:{position:"absolute",left:H,right:"auto",top:G}}},getArrowPath:function(B){return B.displayAbove?"M0,8L8,16,16,8":"M0,8L8,0,16,8"},getArrowAttributes:function(){return{fill:"#fff",stroke:"#bbb"}}}})(jQuery);
AJS.warnAboutFirebug=function(B){if(!AJS.Cookie.read("COOKIE_FB_WARNING")&&window.console&&window.console.firebug){if(!B){B="Firebug is known to cause performance problems with Atlassian products. Try disabling it, if you notice any issues."}var A=AJS.$("<div id='firebug-warning'><p>"+B+"</p><a class='close'>Close</a></div>");AJS.$(".close",A).click(function(){A.slideUp("fast");AJS.Cookie.save("COOKIE_FB_WARNING","true")});A.prependTo(AJS.$("body"))}};
AJS.inlineHelp=function(){AJS.$(".icon-inline-help").click(function(){var A=AJS.$(this).siblings(".field-help");if(A.hasClass("hidden")){A.removeClass("hidden")}else{A.addClass("hidden")}})};
(function(){AJS.messages={setup:function(){AJS.messages.createMessage("generic");AJS.messages.createMessage("error");AJS.messages.createMessage("warning");AJS.messages.createMessage("info");AJS.messages.createMessage("success");AJS.messages.createMessage("hint");AJS.messages.makeCloseable()},makeCloseable:function(A){AJS.$(A||"div.aui-message.closeable").each(function(){var C=AJS.$(this),B=AJS.$('<span class="aui-icon icon-close"></span>').click(function(){C.closeMessage()});C.append(B);B.each(AJS.icons.addIcon.init)})},template:'<div class="aui-message {type} {closeable} {shadowed}"><p class="title"><span class="aui-icon icon-{type}"></span><strong>{title}</strong></p>{body}</div><!-- .aui-message -->',createMessage:function(A){AJS.messages[A]=function(C,E){var D=this.template,B;if(!E){E=C;C="#aui-message-bar"}E.closeable=(E.closeable==false)?false:true;E.shadowed=(E.shadowed==false)?false:true;B=AJS.$(AJS.template(D).fill({type:A,closeable:E.closeable?"closeable":"",shadowed:E.shadowed?"shadowed":"",title:E.title||"","body:html":E.body||""}).toString());if(E.id){if(/[#\'\"\.\s]/g.test(E.id)){AJS.log("AJS.Messages error: ID rejected, must not include spaces, hashes, dots or quotes.")}else{B.attr("id",E.id)}}B.appendTo(C);E.closeable&&AJS.messages.makeCloseable(B)}}};AJS.$.fn.closeMessage=function(){var A=AJS.$(this);if(A.hasClass("aui-message","closeable")){A.trigger("messageClose",[this]).remove()}};AJS.$(function(){AJS.messages.setup()})})();
(function(){var B,E,C=/#.*/,D="active-tab",A="active-pane";AJS.tabs={setup:function(){B=AJS.$("div.aui-tabs:not(.aui-tabs-disabled)");for(var F=0,G=B.length;F<G;F++){E=AJS.$("ul.tabs-menu",B[F]);AJS.$("a",E).click(function(H){AJS.tabs.change(AJS.$(this),H);H&&H.preventDefault()})}},change:function(G,H){var F=AJS.$(G.attr("href").match(C)[0]);F.addClass(A).siblings().removeClass(A);G.parent("li.menu-item").addClass(D).siblings().removeClass(D);G.trigger("tabSelect",{tab:G,pane:F})}};AJS.$(AJS.tabs.setup)})();
AJS.template=(function(G){var J=/\{([^\}]+)\}/g,D=/(?:(?:^|\.)(.+?)(?=\[|\.|$|\()|\[('|")(.+?)\2\])(\(\))?/g,H=/([^\\])'/g,F=function(O,N,P,L){var M=P;N.replace(D,function(S,R,Q,U,T){R=R||U;if(M){if(R+":html" in M){M=M[R+":html"];L=true}else{if(R in M){M=M[R]}}if(T&&typeof M=="function"){M=M()}}});if(M==null||M==P){M=O}M=String(M);if(!L){M=E.escape(M)}return M},B=function(L){this.template=this.template.replace(J,function(N,M){return F(N,M,L,true)});return this},K=function(L){this.template=this.template.replace(J,function(N,M){return F(N,M,L)});return this},C=function(){return this.template};var E=function(M){function L(){return L.template}L.template=String(M);L.toString=L.valueOf=C;L.fill=K;L.fillHtml=B;return L},A={},I=[];E.load=function(L){L=String(L);if(!A.hasOwnProperty(L)){I.length>=1000&&delete A[I.shift()];I.push(L);A[L]=G("script[title='"+L.replace(H,"$1\\'")+"']")[0].text}return this(A[L])};E.escape=AJS.escapeHtml;return E})(window.jQuery);
AJS.whenIType=function(D){var A,E=function(F){F=F.toString();jQuery(document).bind("keypress",F,function(){if(!AJS.popup.current&&A){A()}});jQuery(document).bind("keypress keyup",F,function(G){G.preventDefault()})},B=function(F){var H=jQuery(F),I=H.attr("title")||"",G=D.split("");if(H.data("kbShortcutAppended")){C(H,G,I);return }I+=" ( "+AJS.params.keyType+" '"+G.shift()+"'";jQuery.each(G,function(){I+=" "+AJS.params.keyThen+" '"+this+"'"});I+=" )";H.attr("title",I);H.data("kbShortcutAppended",true)},C=function(G,F,H){H=H.replace(/\)$/," OR ");H+="'"+F.shift()+"'";jQuery.each(F,function(){H+=" "+AJS.params.keyThen+" '"+this+"'"});H+=" )";G.attr("title",H)};E(D);return{moveToNextItem:function(F){A=function(){var H,G=jQuery(F),I=jQuery(F+".focused");if(!A.blurHandler){jQuery(document).one("keypress",function(J){if(J.keyCode===jQuery.ui.keyCode.ESCAPE&&I){I.removeClass("focused")}})}if(I.length===0){I=jQuery(F).eq(0)}else{I.removeClass("focused");H=jQuery.inArray(I.get(0),G);if(H<G.length-1){H=H+1;I=G.eq(H)}else{I.removeClass("focused");I=jQuery(F).eq(0)}}if(I&&I.length>0){I.addClass("focused");I.moveTo();I.find("a:first").focus()}}},moveToPrevItem:function(F){A=function(){var H,G=jQuery(F),I=jQuery(F+".focused");if(!A.blurHandler){jQuery(document).one("keypress",function(J){if(J.keyCode===jQuery.ui.keyCode.ESCAPE&&I){I.removeClass("focused")}})}if(I.length===0){I=jQuery(F+":last")}else{I.removeClass("focused");H=jQuery.inArray(I.get(0),G);if(H>0){H=H-1;I=G.eq(H)}else{I.removeClass("focused");I=jQuery(F+":last")}}if(I&&I.length>0){I.addClass("focused");I.moveTo();I.find("a:first").focus()}}},click:function(F){B(F);A=function(){var G=jQuery(F);if(G.length>0){G.click()}}},goTo:function(F){A=function(){window.location.href=F}},followLink:function(F){B(F);A=function(){var G=jQuery(F);if(G.length>0&&G.attr("nodeName").toLowerCase()==="a"){window.location.href=G.attr("href")}}},execute:function(F){A=function(){F()}},moveToAndClick:function(F){B(F);A=function(){var G=jQuery(F);if(G.length>0){G.click();G.moveTo()}}},moveToAndFocus:function(F){B(F);A=function(){var G=jQuery(F);if(G.length>0){G.focus();G.moveTo()}}},or:function(F){E(F);return this}}};jQuery(document).bind("iframeAppended",function(B,A){jQuery(A).load(function(){var C=jQuery(A).contents();C.bind("keyup keydown keypress",function(D){if(jQuery.browser.safari&&D.type==="keypress"){return }if(!jQuery(D.target).is(":input")){jQuery(document).trigger(D)}})})});AJS.whenIType.fromJSON=function(A){if(A){jQuery.each(A,function(C,D){var B=D.op,E=D.param;jQuery.each(D.keys,function(){if(B==="execute"){E=new Function(E)}AJS.whenIType(this)[B](E)})})}};
AJS.toInit(function(D){if(D.browser.msie){var F=D(".aui-toolbar .toolbar-group");F.each(function(G,H){D(H).children(":first").addClass("first");D(H).children(":last").addClass("last")});if(parseInt(D.browser.version,10)==7){function B(){D(".aui-toolbar button").closest(".toolbar-item").addClass("contains-button")}function C(){D(".aui-toolbar .toolbar-split-right").each(function(J,M){var K=D(M),N=K.closest(".aui-toolbar"),G=N.find(".toolbar-split-left"),I=N.data("leftWidth"),L=N.data("rightWidth");if(!I){I=G.outerWidth();N.data("leftWidth",I)}if(!L){L=0;D(".toolbar-item",M).each(function(P,Q){L+=D(Q).outerWidth()});N.data("rightWidth",L)}var O=N.width(),H=O-I;if(O>L&&L>H){G.addClass("force-split")}else{G.removeClass("force-split")}})}function E(){F.each(function(G,H){var I=0;D(H).children(".toolbar-item").each(function(K,J){I+=D(this).outerWidth()});D(this).width(I)})}E();B();var A=false;D(window).resize(function(){if(A!==false){clearTimeout(A)}A=setTimeout(C,200)})}}});
(function(A){A.fn.autocomplete=function(B,C,K){K=typeof C=="function"?C:(typeof K=="function"?K:function(){});C=!isNaN(Number(C))?C:3;var J=this;J[0].lastSelectedValue=J.val();var H=A(document.createElement("ol"));var D=J.offset();var G=parseInt(A("body").css("border-left-width"));H.css({position:"absolute",width:J.outerWidth()-2+"px"});H.addClass("autocompleter");this.after(H);H.css({margin:(Math.abs(this.offset().left-H.offset().left)>=Math.abs(this.offset().top-H.offset().top))?J.outerHeight()+"px 0 0 -"+J.outerWidth()+"px":"-1px 0 0 0"});H.hide();function F(){H.hide();A(document).unbind("click",F)}function E(){var L=J.val();if(L.length>=C&&L!=J[0].lastQuery&&L!=J[0].lastSelectedValue){A.getJSON(B+encodeURI(L),function(P){var R="";L=L.toLowerCase();var U=L.split(" ");for(var Q=0,W=P.length;Q<W;Q++){var S=false;if(P[Q].fullName&&P[Q].username){var V=P[Q].fullName+" ("+P[Q].username+")";var M=P[Q].fullName.split(" ");for(var O=0,T=M.length;O<T;O++){for(var N=0;N<U.length;N++){if(M[O].toLowerCase().indexOf(U[N])==0){M[O]="<strong>"+M[O].substring(0,U[N].length)+"</strong>"+M[O].substring(U[N].length);S=true}}}if(!S){for(var N=0;N<U.length;N++){if(P[Q].username&&P[Q].username.toLowerCase().indexOf(U[N])==0){P[Q].username="<strong>"+P[Q].username.substring(0,U[N].length)+"</strong>"+P[Q].username.substring(U[N].length)}}}P[Q].fullName=M.join(" ");R+="<li><span>"+P[Q].fullName+"</span> <span class='username-in-autocomplete-list'>("+P[Q].username+")</span><i class='fullDetails'>"+V+"</i><i class='username'>"+P[Q].username+"</i><i class='fullName'>"+P[Q].fullName+"</i></li>"}if(P[Q].status){R+="<li>"+P[Q].status+"</li>"}}H.html(R);A("li",H).click(function(Y){Y.stopPropagation();var X=A("i.fullDetails",this).html();I(X)}).hover(function(){A(".focused").removeClass("focused");A(this).addClass("focused")},function(){});A(document).click(F);H.show()});J[0].lastQuery=L}else{if(L.length<C){F()}}}J.keydown(function(M){var L=this;if(this.timer){clearTimeout(this.timer)}var N={"40":function(){var O=A(".focused").removeClass("focused").next();if(O.length){O.addClass("focused")}else{A(".autocompleter li:first").addClass("focused")}},"38":function(){var O=A(".focused").removeClass("focused").prev();if(O.length){O.addClass("focused")}else{A("li:last",H).addClass("focused")}},"27":function(){F()},"13":function(){var O=A(".focused i.fullDetails").html();I(O)},"9":function(){this[13]();setTimeout(function(){L.focus()},0)}};if(H.css("display")!="none"&&M.keyCode in N){M.preventDefault();N[M.keyCode]()}this.timer=setTimeout(E,300)});function I(N){var M=J.val();if(N){J[0].lastSelectedValue=N;J.val(N);var L={input:J,originalValue:M,value:N,fullName:A(".focused i.fullName").text(),username:A(".focused i.username").text()};K(L);F()}}}})(jQuery);
jQuery.fn.isDirty=function(){var B,A=[];window.onbeforeunload=function(){var C=window.onbeforeunload;if(B!==false){jQuery.each(A,function(){if(this.initVal!==AJS.$(this).val()){B=true;return false}})}if(B){window.onbeforeunload=null;window.setTimeout(function(){jQuery(document).bind("mousemove",function(){window.onbeforeunload=C;jQuery(document).unbind("mousemove",arguments.callee)})},1000);B=void (0);return AJS.params.dirtyMessage||""}};return function(D){if(this.length===0){return }function C(F){var E=jQuery(this);jQuery.fn.isDirty.fieldInFocus=E;if(jQuery.inArray(this,A)===-1){this.initVal=E.val();A.push(this);E.die(F.type,C)}}jQuery(":not(:input)").live("click",function(){delete jQuery.fn.isDirty.fieldInFocus});jQuery(":input[type != hidden]",this.selector).bind("keydown",C).bind("keypress",C).bind("click",C);jQuery(D.ignoreUnloadFromElems).live("mousedown",function(){B=false});this.each(function(){this.onsubmit=function(E){return function(){B=false;if(E){return E.apply(this,arguments)}}}(this.onsubmit);AJS.$(this).submit(function(){B=false})});return this}}();
(function(A){A.fn.progressBar=function(I,L){var C=this;var F={height:"1em",showPercentage:true};var B=A.extend(F,L);var J=C.attr("id")+"-incomplete-bar";var D=C.attr("id")+"-complete-bar";var K=C.attr("id")+"-percent-complete-text";if(A("#"+J).length==0){var E=A(document.createElement("div"));E.attr("id",J);E.css({width:"90%",border:"solid 1px #ccc","float":"left","margin-right":"0.5em"});E.addClass("progress-background-color");var G=A(document.createElement("div"));G.attr("id",D);G.addClass("progress-fill-color");G.css({height:B.height,width:I+"%"});var H=A(document.createElement("span"));H.attr("id",K);H.addClass("percent-complete-text");H.html(I+"%");E.append(G);C.append(E);if(B.showPercentage){C.append(H)}}else{A("#"+D).css("width",I+"%");A("#"+K).html(I+"%")}}})(jQuery);
(function(A){if(document.selection){var B=function(C){return C.replace(/\u000D/g,"")};A.fn.selection=function(F){var E=this[0];this.focus();if(!E){return false}if(F==null){return document.selection.createRange().text}else{var D=E.scrollTop;var C=document.selection.createRange();C.text=F;C.select();E.focus();E.scrollTop=D}};A.fn.selectionRange=function(C,F){var G=this[0];this.focus();var I=document.selection.createRange();if(C==null){var K=this.val(),J=K.length,E=I.duplicate();E.moveToElementText(G);E.setEndPoint("StartToEnd",I);var D=J-B(E.text).length;E.setEndPoint("StartToStart",I);var H=J-B(E.text).length;if(D!=H&&K.charAt(D+1)=="\n"){D+=1}return{end:D,start:H,text:K.substring(H,D),textBefore:K.substring(0,H),textAfter:K.substring(D)}}else{I.moveToElementText(G);I.collapse(true);I.moveStart("character",C);I.moveEnd("character",F-C);I.select()}}}else{A.fn.selection=function(E){var D=this[0];if(!D){return false}if(E==null){if(D.setSelectionRange){return D.value.substring(D.selectionStart,D.selectionEnd)}else{return false}}else{var C=D.scrollTop;if(!!D.setSelectionRange){var F=D.selectionStart;D.value=D.value.substring(0,F)+E+D.value.substring(D.selectionEnd);D.selectionStart=F;D.selectionEnd=F+E.length}D.focus();D.scrollTop=C}};A.fn.selectionRange=function(F,C){if(F==null){var D={start:this[0].selectionStart,end:this[0].selectionEnd};var E=this.val();D.text=E.substring(D.start,D.end);D.textBefore=E.substring(0,D.start);D.textAfter=E.substring(D.end);return D}else{this[0].selectionStart=F;this[0].selectionEnd=C}}}A.fn.wrapSelection=function(C,D){this.selection(C+this.selection()+(D||""))}})(jQuery);
jQuery.fn.throbber=function(A){return function(){var C=[],B={isLatentThreshold:100,minThrobberDisplay:200,loadingClass:"loading"};A(document).ajaxComplete(function(E,D){A(C).each(function(F){if(D===this.get(0)){this.hideThrobber();C.splice(F,1)}})});return function(F){var E,G,D=function(I,H){D.t=setTimeout(function(){clearTimeout(D.t);D.t=undefined;I()},H)};F=A.extend(B,F||{});if(!F.target){return this}G=jQuery(F.target);C.push(A.extend(this,{showThrobber:function(){D(function(){if(!E){G.addClass(F.loadingClass);D(function(){if(E){E()}},F.minThrobberDisplay)}},F.isLatentThreshold)},hideThrobber:function(){E=function(){G.removeClass(F.loadingClass);if(F.end){F.end()}};if(!D.t){E()}}}));this.showThrobber();return this}}()}(jQuery);
jQuery.noConflict();
/**
 * AJS.Meta is used to access dynamic metadata passed from the
 * server to JavaScript via the page HTML.
 *
 * @since 3.6
 */
(function($) {

    /**
     * Returns a boolean if the passed string is "true" or "false", ignoring case, else returns the original string.
     * @param value
     */
    AJS.asBooleanOrString = function (value) {
        var lc = value ? value.toLowerCase() : "";

        if (lc == "true")  return true;
        if (lc == "false") return false;

        return value;
    };

    // A backing map to use if the user sets data.
    var overrides = {};

    AJS.Meta = $.extend({}, AJS.Meta, {
        /**
         * Sets metadata with a key and value, for use when the state of the page changes after
         * loading from the server
         * @param key
         * @param value
         */
        set: function (key, value) {
            overrides[key] = value;
        },

        /**
         * Returns a value given a key. If no entry exists with the key, undefined is returned.
         * If the string value is "true" or "false" the respective boolean value is returned.
         *
         * @method get
         * @param key
         * @return {String} or {boolean}
         */
        get: function (key) {
            if (typeof overrides[key] != "undefined") return overrides[key];

            var metaEl = $("meta[name='ajs-" + key + "']");
            if (!metaEl.length)
                return undefined;

            var value = metaEl.attr("content");
            return AJS.asBooleanOrString(value);
        },

        /**
         * Returns true if the value for the provided key is equal to "true", else returns false.
         *
         * @method getBoolean
         * @param key
         * @return {boolean}
         */
        getBoolean: function (key) {
            return this.get(key) === true;
        },

        /**
         * Returns a number if the value for the provided key can be converted to one.
         * Good for retrieving content ids to check truthiness (e.g. '0' is truthy but 0 is falsy).
         *
         * @method getNumber
         * @param key
         * @return {number}
         */
        getNumber: function (key) {
            return +this.get(key);
        },

        /**
         * Mainly for use when debugging, returns all Data pairs in a map for eyeballing.
         */
        getAllAsMap: function () {
            var map = {};
            $("meta[name^=ajs-]").each(function () {
                map[this.name.substring(4)] = this.content;
            });
            return $.extend(map, overrides);
        }
    });

    /**
     * Returns Link metadata for a page, commonly found from <link> tags in the <head>.
     */
    AJS.Meta.Links = {

        /**
         * Returns a canonical URI for a Page or BlogPost, if present.
         */
        canonical: function () {
            // e.g. <link href="http://localhost:8080/confluence/display/TST/Home" rel="canonical">
            return $('head link[rel="canonical"]').attr('href');
        },

        /**
         * Returns a shortlink URI for a Page or BlogPost, if present.
         */
        shortlink: function () {
            // e.g. <link href="http://localhost:8080/confluence/x/BAAE" rel="shortlink">
            return $('head link[rel="shortlink"]').attr('href');
        }

    };

})(AJS.$);
/**
 * Dark features are features that can enabled and disabled per user via a feature key. Their main use is to allow
 * in-development features to be rolled out to production in a low-risk fashion.
 */
(function ($) {
    var featuresStr = AJS.Meta.get('enabled-dark-features'),
        featuresArr = featuresStr ? featuresStr.split(',') : [],
        features = {};

    $.each(featuresArr, function () {
        features[this] = true;
    });
    

    AJS.DarkFeatures = {
        isEnabled: function (key) {
            return !!features[key];
        },

        enable: function (key) {
            if (key && !features[key])
                features[key] = true;
        },

        disable: function (key) {
            if (key && features[key])
                delete features[key];
        }
    };
})(AJS.$);


/**
 * Manager to store data in localStorage, only if supported by the browser.
 * It ensures that the keys are namespaced with a given prefix to avoid clashing with anything else.
 *
 * @param prefix the prefix to be added to the namespace. i.e. 'atlassian'
 * @param id of the storageManager to be returned. This is used to create a unique namespace for keys.
 */
AJS.storageManager = function(prefix, id) {
    var user = AJS.Meta.get("remote-user"),
        namespace = prefix + "." + (user ? user + "." : "") + id,
        delimiter = "#",
        localStorageSupported = false,
        prefixMatch = /\d+#/,
        getPrefix = function(seconds) {
            var milliseconds = (seconds || 0) * 1000;
            if(!milliseconds) {
                return '';
            }
            return +new Date() + milliseconds + delimiter;
        },
        getItem = function(key) {
            if (!localStorageSupported) return null;
            var match;
            var item = localStorage.getItem(namespace + "." + key);
            if(match = prefixMatch.exec(item)) {
                item = item.replace(match[0],'');
                if(+new Date() > match[0].replace("#",'')) {
                    localStorage.removeItem(namespace + "." + key);
                    return null;
                }
            }
            return item;
        };



    try {
        localStorageSupported = 'localStorage' in window && window['localStorage'] !== null;
    }
    catch (e) {
        AJS.log("Browser does not support localStorage, Confluence.storageManager will not work.");
    }

    return {
        /**
         * Gets the item stored in local storage for the given key. null is returned if it doesn't exist.
         * Note that this method will always return a string representation of what is stored.
         *
         * @param key
         */
        getItem: getItem,
        /**
         * Returns a boolean to let you know if we contain a key that matches, and has not expired.
         * @param key
         */
        doesContain: function(key) {
            return !!getItem(key);
        },
                /**
         * Gets the item stored in local storage for the given key and returns the boolean value of it.
         * It correctly convert the "true" and "false" strings to return true/false booleans.
         *
         * @param key
         */
        getItemAsBoolean: function (key) {
            var value = getItem(key);
            if (value == "false")
                return false;
            if (value == "true")
                return true;

            return !!value;
        },
        setItem: function(key, value, expire) {
            if (!localStorageSupported) return;
            value = getPrefix(expire) + value;

            localStorage.setItem(namespace + "." + key, value);
        },
        removeItem: function(key) {
            if (!localStorageSupported) return;

            localStorage.removeItem(namespace + "." + key);
        }
    };
};

AJS.$.ajaxSetup({traditional:true});AJS.isIE6=!window.XMLHttpRequest;AJS.applyPngFilter=function(a,c,b){if(!AJS.isIE6){return false}c=c||a.src;b=b||"scale";a.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(src='"+c+"', sizingMethod='"+b+"')";return true};
(function(e){var d=false;AJS.debug=function(g){if(!d){return}AJS.log("DEBUG: "+new Date().toLocaleTimeString()+" : "+g)};AJS.debugEnabled=function(g){if(typeof g!="boolean"){return d}d=g;AJS.log("DEBUG ENABLED: "+d)};AJS.logError=function(i,g){var h=[];if(e.browser.webkit){h.push(g)}else{for(prop in g){h.push(prop+": "+g[prop])}}AJS.log(i+h.join(", "))};AJS.toInit=function(g){e(function(){try{g.apply(this,arguments)}catch(h){AJS.logError("Failed to run init function: ",h)}});return this};if(AJS.Meta.getBoolean("log-rendered")){var f=AJS.log,c=e('<div id="ajs-log" class="log"><h3>AJS Log</h3>\n</div>'),b=e("head"),a;c.toggleClass("hidden",!AJS.Meta.getBoolean("log-visible"));AJS.log=function(h){var i=(typeof(h)==="undefined")?"undefined":h;if(a){if(c.next().length!=0){a.append(c)}}else{var g=document.createElement("script");g.type="text/x-log";g.text=i;b.append(g)}c.append(e("<p></p>").text("\n"+i));f(h)};AJS.toInit(function(){a=e("body");a.append(c)})}AJS.Data=AJS.Data||AJS.Meta;AJS.getJSONWrap=function(i){var h=Confluence.getContextPath();var g=i.url;if(g.indexOf(h)!=0&&g.indexOf("http")!=0){g=h+g}i.loadingElement&&AJS.setVisible(i.loadingElement,true);var j=i.messageHandler;j.clearMessages();e.ajax({type:"GET",url:g,dataType:"json",data:i.data,error:function(){i.loadingElement&&AJS.setVisible(i.loadingElement,false);j.displayMessages(i.errorMessage||"There was an error communicating with the server, please try again later.");i.errorCallback&&i.errorCallback()},success:function(k){i.loadingElement&&AJS.setVisible(i.loadingElement,false);if(j.handleResponseErrors(k)){i.errorCallback&&i.errorCallback();return}i.successCallback&&i.successCallback(k)}})};AJS.Validate=e.extend((function(){var h,g;return{email:function(i){if(!h){h=/^((([a-z]|\d|[!#\$%&amp;&#39;\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&amp;&#39;\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i}return h.test(i)},url:function(i){if(!g){g=/^([a-z]([a-z]|\d|\+|-|\.)*):(\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?((\[(|(v[\da-f]{1,}\.(([a-z]|\d|-|\.|_|~)|[!\$&'\(\)\*\+,;=]|:)+))\])|((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=])*)(:\d*)?)(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*|(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)|((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)){0})(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i}return g.test(i)}}}()),AJS.Validate)})(AJS.$);
(function(d){var a=function(e){var f,g;f=function(){return e.baseElement};g=function(i){var h=d("ul",i);if(!h.length){h=AJS("ul").appendTo(i)}return h};return{getMessageContainer:f,clearMessages:function(){f().addClass("hidden").empty()},displayMessages:function(l){if(!l||!l.length){return}if(!d.isArray(l)){l=[l]}var m=f(),k=g(m);for(var h=0,j=l.length;h<j;h++){AJS("li").text(l[h]).appendTo(k)}m.removeClass("hidden")},handleResponseErrors:function(h,i){var j=[].concat(h.validationErrors||[]).concat(h.actionErrors||[]).concat(h.errorMessage||[]);if(j.length){this.displayMessages(i||j);return true}return false}}};AJS.MessageHandler=function(f,g){var e=d.extend(a(f),g&&g(f));e.getMessageContainer().addClass("message-handler");e.clearMessages();return e};var c=false;var b;AJS.MessageHandler.closeOnNew=function(e){if(typeof e!=="undefined"){c=e}else{return c}};AJS.MessageHandler.actionMessage=function(e,f){f=f||"success";b=b||d("#action-messages");if(c){b.empty()}AJS.messages[f](b,{body:e,closeable:true,shadowed:true})};AJS.MessageHandler.loading=function(e){AJS.MessageHandler.actionMessage(e,"info")}})(AJS.$);
AJS.ConfluenceDialog=function(a){var b;a=a||{};a=jQuery.extend({},{keypressListener:function(c){if(c.keyCode===27){AJS.debug("dialog.js: escape keydown caught");if(!jQuery(".aui-dropdown",b.popup.element).is(":visible")){if(typeof a.onCancel=="function"){a.onCancel()}else{b.hide()}}}else{if(c.keyCode===13){AJS.debug("dialog.js: enter keydown caught");if(!jQuery(".aui-dropdown",b.popup.element).is(":visible")){var d=c.target.nodeName&&c.target.nodeName.toLowerCase();if(d!="textarea"&&typeof a.onSubmit=="function"){setTimeout(a.onSubmit)}}}}},width:865,height:530},a);b=new AJS.Dialog(a);jQuery.aop.around({target:b,method:"addButton"},function(c){if(c.arguments[0]){c.arguments[0]=AJS.I18n.getText(c.arguments[0])}return c.proceed()});return b};AJS.toInit(function(b){AJS.bind("show.dialog",function(h,f){var c=AJS.Meta.get("page-id"),j=AJS.Meta.get("space-key"),d=AJS.Meta.get("editor-mode"),g=AJS.Meta.get("new-page"),i=function(){var e={};if(c){e.pageid=c}if(j){e.spacekey=j}if(d){e.editormode=d}if(g){e.newpage=g}return e};AJS.EventQueue=AJS.EventQueue||[];AJS.EventQueue.push({name:f.dialog.id,properties:i()})});var a=function(e){var g=b(e),f;if(g.attr("data-lasttab-override")){return}if(g.attr("data-tab-default")){f=g.attr("data-tab-default")}var h=Confluence.storageManager(g.attr("id")),d=h.getItem("last-tab"),c=d!=null?d:f;if(c){b(".page-menu-item:visible:eq("+c+") button",g).click()}if(!g.attr("data-lasttab-bound")){b(".page-menu-item",g).each(function(k,j){b(j).click(function(){h.setItem("last-tab",k)})});g.attr("data-lasttab-bound","true")}};b(document).bind("showLayer",function(f,c,d){Confluence.runBinderComponents();if(c=="popup"&&d){a(d.element)}});AJS.Dialog.prototype.overrideLastTab=function(){b(this.popup.element).attr("data-lasttab-override","true")};AJS.Dialog.prototype.addHelpText=function(d,c){if(!d){return}var g=d;if(c){g=AJS.template(d).fill(c).toString()}var f=this.page[this.curpage];if(!f.buttonpanel){f.addButtonPanel()}var e=b("<div class='dialog-tip'></div>").html(g);f.buttonpanel.append(e);b("a",e).click(function(){window.open(this.href,"_blank").focus();return false})};AJS.Dialog.prototype.getTitle=function(){return b("#"+this.id+" .dialog-components:visible h2").text()};AJS.Dialog.prototype.isVisible=function(){return b("#"+this.id).is(":visible")}});
(function(){if(typeof AJS!="undefined"){var a=AJS.populateParameters;AJS.populateParameters=function(){a.apply(AJS,arguments);AJS.$("meta[name^=ajs-]").each(function(){var b=this.name,c=this.content;b=b.substring(4).replace(/(-\w)/g,function(d){return d.charAt(1).toUpperCase()});if(typeof AJS.params[b]=="undefined"){AJS.params[b]=AJS.asBooleanOrString(c)}})}}AJS.$.fn.disable=function(b){return this.each(function(){var c=AJS.$(this);var d=c.attr("disabled","disabled").addClass("disabled").attr("id");if(d){AJS.$("label[for="+d+"]",c.parent()).addClass("disabled")}})};AJS.$.fn.enable=function(b){return this.each(function(){var c=AJS.$(this);var d=c.attr("disabled","").removeClass("disabled").attr("id");if(d){AJS.$("label[for="+d+"]",c.parent()).removeClass("disabled")}})}})();
/*
 * jQuery UI Datepicker 1.8.11
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI/Datepicker
 *
 * Depends:
 *	jquery.ui.core.js
 */
(function( $, undefined ) {

$.extend($.ui, { datepicker: { version: "1.8.11" } });

var PROP_NAME = 'datepicker';
var dpuuid = new Date().getTime();

/* Date picker manager.
   Use the singleton instance of this class, $.datepicker, to interact with the date picker.
   Settings for (groups of) date pickers are maintained in an instance object,
   allowing multiple different settings on the same page. */

function Datepicker() {
	this.debug = false; // Change this to true to start debugging
	this._curInst = null; // The current instance in use
	this._keyEvent = false; // If the last event was a key event
	this._disabledInputs = []; // List of date picker inputs that have been disabled
	this._datepickerShowing = false; // True if the popup picker is showing , false if not
	this._inDialog = false; // True if showing within a "dialog", false if not
	this._mainDivId = 'ui-datepicker-div'; // The ID of the main datepicker division
	this._inlineClass = 'ui-datepicker-inline'; // The name of the inline marker class
	this._appendClass = 'ui-datepicker-append'; // The name of the append marker class
	this._triggerClass = 'ui-datepicker-trigger'; // The name of the trigger marker class
	this._dialogClass = 'ui-datepicker-dialog'; // The name of the dialog marker class
	this._disableClass = 'ui-datepicker-disabled'; // The name of the disabled covering marker class
	this._unselectableClass = 'ui-datepicker-unselectable'; // The name of the unselectable cell marker class
	this._currentClass = 'ui-datepicker-current-day'; // The name of the current day marker class
	this._dayOverClass = 'ui-datepicker-days-cell-over'; // The name of the day hover marker class
	this.regional = []; // Available regional settings, indexed by language code
	this.regional[''] = { // Default regional settings
		closeText: 'Done', // Display text for close link
		prevText: 'Prev', // Display text for previous month link
		nextText: 'Next', // Display text for next month link
		currentText: 'Today', // Display text for current month link
		monthNames: ['January','February','March','April','May','June',
			'July','August','September','October','November','December'], // Names of months for drop-down and formatting
		monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], // For formatting
		dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], // For formatting
		dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], // For formatting
		dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'], // Column headings for days starting at Sunday
		weekHeader: 'Wk', // Column header for week of the year
		dateFormat: 'mm/dd/yy', // See format options on parseDate
		firstDay: 0, // The first day of the week, Sun = 0, Mon = 1, ...
		isRTL: false, // True if right-to-left language, false if left-to-right
		showMonthAfterYear: false, // True if the year select precedes month, false for month then year
		yearSuffix: '' // Additional text to append to the year in the month headers
	};
	this._defaults = { // Global defaults for all the date picker instances
		showOn: 'focus', // 'focus' for popup on focus,
			// 'button' for trigger button, or 'both' for either
		showAnim: 'fadeIn', // Name of jQuery animation for popup
		showOptions: {}, // Options for enhanced animations
		defaultDate: null, // Used when field is blank: actual date,
			// +/-number for offset from today, null for today
		appendText: '', // Display text following the input box, e.g. showing the format
		buttonText: '...', // Text for trigger button
		buttonImage: '', // URL for trigger button image
		buttonImageOnly: false, // True if the image appears alone, false if it appears on a button
		hideIfNoPrevNext: false, // True to hide next/previous month links
			// if not applicable, false to just disable them
		navigationAsDateFormat: false, // True if date formatting applied to prev/today/next links
		gotoCurrent: false, // True if today link goes back to current selection instead
		changeMonth: false, // True if month can be selected directly, false if only prev/next
		changeYear: false, // True if year can be selected directly, false if only prev/next
		yearRange: 'c-10:c+10', // Range of years to display in drop-down,
			// either relative to today's year (-nn:+nn), relative to currently displayed year
			// (c-nn:c+nn), absolute (nnnn:nnnn), or a combination of the above (nnnn:-n)
		showOtherMonths: false, // True to show dates in other months, false to leave blank
		selectOtherMonths: false, // True to allow selection of dates in other months, false for unselectable
		showWeek: false, // True to show week of the year, false to not show it
		calculateWeek: this.iso8601Week, // How to calculate the week of the year,
			// takes a Date and returns the number of the week for it
		shortYearCutoff: '+10', // Short year values < this are in the current century,
			// > this are in the previous century,
			// string value starting with '+' for current year + value
		minDate: null, // The earliest selectable date, or null for no limit
		maxDate: null, // The latest selectable date, or null for no limit
		duration: 'fast', // Duration of display/closure
		beforeShowDay: null, // Function that takes a date and returns an array with
			// [0] = true if selectable, false if not, [1] = custom CSS class name(s) or '',
			// [2] = cell title (optional), e.g. $.datepicker.noWeekends
		beforeShow: null, // Function that takes an input field and
			// returns a set of custom settings for the date picker
		onSelect: null, // Define a callback function when a date is selected
		onChangeMonthYear: null, // Define a callback function when the month or year is changed
		onClose: null, // Define a callback function when the datepicker is closed
		numberOfMonths: 1, // Number of months to show at a time
		showCurrentAtPos: 0, // The position in multipe months at which to show the current month (starting at 0)
		stepMonths: 1, // Number of months to step back/forward
		stepBigMonths: 12, // Number of months to step back/forward for the big links
		altField: '', // Selector for an alternate field to store selected dates into
		altFormat: '', // The date format to use for the alternate field
		constrainInput: true, // The input is constrained by the current date format
		showButtonPanel: false, // True to show button panel, false to not show it
		autoSize: false // True to size the input for the date format, false to leave as is
	};
	$.extend(this._defaults, this.regional['']);
	this.dpDiv = $('<div id="' + this._mainDivId + '" class="ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div>');
}

$.extend(Datepicker.prototype, {
	/* Class name added to elements to indicate already configured with a date picker. */
	markerClassName: 'hasDatepicker',

	/* Debug logging (if enabled). */
	log: function () {
		if (this.debug)
			console.log.apply('', arguments);
	},

	// TODO rename to "widget" when switching to widget factory
	_widgetDatepicker: function() {
		return this.dpDiv;
	},

	/* Override the default settings for all instances of the date picker.
	   @param  settings  object - the new settings to use as defaults (anonymous object)
	   @return the manager object */
	setDefaults: function(settings) {
		extendRemove(this._defaults, settings || {});
		return this;
	},

	/* Attach the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span
	   @param  settings  object - the new settings to use for this date picker instance (anonymous) */
	_attachDatepicker: function(target, settings) {
		// check for settings on the control itself - in namespace 'date:'
		var inlineSettings = null;
		for (var attrName in this._defaults) {
			var attrValue = target.getAttribute('date:' + attrName);
			if (attrValue) {
				inlineSettings = inlineSettings || {};
				try {
					inlineSettings[attrName] = eval(attrValue);
				} catch (err) {
					inlineSettings[attrName] = attrValue;
				}
			}
		}
		var nodeName = target.nodeName.toLowerCase();
		var inline = (nodeName == 'div' || nodeName == 'span');
		if (!target.id) {
			this.uuid += 1;
			target.id = 'dp' + this.uuid;
		}
		var inst = this._newInst($(target), inline);
		inst.settings = $.extend({}, settings || {}, inlineSettings || {});
		if (nodeName == 'input') {
			this._connectDatepicker(target, inst);
		} else if (inline) {
			this._inlineDatepicker(target, inst);
		}
	},

	/* Create a new instance object. */
	_newInst: function(target, inline) {
		var id = target[0].id.replace(/([^A-Za-z0-9_-])/g, '\\\\$1'); // escape jQuery meta chars
		return {id: id, input: target, // associated target
			selectedDay: 0, selectedMonth: 0, selectedYear: 0, // current selection
			drawMonth: 0, drawYear: 0, // month being drawn
			inline: inline, // is datepicker inline or not
			dpDiv: (!inline ? this.dpDiv : // presentation div
			$('<div class="' + this._inlineClass + ' ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div>'))};
	},

	/* Attach the date picker to an input field. */
	_connectDatepicker: function(target, inst) {
		var input = $(target);
		inst.append = $([]);
		inst.trigger = $([]);
		if (input.hasClass(this.markerClassName))
			return;
		this._attachments(input, inst);
		input.addClass(this.markerClassName).keydown(this._doKeyDown).
			keypress(this._doKeyPress).keyup(this._doKeyUp).
			bind("setData.datepicker", function(event, key, value) {
				inst.settings[key] = value;
			}).bind("getData.datepicker", function(event, key) {
				return this._get(inst, key);
			});
		this._autoSize(inst);
		$.data(target, PROP_NAME, inst);
	},

	/* Make attachments based on settings. */
	_attachments: function(input, inst) {
		var appendText = this._get(inst, 'appendText');
		var isRTL = this._get(inst, 'isRTL');
		if (inst.append)
			inst.append.remove();
		if (appendText) {
			inst.append = $('<span class="' + this._appendClass + '">' + appendText + '</span>');
			input[isRTL ? 'before' : 'after'](inst.append);
		}
		input.unbind('focus', this._showDatepicker);
		if (inst.trigger)
			inst.trigger.remove();
		var showOn = this._get(inst, 'showOn');
		if (showOn == 'focus' || showOn == 'both') // pop-up date picker when in the marked field
			input.focus(this._showDatepicker);
		if (showOn == 'button' || showOn == 'both') { // pop-up date picker when button clicked
			var buttonText = this._get(inst, 'buttonText');
			var buttonImage = this._get(inst, 'buttonImage');
			inst.trigger = $(this._get(inst, 'buttonImageOnly') ?
				$('<img/>').addClass(this._triggerClass).
					attr({ src: buttonImage, alt: buttonText, title: buttonText }) :
				$('<button type="button"></button>').addClass(this._triggerClass).
					html(buttonImage == '' ? buttonText : $('<img/>').attr(
					{ src:buttonImage, alt:buttonText, title:buttonText })));
			input[isRTL ? 'before' : 'after'](inst.trigger);
			inst.trigger.click(function() {
				if ($.datepicker._datepickerShowing && $.datepicker._lastInput == input[0])
					$.datepicker._hideDatepicker();
				else
					$.datepicker._showDatepicker(input[0]);
				return false;
			});
		}
	},

	/* Apply the maximum length for the date format. */
	_autoSize: function(inst) {
		if (this._get(inst, 'autoSize') && !inst.inline) {
			var date = new Date(2009, 12 - 1, 20); // Ensure double digits
			var dateFormat = this._get(inst, 'dateFormat');
			if (dateFormat.match(/[DM]/)) {
				var findMax = function(names) {
					var max = 0;
					var maxI = 0;
					for (var i = 0; i < names.length; i++) {
						if (names[i].length > max) {
							max = names[i].length;
							maxI = i;
						}
					}
					return maxI;
				};
				date.setMonth(findMax(this._get(inst, (dateFormat.match(/MM/) ?
					'monthNames' : 'monthNamesShort'))));
				date.setDate(findMax(this._get(inst, (dateFormat.match(/DD/) ?
					'dayNames' : 'dayNamesShort'))) + 20 - date.getDay());
			}
			inst.input.attr('size', this._formatDate(inst, date).length);
		}
	},

	/* Attach an inline date picker to a div. */
	_inlineDatepicker: function(target, inst) {
		var divSpan = $(target);
		if (divSpan.hasClass(this.markerClassName))
			return;
		divSpan.addClass(this.markerClassName).append(inst.dpDiv).
			bind("setData.datepicker", function(event, key, value){
				inst.settings[key] = value;
			}).bind("getData.datepicker", function(event, key){
				return this._get(inst, key);
			});
		$.data(target, PROP_NAME, inst);
		this._setDate(inst, this._getDefaultDate(inst), true);
		this._updateDatepicker(inst);
		this._updateAlternate(inst);
		inst.dpDiv.show();
	},

	/* Pop-up the date picker in a "dialog" box.
	   @param  input     element - ignored
	   @param  date      string or Date - the initial date to display
	   @param  onSelect  function - the function to call when a date is selected
	   @param  settings  object - update the dialog date picker instance's settings (anonymous object)
	   @param  pos       int[2] - coordinates for the dialog's position within the screen or
	                     event - with x/y coordinates or
	                     leave empty for default (screen centre)
	   @return the manager object */
	_dialogDatepicker: function(input, date, onSelect, settings, pos) {
		var inst = this._dialogInst; // internal instance
		if (!inst) {
			this.uuid += 1;
			var id = 'dp' + this.uuid;
			this._dialogInput = $('<input type="text" id="' + id +
				'" style="position: absolute; top: -100px; width: 0px; z-index: -10;"/>');
			this._dialogInput.keydown(this._doKeyDown);
			$('body').append(this._dialogInput);
			inst = this._dialogInst = this._newInst(this._dialogInput, false);
			inst.settings = {};
			$.data(this._dialogInput[0], PROP_NAME, inst);
		}
		extendRemove(inst.settings, settings || {});
		date = (date && date.constructor == Date ? this._formatDate(inst, date) : date);
		this._dialogInput.val(date);

		this._pos = (pos ? (pos.length ? pos : [pos.pageX, pos.pageY]) : null);
		if (!this._pos) {
			var browserWidth = document.documentElement.clientWidth;
			var browserHeight = document.documentElement.clientHeight;
			var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
			var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
			this._pos = // should use actual width/height below
				[(browserWidth / 2) - 100 + scrollX, (browserHeight / 2) - 150 + scrollY];
		}

		// move input on screen for focus, but hidden behind dialog
		this._dialogInput.css('left', (this._pos[0] + 20) + 'px').css('top', this._pos[1] + 'px');
		inst.settings.onSelect = onSelect;
		this._inDialog = true;
		this.dpDiv.addClass(this._dialogClass);
		this._showDatepicker(this._dialogInput[0]);
		if ($.blockUI)
			$.blockUI(this.dpDiv);
		$.data(this._dialogInput[0], PROP_NAME, inst);
		return this;
	},

	/* Detach a datepicker from its control.
	   @param  target    element - the target input field or division or span */
	_destroyDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		$.removeData(target, PROP_NAME);
		if (nodeName == 'input') {
			inst.append.remove();
			inst.trigger.remove();
			$target.removeClass(this.markerClassName).
				unbind('focus', this._showDatepicker).
				unbind('keydown', this._doKeyDown).
				unbind('keypress', this._doKeyPress).
				unbind('keyup', this._doKeyUp);
		} else if (nodeName == 'div' || nodeName == 'span')
			$target.removeClass(this.markerClassName).empty();
	},

	/* Enable the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span */
	_enableDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		if (nodeName == 'input') {
			target.disabled = false;
			inst.trigger.filter('button').
				each(function() { this.disabled = false; }).end().
				filter('img').css({opacity: '1.0', cursor: ''});
		}
		else if (nodeName == 'div' || nodeName == 'span') {
			var inline = $target.children('.' + this._inlineClass);
			inline.children().removeClass('ui-state-disabled');
		}
		this._disabledInputs = $.map(this._disabledInputs,
			function(value) { return (value == target ? null : value); }); // delete entry
	},

	/* Disable the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span */
	_disableDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		if (nodeName == 'input') {
			target.disabled = true;
			inst.trigger.filter('button').
				each(function() { this.disabled = true; }).end().
				filter('img').css({opacity: '0.5', cursor: 'default'});
		}
		else if (nodeName == 'div' || nodeName == 'span') {
			var inline = $target.children('.' + this._inlineClass);
			inline.children().addClass('ui-state-disabled');
		}
		this._disabledInputs = $.map(this._disabledInputs,
			function(value) { return (value == target ? null : value); }); // delete entry
		this._disabledInputs[this._disabledInputs.length] = target;
	},

	/* Is the first field in a jQuery collection disabled as a datepicker?
	   @param  target    element - the target input field or division or span
	   @return boolean - true if disabled, false if enabled */
	_isDisabledDatepicker: function(target) {
		if (!target) {
			return false;
		}
		for (var i = 0; i < this._disabledInputs.length; i++) {
			if (this._disabledInputs[i] == target)
				return true;
		}
		return false;
	},

	/* Retrieve the instance data for the target control.
	   @param  target  element - the target input field or division or span
	   @return  object - the associated instance data
	   @throws  error if a jQuery problem getting data */
	_getInst: function(target) {
		try {
			return $.data(target, PROP_NAME);
		}
		catch (err) {
			throw 'Missing instance data for this datepicker';
		}
	},

	/* Update or retrieve the settings for a date picker attached to an input field or division.
	   @param  target  element - the target input field or division or span
	   @param  name    object - the new settings to update or
	                   string - the name of the setting to change or retrieve,
	                   when retrieving also 'all' for all instance settings or
	                   'defaults' for all global defaults
	   @param  value   any - the new value for the setting
	                   (omit if above is an object or to retrieve a value) */
	_optionDatepicker: function(target, name, value) {
		var inst = this._getInst(target);
		if (arguments.length == 2 && typeof name == 'string') {
			return (name == 'defaults' ? $.extend({}, $.datepicker._defaults) :
				(inst ? (name == 'all' ? $.extend({}, inst.settings) :
				this._get(inst, name)) : null));
		}
		var settings = name || {};
		if (typeof name == 'string') {
			settings = {};
			settings[name] = value;
		}
		if (inst) {
			if (this._curInst == inst) {
				this._hideDatepicker();
			}
			var date = this._getDateDatepicker(target, true);
			var minDate = this._getMinMaxDate(inst, 'min');
			var maxDate = this._getMinMaxDate(inst, 'max');
			extendRemove(inst.settings, settings);
			// reformat the old minDate/maxDate values if dateFormat changes and a new minDate/maxDate isn't provided
			if (minDate !== null && settings['dateFormat'] !== undefined && settings['minDate'] === undefined)
				inst.settings.minDate = this._formatDate(inst, minDate);
			if (maxDate !== null && settings['dateFormat'] !== undefined && settings['maxDate'] === undefined)
				inst.settings.maxDate = this._formatDate(inst, maxDate);
			this._attachments($(target), inst);
			this._autoSize(inst);
			this._setDateDatepicker(target, date);
			this._updateDatepicker(inst);
		}
	},

	// change method deprecated
	_changeDatepicker: function(target, name, value) {
		this._optionDatepicker(target, name, value);
	},

	/* Redraw the date picker attached to an input field or division.
	   @param  target  element - the target input field or division or span */
	_refreshDatepicker: function(target) {
		var inst = this._getInst(target);
		if (inst) {
			this._updateDatepicker(inst);
		}
	},

	/* Set the dates for a jQuery selection.
	   @param  target   element - the target input field or division or span
	   @param  date     Date - the new date */
	_setDateDatepicker: function(target, date) {
		var inst = this._getInst(target);
		if (inst) {
			this._setDate(inst, date);
			this._updateDatepicker(inst);
			this._updateAlternate(inst);
		}
	},

	/* Get the date(s) for the first entry in a jQuery selection.
	   @param  target     element - the target input field or division or span
	   @param  noDefault  boolean - true if no default date is to be used
	   @return Date - the current date */
	_getDateDatepicker: function(target, noDefault) {
		var inst = this._getInst(target);
		if (inst && !inst.inline)
			this._setDateFromField(inst, noDefault);
		return (inst ? this._getDate(inst) : null);
	},

	/* Handle keystrokes. */
	_doKeyDown: function(event) {
		var inst = $.datepicker._getInst(event.target);
		var handled = true;
		var isRTL = inst.dpDiv.is('.ui-datepicker-rtl');
		inst._keyEvent = true;
		if ($.datepicker._datepickerShowing)
			switch (event.keyCode) {
				case 9: $.datepicker._hideDatepicker();
						handled = false;
						break; // hide on tab out
				case 13: var sel = $('td.' + $.datepicker._dayOverClass + ':not(.' +
									$.datepicker._currentClass + ')', inst.dpDiv);
						if (sel[0])
							$.datepicker._selectDay(event.target, inst.selectedMonth, inst.selectedYear, sel[0]);
						else
							$.datepicker._hideDatepicker();
						return false; // don't submit the form
						break; // select the value on enter
				case 27: $.datepicker._hideDatepicker();
						break; // hide on escape
				case 33: $.datepicker._adjustDate(event.target, (event.ctrlKey ?
							-$.datepicker._get(inst, 'stepBigMonths') :
							-$.datepicker._get(inst, 'stepMonths')), 'M');
						break; // previous month/year on page up/+ ctrl
				case 34: $.datepicker._adjustDate(event.target, (event.ctrlKey ?
							+$.datepicker._get(inst, 'stepBigMonths') :
							+$.datepicker._get(inst, 'stepMonths')), 'M');
						break; // next month/year on page down/+ ctrl
				case 35: if (event.ctrlKey || event.metaKey) $.datepicker._clearDate(event.target);
						handled = event.ctrlKey || event.metaKey;
						break; // clear on ctrl or command +end
				case 36: if (event.ctrlKey || event.metaKey) $.datepicker._gotoToday(event.target);
						handled = event.ctrlKey || event.metaKey;
						break; // current on ctrl or command +home
				case 37: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, (isRTL ? +1 : -1), 'D');
						handled = event.ctrlKey || event.metaKey;
						// -1 day on ctrl or command +left
						if (event.originalEvent.altKey) $.datepicker._adjustDate(event.target, (event.ctrlKey ?
									-$.datepicker._get(inst, 'stepBigMonths') :
									-$.datepicker._get(inst, 'stepMonths')), 'M');
						// next month/year on alt +left on Mac
						break;
				case 38: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, -7, 'D');
						handled = event.ctrlKey || event.metaKey;
						break; // -1 week on ctrl or command +up
				case 39: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, (isRTL ? -1 : +1), 'D');
						handled = event.ctrlKey || event.metaKey;
						// +1 day on ctrl or command +right
						if (event.originalEvent.altKey) $.datepicker._adjustDate(event.target, (event.ctrlKey ?
									+$.datepicker._get(inst, 'stepBigMonths') :
									+$.datepicker._get(inst, 'stepMonths')), 'M');
						// next month/year on alt +right
						break;
				case 40: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, +7, 'D');
						handled = event.ctrlKey || event.metaKey;
						break; // +1 week on ctrl or command +down
				default: handled = false;
			}
		else if (event.keyCode == 36 && event.ctrlKey) // display the date picker on ctrl+home
			$.datepicker._showDatepicker(this);
		else {
			handled = false;
		}
		if (handled) {
			event.preventDefault();
			event.stopPropagation();
		}
	},

	/* Filter entered characters - based on date format. */
	_doKeyPress: function(event) {
		var inst = $.datepicker._getInst(event.target);
		if ($.datepicker._get(inst, 'constrainInput')) {
			var chars = $.datepicker._possibleChars($.datepicker._get(inst, 'dateFormat'));
			var chr = String.fromCharCode(event.charCode == undefined ? event.keyCode : event.charCode);
			return event.ctrlKey || event.metaKey || (chr < ' ' || !chars || chars.indexOf(chr) > -1);
		}
	},

	/* Synchronise manual entry and field/alternate field. */
	_doKeyUp: function(event) {
		var inst = $.datepicker._getInst(event.target);
		if (inst.input.val() != inst.lastVal) {
			try {
				var date = $.datepicker.parseDate($.datepicker._get(inst, 'dateFormat'),
					(inst.input ? inst.input.val() : null),
					$.datepicker._getFormatConfig(inst));
				if (date) { // only if valid
					$.datepicker._setDateFromField(inst);
					$.datepicker._updateAlternate(inst);
					$.datepicker._updateDatepicker(inst);
				}
			}
			catch (event) {
				$.datepicker.log(event);
			}
		}
		return true;
	},

	/* Pop-up the date picker for a given input field.
	   @param  input  element - the input field attached to the date picker or
	                  event - if triggered by focus */
	_showDatepicker: function(input) {
		input = input.target || input;
		if (input.nodeName.toLowerCase() != 'input') // find from button/image trigger
			input = $('input', input.parentNode)[0];
		if ($.datepicker._isDisabledDatepicker(input) || $.datepicker._lastInput == input) // already here
			return;
		var inst = $.datepicker._getInst(input);
		if ($.datepicker._curInst && $.datepicker._curInst != inst) {
			$.datepicker._curInst.dpDiv.stop(true, true);
		}
		var beforeShow = $.datepicker._get(inst, 'beforeShow');
		extendRemove(inst.settings, (beforeShow ? beforeShow.apply(input, [input, inst]) : {}));
		inst.lastVal = null;
		$.datepicker._lastInput = input;
		$.datepicker._setDateFromField(inst);
		if ($.datepicker._inDialog) // hide cursor
			input.value = '';
		if (!$.datepicker._pos) { // position below input
			$.datepicker._pos = $.datepicker._findPos(input);
			$.datepicker._pos[1] += input.offsetHeight; // add the height
		}
		var isFixed = false;
		$(input).parents().each(function() {
			isFixed |= $(this).css('position') == 'fixed';
			return !isFixed;
		});
		if (isFixed && $.browser.opera) { // correction for Opera when fixed and scrolled
			$.datepicker._pos[0] -= document.documentElement.scrollLeft;
			$.datepicker._pos[1] -= document.documentElement.scrollTop;
		}
		var offset = {left: $.datepicker._pos[0], top: $.datepicker._pos[1]};
		$.datepicker._pos = null;
		//to avoid flashes on Firefox
		inst.dpDiv.empty();
		// determine sizing offscreen
		inst.dpDiv.css({position: 'absolute', display: 'block', top: '-1000px'});
		$.datepicker._updateDatepicker(inst);
		// fix width for dynamic number of date pickers
		// and adjust position before showing
		offset = $.datepicker._checkOffset(inst, offset, isFixed);
		inst.dpDiv.css({position: ($.datepicker._inDialog && $.blockUI ?
			'static' : (isFixed ? 'fixed' : 'absolute')), display: 'none',
			left: offset.left + 'px', top: offset.top + 'px'});
		if (!inst.inline) {
			var showAnim = $.datepicker._get(inst, 'showAnim');
			var duration = $.datepicker._get(inst, 'duration');
			var postProcess = function() {
				$.datepicker._datepickerShowing = true;
				var cover = inst.dpDiv.find('iframe.ui-datepicker-cover'); // IE6- only
				if( !! cover.length ){
					var borders = $.datepicker._getBorders(inst.dpDiv);
					cover.css({left: -borders[0], top: -borders[1],
						width: inst.dpDiv.outerWidth(), height: inst.dpDiv.outerHeight()});
				}
			};
			inst.dpDiv.zIndex($(input).zIndex()+1);
			if ($.effects && $.effects[showAnim])
				inst.dpDiv.show(showAnim, $.datepicker._get(inst, 'showOptions'), duration, postProcess);
			else
				inst.dpDiv[showAnim || 'show']((showAnim ? duration : null), postProcess);
			if (!showAnim || !duration)
				postProcess();
			if (inst.input.is(':visible') && !inst.input.is(':disabled'))
				inst.input.focus();
			$.datepicker._curInst = inst;
		}
	},

	/* Generate the date picker content. */
	_updateDatepicker: function(inst) {
		var self = this;
		var borders = $.datepicker._getBorders(inst.dpDiv);
		inst.dpDiv.empty().append(this._generateHTML(inst));
		var cover = inst.dpDiv.find('iframe.ui-datepicker-cover'); // IE6- only
		if( !!cover.length ){ //avoid call to outerXXXX() when not in IE6
			cover.css({left: -borders[0], top: -borders[1], width: inst.dpDiv.outerWidth(), height: inst.dpDiv.outerHeight()})
		}
		inst.dpDiv.find('button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a')
				.bind('mouseout', function(){
					$(this).removeClass('ui-state-hover');
					if(this.className.indexOf('ui-datepicker-prev') != -1) $(this).removeClass('ui-datepicker-prev-hover');
					if(this.className.indexOf('ui-datepicker-next') != -1) $(this).removeClass('ui-datepicker-next-hover');
				})
				.bind('mouseover', function(){
					if (!self._isDisabledDatepicker( inst.inline ? inst.dpDiv.parent()[0] : inst.input[0])) {
						$(this).parents('.ui-datepicker-calendar').find('a').removeClass('ui-state-hover');
						$(this).addClass('ui-state-hover');
						if(this.className.indexOf('ui-datepicker-prev') != -1) $(this).addClass('ui-datepicker-prev-hover');
						if(this.className.indexOf('ui-datepicker-next') != -1) $(this).addClass('ui-datepicker-next-hover');
					}
				})
			.end()
			.find('.' + this._dayOverClass + ' a')
				.trigger('mouseover')
			.end();
		var numMonths = this._getNumberOfMonths(inst);
		var cols = numMonths[1];
		var width = 17;
		if (cols > 1)
			inst.dpDiv.addClass('ui-datepicker-multi-' + cols).css('width', (width * cols) + 'em');
		else
			inst.dpDiv.removeClass('ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4').width('');
		inst.dpDiv[(numMonths[0] != 1 || numMonths[1] != 1 ? 'add' : 'remove') +
			'Class']('ui-datepicker-multi');
		inst.dpDiv[(this._get(inst, 'isRTL') ? 'add' : 'remove') +
			'Class']('ui-datepicker-rtl');
		if (inst == $.datepicker._curInst && $.datepicker._datepickerShowing && inst.input &&
				// #6694 - don't focus the input if it's already focused
				// this breaks the change event in IE
				inst.input.is(':visible') && !inst.input.is(':disabled') && inst.input[0] != document.activeElement)
			inst.input.focus();
		// deffered render of the years select (to avoid flashes on Firefox)
		if( inst.yearshtml ){
			var origyearshtml = inst.yearshtml;
			setTimeout(function(){
				//assure that inst.yearshtml didn't change.
				if( origyearshtml === inst.yearshtml ){
					inst.dpDiv.find('select.ui-datepicker-year:first').replaceWith(inst.yearshtml);
				}
				origyearshtml = inst.yearshtml = null;
			}, 0);
		}
	},

	/* Retrieve the size of left and top borders for an element.
	   @param  elem  (jQuery object) the element of interest
	   @return  (number[2]) the left and top borders */
	_getBorders: function(elem) {
		var convert = function(value) {
			return {thin: 1, medium: 2, thick: 3}[value] || value;
		};
		return [parseFloat(convert(elem.css('border-left-width'))),
			parseFloat(convert(elem.css('border-top-width')))];
	},

	/* Check positioning to remain on screen. */
	_checkOffset: function(inst, offset, isFixed) {
		var dpWidth = inst.dpDiv.outerWidth();
		var dpHeight = inst.dpDiv.outerHeight();
		var inputWidth = inst.input ? inst.input.outerWidth() : 0;
		var inputHeight = inst.input ? inst.input.outerHeight() : 0;
		var viewWidth = document.documentElement.clientWidth + $(document).scrollLeft();
		var viewHeight = document.documentElement.clientHeight + $(document).scrollTop();

		offset.left -= (this._get(inst, 'isRTL') ? (dpWidth - inputWidth) : 0);
		offset.left -= (isFixed && offset.left == inst.input.offset().left) ? $(document).scrollLeft() : 0;
		offset.top -= (isFixed && offset.top == (inst.input.offset().top + inputHeight)) ? $(document).scrollTop() : 0;

		// now check if datepicker is showing outside window viewport - move to a better place if so.
		offset.left -= Math.min(offset.left, (offset.left + dpWidth > viewWidth && viewWidth > dpWidth) ?
			Math.abs(offset.left + dpWidth - viewWidth) : 0);
		offset.top -= Math.min(offset.top, (offset.top + dpHeight > viewHeight && viewHeight > dpHeight) ?
			Math.abs(dpHeight + inputHeight) : 0);

		return offset;
	},

	/* Find an object's position on the screen. */
	_findPos: function(obj) {
		var inst = this._getInst(obj);
		var isRTL = this._get(inst, 'isRTL');
        while (obj && (obj.type == 'hidden' || obj.nodeType != 1 || $.expr.filters.hidden(obj))) {
            obj = obj[isRTL ? 'previousSibling' : 'nextSibling'];
        }
        var position = $(obj).offset();
	    return [position.left, position.top];
	},

	/* Hide the date picker from view.
	   @param  input  element - the input field attached to the date picker */
	_hideDatepicker: function(input) {
		var inst = this._curInst;
		if (!inst || (input && inst != $.data(input, PROP_NAME)))
			return;
		if (this._datepickerShowing) {
			var showAnim = this._get(inst, 'showAnim');
			var duration = this._get(inst, 'duration');
			var postProcess = function() {
				$.datepicker._tidyDialog(inst);
				this._curInst = null;
			};
			if ($.effects && $.effects[showAnim])
				inst.dpDiv.hide(showAnim, $.datepicker._get(inst, 'showOptions'), duration, postProcess);
			else
				inst.dpDiv[(showAnim == 'slideDown' ? 'slideUp' :
					(showAnim == 'fadeIn' ? 'fadeOut' : 'hide'))]((showAnim ? duration : null), postProcess);
			if (!showAnim)
				postProcess();
			var onClose = this._get(inst, 'onClose');
			if (onClose)
				onClose.apply((inst.input ? inst.input[0] : null),
					[(inst.input ? inst.input.val() : ''), inst]);  // trigger custom callback
			this._datepickerShowing = false;
			this._lastInput = null;
			if (this._inDialog) {
				this._dialogInput.css({ position: 'absolute', left: '0', top: '-100px' });
				if ($.blockUI) {
					$.unblockUI();
					$('body').append(this.dpDiv);
				}
			}
			this._inDialog = false;
		}
	},

	/* Tidy up after a dialog display. */
	_tidyDialog: function(inst) {
		inst.dpDiv.removeClass(this._dialogClass).unbind('.ui-datepicker-calendar');
	},

	/* Close date picker if clicked elsewhere. */
	_checkExternalClick: function(event) {
		if (!$.datepicker._curInst)
			return;
		var $target = $(event.target);
		if ($target[0].id != $.datepicker._mainDivId &&
				$target.parents('#' + $.datepicker._mainDivId).length == 0 &&
				!$target.hasClass($.datepicker.markerClassName) &&
				!$target.hasClass($.datepicker._triggerClass) &&
				$.datepicker._datepickerShowing && !($.datepicker._inDialog && $.blockUI))
			$.datepicker._hideDatepicker();
	},

	/* Adjust one of the date sub-fields. */
	_adjustDate: function(id, offset, period) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (this._isDisabledDatepicker(target[0])) {
			return;
		}
		this._adjustInstDate(inst, offset +
			(period == 'M' ? this._get(inst, 'showCurrentAtPos') : 0), // undo positioning
			period);
		this._updateDatepicker(inst);
	},

	/* Action for current link. */
	_gotoToday: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
			inst.selectedDay = inst.currentDay;
			inst.drawMonth = inst.selectedMonth = inst.currentMonth;
			inst.drawYear = inst.selectedYear = inst.currentYear;
		}
		else {
			var date = new Date();
			inst.selectedDay = date.getDate();
			inst.drawMonth = inst.selectedMonth = date.getMonth();
			inst.drawYear = inst.selectedYear = date.getFullYear();
		}
		this._notifyChange(inst);
		this._adjustDate(target);
	},

	/* Action for selecting a new month/year. */
	_selectMonthYear: function(id, select, period) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		inst._selectingMonthYear = false;
		inst['selected' + (period == 'M' ? 'Month' : 'Year')] =
		inst['draw' + (period == 'M' ? 'Month' : 'Year')] =
			parseInt(select.options[select.selectedIndex].value,10);
		this._notifyChange(inst);
		this._adjustDate(target);
	},

	/* Restore input focus after not changing month/year. */
	_clickMonthYear: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (inst.input && inst._selectingMonthYear) {
			setTimeout(function() {
				inst.input.focus();
			}, 0);
		}
		inst._selectingMonthYear = !inst._selectingMonthYear;
	},

	/* Action for selecting a day. */
	_selectDay: function(id, month, year, td) {
		var target = $(id);
		if ($(td).hasClass(this._unselectableClass) || this._isDisabledDatepicker(target[0])) {
			return;
		}
		var inst = this._getInst(target[0]);
		inst.selectedDay = inst.currentDay = $('a', td).html();
		inst.selectedMonth = inst.currentMonth = month;
		inst.selectedYear = inst.currentYear = year;
		this._selectDate(id, this._formatDate(inst,
			inst.currentDay, inst.currentMonth, inst.currentYear));
	},

	/* Erase the input field and hide the date picker. */
	_clearDate: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		this._selectDate(target, '');
	},

	/* Update the input field with the selected date. */
	_selectDate: function(id, dateStr) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		dateStr = (dateStr != null ? dateStr : this._formatDate(inst));
		if (inst.input)
			inst.input.val(dateStr);
		this._updateAlternate(inst);
		var onSelect = this._get(inst, 'onSelect');
		if (onSelect)
			onSelect.apply((inst.input ? inst.input[0] : null), [dateStr, inst]);  // trigger custom callback
		else if (inst.input)
			inst.input.trigger('change'); // fire the change event
		if (inst.inline)
			this._updateDatepicker(inst);
		else {
			this._hideDatepicker();
			this._lastInput = inst.input[0];
			if (typeof(inst.input[0]) != 'object')
				inst.input.focus(); // restore focus
			this._lastInput = null;
		}
	},

	/* Update any alternate field to synchronise with the main field. */
	_updateAlternate: function(inst) {
		var altField = this._get(inst, 'altField');
		if (altField) { // update alternate field too
			var altFormat = this._get(inst, 'altFormat') || this._get(inst, 'dateFormat');
			var date = this._getDate(inst);
			var dateStr = this.formatDate(altFormat, date, this._getFormatConfig(inst));
			$(altField).each(function() { $(this).val(dateStr); });
		}
	},

	/* Set as beforeShowDay function to prevent selection of weekends.
	   @param  date  Date - the date to customise
	   @return [boolean, string] - is this date selectable?, what is its CSS class? */
	noWeekends: function(date) {
		var day = date.getDay();
		return [(day > 0 && day < 6), ''];
	},

	/* Set as calculateWeek to determine the week of the year based on the ISO 8601 definition.
	   @param  date  Date - the date to get the week for
	   @return  number - the number of the week within the year that contains this date */
	iso8601Week: function(date) {
		var checkDate = new Date(date.getTime());
		// Find Thursday of this week starting on Monday
		checkDate.setDate(checkDate.getDate() + 4 - (checkDate.getDay() || 7));
		var time = checkDate.getTime();
		checkDate.setMonth(0); // Compare with Jan 1
		checkDate.setDate(1);
		return Math.floor(Math.round((time - checkDate) / 86400000) / 7) + 1;
	},

	/* Parse a string value into a date object.
	   See formatDate below for the possible formats.

	   @param  format    string - the expected format of the date
	   @param  value     string - the date in the above format
	   @param  settings  Object - attributes include:
	                     shortYearCutoff  number - the cutoff year for determining the century (optional)
	                     dayNamesShort    string[7] - abbreviated names of the days from Sunday (optional)
	                     dayNames         string[7] - names of the days from Sunday (optional)
	                     monthNamesShort  string[12] - abbreviated names of the months (optional)
	                     monthNames       string[12] - names of the months (optional)
	   @return  Date - the extracted date value or null if value is blank */
	parseDate: function (format, value, settings) {
		if (format == null || value == null)
			throw 'Invalid arguments';
		value = (typeof value == 'object' ? value.toString() : value + '');
		if (value == '')
			return null;
		var shortYearCutoff = (settings ? settings.shortYearCutoff : null) || this._defaults.shortYearCutoff;
		shortYearCutoff = (typeof shortYearCutoff != 'string' ? shortYearCutoff :
				new Date().getFullYear() % 100 + parseInt(shortYearCutoff, 10));
		var dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort;
		var dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames;
		var monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort;
		var monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames;
		var year = -1;
		var month = -1;
		var day = -1;
		var doy = -1;
		var literal = false;
		// Check whether a format character is doubled
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		// Extract a number from the string value
		var getNumber = function(match) {
			var isDoubled = lookAhead(match);
			var size = (match == '@' ? 14 : (match == '!' ? 20 :
				(match == 'y' && isDoubled ? 4 : (match == 'o' ? 3 : 2))));
			var digits = new RegExp('^\\d{1,' + size + '}');
			var num = value.substring(iValue).match(digits);
			if (!num)
				throw 'Missing number at position ' + iValue;
			iValue += num[0].length;
			return parseInt(num[0], 10);
		};
		// Extract a name from the string value and convert to an index
		var getName = function(match, shortNames, longNames) {
			var names = (lookAhead(match) ? longNames : shortNames);
			for (var i = 0; i < names.length; i++) {
				if (value.substr(iValue, names[i].length).toLowerCase() == names[i].toLowerCase()) {
					iValue += names[i].length;
					return i + 1;
				}
			}
			throw 'Unknown name at position ' + iValue;
		};
		// Confirm that a literal character matches the string value
		var checkLiteral = function() {
			if (value.charAt(iValue) != format.charAt(iFormat))
				throw 'Unexpected literal at position ' + iValue;
			iValue++;
		};
		var iValue = 0;
		for (var iFormat = 0; iFormat < format.length; iFormat++) {
			if (literal)
				if (format.charAt(iFormat) == "'" && !lookAhead("'"))
					literal = false;
				else
					checkLiteral();
			else
				switch (format.charAt(iFormat)) {
					case 'd':
						day = getNumber('d');
						break;
					case 'D':
						getName('D', dayNamesShort, dayNames);
						break;
					case 'o':
						doy = getNumber('o');
						break;
					case 'm':
						month = getNumber('m');
						break;
					case 'M':
						month = getName('M', monthNamesShort, monthNames);
						break;
					case 'y':
						year = getNumber('y');
						break;
					case '@':
						var date = new Date(getNumber('@'));
						year = date.getFullYear();
						month = date.getMonth() + 1;
						day = date.getDate();
						break;
					case '!':
						var date = new Date((getNumber('!') - this._ticksTo1970) / 10000);
						year = date.getFullYear();
						month = date.getMonth() + 1;
						day = date.getDate();
						break;
					case "'":
						if (lookAhead("'"))
							checkLiteral();
						else
							literal = true;
						break;
					default:
						checkLiteral();
				}
		}
		if (year == -1)
			year = new Date().getFullYear();
		else if (year < 100)
			year += new Date().getFullYear() - new Date().getFullYear() % 100 +
				(year <= shortYearCutoff ? 0 : -100);
		if (doy > -1) {
			month = 1;
			day = doy;
			do {
				var dim = this._getDaysInMonth(year, month - 1);
				if (day <= dim)
					break;
				month++;
				day -= dim;
			} while (true);
		}
		var date = this._daylightSavingAdjust(new Date(year, month - 1, day));
		if (date.getFullYear() != year || date.getMonth() + 1 != month || date.getDate() != day)
			throw 'Invalid date'; // E.g. 31/02/*
		return date;
	},

	/* Standard date formats. */
	ATOM: 'yy-mm-dd', // RFC 3339 (ISO 8601)
	COOKIE: 'D, dd M yy',
	ISO_8601: 'yy-mm-dd',
	RFC_822: 'D, d M y',
	RFC_850: 'DD, dd-M-y',
	RFC_1036: 'D, d M y',
	RFC_1123: 'D, d M yy',
	RFC_2822: 'D, d M yy',
	RSS: 'D, d M y', // RFC 822
	TICKS: '!',
	TIMESTAMP: '@',
	W3C: 'yy-mm-dd', // ISO 8601

	_ticksTo1970: (((1970 - 1) * 365 + Math.floor(1970 / 4) - Math.floor(1970 / 100) +
		Math.floor(1970 / 400)) * 24 * 60 * 60 * 10000000),

	/* Format a date object into a string value.
	   The format can be combinations of the following:
	   d  - day of month (no leading zero)
	   dd - day of month (two digit)
	   o  - day of year (no leading zeros)
	   oo - day of year (three digit)
	   D  - day name short
	   DD - day name long
	   m  - month of year (no leading zero)
	   mm - month of year (two digit)
	   M  - month name short
	   MM - month name long
	   y  - year (two digit)
	   yy - year (four digit)
	   @ - Unix timestamp (ms since 01/01/1970)
	   ! - Windows ticks (100ns since 01/01/0001)
	   '...' - literal text
	   '' - single quote

	   @param  format    string - the desired format of the date
	   @param  date      Date - the date value to format
	   @param  settings  Object - attributes include:
	                     dayNamesShort    string[7] - abbreviated names of the days from Sunday (optional)
	                     dayNames         string[7] - names of the days from Sunday (optional)
	                     monthNamesShort  string[12] - abbreviated names of the months (optional)
	                     monthNames       string[12] - names of the months (optional)
	   @return  string - the date in the above format */
	formatDate: function (format, date, settings) {
		if (!date)
			return '';
		var dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort;
		var dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames;
		var monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort;
		var monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames;
		// Check whether a format character is doubled
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		// Format a number, with leading zero if necessary
		var formatNumber = function(match, value, len) {
			var num = '' + value;
			if (lookAhead(match))
				while (num.length < len)
					num = '0' + num;
			return num;
		};
		// Format a name, short or long as requested
		var formatName = function(match, value, shortNames, longNames) {
			return (lookAhead(match) ? longNames[value] : shortNames[value]);
		};
		var output = '';
		var literal = false;
		if (date)
			for (var iFormat = 0; iFormat < format.length; iFormat++) {
				if (literal)
					if (format.charAt(iFormat) == "'" && !lookAhead("'"))
						literal = false;
					else
						output += format.charAt(iFormat);
				else
					switch (format.charAt(iFormat)) {
						case 'd':
							output += formatNumber('d', date.getDate(), 2);
							break;
						case 'D':
							output += formatName('D', date.getDay(), dayNamesShort, dayNames);
							break;
						case 'o':
							output += formatNumber('o',
								(date.getTime() - new Date(date.getFullYear(), 0, 0).getTime()) / 86400000, 3);
							break;
						case 'm':
							output += formatNumber('m', date.getMonth() + 1, 2);
							break;
						case 'M':
							output += formatName('M', date.getMonth(), monthNamesShort, monthNames);
							break;
						case 'y':
							output += (lookAhead('y') ? date.getFullYear() :
								(date.getYear() % 100 < 10 ? '0' : '') + date.getYear() % 100);
							break;
						case '@':
							output += date.getTime();
							break;
						case '!':
							output += date.getTime() * 10000 + this._ticksTo1970;
							break;
						case "'":
							if (lookAhead("'"))
								output += "'";
							else
								literal = true;
							break;
						default:
							output += format.charAt(iFormat);
					}
			}
		return output;
	},

	/* Extract all possible characters from the date format. */
	_possibleChars: function (format) {
		var chars = '';
		var literal = false;
		// Check whether a format character is doubled
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		for (var iFormat = 0; iFormat < format.length; iFormat++)
			if (literal)
				if (format.charAt(iFormat) == "'" && !lookAhead("'"))
					literal = false;
				else
					chars += format.charAt(iFormat);
			else
				switch (format.charAt(iFormat)) {
					case 'd': case 'm': case 'y': case '@':
						chars += '0123456789';
						break;
					case 'D': case 'M':
						return null; // Accept anything
					case "'":
						if (lookAhead("'"))
							chars += "'";
						else
							literal = true;
						break;
					default:
						chars += format.charAt(iFormat);
				}
		return chars;
	},

	/* Get a setting value, defaulting if necessary. */
	_get: function(inst, name) {
		return inst.settings[name] !== undefined ?
			inst.settings[name] : this._defaults[name];
	},

	/* Parse existing date and initialise date picker. */
	_setDateFromField: function(inst, noDefault) {
		if (inst.input.val() == inst.lastVal) {
			return;
		}
		var dateFormat = this._get(inst, 'dateFormat');
		var dates = inst.lastVal = inst.input ? inst.input.val() : null;
		var date, defaultDate;
		date = defaultDate = this._getDefaultDate(inst);
		var settings = this._getFormatConfig(inst);
		try {
			date = this.parseDate(dateFormat, dates, settings) || defaultDate;
		} catch (event) {
			this.log(event);
			dates = (noDefault ? '' : dates);
		}
		inst.selectedDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = date.getFullYear();
		inst.currentDay = (dates ? date.getDate() : 0);
		inst.currentMonth = (dates ? date.getMonth() : 0);
		inst.currentYear = (dates ? date.getFullYear() : 0);
		this._adjustInstDate(inst);
	},

	/* Retrieve the default date shown on opening. */
	_getDefaultDate: function(inst) {
		return this._restrictMinMax(inst,
			this._determineDate(inst, this._get(inst, 'defaultDate'), new Date()));
	},

	/* A date may be specified as an exact value or a relative one. */
	_determineDate: function(inst, date, defaultDate) {
		var offsetNumeric = function(offset) {
			var date = new Date();
			date.setDate(date.getDate() + offset);
			return date;
		};
		var offsetString = function(offset) {
			try {
				return $.datepicker.parseDate($.datepicker._get(inst, 'dateFormat'),
					offset, $.datepicker._getFormatConfig(inst));
			}
			catch (e) {
				// Ignore
			}
			var date = (offset.toLowerCase().match(/^c/) ?
				$.datepicker._getDate(inst) : null) || new Date();
			var year = date.getFullYear();
			var month = date.getMonth();
			var day = date.getDate();
			var pattern = /([+-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g;
			var matches = pattern.exec(offset);
			while (matches) {
				switch (matches[2] || 'd') {
					case 'd' : case 'D' :
						day += parseInt(matches[1],10); break;
					case 'w' : case 'W' :
						day += parseInt(matches[1],10) * 7; break;
					case 'm' : case 'M' :
						month += parseInt(matches[1],10);
						day = Math.min(day, $.datepicker._getDaysInMonth(year, month));
						break;
					case 'y': case 'Y' :
						year += parseInt(matches[1],10);
						day = Math.min(day, $.datepicker._getDaysInMonth(year, month));
						break;
				}
				matches = pattern.exec(offset);
			}
			return new Date(year, month, day);
		};
		var newDate = (date == null || date === '' ? defaultDate : (typeof date == 'string' ? offsetString(date) :
			(typeof date == 'number' ? (isNaN(date) ? defaultDate : offsetNumeric(date)) : new Date(date.getTime()))));
		newDate = (newDate && newDate.toString() == 'Invalid Date' ? defaultDate : newDate);
		if (newDate) {
			newDate.setHours(0);
			newDate.setMinutes(0);
			newDate.setSeconds(0);
			newDate.setMilliseconds(0);
		}
		return this._daylightSavingAdjust(newDate);
	},

	/* Handle switch to/from daylight saving.
	   Hours may be non-zero on daylight saving cut-over:
	   > 12 when midnight changeover, but then cannot generate
	   midnight datetime, so jump to 1AM, otherwise reset.
	   @param  date  (Date) the date to check
	   @return  (Date) the corrected date */
	_daylightSavingAdjust: function(date) {
		if (!date) return null;
		date.setHours(date.getHours() > 12 ? date.getHours() + 2 : 0);
		return date;
	},

	/* Set the date(s) directly. */
	_setDate: function(inst, date, noChange) {
		var clear = !date;
		var origMonth = inst.selectedMonth;
		var origYear = inst.selectedYear;
		var newDate = this._restrictMinMax(inst, this._determineDate(inst, date, new Date()));
		inst.selectedDay = inst.currentDay = newDate.getDate();
		inst.drawMonth = inst.selectedMonth = inst.currentMonth = newDate.getMonth();
		inst.drawYear = inst.selectedYear = inst.currentYear = newDate.getFullYear();
		if ((origMonth != inst.selectedMonth || origYear != inst.selectedYear) && !noChange)
			this._notifyChange(inst);
		this._adjustInstDate(inst);
		if (inst.input) {
			inst.input.val(clear ? '' : this._formatDate(inst));
		}
	},

	/* Retrieve the date(s) directly. */
	_getDate: function(inst) {
		var startDate = (!inst.currentYear || (inst.input && inst.input.val() == '') ? null :
			this._daylightSavingAdjust(new Date(
			inst.currentYear, inst.currentMonth, inst.currentDay)));
			return startDate;
	},

	/* Generate the HTML for the current state of the date picker. */
	_generateHTML: function(inst) {
		var today = new Date();
		today = this._daylightSavingAdjust(
			new Date(today.getFullYear(), today.getMonth(), today.getDate())); // clear time
		var isRTL = this._get(inst, 'isRTL');
		var showButtonPanel = this._get(inst, 'showButtonPanel');
		var hideIfNoPrevNext = this._get(inst, 'hideIfNoPrevNext');
		var navigationAsDateFormat = this._get(inst, 'navigationAsDateFormat');
		var numMonths = this._getNumberOfMonths(inst);
		var showCurrentAtPos = this._get(inst, 'showCurrentAtPos');
		var stepMonths = this._get(inst, 'stepMonths');
		var isMultiMonth = (numMonths[0] != 1 || numMonths[1] != 1);
		var currentDate = this._daylightSavingAdjust((!inst.currentDay ? new Date(9999, 9, 9) :
			new Date(inst.currentYear, inst.currentMonth, inst.currentDay)));
		var minDate = this._getMinMaxDate(inst, 'min');
		var maxDate = this._getMinMaxDate(inst, 'max');
		var drawMonth = inst.drawMonth - showCurrentAtPos;
		var drawYear = inst.drawYear;
		if (drawMonth < 0) {
			drawMonth += 12;
			drawYear--;
		}
		if (maxDate) {
			var maxDraw = this._daylightSavingAdjust(new Date(maxDate.getFullYear(),
				maxDate.getMonth() - (numMonths[0] * numMonths[1]) + 1, maxDate.getDate()));
			maxDraw = (minDate && maxDraw < minDate ? minDate : maxDraw);
			while (this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1)) > maxDraw) {
				drawMonth--;
				if (drawMonth < 0) {
					drawMonth = 11;
					drawYear--;
				}
			}
		}
		inst.drawMonth = drawMonth;
		inst.drawYear = drawYear;
		var prevText = this._get(inst, 'prevText');
		prevText = (!navigationAsDateFormat ? prevText : this.formatDate(prevText,
			this._daylightSavingAdjust(new Date(drawYear, drawMonth - stepMonths, 1)),
			this._getFormatConfig(inst)));
		var prev = (this._canAdjustMonth(inst, -1, drawYear, drawMonth) ?
			'<a class="ui-datepicker-prev ui-corner-all" onclick="DP_jQuery_' + dpuuid +
			'.datepicker._adjustDate(\'#' + inst.id + '\', -' + stepMonths + ', \'M\');"' +
			' title="' + prevText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'e' : 'w') + '">' + prevText + '</span></a>' :
			(hideIfNoPrevNext ? '' : '<a class="ui-datepicker-prev ui-corner-all ui-state-disabled" title="'+ prevText +'"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'e' : 'w') + '">' + prevText + '</span></a>'));
		var nextText = this._get(inst, 'nextText');
		nextText = (!navigationAsDateFormat ? nextText : this.formatDate(nextText,
			this._daylightSavingAdjust(new Date(drawYear, drawMonth + stepMonths, 1)),
			this._getFormatConfig(inst)));
		var next = (this._canAdjustMonth(inst, +1, drawYear, drawMonth) ?
			'<a class="ui-datepicker-next ui-corner-all" onclick="DP_jQuery_' + dpuuid +
			'.datepicker._adjustDate(\'#' + inst.id + '\', +' + stepMonths + ', \'M\');"' +
			' title="' + nextText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'w' : 'e') + '">' + nextText + '</span></a>' :
			(hideIfNoPrevNext ? '' : '<a class="ui-datepicker-next ui-corner-all ui-state-disabled" title="'+ nextText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'w' : 'e') + '">' + nextText + '</span></a>'));
		var currentText = this._get(inst, 'currentText');
		var gotoDate = (this._get(inst, 'gotoCurrent') && inst.currentDay ? currentDate : today);
		currentText = (!navigationAsDateFormat ? currentText :
			this.formatDate(currentText, gotoDate, this._getFormatConfig(inst)));
		var controls = (!inst.inline ? '<button type="button" class="ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all" onclick="DP_jQuery_' + dpuuid +
			'.datepicker._hideDatepicker();">' + this._get(inst, 'closeText') + '</button>' : '');
		var buttonPanel = (showButtonPanel) ? '<div class="ui-datepicker-buttonpane ui-widget-content">' + (isRTL ? controls : '') +
			(this._isInRange(inst, gotoDate) ? '<button type="button" class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" onclick="DP_jQuery_' + dpuuid +
			'.datepicker._gotoToday(\'#' + inst.id + '\');"' +
			'>' + currentText + '</button>' : '') + (isRTL ? '' : controls) + '</div>' : '';
		var firstDay = parseInt(this._get(inst, 'firstDay'),10);
		firstDay = (isNaN(firstDay) ? 0 : firstDay);
		var showWeek = this._get(inst, 'showWeek');
		var dayNames = this._get(inst, 'dayNames');
		var dayNamesShort = this._get(inst, 'dayNamesShort');
		var dayNamesMin = this._get(inst, 'dayNamesMin');
		var monthNames = this._get(inst, 'monthNames');
		var monthNamesShort = this._get(inst, 'monthNamesShort');
		var beforeShowDay = this._get(inst, 'beforeShowDay');
		var showOtherMonths = this._get(inst, 'showOtherMonths');
		var selectOtherMonths = this._get(inst, 'selectOtherMonths');
		var calculateWeek = this._get(inst, 'calculateWeek') || this.iso8601Week;
		var defaultDate = this._getDefaultDate(inst);
		var html = '';
		for (var row = 0; row < numMonths[0]; row++) {
			var group = '';
			for (var col = 0; col < numMonths[1]; col++) {
				var selectedDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, inst.selectedDay));
				var cornerClass = ' ui-corner-all';
				var calender = '';
				if (isMultiMonth) {
					calender += '<div class="ui-datepicker-group';
					if (numMonths[1] > 1)
						switch (col) {
							case 0: calender += ' ui-datepicker-group-first';
								cornerClass = ' ui-corner-' + (isRTL ? 'right' : 'left'); break;
							case numMonths[1]-1: calender += ' ui-datepicker-group-last';
								cornerClass = ' ui-corner-' + (isRTL ? 'left' : 'right'); break;
							default: calender += ' ui-datepicker-group-middle'; cornerClass = ''; break;
						}
					calender += '">';
				}
				calender += '<div class="ui-datepicker-header ui-widget-header ui-helper-clearfix' + cornerClass + '">' +
					(/all|left/.test(cornerClass) && row == 0 ? (isRTL ? next : prev) : '') +
					(/all|right/.test(cornerClass) && row == 0 ? (isRTL ? prev : next) : '') +
					this._generateMonthYearHeader(inst, drawMonth, drawYear, minDate, maxDate,
					row > 0 || col > 0, monthNames, monthNamesShort) + // draw month headers
					'</div><table class="ui-datepicker-calendar"><thead>' +
					'<tr>';
				var thead = (showWeek ? '<th class="ui-datepicker-week-col">' + this._get(inst, 'weekHeader') + '</th>' : '');
				for (var dow = 0; dow < 7; dow++) { // days of the week
					var day = (dow + firstDay) % 7;
					thead += '<th' + ((dow + firstDay + 6) % 7 >= 5 ? ' class="ui-datepicker-week-end"' : '') + '>' +
						'<span title="' + dayNames[day] + '">' + dayNamesMin[day] + '</span></th>';
				}
				calender += thead + '</tr></thead><tbody>';
				var daysInMonth = this._getDaysInMonth(drawYear, drawMonth);
				if (drawYear == inst.selectedYear && drawMonth == inst.selectedMonth)
					inst.selectedDay = Math.min(inst.selectedDay, daysInMonth);
				var leadDays = (this._getFirstDayOfMonth(drawYear, drawMonth) - firstDay + 7) % 7;
				var numRows = (isMultiMonth ? 6 : Math.ceil((leadDays + daysInMonth) / 7)); // calculate the number of rows to generate
				var printDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1 - leadDays));
				for (var dRow = 0; dRow < numRows; dRow++) { // create date picker rows
					calender += '<tr>';
					var tbody = (!showWeek ? '' : '<td class="ui-datepicker-week-col">' +
						this._get(inst, 'calculateWeek')(printDate) + '</td>');
					for (var dow = 0; dow < 7; dow++) { // create date picker days
						var daySettings = (beforeShowDay ?
							beforeShowDay.apply((inst.input ? inst.input[0] : null), [printDate]) : [true, '']);
						var otherMonth = (printDate.getMonth() != drawMonth);
						var unselectable = (otherMonth && !selectOtherMonths) || !daySettings[0] ||
							(minDate && printDate < minDate) || (maxDate && printDate > maxDate);
						tbody += '<td class="' +
							((dow + firstDay + 6) % 7 >= 5 ? ' ui-datepicker-week-end' : '') + // highlight weekends
							(otherMonth ? ' ui-datepicker-other-month' : '') + // highlight days from other months
							((printDate.getTime() == selectedDate.getTime() && drawMonth == inst.selectedMonth && inst._keyEvent) || // user pressed key
							(defaultDate.getTime() == printDate.getTime() && defaultDate.getTime() == selectedDate.getTime()) ?
							// or defaultDate is current printedDate and defaultDate is selectedDate
							' ' + this._dayOverClass : '') + // highlight selected day
							(unselectable ? ' ' + this._unselectableClass + ' ui-state-disabled': '') +  // highlight unselectable days
							(otherMonth && !showOtherMonths ? '' : ' ' + daySettings[1] + // highlight custom dates
							(printDate.getTime() == currentDate.getTime() ? ' ' + this._currentClass : '') + // highlight selected day
							(printDate.getTime() == today.getTime() ? ' ui-datepicker-today' : '')) + '"' + // highlight today (if different)
							((!otherMonth || showOtherMonths) && daySettings[2] ? ' title="' + daySettings[2] + '"' : '') + // cell title
							(unselectable ? '' : ' onclick="DP_jQuery_' + dpuuid + '.datepicker._selectDay(\'#' +
							inst.id + '\',' + printDate.getMonth() + ',' + printDate.getFullYear() + ', this);return false;"') + '>' + // actions
							(otherMonth && !showOtherMonths ? '&#xa0;' : // display for other months
							(unselectable ? '<span class="ui-state-default">' + printDate.getDate() + '</span>' : '<a class="ui-state-default' +
							(printDate.getTime() == today.getTime() ? ' ui-state-highlight' : '') +
							(printDate.getTime() == currentDate.getTime() ? ' ui-state-active' : '') + // highlight selected day
							(otherMonth ? ' ui-priority-secondary' : '') + // distinguish dates from other months
							'" href="#">' + printDate.getDate() + '</a>')) + '</td>'; // display selectable date
						printDate.setDate(printDate.getDate() + 1);
						printDate = this._daylightSavingAdjust(printDate);
					}
					calender += tbody + '</tr>';
				}
				drawMonth++;
				if (drawMonth > 11) {
					drawMonth = 0;
					drawYear++;
				}
				calender += '</tbody></table>' + (isMultiMonth ? '</div>' +
							((numMonths[0] > 0 && col == numMonths[1]-1) ? '<div class="ui-datepicker-row-break"></div>' : '') : '');
				group += calender;
			}
			html += group;
		}
		html += buttonPanel + ($.browser.msie && parseInt($.browser.version,10) < 7 && !inst.inline ?
			'<iframe src="javascript:false;" class="ui-datepicker-cover" frameborder="0"></iframe>' : '');
		inst._keyEvent = false;
		return html;
	},

	/* Generate the month and year header. */
	_generateMonthYearHeader: function(inst, drawMonth, drawYear, minDate, maxDate,
			secondary, monthNames, monthNamesShort) {
		var changeMonth = this._get(inst, 'changeMonth');
		var changeYear = this._get(inst, 'changeYear');
		var showMonthAfterYear = this._get(inst, 'showMonthAfterYear');
		var html = '<div class="ui-datepicker-title">';
		var monthHtml = '';
		// month selection
		if (secondary || !changeMonth)
			monthHtml += '<span class="ui-datepicker-month">' + monthNames[drawMonth] + '</span>';
		else {
			var inMinYear = (minDate && minDate.getFullYear() == drawYear);
			var inMaxYear = (maxDate && maxDate.getFullYear() == drawYear);
			monthHtml += '<select class="ui-datepicker-month" ' +
				'onchange="DP_jQuery_' + dpuuid + '.datepicker._selectMonthYear(\'#' + inst.id + '\', this, \'M\');" ' +
				'onclick="DP_jQuery_' + dpuuid + '.datepicker._clickMonthYear(\'#' + inst.id + '\');"' +
			 	'>';
			for (var month = 0; month < 12; month++) {
				if ((!inMinYear || month >= minDate.getMonth()) &&
						(!inMaxYear || month <= maxDate.getMonth()))
					monthHtml += '<option value="' + month + '"' +
						(month == drawMonth ? ' selected="selected"' : '') +
						'>' + monthNamesShort[month] + '</option>';
			}
			monthHtml += '</select>';
		}
		if (!showMonthAfterYear)
			html += monthHtml + (secondary || !(changeMonth && changeYear) ? '&#xa0;' : '');
		// year selection
		inst.yearshtml = '';
		if (secondary || !changeYear)
			html += '<span class="ui-datepicker-year">' + drawYear + '</span>';
		else {
			// determine range of years to display
			var years = this._get(inst, 'yearRange').split(':');
			var thisYear = new Date().getFullYear();
			var determineYear = function(value) {
				var year = (value.match(/c[+-].*/) ? drawYear + parseInt(value.substring(1), 10) :
					(value.match(/[+-].*/) ? thisYear + parseInt(value, 10) :
					parseInt(value, 10)));
				return (isNaN(year) ? thisYear : year);
			};
			var year = determineYear(years[0]);
			var endYear = Math.max(year, determineYear(years[1] || ''));
			year = (minDate ? Math.max(year, minDate.getFullYear()) : year);
			endYear = (maxDate ? Math.min(endYear, maxDate.getFullYear()) : endYear);
			inst.yearshtml += '<select class="ui-datepicker-year" ' +
				'onchange="DP_jQuery_' + dpuuid + '.datepicker._selectMonthYear(\'#' + inst.id + '\', this, \'Y\');" ' +
				'onclick="DP_jQuery_' + dpuuid + '.datepicker._clickMonthYear(\'#' + inst.id + '\');"' +
				'>';
			for (; year <= endYear; year++) {
				inst.yearshtml += '<option value="' + year + '"' +
					(year == drawYear ? ' selected="selected"' : '') +
					'>' + year + '</option>';
			}
			inst.yearshtml += '</select>';
			//when showing there is no need for later update
			if( ! $.browser.mozilla ){
				html += inst.yearshtml;
				inst.yearshtml = null;
			} else {
				// will be replaced later with inst.yearshtml
				html += '<select class="ui-datepicker-year"><option value="' + drawYear + '" selected="selected">' + drawYear + '</option></select>';
			}
		}
		html += this._get(inst, 'yearSuffix');
		if (showMonthAfterYear)
			html += (secondary || !(changeMonth && changeYear) ? '&#xa0;' : '') + monthHtml;
		html += '</div>'; // Close datepicker_header
		return html;
	},

	/* Adjust one of the date sub-fields. */
	_adjustInstDate: function(inst, offset, period) {
		var year = inst.drawYear + (period == 'Y' ? offset : 0);
		var month = inst.drawMonth + (period == 'M' ? offset : 0);
		var day = Math.min(inst.selectedDay, this._getDaysInMonth(year, month)) +
			(period == 'D' ? offset : 0);
		var date = this._restrictMinMax(inst,
			this._daylightSavingAdjust(new Date(year, month, day)));
		inst.selectedDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = date.getFullYear();
		if (period == 'M' || period == 'Y')
			this._notifyChange(inst);
	},

	/* Ensure a date is within any min/max bounds. */
	_restrictMinMax: function(inst, date) {
		var minDate = this._getMinMaxDate(inst, 'min');
		var maxDate = this._getMinMaxDate(inst, 'max');
		var newDate = (minDate && date < minDate ? minDate : date);
		newDate = (maxDate && newDate > maxDate ? maxDate : newDate);
		return newDate;
	},

	/* Notify change of month/year. */
	_notifyChange: function(inst) {
		var onChange = this._get(inst, 'onChangeMonthYear');
		if (onChange)
			onChange.apply((inst.input ? inst.input[0] : null),
				[inst.selectedYear, inst.selectedMonth + 1, inst]);
	},

	/* Determine the number of months to show. */
	_getNumberOfMonths: function(inst) {
		var numMonths = this._get(inst, 'numberOfMonths');
		return (numMonths == null ? [1, 1] : (typeof numMonths == 'number' ? [1, numMonths] : numMonths));
	},

	/* Determine the current maximum date - ensure no time components are set. */
	_getMinMaxDate: function(inst, minMax) {
		return this._determineDate(inst, this._get(inst, minMax + 'Date'), null);
	},

	/* Find the number of days in a given month. */
	_getDaysInMonth: function(year, month) {
		return 32 - this._daylightSavingAdjust(new Date(year, month, 32)).getDate();
	},

	/* Find the day of the week of the first of a month. */
	_getFirstDayOfMonth: function(year, month) {
		return new Date(year, month, 1).getDay();
	},

	/* Determines if we should allow a "next/prev" month display change. */
	_canAdjustMonth: function(inst, offset, curYear, curMonth) {
		var numMonths = this._getNumberOfMonths(inst);
		var date = this._daylightSavingAdjust(new Date(curYear,
			curMonth + (offset < 0 ? offset : numMonths[0] * numMonths[1]), 1));
		if (offset < 0)
			date.setDate(this._getDaysInMonth(date.getFullYear(), date.getMonth()));
		return this._isInRange(inst, date);
	},

	/* Is the given date in the accepted range? */
	_isInRange: function(inst, date) {
		var minDate = this._getMinMaxDate(inst, 'min');
		var maxDate = this._getMinMaxDate(inst, 'max');
		return ((!minDate || date.getTime() >= minDate.getTime()) &&
			(!maxDate || date.getTime() <= maxDate.getTime()));
	},

	/* Provide the configuration settings for formatting/parsing. */
	_getFormatConfig: function(inst) {
		var shortYearCutoff = this._get(inst, 'shortYearCutoff');
		shortYearCutoff = (typeof shortYearCutoff != 'string' ? shortYearCutoff :
			new Date().getFullYear() % 100 + parseInt(shortYearCutoff, 10));
		return {shortYearCutoff: shortYearCutoff,
			dayNamesShort: this._get(inst, 'dayNamesShort'), dayNames: this._get(inst, 'dayNames'),
			monthNamesShort: this._get(inst, 'monthNamesShort'), monthNames: this._get(inst, 'monthNames')};
	},

	/* Format the given date for display. */
	_formatDate: function(inst, day, month, year) {
		if (!day) {
			inst.currentDay = inst.selectedDay;
			inst.currentMonth = inst.selectedMonth;
			inst.currentYear = inst.selectedYear;
		}
		var date = (day ? (typeof day == 'object' ? day :
			this._daylightSavingAdjust(new Date(year, month, day))) :
			this._daylightSavingAdjust(new Date(inst.currentYear, inst.currentMonth, inst.currentDay)));
		return this.formatDate(this._get(inst, 'dateFormat'), date, this._getFormatConfig(inst));
	}
});

/* jQuery extend now ignores nulls! */
function extendRemove(target, props) {
	$.extend(target, props);
	for (var name in props)
		if (props[name] == null || props[name] == undefined)
			target[name] = props[name];
	return target;
};

/* Determine whether an object is an array. */
function isArray(a) {
	return (a && (($.browser.safari && typeof a == 'object' && a.length) ||
		(a.constructor && a.constructor.toString().match(/\Array\(\)/))));
};

/* Invoke the datepicker functionality.
   @param  options  string - a command, optionally followed by additional parameters or
                    Object - settings for attaching new datepicker functionality
   @return  jQuery object */
$.fn.datepicker = function(options){

	/* Verify an empty collection wasn't passed - Fixes #6976 */
	if ( !this.length ) {
		return this;
	}

	/* Initialise the date picker. */
	if (!$.datepicker.initialized) {
		$(document).mousedown($.datepicker._checkExternalClick).
			find('body').append($.datepicker.dpDiv);
		$.datepicker.initialized = true;
	}

	var otherArgs = Array.prototype.slice.call(arguments, 1);
	if (typeof options == 'string' && (options == 'isDisabled' || options == 'getDate' || options == 'widget'))
		return $.datepicker['_' + options + 'Datepicker'].
			apply($.datepicker, [this[0]].concat(otherArgs));
	if (options == 'option' && arguments.length == 2 && typeof arguments[1] == 'string')
		return $.datepicker['_' + options + 'Datepicker'].
			apply($.datepicker, [this[0]].concat(otherArgs));
	return this.each(function() {
		typeof options == 'string' ?
			$.datepicker['_' + options + 'Datepicker'].
				apply($.datepicker, [this].concat(otherArgs)) :
			$.datepicker._attachDatepicker(this, options);
	});
};

$.datepicker = new Datepicker(); // singleton instance
$.datepicker.initialized = false;
$.datepicker.uuid = new Date().getTime();
$.datepicker.version = "1.8.11";

// Workaround for #4055
// Add another global to avoid noConflict issues with inline event handlers
window['DP_jQuery_' + dpuuid] = $;

})(jQuery);

jQuery(function($){
     var shortestDays = [
            "Su",
            "Mo",
            "Tu",
            "We",
            "Th",
            "Fr",
            "Sa"
    ], shortDays = [
            "Sun",
            "Mon",
            "Tue",
            "Wed",
            "Thu",
            "Fri",
            "Sat"
    ], dayNames = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
    ], monthNames   = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"

    ], monthNamesShort = [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec"
    ];//no defaults as will let our internationalisation system handle it


    //we set the default so that we dont have to have lots of .js files handling the language
	$.datepicker.regional[''] = {
		closeText:   "Done",
		prevText:   "Prev",
		nextText:   "Next",
		currentText:   "Today",
		monthNames: monthNames,
		monthNamesShort: monthNamesShort,
		dayNames: dayNames,
		dayNamesShort: shortDays,
		dayNamesMin: shortestDays,
		weekHeader:  "wk",
		dateFormat: $.datepicker.ISO_8601,
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['']);
});
Raphael.spinner=function(k,f,h){var o=h||"#fff",n=f*13/60,s=f*35/60,p=f,d=p+n,c=p+n,m=Raphael(k,p*2+n*2,p*2+n*2),l=[],e=[],u=2*Math.PI/12,j={stroke:o,"stroke-width":n,"stroke-linecap":"round"};for(var q=0;q<12;q++){var g=u*q-Math.PI/2,b=Math.cos(g),a=Math.sin(g);e[q]=q/12;l[q]=m.path([["M",d+s*b,c+s*a],["L",d+p*b,c+p*a]]).attr(j)}var t;(function v(){e.unshift(e.pop());for(var r=0;r<12;r++){l[r].attr("opacity",e[r])}m.safari();t=setTimeout(v,80)})();return function(){clearTimeout(t);m.remove()}};
AJS.REST = (function($) {
    var baseUrl = "/rest/prototype/1/";

    AJS.safeHTML = function (html) {
        return html.replace(/[<>&"']/g, function (symbol) {
            return "&#" + symbol.charCodeAt() + ";";
        });
    };

    /**
     * Converts a single object in REST format into an object in the format expected by AJS.dropDown.
     */
    var getDropdownObjectForRestResult = function (result) {
        if (!result) {
            AJS.log("REST result is null");
            return null;
        }
        if (!result.link || !$.isArray(result.link)) {
            AJS.log("No link for result with title: " + result.title);
            return null;
        }
        if (!result.title) {
            AJS.log("No title for result with id: " + result.id);
            return null;
        }
        var obj = {
            href : encodeURI(AJS.REST.findLink(result.link)),
            name : AJS.safeHTML(result.title),
            spaceName: AJS.safeHTML(AJS.REST.findSpaceName(result)),
            restObj : result
        };
        if (result.thumbnailLink) {
            var versionQuery = result.version ? "?version="+result.version + "&modificationDate=" : "";
            obj.icon = result.thumbnailLink.href + versionQuery;
        } else {
            obj.className = result.iconClass || "content-type-" + result.type + (result.type == "space" ? "desc" : "");
        }
        return obj;
    };

    return {

        getBaseUrl: function() {
            return baseUrl;
        },

        /**
         * Takes a relative path,
         *
         *   e.g. 'session/history.json?max-results=20'
         *
         * and prefixes it with the context and REST paths to form a complete '/'-based URL,
         *
         * e.g.  '/confluence/rest/prototype/1/session/history.json?max-results=20'
         *
         * @param path end of URL to be prefixed
         */
        makeUrl: function (path) {
            return Confluence.getContextPath() + baseUrl + path;
        },

        /**
         * Iterates through the links array to find the first matching link of the given type and rel.
         * @param links typically the link field on a REST JSON object
         * @param type type of link. Defaults to "text/html" if not defined.
         * @param rel relationship of the link. Defaults to "alternate".
         */
        findLink: function(links, type, rel) {
            if (!type) type = "text/html";
            if (!rel) rel = "alternate";
            if (AJS.$.isArray(links)) {
                for (var i=0,ii=links.length; i<ii; i++) {
                    var link = links[i];
                    if (link.type == type && link.rel == rel) {
                        return link.href;
                    }
                }
            }
            return "#";
        },

        findSpaceName: function(restObj){
            if (restObj.space){
                return restObj.space.name;
            }
            return "";
        },

        /**
         * Converts a matrix in REST format into a matrix in the format expected by AJS.dropDown.
         *
         * @param restMatrix matrix of objects in Confluence REST format
         * @return matrix of objects in Confluence drop-down format
         */
        convertFromRest: function (restMatrix) {
            var matrix = [], catArray, obj;
            for (var i = 0, len = restMatrix.length; i < len; i++) {
                catArray = [];
                for (var j = 0, len2 = restMatrix[i].length; j < len2; j++) {
                    obj = getDropdownObjectForRestResult(restMatrix[i][j]);
                    obj && catArray.push(obj);
                }
                catArray.length && matrix.push(catArray);
            }
            return matrix;
        },

        /**
         * Given an ContentEntityObject's REST data construct the alias, destination, href and wiki-markup.
         *
         * @param data - the content data in REST format
         */
        wikiLink : function (data) {
            var alias = data.title,
                destination = data.wikiLink && data.wikiLink.slice(1, -1); // remove the [ and ]

            // CONF-18940 strip off the space key and page title if linking to an attachment on the current page
            if (destination && data.type == "attachment" && data.space && data.space.key == AJS.Meta.get('space-key') &&
                data.ownerId == AJS.params.attachmentSourceContentId) {
                    destination = destination.substring(destination.indexOf("^"));
            }

            var wikiMarkup = destination && (alias != destination ? (alias + "|") : "") + destination;
            AJS.log("tinymce.confluence.Autocompleter.Manager.makeLinkDetails =>" + wikiMarkup);

            return {
                alias : alias,
                destination : destination,
                href : this.findLink(data.link),
                wikiMarkup : wikiMarkup
            };
        },

        /**
         * Converts an object in REST format into a matrix containing the REST data.
         *
         * @async - called from an AJAX callback method
         * @param restObj object in Confluence REST format
         */
        makeRestMatrixFromData: function (restObj, suggestionField) {
            var restMatrix = [];
            var resultArr = eval("restObj." + suggestionField);
            if (resultArr && resultArr.length)
                    restMatrix.push(resultArr);
            return restMatrix;
        },

        /**
         * Converts an object in REST format into a matrix containing the search REST data.
         *
         * @async - called from an AJAX callback method
         * @param restObj object in Confluence REST format
         * @param suggestionField - the name of the field in the resObj that stores the suggestion. If null, "group" is used.
         * The "group" is the field used for in the /search/name REST service. 
         */
        makeRestMatrixFromSearchData: function(restObj, suggestionField) {
            var restMatrix = [];
            suggestionField = suggestionField || "group";
            var resultArr = eval("restObj." + suggestionField);
            if (resultArr) {

                var set = {
                    content: [],
                    attachment: [],
                    userinfo: [],
                    spacedesc: [],
                    page: [],
                    blogpost: [],
                    comment: [],
                    personalspacedesc: [],
                    mail: []
                };
                for (var i = 0, ii = resultArr.length; i < ii; i++) {
                    var group = resultArr[i];
                    set[group.name] && set[group.name].push(group.result);
                }

                // This line determines the order that the search sections appear. Don't change this unless you have to.
                restMatrix = restMatrix.concat(set.content, set.attachment, set.userinfo, set.spacedesc, set.page, set.blogpost, set.comment, set.personalspacedesc, set.mail);
            }
            else {
                log("makeRestMatrixFromData", "WARNING: Unknown rest object", restObj);
            }

            return restMatrix;
        }
    };
})(AJS.$);

/*
 * Copyright 2008 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Utility functions and classes for Soy.
//
// The top portion of this file contains utilities for Soy users:
//   + soy.StringBuilder: Compatible with the 'stringbuilder' code style.
//   + soy.renderElement: Render template and set as innerHTML of an element.
//   + soy.renderAsFragment: Render template and return as HTML fragment.
//
// The bottom portion of this file contains utilities that should only be called
// by Soy-generated JS code. Please do not use these functions directly from
// your hand-writen code. Their names all start with '$$'.

/**
 * Base name for the soy utilities, when used outside of Closure Library.
 * Check to see soy is already defined in the current scope before asigning to
 * prevent clobbering if soyutils.js is loaded more than once.
 * @type {Object}
 */
var soy = soy || {};


// Just enough browser detection for this file.
(function() {
  var ua = navigator.userAgent;
  var isOpera = ua.indexOf('Opera') == 0;
  /**
   * @type {boolean}
   * @private
   */
  soy.IS_OPERA_ = isOpera;
  /**
   * @type {boolean}
   * @private
   */
  soy.IS_IE_ = !isOpera && ua.indexOf('MSIE') != -1;
  /**
   * @type {boolean}
   * @private
   */
  soy.IS_WEBKIT_ = !isOpera && ua.indexOf('WebKit') != -1;
})();


// -----------------------------------------------------------------------------
// StringBuilder (compatible with the 'stringbuilder' code style).


/**
 * Utility class to facilitate much faster string concatenation in IE,
 * using Array.join() rather than the '+' operator.  For other browsers
 * we simply use the '+' operator.
 *
 * @param {Object|number|string|boolean=} opt_a1 Optional first initial item
 *     to append.
 * @param {Object|number|string|boolean} var_args Other initial items to
 *     append, e.g., new soy.StringBuilder('foo', 'bar').
 * @constructor
 */
soy.StringBuilder = function(opt_a1, var_args) {

  /**
   * Internal buffer for the string to be concatenated.
   * @type {string|Array}
   * @private
   */
  this.buffer_ = soy.IS_IE_ ? [] : '';

  if (opt_a1 != null) {
    this.append.apply(this, arguments);
  }
};


/**
 * Length of internal buffer (faster than calling buffer_.length).
 * Only used for IE.
 * @type {number}
 * @private
 */
soy.StringBuilder.prototype.bufferLength_ = 0;


/**
 * Appends one or more items to the string.
 *
 * Calling this with null, undefined, or empty arguments is an error.
 *
 * @param {Object|number|string|boolean} a1 Required first string.
 * @param {Object|number|string|boolean=} opt_a2 Optional second string.
 * @param {Object|number|string|boolean} var_args Other items to append,
 *     e.g., sb.append('foo', 'bar', 'baz').
 * @return {soy.StringBuilder} This same StringBuilder object.
 */
soy.StringBuilder.prototype.append = function(a1, opt_a2, var_args) {

  if (soy.IS_IE_) {
    if (opt_a2 == null) {  // no second argument (note: undefined == null)
      // Array assignment is 2x faster than Array push.  Also, use a1
      // directly to avoid arguments instantiation, another 2x improvement.
      this.buffer_[this.bufferLength_++] = a1;
    } else {
      this.buffer_.push.apply(this.buffer_, arguments);
      this.bufferLength_ = this.buffer_.length;
    }

  } else {

    // Use a1 directly to avoid arguments instantiation for single-arg case.
    this.buffer_ += a1;
    if (opt_a2 != null) {  // no second argument (note: undefined == null)
      for (var i = 1; i < arguments.length; i++) {
        this.buffer_ += arguments[i];
      }
    }
  }

  return this;
};


/**
 * Clears the string.
 */
soy.StringBuilder.prototype.clear = function() {

  if (soy.IS_IE_) {
     this.buffer_.length = 0;  // reuse array to avoid creating new object
     this.bufferLength_ = 0;

   } else {
     this.buffer_ = '';
   }
};


/**
 * Returns the concatenated string.
 *
 * @return {string} The concatenated string.
 */
soy.StringBuilder.prototype.toString = function() {

  if (soy.IS_IE_) {
    var str = this.buffer_.join('');
    // Given a string with the entire contents, simplify the StringBuilder by
    // setting its contents to only be this string, rather than many fragments.
    this.clear();
    if (str) {
      this.append(str);
    }
    return str;

  } else {
    return /** @type {string} */ (this.buffer_);
  }
};


// -----------------------------------------------------------------------------
// Public utilities.


/**
 * Helper function to render a Soy template and then set the output string as
 * the innerHTML of an element. It is recommended to use this helper function
 * instead of directly setting innerHTML in your hand-written code, so that it
 * will be easier to audit the code for cross-site scripting vulnerabilities.
 *
 * @param {Element} element The element whose content we are rendering.
 * @param {Function} template The Soy template defining the element's content.
 * @param {Object=} opt_templateData The data for the template.
 */
soy.renderElement = function(element, template, opt_templateData) {
  element.innerHTML = template(opt_templateData);
};


/**
 * Helper function to render a Soy template into a single node or a document
 * fragment. If the rendered HTML string represents a single node, then that
 * node is returned. Otherwise a document fragment is returned containing the
 * rendered nodes.
 *
 * @param {Function} template The Soy template defining the element's content.
 * @param {Object=} opt_templateData The data for the template.
 * @return {Node} The resulting node or document fragment.
 */
soy.renderAsFragment = function(template, opt_templateData) {

  var tempDiv = document.createElement('div');
  tempDiv.innerHTML = template(opt_templateData);
  if (tempDiv.childNodes.length == 1) {
    return tempDiv.firstChild;
  } else {
    var fragment = document.createDocumentFragment();
    while (tempDiv.firstChild) {
      fragment.appendChild(tempDiv.firstChild);
    }
    return fragment;
  }
};


// -----------------------------------------------------------------------------
// Below are private utilities to be used by Soy-generated code only.


/**
 * Builds an augmented data object to be passed when a template calls another,
 * and needs to pass both original data and additional params. The returned
 * object will contain both the original data and the additional params. If the
 * same key appears in both, then the value from the additional params will be
 * visible, while the value from the original data will be hidden. The original
 * data object will be used, but not modified.
 *
 * @param {!Object} origData The original data to pass.
 * @param {Object} additionalParams The additional params to pass.
 * @return {Object} An augmented data object containing both the original data
 *     and the additional params.
 */
soy.$$augmentData = function(origData, additionalParams) {

  // Create a new object whose '__proto__' field is set to origData.
  /** @constructor */
  function tempCtor() {};
  tempCtor.prototype = origData;
  var newData = new tempCtor();

  // Add the additional params to the new object.
  for (var key in additionalParams) {
    newData[key] = additionalParams[key];
  }

  return newData;
};


/**
 * Escapes HTML special characters in a string. Escapes double quote '"' in
 * addition to '&', '<', and '>' so that a string can be included in an HTML
 * tag attribute value within double quotes.
 *
 * @param {*} str The string to be escaped. Can be other types, but the value
 *     will be coerced to a string.
 * @return {string} An escaped copy of the string.
*/
soy.$$escapeHtml = function(str) {

  str = String(str);

  // This quick test helps in the case when there are no chars to replace, in
  // the worst case this makes barely a difference to the time taken.
  if (!soy.$$EscapeHtmlRe_.ALL_SPECIAL_CHARS.test(str)) {
    return str;
  }

  // Since we're only checking one char at a time, we use String.indexOf(),
  // which is faster than RegExp.test(). Important: Must replace '&' first!
  if (str.indexOf('&') != -1) {
    str = str.replace(soy.$$EscapeHtmlRe_.AMP, '&amp;');
  }
  if (str.indexOf('<') != -1) {
    str = str.replace(soy.$$EscapeHtmlRe_.LT, '&lt;');
  }
  if (str.indexOf('>') != -1) {
    str = str.replace(soy.$$EscapeHtmlRe_.GT, '&gt;');
  }
  if (str.indexOf('"') != -1) {
    str = str.replace(soy.$$EscapeHtmlRe_.QUOT, '&quot;');
  }
  return str;
};

/**
 * Regular expressions used within escapeHtml().
 * @enum {RegExp}
 * @private
 */
soy.$$EscapeHtmlRe_ = {
  ALL_SPECIAL_CHARS: /[&<>\"]/,
  AMP: /&/g,
  LT: /</g,
  GT: />/g,
  QUOT: /\"/g
};


/**
 * Escapes characters in the string to make it a valid content for a JS string literal.
 *
 * @param {*} s The string to be escaped. Can be other types, but the value
 *     will be coerced to a string.
 * @return {string} An escaped copy of the string.
*/
soy.$$escapeJs = function(s) {
  s = String(s);
  var sb = [];
  for (var i = 0; i < s.length; i++) {
    sb[i] = soy.$$escapeChar(s.charAt(i));
  }
  return sb.join('');
};


/**
 * Takes a character and returns the escaped string for that character. For
 * example escapeChar(String.fromCharCode(15)) -> "\\x0E".
 * @param {string} c The character to escape.
 * @return {string} An escaped string representing {@code c}.
 */
soy.$$escapeChar = function(c) {
  if (c in soy.$$escapeCharJs_) {
    return soy.$$escapeCharJs_[c];
  }
  var rv = c;
  var cc = c.charCodeAt(0);
  if (cc > 31 && cc < 127) {
    rv = c;
  } else {
    // tab is 9 but handled above
    if (cc < 256) {
      rv = '\\x';
      if (cc < 16 || cc > 256) {
        rv += '0';
      }
    } else {
      rv = '\\u';
      if (cc < 4096) { // \u1000
        rv += '0';
      }
    }
    rv += cc.toString(16).toUpperCase();
  }

  return soy.$$escapeCharJs_[c] = rv;
};

/**
 * Character mappings used internally for soy.$$escapeJs
 * @private
 * @type {Object}
 */
soy.$$escapeCharJs_ = {
  '\b': '\\b',
  '\f': '\\f',
  '\n': '\\n',
  '\r': '\\r',
  '\t': '\\t',
  '\x0B': '\\x0B', // '\v' is not supported in JScript
  '"': '\\"',
  '\'': '\\\'',
  '\\': '\\\\'
};


/**
 * Escapes a string so that it can be safely included in a URI.
 *
 * @param {*} str The string to be escaped. Can be other types, but the value
 *     will be coerced to a string.
 * @return {string} An escaped copy of the string.
*/
soy.$$escapeUri = function(str) {

  str = String(str);

  // Checking if the search matches before calling encodeURIComponent avoids an
  // extra allocation in IE6. This adds about 10us time in FF and a similiar
  // over head in IE6 for lower working set apps, but for large working set
  // apps, it saves about 70us per call.
  if (!soy.$$ENCODE_URI_REGEXP_.test(str)) {
    return encodeURIComponent(str);
  } else {
    return str;
  }
};

/**
 * Regular expression used for determining if a string needs to be encoded.
 * @type {RegExp}
 * @private
 */
soy.$$ENCODE_URI_REGEXP_ = /^[a-zA-Z0-9\-_.!~*'()]*$/;


/**
 * Inserts word breaks ('wbr' tags) into a HTML string at a given interval. The
 * counter is reset if a space is encountered. Word breaks aren't inserted into
 * HTML tags or entities. Entites count towards the character count; HTML tags
 * do not.
 *
 * @param {*} str The HTML string to insert word breaks into. Can be other
 *     types, but the value will be coerced to a string.
 * @param {number} maxCharsBetweenWordBreaks Maximum number of non-space
 *     characters to allow before adding a word break.
 * @return {string} The string including word breaks.
 */
soy.$$insertWordBreaks = function(str, maxCharsBetweenWordBreaks) {

  str = String(str);

  var resultArr = [];
  var resultArrLen = 0;

  // These variables keep track of important state while looping through str.
  var isInTag = false;  // whether we're inside an HTML tag
  var isMaybeInEntity = false;  // whether we might be inside an HTML entity
  var numCharsWithoutBreak = 0;  // number of characters since last word break
  var flushIndex = 0;  // index of first char not yet flushed to resultArr

  for (var i = 0, n = str.length; i < n; ++i) {
    var charCode = str.charCodeAt(i);

    // If hit maxCharsBetweenWordBreaks, and not space next, then add <wbr>.
    if (numCharsWithoutBreak >= maxCharsBetweenWordBreaks &&
        charCode != soy.$$CharCode_.SPACE) {
      resultArr[resultArrLen++] = str.substring(flushIndex, i);
      flushIndex = i;
      resultArr[resultArrLen++] = soy.WORD_BREAK_;
      numCharsWithoutBreak = 0;
    }

    if (isInTag) {
      // If inside an HTML tag and we see '>', it's the end of the tag.
      if (charCode == soy.$$CharCode_.GREATER_THAN) {
        isInTag = false;
      }

    } else if (isMaybeInEntity) {
      switch (charCode) {
        // If maybe inside an entity and we see ';', it's the end of the entity.
        // The entity that just ended counts as one char, so increment
        // numCharsWithoutBreak.
        case soy.$$CharCode_.SEMI_COLON:
          isMaybeInEntity = false;
          ++numCharsWithoutBreak;
          break;
        // If maybe inside an entity and we see '<', we weren't actually in an
        // entity. But now we're inside and HTML tag.
        case soy.$$CharCode_.LESS_THAN:
          isMaybeInEntity = false;
          isInTag = true;
          break;
        // If maybe inside an entity and we see ' ', we weren't actually in an
        // entity. Just correct the state and reset the numCharsWithoutBreak
        // since we just saw a space.
        case soy.$$CharCode_.SPACE:
          isMaybeInEntity = false;
          numCharsWithoutBreak = 0;
          break;
      }

    } else {  // !isInTag && !isInEntity
      switch (charCode) {
        // When not within a tag or an entity and we see '<', we're now inside
        // an HTML tag.
        case soy.$$CharCode_.LESS_THAN:
          isInTag = true;
          break;
        // When not within a tag or an entity and we see '&', we might be inside
        // an entity.
        case soy.$$CharCode_.AMPERSAND:
          isMaybeInEntity = true;
          break;
        // When we see a space, reset the numCharsWithoutBreak count.
        case soy.$$CharCode_.SPACE:
          numCharsWithoutBreak = 0;
          break;
        // When we see a non-space, increment the numCharsWithoutBreak.
        default:
          ++numCharsWithoutBreak;
          break;
      }
    }
  }

  // Flush the remaining chars at the end of the string.
  resultArr[resultArrLen++] = str.substring(flushIndex);

  return resultArr.join('');
};

/**
 * Special characters used within insertWordBreaks().
 * @enum {number}
 * @private
 */
soy.$$CharCode_ = {
  SPACE: 32,  // ' '.charCodeAt(0)
  AMPERSAND: 38,  // '&'.charCodeAt(0)
  SEMI_COLON: 59,  // ';'.charCodeAt(0)
  LESS_THAN: 60,  // '<'.charCodeAt(0)
  GREATER_THAN: 62  // '>'.charCodeAt(0)
};

/**
 * String inserted as a word break by insertWordBreaks(). Safari requires
 * <wbr></wbr>, Opera needs the 'shy' entity, though this will give a visible
 * hyphen at breaks. Other browsers just use <wbr>.
 * @type {string}
 * @private
 */
soy.WORD_BREAK_ =
    soy.IS_WEBKIT_ ? '<wbr></wbr>' : soy.IS_OPERA_ ? '&shy;' : '<wbr>';


/**
 * Converts \r\n, \r, and \n to <br>s
 * @param {*} str The string in which to convert newlines.
 * @return {string} A copy of {@code str} with converted newlines.
 */
soy.$$changeNewlineToBr = function(str) {

  str = String(str);

  // This quick test helps in the case when there are no chars to replace, in
  // the worst case this makes barely a difference to the time taken.
  if (!soy.$$CHANGE_NEWLINE_TO_BR_RE_.test(str)) {
    return str;
  }

  return str.replace(/(\r\n|\r|\n)/g, '<br>');
};

/**
 * Regular expression used within $$changeNewlineToBr().
 * @type {RegExp}
 * @private
 */
soy.$$CHANGE_NEWLINE_TO_BR_RE_ = /[\r\n]/;


/**
 * Estimate the overall directionality of text. If opt_isHtml, makes sure to
 * ignore the LTR nature of the mark-up and escapes in text, making the logic
 * suitable for HTML and HTML-escaped text.
 * @param {string} text The text whose directionality is to be estimated.
 * @param {boolean=} opt_isHtml Whether text is HTML/HTML-escaped.
 *     Default: false.
 * @return {number} 1 if text is LTR, -1 if it is RTL, and 0 if it is neutral.
 */
soy.$$bidiTextDir = function(text, opt_isHtml) {
  text = soy.$$bidiStripHtmlIfNecessary_(text, opt_isHtml);
  if (!text) {
    return 0;
  }
  return soy.$$bidiDetectRtlDirectionality_(text) ? -1 : 1;
};


/**
 * Returns "dir=ltr" or "dir=rtl", depending on text's estimated
 * directionality, if it is not the same as bidiGlobalDir.
 * Otherwise, returns the empty string.
 * If opt_isHtml, makes sure to ignore the LTR nature of the mark-up and escapes
 * in text, making the logic suitable for HTML and HTML-escaped text.
 * @param {number} bidiGlobalDir The global directionality context: 1 if ltr, -1
 *     if rtl, 0 if unknown.
 * @param {string} text The text whose directionality is to be estimated.
 * @param {boolean=} opt_isHtml Whether text is HTML/HTML-escaped.
 *     Default: false.
 * @return {string} "dir=rtl" for RTL text in non-RTL context; "dir=ltr" for LTR
 *     text in non-LTR context; else, the empty string.
 */
soy.$$bidiDirAttr = function(bidiGlobalDir, text, opt_isHtml) {
  var dir = soy.$$bidiTextDir(text, opt_isHtml);
  if (dir != bidiGlobalDir) {
    return dir < 0 ? 'dir=rtl' : dir > 0 ? 'dir=ltr' : '';
  }
  return '';
};


/**
 * Returns a Unicode BiDi mark matching bidiGlobalDir (LRM or RLM) if the
 * directionality or the exit directionality of text are opposite to
 * bidiGlobalDir. Otherwise returns the empty string.
 * If opt_isHtml, makes sure to ignore the LTR nature of the mark-up and escapes
 * in text, making the logic suitable for HTML and HTML-escaped text.
 * @param {number} bidiGlobalDir The global directionality context: 1 if ltr, -1
 *     if rtl, 0 if unknown.
 * @param {string} text The text whose directionality is to be estimated.
 * @param {boolean=} opt_isHtml Whether text is HTML/HTML-escaped.
 *     Default: false.
 * @return {string} A Unicode bidi mark matching bidiGlobalDir, or
 *     the empty string when text's overall and exit directionalities both match
 *     bidiGlobalDir.
 */
soy.$$bidiMarkAfter = function(bidiGlobalDir, text, opt_isHtml) {
  var dir = soy.$$bidiTextDir(text, opt_isHtml);
  return soy.$$bidiMarkAfterKnownDir(bidiGlobalDir, dir, text, opt_isHtml);
};


/**
 * Returns a Unicode BiDi mark matching bidiGlobalDir (LRM or RLM) if the
 * directionality or the exit directionality of text are opposite to
 * bidiGlobalDir. Otherwise returns the empty string.
 * If opt_isHtml, makes sure to ignore the LTR nature of the mark-up and escapes
 * in text, making the logic suitable for HTML and HTML-escaped text.
 * @param {number} bidiGlobalDir The global directionality context: 1 if ltr, -1
 *     if rtl, 0 if unknown.
 * @param {number} dir text's directionality: 1 if ltr, -1 if rtl, 0 if unknown.
 * @param {string} text The text whose directionality is to be estimated.
 * @param {boolean=} opt_isHtml Whether text is HTML/HTML-escaped.
 *     Default: false.
 * @return {string} A Unicode bidi mark matching bidiGlobalDir, or
 *     the empty string when text's overall and exit directionalities both match
 *     bidiGlobalDir.
 */
soy.$$bidiMarkAfterKnownDir = function(bidiGlobalDir, dir, text, opt_isHtml) {
  return (
      bidiGlobalDir > 0 && (dir < 0 ||
          soy.$$bidiIsRtlExitText_(text, opt_isHtml)) ? '\u200E' : // LRM
      bidiGlobalDir < 0 && (dir > 0 ||
          soy.$$bidiIsLtrExitText_(text, opt_isHtml)) ? '\u200F' : // RLM
      '');
};


/**
 * Strips str of any HTML mark-up and escapes. Imprecise in several ways, but
 * precision is not very important, since the result is only meant to be used
 * for directionality detection.
 * @param {string} str The string to be stripped.
 * @param {boolean=} opt_isHtml Whether str is HTML / HTML-escaped.
 *     Default: false.
 * @return {string} The stripped string.
 * @private
 */
soy.$$bidiStripHtmlIfNecessary_ = function(str, opt_isHtml) {
  return opt_isHtml ? str.replace(soy.$$BIDI_HTML_SKIP_RE_, ' ') : str;
};


/**
 * Simplified regular expression for am HTML tag (opening or closing) or an HTML
 * escape - the things we want to skip over in order to ignore their ltr
 * characters.
 * @type {RegExp}
 * @private
 */
soy.$$BIDI_HTML_SKIP_RE_ = /<[^>]*>|&[^;]+;/g;


/**
 * Returns str wrapped in a <span dir=ltr|rtl> according to its directionality -
 * but only if that is neither neutral nor the same as the global context.
 * Otherwise, returns str unchanged.
 * Always treats str as HTML/HTML-escaped, i.e. ignores mark-up and escapes when
 * estimating str's directionality.
 * @param {number} bidiGlobalDir The global directionality context: 1 if ltr, -1
 *     if rtl, 0 if unknown.
 * @param {*} str The string to be wrapped. Can be other types, but the value
 *     will be coerced to a string.
 * @return {string} The wrapped string.
 */
soy.$$bidiSpanWrap = function(bidiGlobalDir, str) {
  str = String(str);
  var textDir = soy.$$bidiTextDir(str, true);
  var reset = soy.$$bidiMarkAfterKnownDir(bidiGlobalDir, textDir, str, true);
  if (textDir > 0 && bidiGlobalDir <= 0) {
    str = '<span dir=ltr>' + str + '</span>';
  } else if (textDir < 0 && bidiGlobalDir >= 0) {
    str = '<span dir=rtl>' + str + '</span>';
  }
  return str + reset;
};


/**
 * Returns str wrapped in Unicode BiDi formatting characters according to its
 * directionality, i.e. either LRE or RLE at the beginning and PDF at the end -
 * but only if str's directionality is neither neutral nor the same as the
 * global context. Otherwise, returns str unchanged.
 * Always treats str as HTML/HTML-escaped, i.e. ignores mark-up and escapes when
 * estimating str's directionality.
 * @param {number} bidiGlobalDir The global directionality context: 1 if ltr, -1
 *     if rtl, 0 if unknown.
 * @param {*} str The string to be wrapped. Can be other types, but the value
 *     will be coerced to a string.
 * @return {string} The wrapped string.
 */
soy.$$bidiUnicodeWrap = function(bidiGlobalDir, str) {
  str = String(str);
  var textDir = soy.$$bidiTextDir(str, true);
  var reset = soy.$$bidiMarkAfterKnownDir(bidiGlobalDir, textDir, str, true);
  if (textDir > 0 && bidiGlobalDir <= 0) {
    str = '\u202A' + str + '\u202C';
  } else if (textDir < 0 && bidiGlobalDir >= 0) {
    str = '\u202B' + str + '\u202C';
  }
  return str + reset;
};


/**
 * A practical pattern to identify strong LTR character. This pattern is not
 * theoretically correct according to unicode standard. It is simplified for
 * performance and small code size.
 * @type {string}
 * @private
 */
soy.$$bidiLtrChars_ =
    'A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u02B8\u0300-\u0590\u0800-\u1FFF' +
    '\u2C00-\uFB1C\uFDFE-\uFE6F\uFEFD-\uFFFF';


/**
 * A practical pattern to identify strong neutral and weak character. This
 * pattern is not theoretically correct according to unicode standard. It is
 * simplified for performance and small code size.
 * @type {string}
 * @private
 */
soy.$$bidiNeutralChars_ =
    '\u0000-\u0020!-@[-`{-\u00BF\u00D7\u00F7\u02B9-\u02FF\u2000-\u2BFF';


/**
 * A practical pattern to identify strong RTL character. This pattern is not
 * theoretically correct according to unicode standard. It is simplified for
 * performance and small code size.
 * @type {string}
 * @private
 */
soy.$$bidiRtlChars_ = '\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC';


/**
 * Regular expressions to check if a piece of text is of RTL directionality
 * on first character with strong directionality.
 * @type {RegExp}
 * @private
 */
soy.$$bidiRtlDirCheckRe_ = new RegExp(
    '^[^' + soy.$$bidiLtrChars_ + ']*[' + soy.$$bidiRtlChars_ + ']');


/**
 * Regular expressions to check if a piece of text is of neutral directionality.
 * Url are considered as neutral.
 * @type {RegExp}
 * @private
 */
soy.$$bidiNeutralDirCheckRe_ = new RegExp(
    '^[' + soy.$$bidiNeutralChars_ + ']*$|^http://');


/**
 * Check the directionality of the a piece of text based on the first character
 * with strong directionality.
 * @param {string} str string being checked.
 * @return {boolean} return true if rtl directionality is being detected.
 * @private
 */
soy.$$bidiIsRtlText_ = function(str) {
  return soy.$$bidiRtlDirCheckRe_.test(str);
};


/**
 * Check the directionality of the a piece of text based on the first character
 * with strong directionality.
 * @param {string} str string being checked.
 * @return {boolean} true if all characters have neutral directionality.
 * @private
 */
soy.$$bidiIsNeutralText_ = function(str) {
  return soy.$$bidiNeutralDirCheckRe_.test(str);
};


/**
 * This constant controls threshold of rtl directionality.
 * @type {number}
 * @private
 */
soy.$$bidiRtlDetectionThreshold_ = 0.40;


/**
 * Returns the RTL ratio based on word count.
 * @param {string} str the string that need to be checked.
 * @return {number} the ratio of RTL words among all words with directionality.
 * @private
 */
soy.$$bidiRtlWordRatio_ = function(str) {
  var rtlCount = 0;
  var totalCount = 0;
  var tokens = str.split(' ');
  for (var i = 0; i < tokens.length; i++) {
    if (soy.$$bidiIsRtlText_(tokens[i])) {
      rtlCount++;
      totalCount++;
    } else if (!soy.$$bidiIsNeutralText_(tokens[i])) {
      totalCount++;
    }
  }

  return totalCount == 0 ? 0 : rtlCount / totalCount;
};


/**
 * Check the directionality of a piece of text, return true if the piece of
 * text should be laid out in RTL direction.
 * @param {string} str The piece of text that need to be detected.
 * @return {boolean} true if this piece of text should be laid out in RTL.
 * @private
 */
soy.$$bidiDetectRtlDirectionality_ = function(str) {
  return soy.$$bidiRtlWordRatio_(str) >
    soy.$$bidiRtlDetectionThreshold_;
};


/**
 * Regular expressions to check if the last strongly-directional character in a
 * piece of text is LTR.
 * @type {RegExp}
 * @private
 */
soy.$$bidiLtrExitDirCheckRe_ = new RegExp(
    '[' + soy.$$bidiLtrChars_ + '][^' + soy.$$bidiRtlChars_ + ']*$');


/**
 * Regular expressions to check if the last strongly-directional character in a
 * piece of text is RTL.
 * @type {RegExp}
 * @private
 */
soy.$$bidiRtlExitDirCheckRe_ = new RegExp(
    '[' + soy.$$bidiRtlChars_ + '][^' + soy.$$bidiLtrChars_ + ']*$');


/**
 * Check if the exit directionality a piece of text is LTR, i.e. if the last
 * strongly-directional character in the string is LTR.
 * @param {string} str string being checked.
 * @param {boolean=} opt_isHtml Whether str is HTML / HTML-escaped.
 *     Default: false.
 * @return {boolean} Whether LTR exit directionality was detected.
 * @private
 */
soy.$$bidiIsLtrExitText_ = function(str, opt_isHtml) {
  str = soy.$$bidiStripHtmlIfNecessary_(str, opt_isHtml);
  return soy.$$bidiLtrExitDirCheckRe_.test(str);
};


/**
 * Check if the exit directionality a piece of text is RTL, i.e. if the last
 * strongly-directional character in the string is RTL.
 * @param {string} str string being checked.
 * @param {boolean=} opt_isHtml Whether str is HTML / HTML-escaped.
 *     Default: false.
 * @return {boolean} Whether RTL exit directionality was detected.
 * @private
 */
soy.$$bidiIsRtlExitText_ = function(str, opt_isHtml) {
  str = soy.$$bidiStripHtmlIfNecessary_(str, opt_isHtml);
  return soy.$$bidiRtlExitDirCheckRe_.test(str);
};
(function(a){Confluence={getContextPath:function(){return AJS.Meta.get("context-path")},getBaseUrl:function(){return AJS.$("#confluence-base-url").attr("content")||""},getBuildNumber:function(){return AJS.Meta.get("build-number")},runBinderComponents:function(){AJS.log("AJS.Confluence: run binder components");for(var b in Confluence.Binder){if(Confluence.Binder.hasOwnProperty(b)){try{Confluence.Binder[b]()}catch(c){AJS.log("Exception in initialising of component '"+b+"': "+c.message)}}}},placeFocus:function(){Confluence.Binder.placeFocus()},unescapeEntities:function(c){var b={amp:"&",lt:"<",gt:">","#39":"'",quot:'"'};if(c==null){return c}return(""+c).replace(/&[#\d\w]+;/g,function(e){var d=e.substring(1,e.length-1);return b[d]||e})}};Confluence.Binder={placeFocus:function(){var c,b=-1;AJS.$("input[data-focus]").each(function(){var e=AJS.$(this),d=e.attr("data-focus");if(d>b){b=d;c=e}});c&&c.focus()}}})(AJS.$);AJS.toInit(function(){Confluence.runBinderComponents()});AJS.Confluence=Confluence;Confluence.hintManager=function(b){if(!AJS.$.isArray(b)){throw new Error("Hints passed in must be an array of strings")}var a=Math.floor(Math.random()*b.length);return{getNextHint:function(){var c=b[a];a=(a+1)%b.length;return c}}};
(function(a){Confluence.Defaults={maxResults:50}})(AJS.$);
(function(){Confluence.Highlighter=function(e,a){var g,b;if(e&&e.length&&e[0]){var h=[];for(var d=0,f=e.length;d<f;d++){var c=e[d];c&&h.push(c.replace(/[\.\*\+\?\|\(\)\[\]{}\\]/g,"\\$"))}g=new RegExp("("+h.join("|")+")","gi");b=AJS.template(a||"<strong>{highlight}</strong>").fill({highlight:"$1"}).toString()}return{highlight:function(i,j){if(!i){return i}if(!j){i=AJS.template.escape(i)}if(!g){return i}return i.replace(g,b)}}}})();
AJS.Position=(function(a){return{spaceAboveBelow:function(k,e){var b=e.position().top,d,f,j,h=e.outerHeight(true),c,g,i;if(k.nodeName=="IFRAME"){d=k.contentWindow||k.contentDocument;c=a(k).height();f=a(d.document||d);g=b-f.scrollTop();if(!(a.browser.msie&&a.browser.version<=8)){g=g-a(window).scrollTop()}}else{f=a(k);c=f.height();g=b-f.position().top}i=c-g-h;return{above:g,below:i}}}})(AJS.$);
AJS.Confluence.cacheManager=function(c){var a={},b=[],c=c||30;return{get:function(d){return a[d]},put:function(d,e){a[d]=e;b.push(d);if(b.length>c){delete a[b.shift()]}},clear:function(){a={};b=[]}}};
Confluence.storageManager=function(a){return AJS.storageManager("confluence",a)};
(function(d){var c=function(f){AJS.log("InputDrivenDropDown: truncating text");var h=f.$.closest(".aui-dd-parent").width(),g=20;if(!h){f.$.width("25em");h=f.$.width()}d("a span:not(.icon)",f.$).each(function(){var j=d(this),i=AJS("var","&#8230;"),l=i.width(),k=false;j.wrapInner(d("<em>"));d("em",j).each(function(){var m=d(this);m.show();if(this.offsetLeft+this.offsetWidth+l>h-g){var t=this.childNodes,s=false;for(var o=t.length-1;o>=0;o--){var p=t[o],n=1,r=(p.nodeType==3)?"nodeValue":"innerHTML",q=p[r];do{if(n<=q.length){p[r]=q.substr(0,q.length-n++)}else{break}}while(this.offsetLeft+this.offsetWidth+l>h-g);if(n<=q.length){s=true;break}}if(s){k=true}else{m.hide()}}});if(k){j.append(i);this.elpss=i}})};var b=function(f){AJS.log("InputDrivenDropDown: add space names");d("a span:not(.icon)",f.$).each(function(){var i=d(this);var g;try{g=AJS.dropDown.getAdditionalPropertyValue(i,"spaceName")}catch(h){AJS.log("Problem getting space name: "+h.message)}var j=i.text();if(g){j+=" ("+AJS("i").html(g).text()+")"}i.attr("title",j)})};var e=function(k,g){var j=k.options,h=k.dd;if(h){h.hide();h.$.remove()}j.ajsDropDownOptions=j.ajsDropDownOptions||{};if(j.ajsDropDownOptions&&!j.ajsDropDownOptions.alignment){j.ajsDropDownOptions.alignment="left"}j.ajsDropDownOptions.selectionHandler=j.ajsDropDownOptions.selectionHandler||function(m,l){if(m.type!="click"){m.preventDefault();d("a",l).click();document.location=d("a",l).attr("href")}};var f=k.dd=AJS.dropDown(g.matrix,j.ajsDropDownOptions)[0];if(j.ajsDropDownOptions&&j.ajsDropDownOptions.className){f.$.addClass(j.ajsDropDownOptions.className)}if(j.dropdownPlacement){j.dropdownPlacement(f.$)}else{AJS.log("No dropdownPlacement function specified. Appending dropdown to the body.");d("body").append(f.$)}var i=new Confluence.Highlighter(g.queryTokens||[g.query]);d("li a:not(.dropdown-prevent-highlight) span",f.$).each(function(){var l=d(this);l.html(i.highlight(l.html(),true))});c(f);b(f);if(j.dropdownPostprocess){j.dropdownPostprocess(f.$)}f.show(k._effect);if(typeof j.onShow=="function"){j.onShow.call(f,f.$)}return f};function a(g,f){this._effect="appear";this._timer=null;this.id=g;this.options=f;this.inactive=false;this.busy=false;this.cacheManager=AJS.Confluence.cacheManager()}a.prototype.clearCache=function(){this.cacheManager.clear()};a.prototype.change=function(i,h){var g=this;if(i!=g._value){g._value=i;g.busy=false;clearTimeout(g._timer);if(h||(/\S{2,}/).test(i)){var j=g.cacheManager.get(i);if(j){e(g,j)}else{g.busy=true;var f=function(){g.options.getDataAndRunCallback.call(g,i,g.show)};if(g.options.dropDownDelay===0){f()}else{g._timer=setTimeout(function(){f()},g.options.dropDownDelay||200)}}}else{g.dd&&g.dd.hide()}}};a.prototype.hide=function(){this.dd&&this.dd.hide()};a.prototype.remove=function(){var f=this.dd;if(f){this.hide();f.$.remove()}this.inactive=true;this.options.onDeath&&this.options.onDeath()};a.prototype.show=function(g,i,h){if(this.inactive){AJS.log("Quick search abandoned before server response received, ignoring. "+this);return}var f={matrix:g,query:i,queryTokens:h};this.cacheManager.put(i,f);e(this,f);this.busy=false};AJS.inputDrivenDropdown=function(f){return new a("inputdriven-dropdown",f)}})(jQuery);
(function(a){a.fn.quicksearch=function(f,i,e){if(i){e.onShow=i}e.makeParams=e.makeParams||function(j){return{query:j}};var c=function(l){var m=l.statusMessage;var k;if(m){k=[[{html:l.statusMessage,className:"error"}]]}else{if(e.makeRestMatrixFromData){var j=e.makeRestMatrixFromData(l);k=AJS.REST.convertFromRest(j);if(e.addDropdownData){k=e.addDropdownData(k)}}else{k=l.contentNameMatches}}return k};var d,h;if(typeof f=="function"){h=f(),d=function(k){var j=f();if(j!=h){h=j;k.clearCache()}return j}}else{d=function(){return f}}e.getDataAndRunCallback=e.getDataAndRunCallback||function(m,n){var l=this,k=d(l,m),j=AJS.Meta.get("context-path")||"";a.ajax({type:"GET",dataType:"json",url:j+k,data:e.makeParams(m),success:function(p,q){a(window).trigger("quicksearch.ajax-success",{url:k,json:p,resultStatus:q});if(document.activeElement!=b[0]){return}var o=c(p);n.call(l,o,m,p.queryTokens)},global:false,timeout:5000,error:function(r,p,q){a(window).trigger("quicksearch.ajax-error",{url:k,xmlHttpRequest:r,resultStatus:p,errorThrown:q});if(document.activeElement!=b[0]){return}if(p=="timeout"){var o=c({statusMessage:"Timeout",query:m});n.call(l,o,null)}}})};var g=AJS.inputDrivenDropdown(e),b=a(this);b.keyup(function(j){if(j.which==13||j.which==9){AJS.debug("quicksearchdropdown: enter or tab keyup");return}!b.hasClass("placeholded")&&g.change(this.value)});b.quickSearchControl=g;b.bind("clearCache.autocomplete",function(){g.clearCache()});b.bind("hide.autocomplete",function(){g.hide()});return b}})(jQuery);
AJS.Confluence.Binder.placeholder=function(){var b=AJS.$;var a=document.createElement("input");if("placeholder" in a){return}b('textarea[placeholder][data-placeholder-bound!="true"],input[placeholder][data-placeholder-bound!="true"],input.default-text[data-placeholder-bound!="true"]').each(function(){var e=b(this).attr("data-placeholder-bound","true");e.bind("reset.placeholder",function(h,g){var f=g.element.closest("form");f.bind("submit",function(){if(g.element.hasClass("placeholded")){g.element.val("")}})});var c=e.attr("placeholder")||e.attr("data-default-text"),d=function(){if(!b.trim(e.val()).length){e.val(c).addClass("placeholded").trigger("reset.placeholder",{element:e,defaultText:c});e.trigger("reset.default-text")}};d();e.blur(d).focus(function(){if(e.hasClass("placeholded")){e.val("");e.removeClass("placeholded")}})})};Confluence.Binder.inputDefaultText=Confluence.Binder.placeholder;
AJS.Confluence.Binder.insertOnEvent=function(){var a=AJS.$;a('.insert-on-event[data-inserter-bound!="true"]').each(function(){var f=a(this).attr("data-inserter-bound","true"),e=a(f.attr("data-target"))[0],c=f.attr("data-event"),d=f.attr("data-insert-position"),b=f.attr("data-insert-unique-key");if(e&&c&&d){a(self).bind(c,function(j,i){if(e==i.target){if(b){var g=i.content[b],h={};a(".key-holder",d).each(function(){h[a(this).attr("data-key")]=true});if(g in h){return}}a(d).append(AJS.template(f.text()).fill(i.content))}})}})};
Confluence.Binder.autocompleteUser=function(b){b=b||document.body;var c=AJS.$;var a=function(e){if(!e||!e.result){throw new Error("Invalid JSON format")}var d=[];d.push(e.result);return d};c('input.autocomplete-user[data-autocomplete-user-bound!="true"]',b).each(function(){var f=c(this).attr("data-autocomplete-user-bound","true").attr("autocomplete","off");var e=f.attr("data-max")||10,h=f.attr("data-alignment")||"left",g=f.attr("data-dropdown-target"),d=null;if(g){d=c(g)}else{d=c("<div></div>");f.after(d)}if(f.attr("data-resize-to-input")){d.width(f.outerWidth());d.addClass("resize-to-input")}d.addClass("aui-dd-parent autocomplete");f.quicksearch(AJS.REST.getBaseUrl()+"search/user.json",function(){f.trigger("open.autocomplete-user")},{makeParams:function(i){return{"max-results":e,query:i}},dropdownPlacement:function(i){d.append(i)},makeRestMatrixFromData:a,addDropdownData:function(i){if(!i.length){var j=f.attr("data-none-message");if(j){i.push([{name:j,className:"no-results",href:"#"}])}}return i},ajsDropDownOptions:{alignment:h,displayHandler:function(i){if(i.restObj&&i.restObj.username){return i.name+" ("+i.restObj.username+")"}return i.name},selectionHandler:function(n,k){if(k.find(".search-for").length){f.trigger("selected.autocomplete-user",{searchFor:f.val()});return}if(k.find(".no-results").length){this.hide();n.preventDefault();return}var i=c("span:eq(0)",k).data("properties"),o=i.restObj.username,l=f.attr("data-target"),m=l&&c(l),j=f.attr("data-template")||"{username}";f.val(AJS.template(j).fillHtml(i.restObj));m&&m.val(o);f.trigger("selected.autocomplete-user",{content:i.restObj});this.hide();n.preventDefault()}}})})};
(function(b){var a=function(f){if(!f||!f.group){throw new Error("Invalid JSON format")}var e=[];for(var g=0,h=f.group.length;g<h;g++){e.push(f.group[g].result)}return e};var d=function(p,i,f,g){var o=b(p),t="data-autocomplete-content-bound";if(o.attr(t)){return}if(typeof i=="string"){i=[i]}o.attr(t,"true").attr("autocomplete","off");var q=i.join(","),h=o.attr("data-max")||10,m=o.attr("data-alignment")||"left",l=o.attr("data-spacekey"),k=o.attr("data-none-message"),n=o.attr("data-search-link-message"),s=o.attr("data-template")||f,e=o.attr("data-target"),j=o.attr("data-dropdown-target"),r=null;if(j){r=b(j)}else{r=b("<div></div>");o.after(r)}r.addClass("aui-dd-parent autocomplete");o.focus(function(){l=o.attr("data-spacekey")});o.quicksearch(AJS.REST.getBaseUrl()+"search/name.json",null,{onShow:function(){o.trigger("open.autocomplete-content",{contentTypes:i})},makeParams:function(v){var u={"max-results":h,pageSize:h,type:q,query:v};if(l){u.spaceKey=l}return u},dropdownPlacement:function(u){r.append(u)},makeRestMatrixFromData:a,addDropdownData:function(v){if(!v.length){if(k){v.push([{name:k,className:"no-results",href:"#"}])}}if(n){var w=AJS.escapeHtml(o.val());var u=AJS.format(n,w);v.push([{className:"search-for",name:u,href:"#"}])}return v},ajsDropDownOptions:{alignment:m,displayHandler:g,selectionHandler:function(x,v){AJS.debug("autocomplete-content: ajsDropDownOptions.selectionHandler");if(v.find(".search-for").length){o.trigger("selected.autocomplete-content",{contentTypes:i,searchFor:o.val()});return}if(v.find(".no-results").length){AJS.log("no results selected");this.hide();x.preventDefault();return}var u=v.data("properties");o.val(AJS.template(s).fillHtml(u.restObj));if(e){var w=AJS.template(f).fillHtml(u.restObj);b(e).val(w)}o.trigger("selected.autocomplete-content",{contentTypes:i,content:u.restObj,selection:v});this.hide();x.preventDefault()}}})};Confluence.Binder.autocompleteSpace=function(e){e=e||document.body;b("input.autocomplete-space",e).each(function(){d(this,["spacedesc","personalspacedesc"],"{name}",function(f){return f.name})})};Confluence.Binder.autocompleteAttachment=function(e){e=e||document.body;b("input.autocomplete-attachment",e).each(function(){d(this,"attachment","{fileName}",function(f){var g=(f.restObj&&f.restObj.fileName)||f.name;if(f.restObj&&f.restObj.space&&f.restObj.space.title){g+=" ("+f.restObj.space.title+")"}return g})})};var c=function(e){return(e.restObj&&e.restObj.title&&AJS.escapeHtml(e.restObj.title))||e.name};Confluence.Binder.autocompletePage=function(e){e=e||document.body;b("input.autocomplete-page",e).each(function(){d(this,"page","{title}",c)})};Confluence.Binder.autocompleteBlogpost=function(e){e=e||document.body;b("input.autocomplete-blogpost",e).each(function(){d(this,"blogpost","{title}",c)})};Confluence.Binder.autocompleteConfluenceContent=function(e){e=e||document.body;b("input.autocomplete-confluence-content",e).each(function(){d(this,["page","blogpost"],"{title}",c)})};Confluence.Binder.autocompleteSearch=function(e){e=e||document.body;b("input.autocomplete-search",e).each(function(){d(this,[],"{title}",c)})}})(AJS.$);
(function(b){var a=function(c,e){var d;return b.extend({getForm:function(){return b("form",c.baseElement)},getUploadingMessageElement:function(){return b(".upload-in-progress",c.baseElement)},pack:function(){},displayErrors:function(f){d.displayMessages(f);this.pack()},clearErrors:function(){d.clearMessages();this.pack()},setUploadInProgress:function(g,h){var f=this.getUploadingMessageElement();if(g){f.html(h||this.getDefaultUploadingMessage())}AJS.setVisible(f,g);AJS.setVisible(this.getForm(),!g)},onUploadSuccess:function(){},getMessageHandler:function(){if(!d){d=AJS.MessageHandler({baseElement:b(".warning",c.baseElement)})}return d},getDefaultErrorMessage:function(){return "Could not upload the file to Confluence. The server may be unavailable."},getDefaultUploadingMessage:function(){return "File uploading&hellip;"},getContentId:function(){return AJS.Meta.get("attachment-source-content-id")}},e&&e(c))};Confluence.AttachmentUploader=function(d,g){var c,e,f;c=a(d,g);e=c.getMessageHandler();f=c.getForm();if(AJS.Meta.getBoolean("can-attach-files")){f.ajaxForm({dataType:"json",data:{contentId:c.getContentId(),responseFormat:"html"},resetForm:true,beforeSubmit:function(){c.setUploadInProgress(true);e.clearMessages()},success:function(h){c.setUploadInProgress(false);if(e.handleResponseErrors(h,c.getDefaultErrorMessage())){return}c.onUploadSuccess(h.attachmentsAdded||[])},error:function(h){c.setUploadInProgress(false);e.displayMessages(c.getDefaultErrorMessage());AJS.log("Response from server was: "+h.responseText)}});f.find("input:file").change(function(){f.submit()})}else{f.remove()}return c}})(AJS.$);
Confluence.Binder.userHover=(function(){var e=[],b=Confluence.getContextPath(),d=AJS.$;var a=function(h){var g=e[h],f={username:g,target:this};d(self).trigger("hover-user.open",f);d(".ajs-menu-bar",this).ajsMenu();d(".follow, .unfollow",this).each(function(){var i=d(this).click(function(k){if(i.hasClass("waiting")){return}var j=i.hasClass("unfollow")?"/unfollowuser.action":"/followuser.action";i.addClass("waiting");AJS.safe.post(b+j+"?username="+g+"&mode=blank",{},function(){i.removeClass("waiting");i.parent().toggleClass("follow-item").toggleClass("unfollow-item");d(self).trigger("hover-user.follow",f)});return AJS.stopEvent(k)})})};var c=["span.user-hover-trigger","a.confluence-userlink","img.confluence-userlink","a.userLogoLink"].join(", ");return function(){d(c).filter("[data-user-hover-bound!='true']").each(function(){var g=d(this),h=g.attr("data-username");g.attr("title","").attr("data-user-hover-bound","true");d("img",g).attr("title","");var f=d.inArray(h,e);if(f==-1){e.push(h);f=d.inArray(h,e)}d(this).addClass("userlink-"+f)});d.each(e,function(f){AJS.contentHover(d(".userlink-"+f),f,b+"/users/userinfopopup.action?username="+e[f],a)})}})();
(function(c){var e=[];var b=function(f){return f.hasClass("icon-remove-fav")};var a=function(g,i,h){var k=b(h),j=h.parent().find(".icon-wait"),f,l;if(i=="page"){f=Confluence.getContextPath()+"/json/"+(k?"removefavourite.action":"addfavourite.action");l={entityId:g}}if(i=="space"){f=Confluence.getContextPath()+"/json/"+(k?"removespacefromfavourites.action":"addspacetofavourites.action");l={key:g}}h.addClass("hidden");j.removeClass("hidden");AJS.safe.ajax({url:f,type:"POST",data:l,success:function(m){AJS.log(m);j.addClass("hidden");h.parent().find(k?".icon-add-fav":".icon-remove-fav").removeClass("hidden");delete e[g]},error:function(o,n,m){j.addClass("hidden");h.parent().find(k?".icon-remove-fav":".icon-add-fav").removeClass("hidden");AJS.log("Error Toggling Favourite: "+n);delete e[g]}})};var d=function(g,f){if(g.attr("data-favourites-bound")){return}g.delegate(".icon-add-fav, .icon-remove-fav","click",function(k){var i=c(k.target);var h,j=g.attr("data-entity-type");if(f&&f.getEntityId&&typeof f.getEntityId=="function"){h=f.getEntityId(i)}else{h=g.attr("data-entity-id")}if(e[h]){AJS.log("Already busy toggling favourite for "+j+" '"+h+"'. Ignoring request.");return}e[h]=true;a(h,j,i);return false});g.attr("data-favourites-bound",true)};AJS.Confluence.Binder.favourites=function(){c(".entity-favourites").each(function(){if(!c(this).attr("data-favourites-bound")){d(c(this),{})}})};c.fn.favourites=function(f){c(this).each(function(){var g=c(this);d(g,f)})}})(AJS.$);
(function(d){var e=[];var c=function(f){return f.hasClass("icon-stop-watching")};var b=function(h,j,i){var g=c(i),k=i.parent().find(".icon-wait"),f,l;if(j=="page"){f=Confluence.getContextPath()+"/users/"+(g?"removepagenotificationajax.action":"addpagenotificationajax.action");l={pageId:h}}if(j=="space"){f=Confluence.getContextPath()+"/users/"+(g?"removespacenotificationajax.action":"addspacenotificationajax.action");l={spaceKey:h}}i.addClass("hidden");k.removeClass("hidden");AJS.safe.ajax({url:f,type:"POST",data:l,success:function(m){AJS.log(m);k.addClass("hidden");i.parent().find(g?".icon-start-watching":".icon-stop-watching").removeClass("hidden");delete e[h]},error:function(o,n,m){k.addClass("hidden");i.parent().find(g?".icon-stop-watching":".icon-start-watching").removeClass("hidden");AJS.log("Error Toggling Watching: "+n);delete e[h]}})};var a=function(g,f){if(g.attr("data-watching-bound")){return}g.delegate(".icon-start-watching, .icon-stop-watching","click",function(k){var i=d(k.target);var h,j=g.attr("data-entity-type");if(f&&f.getEntityId&&typeof f.getEntityId=="function"){h=f.getEntityId(i)}else{h=g.attr("data-entity-id")}if(e[h]){AJS.log("Already busy toggling favourite for "+j+" '"+h+"'. Ignoring request.");return}e[h]=true;b(h,j,i);return false});g.attr("data-watching-bound",true)};AJS.Confluence.Binder.watching=function(){d(".entity-watching").each(function(){if(!d(this).attr("data-watching-bound")){a(d(this),{})}})};d.fn.watching=function(f){d(this).each(function(){var g=d(this);a(g,f)})}})(AJS.$);
// This file was automatically generated from dialog.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.Dialog == 'undefined') { Confluence.Templates.Dialog = {}; }


Confluence.Templates.Dialog.helpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.Dialog.customHelpLink({href: opt_data.href, text: soy.$$escapeHtml("Help")}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.Dialog.customHelpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="dialog-help-link"><a href="', soy.$$escapeHtml(opt_data.href), '" target="_blank">', soy.$$escapeHtml(opt_data.text), '</a></div>');
  if (!opt_sb) return output.toString();
};

(function(d){var b=function(h,j){var l=-11,g=d('<div class="aui-tip-parent"></div>');if(d.browser.msie&&d.browser.version<9){l=(parseInt(d.browser.version,10)<8)?-5:-13}var f=j?14:7;h.prepend(g).css({zIndex:3001});var i=Raphael(g[0],15,f),k=i.path("M0,6.0001l6.00001-6.00001,6.0001,6.0001").attr({fill:"#f0f0f0",stroke:"#e2e2e2"});i.canvas.style.zIndex=3000;tip=i;if(j){k.rotate(180);if(d.support.opacity){k.clone().translate(2,3).attr({fill:"#A0A0A0",stroke:"#A0A0A0",opacity:".5",blur:"1"}).toBack()}l=l+h.outerHeight()+10}g.css({top:l,left:10});return i},c=function(f,g){return Raphael.shadow(0,0,f.outerWidth(true),f.outerHeight(true),{radius:5,target:f[0],offset:2})},e=function(g,h,f,k){var i=f.outerHeight(),j=i+~~k,l=AJS.Position.spaceAboveBelow(g[0],h);if(l.below>=j){return false}return(l.above>=j)},a=function(g,f){f=f||{};setTimeout(function(){var k=AJS.Rte.Content.offset(g.anchor),p=g.panel.width()+k.left-d(window).width()+10,s=7,h=0,i=d(g.anchor).outerHeight(),o,j=k.left-(p>0?p:0)-h;if(g.shouldFlip){o=k.top-s-g.panel.outerHeight()-4}else{o=k.top+s+i}if(g.options.anchorIframe){var r=d(g.options.anchorIframe),n=r.offset().top+r.height()-g.panel.outerHeight()-10;o=Math.min(o,n)}g.panel.find(".aui-tip-parent").css({left:Math.abs(k.left-j)+10});j=Math.max(0,j);var m={top:o,left:j},q=g.panel.add(g.shadow),l=function(){if(g.shadow){g.shadow.css("left",g.panel.position().left-1)}};f.animate?q.animate(m,f.animateDuration,l):(function(){q.css(m);l()})()},f.delay||0)};AJS.Confluence.PropertyPanel={shouldCreate:true,current:null,createFromButtonModel:function(o,g,n,q){var f=AJS("div").attr({"class":"panel-buttons"});for(var k=0,p=n.length;k<p;k++){if(!n[k]){continue}var m=n[k],l=m.html||'<span class="icon"></span><span class="panel-button-text">'+(m.text||"")+"</span>",h=[];m.className&&h.push(m.className);m.disabled&&h.push("disabled");m.selected&&h.push("selected");!n[k+1]&&h.push("last");!n[k-1]&&h.push("first");var j;if(!m.html){j=AJS("a").attr({href:n[k].href||"#"}).html(l);if(m.disabled){j.attr("title",m.disabledText);j.disable();j.click(function(i){return AJS.stopEvent(i)})}else{n[k].click&&(function(r,i,s){i.click(function(t){r.click(i,s);return AJS.stopEvent(t)})})(n[k],j,g)}}else{j=d(m.html)}m.tooltip&&j.attr("title",m.tooltip);j.addClass(h.join(" "));f.append(j)}return this.create(o,g,f,q)},create:function(j,g,i,p){p=p||{};AJS.Rte.BookmarkManager.storeBookmark();var l=d("#property-panel"),f,n=p.enableFlip==undefined||p.enableFlip,o;l.length&&this.destroy();l=AJS("div").addClass("aui-property-panel-parent").addClass(j+"-panel").attr("id","property-panel").appendTo("body");f=AJS("div").addClass("aui-property-panel").append(i);l.append(f).css({top:0,left:-10000});o=n&&e(d(p.anchorIframe||d(g).parent()),d(g),l,10);var h=this;i.find(".last:last").css({margin:0});var m=c(l,o),k=b(l,o);this.current={anchor:g,panel:l,hasAnchorChanged:function(q){return q&&h.hasAnchorChanged(q)},snapToElement:function(q){a(this,q)},shouldFlip:o,shadow:m,tip:k,options:p,updating:true,type:j};a(this.current);f=this.current;AJS.$(document).bind("keydown.property-panel.escape",function(q){if(q.keyCode===27){AJS.Confluence.PropertyPanel.destroy()}});AJS.$(document).bind("click.property-panel",function(q){if(!AJS.$(q.target).closest("#property-panel").length){AJS.Confluence.PropertyPanel.destroy()}});AJS.trigger("created.property-panel",this.current);this.current.updating=false;return this.current},destroy:function(){if(!this.current){AJS.log("PropertyPanel.destroy: called with no current PropertyPanel, returning");return}if(this.current.updating){AJS.log("PropertyPanel.destroy: called while updating, returning");return}AJS.trigger("destroyed.property-panel",this.current);AJS.$(document).unbind(".property-panel").unbind(".contextToolbar");this.current.panel.remove();this.current.shadow&&this.current.shadow.remove();this.current=null},hasAnchorChanged:function(f){var g=this.current;if(g&&d(g.anchor)[0]==d(f)[0]){return(g.options.originalHeight&&(g.options.originalHeight!=d(f).height()))}return true}}})(AJS.$);
AJS.toInit(function(a){AJS.applySearchPlaceholders=function(c){var b=a(".quick-search-query, input[type=search]",c);if(!b.length){return}b.each(function(){var d=a(this);d.data("quicksearch",{placeholder:d.attr("placeholder")||d.closest("form").find("input[type='submit']").val(),placeholded:true})});if(!a.browser.safari){b.val(b.data("quicksearch").placeholder);b.addClass("placeholded");b.focus(function(){var d=a(this);if(d.data("quicksearch").placeholded){d.data("quicksearch").placeholded=false;d.val("");d.removeClass("placeholded")}});b.blur(function(){var d=a(this);if(d.data("quicksearch").placeholder&&(/^\s*$/).test(d.val())){d.val(d.data("quicksearch").placeholder);d.data("quicksearch").placeholded=true;d.addClass("placeholded")}})}else{b.each(function(){this.type="search"});b.attr("results",10);b.attr("placeholder",b.data("quicksearch").placeholder);b.val("")}};AJS.applySearchPlaceholders();a("#messageContainer .confluence-messages").each(function(){var b=this;if(!getCookie(b.id)){a(b).show();a(".message-close-button",b).click(function(){a(b).slideUp();setCookie(b.id,true)})}})});AJS.General={getContextPath:Confluence.getContextPath,getBaseUrl:Confluence.getBaseUrl};(function(){var a={};AJS.I18n={keys:{},get:function(g,b,c){var e=true,d=Confluence.getContextPath()+"/rest/prototype/1/i18n",h={locale:AJS.params.userLocale};if(AJS.$.isArray(g)){for(var f in g){if(!a[f]){e=false}}h.pluginKeys=g}else{e=a[g];d+="/"+g}if(e){if(typeof b=="function"){b(AJS.I18n.keys)}return}AJS.$.ajax({url:d,data:h,dataType:"json",success:function(i){AJS.I18n.load(i);a[g]=true;if(typeof b=="function"){b(i)}},error:function(i,j){AJS.log("Error loading I18n for "+g+":"+j);if(typeof c=="function"){c(j)}}})},load:function(b){AJS.$.extend(AJS.I18n.keys,b)},getText:function(b,c){var d=AJS.params["i18n."+b]||AJS.I18n.keys[b]||b;if(!c){return d}if(arguments.length==2&&c instanceof Array){c.unshift(d)}else{c=Array.prototype.slice.call(arguments,0);c[0]=d}return AJS.format.apply(AJS,c)}}})();jQuery.fn.selectableEffects=function(a,b,c){var e=jQuery,d=e(this);if(c){d.data("properties",c)}d.click(function(g){var f=e(this);if(b){b(this,f.data("properties"))}a.find(".selected").removeClass("selected");f.addClass("selected");return AJS.stopEvent(g)});d.hover(function(){e(this).addClass("hover")},function(){e(this).removeClass("hover")})};jQuery.fn.shortenUntil=function(d){var b=jQuery;var c=0;while(!d()&&c<this.length){var a=b(this[c]).text();if(a=="\u2026"){c++;continue}b(this[c]).text(a.replace(/[^\u2026]\u2026?$/,"\u2026"))}return this};
AJS.html=function(a){var b=new String(a);b.isHtml=true;return b};AJS.toInit(function(b){var a={};AJS.loadTemplateScripts=function(e){e=e||document;b("script",e).each(function(){if(this.type=="text/x-template"){a[this.title]=AJS.html(this.text)}})};AJS.loadTemplateScripts();AJS.getTemplate=function(e){return a[e]};var d={"&":"&amp;","<":"&lt;",">":"&gt;","'":"&#39;",'"':"&quot;"};AJS.escapeEntities=function(e){if(e==null){return e}if(e.isHtml){return""+e}return(""+e).replace(/[&<>'"]/g,function(f){return d[f]||f})};function c(f){var e=arguments;return f.replace(/\{(\d+)\}/g,function(j,g){var h=e[parseInt(g,10)+1];return h!=null?h:j})}AJS.renderTemplate=function(e,f){if(!AJS.getTemplate(e)){return""}if(!b.isArray(f)){f=Array.prototype.slice.call(arguments,1)}var j=AJS.getTemplate(e).toString();var h=[j];for(var g=0;g<f.length;g++){h.push(AJS.escapeEntities(f[g]))}return c.apply(this,h)};AJS.loadTemplatesFromUrl=function(e,g){var f=AJS.Meta.get("static-resource-url-prefix");if(e.indexOf("http")!=0&&e.indexOf(f)!=0){e=f+e}b.ajax({url:e,data:{locale:AJS.params.userLocale},dataType:"html",success:function(h){var i=AJS("div").append(h);AJS.loadTemplateScripts(i);g&&g()}})};AJS.loadWebResourceTemplates=function(e,g,h){var f="/download/resources/"+e+"/"+g;return this.loadTemplatesFromUrl(f,h)}});
AJS.menuShowCount=0;jQuery.fn.ajsMenu=function(i){i=i||{};var c=jQuery;var g=null;var f=function(j){if(typeof AJS.dropDownTimer!="undefined"&&AJS.dropDownHider){clearTimeout(AJS.dropDownTimer);delete AJS.dropDownTimer;AJS.dropDownHider();AJS.dropDownHider=null}};var d=function(){return c(".ajs-menu-bar.menu-bar-open").length>0};var h=function(j){c(j).closest(".ajs-menu-bar").find(".ajs-drop-down").each(function(k){this.hide()})};var e=function(j){return c(j).closest(".ajs-menu-bar").hasClass("menu-bar-open")};var b=function(j){c(j).closest(".ajs-menu-bar").addClass("menu-bar-open")};var a=function(j){c(j).closest(".ajs-menu-bar").removeClass("menu-bar-open")};c(".ajs-button",this).each(function(){c(this).mouseover(function(){var k=this;var m=e(k);h(k);if(m){var l=c(document);var j=function(){a(k);return false};l.unbind("click.menu");setTimeout(function(){l.one("click.menu",j)},1);b(k)}})});c(".ajs-menu-item",this).each(function(){var l=this,j=c(this),p=c(".ajs-drop-down",l);if(!p.length){return}p=p[0];p.hidden=true;p.focused=-1;p.hide=function(){if(!this.hidden){j.toggleClass("opened");var t=c(l.parentNode);if(t.find(".opened").length==0){a(l)}var s=c("a",this);c(this).toggleClass("assistive");this.hidden=true;c(document).unbind("click",this.fhide).unbind("keydown",this.fmovefocus).unbind("keypress",this.blocker);if(this.focused+1){c(s[this.focused]).removeClass("active")}this.focused=-1}};p.show=function(){if(typeof this.hidden=="undefined"||this.hidden){var s=this,w=c(this);w.toggleClass("assistive");j.toggleClass("opened");b(l);this.hidden=false;this.timer=setTimeout(function(){c(document).click(s.fhide)},1);c(document).keydown(s.fmovefocus).keypress(s.blocker);var t=c("a",s);t.each(function(y){var x=this.parentNode.parentNode;c(this).hover(function(z){if(x.focused+1){c(t[x.focused].parentNode).removeClass("active")}c(this.parentNode).addClass("active");x.focused=y},function(z){if(x.focused+1){c(t[x.focused].parentNode).removeClass("active")}x.focused=-1})});var v=(window.pageYOffset||document.documentElement.scrollTop);var u=v+c(window).height();w.removeClass("above");if(!i.isFixedPosition){if(w.offset().top+w.height()>u){w.addClass("above");if(w.offset().top<v){w.removeClass("above")}}}}};p.isMenuBarOpened=function(){return e(p)};p.closeOthers=function(){h(p)};p.fmovefocus=function(s){p.movefocus(s)};p.fhide=function(s){p.hide(s);return AJS.$(s.target).closest(".ajs-drop-down").length>0};p.blocker=function(s){var t=s.which;if(t==40||t==38){return false}};p.movefocus=function(u){var x=u.which,t=this.getElementsByTagName("a"),w=this.focused,s=(x==9),v;do{switch(x){case 40:case 9:if(u.shiftKey){this.focused--}else{this.focused++}break;case 38:this.focused--;break;case 27:this.hide();return false;default:return true}v=(this.focused<0||this.focused>t.length-1)}while(!v&&c(t[this.focused].parentNode).hasClass("assistive"));if(s&&v){if(w!=-1){c(t[w].parentNode).removeClass("active")}this.focused=-1;this.hide();return false}else{if(!s){if(this.focused<0){this.focused=t.length-1}else{if(this.focused>t.length-1){this.focused=0}}}}if(w>=0){c(t[w].parentNode).removeClass("active")}t[this.focused].focus();c(t[this.focused].parentNode).addClass("active");u.stopPropagation();u.preventDefault();return false};p.show();clearTimeout(p.timer);var m=c(p),k=m.offset();p.hide();var o=c(".trigger",l);if(o.length){var q=function(){clearTimeout(AJS.dropDownTimer);delete AJS.dropDownTimer;AJS.dropDownHider();AJS.dropDownHider=null;p.show()};var r=function(t){var s=typeof AJS.dropDownTimer!="undefined";g=p;if(s){q()}else{AJS.dropDownShower=function(){p.show();delete AJS.dropDownShowerTimer};AJS.dropDownShowerTimer=setTimeout(AJS.dropDownShower,t)}};var n=function(s){var t=typeof AJS.dropDownShowerTimer!="undefined";if(t){clearTimeout(AJS.dropDownShowerTimer);delete AJS.dropDownShowerTimer}if(typeof AJS.dropDownTimer!="undefined"){clearTimeout(AJS.dropDownTimer);delete AJS.dropDownHider}AJS.dropDownHider=function(){p.hide();delete AJS.dropDownTimer};AJS.dropDownTimer=setTimeout(AJS.dropDownHider,s)};j.mouseover(function(){if(p.isMenuBarOpened()){if(p.hidden){h(p);p.show()}}else{j.addClass("hover")}});j.mouseout(function(){if(!p.isMenuBarOpened()){j.removeClass("hover")}});o.click(function(){if(p.hidden){o.parent("li").removeClass("hover");var s=d();p.show();return s}else{p.hide();o.parent("li").addClass("hover");return false}})}})};AJS.toInit(function(c){c("#view-user-history-link").click(function(j){window.open(this.href,(this.id+"-popupwindow").replace(/-/g,"_"),"width=600, height=400, scrollbars, resizable");j.preventDefault();return false});var d=function(k,l){var m=c("#ajax-error");if(m.length==0){c("#com-atlassian-confluence").prepend("<div id='ajax-error'></div>");m=c("#ajax-error")}var j=c("<div>"+k+"</div>").text();if(c("div span:contains('"+j+"')").length==0){m.append("<span class='error'>"+k+"<a class='close'>Close</a></span>")}m.find("a.close").click(function(){var n=c(this).parent();c(n).slideUp(1000,function(){c(n).remove();if(c("#ajax-error").children(".error").length==0){c("#ajax-error").remove()}});return false});l.removeClass("waiting")};c("#page-favourite").click(function(l){var k=c(this);if(k.hasClass("waiting")){return AJS.stopEvent(l)}k.addClass("waiting");var j=Confluence.getContextPath()+"/json/addfavourite.action";if(k.hasClass("selected")){j=Confluence.getContextPath()+"/json/removefavourite.action"}AJS.safeAjax({url:j,type:"POST",dataType:"json",data:{entityId:AJS.params.pageId},success:function(n){if(n.actionErrors){for(var m=0;m<n.actionErrors.length;m++){d(n.actionErrors,k)}return}if(n.errorMessage){d(n.errorMessage,k);return}k.removeClass("waiting");k.toggleClass("selected");k.toggleClass("ie-page-favourite-selected")},error:function(m){d("Server error while updating favourite",k)}});return AJS.stopEvent(l)});var h=c("#page-watch"),i=c("#page-unwatch"),e=c(h.parent("li")),g=c(i.parent("li"));if(h.hasClass("inactive")){e.addClass("assistive")}if(i.hasClass("inactive")){g.addClass("assistive")}var f=function(j,k,l){k.addClass("waiting");AJS.safe.ajax({url:j,type:"POST",dataType:"json",data:{entityId:AJS.params.pageId},success:function(n){if(n.actionErrors){for(var m=0;m<n.actionErrors.length;m++){d(n.actionErrors,k)}return}if(n.errorMessage){d(n.errorMessage,k);return}k.removeClass("waiting");k.toggleClass("inactive");l.toggleClass("inactive");k.parent("li").toggleClass("assistive");l.parent("li").toggleClass("assistive")},error:function(m){k.removeClass("waiting");d("Server error while updating favourite",menuItem)}})};h.click(function(j){f(Confluence.getContextPath()+"/pages/startwatching.action",h,i);h.addClass("waiting");return AJS.stopEvent(j)});i.click(function(j){f(Confluence.getContextPath()+"/pages/stopwatching.action",i,h);i.addClass("waiting");return AJS.stopEvent(j)});var a=c("#action-menu-link"),b=c("#add-menu-link");if(a.length){a.next().addClass("most-right-menu-item")}else{if(b.length){b.next().addClass("most-right-menu-item")}}c(".ajs-menu-bar").ajsMenu({isFixedPosition:true})});AJS.$(function(a){a("#header-menu-bar .ajs-menu-item").each(function(){var c=a(this),d=a(".ajs-drop-down",this),b=c.width();if(b>d.width()){d.width(b.valueOf()+50);AJS.log("Dropdown width override occurred")}})});
jQuery.fn.simpleScrollTo=function(c){var e=jQuery;var a=e(this[0]);var b=e(c).position().top;var d=b+e(c).outerHeight()-a.outerHeight();if(b<0){a.scrollTop(a.scrollTop()+b)}else{if(d>0){a.scrollTop(a.scrollTop()+d)}}return this};
AJS.toInit(function(a){a("a#websudo-drop.drop-non-websudo").click(function(){a.getJSON(a(this).attr("href"),function(){a("li#confluence-message-websudo-message").slideUp()});return false})});
AJS.PagePermissions=AJS.PagePermissions||{};AJS.toInit(function(d){var g="user",s="group";var j=Confluence.getContextPath();var n=!!d("#rte-button-restrictions").length;var a=null;var k=null;var q=null;var m={addNames:function(v,x){var w=this;var u=v.replace(/\s*,\s*/g,",").split(",");var y=d("#waitImage");y.show();var z={name:u,type:x||"",pageId:AJS.Meta.get("parent-page-id"),spaceKey:AJS.Meta.get("space-key")};d.getJSON(j+"/pages/getentities.action",z,function(E){y.hide();for(var D=0,A=E.length;D<A;D++){var B=E[D].entity;w.addEntity(E[D]);var C=d.inArray(B.name,u);u.splice(C,1)}k.validator.handleNonExistentEntityNames(u)})},addEntity:function(w){if(!w){return}var v=w.entity;var u=w.report;var y=k.getPermissionType();if(k.validator.isDuplicateEntityForType(v,y)){q.highlightEntityRow(v,y);return}var x={entity:v,view:true,edit:true,report:u};q.addRow(x,y);Confluence.Binder.userHover();q.changedByUser();q.highlightEntityRow(v,y);k.nameField.removeFromNameInput(v.name)},makePermissionStrings:function(){var u=q.makePermissionMap(false);return{viewPermissionsUsers:u.user.view.join(","),editPermissionsUsers:u.user.edit.join(","),viewPermissionsGroups:u.group.view.join(","),editPermissionsGroups:u.group.edit.join(",")}},refreshLayout:function(){var z=d("#page-permissions-tables");var y=d("#update-page-restrictions-dialog");var w=y.outerHeight();var u=y.find("h2").outerHeight();var B=y.find(".dialog-button-panel").outerHeight();var x=w-(u+B);var A=d("#page-permissions-editor-form").outerHeight();var v=x-A;d("#update-page-restrictions-dialog .dialog-panel-body").height(x);z.height(v)}};d.extend(AJS.PagePermissions,{addUserPermissions:function(u){m.addNames(u,g)},addGroupPermissions:function(u){m.addNames(u,s)},makePermissionStrings:m.makePermissionStrings});function e(w){q.allowEditing(w.userCanEditRestrictions);q.resetInherited();if(!m.permissionsEdited){q.resetDirect()}if(!w){return}for(var x=0,z=w.permissions.length;x<z;x++){var F=w.permissions[x];var B=F[0].toLowerCase();var u=F[1];var D=F[2];var v=(u==g)?w.users[D]:w.groups[D];var E=F[3];var C=F[4];var y=+E&&E!=AJS.params.pageId;if(m.permissionsEdited&&!y){continue}var A={owningId:E,entity:v.entity,report:v.report};A[B]=true;A.owningTitle=C;A.inherited=y;q.addRow(A,B)}if(w.permissions.length>0){Confluence.Binder.userHover()}q.saveBackup();q.refresh()}function h(){var A=q.makePermissionMap(false),v=d("#rte-button-restrictions .icon"),z=d("#rte-button-restrictions .trigger-text"),x=[].concat(A.group.view).concat(A.user.view).concat(A.group.edit).concat(A.user.edit);if(x.length){v.removeClass("icon-unlocked").addClass("icon-locked");z.text("Restricted")}else{v.removeClass("icon-locked").addClass("icon-unlocked");z.text("Unrestricted")}m.permissionsEdited=false;var y=m.makePermissionStrings();for(var u in y){var w=y[u];d("#"+u).val(w);if(m.originalPermissions[u]!=w){m.permissionsEdited=true}}}function p(){k.validator.resetValidationErrors();q.clearHighlight();a.hide();window.scrollTo(m.bookmark.scrollX,m.bookmark.scrollY)}function f(){var v=d(".permissions-update-button").disable();if(n){h();AJS.setVisible("#page-permissions-unsaved-changes-msg",m.permissionsEdited);v.enable();p()}else{var u=m.makePermissionStrings();u.pageId=AJS.params.pageId;d("#waitImage").show();AJS.safe.post(j+"/pages/setpagepermissions.action",u,function(w){d("#waitImage").hide();AJS.setVisible("#content-metadata-page-restrictions",w.hasPermissions);v.enable();p()},"json")}}function c(){p();if(n){q.restoreBackup()}return false}function o(){a=AJS.ConfluenceDialog({width:865,height:530,id:"update-page-restrictions-dialog",onCancel:c});a.addHeader("Page Restrictions");a.addPanel("Page Permissions Editor",AJS.renderTemplate("page-permissions-div"));a.addButton("Save",f,"permissions-update-button");a.addCancel("Close",c);a.popup.element.find(".dialog-title").append(Confluence.Templates.PagePermissions.helpLink());k=AJS.PagePermissions.Controls(m);var u=d("#page-permissions-table").bind("changed",r);q=AJS.PagePermissions.Table(u);m.table=q}function i(u){m.bookmark={scrollX:document.documentElement.scrollLeft,scrollY:document.documentElement.scrollTop};b();k.setVisible(u.userCanEditRestrictions);AJS.setVisible(".permissions-update-button",u.userCanEditRestrictions);a.show();m.refreshLayout()}function t(z,w){var x=(w&&d("#newSpaceKey").val())||AJS.Meta.get("space-key");var u=(w&&d("#parentPageString").val())||"";var y={pageId:AJS.Meta.get("page-id"),parentPageId:AJS.Meta.get("parent-page-id"),parentPageTitle:u,spaceKey:x};var v;if(AJS.params.newPage){y.draftId=AJS.Meta.get("content-id")}d("#waitImage").show();if(n){v=j+"/pages/geteditpagepermissions.action";d.extend(y,{viewPermissionsUsers:d("#viewPermissionsUsers").val(),editPermissionsUsers:d("#editPermissionsUsers").val(),viewPermissionsGroups:d("#viewPermissionsGroups").val(),editPermissionsGroups:d("#editPermissionsGroups").val()})}else{v=j+"/pages/getpagepermissions.action"}d.getJSON(v,y,function(A){d("#waitImage").hide();e(A);z(A)})}function l(u){a||o();t(i,u)}function r(){d(".permissions-update-button").enable();d(".button-panel-cancel-link").text("Cancel")}function b(){d(".permissions-update-button").disable();d(".button-panel-cancel-link").text("Close")}d("#content-metadata-page-restrictions, #action-page-permissions-link").click(function(u){l(false);u.preventDefault()});d("#rte-button-restrictions").click(function(u){l(true);u.preventDefault()});if(n){m.originalPermissions={viewPermissionsUsers:d("#viewPermissionsUsers").val(),editPermissionsUsers:d("#editPermissionsUsers").val(),viewPermissionsGroups:d("#viewPermissionsGroups").val(),editPermissionsGroups:d("#editPermissionsGroups").val()}}});
AJS.PagePermissions.Table=function(b){var d=AJS.$,c=this;var a=false;this.refresh=function(){var h=b.find(".view-permission-row");var g=b.find(".edit-permission-row");var i=h.length>0;var f=g.length>0;AJS.setVisible("#page-permissions-no-views",!i);AJS.setVisible("#page-permissions-no-edits",!f);b.each(function(){d(".view-permission-row .page-permissions-marker-cell span",this).removeClass("first-of-type").filter(":first").addClass("first-of-type");d(".edit-permission-row .page-permissions-marker-cell span",this).removeClass("first-of-type").filter(":first").addClass("first-of-type")});c.clearHighlight()};this.saveBackup=function(){this.copy=b.children().clone(true)};this.restoreBackup=function(){b.children().remove();b.append(this.copy)};this.addCount=0;this.makePermissionMap=function(g){var f={user:{view:[],edit:[]},group:{view:[],edit:[]}};b.find("tr.view-permission-row, tr.edit-permission-row").each(function(){var l=d(this);var i=l.is(".user-permission")?"user":"group";var k=l.is(".view-permission-row")?"view":"edit";var j=(g&&(i=="user"))?"display-name":"name";var h=l.find(".permission-entity-"+j).text();f[i][k].push(h)});return f};this.makePermissionMapForCheckboxes=function(g){var f={user:{view:[],edit:[]},group:{view:[],edit:[]}};b.find("tr.view-permission-row").each(function(){var m=d(this);var i=!!m.find(".view-permission-cell input").attr("checked");var l=!!m.find(".edit-permission-cell input").attr("checked");if(i||l){var j=m.hasClass("user-permission")?"user":"group";var k=(g&&(j=="user"))?"display-name":"name";var h=m.find(".permission-entity-"+k).text();if(i&&(g||!m.hasClass("readonly-permission"))){f[j].view.push(h)}if(l){f[j].edit.push(h)}}});return f};var e=function(i,f){var h=i.find("td.permission-entity");var g=Confluence.getContextPath()+(f.profilePictureDownloadPath||"/images/icons/"+f.type+"_16.gif");h.find("img").attr("src",g);h.find(".permission-entity-name").text(f.name);if(f.type=="group"){h.find(".permission-entity-name-wrap").hide()}h.find(".permission-entity-display-name").text(f.fullName||f.name);var j=h.find("span.entity-container");if(f.type=="user"){j.addClass("content-hover user-hover-trigger").attr("data-username",f.name)}};this.addRow=function(q,l){var i=q.entity;var h=d(Confluence.Templates.PagePermissions.permissionRow());h.addClass(i.type+"-permission");h.addClass(l+"-permission-row");if(l=="edit"){h.find(".page-permissions-marker-cell span").text("Editing restricted to:")}e(h,i);var j=!a||q.inherited||q.readOnly;if(j){h.addClass("readonly-permission")}var m=h.find(".remove-permission-link");if(j||!a){m.remove()}else{m.attr("id","remove-permission-"+this.addCount++);m.click(function(s){d(this).closest("tr").remove();c.changedByUser();return AJS.stopEvent(s)})}if(q.inherited){var n=d(".page-permissions-table[owningTitle='"+AJS.escape(q.owningTitle)+"']");if(!n.length){var g=d(Confluence.Templates.PagePermissions.inheritedPermissionsTable());n=g.find("table");n.attr("owningTitle",AJS.escape(q.owningTitle));var k=g.find(".page-inherited-permissions-table-desc");var o=k.find("a"),f=Confluence.getContextPath()+"/pages/viewpage.action?pageId="+q.owningId;o.attr("href",f).attr("target","_blank").text(q.owningTitle).addClass("page-perms-owningTitle");var r=d("#content-title");var p=r.length?r.val():AJS.Meta.get("page-title");k.find("span").addClass(".page-perms-inherited-this-page").text(p);d("#page-inherited-permissions-tables").append(g)}n.append(h);d("#page-inherited-permissions-table-div").removeClass("hidden")}else{if(l=="view"){d("#page-permissions-no-edits").before(h)}else{b.append(h)}}};this.changedByUser=function(){b.trigger("changed");c.clearHighlight();c.refresh()};this.resetDirect=function(){b.find("tr:not(.marker-row)").remove();c.addCount=0};this.resetInherited=function(){d("#page-inherited-permissions-tables div").remove()};b.click(function(f){c.clearHighlight()});d("#page-inherited-permissions-table-desc").click(function(){d(".page-inheritance-togglable").toggleClass("hidden");d(".icon",this).toggleClass("twisty-open").toggleClass("twisty-closed")});this.highlightEntityRow=function(f,h){var g=b.find("."+h+"-permission-row").filter(function(){return d(".permission-entity-name",this).text()==f.name});d("#page-permissions-tables").simpleScrollTo(g);g.addClass("highlighted-permission")};this.clearHighlight=function(){d("tr.highlighted-permission").removeClass("highlighted-permission")};this.allowEditing=function(f){a=f};return this};
AJS.PagePermissions.Controls=function(b){var d=AJS.$;var c={handleNonExistentEntityNames:function(g){if(!g||!g.length){return}var f=g.join(", ");var h="Unknown user or group:"+" "+f;d("#page-permissions-error-div").find("div").text(h).end().removeClass("hidden");b.refreshLayout()},isDuplicateEntityForType:function(f,h){var g=d("#page-permissions-table ."+h+"-permission-row .permission-entity-name").filter(function(){return d(this).text()==f.name});return g.length>0},resetValidationErrors:function(){d("#page-permissions-error-div").addClass("hidden");b.refreshLayout()}};var a=(function(){var f=d("#page-permissions-names-input");var h=d("#page-permissions-names-hidden");var g=f.val();f.keypress(function(i){if(i.keyCode==Event.KEY_RETURN){e();f.focus();return false}return true});f.bind("selected.autocomplete-user",function(j,i){var k=i.content.username;h.val(unescape(k.replace(/\+/g," ")));f.val("");e();j.preventDefault()});f.focus(function(){var k=f.next(".aui-dd-parent");if(!k.length){return}k.show();var i=f.offset().left;if(k.offset().left!=i){k.css("margin-left",0);var m=i-k.offset().left;k.css("margin-left",m+"px")}var l=f.offset().top+f.outerHeight();if(k.offset().top!=l){k.css("margin-top",0);var j=l-k.offset().top;k.css("margin-top",j+"px")}k.css({width:f.outerWidth()});k.hide()});return{getValue:function(){var i=h.val();if(i){h.val("")}else{i=f.val();if(i==g){i=""}}return i},removeFromNameInput:function(m){if(!m){return}var l=f.val();if(!l){return}var j=l.split(",");for(var k=0;k<j.length;k++){j[k]=d.trim(j[k])}j=d.grep(j,function(i){return i!=""&&i!=m});if(j.length){f.val(j.join(", "))}else{if(document.activeElement==f[0]){f.val("")}}}}})();var e=function(){c.resetValidationErrors();b.table.clearHighlight();var f=a.getValue();if(!f){return}b.addNames(f)};d("#page-permissions-choose-me").click(function(f){c.resetValidationErrors();b.addNames(d(this).find(".remote-user-name").text());return AJS.stopEvent(f)});d("#permissions-error-div-close").click(function(f){c.resetValidationErrors();return AJS.stopEvent(f)});d("#add-typed-names").click(e);return{validator:c,nameField:a,setVisible:function(f){AJS.setVisible("#page-permissions-editor-form",f);AJS.setVisible(".remove-permission-link",f)},isShowing:function(){return !d("#page-permissions-editor-form").hasClass("hidden")},getPermissionType:function(){return !!d("#restrictViewRadio:checked").length?"view":"edit"}}};
// This file was automatically generated from page-permissions.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.PagePermissions == 'undefined') { Confluence.Templates.PagePermissions = {}; }


Confluence.Templates.PagePermissions.helpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.Dialog.helpLink({href: "http://docs.atlassian.com/confluence/docs-41/Page+Restrictions"}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.PagePermissions.inheritedPermissionsTable = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="page-inherited-permissions-owner-div"><div class="page-inherited-permissions-table-desc">', "Viewing restrictions apply to \u201c\x3ca\x3e\x3c/a\x3e\u201d. In order to see \u201c\x3cspan\x3e\x3c/span\x3e\u201d, a user must be in the following list of users and groups:", '</div><table class="page-permissions-table"></table></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.PagePermissions.permissionRow = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<tr class="permission-row"><td class="page-permissions-marker-cell" width="20%"><span>', soy.$$escapeHtml("Viewing restricted to:"), '</span></td><td class="permission-entity" nowrap="true" width="40%"><span class="entity-container"><img class="permission-entity-picture"/><span class="permission-entity-display-name"></span><span class="permission-entity-name-wrap">&nbsp;(<span class="permission-entity-name"></span>)</span></span></td><td class="permission-detail-column"><div class="permission-remove-div"><a href="#" class="remove-permission-link">', soy.$$escapeHtml("Remove restriction"), '</a></div></td></tr>');
  if (!opt_sb) return output.toString();
};

AJS.toInit(function(c){if(!c("link[rel=canonical]").length){return}var b=null;var a=function(){b=new AJS.Dialog(600,210,"link-page-popup").addHeader("Link to this Page").addPanel("Link to this Page","<form id='link-page-popup-form' class='aui'><fieldset></fieldset></form>").addCancel("Close",function(f){b.hide();return false});if(Confluence.KeyboardShortcuts&&Confluence.KeyboardShortcuts.enabled){b.addHelpText(AJS.format("Shortcut tip: Pressing \u003cb>{0}\u003c\/b> also opens this dialog box","k"))}var d=[{label:"Link",id:"link",value:c("link[rel=canonical]").attr("href")},{label:"Tiny Link",id:"tiny-link",value:c("link[rel=shortlink]").attr("href")}];c.each(d,function(){c("#link-page-popup-form fieldset").append(AJS.format("<div class='field-group'><label for=''link-popup-field-{0}''>{1}:</label><input id=''link-popup-field-{0}'' readonly=''readonly'' value='''' class=''text'' type=''text''></div>",this.id,this.label)).find("input:last").val(this.value)});var e=c("#link-page-popup-form fieldset input.text");e.focus(function(){c(this).select()});e.mouseup(function(f){f.preventDefault()})};c("#link-to-page-link").click(function(d){if(!b){a()}c(this).parents(".ajs-drop-down")[0].hide();b.show();c("#link-page-popup-form #link-popup-field-tiny-link").select();return AJS.stopEvent(d)})});
AJS.toInit(function(B){var A=AJS.Data.get("context-path");
var C=B("#edit-in-word, #edit-in-word-pathauth, a.office-editable, a.office-editable-pathauth");
C.click(function(G){G.preventDefault();
var F=B(this);
var E=F.attr("data-use-path-auth");
if(typeof (E)=="undefined"){E=(F.attr("id")=="edit-in-word-pathauth"||F.hasClass("office-editable-pathauth"))
}else{E=(E==="true")
}var H=F.attr("href");
var D=F.attr("data-prog-id");
if(typeof (D)=="undefined"){D=getProgID(H)
}return doEditInOffice(A,H,D,E)
})
});
function getProgID(A){var B=A.substring(A.lastIndexOf(".")+1);
switch(B){case"ppt":case"pptx":case"ppsx":case"pot":case"potx":case"pptm":return"PowerPoint.Show";
case"doc":case"docx":case"dot":case"dotx":return"Word.Document";
case"xls":case"xlt":case"xlsx":case"xlst":case"xlsm":return"Excel.Sheet";
default:return""
}}function filterPath(B,C,A){AJS.$.ajax({url:contextPath+"/rest/office/1.0/authtoken",success:function(G){if(G.token){var D=B.split("/");
var F="";
for(var E=0;
E<D.length-1;
E++){if(D[E].length){F=F+"/"+D[E]
}}F=F+"/ocauth/"+G.token+"/"+D[D.length-1];
C(F)
}else{A("Unable to retrieve a temporary auth token. Check your server logs.")
}},error:function(D,F,E){A("Ajax error retrieving token: "+F+", error from server: "+E)
},statusCode:{403:function(){A("The current configuration requires you to be logged in to use the Office Connector.")
}}})
}function getCookie(B){var F=document.cookie.split(";");
var C="";
var D="";
var E="";
for(var A=0;
A<F.length;
A++){C=F[A].split("=");
D=C[0].replace(/^\s+|\s+$/g,"");
if(D==B){if(C.length>1){E=unescape(C[1].replace(/^\s+|\s+$/g,""))
}return E
}C=null;
D=""
}return null
}function getBaseUrl(){return location.protocol+"//"+location.host
}function handleTokenError(A){alert(A)
}function doEditInOffice(A,B,D,H){var G=getBaseUrl();
if(window.ActiveXObject){var E;
try{E=new ActiveXObject("SharePoint.OpenDocuments.1")
}catch(C){window.alert("Unable to create an ActiveX object to open the document. This is most likely because of the security settings for your browser.");
return false
}if(E){if(H){filterPath(B,function(J){E.EditDocument(G+J,D)
},handleTokenError)
}else{E.EditDocument(G+B,D)
}return false
}else{window.alert("Cannot instantiate the required ActiveX control to open the document. This is most likely because you do not have Office installed or you have an older version of Office.");
return false
}}else{if(window.URLLauncher){var F=navigator.appVersion.indexOf("Mac")!=-1;
var I=function(L){var J=new URLLauncher();
if(J.open2){var N=new RegExp(A+"/plugins/servlet/[^/]+/");
var M=L.match(N);
var K=L.substring(M[0].length);
J.open2(encodeURI(M[0]),encodeURI(K))
}else{J.open(L)
}};
if(H&&!F){B=filterPath(B,I,handleTokenError)
}else{I(B)
}}else{if(window.InstallTrigger){if(window.confirm("A plugin is required to use this feature. Would you like to download it?")){InstallTrigger.install({"WebDAV Launcher":"https://update.atlassian.com/office-connector/URLLauncher/latest/webdavloader.xpi"})
}}else{window.alert("Firefox or Internet Explorer is required to use this feature.")
}}}return false
}function enableEdit(A){A.style.cursor="pointer";
A.style.backgroundColor="#cccccc";
A.style.color=""
}function disableEdit(A){A.style.cursor="";
A.style.backgroundColor="#ffffff";
A.style.color="#ffffff"
};
AJS.moreLinkClickHandler=function(B){var A=AJS.$(this),C=A.attr("href"),D=A.closest(".more-link-container");
if(!D.length){throw new Error("Could not find more link container when one was expected.")
}AJS.$(".waiting-image",D).removeClass("hidden");
AJS.$(".more-link-text",A).hide();
AJS.$.get(C,function(E){$context=AJS.$(E);
D.replaceWith($context);
AJS.$(".more-link",$context).click(AJS.moreLinkClickHandler);
if(AJS.PageGadget&&AJS.PageGadget.contentsUpdated){AJS.PageGadget.contentsUpdated()
}});
return AJS.stopEvent(B)
};
AJS.toInit(function(A){A(".more-link").click(AJS.moreLinkClickHandler)
});
AJS.toInit(function(A){A("select.content-filter").change(function(){A(".filter-control .waiting-image").removeClass("hidden");
var B=A(this);
A.get(AJS.params.changesUrl,{contentType:A(this).val()},function(E){var D=A(E);
var C=B.parent();
C.parent().siblings(".results-container").children("ul").html(D);
A(".waiting-image",C).addClass("hidden");
A(".more-link",D).click(AJS.moreLinkClickHandler)
})
})
});
AJS.toInit(function(e){var b=Confluence.storageManager("personal-sidebar"),d=e("#personal-info-sidebar"),a=d.height(),c=e("#content");function f(){d.toggleClass("collapsed");c.toggleClass("sidebar-collapsed");d.trigger("toggled")}if(b.getItemAsBoolean("show")){f()}e(".sidebar-collapse").click(function(g){f();b.setItem("show",d.hasClass("collapsed"));return AJS.stopEvent(g)}).height(a)});
(function(B){var L,T,Q,M,d,m,J,A,O,z,C=0,H={},j=[],e=0,G={},y=[],f=null,o=new Image(),i=/\.(jpg|gif|png|bmp|jpeg)(.*)?$/i,k=/[^\.]\.(swf)\s*$/i,p,N=1,h=0,t="",b,c,P=false,s=B.extend(B("<div/>")[0],{prop:0}),S=B.browser.msie&&B.browser.version<7&&!window.XMLHttpRequest,r=function(){T.hide();o.onerror=o.onload=null;if(f){f.abort()}L.empty()},x=function(){if(false===H.onError(j,C,H)){T.hide();P=false;return}H.titleShow=false;H.width="auto";H.height="auto";L.html('<p id="fancybox-error">The requested content cannot be loaded.<br />Please try again later.</p>');n()},w=function(){var Z=j[C],W,Y,ab,aa,V,X;r();H=B.extend({},B.fn.fancybox.defaults,(typeof B(Z).data("fancybox")=="undefined"?H:B(Z).data("fancybox")));X=H.onStart(j,C,H);if(X===false){P=false;return}else{if(typeof X=="object"){H=B.extend(H,X)}}ab=H.title||(Z.nodeName?B(Z).attr("title"):Z.title)||"";H.orig=B(Z).is("img")&&B(Z);if(Z.nodeName&&!H.orig){H.orig=B(Z).children("img:first").length?B(Z).children("img:first"):B(Z)}if(ab===""&&H.orig&&H.titleFromAlt){ab=H.orig.attr("alt")}W=H.href||(Z.nodeName?B(Z).attr("href"):Z.href)||null;if((/^(?:javascript)/i).test(W)||W=="#"){W=null}if(H.type){Y=H.type;if(!W){W=H.content}}else{if(H.content){Y="html"}else{if(H.dataAttr){Y="dataAttribute";W=H.orig.attr("data-"+H.dataAttr)}else{if(W){if(W.match(i)){Y="image"}else{if(W.match(k)){Y="swf"}else{if(B(Z).hasClass("iframe")){Y="iframe"}else{if(W.indexOf("#")===0){Y="inline"}else{Y="ajax"}}}}}}}}if(!Y){x();return}if(Y=="inline"){Z=W.substr(W.indexOf("#"));Y=B(Z).length>0?"inline":"ajax"}H.type=Y;H.href=W;H.title=ab;if(H.autoDimensions){if(H.type=="html"||H.type=="inline"||H.type=="ajax"){H.width="auto";H.height="auto"}else{H.autoDimensions=false}}if(H.modal){H.overlayShow=true;H.hideOnOverlayClick=false;H.hideOnContentClick=false;H.enableEscapeButton=false;H.showCloseButton=false}H.padding=parseInt(H.padding,10);H.margin=parseInt(H.margin,10);L.css("padding",(H.padding+H.margin));B(".fancybox-inline-tmp").unbind("fancybox-cancel").bind("fancybox-change",function(){B(this).replaceWith(m.children())});switch(Y){case"html":L.html(H.content);n();break;case"inline":if(B(Z).parent().is("#fancybox-content")===true){P=false;return}B('<div class="fancybox-inline-tmp" />').hide().insertBefore(B(Z)).bind("fancybox-cleanup",function(){B(this).replaceWith(m.children())}).bind("fancybox-cancel",function(){B(this).replaceWith(L.children())});B(Z).appendTo(L);n();break;case"image":case"dataAttribute":P=false;B.fancybox.showActivity();o=new Image();o.onerror=function(){x()};o.onload=function(){P=true;o.onerror=o.onload=null;F()};o.src=W;break;case"swf":H.scrolling="no";aa='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="'+H.width+'" height="'+H.height+'"><param name="movie" value="'+W+'"></param>';V="";B.each(H.swf,function(ac,ad){aa+='<param name="'+ac+'" value="'+ad+'"></param>';V+=" "+ac+'="'+ad+'"'});aa+='<embed src="'+W+'" type="application/x-shockwave-flash" width="'+H.width+'" height="'+H.height+'"'+V+"></embed></object>";L.html(aa);n();break;case"ajax":P=false;B.fancybox.showActivity();H.ajax.win=H.ajax.success;f=B.ajax(B.extend({},H.ajax,{url:W,data:H.ajax.data||{},error:function(ac,ae,ad){if(ac.status>0){x()}},success:function(ad,af,ac){var ae=typeof ac=="object"?ac:f;if(ae.status==200){if(typeof H.ajax.win=="function"){X=H.ajax.win(W,ad,af,ac);if(X===false){T.hide();return}else{if(typeof X=="string"||typeof X=="object"){ad=X}}}L.html(ad);n()}}}));break;case"iframe":E();break}},n=function(){var V=H.width,W=H.height;if(V.toString().indexOf("%")>-1){V=parseInt((B(window).width()-(H.margin*2))*parseFloat(V)/100,10)+"px"}else{V=V=="auto"?"auto":V+"px"}if(W.toString().indexOf("%")>-1){W=parseInt((B(window).height()-(H.margin*2))*parseFloat(W)/100,10)+"px"}else{W=W=="auto"?"auto":W+"px"}L.wrapInner('<div style="width:'+V+";height:"+W+";overflow: "+(H.scrolling=="auto"?"auto":(H.scrolling=="yes"?"scroll":"hidden"))+';position:relative;"></div>');H.width=L.width();H.height=L.height();E()},F=function(){H.width=o.width;H.height=o.height;B("<img />").attr({id:"fancybox-img",src:o.src,alt:H.title}).appendTo(L);E()},E=function(){var W,V;T.hide();if(M.is(":visible")&&false===G.onCleanup(y,e,G)){B.event.trigger("fancybox-cancel");P=false;return}P=true;B(m.add(Q)).unbind();B(window).unbind("resize.fb scroll.fb");B(document).unbind("keydown.fb");if(M.is(":visible")&&G.titlePosition!=="outside"){M.css("height",M.height())}y=j;e=C;G=H;if(G.overlayShow){Q.css({"background-color":G.overlayColor,opacity:G.overlayOpacity,cursor:G.hideOnOverlayClick?"pointer":"auto",height:B(document).height()});if(!Q.is(":visible")){if(S){B("select:not(#fancybox-tmp select)").filter(function(){return this.style.visibility!=="hidden"}).css({visibility:"hidden"}).one("fancybox-cleanup",function(){this.style.visibility="inherit"})}Q.show()}}else{Q.hide()}c=R();l();if(M.is(":visible")){B(J.add(O).add(z)).hide();W=M.position();b={top:W.top,left:W.left,width:M.width(),height:M.height()};V=(b.width==c.width&&b.height==c.height);m.fadeTo(G.changeFade,0.3,function(){var X=function(){m.html(L.contents()).fadeTo(G.changeFade,1,v)};B.event.trigger("fancybox-change");m.empty().removeAttr("filter").css({"border-width":G.padding,width:c.width-G.padding*2,height:H.autoDimensions?"auto":c.height-h-G.padding*2});if(V){X()}else{s.prop=0;B(s).animate({prop:1},{duration:G.changeSpeed,easing:G.easingChange,step:U,complete:X})}});return}M.removeAttr("style");m.css("border-width",G.padding);if(G.transitionIn=="elastic"){b=I();m.html(L.contents());M.show();if(G.opacity){c.opacity=0}s.prop=0;B(s).animate({prop:1},{duration:G.speedIn,easing:G.easingIn,step:U,complete:v});return}if(G.titlePosition=="inside"&&h>0){A.show()}m.css({width:c.width-G.padding*2,height:H.autoDimensions?"auto":c.height-h-G.padding*2}).html(L.contents());M.css(c).fadeIn(G.transitionIn=="none"?0:G.speedIn,v)},D=function(V){if(V&&V.length){if(G.titlePosition=="float"){return'<table id="fancybox-title-float-wrap" cellpadding="0" cellspacing="0"><tr><td id="fancybox-title-float-left"></td><td id="fancybox-title-float-main">'+V+'</td><td id="fancybox-title-float-right"></td></tr></table>'}return'<div id="fancybox-title-'+G.titlePosition+'">'+V+"</div>"}return false},l=function(){t=G.title||"";h=0;A.empty().removeAttr("style").removeClass();if(G.titleShow===false){A.hide();return}t=B.isFunction(G.titleFormat)?G.titleFormat(t,y,e,G):D(t);if(!t||t===""){A.hide();return}A.addClass("fancybox-title-"+G.titlePosition).html(t).appendTo("body").show();switch(G.titlePosition){case"inside":A.css({width:c.width-(G.padding*2),marginLeft:G.padding,marginRight:G.padding});h=A.outerHeight(true);A.appendTo(d);c.height+=h;break;case"over":A.css({marginLeft:G.padding,width:c.width-(G.padding*2),bottom:G.padding}).appendTo(d);break;case"float":A.css("left",parseInt((A.width()-c.width-40)/2,10)*-1).appendTo(M);break;default:A.css({width:c.width-(G.padding*2),paddingLeft:G.padding,paddingRight:G.padding}).appendTo(M);break}A.hide()},g=function(){if(G.enableEscapeButton||G.enableKeyboardNav){B(document).bind("keydown.fb",function(V){if(V.keyCode==27&&G.enableEscapeButton){V.preventDefault();B.fancybox.close()}else{if((V.keyCode==37||V.keyCode==39)&&G.enableKeyboardNav&&V.target.tagName!=="INPUT"&&V.target.tagName!=="TEXTAREA"&&V.target.tagName!=="SELECT"){V.preventDefault();B.fancybox[V.keyCode==37?"prev":"next"]()}}})}if(!G.showNavArrows){O.hide();z.hide();return}if((G.cyclic&&y.length>1)||e!==0){O.show()}if((G.cyclic&&y.length>1)||e!=(y.length-1)){z.show()}},v=function(){if(!B.support.opacity){m.get(0).style.removeAttribute("filter");M.get(0).style.removeAttribute("filter")}if(H.autoDimensions){m.css("height","auto")}M.css("height","auto");if(t&&t.length){A.show()}if(G.showCloseButton){J.show()}g();if(G.hideOnContentClick){m.bind("click",B.fancybox.close)}if(G.hideOnOverlayClick){Q.bind("click",B.fancybox.close)}B(window).bind("resize.fb",B.fancybox.resize);if(G.centerOnScroll){B(window).bind("scroll.fb",B.fancybox.center)}if(G.type=="iframe"){B('<iframe id="fancybox-frame" name="fancybox-frame'+new Date().getTime()+'" frameborder="0" hspace="0" '+(B.browser.msie?'allowtransparency="true""':"")+' scrolling="'+H.scrolling+'" src="'+G.href+'"></iframe>').appendTo(m)}M.show();P=false;B.fancybox.center();G.onComplete(y,e,G);K()},K=function(){var V,W;if((y.length-1)>e){V=y[e+1].href;if(typeof V!=="undefined"&&V.match(i)){W=new Image();W.src=V}}if(e>0){V=y[e-1].href;if(typeof V!=="undefined"&&V.match(i)){W=new Image();W.src=V}}},U=function(W){var V={width:parseInt(b.width+(c.width-b.width)*W,10),height:parseInt(b.height+(c.height-b.height)*W,10),top:parseInt(b.top+(c.top-b.top)*W,10),left:parseInt(b.left+(c.left-b.left)*W,10)};if(typeof c.opacity!=="undefined"){V.opacity=W<0.5?0.5:W}M.css(V);m.css({width:V.width-G.padding*2,height:V.height-(h*W)-G.padding*2})},u=function(){return[B(window).width()-(G.margin*2),B(window).height()-(G.margin*2),B(document).scrollLeft()+G.margin,B(document).scrollTop()+G.margin]},R=function(){var V=u(),Z={},W=G.autoScale,X=G.padding*2,Y;if(G.width.toString().indexOf("%")>-1){Z.width=parseInt((V[0]*parseFloat(G.width))/100,10)}else{Z.width=G.width+X}if(G.height.toString().indexOf("%")>-1){Z.height=parseInt((V[1]*parseFloat(G.height))/100,10)}else{Z.height=G.height+X}if(W&&(Z.width>V[0]||Z.height>V[1])){if(H.type=="image"||H.type=="dataAttribute"||H.type=="swf"){Y=(G.width)/(G.height);if((Z.width)>V[0]){Z.width=V[0];Z.height=parseInt(((Z.width-X)/Y)+X,10)}if((Z.height)>V[1]){Z.height=V[1];Z.width=parseInt(((Z.height-X)*Y)+X,10)}}else{Z.width=Math.min(Z.width,V[0]);Z.height=Math.min(Z.height,V[1])}}Z.top=parseInt(Math.max(V[3]-20,V[3]+((V[1]-Z.height-40)*0.5)),10);Z.left=parseInt(Math.max(V[2]-20,V[2]+((V[0]-Z.width-40)*0.5)),10);return Z},q=function(V){var W=V.offset();W.top+=parseInt(V.css("paddingTop"),10)||0;W.left+=parseInt(V.css("paddingLeft"),10)||0;W.top+=parseInt(V.css("border-top-width"),10)||0;W.left+=parseInt(V.css("border-left-width"),10)||0;W.width=V.width();W.height=V.height();return W},I=function(){var Y=H.orig?B(H.orig):false,X={},W,V;if(Y&&Y.length){W=q(Y);X={width:W.width+(G.padding*2),height:W.height+(G.padding*2),top:W.top-G.padding-20,left:W.left-G.padding-20}}else{V=u();X={width:G.padding*2,height:G.padding*2,top:parseInt(V[3]+V[1]*0.5,10),left:parseInt(V[2]+V[0]*0.5,10)}}return X},a=function(){if(!T.is(":visible")){clearInterval(p);return}B("div",T).css("top",(N*-40)+"px");N=(N+1)%12};B.fn.fancybox=function(V){if(!B(this).length){return this}B(this).data("fancybox",B.extend({},V,(B.metadata?B(this).metadata():{}))).unbind("click.fb").bind("click.fb",function(X){X.preventDefault();if(P){return}P=true;B(this).blur();j=[];C=0;var W=B(this).attr("rel")||"";if(!W||W==""||W==="nofollow"){j.push(this)}else{j=B("a[rel="+W+"], area[rel="+W+"]");C=j.index(this)}w();return});return this};B.fancybox=function(Y){var X;if(P){return}P=true;X=typeof arguments[1]!=="undefined"?arguments[1]:{};j=[];C=parseInt(X.index,10)||0;if(B.isArray(Y)){for(var W=0,V=Y.length;W<V;W++){if(typeof Y[W]=="object"){B(Y[W]).data("fancybox",B.extend({},X,Y[W]))}else{Y[W]=B({}).data("fancybox",B.extend({content:Y[W]},X))}}j=jQuery.merge(j,Y)}else{if(typeof Y=="object"){B(Y).data("fancybox",B.extend({},X,Y))}else{Y=B({}).data("fancybox",B.extend({content:Y},X))}j.push(Y)}if(C>j.length||C<0){C=0}w()};B.fancybox.showActivity=function(){clearInterval(p);T.show();p=setInterval(a,66)};B.fancybox.hideActivity=function(){T.hide()};B.fancybox.next=function(){return B.fancybox.pos(e+1)};B.fancybox.prev=function(){return B.fancybox.pos(e-1)};B.fancybox.pos=function(V){if(P){return}V=parseInt(V,10);j=y;if(V>-1&&V<y.length){C=V;w()}else{if(G.cyclic&&y.length>1){C=V>=y.length?0:y.length-1;w()}}return};B.fancybox.cancel=function(){if(P){return}P=true;B.event.trigger("fancybox-cancel");r();H.onCancel(j,C,H);P=false};B.fancybox.close=function(){if(P||M.is(":hidden")){return}P=true;if(G&&false===G.onCleanup(y,e,G)){P=false;return}r();B(J.add(O).add(z)).hide();B(m.add(Q)).unbind();B(window).unbind("resize.fb scroll.fb");B(document).unbind("keydown.fb");m.find("iframe").attr("src",S&&/^https/i.test(window.location.href||"")?"javascript:void(false)":"about:blank");if(G.titlePosition!=="inside"){A.empty()}M.stop();function V(){Q.fadeOut("fast");A.empty().hide();M.hide();B.event.trigger("fancybox-cleanup");m.empty();G.onClosed(y,e,G);y=H=[];e=C=0;G=H={};P=false}if(G.transitionOut=="elastic"){b=I();var W=M.position();c={top:W.top,left:W.left,width:M.width(),height:M.height()};if(G.opacity){c.opacity=1}A.empty().hide();s.prop=1;B(s).animate({prop:0},{duration:G.speedOut,easing:G.easingOut,step:U,complete:V})}else{M.fadeOut(G.transitionOut=="none"?0:G.speedOut,V)}};B.fancybox.resize=function(){if(Q.is(":visible")){Q.css("height",B(document).height())}B.fancybox.center(true)};B.fancybox.center=function(){var V,W;if(P){return}W=arguments[0]===true?1:0;V=u();if(!W&&(M.width()>V[0]||M.height()>V[1])){return}M.stop().animate({top:parseInt(Math.max(V[3]-20,V[3]+((V[1]-m.height()-40)*0.5)-G.padding),10),left:parseInt(Math.max(V[2]-20,V[2]+((V[0]-m.width()-40)*0.5)-G.padding),10)},typeof arguments[0]=="number"?arguments[0]:200)};B.fancybox.init=function(){if(B("#fancybox-wrap").length){return}B("body").append(L=B('<div id="fancybox-tmp"></div>'),T=B('<div id="fancybox-loading"><div></div></div>'),Q=B('<div id="fancybox-overlay"></div>'),M=B('<div id="fancybox-wrap"></div>'));d=B('<div id="fancybox-outer"></div>').append('<div class="fancybox-bg" id="fancybox-bg-n"></div><div class="fancybox-bg" id="fancybox-bg-ne"></div><div class="fancybox-bg" id="fancybox-bg-e"></div><div class="fancybox-bg" id="fancybox-bg-se"></div><div class="fancybox-bg" id="fancybox-bg-s"></div><div class="fancybox-bg" id="fancybox-bg-sw"></div><div class="fancybox-bg" id="fancybox-bg-w"></div><div class="fancybox-bg" id="fancybox-bg-nw"></div>').appendTo(M);d.append(m=B('<div id="fancybox-content"></div>'),J=B('<a id="fancybox-close"></a>'),A=B('<div id="fancybox-title"></div>'),O=B('<a href="javascript:;" id="fancybox-left"><span class="fancy-ico" id="fancybox-left-ico"></span></a>'),z=B('<a href="javascript:;" id="fancybox-right"><span class="fancy-ico" id="fancybox-right-ico"></span></a>'));J.click(B.fancybox.close);T.click(B.fancybox.cancel);O.click(function(V){V.preventDefault();B.fancybox.prev()});z.click(function(V){V.preventDefault();B.fancybox.next()});if(B.fn.mousewheel){M.bind("mousewheel.fb",function(V,W){if(P){V.preventDefault()}else{if(B(V.target).get(0).clientHeight==0||B(V.target).get(0).scrollHeight===B(V.target).get(0).clientHeight){V.preventDefault();B.fancybox[W>0?"prev":"next"]()}}})}if(!B.support.opacity){M.addClass("fancybox-ie")}if(S){T.addClass("fancybox-ie6");M.addClass("fancybox-ie6");B('<iframe id="fancybox-hide-sel-frame" src="'+(/^https/i.test(window.location.href||"")?"javascript:void(false)":"about:blank")+'" scrolling="no" border="0" frameborder="0" tabindex="-1"></iframe>').prependTo(d)}};B.fn.fancybox.defaults={padding:10,margin:40,opacity:false,modal:false,cyclic:false,scrolling:"auto",width:560,height:340,autoScale:true,autoDimensions:true,centerOnScroll:false,ajax:{},swf:{wmode:"transparent"},hideOnOverlayClick:true,hideOnContentClick:false,overlayShow:true,overlayOpacity:0.7,overlayColor:"#777",titleShow:true,titlePosition:"float",titleFormat:null,titleFromAlt:false,transitionIn:"fade",transitionOut:"fade",speedIn:300,speedOut:300,changeSpeed:300,changeFade:"fast",easingIn:"swing",easingOut:"swing",showCloseButton:true,showNavArrows:true,enableEscapeButton:true,enableKeyboardNav:true,onStart:function(){},onCancel:function(){},onComplete:function(){},onCleanup:function(){},onClosed:function(){},onError:function(){}};B(document).ready(function(){B.fancybox.init()})})(jQuery);
AJS.toInit(function(b){var a={padding:0,speedIn:500,speedOut:500,overlayShow:true,overlayOpacity:0.5,dataAttr:"image-src"};b("img.confluence-embedded-image").each(function(){var c=b(this);if(!c.parent("a").length){c.fancybox(a)}})});
AJS.toInit(function(b){var d=b("#version-comment");if(d.length){var a=b("#show-version-comment");var c=b("#hide-version-comment");a.click(function(f){a.hide();c.show();d.show();return AJS.stopEvent(f)});c.click(function(f){c.hide();a.show();d.hide();return AJS.stopEvent(f)});if(a.length&&c.length){d.hide()}}});
AJS.toInit(function(c){if(!Confluence.Templates.Labels){return}var b=null;var d=function(){c("#"+b.id).find(".label-list").removeClass("editable");b.hide();return false};var a=function(){b=AJS.ConfluenceDialog({width:550,height:233,id:"edit-labels-dialog",onCancel:d});b.addHeader("Labels");b.addPanel("Label Editor",AJS.renderTemplate("labels-dialog-div"));b.addCancel("Close",d);b.addHelpText("Shortcut tip: In page view, pressing \u003cb>{shortcut}\u003c\/b> also opens this dialog box",{shortcut:"l"});b.popup.element.find(".dialog-title").append(Confluence.Templates.Labels.helpLink());c("#add-labels-form").submit(function(g){var f=c("#labelsString");g.preventDefault();AJS.Labels.addLabel(f.val());f.focus()});c("#labelsString").keydown(function(f){if(f.keyCode==13){if(!AJS.dropDown.current){c("#add-labels-form").submit(f)}}});AJS.Labels.bindAutocomplete()};c("#rte-button-labels").click(function(f){AJS.Labels.openDialog()});c(".show-labels-editor").click(function(f){f.preventDefault();AJS.Labels.openDialog()});AJS.Labels.openDialog=function(){if(!b){a()}b.show();c("#"+b.id).find(".label-list").addClass("editable");c("#labelsString").val("").focus()}});
// This file was automatically generated from labels-dialog.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.Labels == 'undefined') { Confluence.Templates.Labels = {}; }


Confluence.Templates.Labels.helpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.Dialog.helpLink({href: "http://docs.atlassian.com/confluence/docs-41/Adding+a+Global+Label"}, output);
  if (!opt_sb) return output.toString();
};

jQuery(function(a){a("#manage-watchers-menu-item").click(function(h){h.preventDefault();var c="manage-watchers-dialog";var i=new AJS.ConfluenceDialog({width:865,height:530,id:c,onCancel:function(){i.hide().remove()}});i.addHeader("Manage Watchers");i.addPanel("default",Confluence.Templates.ManageWatchers.dialogContent({pageId:AJS.Meta.get("page-id"),xsrfToken:AJS.Meta.get("atl-token")}));i.addCancel("Close",function(){i.hide().remove();return false});i.show();var d=a("#"+c);d.find(".dialog-title").append(Confluence.Templates.ManageWatchers.helpLink());if(Confluence.KeyboardShortcuts&&Confluence.KeyboardShortcuts.enabled){i.addHelpText(AJS.format("Shortcut tip: Pressing \u003cb>{0}\u003c\/b> also opens this dialog box","w"))}d.find("input:visible, button:visible").each(function(e){a(this).attr("tabindex",e+1)});AJS.applySearchPlaceholders(d);d.bind("remove-list-item.manage-watchers",function(p,o){var m=o.item,n=o.list,q=o.username;m.addClass("removing");AJS.safe.ajax({dataType:"json",type:"POST",url:AJS.params.contextPath+"/json/removewatch.action",data:{pageId:AJS.params.pageId,username:q},error:function(){alert("Failed to remove watcher. Refresh page to see latest status.");m.removeClass("removing")},success:function(){m.slideUp().remove();d.trigger("list-updated.manage-watchers",{list:n})}})});d.bind("list-updated.manage-watchers",function(p,o){var n=o.list;var m=a("li.watch-user",n).length>0;if(!m){n.find(".no-users").removeClass("hidden");return}n.find(".no-users").addClass("hidden");Confluence.Binder.userHover();n.find(".confluence-userlink").each(function(){a(this).click(function(q){q.preventDefault()})})});d.bind("list-data-retrieved.manage-watchers",function(p,o){var n=o.list,m=o.watchers;n.find(".watch-user").remove();if(m&&m.length){a.each(m,function(){var r=this.name;var q={username:r,fullName:this.fullName,url:AJS.params.contextPath+"/display/~"+this.name,iconUrl:AJS.params.contextPath+this.profilePictureDownloadPath};var e=a(Confluence.Templates.ManageWatchers.userItem(q));n.append(e);e.find(".remove-watch").click(function(){d.trigger("remove-list-item.manage-watchers",{username:r,item:e,list:n})})})}n.find(".loading").hide();d.trigger("list-updated.manage-watchers",{list:n})});var f=d.find(".page-watchers .user-list");var k=d.find(".space-watchers .user-list");AJS.safe.ajax({url:AJS.params.contextPath+"/json/listwatchers.action",dataType:"json",data:{pageId:AJS.params.pageId},error:function(){alert("Failed to retrieve watchers.")},success:function(e){d.trigger("list-data-retrieved.manage-watchers",{list:f,watchers:e.pageWatchers});d.trigger("list-data-retrieved.manage-watchers",{list:k,watchers:e.spaceWatchers})}});var l=d.find("form");var j=l.find("#add-watcher-user");var b=l.find("#add-watcher-username");var g=(function(){var e=l.find("> .status");return{clear:function(){e.addClass("hidden").removeClass("loading error").text("")},loading:function(m){e.addClass("loading").removeClass("hidden error").html(m)},error:function(m){e.addClass("error").removeClass("hidden loading").text(m)}}})();l.ajaxForm({beforeSerialize:function(){if(b.val()==""){b.val(j.val())}},beforeSubmit:function(){j.blur().attr("disabled","disabled");f.addClass("updating");g.loading("Adding watcher&hellip;")},dataType:"json",error:function(m,e){alert("Failed to add watcher: "+e)},success:function(e){b.val("");j.attr("disabled","").val("").focus();f.removeClass("updating");if(e.actionErrors&&e.actionErrors.length){g.error(e.actionErrors[0]);return}d.trigger("list-data-retrieved.manage-watchers",{list:f,watchers:e.pageWatchers});g.clear()}});Confluence.Binder.autocompleteUser();j.bind("selected.autocomplete-user",function(n,m){l.submit()});j.focus()})});
// This file was automatically generated from manage-watchers.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.ManageWatchers == 'undefined') { Confluence.Templates.ManageWatchers = {}; }


Confluence.Templates.ManageWatchers.dialogContent = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="dialog-content"><div class="column page-watchers"><h3>', soy.$$escapeHtml("Watching this page"), '</h3><p class="description">', soy.$$escapeHtml("These people are notified when the page is changed. You can add or remove people from this list."), '</p><form action="', soy.$$escapeHtml("/wiki"), '/json/addwatch.action" method="POST"><input type="hidden" name="atl_token" value="', soy.$$escapeHtml(opt_data.xsrfToken), '"><input type="hidden" name="pageId" value="', soy.$$escapeHtml(opt_data.pageId), '"/><input type="hidden" id="add-watcher-username" name="username" value=""/><label for="add-watcher-user">', soy.$$escapeHtml("User"), '</label><input id="add-watcher-user" name="userFullName" type="search" class="autocomplete-user" value="" placeholder="', soy.$$escapeHtml("Full name or username"), '" autocomplete="off" data-max="10" data-target="#add-watcher-username" data-dropdown-target="#add-watcher-dropdown" data-template="{title}" data-none-message="', soy.$$escapeHtml("No matching users found."), '"><input id="add-watcher-submit" type="submit" name="add" value="', soy.$$escapeHtml("Add"), '"><div id="add-watcher-dropdown" class="aui-dd-parent autocomplete"></div><div class="status hidden"></div></form><ul class="user-list"><li class="loading">', "Loading\x26hellip;", '</li><li class="no-users hidden">', soy.$$escapeHtml("No page watchers"), '</li></ul></div><div class="column space-watchers"><h3>', soy.$$escapeHtml("Watching this space"), '</h3><p class="description">', soy.$$escapeHtml("These people are notified when any content in the space is changed. You cannot modify this list."), '</p><ul class="user-list"><li class="loading">', "Loading\x26hellip;", '</li><li class="no-users hidden">', soy.$$escapeHtml("No space watchers"), '</li></ul></div></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.ManageWatchers.userItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<li class="watch-user"><img class="profile-picture confluence-userlink" src="', soy.$$escapeHtml(opt_data.iconUrl), '" data-username="', soy.$$escapeHtml(opt_data.username), '"><a class="confluence-userlink" href="', soy.$$escapeHtml(opt_data.url), '" data-username="', soy.$$escapeHtml(opt_data.username), '">', soy.$$escapeHtml(opt_data.fullName), ' <span class="username">(', soy.$$escapeHtml(opt_data.username), ')</span></a><span class="remove-watch" title="', soy.$$escapeHtml("Remove"), '" data-username="', soy.$$escapeHtml(opt_data.username), '">', soy.$$escapeHtml("Remove"), '</span></li>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.ManageWatchers.helpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.Dialog.helpLink({href: "http://docs.atlassian.com/confluence/docs-41/Managing+Watchers"}, output);
  if (!opt_sb) return output.toString();
};

AJS.toInit(function(c){var f,j;var a=function(l){if(l.homePage){var m="Home page";return'<span class="child-display"><span class="icon icon-home-page" title="'+m+'">'+m+':</span> <a href="'+AJS.params.contextPath+l.href+'">'+l.text+"</a></span>"}else{var k=l.recentlyUpdated?"icon icon-recently-updated-page":"icon icon-page";return'<span class="child-display"><span class="'+k+'" title="Page">Page:</span> <a href="'+AJS.params.contextPath+l.href+'">'+AJS.escapeHtml(l.text)+"</a></span>"}};var e=function(m){var k=c("#page-children:not(.children-loaded)");g();if(m&&k.length){if(m.errorMessage){k.html("<span class='error'>"+m.errorMessage+"</span>");return}var l=[];c.each(m,function(n,o){l.push(a(o))});k.html(l.join(""));k.addClass("children-loaded")}};var g=function(){if(j){j();j=null}f.addClass("hidden")};var b=function(k){AJS.safe.ajax({url:AJS.params.contextPath+"/json/pagechildrenstoresettings.action",type:"POST",data:{pageId:AJS.params.pageId,showChildren:k},success:function(){},error:function(m,l){AJS.log("Failed to store the user 'showChildren' user setting: "+l)}})};var i=function(){var k=c("#page-children:not(.children-loaded)");if(k.length){f=c("<div class='throbber'></div>");k.append(f);j=Raphael.spinner(f[0],10,"#666");AJS.safe.ajax({url:AJS.params.contextPath+"/json/pagechildren.action",type:"POST",data:{pageId:AJS.params.pageId,showChildren:true},success:e,error:function(o,n,m){var l="Could not load child pages.";g();k.html("<span class='error'>"+l+"</span>");AJS.log("Error retrieving child pages: "+n)}})}else{b(true)}};var d=function(){c("#page-children").hide();b(false)};var h=function(){c("#page-children").show();if(c("#children-section:not(.children-showing)").length){i()}else{b(true)}};c("#children-section a.children-show-hide").each(function(){c(this).click(function(l){var k=c("#children-section");if(k.hasClass("children-showing")){d();k.removeClass("children-showing").addClass("children-hidden")}else{h();k.removeClass("children-hidden").addClass("children-showing")}return AJS.stopEvent(l)})})});
(function($){var escapeable=/["\\\x00-\x1f\x7f-\x9f]/g,meta={"\b":"\\b","\t":"\\t","\n":"\\n","\f":"\\f","\r":"\\r",'"':'\\"',"\\":"\\\\"};$.toJSON=typeof JSON==="object"&&JSON.stringify?JSON.stringify:function(o){if(o===null){return"null"}var type=typeof o;if(type==="undefined"){return undefined}if(type==="number"||type==="boolean"){return""+o}if(type==="string"){return $.quoteString(o)}if(type==="object"){if(typeof o.toJSON==="function"){return $.toJSON(o.toJSON())}if(o.constructor===Date){var month=o.getUTCMonth()+1,day=o.getUTCDate(),year=o.getUTCFullYear(),hours=o.getUTCHours(),minutes=o.getUTCMinutes(),seconds=o.getUTCSeconds(),milli=o.getUTCMilliseconds();if(month<10){month="0"+month}if(day<10){day="0"+day}if(hours<10){hours="0"+hours}if(minutes<10){minutes="0"+minutes}if(seconds<10){seconds="0"+seconds}if(milli<100){milli="0"+milli}if(milli<10){milli="0"+milli}return'"'+year+"-"+month+"-"+day+"T"+hours+":"+minutes+":"+seconds+"."+milli+'Z"'}if(o.constructor===Array){var ret=[];for(var i=0;i<o.length;i++){ret.push($.toJSON(o[i])||"null")}return"["+ret.join(",")+"]"}var name,val,pairs=[];for(var k in o){type=typeof k;if(type==="number"){name='"'+k+'"'}else{if(type==="string"){name=$.quoteString(k)}else{continue}}type=typeof o[k];if(type==="function"||type==="undefined"){continue}val=$.toJSON(o[k]);pairs.push(name+":"+val)}return"{"+pairs.join(",")+"}"}};$.evalJSON=typeof JSON==="object"&&JSON.parse?JSON.parse:function(src){return eval("("+src+")")};$.secureEvalJSON=typeof JSON==="object"&&JSON.parse?JSON.parse:function(src){var filtered=src.replace(/\\["\\\/bfnrtu]/g,"@").replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g,"]").replace(/(?:^|:|,)(?:\s*\[)+/g,"");if(/^[\],:{}\s]*$/.test(filtered)){return eval("("+src+")")}else{throw new SyntaxError("Error parsing JSON, source is not valid.")}};$.quoteString=function(string){if(string.match(escapeable)){return'"'+string.replace(escapeable,function(a){var c=meta[a];if(typeof c==="string"){return c}c=a.charCodeAt();return"\\u00"+Math.floor(c/16).toString(16)+(c%16).toString(16)})+'"'}return'"'+string+'"'}})(jQuery);
(function(){var a=jQuery.ajax;AJS.safe={ajax:function(b){if(b.data&&typeof b.data=="object"){b.data.atl_token=jQuery("#atlassian-token").attr("content");return a(b)}},get:function(){jQuery.ajax=AJS.safe.ajax;try{return jQuery.get.apply(jQuery,arguments)}finally{jQuery.ajax=a}},getScript:function(b,c){return AJS.safe.get(b,null,c,"script")},getJSON:function(b,c,d){return AJS.safe.get(b,c,d,"json")},post:function(b,d,e,c){jQuery.ajax=AJS.safe.ajax;try{return jQuery.post.apply(jQuery,arguments)}finally{jQuery.ajax=a}}}})();AJS.safeAjax=function(a){return AJS.safe.ajax(a)};
(function(){var a=function(b){return{id:b.id,title:b.title,url:AJS.REST.findLink(b.link),type:b.type,spaceName:b.space?b.space.title:"",spaceKey:b.space?b.space.key:"",friendlyDate:b.lastModifiedDate?b.lastModifiedDate.friendly:"",date:b.lastModifiedDate?b.lastModifiedDate.date:""}};jQuery.fn.searchResultsGrid=function(b,f,n,d){var g=jQuery,h=this;var j=f.results;if(!j||!j.length){var p=AJS.format(d.noSearchResults,AJS.escapeEntities(b));h.html("<div class='no-results'>"+p+"</div>");return}h.html(AJS.getTemplate("searchResultsGrid").toString());if(!f.skipResultCount){var m=f.startIndex+1,k=f.startIndex+j.length,l=AJS.format(d.resultsCount,m,k,f.total,AJS.escapeEntities(b));h.prepend(AJS.renderTemplate("searchResultsGridCount",AJS.html(l)))}for(var e=0;e<j.length;e++){var o=j[e];o=f.convertFromRest?a(o):o;var c=g(AJS.renderTemplate("searchResultsGridRow",[o.title,o.url,o.type,o.spaceName,o.spaceKey,o.friendlyDate,o.date]));if(o.type=="attachment"&&o.id){c.attr("data-attachment-id",o.id)}c.selectableEffects(h,n.select,j[e]);h.find("table").append(c)}g(".search-result:first",h).click()}})();
(function(a){a.ui=a.ui||{};a.fn.extend({spinner:function(b){if(!this.is(".ui-spinner")){return new a.ui.spinner(this,b||{})}}});a.ui.spinner=function(e,k){this.anchor=e;var g=AJS.params.staticResourceUrlPrefix||contextPath;this.images=k.images||[g+"/images/ddtree/black spinner/1.png",g+"/images/ddtree/black spinner/2.png",g+"/images/ddtree/black spinner/3.png",g+"/images/ddtree/black spinner/4.png",g+"/images/ddtree/black spinner/5.png",g+"/images/ddtree/black spinner/6.png",g+"/images/ddtree/black spinner/7.png",g+"/images/ddtree/black spinner/8.png",g+"/images/ddtree/black spinner/9.png",g+"/images/ddtree/black spinner/10.png",g+"/images/ddtree/black spinner/11.png",g+"/images/ddtree/black spinner/12.png"];this.width=k.width||"16px";this.height=k.height||k.width||"16px";this.hide=function(){this.anchor.hide();this.stop()};this.show=function(){this.start();this.anchor.show()};this.fadeIn=function(){this.anchor.fadeIn.apply(this.anchor,arguments)};this.fadeOut=function(){this.anchor.fadeOut.apply(this.anchor,arguments)};this.moveTo=function(i,l){this.anchor.css("top",l);this.anchor.css("left",i)};this.putInBox=function(n){var l=n.x||n.x1,o=n.y||n.y1,m=(typeof n.width=="undefined")?n.x2-n.x1:n.width,i=(typeof n.height=="undefined")?n.y2-n.y1:n.height;this.moveTo(l+Math.round((m-this.offsetWidth)/2),o+Math.round((i-this.offsetHeight)/2))};this.start=function(){if(!this.timer){this.timer=setInterval(b,100)}return this.timer};this.stop=function(){clearInterval(this.timer);this.timer=null};this.divs=[];for(var d=0,j=this.images.length;d<j;d++){var c=document.createElement("div");if(!AJS.applyPngFilter(c,this.images[d])){var f=document.createElement("img");f.src=this.images[d];f.style.width=this.width;f.style.height=this.height;c.appendChild(f)}c.style.width=this.width;c.style.height=this.height;this.anchor.append(c);if(!this.offsetWidth){this.offsetWidth=c.offsetWidth;this.offsetHeight=c.offsetHeight}this.divs.push(a(c).hide())}this.frame=0;this.direction=1;var h=this;var b=function(){h.divs[h.frame].hide();h.frame+=h.direction;if(h.frame>=h.divs.length){h.frame=0}if(h.frame<0){h.frame=h.divs.length-1}h.divs[h.frame].show()};this.anchor.css("position","absolute")}})(jQuery);
(function(b){b.ui=b.ui||{};b.fn.extend({tree:function(c){if(!this.is(".ui-tree")){return new b.ui.tree(this,c)}}});var a=function(c){c.preventDefault()};b.ui.tree=function(f,h){var e=f,t=this,F=false,g=arguments;if(!(/^[ou]l$/i.test(e[0].tagName))){F=true;if(!h.url){return false}e.html("<ul></ul>");e=b("ul",e)}var v=e[0];e.addClass("ui-tree");var n={list:e,visibleNodes:[],dim:e.offset(),points:[],win:b(window),timer:null,prev:0,events:{grab:function(){},click:function(){},drag:function(){},drop:function(){},append:function(){},insertabove:function(){},insertbelow:function(){},load:function(){},nodeover:function(){},nodeout:function(){},onready:function(){},order:function(){},orderUndo:function(){},remove:function(){},preview:function(){}}};this.options=h;this.expandPath=function(i,L){L=L||function(){};if(i.length){var K=1,J,H,I=function(){if(K<i.length){for(var M in i[K]){J=t.findNodeBy(M,i[K][M]);if(J){break}}K++;J.open(I)}else{L()}};for(H in i[0]){J=this.findNodeBy(H,i[0][H]);break}if(!J){return}J.open(I)}else{L()}};this.reload=function(H){if(F){e.remove()}for(var I in H){this.options[I]=H[I]}return new g.callee(f,this.options)};this.append=function(i){var H=x(i);e.append(H);c.call(H);o()};this.unhighlight=function(){e.find("li.highlighted").each(function(i,H){b(this).removeClass("highlighted")})};function k(O,N){O=(O+"").toLowerCase();N=(N+"").toLowerCase();var J=/(\d+|\D+)/g,K=O.match(J),H=N.match(J),M=Math.max(K.length,H.length);for(var I=0;I<M;I++){if(I==K.length){return -1}if(I==H.length){return 1}var P=parseInt(K[I],10),L=parseInt(H[I],10);if(P==K[I]&&L==H[I]&&P!=L){return(P-L)/Math.abs(P-L)}if((P!=K[I]||L!=H[I])&&K[I]!=H[I]){return K[I]<H[I]?-1:1}}return 0}function u(I){this[0]=I[0];this.$=I;this.text=I.find("span").text();this.href=I.find("a").attr("href");this.linkClass=I.find("a").attr("class");this.nodeClass=I.attr("class");this.open=function(J){return n.visibleNodes[this[0].num].open(J)};this.insertChild=function(J){J.$&&(J=J[0]);n.visibleNodes[this[0].num].append(J)};this.reorder=function(){n.visibleNodes[this[0].num].order(k)};this.close=function(){n.visibleNodes[this[0].num].close()};this.getAttribute=function(J){return this[0][J]};this.setAttribute=function(J,K){this[0][J]=K};this.highlight=function(){this.$.addClass("highlighted")};this.unhighlight=function(){this.$.removeClass("highlighted")};this.makeDraggable=function(){this.setAttribute("undraggable",false);this.$.removeClass("undraggable")};this.makeUndraggable=function(){this.setAttribute("undraggable",true);this.$.addClass("undraggable")};this.makeClickable=function(K){this.setAttribute("unclickable",false);this.$.removeClass("unclickable");var L=this[0].getElementsByTagName("a");var J;if(K){J=b(L[0])}else{J=b(L)}J.unbind("click",a);J.click(n.events.click)};this.makeUnclickable=function(K){this.setAttribute("unclickable",true);this.$.addClass("unclickable");var L=this[0].getElementsByTagName("a");var J;if(K){J=b(L[0])}else{J=b(L)}J.click(a);J.unbind("click",n.events.click)};this.setText=function(J){this.text=J;this[0].text=J;this.$.find("span").text(J)};this.getParent=function(){if(this.$.parent(":not(.ui-tree)").length){var J=this.$.parent().parent();if(J.length){return new u(b(J[0]))}}return null};this.append=function(L){var K=this.$.find("ul");if(!K.length){if(this[0].toBeLoaded){var M=this;this.open(function(){M.append(L)});return false}this.$.append("<ul></ul>");K=this.$.find("ul")}var J=x(L);K.append(J);c.call(J);if(typeof this[0].closed=="undefined"){this.$.addClass("closed");this[0].closed=true;K.hide()}o()};this.below=function(J){var K=x(J);this.$.after(K);c.call(K);o()};this.above=function(J){var K=x(J);this.$.before(K);c.call(K);o()};this.remove=function(){this.$.remove();o()};this.reload=function(){if(this[0].getElementsByTagName("ul").length){this[0].removeChild(this[0].getElementsByTagName("ul")[0]);this.$.removeClass("opened").addClass("closed");this[0].closed=true;n.visibleNodes[this[0].num].open()}};this.order=function(O){var L=b("ul",this.$),J=this[0];J.ordered=true;if(L.length){var K=[];J.oldorder=[];b("li",this.$).each(function(){K.push(this);J.oldorder.push(this)});function P(R,Q){return O(b(R).find("span").html(),b(Q).find("span").html())}K.sort(P);J.order=K;for(var M=0,N=K.length;M<N;M++){L.append(K[M])}}o()};this.orderUndo=function(){this[0].ordered=false;var J=b("ul",this.$);if(this[0].oldorder&&J.length){for(var K=0,L=this[0].oldorder.length;K<L;K++){J.append(this[0].oldorder[K])}}this[0].oldorder=null;o()};this.setOrdered=function(J){this[0].ordered=J;b("a.abc:first",this).css("display",J?"none":"block");b("a.rollback:first",this).css("display","none")};if(t.options.parameters&&t.options.parameters.length){for(var i=0,H=t.options.parameters.length;i<H;i++){if(I[0][t.options.parameters[i]]){this[t.options.parameters[i]]=I[0][t.options.parameters[i]]}}}}this.findNodeBy=function(I,M){var K=[],H=v.getElementsByTagName("li");for(var J=0,L=H.length;J<L;J++){if(H[J][I]==M){K.push(new u(b(H[J])))}}if(K.length==0){return null}else{if(K.length==1){return K[0]}else{return K}}};if(h.url){var r=document.createElement("div");r.className="tree-spinner";if(h.spinnerId){r.id=h.spinnerId}b("body").append(r);n.spinner=b(r).spinner();n.spinner.hide()}for(var y in n.events){if(typeof h[y]=="function"){n.events[y]=h[y]}}function z(i){return !(i.tagName.toLowerCase()=="li"&&b("li:not(.tree-helper)",i).length<1)}function d(i){this.$li=b(i);this.height=this.$li.height()}d.prototype.append=function(i){if(this.$li[0]==i){return false}if(this.$li[0].toBeLoaded){var J=this;this.load(function(){J.append(i)});return false}if(this.$li[0].tagName.toLowerCase()=="li"){var I=b("ul:first",this.$li);var H=i.parentNode.parentNode;b(".rollback:first",H).css("display","none");if(I.length){I.append(i);if(this.$li[0].ordered){this.order(k)}}else{I=document.createElement("ul");I.appendChild(i);this.$li[0].appendChild(I);this.$li.addClass("opened");b(".click-zone:first",this.$li).css("display","inline");b(".rollback:first",this.$li).css("display","none")}if(!z(H)){n.visibleNodes[H.num].notaFolderAnymore()}setTimeout(o,0);n.events.append.call({source:i,target:this.$li[0]})}};d.prototype.below=function(i){var H=i.parentNode.parentNode;this.$li.after(i);b(".rollback:first",H).css("display","none");if(z(H)){if(!b(i.parentNode).hasClass("ui-tree")&&!i.parentNode.parentNode.undraggable){i.parentNode.parentNode.ordered=false;b(".abc:first",i.parentNode.parentNode).css("display","block");b(".rollback:first",i.parentNode.parentNode).css("display","none")}}else{n.visibleNodes[H.num].notaFolderAnymore()}setTimeout(o,0);n.events.insertbelow.call({source:i,target:this.$li[0]})};d.prototype.above=function(i){var H=i.parentNode.parentNode;this.$li.before(i);b(".rollback:first",H).css("display","none");if(z(H)){if(!b(i.parentNode).hasClass("ui-tree")&&!i.parentNode.parentNode.undraggable){i.parentNode.parentNode.ordered=false;b(".abc:first",i.parentNode.parentNode).css("display","block");b(".rollback:first",i.parentNode.parentNode).css("display","none")}}else{n.visibleNodes[H.num].notaFolderAnymore()}setTimeout(o,0);n.events.insertabove.call({source:i,target:this.$li[0]})};d.prototype.order=function(M){var H=this.$li[0];H.ordered=true;var J=b("ul:first",this.$li);if(J.length){var I=[];H.oldorder=[];b("li",this.$li).each(function(){if(this.parentNode.parentNode==H){I.push(this);H.oldorder.push(this)}});function N(O,i){var Q=b("span",O).text().replace(/^\s+|\s+$/g,""),P=b("span",i).text().replace(/^\s+|\s+$/g,"");return M(Q,P)}I.sort(N);H.order=I;for(var K=0,L=I.length;K<L;K++){J.append(I[K])}}o()};d.prototype.orderUndo=function(){var H=this.$li[0];H.ordered=false;var I=b("ul:first",this.$li);if(H.oldorder&&I.length&&I[0].parentNode==H){for(var J=0,K=H.oldorder.length;J<K;J++){I.append(H.oldorder[J])}}H.oldorder=null;H.oldor=null;o()};d.prototype.open=function(H){H=H||function(){};if(this.$li.hasClass("closed")){var i=b("ul:has(li)",this.$li);if(i.length){i.show();this.closed=false;this.$li.removeClass("closed").addClass("opened");o();H(true);return true}else{return this.load(H)}}H(false);return false};d.prototype.close=function(H){H=H||function(){};var i=this.$li.contents().filter("ul:has(li)");if(i.length){i.hide();this.closed=true;this.$li.removeClass("opened").addClass("closed");n.visibleNodes.splice(this.$li[0].num+1,i[0].getElementsByTagName("li").length);o();H()}};d.prototype.load=function(P){var H=t.options.url;if(!H){return false}P=P||function(){};this.$li[0].toBeLoaded=false;this.$li[0].closed=true;var J={};if(h.parameters&&h.parameters.length){for(var K=0,Q=h.parameters.length;K<Q;K++){J[h.parameters[K]]=(this.$li[0][h.parameters[K]]||"")}}var I=this,N=this.$li[0].getElementsByTagName("span")[0],O=N.offsetWidth,M=Math.round(b(N).offset().left);I.loading=true;n.spinner.putInBox({x:M+O,y:this.top,width:25,height:n.H});n.spinner.show();var L=function(V){var T=b("ul",I.$li);if(!T.length){T=document.createElement("ul");I.$li[0].appendChild(T);T=b(T)}I.ordered=(typeof V[0].position!="number");for(var S=0,U=V.length;S<U;S++){var R=x(V[S]);T[0].appendChild(R);c.call(R)}T.hide();I.open(P);n.events.load();n.spinner.hide();I.$li[0].ordered=I.ordered;b(".abc:first",I.$li[0]).css("display",I.ordered||R.undraggable?"none":"block");b(".rollback:first",I.$li[0]).css("display","none")};b.ajax({url:H,type:"GET",dataType:"json",data:J,success:L});return true};d.prototype.notaFolderAnymore=function(){this.$li.removeClass("closed").removeClass("opened");b(".click-zone:first",this.$li).hide();b(".abc:first",this.$li).css("display","none");b(".rollback:first",this.$li).css("display","none");var i=this.$li[0].getElementsByTagName("ul");this.closed=false;if(i.length){this.$li[0].removeChild(i[0])}};function m(i){var H=n.points[i];if(typeof H!="undefined"){return{visibleNode:n.visibleNodes[H.num],where:H.where,top:H.top}}else{return{visibleNode:new d(v),where:"append",top:n.dim.top}}}function j(){var L={y:0,num:0};n.points=[];for(var I=0,K=n.visibleNodes.length;I<K;I++){var N=n.visibleNodes[I].$li.offset(),O=Math.round(N.top);n.visibleNodes[I].top=O;n.visibleNodes[I].left=Math.round(N.left);if(L.y){var M=(O-L.y)/4;for(var J=L.y;J<O;J++){var H=(J-L.y<M)?"above":(J-L.y<M*3)?"append":"below";n.points[J]={num:L.num,where:H,top:L.y}}}if(I==K-1){var M=(n.visibleNodes[I].height)/4;for(var J=O;J<O+n.visibleNodes[I].height;J++){var H=(J-O<M)?"above":(J-O<M*3)?"append":"below";n.points[J]={num:I,where:H,top:O}}}L.y=O;L.num=I}}function o(){n.visibleNodes=[];var H=b("li:visible",v);for(var I=0,J=H.length;I<J;I++){if(!b(H[I]).hasClass("tree-helper")){H[I].num=n.visibleNodes.length;n.visibleNodes.push(new d(H[I]))}}j()}this.updateVisibleNodes=o;var B=function(){var i={distance:3,helper:"clone",opacity:0.7,cursorAt:{top:n.H/2,left:30},stop:function(L,K){clearInterval(n.timer);clearTimeout(n.opentimer);n.opentimer=null;var I=m(n.prev);I.visibleNode.$li.removeClass("over").removeClass("above").removeClass("append").removeClass("below");I.visibleNode.$li.next().removeClass("over").removeClass("above").removeClass("append").removeClass("below");n.win.unbind("keypress",n.escape);delete n.escape;if(i.revert){i.revert=false;return false}I=m(L.pageY);var J=I.visibleNode.$li[0],H=true;while(J!=v){if(J==this){H=false;break}J=J.parentNode}H=H&&!(I.where=="above"&&I.visibleNode.$li.prev()[0]==this)&&!(I.where=="append"&&I.visibleNode.$li[0]==this.parentNode.parentNode);if(H){I.visibleNode[I.where](this);n.events.drop.call({position:I.where,source:this,target:I.visibleNode.$li[0]})}},start:function(J,H){var I=this;H.helper.append("<strong></strong>").addClass("tree-helper").find(".button-panel").remove();n.events.grab.call(I);if(this.undraggable){H.helper.addClass("no");i.revert=true}n.escape=function(M){if(M.keyCode==27){var K=m(n.prev);K.visibleNode.$li.removeClass("over").removeClass("above").removeClass("append").removeClass("below");K.visibleNode.$li.next().removeClass("over").removeClass("above").removeClass("append").removeClass("below");var L=H.helper.clone();H.helper.before(L);L.animate({left:Math.round(b(I).offset().left)+"px",top:Math.round(b(I).offset().top)+"px",opacity:0},"slow","swing",function(){L.remove()});H.helper.css("display","none");i.revert=true}};n.win.keypress(n.escape)},drag:function(N,M){var H=m(n.prev);H.visibleNode.$li.removeClass("above").removeClass("append").removeClass("below");H.visibleNode.$li.next().removeClass("above").removeClass("append").removeClass("below");if(!i.revert||n.out){n.prev=N.pageY;var K=m(n.prev);if(K.visibleNode.$li[0]==v){i.revert=true;n.out=true;return}else{if(n.out){n.out=false;i.revert=false}}if(K.visibleNode!=H.visibleNode){n.events.nodeout.call(H.visibleNode.$li);if(n.opentimer){clearTimeout(n.opentimer);n.opentimer=false}}n.events.nodeover.call({element:K.visibleNode.$li,position:K.where});var J=K.where,I=K.visibleNode.$li.next();if(J=="below"&&I.length&&!I.hasClass("tree-helper")){I.addClass("above")}else{m(n.prev).visibleNode.$li.addClass(J)}if(K.where=="append"&&(K.visibleNode.closed||K.visibleNode.$li[0].toBeLoaded)&&!n.opentimer){n.opentimer=(function(O){return setTimeout(function(){O.visibleNode.$li.removeClass("append");O.visibleNode.open(function(){n.opentimer=false})},500)})(K)}var L=arguments.callee;if(n.win.height()-N.pageY+n.win.scrollTop()<30){clearInterval(n.timer);n.timer=setInterval(function(){window.scrollBy(0,4);M.helper.css("top",parseInt(M.helper.css("top"))+4+"px");L({pageY:N.pageY+4},M)},n.win.height()-N.pageY+n.win.scrollTop())}else{if(n.win.scrollTop()>0&&(N.pageY-n.win.scrollTop())<30){clearInterval(n.timer);n.timer=setInterval(function(){window.scrollBy(0,-4);L({pageY:N.pageY-4},M);M.helper.css("top",parseInt(M.helper.css("top"))-4+"px")},N.pageY-n.win.scrollTop())}else{if(n.timer){clearInterval(n.timer)}}}n.events.drag.call({element:this,left:N.pageX,top:N.pageY})}}};return i};function c(){var i=b(this);if(t.options.undraggable){i.mousedown(a)}else{i.draggable(B());i[0].undraggable=i.hasClass("undraggable")}var H=b(this.getElementsByTagName("a")[0]);if(t.options.unclickable){i.addClass("unclickable");H.click(a)}else{H.click(n.events.click)}if(t.options.oninsert){t.options.oninsert.call(new u(i),H)}}b.ui.tree.callNumber=0;var q=function(i){if(n.visibleNodes[this.parentNode.num].loading){return}if(b(this.parentNode).hasClass("closed")){n.visibleNodes[this.parentNode.num].open()}else{n.visibleNodes[this.parentNode.num].close()}return false},s=function(i){if(!b(i.target).hasClass("tree-helper")){b(".button-panel:first",this).addClass("hover")}return false},E=function(i){if(!b(i.target).hasClass("tree-helper")){b(".button-panel:first",this).removeClass("hover")}return false},D=function(){var i=n.visibleNodes[this.parentNode.parentNode.num];i.order(k);n.events.order.call({source:i.$li[0]});b(this).hide();b("a.rollback",this.parentNode).show();return false},w=function(H){var i=n.visibleNodes[this.parentNode.parentNode.num];i.orderUndo();n.events.orderUndo.call({source:i.$li[0],orderedChildren:b("ul:first",i.$li[0]).children()});b(this).hide();b("a.abc",this.parentNode).show();return false},G=function(H){H.preventDefault();var i=n.visibleNodes[this.parentNode.parentNode.num];n.events.preview.call({source:preview,node:i.$li[0]})},A=function(H){H.preventDefault();var i=n.visibleNodes[this.parentNode.parentNode.num];n.events.remove.call({source:i.$li[0]})};function x(I){var S=document.createElement("li");S.className=I.nodeClass;if(t.options.parameters&&t.options.parameters.length){for(var K=0,L=t.options.parameters.length;K<L;K++){if(I[t.options.parameters[K]]){S[t.options.parameters[K]]=I[t.options.parameters[K]]}}}if(t.options.nodeId){S.id="node-"+I[t.options.nodeId]}var Q=document.createElement("a"),R=document.createElement("span"),J=document.createElement("i");J.className="decorator";Q.href=I.href;R.appendChild(document.createTextNode(I.text));Q.appendChild(R);Q.appendChild(J);Q.className=I.linkClass;var M=document.createElement("div");b(M).addClass("click-zone");b(M).click(q);b(S).mouseover(s).mouseout(E);S.appendChild(M);S.appendChild(Q);var i=document.createElement("div");i.className="button-panel";S.appendChild(i);var P=document.createElement("a");P.className="abc";P.title="Sort Alphabetically";i.appendChild(P);var H=document.createElement("a");H.className="rollback";H.title="Undo Sorting";i.appendChild(H);b(P).click(D);b(H).click(w);if(t.options.isAdministrator){var N=document.createElement("a");N.className="preview-node";N.title="Preview";i.appendChild(N);b(N).click(G);var T=document.createElement("a");T.className="remove-node";T.title="Delete";i.appendChild(T);b(T).click(A)}b(P).css("display","none");b(H).css("display","none");var O=b(S);if(O.hasClass("opened")){O.removeClass("opened").addClass("closed");S.closed=true}else{if(O.hasClass("closed")){S.toBeLoaded=true}else{b(M).css("display","none")}}return S}var p=e.contents().filter("li");if(p.length>0){n.H=p.height();p.each(c);o();n.events.onready.call(this)}else{var l=t.options.initUrl||t.options.url;if(!l){return false}n.spinner.putInBox({x:n.dim.left,y:n.dim.top,width:16,height:16});n.spinner.show();var C=++b.ui.tree.callNumber;b.getJSON(l,function(L){var K=+new Date;for(var I=0,J=L.length;I<J;I++){var H=x(L[I]);v.appendChild(H);if(I==0){n.H=b(H).height()}c.call(H)}o();n.spinner.hide();if(C==b.ui.tree.callNumber){n.events.onready.call(this);b.ui.tree.callNumber=0}})}n.offset=v.offsetTop;setInterval(function(){if(v.offsetTop!=n.offset){j();n.offset=v.offsetTop}},10);return this}})(jQuery);
// This file was automatically generated from page-move-dialog.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.MovePage == 'undefined') { Confluence.Templates.MovePage = {}; }


Confluence.Templates.MovePage.errorMessage = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div id="move-errors" class="hidden warning"></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.breadcrumbItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<li><a class="', soy.$$escapeHtml(opt_data.className), '" title="', soy.$$escapeHtml(opt_data.title), '" tabindex="-1"><span>', soy.$$escapeHtml(opt_data.text), '</span></a></li>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.breadcrumbLoading = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<li class="loading"><span>', "Loading breadcrumbs\x26hellip;", '</span></li>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.breadcrumbError = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<li class="warning last"><span>', soy.$$escapeHtml("Error retrieving breadcrumbs."), '</span></li>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.noMatchingPages = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<ol><li><span class="warning">', soy.$$escapeHtml("No matching pages found."), '</span></li></ol>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.noMatchingSpaces = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<ol><li><span class="warning">', soy.$$escapeHtml("No matching spaces found."), '</span></li></ol>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.searchResultsLoading = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="searching">', soy.$$escapeHtml("Searching\u2026"), '</div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.pageHistoryLoading = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="searching">', soy.$$escapeHtml("Loading\u2026"), '</div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.panelLoading = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<span>', soy.$$escapeHtml("Loading\u2026"), '</span>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.browsePanelSpace = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<ul><li id=\'tree-root-node-item\' class=\'root-node-list-item\'><a class=\'root-node\' href=\'#\'>', soy.$$escapeHtml(opt_data.linkText), '</a></li></ul>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.orderingPagePanel = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div id="orderingPlaceHolder"></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.reorderCheckbox = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<span id="reorderRequirement"><input id="reorderCheck" type="checkbox" name="reorderFlag" title="', soy.$$escapeHtml("Choose the position of this page within the list of child pages."), '"/><label for="reorderCheck" title="', soy.$$escapeHtml("Choose the position of this page within the list of child pages."), '">', soy.$$escapeHtml("Reorder"), '</label></span>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.helpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.Dialog.helpLink({href: "http://docs.atlassian.com/confluence/docs-41/Moving+a+Page"}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.historyPanel = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="row information"><div class="inner"><div class="element">', soy.$$escapeHtml(AJS.format("Select the new parent page for this page and its children from your history.",opt_data.pageTitle)), '</div></div></div><div id="move-page-search-container" class="row"><div class="search-results"></div></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.MovePage.browsePanel = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="row information"><div class="inner"><div class="element">', soy.$$escapeHtml(AJS.format("Click to select the new parent page for this page and its children.",opt_data.pageTitle)), '</div></div></div><div class="tree"></div>');
  if (!opt_sb) return output.toString();
};

jQuery.fn.movePageOrdering=function(i,j,g,e){var f=jQuery;var c=f("#confluence-context-path").attr("content");var b=f("#orderingPlaceHolder",this);b.addClass("loading").html(Confluence.Templates.MovePage.panelLoading());b.load(c+"/panels/reorderpage.action",{panelName:"reorder",spaceKey:i,title:j,movedPageId:AJS.params.pageId,pageTitle:g},function(){b.removeClass("loading");h(b,e);a(f(".siblings",b))});var d=function(m,o){var l;var n=m.prevAll("li.sibling")[0];if(n){l="below"}else{l="above";n=m.nextAll("li.sibling")[0]}if(n){AJS.log("Reorder: positionIndicator = "+l+" and target = "+n.innerHTML);var k=f("i",n).text();o(k,l)}};var h=function(k,p){var m=f(".dropper",k),o=f(".target",m);var l=0;f("li",m).each(function(q){!q&&f(this).before(f('<li class="leading">&nbsp;</li>'));f(this).after(f('<li class="leading">&nbsp;</li>'))});var n=o.next();f(".leading",m).hover(function(q){f(this).addClass("here")},function(){f(this).removeClass("here")}).click(function(){d(f(this),p);var q=this;o.hide(150,function(){q!=n[0]&&f(q).after(n).after(o);o.show(150)})})};var a=function(k){var m=f(".target",k);if(m.length){var l=m.position().top;var n=k.height();if(l<0||l>n){k.scrollTop(k.scrollTop()+l-n/3)}}}};
jQuery.fn.renderBreadcrumbs=function(k){var g=jQuery,e=this,j=[],h=0,m=k.length-1,a=k[h],c=a.url.indexOf("~")>=0?"personalspacedesc":"spacedesc",l,b=e.closest(".breadcrumbs-container").width(),f=function(){return e.width()<b},d;j.push(Confluence.Templates.MovePage.breadcrumbItem({text:a.title,title:a.title,className:(h==m?"last":"")}));while(h++<m){l=k[h];j.push(Confluence.Templates.MovePage.breadcrumbItem({text:l.title,title:l.title,className:(h==m?"last":"")}))}this.html(j.join(""));d=g("li a span",this);d.each(function(i){if(i!=0&&i!=m){g(this).shortenUntil(f)}});g(d.get(0)).shortenUntil(f);g(d.get(m)).shortenUntil(f);return this};AJS.toInit(function(d){var b=d("#confluence-context-path").attr("content");function a(e){for(var f=1;f<e.length;f++){if(e[f].title==AJS.Meta.get("page-title")){return false}}return true}if(!AJS.MoveDialog){AJS.MoveDialog={}}var c={};AJS.MoveDialog.getBreadcrumbs=function(f,h,e){var g=f.userName?f.userName:(f.pageId?(f.pageId+":"+f.fileName):(f.spaceKey+":"+f.title+":"+f.postingDay+":"+f.fileName));if(g in c){h(c[g],"success");return}d.ajax({type:"GET",dataType:"json",data:f,url:b+"/pages/breadcrumb.action",error:e||function(){},success:function(j,k){if(!j||!j.breadcrumbs){e(j,k);return}var i=d.makeArray(j.breadcrumbs);while(i[0]&&(/dashboard.action$/.test(i[0].url)||(j.type!="userinfo"&&/peopledirectory.action$/.test(i[0].url)))){i.shift()}i.type=j.type;c[g]=i;h(i,k)}})};AJS.MoveDialog.Breadcrumbs=function(h,f){var e=0;function g(l,k,j){h.renderBreadcrumbs(k);var i=l!=AJS.Meta.get("space-key")||a(k);if(i){j.clearErrors();d(j.moveButton).attr("disabled","")}else{j.error("You cannot move a page to be underneath itself or its children.");d("li:last-child",h).addClass("warning")}}return{update:function(j,i){h.html(Confluence.Templates.MovePage.breadcrumbLoading());var k=e+=1;var l=function(){if(k!=e){AJS.log("Breadcrumb response for ");AJS.log(j);AJS.log(" is stale, ignoring.");return true}return false};(f||AJS.MoveDialog.getBreadcrumbs)(j,function(m,n){if(l()){return}if(n!="success"||!m){h.html(Confluence.Templates.MovePage.breadcrumbError());return}g(j.spaceKey,m,i)},function(m){if(l()){return}h.html(Confluence.Templates.MovePage.breadcrumbError());if(m.status==404){i.error("The specified page was not found.")}})}}};AJS.Breadcrumbs={};AJS.Breadcrumbs.getBreadcrumbs=function(f,h,e){if(!f.id){throw new Error("id is a required parameter in 'options'")}if(!f.type){throw new Error("type is a required parameter in 'options'")}var g=f.id+":"+f.type;if(g in c){h(c[g],"success");return}d.ajax({type:"GET",dataType:"json",data:f,url:Confluence.getContextPath()+AJS.REST.getBaseUrl()+"breadcrumb",error:e||function(){},success:function(j,k){if(!j||!j.breadcrumbs){e(j,k);return}var i=d.makeArray(j.breadcrumbs);while(i[0]&&(/dashboard.action$/.test(i[0].url)||(j.type!="userinfo"&&/peopledirectory.action$/.test(i[0].url)))){i.shift()}i.type=j.type;c[g]=i;h(i,k)}})}});
jQuery.fn.movePageAutocomplete=function(d,c,b,a){var f=jQuery;var e=a;AJS.log(d);return f(this).quicksearch(d,null,{dropdownPostprocess:function(g){f("> ol.last",g).remove();if(!f("> ol",g).length){f(g).append(b)}f("> ol:last-child",g).addClass("last");f("a",g).attr("tabindex","-1")},dropdownPlacement:function(g){f(c).append(g)},ajsDropDownOptions:{selectionHandler:function(h,g){if(g){this.hide("selected");e(h,g);h.preventDefault()}}}})};jQuery.fn.movePageLocation=function(c){var f=jQuery;var b=f(this);var e=f("#new-space",b);var d=f("#new-space-key",b);var a=f("#new-parent-page",b);var g=function(){if(e.is(":visible")){if(e.val()==""){e.val(AJS.Meta.get("space-name"));d.val(AJS.Meta.get("space-key"))}c.clearErrors();c.select(d.val(),e.val(),a.val())}};a.blur(g).focus(function(){c.clearErrors();AJS.dropDown.current&&AJS.dropDown.current.hide()});e.blur(g).focus(function(){AJS.dropDown.current&&AJS.dropDown.current.hide()});e.movePageAutocomplete("/json/contentnamesearch.action?type=spacedesc&type=personalspacedesc",f(".new-space-dropdown",b),Confluence.Templates.MovePage.noMatchingSpaces(),function(j,i){var h=i.find("span").data("properties");d.val(h.spaceKey);e.val(AJS("span").html(h.name).text());a.val("");g();a.focus()});a.movePageAutocomplete(function(){return"/json/contentnamesearch.action?type=page&spaceKey="+d.val()},f(".new-parent-page-dropdown",b),Confluence.Templates.MovePage.noMatchingPages(),function(i,h){var j=AJS("span").html(h.find("span").data("properties").name).text();a.val(j);g();window.setTimeout(function(){c.moveButton.focus()},50)})};
jQuery.fn.movePageSearch=function(b){var h=jQuery;var c=h("#confluence-context-path").attr("content");var a=this;var e=h("input[type=button]",a);var g=h("input.search-query",a);var f=h(".search-space",a);var d=h(".search-results",a);h([f[0],g[0]]).keydown(function(i){if(i.which==13){e.click()}});h([g[0],d[0]]).keydown(function(j){function i(n){var l=h(".search-result",a);var m=h(".search-result.selected",a);var k=l.index(m)+n;if(k<0){k=l.length-1}if(k>=l.length){k=0}l.eq(k).click()}if(j.which==38){i(-1)}else{if(j.which==40){i(1)}}});e.click(function(){b.clearErrors();var i=g.val();if(i==""){d.empty();return}d.html(Confluence.Templates.MovePage.searchResultsLoading());h.ajax({type:"GET",dataType:"json",data:{queryString:i,where:f.val(),types:["spacedesc","personalspacedesc","page"]},url:c+"/json/search.action",error:function(){b.error("Failed to retrieve search results from the server.")},success:function(k,j){if(j!="success"){b.error("Failed to retrieve search results from the server.");return}var l={select:function(m,n){if(n.type=="page"){b.select(n.spaceKey,n.spaceName,n.title,n.id)}else{b.select(n.spaceKey,n.spaceName)}}};d.searchResultsGrid(i,k,h(b).extend(l),{noSearchResults:"There were no pages found containing \u003cb>{0}\u003c\/b>.",resultsCount:"Showing \u003cb>{0}\u003c\/b>-\u003cb>{1}\u003c\/b> of \u003cb>{2}\u003c\/b> pages containing \u003cb>{3}\u003c\/b>."})}})})};
jQuery.fn.movePageHistory=function(b){var e=jQuery;var c=e("#confluence-context-path").attr("content");var a=this;var d=e(".search-results",a);e(d).keydown(function(g){function f(k){var i=e(".search-result",a);var j=e(".search-result.selected",a);var h=i.index(j)+k;if(h<0){h=i.length-1}if(h>=i.length){h=0}i.eq(h).click()}if(g.which==38){f(-1)}else{if(g.which==40){f(1)}}});d.html(Confluence.Templates.MovePage.pageHistoryLoading());e.ajax({type:"GET",dataType:"json",data:{types:["spacedesc","personalspacedesc","page"]},url:c+"/json/history.action",error:function(){b.error(AJS.params.movePageDialogHistoryError)},success:function(g,f){if(f!="success"){b.error(AJS.params.movePageDialogHistoryError);return}if(!g.history||g.history.length==0){d.html("<div class='no-results'>"+"There were no recently viewed pages found."+"</div>");return}d.html(AJS.getTemplate("searchResultsGrid").toString());e.each(g.history,function(){var i=this;if(i.id==AJS.params.pageId){return}var h=AJS.$(AJS.renderTemplate("searchResultsGridRow",[i.title,c+i.url,i.type,i.spaceName,i.spaceKey,i.friendlyDate,i.date]));e(h).click(function(j){if(i.type=="page"){b.select(i.spaceKey,i.spaceName,i.title,i.id)}else{b.select(i.spaceKey,i.spaceName)}d.find(".selected").removeClass("selected");e(this).addClass("selected");return AJS.stopEvent(j)});e(h).hover(function(){e(this).addClass("hover")},function(){e(this).removeClass("hover")});d.find("table").append(h)});if(e(".search-result",d).length==0){d.html("<div class='no-results'>"+"There were no recently viewed pages found."+"</div>")}}})};
jQuery.fn.movePageBrowse=function(m,j,b,l,d,f){var e=jQuery;var c=e("#confluence-context-path").attr("content");var a=this;var g=e(".tree",a);g.addClass("loading").html(Confluence.Templates.MovePage.panelLoading());var o,k=function(){g.removeClass("rendering").addClass("expanding");e("#parent-selection-tree .dialog-button-panel").remove();h(AJS.Meta.get("space-key"),d,function(s){if(s&&d!=""){var p=o.findNodeBy("text",d);if(p){p.$.find("> a").addClass("current-parent")}}var r=AJS.Meta.get("page-title");if(s&&r){var q=o.findNodeBy("text",r);if(q){q.makeUnclickable();if(r!=f){q.setText(f)}}}h(j,l,function(w){if(w){var v=o.findNodeBy("text",l);if(v){v.$.find("> a").addClass("highlighted");var t=v.$.position().top;var u=g.height();if(t<0||t>u){g.scrollTop(g.scrollTop()+t-u/3)}}}g.removeClass("expanding")})})};var i=function(p){p.preventDefault();e("a.highlighted",g).removeClass("highlighted");e(this).addClass("highlighted");j=e("#chosenSpaceKey").val();b=e("#chosenSpaceKey option:selected").text();l=e(this).hasClass("root-node")?"":e(this).find("span").text();m.select(j,b,l)};var n=function(){e("select#chosenSpaceKey").val(j).change(function(){var q=e(this).val();var p=e(this).find("option:selected").text();e("#tree-root-node-item a").text(p).toggleClass("highlighted",j==q&&l=="").toggleClass("current-parent",AJS.Meta.get("space-key")==q&&d=="");g.addClass("rendering");o=o.reload({initUrl:c+"/pages/children.action?spaceKey="+encodeURIComponent(q)+"&node=root"})});e("#tree-root-div").html(Confluence.Templates.MovePage.browsePanelSpace({linkText:b})).find("a").click(i).toggleClass("highlighted",l=="").toggleClass("current-parent",AJS.Meta.get("space-key")==j&&d=="")};var h=function(q,p,r){if(q!=e("#chosenSpaceKey").val()){r(false);return}console.log("before breadcrumbs");AJS.MoveDialog.getBreadcrumbs({spaceKey:q,title:p},function(s){var t=e.map(s.slice(1),function(u){return{text:u.title}});console.log("before expandPath");o.expandPath(t,function(){console.log("expandPath callback");r(true)})},function(){m.error("Could not retrieve tree expansion information.");r(false)})};g.load(c+"/panels/browsepagelocation.action",{panelName:"browse",dialogMode:"view",spaceKey:j,parentPageString:l,pageId:AJS.params.pageId},function(){g.removeClass("loading").addClass("rendering");n();o=e("#parent-selection-tree").tree({url:c+"/pages/children.action",initUrl:c+"/pages/children.action?spaceKey="+encodeURIComponent(j)+"&node=root",parameters:["pageId","text"],undraggable:true,spinnerId:"move-page-dialog-spinner",nodeId:"pageId",click:i,onready:k,oninsert:function(){var p=this.$;if(p.parents("li:first").attr("unclickable")){this.makeUnclickable()}}});AJS.MoveDialog.tree=o})};
AJS.toInit(function(e){Confluence.MovePageDialog=function(h){var l=AJS.Meta.get("page-title");h=e.extend({spaceKey:AJS.Meta.get("space-key"),spaceName:AJS.Meta.get("space-name"),pageTitle:l,parentPageTitle:AJS.Meta.get("parent-page-title"),title:AJS.format("Move Page &ndash; &#8216;{0}&#8217;",l),buttonName:"Move",openedPanel:"Advanced",moveHandler:function(z){AJS.log("No move handler defined. Closing dialog.");z.remove()},cancelHandler:function(z){z.remove();return false}},h);var r={spaceKey:h.spaceKey,spaceName:h.spaceName,parentPageTitle:h.parentPageTitle};var g=h.spaceKey;var t=h.spaceName;var w=h.parentPageTitle;var i="";var m="";var k=function(z,A){i=z;m=A};var x=AJS.ConfluenceDialog({width:800,height:590,id:"move-page-dialog"});x.addHeader(h.title);x.addPanel("Advanced",AJS.renderTemplate("movePageDialog"),"location-panel","location-panel-id");x.addPanel("Search",AJS.renderTemplate("movePageSearchPanel"),"search-panel","search-panel-id");x.addPanel("Recently Viewed",Confluence.Templates.MovePage.historyPanel({pageTitle:AJS.Meta.get("page-title")}),"history-panel","history-panel-id");x.addPanel("Browse",Confluence.Templates.MovePage.browsePanel({pageTitle:AJS.Meta.get("page-title")}),"browse-panel","browse-panel-id");x.get('#"'+"Advanced"+'"')[0].onselect=function(){e("#new-space-key").val(g);e("#new-space").val(t);e("#new-parent-page").val(w).select()};x.get('#"'+"Search"+'"')[0].onselect=function(){e("#move-page-dialog .search-panel .search-results .selected").removeClass("selected");e("#move-page-dialog input.search-query").focus()};x.get('#"'+"Recently Viewed"+'"')[0].onselect=function(){e(".history-panel",u).movePageHistory(o)};x.get('#"'+"Browse"+'"')[0].onselect=function(){AJS.log("browse: "+[g,t,w].join());e(".browse-panel",u).movePageBrowse(o,g,t,w,n,h.pageTitle)};var s=function(A){A.nextPage();var z=e("#move-page-dialog");e(".ordering-panel",z).movePageOrdering(g,w,h.pageTitle,k)};var q=function(A){var C=e("#new-space:visible").val();var B=e("#new-space-key").val();var z=e("#new-parent-page:visible").val();if(C&&(C!=t||B!=g||z!=w)){AJS.MoveDialog.getBreadcrumbs({spaceKey:B,pageTitle:z},function(){Confluence.PageLocation.set({spaceKey:B,spaceName:C,parentPageTitle:z});h.moveHandler(A,B,C,z,i,m,f)},function(D){e("#new-parent-breadcrumbs").html(Confluence.Templates.MovePage.breadcrumbError());if(D.status==404){o.error("The specified page was not found.")}})}else{Confluence.PageLocation.set({spaceKey:g,spaceName:t,parentPageTitle:w});h.moveHandler(A,g,t,w,i,m,f)}};var y=function(z){if(e("#reorderCheck")[0].checked){s(z)}else{q(z)}};x.addButton(h.buttonName,y,"move-button");x.addCancel("Cancel",h.cancelHandler);x.popup.element.find(".dialog-title").append(Confluence.Templates.MovePage.helpLink());x.addPage().addHeader(h.title).addPanel("Page Ordering",Confluence.Templates.MovePage.orderingPagePanel(),"ordering-panel","ordering-panel-id").addLink("Back",function(z){z.prevPage()},"dialog-back-link").addButton("Reorder",q,"reorder-button").addCancel("Cancel",h.cancelHandler);var v=x.get("button#"+h.buttonName)[0].item;e("button.move-button").before(Confluence.Templates.MovePage.reorderCheckbox());x.gotoPage(0);x.show();var u=e("#move-page-dialog");e(".location-panel .location-info",u).appendTo(e(".dialog-page-body:first",u));e(".dialog-button-panel:visible",u).prepend(Confluence.Templates.MovePage.errorMessage());var j=new AJS.MoveDialog.Breadcrumbs(e("#new-parent-breadcrumbs"));function f(z){if(!z||z.length==0){e("#move-errors").addClass("hidden");e(v).attr("disabled","");return}if(!e.isArray(z)){z=[z]}e("#move-errors").text(z[0]).attr("title",z.join("\n")).removeClass("hidden");x.gotoPage(0)}var o={moveButton:v,clearErrors:function(){f([])},error:f,select:function(B,A,z){AJS.log("select: "+[B,A,z].join());g=B;t=A;w=z||"";e(v).attr("disabled","disabled");j.update({spaceKey:g,title:w},o)}};x.overrideLastTab();x.get('#"'+h.openedPanel+'"').select();var n=AJS.Meta.get("parent-page-title")||AJS.Meta.get("from-page-title");var p=new AJS.MoveDialog.Breadcrumbs(e("#current-parent-breadcrumbs"));p.update({spaceKey:AJS.Meta.get("space-key"),title:n},o);e(".location-panel",u).movePageLocation(o);e(".search-panel",u).movePageSearch(o);e(".history-panel",u).movePageHistory(o);e("#new-parent-page").select();if(h.hint){x.addHelpText(h.hint.template||h.hint.text,h.hint.arguments)}return u};var d=function(h,g,i,f){var j={pageId:AJS.params.pageId,spaceKey:h};if(i){j.position=f;j.targetId=i}else{if(g!=""){j.targetTitle=g;j.position="append"}else{j.position="topLevel"}}return j};function a(j,l,f,m,o,g,i){j=j.popup.element;j.addClass("waiting");e("button",j).attr("disabled","disabled");var h=e("<div class='throbber'></div>");j.append(h);var n=Raphael.spinner(h[0],100,"#666");function k(p){i(p);j.removeClass("waiting");n();e("button",j).attr("disabled","")}e.ajax({url:contextPath+"/pages/movepage.action",type:"GET",dataType:"json",data:new d(l,m,o,g),error:function(){k("Move failed. There was a problem contacting the server.")},success:function(p){var q=[].concat(p.validationErrors||[]).concat(p.actionErrors||[]).concat(p.errorMessage||[]);if(q.length>0){k(q);return}window.location.href=contextPath+p.page.url+(p.page.url.indexOf("?")>=0?"&":"?")+"moved=true"}})}e("#action-move-page-dialog-link").click(function(f){f.preventDefault();if(e("#move-page-dialog").length>0){e("#move-page-dialog, body > .shadow, body > .aui-blanket").remove()}new Confluence.MovePageDialog({moveHandler:a});return false});var c;e("#rte-button-location").click(function(f){f.preventDefault();if(e("#move-page-dialog").length>0){e("#move-page-dialog, body > .shadow, body > .aui-blanket").remove()}new Confluence.MovePageDialog({spaceName:c,spaceKey:e("#newSpaceKey").val(),pageTitle:e("#content-title").val(),parentPageTitle:e("#parentPageString").val(),buttonName:"Move",title:"Set Page Location",moveHandler:function(k,h,l,m,j,i,g){c=l;e("#newSpaceKey").val(h);e("#parentPageString").val(m);if(m!=""){e("#position").val("append")}else{e("#position").val("topLevel")}if(j){e("#targetId").val(j);e("#position").val(i)}k.remove()}});return false});var b=null;Confluence.PageLocation={get:function(){if(b){return b}return{spaceName:AJS.Meta.get("space-name"),spaceKey:AJS.Meta.get("space-key"),parentPageTitle:AJS.Meta.get("parent-page-title")}},set:function(f){b=f}}});
var AJS=AJS||{};AJS.animation={running:[],queue:[],timer:null,duration:300,period:20,add:function(a){this.queue.push(a)},start:function(){if(this.timer!=null){return}this.running=this.queue;this.queue=[];jQuery.each(this.running,function(){if(this.onStart){this.onStart()}});var c=this;var b=new Date().getTime();var a=b+this.duration;this.timer=setInterval(function(){var d=new Date().getTime();var e=(d-b)/(a-b);if(e<=1){c.animate(e)}if(e>=1&&c.timer!=null){c.finish()}},this.period);return this.timer},finish:function(){clearInterval(this.timer);jQuery.each(this.running,function(){if(this.onFinish){this.onFinish()}});this.running=[];this.timer=null;if(this.queue.length>0){this.start()}},animate:function(a){jQuery.each(this.running,function(){if(this.animate){this.animate(AJS.animation.interpolate(a,this.start,this.end,this.reverse))}})},interpolate:function(d,c,a,b){if(typeof c!="undefined"&&typeof a!="undefined"){if(b){return a+d*(c-a)}else{return c+d*(a-c)}}return d},combine:function(a){return{animations:a,append:function(b){this.animations.push(b);return this},onStart:function(){jQuery.each(this.animations,function(){if(this.onStart){this.onStart()}})},onFinish:function(){jQuery.each(this.animations,function(){if(this.onFinish){this.onFinish()}})},animate:function(b){jQuery.each(this.animations,function(){if(this.animate){this.animate(AJS.animation.interpolate(b,this.start,this.end,this.reverse))}})}}}};
AJS.toInit(function(a){a("#ellipsis").click(function(){try{a("#breadcrumbs .hidden-crumb").removeClass("hidden-crumb");a(this).addClass("hidden-crumb")}catch(b){AJS.log(b)}})});
Confluence.QuickNav=(function(d){var c,a;var b=function(e){d("a",e).each(function(){var h=d(this);var f=h.find("span");var g=AJS.dropDown.getAdditionalPropertyValue(f,"spaceName");if(g&&!h.is(".content-type-spacedesc")){h.after(h.clone().attr("class","space-name").html(g));h.parent().addClass("with-space-name")}})};return{setDropDownPostProcess:function(e){c=e},setMakeParams:function(e){a=e},init:function(f,e){f.quicksearch("/json/contentnamesearch.action",null,{dropdownPlacement:e,dropdownPostprocess:function(g){c&&c(g);b(g)},makeParams:function(g){if(a){return a(g)}else{return{query:g}}}})}}})(AJS.$);AJS.toInit(function(c){var a=function(d){return function(e){d.closest("form").find(".quick-nav-drop-down").append(e)}};var b=c("#quick-search-query");spaceBlogSearchQuery=c("#space-blog-quick-search-query"),confluenceSpaceKey=c("#confluence-space-key");Confluence.QuickNav.init(b,a(b));if(spaceBlogSearchQuery.length&&confluenceSpaceKey.length){spaceBlogSearchQuery.quicksearch("/json/contentnamesearch.action?type=blogpost&spaceKey="+AJS("i").html(confluenceSpaceKey.attr("content")).text(),null,{dropdownPlacement:a(spaceBlogSearchQuery)})}});
(function(a){AJS.contentHover=function(j,i,d,f,m){var b=a.extend(false,AJS.contentHover.opts,m);var h,l,c=a("#content-hover-"+i);if(!c.length){a(b.container).append(a('<div id="content-hover-'+i+'" class="ajs-content-hover"><div class="contents"></div></div>'));c=a("#content-hover-"+i);h=c.find(".contents");h.css("width",b.width+"px").mouseover(function(){clearTimeout(e.hideDelayTimer);c.unbind("mouseover")}).mouseout(function(){g()})}else{h=c.find(".contents")}var e=c[0];var k=function(){if(c.is(":visible")){return}e.showTimer=setTimeout(function(){if(!e.contentLoaded||!e.shouldShow){return}e.beingShown=true;var p=a(window),n=l.x-3,r=l.y+15;if(n+b.width+30>p.width()){c.css({right:"20px",left:"auto"})}else{c.css({left:n+"px",right:"auto"})}var o=(window.pageYOffset||document.documentElement.scrollTop)+p.height();if((r+c.height())>o){r=o-c.height()-5;c.mouseover(function(){clearTimeout(e.hideDelayTimer)}).mouseout(function(){g()})}c.css({top:r+"px"});var q=a("#content-hover-shadow").appendTo(c).show();c.fadeIn(b.fadeTime,function(){e.beingShown=false});q.css({width:h.outerWidth()+32+"px",height:h.outerHeight()+25+"px"});a(".b",q).css("width",h.outerWidth()-26+"px");a(".l, .r",q).css("height",h.outerHeight()-21+"px")},b.showDelay)};var g=function(){e.beingShown=false;e.shouldShow=false;clearTimeout(e.hideDelayTimer);clearTimeout(e.showTimer);clearTimeout(e.loadTimer);e.contentLoading=false;e.shouldLoadContent=false;e.hideDelayTimer=setTimeout(function(){c.fadeOut(b.fadeTime)},b.hideDelay)};a(j).mousemove(function(n){l={x:n.pageX,y:n.pageY};if(!e.beingShown){clearTimeout(e.showTimer)}e.shouldShow=true;if(!e.contentLoaded){if(e.contentLoading){if(e.shouldLoadContent){var o=(l.x-e.initialMousePosition.x)*(l.x-e.initialMousePosition.x)+(l.y-e.initialMousePosition.y)*(l.y-e.initialMousePosition.y);if(o>(b.mouseMoveThreshold*b.mouseMoveThreshold)){e.contentLoading=false;e.shouldLoadContent=false;clearTimeout(e.loadTimer);return}}}else{e.initialMousePosition=l;e.shouldLoadContent=true;e.contentLoading=true;e.loadTimer=setTimeout(function(){if(!e.shouldLoadContent){return}h.load(d,function(){e.contentLoaded=true;e.contentLoading=false;f.call(c,i);k()})},b.loadDelay)}}clearTimeout(e.hideDelayTimer);if(!e.beingShown){k()}}).mouseout(function(){g()});h.click(function(n){n.stopPropagation()});a("body").click(function(){e.beingShown=false;clearTimeout(e.hideDelayTimer);clearTimeout(e.showTimer);c.hide()});return c};AJS.contentHover.opts={fadeTime:100,hideDelay:500,showDelay:700,loadDelay:50,width:300,mouseMoveThreshold:10,container:"body"};AJS.toInit(function(){a("body").append(a('<div id="content-hover-shadow"><div class="tl"></div><div class="tr"></div><div class="l"></div><div class="r"></div><div class="bl"></div><div class="br"></div><div class="b"></div></div>'));a("#content-hover-shadow").hide()})})(jQuery);if(typeof AJS.followCallbacks=="undefined"){AJS.followCallbacks=[]}if(typeof AJS.favouriteCallbacks=="undefined"){AJS.favouriteCallbacks=[]}AJS.toInit(function(a){a(self).bind("hover-user.follow",function(f,d){for(var b=0,c=AJS.followCallbacks.length;b<c;b++){AJS.followCallbacks[b](d.username)}})});
AJS.Labels=(function(e){var k={parse:function(s){var t=[],r=e(s);if(r.is(d.labelItem)){t.push(r[0])}else{r.find(d.labelItem).each(function(){t.push(this)})}return t},contains:function(t){var r=e(t),s=r.text(),w=r.attr(w),u=e(d.labelView).first(),v;v=i()?":contains('"+s+"')":"["+d.idAttribute+"='"+w+"']";return !!u.find(d.labelItem).filter(v).size()},size:function(){return e(d.labelView).first().find(d.labelItem).size()}};var d={labelView:".label-list",labelItem:".label",noLabelsMessage:".no-labels-message",idAttribute:"data-label-id"};var q=Confluence.getContextPath(),o={index:q+"/labels/autocompletelabel.action?maxResults=3",create:q+"/json/addlabelactivity.action",validate:q+"/json/validatelabel.action",destroy:q+"/json/removelabelactivity.action"};var i=function(){return !!document.getElementById("createpageform")};var a=function(){return e(".space-administration").length};var f=0;var n=function(r){var s=b();p();if(r&&r.promise){r.done(function(u,t){AJS.Meta.set("num-labels",k.size());j(t);e("#rte-button-labels").trigger("updateLabel")});r.done(m);r.fail(m);r.done(s);r.fail(s)}return r};var b=function(){var r=e("#labelsString, #add-labels-editor-button");r.addClass("disabled");return function(){r.removeClass("disabled")}};var m=function(){e("#labelsString").val("")};var p=function(r){r=r||null;e("#labelOperationErrorMessage").html(r).toggle(!!r)};var j=function(r){r.each(function(){var u=e(this),t=u.find("li").size(),s=u.siblings(d.noLabelsMessage);s.toggle(!t)})};var l=function(r){if(!r){return false}var t={type:"POST",dataType:"json",data:{}},u,s=e.Deferred();t.url=i()?o.validate:o.create;t.data.entityIdString=AJS.params.pageId;t.data.labelString=r;u=AJS.safe.ajax(t);u.done(function(x){var w=e(d.labelView),v=e(k.parse(x.response));v.each(function(){if(k.contains(this)){return}var z,y=e("<li/>");if(i()){z=f+(new Date().getTime());this.setAttribute(d.idAttribute,z);f++}y.append(this).appendTo(w)});if(!x.success){p(x.response)}s.resolve(v,w)});u.fail(function(x,v,w){AJS.log(w);p(w.message);s.reject(w.message)});i()&&u.done(function(){var v=e("#createPageLabelsString").val();e("#createPageLabelsString").val(v+" "+r)});return s.promise()};var c=function(s){if(!s){return false}s=s.jquery?s:e(s);var w=s.attr(d.idAttribute),r=jQuery.trim(s.text()),v,u={type:"POST",dataType:"json",data:{}},t=e.Deferred();if(i()){v=e.Deferred();v.resolve()}else{if(a()){u.type="GET";u.url=q+"/spaces/removelabelfromspace.action";u.data.key=AJS.Meta.get("space-key");u.data.labelId=w;u.dataType="text"}else{u.url=o.destroy;u.data.entityIdString=AJS.params.pageId;u.data.labelIdString=w}v=AJS.safe.ajax(u)}v.done(function(){var x=e(d.labelItem);x=x.filter("["+d.idAttribute+"='"+w+"']");x.fadeOut("normal",function(){var y=x.closest(d.labelView);x.parent().remove();t.resolve(s,y)})});v.fail(function(z,x,y){console.log(y);p(y.message);t.reject()});i()&&t.done(function(){var x=e("#createPageLabelsString").val();var y=x.split(/\s+/);y=e.grep(y,function(z){return(!z||z==r)},true);e("#createPageLabelsString").val(y.join(" "))});return t.promise()};var g=function(){var w=e("#labelsString"),v=w.parents("#add-labels-form").length;if(!w.length){return}var t=function(x){e("#labelsAutocompleteList").append(x)};var u=function(F){if(F.find("a.label-suggestion").length){var G=e("span",F),C=e.data(G[0],"properties"),E=w.val(),y=[];if(v){y=E.split(/\s+/);y[y.length-1]=C.name;w.val(y.join(" "))}else{var D=AJS.Labels.queryTokens,J=-1,z,A="";for(var B=0,I=D.length;B<I;B++){A=D[B];z=E.lastIndexOf(A);if(z>J){J=z}}if(J!=-1){var H=E.substr(0,J);var x=E.substr(J+A.length).match(/^\s+/);if(x){H+=x[0]}w.val(H+C.name)}else{w.val(C.name)}}}};var r=function(){if(!e("#labelsAutocompleteList .label-suggestion").length){this.hide()}else{if(!v){var z=e("#labelsAutocompleteList a.label-suggestion");for(var x=0,y=z.length;x<y;x++){z.get(x).href="#"}}}};var s="/labels/autocompletelabel.action?maxResults=3";e(window).bind("quicksearch.ajax-success",function(y,x){if(x.url==s){AJS.Labels.queryTokens=(x.json&&x.json.queryTokens)||[];return false}});e(window).bind("quicksearch.ajax-error",function(y,x){if(x.url==s){AJS.Labels.queryTokens=[];return false}});w.quicksearch(s,r,{makeParams:function(x){return{query:x,contentId:AJS.params.pageId||""}},dropdownPlacement:t,ajsDropDownOptions:{selectionHandler:function(y,x){u(x);this.hide();y.preventDefault()}}})};var h=function(r){e("#labels_div").toggleClass("hidden");e("#labels_info").toggleClass("hidden");if(e("#labels_div").hasClass("hidden")){e("#labels_info").html(e("#labelsString").val().toLowerCase());e("#labels_edit_link").html("Edit")}else{e("#labels_edit_link").html("Done")}if(r){r.preventDefault()}};e("#labels_edit_link").live("click",h);e(".label-list.editable a.label").live("click",function(r){r.preventDefault()});e(".label-list.editable .remove-label").live("click",function(r){r.preventDefault();AJS.Labels.removeLabel(this.parentNode)});AJS.toInit(function(){if(a()){AJS.Labels.bindAutocomplete();e(".label-list").addClass("editable")}});return{addLabel:function(r){return n(l(r))},removeLabel:function(r){return n(c(r))},bindAutocomplete:g}})(AJS.$);
AJS.toInit(function(e){var c,f=140;function b(){var m="idontthinksohal";var j=new AJS.Dialog(650,m,"update-user-status-dialog");var l=j.popup.element;var k=e(Confluence.Templates.UserStatus.dialogContent({maxChars:f}));j.addHeader("What are you working on?");j.addPanel("Set Status",k);j.addButton("Update",h,"status-update-button");j.addCancel("Cancel",function(n){n.hide();return false});j.setError=function(n){e(".error-message",l).html(n)};return j}function g(k){var j;if(!k){j="You must enter a status."}else{if(!e.trim(k)){j="Whitespace is cool and all, but you might want to add a message in there, too."}else{if(k.length>f){j=AJS.format("The status message is too long. Status messages must be no longer than {0} characters.",f)}}}if(j){c.setError(j)}return !j}function d(j){e(".current-user-latest-status .status-text").html(j.text);e(".current-user-latest-status a[id^=view]").each(function(){var l=e(this),k=l.attr("href");l.attr("href",k.replace(/\d+$/,j.id)).text(j.friendlyDate).attr("title",new Date(j.date).toLocaleString())})}function i(){e.getJSON(Confluence.getContextPath()+"/status/current.action",function(j){if(j.errorMessage){c.setError(j.errorMessage)}else{d(j)}})}var h=function(){var m=c.popup.element,p=e("#status-text",m),k=e(".status-update-button",m),o=p.val(),j,n;function l(){p.blur();p.attr("disabled","disabled").attr("readonly","readonly");k.attr("disabled","disabled");return function(){p.focus();p.removeAttr("disabled").removeAttr("readonly");k.removeAttr("disabled")}}j=l();if(!g(o)){j();return false}n=AJS.safe.ajax({url:Confluence.getContextPath()+"/status/update.action",type:"POST",dataType:"json",data:{text:o}});n.done(j).fail(j);n.done(function(q){if(q.errorMessage){c.setError(q.errorMessage)}else{d(q);p.val("");m.fadeOut(200,function(){c.hide()})}});n.fail(function(s,r,q){AJS.log("Error updating status: "+r);AJS.log(q);c.setError("There was an error - "+q)});return n.promise()};var a=function(j){var l=j.popup.element,n=e("#status-text",l),m=e(".chars-left",l),k=e(".status-update-button",l);n.keydown(function(o){if(o.keyCode==13){h()}}).bind("blur focus change "+(!e.browser.msie?"paste input":"keyup"),function(){var p=e(this).val(),o=f-p.length;k[p.length?"removeAttr":"attr"]("disabled","disabled");m.text(Math.abs(o)).toggleClass("close-to-limit",o<20).toggleClass("over-limit",o<0)});e("form",l).submit(function(o){o.preventDefault();h()})};e("#set-user-status-link").click(function(k){var j=e(this).parents(".ajs-drop-down")[0];j&&j.hide();if(typeof c=="undefined"){c=b();a(c)}i();c.setError("");c.show();e("#update-user-status-dialog #status-text").removeAttr("readonly").removeAttr("disabled").focus();return AJS.stopEvent(k)})});
// This file was automatically generated from userstatus-dialog.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.UserStatus == 'undefined') { Confluence.Templates.UserStatus = {}; }


Confluence.Templates.UserStatus.dialogContent = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div><span class=\'error-message\'></span></div><form class="aui update-status"><fieldset><label for="status-text" class="assistive">', soy.$$escapeHtml(AJS.format("Enter your status ({0} character limit)",opt_data.maxChars)), '</label><textarea name="status-text" id="status-text"></textarea><span class="chars-left">', soy.$$escapeHtml(opt_data.maxChars), '</span></fieldset><p id="dialog-current-status" class="current-user-latest-status"><strong>', soy.$$escapeHtml("Last update:"), '</strong> <span class="status-text"></span></p></form>');
  if (!opt_sb) return output.toString();
};

var GADGET_DIRECTORY = null;

GadgetDirectory = function() {};
GadgetDirectory.prototype = {
    dlg: null,
    gadget_list: null,

    showDialog: function() {
        //Create the dialog
        this.dlg.addHeader(GADGET_DIRECTORY.translations.header);
        this.dlg.addCancel(GADGET_DIRECTORY.translations.closeButton, function(dlg) {dlg.hide(); return false;});

        AJS.$(".throbber").hide();
        this.dlg.getCurrentPanel().html(this.buildPanel());
    },

    buildPanel: function() {
        return AJS.$("<div/>").addClass("directory-panel").append(this.buildDirectoryHelp()).append(this.buildDirectoryList());
    },

    buildDirectoryHelp: function() {
        var helpPanel = AJS.$("<div/>").addClass("directory-help");
        AJS.$("<h3/>").addClass("directory-help-title").html(GADGET_DIRECTORY.translations.helpTitle1).appendTo(helpPanel);
        AJS.$("<p/>").addClass("directory-help-text").html(GADGET_DIRECTORY.translations.helpBody1).appendTo(helpPanel);
        AJS.$("<h3/>").addClass("directory-help-title").html(GADGET_DIRECTORY.translations.helpTitle2).appendTo(helpPanel);
        AJS.$("<p/>").addClass("directory-help-text").html(GADGET_DIRECTORY.translations.helpBody2).appendTo(helpPanel);
        AJS.$("<p/>").html(GADGET_DIRECTORY.translations.moreInfo).appendTo(helpPanel);
        return helpPanel;
    },

    buildDirectoryList: function() {
        if (!GADGET_DIRECTORY.gadget_list)
            return AJS.$("<div/>").addClass("no-gadgets").html("No gadgets found.");

        var directory_list = AJS.$("<ol/>").addClass("macro-list");
        AJS.$.each(GADGET_DIRECTORY.gadget_list, function(i, gadget_item) {
            var directory_item = AJS.$("<li/>").attr("id", "macro-" + gadget_item.title.split(' ').join('')).addClass("macro-list-item");

            var title = AJS.$("<h3/>").addClass("macro-title").html(gadget_item.title);

            var gadgetUrl = AJS.$("<p/>").append(AJS.$("<span/>").append(AJS.$("<a/>").addClass("macro-uri").attr("href", gadget_item.url).attr("target", "_blank").attr("title", gadget_item.url).html(GADGET_DIRECTORY.translations.gadgetUrl)));
            var author = AJS.$("<p/>").addClass("macro-author");
            if (gadget_item.author) {
                author.html("By " + gadget_item.author);
            } else {
                author.html(GADGET_DIRECTORY.translations.noAuthor);
            }
            var description = AJS.$("<p/>").addClass("macro-desc");
            if (gadget_item.description) {
                description.html(gadget_item.description);
            } else {
                description.html(GADGET_DIRECTORY.translations.noDescription);
            }

            if (gadget_item.thumbnail) {
                var thumbnail = AJS.$("<img/>").addClass("macro-icon").attr({
                       height: 60,
                       width: 120,
                       alt: "",
                       src: gadget_item.thumbnail
                   });
                directory_item.append(thumbnail);
            }
            directory_item.append(title);
            directory_item.append(gadgetUrl);
            directory_item.append(author);
            directory_item.append(description);
            
            directory_list.append(directory_item);
        });

        return directory_list;
    },

    buildThrobber: function() {
        var throbber = AJS.$("<div/>").addClass("throbber");
        Raphael.spinner(throbber[0], 60, "#666");
        return throbber;
    },

    loadDirectory: function() {
        AJS.$(document).keyup(function (e) {
            if (e.keyCode == 27)  {
                GADGET_DIRECTORY.dlg.hide();
                AJS.$(document).unbind("keyup", arguments.callee);
                return AJS.stopEvent(e);
            }
        });
        if (this.dlg) {
            this.dlg.show();
        } else {
            this.dlg = new AJS.Dialog(865, 530, "gadget-directory-dialog");
            this.dlg.addPanel("", "panel1");
            this.dlg.getCurrentPanel().html(this.buildThrobber());
            this.dlg.getCurrentPanel().setPadding(0);
            this.dlg.getCurrentPanel().body.css("overflow", "hidden");
            this.dlg.show();

            AJS.$.ajax({
                    url: contextPath + "/rest/gadget/1.0/published/gadgetsdirectory",
                    type: "GET",
                    dataType: "json",
                    success: function(data) {
                        if (data.directoryList)
                            GADGET_DIRECTORY.gadget_list = data.directoryList;
                        GADGET_DIRECTORY.translations = data.translations;
                        GADGET_DIRECTORY.showDialog();
                    },
                    error: function() {
                        GADGET_DIRECTORY.dlg.getCurrentPanel().html(AJS.$("<div/>").addClass("loading-error").html("An error has occurred while trying to load the gadget directory."));
                    },
                    timeout: 12000
            });
        }
    }
};


AJS.toInit(function ($)
{
    GADGET_DIRECTORY = new GadgetDirectory();
    AJS.$("#gadget-directory-link").click(function (e) {
        GADGET_DIRECTORY.loadDirectory();
        e.preventDefault();
    });
});
function placeFocus(){if(document.location.hash||document.getElementById("editpageform")||document.getElementById("createpageform")||document.getElementById("upload-attachments")||document.getElementById("addcomment")){return}var l="";var a=window.location.search.substring(1);var f=a.split("&");for(var d=0;d<f.length;d++){var m=f[d].split("=")[0];var h=f[d].split("=")[1];if(m=="autofocus"&&(h!=null&&h.length>0)){l="'"+h+"'"}}var c=false;for(var d=0;d<document.forms.length;d++){var k=document.forms[d].elements;if(document.forms[d].id!="quick-search"&&document.forms[d].id!="space-blog-quick-search"&&document.forms[d].name!="inlinecommentform"){for(var b=0;b<k.length;b++){if((k[b].type=="text"||k[b].type=="password"||k[b].type=="textarea")&&!k[b].disabled&&!(k[b].style.display=="none")){try{if(l!=null&&l.length>0){if(k[b].id==l){k[b].focus();c=true;break}}else{k[b].focus();c=true;break}}catch(g){}}}}if(c){break}}}function setCookie(b,g,i,f,h,j,e,a){var d=b+"="+escape(g);if(i){var c=new Date(i,f,h);d+="; expires="+c.toGMTString()}if(j){d+="; path="+escape(j)}else{d+="; path=/"}if(e){d+="; domain="+escape(e)}if(a){d+="; secure"}document.cookie=d}function getCookie(b){var a=document.cookie.match(b+"=(.*?)(;|$)");if(a){return(unescape(a[1]))}else{return null}}function highlight(a){new Effect.Highlight(a,{endcolor:"#f0f0f0"})};
AJS.toInit(function ($) {

    var whatsNewMenuItem = $("#whats-new-menu-link"),
        throbber, iframe, popup, timeoutDiv, killSpinner, timeout,

    /**
     * Called when the user clicks on the "Don't show again checkbox or its label, stores a flag against the user to
     * not auto-show the What's New dialog on first visit of session.
     */
    toggleDontShow = function (e) {
        var isShownForUser = !$(this).attr('checked');
        var url = AJS.Meta.get("context-path") + "/plugins/whatsnew/set.action";
        var data = {
            isShownForUser: isShownForUser
        };
        AJS.log("whatsnew > toggleDontShow > setting isShownForUser to: " + data.isShownForUser);
        AJS.safe.post(url, data, function (data, status) {
            AJS.log("whatsnew > toggleDontShow > isShownForUser set to: " + data.isShownForUser);
        });
    },

    // When the iframe content has loaded a page-loaded.whats-new event will be
    // triggered on the parent frame AJS object. At this point, hide the loading
    // div and display the iframe.
    iframeReadyStateChanged = function () {
        // Load already cancelled
        if (!iframe) return;

        timeout && clearTimeout(timeout);
        hideThrobber();
        AJS.setVisible(iframe, true);
    },

    createDialog = function (isShownForUser) {
        var dialog = new AJS.ConfluenceDialog({
            width: 855,
            height: 545,
            id: "whats-new-dialog",
            onCancel: function () {
                dialog.hide().remove();
                timeout && clearTimeout(timeout);
            }
        });
        // getText and format separately so that js-i18n-transformer will work
        var headingPattern = "What\u2019s New in Confluence {0}";

        var minorVersion =  AJS.Meta.get("version-number").match(/^\d+\.\d+/);
        var header = AJS.format(headingPattern, minorVersion);
        dialog.addHeader(header);
        dialog.addPanel("default", AJS.renderTemplate("whats-new-dialog-panel"));
        dialog.addCancel("Close", function () {
            dialog.hide().remove();
            timeout && clearTimeout(timeout);
            return false;
        });
        popup = dialog.popup.element;

        if (AJS.Meta.get("remote-user")) {
            dialog.page[dialog.curpage].buttonpanel.append(AJS.renderTemplate("whats-new-dialog-tip-panel"));
            popup.find('#dont-show-whats-new').change(toggleDontShow).attr('checked', isShownForUser ? '' : 'checked');
        }

        iframe = popup.find("iframe");

        var src = AJS.Meta.get("whats-new-iframe-src-override");
        if (typeof(src) == "undefined") {
            src = whatsNewMenuItem[0].href;
        }
        iframe[0].src = src;
        iframe.load(iframeReadyStateChanged);

        timeoutDiv = popup.find(".whats-new-timeout");

        return dialog;
    },

    hideThrobber = function () {
        if (killSpinner) {
            killSpinner();
            killSpinner = null;
        }
        throbber.addClass("hidden");
    },

    /**
     * Creates and shows the what's new dialog after checking the user's settings..
     */
    showWhatsNewDialog = function () {
        var url = AJS.Meta.get("context-path") + "/plugins/whatsnew/get.action";
        $.getJSON(url, function (settings) {
            var templateUrl = AJS.Meta.get("static-resource-url-prefix") + "/download/resources/com.atlassian.confluence.whatsnew:whats-new-resources/whats-new.html";
            AJS.loadTemplatesFromUrl(templateUrl, function () {
                createDialog(settings.isShownForUser).show();
                // If the iframe takes too long to load, show a timeout message
                throbber = popup.find(".whats-new-throbber.hidden");
                throbber.removeClass("hidden");
                killSpinner = Raphael.spinner(throbber[0], 80, "#666");

                timeout = setTimeout(function () {
                    iframe = null;
                    hideThrobber();
                    AJS.setVisible(timeoutDiv, true);
                }, 10000);
            });
        });
    };

    // Show the dialog if the user selects the menu item.
    whatsNewMenuItem.click(function (e) {
        e.preventDefault();
        showWhatsNewDialog();
    });

    // If dialog should show automatically on page load, show it now.
    AJS.Meta.getBoolean("show-whats-new") && showWhatsNewDialog();
});

(function(D){D.hotkeys={version:"0.8",specialKeys:{8:"backspace",9:"tab",13:"return",16:"shift",17:"ctrl",18:"alt",19:"pause",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"insert",46:"del",96:"0",97:"1",98:"2",99:"3",100:"4",101:"5",102:"6",103:"7",104:"8",105:"9",106:"*",107:"+",109:"-",110:".",111:"/",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12",144:"numlock",145:"scroll",188:",",190:".",191:"/",224:"meta",219:"[",221:"]"},keypressKeys:["<",">","?"],shiftNums:{"`":"~","1":"!","2":"@","3":"#","4":"$","5":"%","6":"^","7":"&","8":"*","9":"(","0":")","-":"_","=":"+",";":": ","'":'"',",":"<",".":">","/":"?","\\":"|"}};D.each(D.hotkeys.keypressKeys,function(E,F){D.hotkeys.shiftNums[F]=F});function A(E){this.num=0;this.timer=E>0?E:false}A.prototype.val=function(){return this.num};A.prototype.inc=function(){if(this.timer){clearTimeout(this.timeout);this.timeout=setTimeout(D.proxy(A.prototype.reset,this),this.timer)}this.num++};A.prototype.reset=function(){if(this.timer){clearTimeout(this.timeout)}this.num=0};function C(G){if(!(D.isPlainObject(G.data)||D.isArray(G.data)||typeof G.data==="string")){return }var F=G.handler,E={timer:700};(function(H){if(typeof H==="string"){E.combo=[H]}else{if(D.isArray(H)){E.combo=H}else{D.extend(E,H)}}E.combo=D.map(E.combo,function(I){return I.toLowerCase()})})(G.data);G.index=new A(E.timer);G.handler=function(M){if(this!==M.target&&(/textarea|select|input/i.test(M.target.nodeName))){return }var J=M.type!=="keypress"&&D.hotkeys.specialKeys[M.which],N=String.fromCharCode(M.which).toLowerCase(),K,L="",I={};if(M.altKey&&J!=="alt"){L+="alt+"}if(M.ctrlKey&&J!=="ctrl"){L+="ctrl+"}if(M.metaKey&&!M.ctrlKey&&J!=="meta"){L+="meta+"}if(M.shiftKey&&J!=="shift"){L+="shift+"}I[L+(J||N)]=true;if(/shift+/.test(L)){I[L.replace("shift+","")+D.hotkeys.shiftNums[(J||N)]]=true}var H=G.index,O=E.combo;if(B(O[H.val()],I)){if(H.val()===O.length-1){H.reset();return F.apply(this,arguments)}else{H.inc()}}else{H.reset();if(B(O[0],I)){H.inc()}}}}function B(H,F){var I=H.split(" ");for(var G=0,E=I.length;G<E;G++){if(F[I[G]]){return true}}return false}D.each(["keydown","keyup","keypress"],function(){D.event.special[this]={add:C}})})(jQuery);
jQuery(document).bind("iframeAppended",function(B,A){jQuery(A).contents().bind("keydown keypress keyup",function(C){jQuery.event.trigger(C,arguments,document,true)})});AJS.whenIType=function(H){H=jQuery.isArray(H)?H:[H];var D=AJS.I18n?AJS.I18n.getText("keyboard.shortcut.type"):AJS.params.keyType,A=AJS.I18n?AJS.I18n.getText("keyboard.shortcut.then"):AJS.params.keyThen,B=AJS.I18n?AJS.I18n.getText("keyboard.shortcut.or"):AJS.params.keyOr,C=navigator.platform.indexOf("Mac")!=-1;var F,E=function(J){var K=jQuery.grep(J,function(L){return/^[a-z0-9\?]$/i.test(L)}).length===J.length;jQuery(document).bind((K?"keypress":"keydown")+".whenitype",J,function(L){if(F&&!AJS.popup.current&&!AJS.dropDown.current&&!AJS.InlineDialog.current){F(L);L.preventDefault();L.stopImmediatePropagation()}});jQuery(document).bind("keyup.whenitype",J,function(L){L.preventDefault()})},I=function(J){var L=jQuery(J),M=L.attr("title")||"",K=H.slice(0);if(L.data("kbShortcutAppended")){G(L,K,M);return }if(C){K=jQuery.map(K,function(N){N=N.replace(/Meta/i,"\u2318");N=N.replace(/Shift/i,"\u21E7");return N})}M+=" ( "+D+" '"+K.shift()+"'";jQuery.each(K,function(){M+=" "+A+" '"+this+"'"});M+=" )";L.attr("title",M);L.data("kbShortcutAppended",true)},G=function(K,J,L){L=L.replace(/\)$/,B+" ");L+="'"+J.shift()+"'";jQuery.each(J,function(){L+=" "+A+" '"+this+"'"});L+=" )";K.attr("title",L)};E(H);return{moveToNextItem:function(J){F=function(){var L,N=true,K=jQuery(J),M=jQuery(J+".focused");if(!F.blurHandler){jQuery(document).one("keypress.whenitype",function(O){if(O.keyCode===27&&M){M.removeClass("focused")}})}if(M.length===0){N=false;M=jQuery(J).eq(0)}else{M.removeClass("focused");L=jQuery.inArray(M.get(0),K);if(L<K.length-1){L=L+1;M=K.eq(L)}else{M.removeClass("focused");M=jQuery(J).eq(0);N=false}}if(M&&M.length>0){M.addClass("focused");M.moveTo(N);M.find("a:first").focus()}}},moveToPrevItem:function(J){F=function(){var L,N=true,K=jQuery(J),M=jQuery(J+".focused");if(!F.blurHandler){jQuery(document).one("keypress.whenitype",function(O){if(O.keyCode===27&&M){M.removeClass("focused")}})}if(M.length===0){N=false;M=jQuery(J+":last")}else{M.removeClass("focused");L=jQuery.inArray(M.get(0),K);if(L>0){L=L-1;M=K.eq(L)}else{M.removeClass("focused");M=jQuery(J+":last");N=false}}if(M&&M.length>0){M.addClass("focused");M.moveTo(N);M.find("a:first").focus()}}},click:function(J){I(J);F=function(){var K=jQuery(J);if(K.length>0){K.click()}}},goTo:function(J){F=function(){window.location.href=contextPath+J}},evaluate:function(J){J.call(this)},followLink:function(J){I(J);F=function(){var K=jQuery(J);if(K.length>0&&(K.attr("nodeName").toLowerCase()==="a"||K.attr("nodeName").toLowerCase()==="link")){K.click();window.location.href=K.attr("href")}}},execute:function(K){var J=this;F=function(){K.call(J)}},moveToAndClick:function(J){I(J);F=function(){var K=jQuery(J);if(K.length>0){K.click();K.moveTo()}}},moveToAndFocus:function(J){I(J);F=function(L){var K=jQuery(J);if(K.length>0){K.focus();K.moveTo&&K.moveTo();if(K.is(":input")){L.preventDefault()}}}},or:function(J){E(J);return this}}};
AJS.bind("initialize.keyboardshortcuts",function(){var E=AJS.$,B=AJS.Data.get,D=B("context-path")+"/rest/shortcuts/latest/shortcuts/"+B("build-number")+"/"+B("keyboardshortcut-hash"),A=function(F){if(F.keyCode===27&&E(F.target).is(":input")){E(F.target).blur()}},C=navigator.platform.indexOf("Mac")!=-1;E.getJSON(D,function(H){var F=H.shortcuts;if(!F){throw new Error("Server returned no shortcuts.")}AJS.trigger("shortcuts-loaded.keyboardshortcuts",{shortcuts:F});var J={enableContext:function(K){var L;E.each(F,function(O,M){if(M.context!=K){return }var N=M.op,P=M.param;E.each(M.keys,function(){if(N==="execute"||N==="evaluate"){P=Function(P)}L=C?E.map(this,function(Q){return Q.replace(/Ctrl/i,"Meta")}):this;AJS.whenIType(L)[N](P)})})}};var G=function(){E(document).bind("keyup.whenitype",A);E(document).bind("iframeAppended.whenitype",function(L,K){E(K).load(function(){if(K.contentWindow&&K.contentWindow.jQuery){K.contentWindow.jQuery("body").bind("keyup.whenitype",A)}})});AJS.trigger("register-contexts.keyboardshortcuts",{shortcutRegistry:J})};G();AJS.bind("add-bindings.keyboardshortcuts",G);var I=function(){E(document).unbind(".whenitype");E("iframe").each(function(){if(this.contentWindow&&this.contentWindow.jQuery){this.contentWindow.jQuery("body").unbind(".keyboard-shortcuts.whenitype")}})};AJS.bind("remove-bindings.keyboardshortcuts",I)})});
AJS.toInit(function($) {
    AJS.log("confluence-keyboard-shortcuts initialising");

    // CGP-151/CONFDEV-811 - Skip this if you are in the Page Gadget
    if (AJS.PageGadget || (window.parent.AJS && window.parent.AJS.PageGadget)) {
        AJS.log("Inside the Page Gadget. Skipping keyboard shortcuts");
        return;
    }

    Confluence.KeyboardShortcuts.enabled = AJS.Meta.getBoolean('use-keyboard-shortcuts');

    AJS.bind("shortcuts-loaded.keyboardshortcuts", function (e, data) {
        Confluence.KeyboardShortcuts.shortcuts = data.shortcuts;
        $("#keyboard-shortcuts-link").click(Confluence.KeyboardShortcuts.openDialog);
    });

    AJS.bind("register-contexts.keyboardshortcuts", function(e, data){

        // Only bind the shortcuts for contexts if the user has the preference set
        if (!Confluence.KeyboardShortcuts.enabled) {
            return;
        }
        // Here we bind to register-contexts.keyboardshortcuts so that we can select which
        // keyboard shortcut contexts should be enabled. We use jQuery selectors to determine
        // which keyboard shortcut contexts are applicable to a page.

        var shortcutRegistry = data.shortcutRegistry;
        shortcutRegistry.enableContext("global");
        $("#action-menu-link").length && !$("#preview").length && shortcutRegistry.enableContext("viewcontent");
        $("#viewPageLink").length && shortcutRegistry.enableContext("viewinfo");

        if ($("#wysiwyg").length) {
            shortcutRegistry.enableContext("editor");

            // tinymce shortcuts are added through the tinymce apis
            var ed = tinyMCE.activeEditor,
                editorForm = $("#rte").closest("form");

            $.each(Confluence.KeyboardShortcuts.shortcuts, function (i, shortcut) {
                if (shortcut.context.indexOf("tinymce") != 0) return;

                var operation = shortcut.op,
                    param = shortcut.param;
                $.each(shortcut.keys, function () {
                    var shortcutKey = this,
                        shortcutFunc;
                    if (operation == "click") {
                        shortcutFunc = function() { $(param).click(); };
                    }
                    else if (operation == "execute") {
                        shortcutFunc = param;
                    }
                    if (shortcutFunc) {
                        if ($.isArray(shortcutKey)) {
                            shortcutKey = shortcutKey.join(",");
                        }
                        AJS.debug("Adding shortcut for " + shortcutKey);
                        ed.addShortcut(shortcutKey.toLowerCase(), "", shortcutFunc);

                        // CONFDEV-3711: Binds a keydown event to the form input elements to capture the editor
                        // save and preview shortcuts
                        if (shortcut.context == "tinymce.actions" && shortcutKey.indexOf("+") != -1) {
                            AJS.debug("Binding shortcut on inputs too for " + shortcutKey);
                            editorForm.delegate(":input", "keydown", function(event) {
                                var code = (event.keyCode ? event.keyCode : event.which);
                                var shortcutarray = shortcutKey.split("+");
                                // Parses the shortcut and checks if correct keys are present.
                                shortcutarray = $.map(shortcutarray, function(key) {
                                    return (((key == "Ctrl") && (event.metaKey)) || ((key == "Shift") && (event.shiftKey)) || (code == key.charCodeAt(0)) ? null : key);
                                });
                                if (!(shortcutarray.length)) {
                                    shortcutFunc();
                                    event.preventDefault();
                                }
                            });
                        }

                    } else {
                        AJS.log("ERROR: unkown editor shortcut key operation " + operation + " for shortcut " + shortcutKey);
                    }
                });
            });
        }

        Confluence.KeyboardShortcuts.ready = true;
    });

    function initShortcuts() {
        // AKS requires that we load the I18n resources before we ask to initialize the keyboard shortcuts
        AJS.I18n.get(["com.atlassian.confluence.keyboardshortcuts","com.atlassian.plugins.editor"], function() {
            AJS.trigger("initialize.keyboardshortcuts");
        }, function() {
            AJS.log("There was an error loading the keyboard shortcuts, please try again");
        });
    }

    // Why is this if statment needed? It seems that when we are ready to do an import, the pluginsystem is up, and we
    // pull down the super batch. This superbatch contains this code and it fires off a request to Confluence to get the
    // i18n resources. This request gets redirected to 'selectsetupstep.action' which due to the fact that the import is
    // running thinks we are done, and redirects to 'finishsetup.action' and things blow up.
    if (typeof Confluence.getContextPath() != "undefined") {
        if ($("#rte").length) { //If there is an editor on the page wait for it to load before initializing shortcuts
            AJS.bind("init.rte", function() {
                initShortcuts();
            });
        } else {
            initShortcuts();
        }
    }

    //CONFDEV-4913 - Disable shortcuts after we click add comment
    $("#add-comment-menu-link, #add-comment-rte").click(function() {
        AJS.trigger("remove-bindings.keyboardshortcuts");
    });

});

// Add functions that are referenced from the execute shortcut operations in atlassian-plugin.xml here
Confluence.KeyboardShortcuts = {
    Editor: [], // hack for jira issue plugin, remove once the plugin has been updated
    enabled: false,
    ready: false,
    dialog: null,
    closeDialog: function() {
        Confluence.KeyboardShortcuts.getDialog().then(function(dialog) {
            dialog.hide();
        });
        return false;
    },
    openDialog: function() {
        Confluence.KeyboardShortcuts.getDialog().then(function(dialog) {
            dialog.show();
        });
        return false;
    }
};


(function($) {

var popup;

Confluence.KeyboardShortcuts.getDialog = function () {
    var dfr = $.Deferred();

    if (popup) {
        return dfr.resolve(popup);
    }

    var shortcuts = Confluence.KeyboardShortcuts.shortcuts,

    cancel = function() {
        AJS.log("Hiding Shortcuts help");
        popup.hide();
        return false;
    },

    //Same technique as tinyMCE.
    isMac = navigator.platform.indexOf('Mac') != -1,

    //Construct the key sequence diagram shown on the keyboard shortcuts help dialog
    //e.g. shortcut.keys = [["g", "d"]]
    makeKeySequence = function (shortcut) {
        var sequenceSpan = AJS("span").addClass("item-action");
        // TODO - may need "or" in future if keys has length > 1
        var keySequence = shortcut.keys[0];

        for(var i = 0; i < keySequence.length; i++) {
            if(i > 0)
                sequenceSpan.append(makeKbdSeparator("then"));

            makeKeyCombo(keySequence[i], sequenceSpan);
        }

        return sequenceSpan;
    },

    makeKeyCombo = function(combo, sequence) {
        var keys = combo.split("+");

        for (var i = 0; i < keys.length; i++) {
            if (i > 0)
                sequence.append(makeKbdSeparator("+"));

            makeKeyAlternatives(keys[i], sequence);
        }
    },

    makeKeyAlternatives = function(key, sequence) {
        var keys = key.split("..");

        for (var i = 0; i < keys.length; i++) {
            if (i > 0)
                sequence.append(makeKbdSeparator("to"));

            sequence.append(makeKbd(keys[i]));
        }
    },

    makeKbd = function(key) {
        var kbd = AJS("kbd");

        switch (key){
            case "Shift":
            case "Sh":
                kbd.text("Shift");
                kbd.addClass("modifier-key");
                break;
            case "Ctrl":
                var text = isMac ? '\u2318' : "Ctrl";  //Apple command key
                kbd.text(text);
                kbd.addClass("modifier-key");
                break;
            case "Tab":
                kbd.text("Tab");
                kbd.addClass("modifier-key");
                break;
            case "Alt":
                kbd.text("Alt");
                kbd.addClass("modifier-key");
                break;
            default:
                kbd.text(key);
                kbd.addClass("regular-key");
        }

        return kbd;
    },

    makeKbdSeparator = function(text) {
        var separator = AJS("span");
        separator.text(text);
        separator.addClass("key-separator");
        return separator;
    },

    makeShortcutModule = function(title, contexts, shortcuts) {
        var module = $(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutModule({title: title}));
        var list = module.find("ul");

        for (var i = 0; i < shortcuts.length; i++) {
            var shortcut = shortcuts[i];
            if (shortcut.hidden) {
                continue;
            }
            if($.inArray(shortcut.context, contexts) != -1) {
                var shortcutItem = AJS("li").addClass("item-details");
                var desc = AJS("strong").addClass("item-description").append(AJS.I18n.getText(shortcut.descKey));
                shortcutItem.append(desc);
                shortcutItem.append(makeKeySequence(shortcut));
                list.append(shortcutItem);
            }
        }

        return module;
    },

    makeGeneralShortcutsMenu = function() {
        var generalShortcutsMenuPane = $(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutPanel({panelId: "general-shortcuts-panel"}));
        var generalShortcutsMenu = $(generalShortcutsMenuPane).children(".shortcutsmenu");

        if (AJS.Meta.get("remote-user")) {
            generalShortcutsMenuPane.find(".keyboard-shortcut-dialog-panel-header").append(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutEnabledCheckbox());
        }

        generalShortcutsMenu.append(makeShortcutModule("Global Shortcuts", ["global"], shortcuts));
        generalShortcutsMenu.append(makeShortcutModule("Page \/ Blog Post Actions", ["viewcontent", "viewinfo"], shortcuts));

        return generalShortcutsMenuPane;
    },

    makeEditorShortcutsMenu = function() {
        var editorShortcutsMenuPane = $(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutPanel({panelId: "editor-shortcuts-panel"}));
        var editorShortcutsMenu = $(editorShortcutsMenuPane).children(".shortcutsmenu");

        editorShortcutsMenu.append(makeShortcutModule("Block Formatting", ["tinymce.block"], shortcuts));
        editorShortcutsMenu.append(makeShortcutModule("Rich Formatting", ["tinymce.rich"], shortcuts));
        editorShortcutsMenu.append(makeShortcutModule("Editing Actions", ["tinymce.actions"], shortcuts));

        return editorShortcutsMenuPane;
    },

    toggleEnabled = function (event) {
        var enable = $(this).attr('checked');
        // TODO - after 3.4-m4 and blitz - error handling architecture
        AJS.$.post(Confluence.getContextPath() + "/rest/confluenceshortcuts/latest/enabled", {enabled: enable}, function(){
            Confluence.KeyboardShortcuts.enabled = enable;
            Confluence.KeyboardShortcuts.ready = false;
            if (enable) {
                AJS.trigger("add-bindings.keyboardshortcuts");
            } else {
                AJS.trigger("remove-bindings.keyboardshortcuts");
            }
        });
    },

    initialiseEnableShortcutsCheckbox = function () {
        $('#keyboard-shortcut-enabled-checkbox')
            .attr('checked', Confluence.KeyboardShortcuts.enabled)
            .click(toggleEnabled);
    };

    popup = AJS.ConfluenceDialog({
        width: 950,
        height: 590,
        id: "keyboard-shortcuts-dialog"
    });

    popup.addHeader("Keyboard Shortcuts");
    popup.addPanel("General", makeGeneralShortcutsMenu());
    popup.addPanel("Editor", makeEditorShortcutsMenu());
    popup.addCancel("Close", cancel);
    popup.popup.element.find(".dialog-title").append(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutHelpLink());
    AJS.trigger("keyboard-shortcut-dialog-ready", popup);

    // If you have an editor active, automatically open the Editor tab.
    if (typeof(tinyMCE) != "undefined" && tinyMCE.activeEditor) {
        popup.overrideLastTab();
        popup.gotoPanel(1);
    } else {
        popup.gotoPanel(0);
    }

    dfr.resolve(popup);
    initialiseEnableShortcutsCheckbox();
    return dfr;
};

}(AJS.$));

/*
Adds the "Editor Autoformatting" tab to the Keyboard Shortcuts help dialog
 */
AJS.toInit(function($) {
    var templates = Confluence.Templates.KeyboardShortcutsDialog.Autoformat,

    buildShortcutModule = function(title, context, itemBuilder) {
        var module = $(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutModule({title: title})),
        list = module.find("ul"),
        items = getMenuItemsForContext(context);

        for (var i = 0, ii = items.length; i < ii; i++) {
            list.append (
                itemBuilder(items[i])
            );
        }

        return module;       
    },

    buildStandardShortcutModule = function(title, context, itemTemplate) {
        return buildShortcutModule(
                title,
                context,
                function (item) {
                    return itemTemplate({output: item.description, type: item.action});
                }
        );
    },

    buildEmoticonModule = function(title, context) {
        var emoticonResourceUrl = AJS.params.staticResourceUrlPrefix + "/images/icons/emoticons/";
        return buildShortcutModule(
                title,
                context,
                function (item) {
                    return templates.emoticonHelpItem(
                            {src: emoticonResourceUrl + item.img, type: item.action}
                    );
                }
        );
    },

    getMenuItemsForContext = function(context) {
        return $.grep(Confluence.KeyboardShortcuts.Autoformat, function(e) {
            return e.context == context;
        });
    },

    buildHelpPanel = function() {
        var autoformatHelpPanel = $(Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutPanel({panelId: 'autoformat-shortcuts-panel'})),
        autoformatHelpPanelMenu = autoformatHelpPanel.children(".shortcutsmenu");

        autoformatHelpPanelMenu.append(
                buildStandardShortcutModule(
                        "Font Formatting",
                        "autoformat.font_formatting",
                        templates.simpleHelpItem
                )
        );
        autoformatHelpPanelMenu.append(
                buildStandardShortcutModule("Autocomplete",
                        "autoformat.autocomplete",
                        templates.keyboardShortcutItem
                )
        );
        autoformatHelpPanelMenu.append(
                buildStandardShortcutModule(
                        "Tables",
                        "autoformat.tables",
                        templates.tableHelpItem
                )
        );
        autoformatHelpPanelMenu.append(
                buildStandardShortcutModule(
                        "Styles",
                        "autoformat.styles",
                        templates.styleHelpItem
                ).addClass("styles-module")
        );
        autoformatHelpPanelMenu.append(
                buildEmoticonModule(
                        "Emoticons",
                        "autoformat.emoticons"
                )
        );
        autoformatHelpPanelMenu.append(
                buildStandardShortcutModule(
                        "Lists",
                        "autoformat.lists",
                        templates.simpleHelpItem
                )
        );

        if (AJS.Meta.get("remote-user"))
        {
            autoformatHelpPanel.find(".keyboard-shortcut-dialog-panel-header").append(
                templates.configureAutocomplete(
                        {href: Confluence.getContextPath() + "/users/viewmyeditorsettings.action"}
                )
            );
        }

        return autoformatHelpPanel;
    };

    AJS.bind("keyboard-shortcut-dialog-ready", function(e, popup) {
        popup.addPanel("Editor Autoformatting", buildHelpPanel());
    });

    Confluence.KeyboardShortcuts.Autoformat = [
        {
            context: "autoformat.font_formatting",
            description: templates.boldDescription(),
            action: "*Bold*"
        },
        {
            context: "autoformat.font_formatting",
            description: templates.underlineDescription(),
            action: "+Underline+"
        },
        {
            context: "autoformat.font_formatting",
            description: templates.italicDescription(),
            action: "_Italic_"
        },
        {
            context: "autoformat.font_formatting",
            description: templates.monospaceDescription(),
            action: "{{Monospace}}"
        },
        {
            context: "autoformat.tables",
            description: templates.tableDescription(),
            action: "||||| + enter"
        },
        {
            context: "autoformat.tables",
            description: templates.tableWithHeadingsDiscriptions(),
            action: "||heading||heading||"
        },
        {
            context: "autoformat.styles",
            description: templates.h1Description(),
            action: "h1. Heading"
        },
        {
            context: "autoformat.styles",
            description: templates.h3Description(),
            action: "h3. Heading"
        },
        {
            context: "autoformat.styles",
            description: templates.bqDescription(),
            action: "bq. Quote"
        },
        {
            context: "autoformat.emoticons",
            img: "check.png",
            action: "(\/)"
        },
        {
            context: "autoformat.emoticons",
            img: "smile.png",
            action: ":)"
        },
        {
            context: "autoformat.lists",
            description: templates.numberedListDescription(),
            action: "# list"
        },
        {
            context: "autoformat.lists",
            description: templates.bulletedListDescription(),
            action: "* bullets"
        },
        {
            context: "autoformat.autocomplete",
            description: "Image\/Media",
            action: "!"
        },
        {
            context: "autoformat.autocomplete",
            description: "Link",
            action: "["
        },
        {
            context: "autoformat.autocomplete",
            description: "Macro",
            action: "{"
        }
    ];
});
// This file was automatically generated from shortcut-dialog-tab-autoformat.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.KeyboardShortcutsDialog == 'undefined') { Confluence.Templates.KeyboardShortcutsDialog = {}; }
if (typeof Confluence.Templates.KeyboardShortcutsDialog.Autoformat == 'undefined') { Confluence.Templates.KeyboardShortcutsDialog.Autoformat = {}; }


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.configureAutocomplete = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div id="keyboard-shortcut-autocomplete-message">', soy.$$escapeHtml("To configure Autocomplete,"), ' <a target="_blank" href=', soy.$$escapeHtml(opt_data.href), '>', soy.$$escapeHtml("go to your editor settings"), '</a></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.helpItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<li class="item-details"><span class="item-description wiki-content">', opt_data.output, '</span><span class="', opt_data.actionClass, ' item-action">', opt_data.type, '</span></li>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.simpleHelpItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.KeyboardShortcutsDialog.Autoformat.helpItem({output: opt_data.output, type: '<code>' + opt_data.type + '</code>', actionClass: ''}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.tableHelpItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.KeyboardShortcutsDialog.Autoformat.helpItem({output: opt_data.output, type: '<code>' + opt_data.type + '</code>', actionClass: 'table-action'}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.styleHelpItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.KeyboardShortcutsDialog.Autoformat.helpItem({output: opt_data.output, type: '<code>' + opt_data.type + '</code>', actionClass: 'style-action'}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.keyboardShortcutItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.KeyboardShortcutsDialog.Autoformat.helpItem({output: soy.$$escapeHtml(opt_data.output), type: '<kbd class="regular-key">' + soy.$$escapeHtml(opt_data.type) + '</kbd>', actionClass: ''}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.emoticonHelpItem = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  Confluence.Templates.KeyboardShortcutsDialog.Autoformat.simpleHelpItem({output: '<img src=' + soy.$$escapeHtml(opt_data.src) + '></img>', type: opt_data.type}, output);
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.boldDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<b>', soy.$$escapeHtml("Bold"), '</b> ', soy.$$escapeHtml("text"));
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.underlineDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<span style="text-decoration: underline;">', soy.$$escapeHtml("Underline"), '</span> ', soy.$$escapeHtml("text"));
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.italicDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<em>', soy.$$escapeHtml("Italic"), '</em> ', soy.$$escapeHtml("text"));
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.monospaceDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<code>', soy.$$escapeHtml("Monospace"), '</code> ', soy.$$escapeHtml("text"));
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.tableDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<table class="confluenceTable"><tbody><tr><td class="confluenceTd">', soy.$$escapeHtml("first cell"), '</td><td class="confluenceTd">&nbsp;</td><td class="confluenceTd">&nbsp;</td><td class="confluenceTd">&nbsp;</td></tr></tbody></table>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.tableWithHeadingsDiscriptions = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<table class="confluenceTable"><tbody><tr><th class="confluenceTh">', soy.$$escapeHtml("heading"), '</th><th class="confluenceTh">', soy.$$escapeHtml("heading"), '</th></tr><tr><td class="confluenceTd">&#8203;</td><td class="confluenceTd">&#8203;</td></tr></tbody></table>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.h1Description = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<h1>', soy.$$escapeHtml("Heading"), '</h1>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.h3Description = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<h3>', soy.$$escapeHtml("Heading"), '</h3>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.bqDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<blockquote>', soy.$$escapeHtml("Quote"), '</blockquote>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.numberedListDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<ol><li>', soy.$$escapeHtml("list"), '</li></ol>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.Autoformat.bulletedListDescription = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<ul><li>', soy.$$escapeHtml("bullets"), '</li></ul>');
  if (!opt_sb) return output.toString();
};

// This file was automatically generated from help-dialog.soy.
// Please don't edit this file by hand.

if (typeof Confluence == 'undefined') { var Confluence = {}; }
if (typeof Confluence.Templates == 'undefined') { Confluence.Templates = {}; }
if (typeof Confluence.Templates.KeyboardShortcutsDialog == 'undefined') { Confluence.Templates.KeyboardShortcutsDialog = {}; }


Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutModule = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="module"><div class="mod-header"><h3>', soy.$$escapeHtml(opt_data.title), '</h3></div><div class="mod-content"><ul class="mod-item"></ul></div></div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutHelpLink = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div class="dialog-help-link">');
  Confluence.Templates.Dialog.customHelpLink({href: soy.$$escapeHtml("http://docs.atlassian.com/confluence/docs-41/Keyboard+Shortcuts"), text: soy.$$escapeHtml("View All Shortcuts")}, output);
  output.append('</div>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutEnabledCheckbox = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<form name="shortcut-settings" id="shortcut-settings-form"><input type="checkbox" name="enabled" id="keyboard-shortcut-enabled-checkbox"><label for="keyboard-shortcut-enabled-checkbox">', soy.$$escapeHtml("Enable General Shortcuts"), '</label></form>');
  if (!opt_sb) return output.toString();
};


Confluence.Templates.KeyboardShortcutsDialog.keyboardShortcutPanel = function(opt_data, opt_sb) {
  var output = opt_sb || new soy.StringBuilder();
  output.append('<div id=', soy.$$escapeHtml(opt_data.panelId), '><div class="keyboard-shortcut-dialog-panel-header"></div><div class="shortcutsmenu"></div><div class="keyboard-shortcut-dialog-panel-footer"></div></div>');
  if (!opt_sb) return output.toString();
};

