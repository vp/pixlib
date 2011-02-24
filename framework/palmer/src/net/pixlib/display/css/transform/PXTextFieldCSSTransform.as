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
package net.pixlib.display.css.transform 
{
	import net.pixlib.commands.PXDelegate;
	import net.pixlib.utils.reflect.PXReflectUtil;

	import flash.filters.BlurFilter;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXTextFieldCSSTransform
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function transform(field : TextField, format : TextFormat, style : Object, beginIndex : int = -1, endIndex : int = -1) : void
		{
			PXReflectUtil.bindProperties(field, style, true);
			
			field.embedFonts = Font.enumerateFonts().filter(PXDelegate.create(_isEmbed, format.font)).length > 0;
			field.antiAliasType = AntiAliasType.ADVANCED;
			
			if(style.backgroundColor != null)
			{
				field.background = true;
				field.backgroundColor = style.backgroundColor;
			} 
			else field.background = false;
			
			if(style.borderColor != null)
			{
				field.border = true;
				field.borderColor = style.borderColor;
			} 
			else field.border = false;
			
			if(style.filter)
			{
				field.filters = style.filter;
			}
			else if(!field.embedFonts) field.filters = field.filters.concat([new BlurFilter(0, 0, 0)]);
			
			field.defaultTextFormat = format;
			field.setTextFormat(format, beginIndex, endIndex);
		}

		
		//--------------------------------------------------------------------
		// Private methods
		//--------------------------------------------------------------------
		
		/** @private */
		private static function _isEmbed( element : *, index : int, list : Array, testedFont : String ) : Boolean
		{
			return (element.fontName == testedFont );
		}
	}
}
