var DDBT_HOST="{{DDBT_HOST}}";var LOCATION_HOST=location.hostname.replace("www.","");var DDBT_COOKIE_NAME="ddbt_uid";var TAGS_COOKIE_NAME="ddbt_tags";var DDBT_UID=null;var DDBT_TAGS=null;var DDBT_CLIENT={};var AD_QUERY_NAME="ad";var QUERY={};if(document.cookie){var cookies=document.cookie.split("; ");for(var i=0;i<cookies.length;i++){var str=cookies[i].split("=");if(str[0]==DDBT_COOKIE_NAME){DDBT_UID=unescape(str[1])}if(str[0]==TAGS_COOKIE_NAME){DDBT_TAGS=unescape(str[1])}}}QUERY=function(){var e={};var t=location.search.substring(1).split("&");for(var n=0;n<t.length;n++){var r=t[n].search(/=/);var i="";if(r!=-1)i=t[n].slice(0,r);var s=t[n].slice(t[n].indexOf("=",0)+1);if(i!="")e[i]=decodeURI(s)}return e}();DDBT_CLIENT=function(e){this.name=e.replace(/^www./,"")||"none";this.tags=[];if(DDBT_TAGS){this.tags=DDBT_TAGS.split(",")}this.DDBT_UID=DDBT_UID?DDBT_UID:this.createStringKey();this.DDBT_HOST=DDBT_HOST;if(this.name.indexOf("localhost")>-1||this.name.indexOf("192.168")>-1||this.name.indexOf("0.0.0.0")>-1){this.DDBT_HOST="localhost:3000"}this.ua=window.navigator.userAgent;this.connection=document.createElement("img");if(QUERY[AD_QUERY_NAME]){this.addTag(QUERY[AD_QUERY_NAME])}this.connection.src=this.getParseURL();this.initializer()};DDBT_CLIENT.prototype.initializer=function(){var e=this;try{e.render()}catch(t){setTimeout(function(){e.initializer()},50)}};DDBT_CLIENT.prototype.render=function(){var e=document.body||document.getElementsByTagName("body")[0];e.appendChild(this.connection)};DDBT_CLIENT.prototype.getParseURL=function(e){var t="?tm="+(new Date).getTime()+"&name="+encodeURIComponent(this.name)+"&uid="+this.DDBT_UID+"&path="+location.pathname;if(0<this.tags.length){t+="&tags="+this.tags.join()}if(e){for(var n=0;n<e.length;n++){t+="&"+encodeURIComponent(e[n]["key"])+"="+encodeURIComponent(e[n]["val"])}}return"http://"+this.DDBT_HOST+"/ddbt.gif"+t};DDBT_CLIENT.prototype.createStringKey=function(){var e="",t=("abcdefghijklmnopqrstuvwxyz"+"ABCDEFGHIJKLMNOPQRSTUVWXYZ"+"0123456789").split(""),n=0;while(n<24){e+=t[Math.floor(Math.random()*t.length)];n++}document.cookie=DDBT_COOKIE_NAME+"="+escape(e)+"; expires="+(new Date((new Date).getTime()+36e5*24*600)).toGMTString()+"; domain=."+LOCATION_HOST+"; path=/";this.addTag("first");return e};DDBT_CLIENT.prototype.getUid=function(){return this.DDBT_UID};DDBT_CLIENT.prototype.eventTrack=function(e){var t=[{key:"action",val:e}];this.connection.src=this.getParseURL(t)};DDBT_CLIENT.prototype.addLabel=function(e){var t=[{key:"label",val:e}];this.connection.src=this.getParseURL(t)};DDBT_CLIENT.prototype.addTag=function(e){this.tags.push(e);document.cookie=TAGS_COOKIE_NAME+"="+this.tags.join()}