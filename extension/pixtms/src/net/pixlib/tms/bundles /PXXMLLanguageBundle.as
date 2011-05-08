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
	 * The PXXMLLanguageBundle class use XML content as bundle content.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXXMLLanguageBundle extends PXLanguageBundle
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _att : String;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param data 			XML content
		 * @param bundleID		Language bundle ID
		 * @param keyAttribute	XML attribute name for key identifier
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */
		public function PXXMLLanguageBundle(language : String, data : XML = null, bundleID : String = ID, keyAttribute : String = "id")
		{
			super(language, data, bundleID);
			
			_att = keyAttribute;
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function getResource(key : String) : String
		{
			var xml : XML = getXMLContent();
			var node : XMLList = xml..*.( hasOwnProperty("@" + _att) && @[_att] == key );
			
			if(node && node.toString().length > 0) return node.toString();
			else return null;
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
			
		/**
		 * @private
		 */
		protected function getXMLContent() : XML
		{
			return content is XML ? content as XML : new XML(content);
		}
	}
}
