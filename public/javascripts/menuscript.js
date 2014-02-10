/*horizontal menu */
function horizontalHover(id) {
	var cssRule;
	var newSelector;
	for (var i = 0; i < document.styleSheets.length; i++){
		if(document.styleSheets[i].rules){
		for (var x = 0; x < document.styleSheets[i].rules.length ; x++)
			{
			cssRule = document.styleSheets[i].rules[x];
			if (cssRule.selectorText.indexOf("LI:hover") != -1)
			{
				 newSelector = cssRule.selectorText.replace(/LI:hover/gi, "LI.iehover");
				document.styleSheets[i].addRule(newSelector , cssRule.style.cssText);
			}
		}
		}
	}	
	if(document.getElementById(id)){
	var getElm = document.getElementById(id).getElementsByTagName("LI");
	for (var i=0; i<getElm.length; i++) {
		getElm[i].onmouseover=function() {
			this.className+=" iehover";
		}
		getElm[i].onmouseout=function() {
			this.className=this.className.replace(new RegExp(" iehover\\b"), "");
		}
	}
	}
}
/*horizontal menu*/

/*vertical menu*/
var menu=[];
function init(id,index) {
	menu[index]=id;
	if (document.getElementById && document.getElementsByTagName) {
		if(document.getElementById(id)){
		var myMenu = document.getElementById(id).getElementsByTagName("A");
		if (!myMenu) { return; }
		else {
			for (var i=0;i<myMenu.length;i++) {
				myMenu[i].onmouseover = navHoverStyle;
				myMenu[i].onfocus = navHoverStyle;
			}
			document.getElementById(id).style.visibility = "visible";
		}
		}
	}
}

// Stores the currently open UL objects
var openMenus = new Array();

// Stores the timer for closing the menu
var navTimer;

function navHoverStyle(e) {
	if (!e) var e = window.event;
	if (e.target) var tg = e.target;
	else if (e.srcElement) var tg = e.srcElement;

	var linkElm = tg;
	while (linkElm.nodeName != 'A')
		linkElm.parentNode;

	while (tg.nodeName != 'LI')
		tg = tg.parentNode;

	// Determine if and if so, which submenu items to close
	var tgParent = tg.parentNode;
	while (tgParent.nodeName != 'UL')
		tgParent = tgParent.parentNode;
	var found=false;	
	for(var i=0;i<menu.length;i++){
		if(menu[i]==tgParent.id)found=true;
	}
	if (found) {
		closeAll(0);
	}
	else {
		var j=0;
		while (openMenus[j] != tgParent) {
			j++;
		}
		closeAll(j+1);
	}

	// Determine if the current item has a submenu and if so, open it
	for ( var i=0;i<tg.childNodes.length;i++) {
		if ( tg.childNodes[i].nodeName == 'UL') {
			var subMenuElm = tg.childNodes[i];
		}
	}

	if (subMenuElm) {
		linkElm.className = 'unfolded';
		subMenuElm.style.display = 'block';
		openMenus.push(subMenuElm);
	}

	// Set the timer
	checkNavTimer();

	return false;
}

function checkNavTimer() {
	if (navTimer) clearTimeout(navTimer);
	navTimer = setTimeout('closeAll(0)',5000);
}

function closeAll(lvl) {
	var oMl = openMenus.length-1;
	for ( var i=oMl;i>=lvl;i--) {
		var linkElm = openMenus[i].previousSibling;
		while (linkElm.nodeName != 'A')
			linkElm = linkElm.previousSibling;

		linkElm.className = '';
		openMenus[i].style.display = 'none';
		openMenus.pop();
	}
}
/*vertical menu*/
var SLIDETIMER = 2;
var SLIDESPEED = 1;
var STARTINGOPACITY = 100;
var subsection;
var TIMER;
var WAITTIME;
// handles section to section scrolling of the content //
function slideContent(id,prefix,timer,slidetimer1,slidespeed1,waittime) {
  var div = document.getElementById(id);
  var slider = div.parentNode;
  clearInterval(slider.timer);
  slider.section = parseInt(id.replace(/\D/g,''));
  slider.target = div.offsetTop;
  slider.style.top = slider.style.top || '0px';
  slider.current = slider.style.top.replace('px','');
  slider.direction = (Math.abs(slider.current) > slider.target) ? 1 : -1;
  //slider.style.opacity = STARTINGOPACITY * .01;
  slider.style.filter = 'alpha(opacity=' + STARTINGOPACITY + ')';
  slider.timer = setInterval( function() { slideAnimate(slider,prefix,timer,slidetimer1,slidespeed1,waittime) }, SLIDETIMER);
}

function slideAnimate(slider,prefix,timer,slidetimer1,slidespeed1,waittime) {
  var curr = Math.abs(slider.current);
  var tar = Math.abs(slider.target);
  var dir = slider.direction;
  if((tar - curr <= SLIDESPEED ) || (curr - tar <= SLIDESPEED && dir == 1)) {
    slider.style.top = (slider.target * -1) + 'px';
	slider.style.opacity = 1;
	slider.style.filter = 'alpha(opacity=100)';
    clearInterval(slider.timer);
	if(slider.autoscroll) {
	  setTimeout( function() { autoScroll(slider.id,prefix,timer,slider.autoscroll,slidetimer1,slidespeed1,waittime) }, timer * waittime);
	}
  } else {
	var pos = (dir == 1) ? parseInt(slider.current) + SLIDESPEED : slider.current - SLIDESPEED;
    slider.current = pos;
    slider.style.top = pos + 'px';
  }
}
// initiate auto scrolling //
function autoScroll(id,prefix,timer,restart,slidetimer1,slidespeed1,waittime) {
SLIDETIMER = slidetimer1;
SLIDESPEED = slidespeed1;
TIMER=timer;
WAITTIME=waittime;
  var div = document.getElementById(id);
  div.autoscroll = (!div.autoscroll && !restart) ? false : true;
  div.rel=prefix;
  div.onmouseover = cancelAutoScroll; 
   div.onmouseout = resumeAutoScroll; 
  if(div.autoscroll) {
    var sections = div.getElementsByTagName('div');
    var length = sections.length;
    div.section = (div.section && div.section < length) ? div.section + 1 : 1;
    slideContent(prefix + '-' + div.section,prefix,timer,slidetimer1,slidespeed1,waittime);
  } 	
}
function cancelAutoScroll() {
  this.autoscroll = false;
  clearTimeout(this.timer);
 
}
function resumeAutoScroll() {
  autoScroll(this.id,this.rel,TIMER,true,SLIDETIMER,SLIDESPEED,WAITTIME);
}
