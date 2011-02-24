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
package net.pixlib.load
{

	/**
	 * The PXXMLLoader class allow to load xml content.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var loader : PXXMLLoader = new PXXMLLoader(  );
	 * loader.addEventListener( PXLoaderEvent.onLoadInitEVENT, onLoaded );
	 * loader.load( new URLRequest( "content.xml" ) );
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	public class PXXMLLoader extends PXFileLoader
	{
		/**
		 * The loaded XML content.
		 * 
		 * @return	XML content
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get xml() : XML
		{
			return XML(content);
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXXMLLoader(key : String = null)
		{
			super(PXFileLoader.TEXT, key);
		}
	}
}