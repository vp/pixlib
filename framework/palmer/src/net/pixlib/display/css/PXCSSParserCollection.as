/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.display.css
{
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.load.PXResourceLocator;
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXFlashVars;

	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXCSSParserCollection
	{
		// --------------------------------------------------------------------
		// Constants
		// --------------------------------------------------------------------

		public static const CLASS_KEYWORD : String = "ClassReference";

		public static const INSTANCE_KEYWORD : String = "Instance";

		public static const RESOURCE_KEYWORD : String = "ResourceLocator";

		public static const FACTORY_KEYWORD : String = "CoreFactory";

		public static const FLASHVAR_KEYWORD : String = "FlashVar";

		public static const FILTER_KEYWORD : String = "Filters";

		public static const COPY_KEYWORD : String = "Copy";
		
		public static const FUNC_KEYWORD : String = "Func";


		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		private var _dicoP : Dictionary;

		private var _dicoK : Dictionary;

		private var _owner : PXCSS;
		
		
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCSSParserCollection()
		{
			_dicoP = new Dictionary(true);
			initProperties();

			_dicoK = new Dictionary(true);
			initKeywords();
		}

		/**
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addPropertyParser(property : String, method : Function) : void
		{
			_dicoP[property] = method;
		}

		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removePropertyParser(property : String) : void
		{
			if (_dicoP[property]) delete _dicoP[property];
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addKeywordParser(keyword : String, method : Function) : void
		{
			_dicoK[keyword] = method;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeKeywordParser(keyword : String) : void
		{
			if (_dicoK[keyword]) delete _dicoK[keyword];
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function parse(owner : PXCSS, property : String, value : String) : *
		{
			_owner = owner;
			
			if (_dicoP[property] != undefined)
			{
				return _dicoP[property](value);
			}
			return parseDefault(value);
		}


		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initProperties() : void
		{
			// DisplayObject
			addPropertyParser("alpha", parseNumber);
			addPropertyParser("blendMode", parseDefault);
			addPropertyParser("cacheAsBitmap", parseBoolean);
			addPropertyParser("height", parseNumber);
			addPropertyParser("name", parseDefault);
			addPropertyParser("rotation", parseNumber);
			addPropertyParser("rotationX", parseNumber);
			addPropertyParser("rotationY", parseNumber);
			addPropertyParser("rotationZ", parseNumber);
			addPropertyParser("scaleX", parseNumber);
			addPropertyParser("scaleY", parseNumber);
			addPropertyParser("scaleZ", parseNumber);
			addPropertyParser("visible", parseBoolean);
			addPropertyParser("width", parseNumber);
			addPropertyParser("x", parseNumber);
			addPropertyParser("y", parseNumber);
			addPropertyParser("z", parseNumber);

			// Sprite
			addPropertyParser("buttonMode", parseBoolean);
			addPropertyParser("useHandCursor", parseBoolean);

			// MovieClip
			addPropertyParser("enabled", parseBoolean);
			addPropertyParser("trackAsMenu", parseBoolean);

			// TextField
			addPropertyParser("condenseWhite", parseBoolean);
			addPropertyParser("numLines", parseNumber);
			addPropertyParser("useRichTextClipboard", parseBoolean);
			addPropertyParser("scrollH", parseNumber);
			addPropertyParser("selectionBeginIndex", parseNumber);
			addPropertyParser("selectionBeginIndex", parseNumber);
			addPropertyParser("text", parseDefault);
			addPropertyParser("maxScrollH", parseNumber);
			addPropertyParser("multiline", parseBoolean);
			addPropertyParser("autoSize", parseDefault);
			addPropertyParser("selectedText", parseDefault);
			addPropertyParser("textWidth", parseNumber);
			addPropertyParser("textColor", parseNumber);
			addPropertyParser("htmlText", parseDefault);
			addPropertyParser("scrollV", parseNumber);
			addPropertyParser("backgroundColor", parseNumber);
			addPropertyParser("bottomScrollV", parseNumber);
			addPropertyParser("embedFonts", parseBoolean);
			addPropertyParser("selectedEndIndex", parseNumber);
			addPropertyParser("maxChars", parseNumber);
			addPropertyParser("border", parseBoolean);
			addPropertyParser("background", parseBoolean);
			addPropertyParser("selectable", parseBoolean);
			addPropertyParser("type", parseDefault);
			addPropertyParser("maxScrollV", parseNumber);
			addPropertyParser("thickness", parseNumber);
			addPropertyParser("alwaysShowSelection", parseBoolean);
			addPropertyParser("alwaysShowSelection", parseBoolean);
			addPropertyParser("antiAliasType", parseDefault);
			addPropertyParser("displayAsPassword", parseBoolean);
			addPropertyParser("sharpness", parseNumber);
			addPropertyParser("wordWrap", parseBoolean);
			addPropertyParser("textHeight", parseNumber);
			addPropertyParser("mouseWheelEnabled", parseBoolean);
			addPropertyParser("gridFitType", parseDefault);
			addPropertyParser("caretIndex", parseNumber);
			addPropertyParser("restrict", parseDefault);
			addPropertyParser("borderColor", parseNumber);

			// TextFormat
			addPropertyParser("align", parseDefault);
			addPropertyParser("bold", parseBoolean);
			addPropertyParser("bullet", parseBoolean);
			addPropertyParser("color", parseNumber);
			addPropertyParser("font", parseDefault);
			addPropertyParser("indent", parseNumber);
			addPropertyParser("italic", parseNumber);
			addPropertyParser("kerning", parseBoolean);
			addPropertyParser("leading", parseNumber);
			addPropertyParser("leftMargin", parseNumber);
			addPropertyParser("letterSpacing", parseNumber);
			addPropertyParser("rightMargin", parseNumber);
			addPropertyParser("size", parseNumber);
			addPropertyParser("target", parseDefault);
			addPropertyParser("underline", parseBoolean);
			addPropertyParser("url", parseDefault);

			// StyleSheet
			addPropertyParser("fontFamily", parseDefault);
			addPropertyParser("fontSize", parseNumber);
			addPropertyParser("fontWeight", parseDefault);
			addPropertyParser("fontStyle", parseDefault);
			addPropertyParser("textAlign", parseDefault);
			addPropertyParser("textDecoration", parseDefault);
			addPropertyParser("textIndent", parseNumber);
			addPropertyParser("marginLeft", parseNumber);
			addPropertyParser("marginRight", parseNumber);
			addPropertyParser("letterSpacing", parseNumber);
			addPropertyParser("borderColor", parseNumber);
		}

		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseDefault(value : String) : *
		{
			if (_hasKeyworkd(value)) return _parseKeyword(value);

			return value;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseNumber(value : String) : *
		{
			if (_hasKeyworkd(value)) return _parseKeyword(value);

			if (value.indexOf("#") == 0) return _stringToHexa(value);
			return parseFloat(value.split("px").join(""));
		}

		/**
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseBoolean(value : String) : *
		{
			if (_hasKeyworkd(value)) return _parseKeyword(value);

			return new Boolean(value == "true");
		}

		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initKeywords() : void
		{
			addKeywordParser(PXCSSParserCollection.CLASS_KEYWORD, parseClassReference);
			addKeywordParser(PXCSSParserCollection.FACTORY_KEYWORD, parseCoreFactory);
			addKeywordParser(PXCSSParserCollection.FLASHVAR_KEYWORD, parseFlashvar);
			addKeywordParser(PXCSSParserCollection.INSTANCE_KEYWORD, parseInstance);
			addKeywordParser(PXCSSParserCollection.RESOURCE_KEYWORD, parseResource);
			addKeywordParser(PXCSSParserCollection.FILTER_KEYWORD, parseFilters);
			addKeywordParser(PXCSSParserCollection.COPY_KEYWORD, parseCopy);
			addKeywordParser(PXCSSParserCollection.FUNC_KEYWORD, parseFunc);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseClassReference(value : String) : Class
		{
			var chain : String = value.substring(CLASS_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			try
			{
				return getDefinitionByName(args[0]) as Class;
			}
			catch(e : Error)
			{
			}

			PXDebug.ERROR(CLASS_KEYWORD + " failed. Can't retreive class '" + args + "' in current domain.", this);

			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseInstance(value : String) : *
		{
			var chain : String = value.substring(INSTANCE_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			try
			{
				var cl : String = args.shift();
				return PXCoreFactory.getInstance().buildInstance(cl, args);
			}
			catch(e : Error)
			{
			}

			PXDebug.ERROR(INSTANCE_KEYWORD + " failed '" + args + "'", this);

			return null;
		}
		
		protected function parseFunc(value : String) : *
		{
			var chain : String = value.substring(FUNC_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			var fName : String = args.shift();

			if (_owner.hasCSSMethod(fName))
			{
				try
				{
					return _owner.getCSSMethod(fName).apply(this, args);
				}
				catch(e : Error)
				{
					PXDebug.ERROR("Call to " + fName + "[" + args + "] failed", this);
					return null;	
				}
			}
			
			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseFilters(value : String) : Array
		{
			var chain : String = value.substring(FILTER_KEYWORD.length + 1, value.length - 1);
			
			var defs : Array = chain.split("|");
			var len : uint = defs.length;
			var filters : Array = [];
			
			for (var i : uint = 0; i < len; i++)
			{
				var args : Array = _getArguments(defs[i]);
				try
				{
					var cl : String = args.shift();
					filters.push(PXCoreFactory.getInstance().buildInstance(cl, args));
				}
				catch(e : Error)
				{
					PXDebug.ERROR(FILTER_KEYWORD + " error '" + args + "'", this);
				}
			}
			
			return filters;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseCopy(value : String) : String
		{
			var chain : String = value.substring(COPY_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			if (args[0] != undefined) return "copy:" + args[0];

			PXDebug.ERROR(COPY_KEYWORD + " failed '" + args + "'", this);

			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseResource(value : String) : *
		{
			var chain : String = value.substring(RESOURCE_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			if (args.length > 0)
			{
				try
				{
					var locator : String = args[0] != undefined ? args[0] : null;
					var key : String = args[1];

					if (PXResourceLocator.getInstance(locator).isRegistered(key))
					{
						return PXResourceLocator.getInstance(locator).locate(key);
					}
				}
				catch(e : Error)
				{
				}
			}

			PXDebug.ERROR(RESOURCE_KEYWORD + " failed '" + args + "'", this);

			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseCoreFactory(value : String) : *
		{
			var chain : String = value.substring(FACTORY_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			if (args.length > 0)
			{
				try
				{
					if (PXCoreFactory.getInstance().isRegistered(args[0]))
					{
						return PXCoreFactory.getInstance().locate(args[0]);
					}
				}
				catch(e : Error)
				{
				}
			}

			PXDebug.ERROR(FACTORY_KEYWORD + " failed '" + args + "'", this);

			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function parseFlashvar(value : String) : *
		{
			var chain : String = value.substring(FLASHVAR_KEYWORD.length + 1, value.length - 1);
			var args : Array = _getArguments(chain);

			if (args.length > 0)
			{
				try
				{
					if (PXFlashVars.getInstance().isRegistered(args[0]))
					{
						return PXFlashVars.getInstance().locate(args[0]);
					}
				}
				catch(e : Error)
				{
				}
			}

			PXDebug.ERROR(FLASHVAR_KEYWORD + " failed '" + args + "'", this);

			return null;
		}


		// --------------------------------------------------------------------
		// Private methods
		// --------------------------------------------------------------------

		/** @private */
		private function _hasKeyworkd(value : String) : Boolean
		{
			return _dicoK[_getKeyword(value)] != undefined;
		}

		/** @private */
		private function _parseKeyword(value : String) : *
		{
			var keyword : String = _getKeyword(value);

			if (_dicoK[keyword] != undefined)
			{
				return _dicoK[keyword](value);
			}
			return value;
		}

		/** @private */
		private static function _getKeyword(value : String) : String
		{
			return value.substring(0, value.indexOf("("));
		}

		/** @private */
		private static function _stringToHexa(str : String) : int
		{
			str = str.substr(-6, 6);
			return parseInt(str, 16);
		}

		/** @private */
		private static function _getArguments(arguments : String) : Array
		{
			var args : Array = _split(arguments);

			var array : Array = [];
			var length : Number = args.length;
			var src : String;

			for ( var y : int = 0;y < length;y++ )
			{
				src = _stripSpaces(args[y]);

				if (src == "true" || src == "false")
				{
					array.push(src == "true");
				}
				else
				{
					if (src.charCodeAt(0) == 34 || src.charCodeAt(0) == 39)
					{
						array.push(src.substr(1, src.length - 2));
					}
					else array.push(Number(src));
				}
			}

			return array;
		}

		/** @private */
		private static function _split(sE : String) : Array
		{
			var bool : Boolean = true;
			var args : Array = new Array();
			var length : Number = sE.length;
			var num : Number;
			var src : String = "";
			var char : Number;

			for ( var i : Number = 0;i < length;i++ )
			{
				char = sE.charCodeAt(i);

				if ( bool && (char == 34 || char == 39) )
				{
					bool = false;
					num = char;
				}
				else if ( !bool && num == char )
				{
					bool = true;
					num = undefined;
				}

				if ( char == 44 && bool )
				{
					args.push(src);
					src = '';
				}
				else
				{
					src += sE.substr(i, 1);
				}
			}

			args.push(src);
			return args;
		}

		/** @private */
		private static function _stripSpaces(s : String) : String
		{
			var index : Number = 0;
			while ( index < s.length && s.charCodeAt(index) == 32 ) index++;
			var cpt : Number = s.length - 1;
			while ( cpt > -1 && s.charCodeAt(cpt) == 32 ) cpt--;
			return s.substr(index, cpt - index + 1);
		}
	}
}
