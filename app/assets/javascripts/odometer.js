//============================================================================//
//  Gavin Brock's CSS/JavaScript Animated Odometer
//  Version 1.0 - April 7th 2008
//============================================================================//
//  Copyright (C) 2008 Gavin Brock
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//============================================================================//

function Odometer (parentDiv,opts) {
    if (!parentDiv) throw "ERROR: Odometer object must be past a document element.";

    this.digits       = 6;
    this.tenths       = 0;
    this.digitHeight  = 40;
    this.digitPadding = 0;
    this.digitWidth   = 30;
    this.bustedness   = 2;
    this.fontStyle    = "font-family: Courier New, Courier, monospace; font-weight: 900;";
    this.value        = -1;

    for (var key in opts) { this[key] = opts[key]; }

    var style = {
        digits:        "position:absolute; height:"+this.digitHeight+"px; width:"+(this.digitWidth-(2*this.digitPadding))+"px; "+
                       "padding:"+this.digitPadding+"px; font-size:"+(this.digitHeight-(2*this.digitPadding))+"px; "+
                       "background:black; color:white; text-align:center; "+this.fontStyle,
        columns:       "position:relative; float:left; overflow:hidden;"+
                       "height:"+this.digitHeight+"px; width:"+this.digitWidth+"px;",
        highlight:     "position:absolute; background:white; opacity:0.25; filter:alpha(opacity=25); width:100%; left:0px;",
        lowlight:      "position:absolute; background:black; opacity:0.25; filter:alpha(opacity=25); width:100%; left:0px;",
        sidehighlight: "position:absolute; background:white; opacity:0.50; filter:alpha(opacity=50); height:100%; top:0px;",
        sidelowlight:  "position:absolute; background:black; opacity:0.50; filter:alpha(opacity=50); height:100%; top:0px;"
    };

    var highlights = [
        "top:20%;   height:32%;" + style.highlight,
        "top:27.5%; height:16%;" + style.highlight,
        "top:32.5%; height:6%;"  + style.highlight,
        "right:0%;  width:6%;"   + style.sidelowlight,
        "left:0%;   width:4%;"   + style.sidehighlight,
        "top:0%;    height:14%;" + style.lowlight,
        "bottom:0%; height:25%;" + style.lowlight,
        "bottom:0%; height:8%;"  + style.lowlight
    ];

    this.setDigitValue = function (digit, val, frac) {
	var di = digitInfo[digit];
       	var px = Math.floor(this.digitHeight * frac);
	px = px + di.offset;
	if (val != di.last_val) {
		var tmp = di.digitA;
		di.digitA = di.digitB;
		di.digitB = tmp;
        	di.digitA.innerHTML = val;
        	di.digitB.innerHTML = (1+Number(val)) % 10;
		di.last_val = val;
	}
	if (px != di.last_px) {
        	di.digitA.style.top = (0-px)+"px";
        	di.digitB.style.top = (0-px+this.digitHeight)+"px";
		di.last_px = px;
	}
    };


    this.set = function (inVal) {
        if (inVal < 0) throw "ERROR: Odometer value cannot be negative.";
	this.value = inVal;
	if (this.tenths) inVal = inVal * 10;
        var numb = Math.floor(inVal);
        var frac = inVal - numb;
	numb = String(numb);
        for (var i=0; i < this.digits; i++) {
            var num = numb.substring(numb.length-i-1, numb.length-i) || 0;
            this.setDigitValue(this.digits-i-1, num, frac);
            if (num != 9) frac = 0;
        }
    };

    this.get = function () {
        return(this.value);
    };


    var odometerDiv = document.createElement("div")
    odometerDiv.setAttribute("id","odometer");
    odometerDiv.style.cssText="text-align: left";
    parentDiv.appendChild(odometerDiv);

    var digitInfo = new Array();
    for (var i=0; i < this.digits; i++) {
        var digitDivA = document.createElement("div");
        digitDivA.setAttribute("id","odometer_digit_"+i+"a");
        digitDivA.style.cssText=style.digits;

        var digitDivB = document.createElement("div");
        digitDivB.setAttribute("id","odometer_digit_"+i+"b");
        digitDivB.style.cssText = style.digits;

        var digitColDiv = document.createElement("div");
        digitColDiv.style.cssText = style.columns;

        digitColDiv.appendChild(digitDivB);
        digitColDiv.appendChild(digitDivA);

        for (var j in highlights) {
            var hdiv = document.createElement("div");
            hdiv.innerHTML="<p></p>"; // For Dumb IE
            hdiv.style.cssText = highlights[j];
            digitColDiv.appendChild(hdiv);
        }
        odometerDiv.appendChild(digitColDiv);
	var offset = Math.floor(Math.random()*this.bustedness);
	digitInfo.push({digitA:digitDivA, digitB:digitDivB, last_val:-1, last_px: -1, offset:offset});
    };


    if (this.tenths) {
	digitInfo[this.digits - 1].digitA.style.background = "#cccccc";
	digitInfo[this.digits - 1].digitB.style.background = "#cccccc";
	digitInfo[this.digits - 1].digitA.style.color = "#000000";
	digitInfo[this.digits - 1].digitB.style.color = "#000000";
    }

    if (this.value >= 0) this.set(this.value);
}

