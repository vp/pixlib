/*
package net.pixlib.display.css

	/**
	[Event(name="onStyleChanged", type="net.pixlib.display.css.event.PXCSSStyleChangeEvent")]
	/**
	[Event(name="onPropertyChanged", type="net.pixlib.display.css.event.PXCSSPropertyChangeEvent")]
	/**
	final public class PXCSS
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------
		/** @private */
		private var _name : String;

		/** @private */
		private var _locatorName : String;

		/** @private */
		private var _methodMap : PXHashMap;

		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		/** Event broadcaster. */
		protected var broadcaster : PXEventBroadcaster;

		/** Embeded Stylesheet object. */
		protected var sheet : StyleSheet;

		/** TextFormat cache. */
		protected var formatCache : PXHashMap;

		/** Style cache. */
		protected var styleCache : PXHashMap;

		/** Parsers collection. */
		protected var parsers : PXCSSParserCollection;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		public static var DEFAULT_CSS_PARSER : PXCSSParserCollection = new PXCSSParserCollection();

		/**
		public static var DEFAULT_TEXTFORMAT_STRATEGY : PXTextFormatCSSTransform = new PXTextFormatCSSTransform();

		/**
		public static var DEFAULT_TEXTFIELD_STRATEGY : PXTextFieldCSSTransform = new PXTextFieldCSSTransform();

		/**
		public static var DEFAULT_DISPLAYOBJECT_STRATEGY : PXDisplayObjectCSSTransform = new PXDisplayObjectCSSTransform();
		/**
		public function get name() : String
		{
			return _name;
		}

		/**
		public function get locatorName() : String
		{
			return _locatorName;
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		public function PXCSS(name : String = null, css : StyleSheet = null, locator : String = null, iocEngine : Boolean = false)
		{
			formatCache = new PXHashMap();
			styleCache = new PXHashMap();
			broadcaster = new PXEventBroadcaster(this);
			_methodMap = new PXHashMap();
			_locatorName = locator;
			parsers = DEFAULT_CSS_PARSER;
			setName(name, iocEngine);
			setStyleSheet(css ? css : new StyleSheet());
		}

		/**
		public function getStyleSheet() : StyleSheet
		{
			return sheet;
		}

		/**
		public function setStyleSheet(content : StyleSheet) : void
		{
			sheet = content;
			clearCache();
		}

		/**
		public function clearCache(styleName : String = null) : void
		{
			if (styleName)
			{
				if (formatCache.containsKey(styleName)) formatCache.remove(styleName);
				if (styleCache.containsKey(styleName)) styleCache.remove(styleName);
			}
			else
			{
				formatCache.clear();
				styleCache.clear();
			}
		}

		/**
		public function getTextFormat(styleName : String, strategy : PXTextFormatCSSTransform = null) : TextFormat
		{
			var format : TextFormat = new TextFormat();
			if ( formatCache.containsKey(styleName) )
			{
				format = formatCache.get(styleName);
			}
			else
			{
				if (strategy) format = strategy.transform(getStyle(styleName));
				else format = DEFAULT_TEXTFORMAT_STRATEGY.transform(getStyle(styleName));
				formatCache.put(styleName, format);
			}
			return format;
		}

		/**
		public function applyOnTextField(field : TextField, styleName : String, fieldTransform : PXTextFieldCSSTransform = null, formatTransform : PXTextFormatCSSTransform = null, beginIndex : int = -1, endIndex : int = -1) : void
		{
			if (field)
			{
				var format : TextFormat = getTextFormat(styleName, formatTransform);
				var style : Object = getStyle(styleName);
				if (fieldTransform) fieldTransform.transform(field, format, style, beginIndex, endIndex);
				else DEFAULT_TEXTFIELD_STRATEGY.transform(field, format, style, beginIndex, endIndex);
			}
		}

		/**
		public function applyOnDisplayObject(target : DisplayObject, styleName : String, transform : PXDisplayObjectCSSTransform = null) : void
		{
			if (target)
			{
				var style : Object = getStyle(styleName);
				if (transform) transform.transform(target, style);
				else DEFAULT_DISPLAYOBJECT_STRATEGY.transform(target, style);
			}
		}

		/**
		public function setStyleProperty(styleName : String, property : String, value : *) : void
		{
			var styleObject : Object = getStyle(styleName);
			var changed : Boolean = false;
			var oldValue : * = null;
			if ( styleObject.hasOwnProperty(property))
			{
				if (styleObject[property] != value)
				{
					oldValue = getProperty(styleName, property);
					styleObject[property] = value;
					changed = true;
				}
			}
			else
			{
				styleObject[property] = value;
				changed = true;
			}
			if (changed)
			{
				broadcaster.broadcastEvent(new PXCSSPropertyChangeEvent(PXCSSPropertyChangeEvent.onPropertyChangedEVENT, this, styleName, property, getProperty(styleName, property), oldValue));
			}
		}

		/**
		public function getStyle(styleName : String) : PXCSSStyleClass
		{
			if ( styleCache.containsKey(styleName) )
			{
				return styleCache.get(styleName);
			}
			return parseStyle(styleName);
		}

		/**
		public function setStyle(styleName : String, styleObject : Object) : void
		{
			var oldStyle : Object = getStyle(styleName);
			clearCache(styleName);
			sheet.setStyle(styleName, styleObject);
			parseStyle(styleName);
			broadcaster.broadcastEvent(new PXCSSStyleChangeEvent(PXCSSStyleChangeEvent.onStyleChangedEVENT, this, styleName, styleObject, oldStyle));
		}

		/**
		public function parseCSS(string : String) : void
		{
			sheet.parseCSS(string);
			parseStyleSheet();
		}

		/**
		public function hasProperty(styleName : String, property : String) : Boolean
		{
			return getStyle(styleName).hasOwnProperty(property);
		}

		/**
		public function getProperty(styleName : String, property : String, defaultValue : * = null) : *
		{
			var style : Object = getStyle(styleName);
			if ( style != null && style.hasOwnProperty(property))
			{
				return style[property];
			}
			else
			{
				PXDebug.ERROR(".getProperty(" + styleName + ") failed! " + styleName + "->" + property, this);
			}
			return defaultValue;
		}

		/**
		public function getNumber(styleName : String, property : String, defaultValue : Number = 0) : Number
		{
			return getProperty(styleName, property, defaultValue) as Number;
		}

		/**
		public function getBoolean(styleName : String, property : String, defaultValue : Boolean = true) : Boolean
		{
			return getProperty(styleName, property, defaultValue) as Boolean;
		}

		/**
		public function addEventListener(type : String, listener : Object, ... rest) : Boolean
		{
			return broadcaster.addEventListener.apply(broadcaster, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**
		public function removeEventListener(type : String, listener : Object) : Boolean
		{
			return broadcaster.removeEventListener(type, listener);
		}

		/**
		public function registerCSSMethod(methodName : String, method : Function) : void
		{
			if (!_methodMap.containsKey(methodName))
			{
				_methodMap.put(methodName, method);
			}
		}

		/**
		public function unregisterCSSMethod(methodName : String) : void
		{
			if (_methodMap.containsKey(methodName))
			{
				_methodMap.remove(methodName);
			}
		}

		/**
		public function getCSSMethod(methodName : String) : Function
		{
			if (_methodMap.containsKey(methodName))
			{
				return _methodMap.get(methodName);
			}
			return null;
		}

		/**
		public function hasCSSMethod(methodName : String) : Boolean
		{
			return _methodMap.containsKey(methodName);
		}

		/**
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		protected function setName(name : String, iocEngine : Boolean = false) : void
		{
			if ( name != null )
			{
				_name = name;
				if (!iocEngine)
				{
					if (!PXResourceLocator.getInstance(_locatorName).isRegistered(_name))
					{
						PXResourceLocator.getInstance(_locatorName).register(_name, this);
					}
					else
					{
						var msg : String = "can't be registered to " + PXResourceLocator.getInstance(_locatorName) + " with '" + _name + "' name. This name already exists.";
						PXDebug.WARN(msg, this);
					}
				}
			}
		}

		/**
		protected function parseStyleSheet() : void
		{
			clearCache();
			var len : uint = sheet.styleNames.length;
			var styleName : String;
			for (var i : uint = 0;i < len;i++)
			{
				styleName = sheet.styleNames[i];
				if ( !styleCache.containsKey(styleName))
				{
					parseStyle(styleName);
				}
			}
		}

		/**
		protected function parseStyle(styleName : String) : PXCSSStyleClass
		{
			var style : String;
			var obj : * = new PXCSSStyleClass();
			var styleObj : Object;
			var value : String;
			var method : Function;
			var parsed : *;
			{
				styleObj = sheet.getStyle(styleName);
				if (styleObj.hasOwnProperty(STYLE_ALIAS_PROPERTY))
				{
			}
			{
				style = !i ? path[i] : style + "." + path[i];
				styleObj = sheet.getStyle(style);
				if ( style.length > 0 && styleObj != null )
				{
					for ( var property : String in styleObj )
					{
						value = PXStringUtils.trim(styleObj[property]);
						parsed = parsers.parse(this, property, value);
						var refStyleName : String;
						var tmpStyle : Object;
						while (parsed is String && parsed.indexOf("copy:") == 0)
						{
							refStyleName = parsed.split(":")[1];
							if ( refStyleName.length > 0 && sheet.styleNames.indexOf(refStyleName) > -1)
							{
								tmpStyle = sheet.getStyle(refStyleName);
								if (tmpStyle.hasOwnProperty(property))
								{
									parsed = parsers.parse(this, property, PXStringUtils.trim(tmpStyle[property]));
								}
								else parsed = null;
							}
							else parsed = null;
						}
				}
			}
			sheet.setStyle(styleName, obj);
			styleCache.put(styleName, obj);
			return obj;
		}
	}
}