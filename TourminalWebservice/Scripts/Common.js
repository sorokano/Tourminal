function showRecaptcha(element) {
    Recaptcha.create("6LclSMsSAAAAANOv78MwT4Vg4KJ0-OqWULhFWn3L",
    element, {
        theme: "clean",
        callback: Recaptcha.focus_response_field
    });
}
var citiesEng = ["New Delhi/India/9/Индия", "Bombay/India/9/Индия", "Caracas/Venezuela/3/Венесуэла", "Rayong/Thailand/10/Тайланд", "Lima/Peru/6/Перу", "Phnom-Penh/Cambodia/11/Камбоджа", "Nairobi/Kenya/14/Кения", "Quito/Ecuador/5/Эквадор", "Jakarta/Indonesia/12/Индонезия"];
var citiesRus = ["Нью Дели", "Бомбей", "Каракас", "Бангкок", "Лима", "Пномпень", "Найроби", "Кито", "Джакарта"];
var cityDescrs = [
    "2/За последние 50 лет Венесуэльские красавицы выиграли больше конкурсов красоты, чем жительницы любой другой страны/head1.png"
    , "0/Распространенная закуска «чаат» представляет собой небольшие пирожки из слоеного теста, которые жарят во фритюре/head2.png"
    , "4/Цивилизация Инков в 1200 веке до н.э.в городе Куско, на юге Перу. Инки жили в Перу до 1533 года/head3.png"
    , "7/В Эквадоре не бывает зимней резины и нет сети McDonalds/head4.png"
]

function GetCityEngByIndex(index) {
    return citiesEng[index];
}
function GetCityRusByIndex(index) {
    return citiesRus[index];
}
function GetCityDescByIndex(index) {
    return cityDescrs[index];
}

function setRandomCityInfo(index) {
    var cityDescr = GetCityDescByIndex(index).split("/");
    var cityEngCountry = GetCityEngByIndex(cityDescr[0]).split("/");
    var cityRus = GetCityRusByIndex(cityDescr[0]);
    var countryRus = cityEngCountry[3];
    $.getJSON("http://tourminal.ru/ElcondorWCF.svc/GetCountryGMTOffset?method=?&countryName=" + cityEngCountry[1], function (response) {
        setCityInfo(cityEngCountry[0], 'bubble_deg', 'bubble_time', 'city_name', cityRus, 0, response);
        //setCityInfo(cityEngCountry[0], 'weather_deg', 'weather_time', 'weather_city', cityRus, 0, response);
    });
    //setCityDescr(countryRus, cityDescr[1]);
    var bgurl = '../../Content/UserImages/' + cityDescr[2];
    $("#headerimg").attr("src", bgurl);
}

function setCityInfo (cityname, temperatureSpanId, timeSpanId, cityNameSpanId, cityNameRus, currentGMT, gmtoffset) {
    $("." + cityNameSpanId).text(cityNameRus);
    var gmtTest = gmtoffset.split("+");
    if (gmtTest.length > 2)
        gmtoffset = gmtTest[1];
    $.getJSON("http://tourminal.ru/ElcondorWCF.svc/GetWeatherInfo?method=?&cityName=" + cityname, function (response) {
        var temp = $(response).find("Temperature").text();
        temp = temp.substring(temp.indexOf('(') + 1, temp.indexOf(')') - 2) + '°'; //temperature F+C
        $("." + temperatureSpanId).text(temp);
    });
    $.getJSON("http://tourminal.ru/ElcondorWCF.svc/GetLocaltime?method=?&offset=" + gmtoffset, function (response) {
        $("." + timeSpanId).html($("." + timeSpanId).html() + response);
    });
}

function setCityDescr (countryname, description) { 
    $("#cityinfoname").html('<h2>' + countryname + '</h2>');//<p>' + description + '</p>');
    $("#cityinfotext").text(description);
}

function setCountryMenuHref(id) {
    var lnk1 = $("#btncountrytours").attr("href");
    var lnk2 = $("#btncountrydesc").attr("href");
    var lnk3 = $("#btncountryinfo").attr("href");
    var lnk4 = $("#btncountryregs").attr("href");
    var lnk5 = $("#btncountryvisa").attr("href");
    var lnk6 = $("#btncountrytckt").attr("href");
    var lnk7 = $("#btncountryartcls").attr("href");
    var lnk8 = $("#btncountryexc").attr("href");
    var lnk9 = $("#btncountrycruise").attr("href");
    var lnk10 = $("#btncountryhotels").attr("href");
    var lnk11 = $("#btncountryaddinf").attr("href");
    $("#btncountrytours").attr("href", lnk1 + '?id=' + id);
    $("#btncountrydesc").attr("href", lnk2 + '?id=' + id);
    $("#btncountryinfo").attr("href", lnk3 + '?id=' + id);
    $("#btncountryregs").attr("href", lnk4 + '?id=' + id);
    $("#btncountryvisa").attr("href", lnk5 + '?id=' + id);
    $("#btncountrytckt").attr("href", lnk6 + '?id=' + id);
    $("#btncountryartcls").attr("href", lnk7 + '?id=' + id);
    $("#btncountryexc").attr("href", lnk8 + '?id=' + id);
    $("#btncountrycruise").attr("href", lnk9 + '?id=' + id);
    $("#btncountryhotels").attr("href", lnk10 + '?id=' + id);
    $("#btncountryaddinf").attr("href", lnk11 + '?id=' + id);
}

function sendticketmsg() {
    hideshow('loading', 1);
    error(0);   
    $.ajax({
        type: "POST",
        url: "../../verifyTicketBooking.php",
        data: $('#msgTicketForm').serialize(),
        dataType: "json",
        success: function (msg) {
            if (msg.status == "1") {
                hideshow('errorContact', 0);      
                var webserviceParameter="formVars="+ "email__" + $("#emailContact").val() + "||name__" + $("#nameContact").val()
                                            + "||body__" + $("#contentContact").val() + "||datefrom__" + $("#datefrom").val() + "||dateto__" //+ $("#dateto").val() 
                                            + "||itemId__" + $("#itemId").val() + "||phoneContact__" + $("#phoneContact").val() + "||routeName__" + $("#routeName").text();
                $.getJSON("../../ElcondorWCF.svc/SendMessageTicket?method=?&"+webserviceParameter,function(data){
                    if (data != "1") {
                        error(1, data, 'errorContact');
                    } else {
                        window.location = msg.txt;
                    }
                });          
//                $.ajax({
//                    type: "GET",
//                    url: "../../ElcondorWCF.svc/SendMessageTicket?formVars=" + "email__" + $("#emailContact").val() + "||name__" + $("#nameContact").val()
//                                            + "||body__" + $("#contentContact").val() + "||datefrom__" + $("#datefrom").val() + "||dateto__" //+ $("#dateto").val() 
//                                            + "||itemId__" + $("#itemId").val() + "||itemName__" + $("#itemName").val() + "||phoneContact_" + $("#phoneContact").val() + "||routeName_" + $("#routeName").text(),
//                    data: "",
//                    dataType: "json",
//                    success: function (ms) {
//                        alert(ms);
//                        if (ms != "1") {
//                            error(1, ms, 'errorContact');
//                        } else {
//                            window.location = msg.txt;
//                        }
//                    }
//                });
            } else if (msg.status == "0") {
                error(1, msg.txt, 'errorContact');
            }
            hideshow('loading', 0);
        }
    });
}

function sendmsg() {
    hideshow('loading', 1);
    error(0);   
    $.ajax({
        type: "POST",
        url: "../../verifyRegistration.php",
        data: $('#msgForm').serialize(),
        dataType: "json",
        success: function (msg) {
            if (msg.status == "1") {
                hideshow('errorContact', 0);
                //ok,register user...
				var webserviceParameter="formVars=" + "email__" + $("#emailContact").val() + "||name__" + $("#nameContact").val()
                                            + "||body__" + $("#contentContact").val() + "||datefrom__" + $("#datefrom").val() + "||dateto__" + $("#dateto").val() 
                                            + "||itemId__" + "1" + "||itemName__" + $("#itemName").val();
                $.getJSON("../../ElcondorWCF.svc/SendMessageBooking?"+webserviceParameter,function(data){
                    if (data != "1") {
                        error(1, data, 'errorContact');
                    } else {
                        window.location = msg.txt;
                    }
                });   
                /*$.ajax({
                    type: "GET",
                    url: "../../ElcondorWCF.svc/SendMessage?formVars=" + "email__" + $("#emailContact").val() + "||name__" + $("#nameContact").val()
                                            + "||body__" + $("#contentContact").val(),
                    data: "",
                    dataType: "json",
                    success: function (ms) {
                        if (ms != "1") {
                            error(1, ms, 'errorContact');
                        } else {
                            window.location = msg.txt;
                        }
                    }
                });*/
				
            }
            else if (msg.status == "0") {
                error(1, msg.txt, 'errorContact');
            }
            hideshow('loading', 0);
        }
    });
}


function sendmsgbook() {
    hideshow('loading', 1);
    error(0);   
    $.ajax({
        type: "POST",
        url: "../../verifyRegistration.php",
        data: $('#msgForm').serialize(),
        dataType: "json",
        success: function (msg) {
            if (msg.status == "1") {
                hideshow('errorContact', 0);
                $.ajax({
                    type: "GET",
                    url: "../../ElcondorWCF.svc/SendMessageBooking?formVars=" + "email__" + $("#emailContact").val() + "||name__" + $("#nameContact").val()
                                            + "||body__" + $("#contentContact").val() + "||datefrom__" + $("#datefrom").val() + "||dateto__" + $("#dateto").val() 
                                            + "||itemId__" + $("#itemId").val() + "||itemName__" + $("#itemName").val(),
                    data: "",
                    dataType: "json",
                    success: function (ms) {
                        if (ms != "1") {
                            error(1, ms, 'errorContact');
                        } else {
                            window.location = msg.txt;
                        }
                    }
                });
            }
            else if (msg.status == "0") {
                error(1, msg.txt, 'errorContact');
            }
            hideshow('loading', 0);
        }
    });
}

function hideshow(el, act) {
    if (act) $('#' + el).css('visibility', 'visible');
    else $('#' + el).css('visibility', 'hidden');
}

function error(act, txt, container) {
    hideshow(container, act);
    if (txt) $('#' + container).html(txt);
}

$.urlParam = function(name, path){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec(path);
    if (!results) { return 0; }
    return results[1] || 0;
}

function loadjscssfile(filename, filetype){
 if (filetype=="js"){ //if filename is a external JavaScript file
  var fileref=document.createElement('script')
  fileref.setAttribute("type","text/javascript")
  fileref.setAttribute("src", filename)
 }
 else if (filetype=="css"){ //if filename is an external CSS file
  var fileref=document.createElement("link")
  fileref.setAttribute("rel", "stylesheet")
  fileref.setAttribute("type", "text/css")
  fileref.setAttribute("href", filename)
 }
 if (typeof fileref!="undefined")
  document.getElementsByTagName("head")[0].appendChild(fileref)
}

function validateSearchFields() {
    var errors = "";
    if (!validateFloat($("#txtPriceStart").val()) && $("#txtPriceStart").val() != '')
        errors += "Неверно указана минимальная цена.";
    if (!validateFloat($("#txtPriceEnd").val()) && $("#txtPriceEnd").val() != '')
        errors += "Неверно указана максимальная цена.";
    if (errors.length == 0) {
        if ($("#txtPriceStart").val() > $("#txtPriceEnd").val())
            errors += "Максимальная цена за сутки не может быть меньше минимальной.";
    }
    return errors;
}

function validateFloat(value) {
	if (isNaN(parseFloat(value)))
	    return false;
	else return true;
}

function populateComboboxNoParam(comboboxId, webserviceName, addEmptyRow) {
    $.getJSON(webserviceName + "?method=?", function (response) {
        var result = "";
        if (addEmptyRow)
            result += '<option value="-1">Не имеет значения</option>';
        var items = eval('(' + response + ')');
        for (var i = 0; i < items.length; i++) {
            result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
        }
        $("select#" + comboboxId).html(result);
    });
}
        
function populateCombobox(comboboxId, webserviceName, addAllItemsRow, webserviceParameter) {
    $.getJSON(webserviceName + "?method=?&" + webserviceParameter, function (response) {
        var result = "";
        if (addAllItemsRow)
            result += '<option value="-1">-- Все --</option>';
        var items = eval('(' + response + ')');
        for (var i = 0; i < items.length; i++) {
            result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
        }
        $("select#" + comboboxId).html(result);
    });
}

function populateComboboxNameIs(comboboxId, webserviceName, addAllItemsRow, webserviceParameter) {
    $.getJSON(webserviceName + "?method=?&" + webserviceParameter, function (response) {
        var result = "";
        if (addAllItemsRow)
            result += '<option value="-1">-- Все --</option>';
        var items = eval('(' + response + ')');
        for (var i = 0; i < items.length; i++) {
            result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
        }
        $("select#" + comboboxId).html(result);
    });
}

function selectTopMenuItem(pageid) {
    $('.h_menu_list li[id]').each(function (el) {
        if ($(this).attr('id').substr(3, $(this).attr('id').length) == pageid)
            $(this).attr('class', 'h_menu_item active');
        else
            $(this).attr('class', 'h_menu_item');
    });
}

function populateComboboxNameId(comboboxId, webserviceName, addAllItemsRow, webserviceParameter) {
    $.getJSON(webserviceName + "?method=?&" + webserviceParameter, function (response) {
        var result = "";
        if (addAllItemsRow)
            result += '<option value="-1">-- Все --</option>';
        var items = eval('(' + response + ')');
        for (var i = 0; i < items.length; i++) {
            result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
        }
        $("select#" + comboboxId).html(result);
    });
}

function populateMultipleCombobox(comboboxId, webserviceName, addEmptyRow) {
    $.getJSON(webserviceName + "?method=?", function (response) {
        var result = "";
        var items = eval('(' + response + ')');
        for (var i = 0; i < items.length; i++) {
            result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
        }
        $("select#" + comboboxId).html(result);
        $("#" + comboboxId).multiselect({
            noneSelectedText: "Не имеет значения",
            selectedText: "Выбрано: # пункт(ов)",
            header: false
        });
    });
}

(function ($) {
m = {
'\b': '\\b',
'\t': '\\t',
'\n': '\\n',
'\f': '\\f',
'\r': '\\r',
'"' : '\\"',
'\\': '\\\\'
},
$.toJSON = function (value, whitelist) {
var a, // The array holding the partial texts.
i, // The loop counter.
k, // The member key.
l, // Length.
r = /["\\\x00-\x1f\x7f-\x9f]/g,
v; // The member value.

switch (typeof value) {
case 'string':
return r.test(value) ?
'"' + value.replace(r, function (a) {
var c = m[a];
if (c) {
return c;
}
c = a.charCodeAt();
return '\\u00' + Math.floor(c / 16).toString(16) + (c % 16).toString(16);
}) + '"' :
'"' + value + '"';

case 'number':
return isFinite(value) ? String(value) : 'null';

case 'boolean':
case 'null':
return String(value);

case 'object':
if (!value) {
return 'null';
}
if (typeof value.toJSON === 'function') {
return value.toJSON();
}
a = [];
if (typeof value.length === 'number' &&
!(value.propertyIsEnumerable('length'))) {
l = value.length;
for (i = 0; i < l; i += 1) {
a.push($.toJSON(value[i], whitelist) || 'null');
}
return '[' + a.join(',') + ']';
}
if (whitelist) {
l = whitelist.length;
for (i = 0; i < l; i += 1) {
k = whitelist[i];
if (typeof k === 'string') {
v = $.toJSON(value[k], whitelist);
if (v) {
a.push($.toJSON(k) + ':' + v);
}
}
}
} else {
for (k in value) {
if (typeof k === 'string') {
v = $.toJSON(value[k], whitelist);
if (v) {
a.push($.toJSON(k) + ':' + v);
}
}
}
}
return '{' + a.join(',') + '}';
}
};

})(jQuery); 

function isValidDate(date_string, format) {
    var days = [0,31,28,31,30,31,30,31,31,30,31,30,31];
    var year, month, day, date_parts = null;
    var rtrn = false;
    var decisionTree = {
        'm/d/y':{
            're':/^(\d{1,2})[./-](\d{1,2})[./-](\d{2}|\d{4})$/,
            'month': 1,'day': 2, year: 3
        },
        'mm/dd/yy':{
            're':/^(\d{1,2})[./-](\d{1,2})[./-](\d{2})$/,
            'month': 1,'day': 2, year: 3
        },
        'dd/mm/yyyy':{
            're':/^(\d{1,2})[./-](\d{1,2})[./-](\d{4})$/,
            'day': 1,'month': 2, year: 3
        },
        'y/m/d':{
            're':/^(\d{2}|\d{4})[./-](\d{1,2})[./-](\d{1,2})$/,
            'month': 2,'day': 3, year: 1
        },
        'yy/mm/dd':{
            're':/^(\d{1,2})[./-](\d{1,2})[./-](\d{1,2})$/,
            'month': 2,'day': 3, year: 1
        },
        'yyyy/mm/dd':{
            're':/^(\d{4})[./-](\d{1,2})[./-](\d{1,2})$/,
            'month': 2,'day': 3, year: 1
        }
    };

    var test = decisionTree[format];
    
    if (test) {
        date_parts = date_string.match(test.re);
        if (date_parts) {
            year = date_parts[test.year];
            month = date_parts[test.month];
            day = date_parts[test.day];
            
            rtrn = 1 <= day;
        }
    }
    return rtrn;
}//eof isValidDate

/*!
 * jQuery Expander Plugin v1.4.2
 *
 * Date: Fri Mar 16 14:29:56 2012 EDT
 * Requires: jQuery v1.3+
 *
 * Copyright 2011, Karl Swedberg
 * Dual licensed under the MIT and GPL licenses (just like jQuery):
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 *
 *
 *
 *
*/

(function($) {
  $.expander = {
    version: '1.4.2',
    defaults: {
      // the number of characters at which the contents will be sliced into two parts.
      slicePoint: 100,

      // whether to keep the last word of the summary whole (true) or let it slice in the middle of a word (false)
      preserveWords: true,

      // a threshold of sorts for whether to initially hide/collapse part of the element's contents.
      // If after slicing the contents in two there are fewer words in the second part than
      // the value set by widow, we won't bother hiding/collapsing anything.
      widow: 4,

      // text displayed in a link instead of the hidden part of the element.
      // clicking this will expand/show the hidden/collapsed text
      expandText: 'показать текст...',
      expandPrefix: '&hellip; ',

      expandAfterSummary: false,

      // class names for summary element and detail element
      summaryClass: 'summary',
      detailClass: 'details',

      // class names for <span> around "read-more" link and "read-less" link
      moreClass: 'read-more',
      lessClass: 'read-less',

      // number of milliseconds after text has been expanded at which to collapse the text again.
      // when 0, no auto-collapsing
      collapseTimer: 0,

      // effects for expanding and collapsing
      expandEffect: 'fadeIn',
      expandSpeed: 250,
      collapseEffect: 'fadeOut',
      collapseSpeed: 200,

      // allow the user to re-collapse the expanded text.
      userCollapse: true,

      // text to use for the link to re-collapse the text
      userCollapseText: 'скрыть текст...',
      userCollapsePrefix: ' ',


      // all callback functions have the this keyword mapped to the element in the jQuery set when .expander() is called

      onSlice: null, // function() {}
      beforeExpand: null, // function() {},
      afterExpand: null, // function() {},
      onCollapse: null // function(byUser) {}
    }
  };

  $.fn.expander = function(options) {
    var meth = 'init';

    if (typeof options == 'string') {
      meth = options;
      options = {};
    }

    var opts = $.extend({}, $.expander.defaults, options),
        rSelfClose = /^<(?:area|br|col|embed|hr|img|input|link|meta|param).*>$/i,
        rAmpWordEnd = opts.wordEnd || /(&(?:[^;]+;)?|[a-zA-Z\u00C0-\u0100]+)$/,
        rOpenCloseTag = /<\/?(\w+)[^>]*>/g,
        rOpenTag = /<(\w+)[^>]*>/g,
        rCloseTag = /<\/(\w+)>/g,
        rLastCloseTag = /(<\/[^>]+>)\s*$/,
        rTagPlus = /^<[^>]+>.?/,
        delayedCollapse;

    var methods = {
      init: function() {
        this.each(function() {
          var i, l, tmp, newChar, summTagless, summOpens, summCloses,
              lastCloseTag, detailText, detailTagless,
              $thisDetails, $readMore,
              openTagsForDetails = [],
              closeTagsForsummaryText = [],
              defined = {},
              thisEl = this,
              $this = $(this),
              $summEl = $([]),
              o = $.meta ? $.extend({}, opts, $this.data()) : opts,
              hasDetails = !!$this.find('.' + o.detailClass).length,
              hasBlocks = !!$this.find('*').filter(function() {
                var display = $(this).css('display');
                return (/^block|table|list/).test(display);
              }).length,
              el = hasBlocks ? 'div' : 'span',
              detailSelector = el + '.' + o.detailClass,
              moreSelector = 'span.' + o.moreClass,
              expandSpeed = o.expandSpeed || 0,
              allHtml = $.trim( $this.html() ),
              allText = $.trim( $this.text() ),
              summaryText = allHtml.slice(0, o.slicePoint);

          // bail out if we've already set up the expander on this element
          if ( $.data(this, 'expander') ) {
            return;
          }

          $.data(this, 'expander', true);

          // determine which callback functions are defined
          $.each(['onSlice','beforeExpand', 'afterExpand', 'onCollapse'], function(index, val) {
            defined[val] = $.isFunction(o[val]);
          });

          // back up if we're in the middle of a tag or word
          summaryText = backup(summaryText);

          // summary text sans tags length
          summTagless = summaryText.replace(rOpenCloseTag, '').length;

          // add more characters to the summary, one for each character in the tags
          while (summTagless < o.slicePoint) {
            newChar = allHtml.charAt(summaryText.length);
            if (newChar == '<') {
              newChar = allHtml.slice(summaryText.length).match(rTagPlus)[0];
            }
            summaryText += newChar;
            summTagless++;
          }

          summaryText = backup(summaryText, o.preserveWords);

          // separate open tags from close tags and clean up the lists
          summOpens = summaryText.match(rOpenTag) || [];
          summCloses = summaryText.match(rCloseTag) || [];

          // filter out self-closing tags
          tmp = [];
          $.each(summOpens, function(index, val) {
            if ( !rSelfClose.test(val) ) {
              tmp.push(val);
            }
          });
          summOpens = tmp;

          // strip close tags to just the tag name
          l = summCloses.length;
          for (i = 0; i < l; i++) {
            summCloses[i] = summCloses[i].replace(rCloseTag, '$1');
          }

          // tags that start in summary and end in detail need:
          // a). close tag at end of summary
          // b). open tag at beginning of detail
          $.each(summOpens, function(index, val) {
            var thisTagName = val.replace(rOpenTag, '$1');
            var closePosition = $.inArray(thisTagName, summCloses);
            if (closePosition === -1) {
              openTagsForDetails.push(val);
              closeTagsForsummaryText.push('</' + thisTagName + '>');

            } else {
              summCloses.splice(closePosition, 1);
            }
          });

          // reverse the order of the close tags for the summary so they line up right
          closeTagsForsummaryText.reverse();

          // create necessary summary and detail elements if they don't already exist
          if ( !hasDetails ) {

            // end script if there is no detail text or if detail has fewer words than widow option
            detailText = allHtml.slice(summaryText.length);
            detailTagless = $.trim( detailText.replace(rOpenCloseTag, '') );

            if ( detailTagless === '' || detailTagless.split(/\s+/).length < o.widow ) {
              return;
            }
            // otherwise, continue...
            lastCloseTag = closeTagsForsummaryText.pop() || '';
            summaryText += closeTagsForsummaryText.join('');
            detailText = openTagsForDetails.join('') + detailText;

          } else {
            // assume that even if there are details, we still need readMore/readLess/summary elements
            // (we already bailed out earlier when readMore el was found)
            // but we need to create els differently

            // remove the detail from the rest of the content
            detailText = $this.find(detailSelector).remove().html();

            // The summary is what's left
            summaryText = $this.html();

            // allHtml is the summary and detail combined (this is needed when content has block-level elements)
            allHtml = summaryText + detailText;

            lastCloseTag = '';
          }
          o.moreLabel = $this.find(moreSelector).length ? '' : buildMoreLabel(o);

          if (hasBlocks) {
            detailText = allHtml;
          }
          summaryText += lastCloseTag;

          // onSlice callback
          o.summary = summaryText;
          o.details = detailText;
          o.lastCloseTag = lastCloseTag;

          if (defined.onSlice) {
            // user can choose to return a modified options object
            // one last chance for user to change the options. sneaky, huh?
            // but could be tricky so use at your own risk.
            tmp = o.onSlice.call(thisEl, o);

          // so, if the returned value from the onSlice function is an object with a details property, we'll use that!
            o = tmp && tmp.details ? tmp : o;
          }

          // build the html with summary and detail and use it to replace old contents
          var html = buildHTML(o, hasBlocks);

          $this.html( html );

          // set up details and summary for expanding/collapsing
          $thisDetails = $this.find(detailSelector);
          $readMore = $this.find(moreSelector);
          $thisDetails.hide();
          $readMore.find('a').unbind('click.expander').bind('click.expander', expand);

          $summEl = $this.find('div.' + o.summaryClass);

          if ( o.userCollapse && !$this.find('span.' + o.lessClass).length ) {
            $this
            .find(detailSelector + ' .graypanel')
            .append('<span class="' + o.lessClass + '">' + o.userCollapsePrefix + '<a href="#">' + o.userCollapseText + '</a></span>');

            $this
            .find(detailSelector + ' .graypanel')
            .prepend('<span class="' + o.lessClass + '">' + o.userCollapsePrefix + '<a href="#">' + o.userCollapseText + '</a></span>')
          }

          $this
          .find('span.' + o.lessClass + ' a')
          .unbind('click.expander')
          .bind('click.expander', function(event) {
            event.preventDefault();
            clearTimeout(delayedCollapse);
            var $detailsCollapsed = $(this).closest(detailSelector);
            reCollapse(o, $detailsCollapsed);
            if (defined.onCollapse) {
              o.onCollapse.call(thisEl, true);
            }
          });

          function expand(event) {
            event.preventDefault();
            $readMore.hide();
            $summEl.hide();
            if (defined.beforeExpand) {
              o.beforeExpand.call(thisEl);
            }

            $thisDetails.stop(false, true)[o.expandEffect](expandSpeed, function() {
              $thisDetails.css({zoom: ''});
              if (defined.afterExpand) {o.afterExpand.call(thisEl);}
              delayCollapse(o, $thisDetails, thisEl);
            });
          }

        }); // this.each
      },
      destroy: function() {
        if ( !this.data('expander') ) {
          return;
        }
        this.removeData('expander');
        this.each(function() {
          var $this = $(this),
              o = $.meta ? $.extend({}, opts, $this.data()) : opts,
              details = $this.find('.' + o.detailClass).contents();

          $this.find('.' + o.moreClass).remove();
          $this.find('.' + o.summaryClass).remove();
          $this.find('.' + o.detailClass).after(details).remove();
          $this.find('.' + o.lessClass).remove();

        });
      }
    };

    // run the methods (almost always "init")
    if ( methods[meth] ) {
      methods[ meth ].call(this);
    }

    // utility functions
    function buildHTML(o, blocks) {
      var el = 'span',
          summary = o.summary;
      if ( blocks ) {
        el = 'div';
        // if summary ends with a close tag, tuck the moreLabel inside it
        if ( rLastCloseTag.test(summary) && !o.expandAfterSummary) {
          summary = summary.replace(rLastCloseTag, o.moreLabel + '$1');
        } else {
        // otherwise (e.g. if ends with self-closing tag) just add moreLabel after summary
        // fixes #19
          summary += o.moreLabel;
        }

        // and wrap it in a div
        summary = '<div class="' + o.summaryClass + '">' + summary + '</div>';
      } else {
        summary += o.moreLabel;
      }

      return [
        summary,
        '<',
          el + ' class="' + o.detailClass + '"',
        '>',
          o.details,
        '</' + el + '>'
        ].join('');
    }

    function buildMoreLabel(o) {
      var ret = '<span class="' + o.moreClass + '">' + o.expandPrefix;
      ret += '<a href="#">' + o.expandText + '</a></span>';
      return ret;
    }

    function backup(txt, preserveWords) {
      if ( txt.lastIndexOf('<') > txt.lastIndexOf('>') ) {
        txt = txt.slice( 0, txt.lastIndexOf('<') );
      }
      if (preserveWords) {
        txt = txt.replace(rAmpWordEnd,'');
      }

      return $.trim(txt);
    }

    function reCollapse(o, el) {
      el.stop(true, true)[o.collapseEffect](o.collapseSpeed, function() {
        var prevMore = el.prev('span.' + o.moreClass).show();
        if (!prevMore.length) {
          el.parent().children('div.' + o.summaryClass).show()
            .find('span.' + o.moreClass).show();
        }
      });
    }

    function delayCollapse(option, $collapseEl, thisEl) {
      if (option.collapseTimer) {
        delayedCollapse = setTimeout(function() {
          reCollapse(option, $collapseEl);
          if ( $.isFunction(option.onCollapse) ) {
            option.onCollapse.call(thisEl, false);
          }
        }, option.collapseTimer);
      }
    }

    return this;
  };

  // plugin defaults
  $.fn.expander.defaults = $.expander.defaults;
})(jQuery);

$.fn.infiniteCarousel = function () {

    function repeat(str, num) {
        return new Array(num + 1).join(str);
    }
    return this.each(function () {
        var $wrapper = $('> div', this).css('overflow', 'hidden'),
				$slider = $wrapper.find('> ul'),
				$items = $slider.find('> li'),
				$single = $items.filter(':first'),

				singleWidth = $single.outerWidth(),
				visible = Math.ceil($wrapper.innerWidth() / singleWidth), // note: doesn't include padding or border
				currentPage = 1,
				pages = Math.ceil($items.length / visible);


        // 1. Pad so that 'visible' number will always be seen, otherwise create empty items
        if (($items.length % visible) != 0) {
            $slider.append(repeat('<li class="empty" />', visible - ($items.length % visible)));
            $items = $slider.find('> li');
        }

        // 2. Top and tail the list with 'visible' number of items, top has the last section, and tail has the first
        $items.filter(':first').before($items.slice(-visible).clone().addClass('cloned'));
        $items.filter(':last').after($items.slice(0, visible).clone().addClass('cloned'));
        $items = $slider.find('> li'); // reselect

        // 3. Set the left position to the first 'real' item
        $wrapper.scrollLeft(singleWidth * visible);

        // 4. paging function
        function gotoPage(page) {
            var dir = page < currentPage ? -1 : 1,
					n = Math.abs(currentPage - page),
					left = singleWidth * dir * visible * n;

            $wrapper.filter(':not(:animated)').animate({
                scrollLeft: '+=' + left
            }, 500, function () {
                if (page == 0) {
                    $wrapper.scrollLeft(singleWidth * visible * pages);
                    page = pages;
                } else if (page > pages) {
                    $wrapper.scrollLeft(singleWidth * visible);
                    // reset back to start position
                    page = 1;
                }

                currentPage = page;
            });

            return false;
        }

        $wrapper.after('<a class="arrow back">&lt;</a><a class="arrow forward">&gt;</a>');

        // 5. Bind to the forward and back buttons
        $('a.back', this).click(function () {
            return gotoPage(currentPage - 1);
        });

        $('a.forward', this).click(function () {
            return gotoPage(currentPage + 1);
        });

        // create a public interface to move to a specific page
        $(this).bind('goto', function (event, page) {
            gotoPage(page);
        });
    });
};