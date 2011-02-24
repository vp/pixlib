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
package net.pixlib.load.collection
{
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;

	/**
	 * An event object which carry a <code>PXLoaderCollection</code> object.
	 * 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Romain Ecarnot
	 */
	public class PXLoaderCollectionEvent extends PXLoaderEvent
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/** @copy net.pixlib.load.PXLoaderEvent#onLoadStartEVENT */
		public static const onLoadStartEVENT : String = PXLoaderEvent.onLoadStartEVENT;

		/** @copy net.pixlib.load.PXLoaderEvent#onLoadInitEVENT */
		public static const onLoadInitEVENT : String = PXLoaderEvent.onLoadInitEVENT;

		/** @copy net.pixlib.load.PXLoaderEvent#onLoadProgressEVENT */
		public static const onLoadProgressEVENT : String = PXLoaderEvent.onLoadProgressEVENT;

		/** @copy net.pixlib.load.PXLoaderEvent#onLoadTimeOutEVENT */
		public static const onLoadTimeOutEVENT : String = PXLoaderEvent.onLoadTimeOutEVENT;

		/** @copy net.pixlib.load.PXLoaderEvent#onLoadErrorEVENT */
		public static const onLoadErrorEVENT : String = PXLoaderEvent.onLoadErrorEVENT;

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onItemLoadStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCollectionLoader()</code>
		 *     	</td><td>The loader collection object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getLoader()</code>
		 *     	</td><td>The current loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The current loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onLoadStart
		 */				public static const onItemLoadStartEVENT : String = "onItemLoadStart";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onItemLoadProgress</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCollectionLoader()</code>
		 *     	</td><td>The loader collection object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getLoader()</code>
		 *     	</td><td>The current loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The current loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onItemLoadProgress
		 */	
		public static const onItemLoadProgressEVENT : String = "onItemLoadProgress";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onItemLoadTimeOut</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCollectionLoader()</code>
		 *     	</td><td>The loader collection object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getLoader()</code>
		 *     	</td><td>The current loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The current loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onItemLoadTimeOut
		 */	
		public static const onItemLoadTimeOutEVENT : String = "onItemLoadTimeOut";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onItemLoadError</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCollectionLoader()</code>
		 *     	</td><td>The loader collection object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getLoader()</code>
		 *     	</td><td>The current loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The current loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onItemLoadError
		 */	
		public static const onItemLoadErrorEVENT : String = "onItemLoadError";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onItemLoadInit</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCollectionLoader()</code>
		 *     	</td><td>The loader collection object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getLoader()</code>
		 *     	</td><td>The current loader object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getName()</code>
		 *     	</td><td>The current loader identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onItemLoadInit
		 */	
		public static const onItemLoadInitEVENT : String = "onItemLoadInit";

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Current processing loader.*/
		protected var oCurrentLoader : PXLoader;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns the PXCollectionLoader object carried by this event.
		 * 
		 * @return	The PXCollectionLoader value carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get currentLoader() : PXLoader
		{
			return oCurrentLoader;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>PXCollectionLoaderEvent</code> instance.
		 * 
		 * @param	type			Name of the event type
		 * @param	collection		PXCollectionLoader object carried by this event
		 * @param	errorMessage	(optional) Error message carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXLoaderCollectionEvent( type : String, collection : PXLoaderCollection, loader : PXLoader = null, errorMessage : String = "" )
		{
			super(type, collection, errorMessage);
			
			oCurrentLoader = loader;
		}
	}
}