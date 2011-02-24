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
	import net.pixlib.load.strategy.PXURLLoaderStrategy;

	/**
	 * The PXFileLoader class allow to load text, binary or variables data 
	 * format from passed-in file.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var loader : PXFileLoader = new PXFileLoader( PXFileLoader.BINARY );
	 * loader.addEventListener( PXLoaderEvent.onLoadInitEVENT, onLoaded );
	 * loader.load( new URLRequest( "logo.swf" );
	 * 
	 * function onLoaded( event : PXLoaderEvent ) :void
	 * {
	 * 	var content : ByteArray = event.pixlib_FileLoader::loader.content as ByteArray;
	 * }
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 * @author	Romain Ecarnot
	 */
	public class PXFileLoader extends PXAbstractLoader
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
				
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static const BINARY : String = PXURLLoaderStrategy.BINARY;

		/**
		 * Specifies that downloaded data is received as text.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		public static const TEXT : String = PXURLLoaderStrategy.TEXT;

		/**
		 * Specifies that downloaded data is received as URL-encoded variables.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		public static const VARIABLES : String = PXURLLoaderStrategy.VARIABLES;

		
		/**
		 * Indicates how the downloaded data is received.
		 * 
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.TEXT</code>, 
		 * the received data is a string containing the text of 
		 * the loaded file.</p>
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.BINARY</code>, the received data is 
		 * a ByteArray object containing the raw binary data.</p>
		 * <p>If the value of the dataFormat property is 
		 * <code>URLLoaderDataFormat.VARIABLES</code>, the received data is 
		 * a URLVariables object containing the URL-encoded variables.</p>
		 * 
		 * <p>The default is <code>PXURLLoaderStrategy.TEXT</code></p>
		 * 
		 * @param	value	Downloaded data format
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set dataFormat( value : String ) : void
		{
			PXURLLoaderStrategy(strategy).dataFormat = value;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param	dataFormat	(optional) Downloaded data format.		 * @param	key			(optional) Loader identifier.
		 * 
		 * @see #dataFormat
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXFileLoader(dataFormat : String = null, key : String = null)
		{
			super(new PXURLLoaderStrategy(dataFormat));
			
			name = key;
		}
	}
}