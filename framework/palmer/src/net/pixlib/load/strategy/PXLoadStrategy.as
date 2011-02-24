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
package net.pixlib.load.strategy
{
	import net.pixlib.load.PXLoader;

	import flash.net.URLRequest;
	import flash.system.LoaderContext;	

	/**
	 * The PXLoadStrategy interface defines rule for loading strategy 
	 * implementation.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	public interface PXLoadStrategy
	{
		/**
		 * Current loaded bytes amount.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get bytesLoaded() : uint;

		/**
		 * Total bytes to load by this strategy.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get bytesTotal() : uint;
		
		/**
		 * The PXLoader owner of this strategy.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function set owner(value : PXLoader) : void;
		
		/**
		 * Loads content.
		 * 
		 * @param	loadingRequest	The absolute or relative URL of the content to load.
		 * @param	loadingContext	(optional) A LoaderContext object, which has properties that define the following: 
		 * <ul>
		 * 	<li>Whether or not to check for the existence of a policy file upon loading the object</li>
		 * 	<li>The ApplicationDomain for the loaded object</li>
		 * 	<li>The SecurityDomain for the loaded object</li>
		 * </ul>
		 *
		 * <p>For complete details, see the description of the properties in the 
		 * <a href="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/flash/system/LoaderContext.html" target="_blank">LoaderContext</a> class.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void;

		/**
		 * Releases loading process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release() : void;
	}
}