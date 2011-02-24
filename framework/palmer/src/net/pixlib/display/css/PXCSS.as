/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */
package net.pixlib.display.css{	import net.pixlib.collections.PXHashMap;	import net.pixlib.core.PXCoreFactory;	import net.pixlib.display.css.event.PXCSSPropertyChangeEvent;	import net.pixlib.display.css.event.PXCSSStyleChangeEvent;	import net.pixlib.display.css.transform.PXDisplayObjectCSSTransform;	import net.pixlib.display.css.transform.PXTextFieldCSSTransform;	import net.pixlib.display.css.transform.PXTextFormatCSSTransform;	import net.pixlib.events.PXEventBroadcaster;	import net.pixlib.load.PXResourceLocator;	import net.pixlib.log.PXDebug;	import net.pixlib.log.PXStringifier;	import net.pixlib.utils.PXStringUtils;	import flash.display.DisplayObject;	import flash.text.StyleSheet;	import flash.text.TextField;	import flash.text.TextFormat;	

	/**	 * Dispatched when the a CSS style has changed.	 *	 * @eventType net.pixlib.quick.display.css.event.CSSStyleChangeEvent.onStyleChangedEVENT	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 */
	[Event(name="onStyleChanged", type="net.pixlib.display.css.event.PXCSSStyleChangeEvent")]
	/**	 * Dispatched when the a CSS property has changed.	 *	 * @eventType net.pixlib.quick.display.css.event.CSSStyleChangeEvent.onPropertyChangedEVENT	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 */
	[Event(name="onPropertyChanged", type="net.pixlib.display.css.event.PXCSSPropertyChangeEvent")]
	/**	 * CSS custom StyleSheet object.	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 * 	 * @author Romain Ecarnot	 */
	final public class PXCSS
	{		public static const STYLE_ALIAS_PROPERTY : String = "StyleClassAlias";		
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
		/**		 * Default CSS Parser collection.		 * 		 * @default is net.pixlib.css.CSSParserCollection instance		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEFAULT_CSS_PARSER : PXCSSParserCollection = new PXCSSParserCollection();

		/**		 * Default CSS Tranformation strategy for TextFormat.		 * 		 * @default is net.pixlib.css.transform.TextFormatCSSTransform instance		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEFAULT_TEXTFORMAT_STRATEGY : PXTextFormatCSSTransform = new PXTextFormatCSSTransform();

		/**		 * Default CSS Tranformation strategy for TextField.		 * 		 * @default is net.pixlib.css.transform.TextFieldCSSTransform instance		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEFAULT_TEXTFIELD_STRATEGY : PXTextFieldCSSTransform = new PXTextFieldCSSTransform();

		/**		 * Default CSS Tranformation strategy for DisplayObject.		 * 		 * @default is net.pixlib.css.transform.DisplayObjectCSSTransform instance		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEFAULT_DISPLAYOBJECT_STRATEGY : PXDisplayObjectCSSTransform = new PXDisplayObjectCSSTransform();
		/**		 * CSS Unique identifier.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function get name() : String
		{
			return _name;
		}

		/**		 * Locator's identifer where this CSS instance is registered.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function get locatorName() : String
		{
			return _locatorName;
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Creates new instance.		 * 		 * @param	name	(optional) Instance unique identifier (use it 		 * 					to register CSS instance into Resource Locator 		 * 					System).		 * @param	css		(optional) StyleSheet object to embed (or use 		 * 					parseCSS() method).		 * @param	locator	(optional) Locator identifer (if name is defined and 		 * 					locator is <code>null</code>, CSS instance is 		 * 					registered into default Resource locator.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Returns embed StyleSheet object.		 * 		 * @return embed StyleSheet object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getStyleSheet() : StyleSheet
		{
			return sheet;
		}

		/**		 * Sets the stylesheet to use.		 * 		 * @param css	StyleSheet to use		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function setStyleSheet(content : StyleSheet) : void
		{
			sheet = content;
			clearCache();
		}

		/**		 * Clears TextFormat and Style caches.		 * 		 * @param styleName Style to uncache. If <code>null</code> all styles 		 * 					cache are cleared.		 * 							 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Returns the TextFormat using passed-in <code>styleName</code> 		 * style name.		 * 		 * @return	The TextFormat using passed-in <code>styleName</code> 		 * 			style name.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Applies passed-in style format on <code>field</code> TextField.		 * 		 * @param field				TextField to use		 * @param styleName			Style to apply		 * @param fieldTransform	Transformation engine to use for TextField		 * @param formatTransform	Transformation engine to use for TextFormat		 * @param beingIndex		(optional) Index specifying the first character of the desired range of text.		 * @param endIndex			(optional) Index specifying the last character of the desired range of text.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Applies passed-in style on <code>target</code> DisplayObject.		 * 		 * @param target	DisplayObject to use		 * @param styleName	Style to apply		 * @param transform	Transformation engine to use for DisplayObject		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function applyOnDisplayObject(target : DisplayObject, styleName : String, transform : PXDisplayObjectCSSTransform = null) : void
		{
			if (target)
			{
				var style : Object = getStyle(styleName);
				if (transform) transform.transform(target, style);
				else DEFAULT_DISPLAYOBJECT_STRATEGY.transform(target, style);
			}
		}

		/**		 * Sets new style property value.		 * 		 * <p>Register listener for CSSPropertyChangeEvent.onPropertyChangedEVENT 		 * event type to receive notification when property change.</p>		 * 		 * @param styleName Style to use		 * @param property	Property name to change		 * @param value		New property value		 * 		 * @see net.pixlib.css.event.CSSPropertyChangeEvent#onPropertyChangedEVENT		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Returns PXCSSStyleClass instance using embed StyleSheet.		 * 		 * @return PXCSSStyleClass instance using embed StyleSheet		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getStyle(styleName : String) : PXCSSStyleClass
		{
			if ( styleCache.containsKey(styleName) )
			{
				return styleCache.get(styleName);
			}
			return parseStyle(styleName);
		}

		/**		 * Adds a new style with the specified name to the style sheet object.		 * 		 * <p>Register listener for CSSStyleChangeEvent.onStyleChangedEVENT 		 * event type to receive notification when style change.</p>		 * 		 * @param styleName		Name of the style to add.		 * @param styleObject	Object that describes the style.		 * 		 * @see net.pixlib.css.event.CSSStyleChangeEvent#onStyleChangedEVENT		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function setStyle(styleName : String, styleObject : Object) : void
		{
			var oldStyle : Object = getStyle(styleName);
			clearCache(styleName);
			sheet.setStyle(styleName, styleObject);
			parseStyle(styleName);
			broadcaster.broadcastEvent(new PXCSSStyleChangeEvent(PXCSSStyleChangeEvent.onStyleChangedEVENT, this, styleName, styleObject, oldStyle));
		}

		/**		 * Parses the passed-in CSS string definition.		 * 		 * @param string The CSS String definition to parse		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function parseCSS(string : String) : void
		{
			sheet.parseCSS(string);
			parseStyleSheet();
		}

		/**		 * Returns <code>true</code> if <code>styleName</code> contains 		 * <code>property</code> property.		 * 		 * @param	styleName	Style name (in current StyleSheet) to use		 * @param	property	Style property to check		 * 		 * @return <code>true</code> if <code>styleName</code> contains 		 * <code>property</code> property.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function hasProperty(styleName : String, property : String) : Boolean
		{
			return getStyle(styleName).hasOwnProperty(property);
		}

		/**		 * Returns style property value.		 * 		 * @param	styleName		Style name (in current StyleSheet) to use		 * @param	property		Style property to check		 * @param	defaultValue	(optional) Default value if property 		 * 							is not defined.		 * 		 * @return <code>property</code> value in passed-in <code>styleName</code> style.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Returns style property (Number cast)		 * 		 * @param	styleName		Style name (in current StyleSheet) to use		 * @param	property		Style property to check		 * @param	defaultValue	(optional) Default value to use if property 		 * 							is not defined.		 * 		 * @return <code>property</code> value in passed-in <code>styleName</code> style.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getNumber(styleName : String, property : String, defaultValue : Number = 0) : Number
		{
			return getProperty(styleName, property, defaultValue) as Number;
		}

		/**		 * Returns style property (Boolean cast)		 * 		 * @param	styleName		Style name (in current StyleSheet) to use		 * @param	property		Style property to check		 * @param	defaultValue	(optional) Default value to use if property 		 * 							is not defined.		 * 		 * @return <code>property</code> value in passed-in <code>styleName</code> style.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getBoolean(styleName : String, property : String, defaultValue : Boolean = true) : Boolean
		{
			return getProperty(styleName, property, defaultValue) as Boolean;
		}

		/**		 * Adds an event listener for the specified event type.		 * There is two behaviors for the <code>addEventListener</code>		 * function : 		 * <ol>		 * <li>The passed-in listener is an object : 		 * The object is added as listener only for the specified event, the object must		 * have a function with the same name than <code>type</code> or at least a		 * <code>handleEvent</code> function.</li>		 * <li>The passed-in listener is a function : 		 * There is no restriction concerning the name of the function. If the <code>rest</code> 		 * is not empty, all elements in it will be used as additional arguments when 		 * event callback will happen. </li>		 * </ol>		 * 		 * @param	type		name of the event for which register the listener		 * @param	listener	object or function which will receive this event		 * @param	rest		additional arguments for the function listener		 * @return	<code>true</code> if the function have been succesfully added as		 * 			listener fot the passed-in event		 * @throws 	<code>UnsupportedOperationException</code> — If the listener is an object		 * 			which have neither a function with the same name than the event type nor		 * 			a function called <code>handleEvent</code>		 * 					 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function addEventListener(type : String, listener : Object, ... rest) : Boolean
		{
			return broadcaster.addEventListener.apply(broadcaster, rest.length > 0 ? [type, listener].concat(rest) : [type, listener]);
		}

		/**		 * Removes the passed-in listener for listening the specified event. The		 * listener could be either an object or a function.		 * 		 * @param	type		name of the event for which unregister the listener		 * @param	listener	object or function to be unregistered		 * @return	<code>true</code> if the listener has been successfully removed		 * 			as listener for the passed-in event		 * 					 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function removeEventListener(type : String, listener : Object) : Boolean
		{
			return broadcaster.removeEventListener(type, listener);
		}

		/**		 * Registers new method for CSS Method parsing.		 * 		 * @param methodName	CSS Method name		 * @param method		Method to call from CSS parser engine		 * 		 * @example CSS StyleSheet example		 * <listing>		 * 		 * .title		 * {		 * 	text: Func("getOS");		 * }		 * </listing>		 * 		 * @example Method registration		 * <listing>		 * 		 * css.registerCSSMethod("getOS", _getOS);		 * </listing>		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function registerCSSMethod(methodName : String, method : Function) : void
		{
			if (!_methodMap.containsKey(methodName))
			{
				_methodMap.put(methodName, method);
			}
		}

		/**		 * Unregisters method from CSS Method parsing.		 * 		 * @param methodName	Method name to unregister		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function unregisterCSSMethod(methodName : String) : void
		{
			if (_methodMap.containsKey(methodName))
			{
				_methodMap.remove(methodName);
			}
		}

		/**		 * Returns CSS Method registered using passed-in <code>methodName</code> 		 * identifier.		 * 		 * @param methodName	CSS Method name to retreive		 * 		 * @return	Method registered using passed-in <code>methodName</code> 		 * 			identifier.		 * 		 * @see #registerCSSMethod		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function getCSSMethod(methodName : String) : Function
		{
			if (_methodMap.containsKey(methodName))
			{
				return _methodMap.get(methodName);
			}
			return null;
		}

		/**		 * Returns <code>true</code> if passed-in <code>methodName</code> method 		 * identifier is registered in current CSS Method map.		 * 		 * @param methodName CSS Method name to retreive		 * 		 * @return	<code>true</code> if passed-in <code>methodName</code> method 		 * 			identifier is registered in current CSS Method map.		 * 					 * @see #registerCSSMethod		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function hasCSSMethod(methodName : String) : Boolean
		{
			return _methodMap.containsKey(methodName);
		}

		/**		 * Returns string representation of instance.		 * 		 * @return The string representation of instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**		 * Sets the CSS instance unique identifier.		 * 		 * @param	name	Instance identifier		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Parses embeded StyleSheet object.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
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

		/**		 * Parses passed-in style and return its PXCSSStyleClass representation.		 * 		 * @return PXCSSStyleClass representation of passed-in styleName object		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		protected function parseStyle(styleName : String) : PXCSSStyleClass
		{			var path : Array = styleName.split(".");
			var style : String;
			var obj : * = new PXCSSStyleClass();
			var styleObj : Object;
			var value : String;
			var method : Function;
			var parsed : *;						if ( styleName.length > 0 && sheet.styleNames.indexOf(styleName) > -1)
			{
				styleObj = sheet.getStyle(styleName);
				if (styleObj.hasOwnProperty(STYLE_ALIAS_PROPERTY))
				{					try					{						obj = PXCoreFactory.getInstance().buildInstance(PXStringUtils.trim(styleObj[STYLE_ALIAS_PROPERTY]));					}					catch(e : Error)					{						PXDebug.ERROR("StyleClass alias error " + e.message, this);					}				}
			}						for ( var i : uint = 0;i < path.length;i++ )
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
						}												obj[property] = parsed;					}
				}
			}			
			sheet.setStyle(styleName, obj);
			styleCache.put(styleName, obj);						
			return obj;
		}
	}
}