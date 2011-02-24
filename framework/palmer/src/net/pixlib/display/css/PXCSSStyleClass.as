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
	import net.pixlib.core.PXValueObject;
	
	/**
	 * The PXCSSStyleClass represent default dynamic CSS Style instance.
	 * 
	 * <p>Feel free to override it to allow strong typing features using 
	 * your own CSS Style. Class must be dynamic.</p>
	 * 
	 * @example CSS File
	 * <listing>
	 * 
	 * .myclass
	 * {
	 * 	StyleClassAlias: com.project.vo.MyCustomStyle
	 * 	
	 * 	color: #00FF00;
	 * }
	 * </listing>
	 * 
	 * @example CSS VO Style
	 * <listing>
	 * 
	 * package com.project
	 * {
	 * 	dynamic public class MyCustomStyle extends PXCSSStyleClass
	 * 	{
	 * 		public var color : uint;
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	dynamic public class PXCSSStyleClass implements PXValueObject
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCSSStyleClass() 
		{
			
		}
	}
}