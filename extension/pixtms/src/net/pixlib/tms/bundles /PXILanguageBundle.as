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
package net.pixlib.tms.bundles
{
	/**
	 * The PXILanguageBundle interface defines behaviour for all concrete 
	 * localization bundle implementations.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public interface PXILanguageBundle
	{
		/**
		 * Bundle's language.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get language() : String;
		
		/**
		 * @private
		 */
		function set language(value : String) : void;
		
		/**
		 * Bundle's name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get id() : String;
				
		/**
		 * Bundle data content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get content() : Object;

		/**
		 * @private
		 */
		function set content(data : Object) : void;

		/**
		 * Returns <code>true</code> if resource registered with 
		 * passed-in key in current bundle.
		 * 
		 * @param key	Resource identifier to search
		 * 
		 * @return <code>true</code> if resource registered with 
		 * passed-in key in current bundle.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function hasResource(key : String) : Boolean;

		/**
		 * Returns resource registered with passed-in key in current bundle.
		 * 
		 * @param key	Resource identifier to search
		 * 
		 * @return resource registered with passed-in key in current bundle.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function getResource(key : String) : String;
	}
}
