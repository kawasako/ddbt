var DDBT_HOST = "{{DDBT_HOST}}";
var LOCATION_HOST = location.hostname.replace("www.", "");
var DDBT_COOKIE_NAME = "ddbt_uid";
var TAGS_COOKIE_NAME = "ddbt_tags";
var DDBT_UID = null;
var DDBT_TAGS = null;
var DDBT_CLIENT = {};
var AD_QUERY_NAME = "ad";
var QUERY = {};

// get ddbt cookie
if (document.cookie) {
  var cookies = document.cookie.split("; ");
  for (var i = 0; i < cookies.length; i++) {
    var str = cookies[i].split("=");
    if (str[0] == DDBT_COOKIE_NAME) { DDBT_UID = unescape(str[1]); }
    if (str[0] == TAGS_COOKIE_NAME) { DDBT_TAGS = unescape(str[1]); }
  }
}

// get query string
QUERY = function(){
  var vars = {};
  var param = location.search.substring(1).split('&');
  for(var i = 0; i < param.length; i++) {
    var keySearch = param[i].search(/=/);
    var key = '';
    if(keySearch != -1) key = param[i].slice(0, keySearch);
    var val = param[i].slice(param[i].indexOf('=', 0) + 1);
    if(key != '') vars[key] = decodeURI(val);
  }
  return vars;
}();

// Constructor
DDBT_CLIENT = function(name) {
  this.name = name.replace(/^www./,"") || "none";
  this.tags = [];
  if(DDBT_TAGS) { this.tags = DDBT_TAGS.split(","); }
  this.DDBT_UID = DDBT_UID ? DDBT_UID : this.createStringKey();
  this.DDBT_HOST = DDBT_HOST;
  if (this.name.indexOf("localhost") > -1 || this.name.indexOf("192.168") > -1 || this.name.indexOf("0.0.0.0") > -1){ this.DDBT_HOST = "localhost:3000"; }
  this.ua = window.navigator.userAgent;
  this.connection = document.createElement("img");
  if (QUERY[AD_QUERY_NAME]){ this.addTag(QUERY[AD_QUERY_NAME]); } // ad query support
  this.connection.src = this.getParseURL();
  this.initializer();
};

// ========================================== CORE ==========================================

// DOM initializer
DDBT_CLIENT.prototype.initializer = function() {
  var _this = this;
  try {
    _this.render();
  }catch(err){
    setTimeout(function(){
      _this.initializer();
    },50);
  }
};

// DOM render
DDBT_CLIENT.prototype.render = function() {
  var bodyNode = document.body || document.getElementsByTagName('body')[0];
  bodyNode.appendChild(this.connection);
};

// URL parser
DDBT_CLIENT.prototype.getParseURL = function(data) {
  var query = "?tm=" + new Date().getTime() + "&name=" + encodeURIComponent(this.name) + "&uid=" + this.DDBT_UID + "&path=" + location.pathname;
  if(0<this.tags.length){ query +=  "&tags=" + this.tags.join(); }
  if(data) { for(var i=0;i<data.length;i++) { query += "&" + encodeURIComponent(data[i]["key"]) + "=" + encodeURIComponent(data[i]["val"]); } }
  return "http://" + this.DDBT_HOST + "/ddbt.gif" + query; // ssl not support
};

// Create key
DDBT_CLIENT.prototype.createStringKey = function() {
  var uid = "", a = ("abcdefghijklmnopqrstuvwxyz" + "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789").split(""), i = 0;
  while (i < 24) { uid += a[Math.floor(Math.random() * a.length)]; i++; }
  document.cookie = DDBT_COOKIE_NAME + "=" + escape(uid) + "; expires=" + new Date( new Date().getTime() + (3600000 * 24 * 600)).toGMTString() + "; domain=."+ LOCATION_HOST +"; path=/";
  this.addTag("first");
  return uid;
};

// ========================================== API ==========================================

// get id
DDBT_CLIENT.prototype.getUid = function() {
  return this.DDBT_UID;
};

// event tracking
DDBT_CLIENT.prototype.eventTrack = function(action){
  var data = [{ key: "action", val: action }];
  this.connection.src = this.getParseURL(data);
};

// add Label
DDBT_CLIENT.prototype.addLabel = function(label){
  var data = [{ key: "label", val: label }];
  this.connection.src = this.getParseURL(data);
};

// add Tag
DDBT_CLIENT.prototype.addTag = function(tag){
  this.tags.push(tag);
  // this.tags = this.tags.filter(function (x, i, self) { return self.indexOf(x) === i; });
  document.cookie = TAGS_COOKIE_NAME + "=" + this.tags.join();
};

