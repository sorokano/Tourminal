/*!
* jQuery UI Widget 1.8.2
*
* Copyright (c) 2010 AUTHORS.txt (http://jqueryui.com/about)
* Dual licensed under the MIT (MIT-LICENSE.txt)
* and GPL (GPL-LICENSE.txt) licenses.
*
* http://docs.jquery.com/UI/Widget

(function($) {

    var _remove = $.fn.remove;

    $.fn.remove = function(selector, keepData) {
        return this.each(function() {
            if (!keepData) {
                if (!selector || $.filter(selector, [this]).length) {
                    $("*", this).add(this).each(function() {
                        $(this).triggerHandler("remove");
                    });
                }
            }
            return _remove.call($(this), selector, keepData);
        });
    };

    $.widget = function(name, base, prototype) {
        var namespace = name.split(".")[0],
		fullName;
        name = name.split(".")[1];
        fullName = namespace + "-" + name;

        if (!prototype) {
            prototype = base;
            base = $.Widget;
        }

        // create selector for plugin
        $.expr[":"][fullName] = function(elem) {
            return !!$.data(elem, name);
        };

        $[namespace] = $[namespace] || {};
        $[namespace][name] = function(options, element) {
            // allow instantiation without initializing for simple inheritance
            if (arguments.length) {
                this._createWidget(options, element);
            }
        };

        var basePrototype = new base();
        // we need to make the options hash a property directly on the new instance
        // otherwise we'll modify the options hash on the prototype that we're
        // inheriting from
        //	$.each( basePrototype, function( key, val ) {
        //		if ( $.isPlainObject(val) ) {
        //			basePrototype[ key ] = $.extend( {}, val );
        //		}
        //	});
        basePrototype.options = $.extend({}, basePrototype.options);
        $[namespace][name].prototype = $.extend(true, basePrototype, {
            namespace: namespace,
            widgetName: name,
            widgetEventPrefix: $[namespace][name].prototype.widgetEventPrefix || name,
            widgetBaseClass: fullName
        }, prototype);

        $.widget.bridge(name, $[namespace][name]);
    };

    $.widget.bridge = function(name, object) {
        $.fn[name] = function(options) {
            var isMethodCall = typeof options === "string",
			args = Array.prototype.slice.call(arguments, 1),
			returnValue = this;

            // allow multiple hashes to be passed on init
            options = !isMethodCall && args.length ?
			$.extend.apply(null, [true, options].concat(args)) :
			options;

            // prevent calls to internal methods
            if (isMethodCall && options.substring(0, 1) === "_") {
                return returnValue;
            }

            if (isMethodCall) {
                this.each(function() {
                    var instance = $.data(this, name),
					methodValue = instance && $.isFunction(instance[options]) ?
						instance[options].apply(instance, args) :
						instance;
                    if (methodValue !== instance && methodValue !== undefined) {
                        returnValue = methodValue;
                        return false;
                    }
                });
            } else {
                this.each(function() {
                    var instance = $.data(this, name);
                    if (instance) {
                        if (options) {
                            instance.option(options);
                        }
                        instance._init();
                    } else {
                        $.data(this, name, new object(options, this));
                    }
                });
            }

            return returnValue;
        };
    };

    $.Widget = function(options, element) {
        // allow instantiation without initializing for simple inheritance
        if (arguments.length) {
            this._createWidget(options, element);
        }
    };

    $.Widget.prototype = {
        widgetName: "widget",
        widgetEventPrefix: "",
        options: {
            disabled: false
        },
        _createWidget: function(options, element) {
            // $.widget.bridge stores the plugin instance, but we do it anyway
            // so that it's stored even before the _create function runs
            this.element = $(element).data(this.widgetName, this);
            this.options = $.extend(true, {},
			this.options,
			$.metadata && $.metadata.get(element)[this.widgetName],
			options);

            var self = this;
            this.element.bind("remove." + this.widgetName, function() {
                self.destroy();
            });

            this._create();
            this._init();
        },
        _create: function() { },
        _init: function() { },

        destroy: function() {
            this.element
			.unbind("." + this.widgetName)
			.removeData(this.widgetName);
            this.widget()
			.unbind("." + this.widgetName)
			.removeAttr("aria-disabled")
			.removeClass(
				this.widgetBaseClass + "-disabled " +
				"ui-state-disabled");
        },

        widget: function() {
            return this.element;
        },

        option: function(key, value) {
            var options = key,
			self = this;

            if (arguments.length === 0) {
                // don't return a reference to the internal hash
                return $.extend({}, self.options);
            }

            if (typeof key === "string") {
                if (value === undefined) {
                    return this.options[key];
                }
                options = {};
                options[key] = value;
            }

            $.each(options, function(key, value) {
                self._setOption(key, value);
            });

            return self;
        },
        _setOption: function(key, value) {
            this.options[key] = value;

            if (key === "disabled") {
                this.widget()
				[value ? "addClass" : "removeClass"](
					this.widgetBaseClass + "-disabled" + " " +
					"ui-state-disabled")
				.attr("aria-disabled", value);
            }

            return this;
        },

        enable: function() {
            return this._setOption("disabled", false);
        },
        disable: function() {
            return this._setOption("disabled", true);
        },

        _trigger: function(type, event, data) {
            var callback = this.options[type];

            event = $.Event(event);
            event.type = (type === this.widgetEventPrefix ?
			type :
			this.widgetEventPrefix + type).toLowerCase();
            data = data || {};

            // copy original event properties over to the new event
            // this would happen if we could call $.event.fix instead of $.Event
            // but we don't have a way to force an event to be fixed multiple times
            if (event.originalEvent) {
                for (var i = $.event.props.length, prop; i; ) {
                    prop = $.event.props[--i];
                    event[prop] = event.originalEvent[prop];
                }
            }

            this.element.trigger(event, data);

            return !($.isFunction(callback) &&
			callback.call(this.element[0], event, data) === false ||
			event.isDefaultPrevented());
        }
    };

})(jQuery);
*/

/*!
* jQuery UI Widget 1.8.14
*
* Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
* Dual licensed under the MIT or GPL Version 2 licenses.
* http://jquery.org/license
*
* http://docs.jquery.com/UI/Widget
*/
(function (b, j) {
    if (b.cleanData) { var k = b.cleanData; b.cleanData = function (a) { for (var c = 0, d; (d = a[c]) != null; c++) b(d).triggerHandler("remove"); k(a) } } else { var l = b.fn.remove; b.fn.remove = function (a, c) { return this.each(function () { if (!c) if (!a || b.filter(a, [this]).length) b("*", this).add([this]).each(function () { b(this).triggerHandler("remove") }); return l.call(b(this), a, c) }) } } b.widget = function (a, c, d) {
        var e = a.split(".")[0], f; a = a.split(".")[1]; f = e + "-" + a; if (!d) { d = c; c = b.Widget } b.expr[":"][f] = function (h) {
            return !!b.data(h,
a)
        }; b[e] = b[e] || {}; b[e][a] = function (h, g) { arguments.length && this._createWidget(h, g) }; c = new c; c.options = b.extend(true, {}, c.options); b[e][a].prototype = b.extend(true, c, { namespace: e, widgetName: a, widgetEventPrefix: b[e][a].prototype.widgetEventPrefix || a, widgetBaseClass: f }, d); b.widget.bridge(a, b[e][a])
    }; b.widget.bridge = function (a, c) {
        b.fn[a] = function (d) {
            var e = typeof d === "string", f = Array.prototype.slice.call(arguments, 1), h = this; d = !e && f.length ? b.extend.apply(null, [true, d].concat(f)) : d; if (e && d.charAt(0) === "_") return h;
            e ? this.each(function () { var g = b.data(this, a), i = g && b.isFunction(g[d]) ? g[d].apply(g, f) : g; if (i !== g && i !== j) { h = i; return false } }) : this.each(function () { var g = b.data(this, a); g ? g.option(d || {})._init() : b.data(this, a, new c(d, this)) }); return h
        } 
    }; b.Widget = function (a, c) { arguments.length && this._createWidget(a, c) }; b.Widget.prototype = { widgetName: "widget", widgetEventPrefix: "", options: { disabled: false }, _createWidget: function (a, c) {
        b.data(c, this.widgetName, this); this.element = b(c); this.options = b.extend(true, {}, this.options,
this._getCreateOptions(), a); var d = this; this.element.bind("remove." + this.widgetName, function () { d.destroy() }); this._create(); this._trigger("create"); this._init()
    }, _getCreateOptions: function () { return b.metadata && b.metadata.get(this.element[0])[this.widgetName] }, _create: function () { }, _init: function () { }, destroy: function () { this.element.unbind("." + this.widgetName).removeData(this.widgetName); this.widget().unbind("." + this.widgetName).removeAttr("aria-disabled").removeClass(this.widgetBaseClass + "-disabled ui-state-disabled") },
        widget: function () { return this.element }, option: function (a, c) { var d = a; if (arguments.length === 0) return b.extend({}, this.options); if (typeof a === "string") { if (c === j) return this.options[a]; d = {}; d[a] = c } this._setOptions(d); return this }, _setOptions: function (a) { var c = this; b.each(a, function (d, e) { c._setOption(d, e) }); return this }, _setOption: function (a, c) { this.options[a] = c; if (a === "disabled") this.widget()[c ? "addClass" : "removeClass"](this.widgetBaseClass + "-disabled ui-state-disabled").attr("aria-disabled", c); return this },
        enable: function () { return this._setOption("disabled", false) }, disable: function () { return this._setOption("disabled", true) }, _trigger: function (a, c, d) { var e = this.options[a]; c = b.Event(c); c.type = (a === this.widgetEventPrefix ? a : this.widgetEventPrefix + a).toLowerCase(); d = d || {}; if (c.originalEvent) { a = b.event.props.length; for (var f; a; ) { f = b.event.props[--a]; c[f] = c.originalEvent[f] } } this.element.trigger(c, d); return !(b.isFunction(e) && e.call(this.element[0], c, d) === false || c.isDefaultPrevented()) } 
    }
})(jQuery);
;