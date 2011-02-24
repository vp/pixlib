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

	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * PXLoaderCollection allow to manage multi loading processes.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXLoaderCollection extends PXLoader
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Continue loading process if error has occured.
		 * 
		 * <p><code>true</code> to continue loading process or <code>false</code> 
		 * to stop process when error (or timeout) occured.</p>
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get bypassError( ) : Boolean;

		/** @private */
		function set bypassError( value : Boolean ) : void;

		/**
		 * Amount of loaded loaders in this collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get loadedLoaders( ) : uint;

		/**
		 * Collection loaders count.
		 */
		function get totalLoaders( ) : uint;

		/**
		 * Returns <code>true</code> if loader collection is empty.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get empty( ) : Boolean;
		
		/**
		 * Returns loader who is currently loading.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get currentLoader( ) : PXLoader;
		
		/**
		 * Returns the number of loaders stored in this collection.
		 * 
		 * @return	the number of loaders stored in this collection
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get length() : uint;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Adds new loader in collection.
		 * 
		 * @param	loader			PXLoader instance
		 * @param	id				(optional) Loader identifier		 * @param	loadingRequest	(optional) Loading URL Request		 * @param	loadingContext	(optional) Loading context
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		function add(loader : PXLoader, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : Boolean

		/**
		 * Removes passed-in <code>loader</code> form collection.
		 * 
		 * @param	loader	PXLoader to remove.
		 * 
		 * @return	<code>true</code> if <code>loader</code> was successfully removed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function remove(loader : PXLoader) : Boolean;

		/**
		 * Returns <code>true</code> if the passed-in loader is stored
		 * in this collection.
		 * 
		 * @param	loader Loader object to look at
		 * @return	<code>true</code> if the passed-in loader is stored
		 * 		   	in the collection
		 * 		   	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function contains(loader : PXLoader) : Boolean;

		/**
		 * Returns <code>true</code> if the passed-in loader name is registered 
		 * in this collection.
		 * 
		 * @param	name Loader name to look at
		 * @return	<code>true</code> if the passed-in loader name is stored
		 * 		   	in the collection
		 * 		   	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function isRegistered(key : String) : Boolean

		/**
		 * Returns PXLoader registered with passed-in <code>key</code> in 
		 * collection, either returns <code>null</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function getLoader(key : String) : PXLoader

		/**
		 * Clears loaders collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function clear() : void;

		/**
		 * Adds listener to all collection events.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function addCollectionListener(listener : PXLoaderCollectionListener) : void;

		/**
		 * Removes listener from all collection events.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function removeCollectionListener(listener : PXLoaderCollectionListener) : void;
	}
}
