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
	 * The PXXLIFFLanguageBundle class use XLIFF content as bundle content.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXXLIFFLanguageBundle extends PXLanguageBundle
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * Default XLIFF namespace.
		 * 
		 * @default "urn:oasis:names:tc:xliff:document:1.2"
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */
		public static const DEFAULT_XLIFF_NAMESPACE_URI : String = "urn:oasis:names:tc:xliff:document:1.2";
		
		/**
		 * Default identifier attribute in XLIFF content
		 * 
		 * @default "resname"
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */		public static const DEFAULT_XLIFF_REF_ATTRIBUTE : String = "resname";
		
				
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _att : String;
		
		/**
		 * @private
		 */
		private var _ns : Namespace;
		
				
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param data 			XLIFF content
		 * @param bundleID		Language bundle ID
		 * @param keyAttribute	XML attribute name for key identifier
		 * 
		 * @langversion 3.0
	 	 * @playerversion Flash 10
		 */
		public function PXXLIFFLanguageBundle(language : String, data : XML = null, bundleID : String = ID, keyAttribute : String = null, uri : String = null)
		{
			super(language, data, bundleID);
			
			_att = keyAttribute ? keyAttribute : DEFAULT_XLIFF_REF_ATTRIBUTE;
			_ns = new Namespace( uri ? uri : DEFAULT_XLIFF_NAMESPACE_URI);
		}
		
		/**
		 * @inheritDoc
		 */
		final override public function getResource(key : String) : String
		{
			var xml : XML = getXMLContent();
			
			var node : XMLList = xml..*.( hasOwnProperty("@" + _att) && @[_att] == key );
			
			if( node._ns::target.length() > 0 )
			{
				return node._ns::target.toString();
			}
			else if( node._ns::source.length() > 0 )
			{
				return node._ns::source.toString();
			}
			
			return null;
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
			
		/**
		 * @private
		 */
		protected function getXMLContent() : XML
		{
			return content is XML ? content as XML : new XML( String(content));
		}
	}
}
