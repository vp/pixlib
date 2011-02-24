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
	import flash.text.TextFormat;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXTextFormatCSSTransform 
	{
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXTextFormatCSSTransform() : void
		{
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function transform(style : Object) : TextFormat
		{
			var format : TextFormat = new TextFormat();
			
			if(style.blockIndent != null) format.blockIndent = style.blockIndent;
			if(style.textAlign != null && style.textAlign.length > 0) format.align = style.textAlign;
			if(style.fontWeight != null && style.fontWeight == "bold") format.bold = true;
			if(style.color != null) format.color = style.color;
			if(style.fontFamily != null) format.font = style.fontFamily;
			if(style.textIndent != null) format.indent = style.textIndent;
			if(style.fontStyle != null && style.fontStyle == "italic") format.italic = true;
			if(style.leading != null) format.leading = style.leading;
			if(style.marginLeft != null) format.leftMargin = style.marginLeft;
			if(style.letterSpacing != null) format.letterSpacing = style.letterSpacing;
			if(style.marginRight != null) format.rightMargin = style.marginRight;
			if(style.fontSize != null) format.size = style.fontSize;
			if(style.textDecoration != null && style.textDecoration == "underline") format.underline = true;
			
			return format;
		}
	}
}
