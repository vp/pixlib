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
	import net.pixlib.utils.reflect.PXReflectUtil;

	import flash.display.DisplayObject;

	/**
	 * The PXDisplayObjectCSSTransform class apply all compliant CSS style 
	 * properties on a Display Object instance.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXDisplayObjectCSSTransform 
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Applies all style properties on <code>target</code> Display Object.
		 * 
		 * @param target Display Object to modifiy
		 * @param style	Style to apply
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function transform(target : DisplayObject, style : Object) : void
		{
			PXReflectUtil.bindProperties(target, style, true);
			
			if(style.filter) target.filters = style.filter;
		}
	}
}
