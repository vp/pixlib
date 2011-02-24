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
	import net.pixlib.events.PXCommandEvent;
	
	use namespace pixlib_GraphicLoader;
	
	use namespace pixlib_FileLoader;
	
	use namespace pixlib_StreamLoader;
	
	use namespace pixlib_XMLLoader;
	
	use namespace pixlib_PluginLoader;
	
	use namespace pixlib_CSSLoader;

	/**
	 * An event object which carry a <code>PXLoader</code> value.
	 * 
	 * @see PXLoader
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *  
	 * @author 	Francis Bourre	 * @author 	Romain Ecarnot
	 */
	public class PXLoaderEvent extends PXCommandEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>loader</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code>
		 *     	</td><td>The loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadStart
		 */		
		public static const onLoadStartEVENT : String = "onLoadStart";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>loader</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code>
		 *     	</td><td>The loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadInit
		 */
		public static const onLoadInitEVENT : String = "onLoadInit";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadProgress</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>loader</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code>
		 *     	</td><td>The loader identifier</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>percentLoaded</code>
		 *     	</td><td>The loading progression</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadProgress
		 */
		public static const onLoadProgressEVENT : String = "onLoadProgress";
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadTimeOut</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>loader</code>
		 *     	</td><td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code>
		 *     	</td><td>The loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadTimeOut
		 */
		public static const onLoadTimeOutEVENT : String = "onLoadTimeOut";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLoadError</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>loader</code></td>
		 *     	<td>The loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>name</code></td>
		 *     	<td>The loader identifier</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>errorMessage</code></td>
		 *     	<td>The loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadError
		 */
		public static const onLoadErrorEVENT : String = "onLoadError";

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */
		protected var oLoader : PXLoader;

		/** @private */
		protected var sErrorMessage : String;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Error message to be carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get errorMessage() : String
		{
			return sErrorMessage;
		}
		
		/**
		 * @private
		 */
		public function set errorMessage(value : String) : void
		{
			sErrorMessage = value.length > 0 ? value : loader + " loading fails with '" + loader.request.url + "'";
		}
		
		/**
		 * The loading progression value of object carried by 
		 * this event.
		 * 
		 * @return	The loading progression value of object carried by 
		 * 			this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get percentLoaded() : Number
		{
			return loader.percentLoaded;
		}
		
		/**
		 * Returns the loader named carried by this event.
		 * 
		 * @return	The loader name carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name() : String
		{
			return loader.name;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Creates a new <code>PXLoaderEvent</code> object.
		 * 
		 * @param	type			Name of the event type
		 * @param	loader			Loader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXLoaderEvent( eventType : String, loader : PXLoader, errorMsg : String = "", bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(eventType, loader, bubbles, cancelable);
			
			oLoader = loader;
			sErrorMessage = errorMsg;
		}

		/**
		 * Returns the loader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get loader() : PXLoader
		{
			return oLoader;
		}

		/**
		 * Returns the PXFileLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		pixlib_FileLoader function get loader() : PXFileLoader
		{
			return oLoader as PXFileLoader;
		}
		
		/**
		 * Returns the PXCSSLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		pixlib_CSSLoader function get loader() : PXCSSLoader
		{
			return oLoader as PXCSSLoader;
		}
		
		/**
		 * Returns the PXGraphicLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		pixlib_GraphicLoader function get loader() : PXGraphicLoader
		{
			return oLoader as PXGraphicLoader;
		}
		
		/**
		 * Returns the PXStreamLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		pixlib_StreamLoader function get loader() : PXStreamLoader
		{
			return oLoader as PXStreamLoader;
		}

		/**
		 * Returns the PXXMLLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		pixlib_XMLLoader function get loader() : PXXMLLoader
		{
			return oLoader as PXXMLLoader;
		}
		
		/**
		 * Returns the PXPluginLoader object carried by this event.
		 * 
		 * @return	The loader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		pixlib_PluginLoader function get loader() : PXPluginLoader
		{
			return oLoader as PXPluginLoader;
		}
	}
}