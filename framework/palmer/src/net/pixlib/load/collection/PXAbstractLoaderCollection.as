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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXUnimplementedMethodException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;
	import net.pixlib.load.PXAbstractLoader;
	import net.pixlib.load.PXGraphicLoader;
	import net.pixlib.load.PXLoader;
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.PXLoaderLocator;
	import net.pixlib.load.strategy.PXLoadStrategy;
	import net.pixlib.log.PXDebug;
	import net.pixlib.utils.PXHashCode;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 *  Dispatched when an item of collection loading starts.
	 *  
	 *  @eventType net.pixlib.load.collection.PXLoaderCollectionEvent.onItemLoadStartEVENT
	 */
	[Event(name="onItemLoadStart", type="net.pixlib.load.collection.PXLoaderCollectionEvent")]
	/**
	 *  Dispatched during loading progression.
	 *  
	 *  @eventType net.pixlib.load.collection.PXLoaderCollectionEvent.onItemLoadProgressEVENT
	 */
	[Event(name="onItemLoadProgress", type="net.pixlib.load.collection.PXLoaderCollectionEvent")]
	/**
	 *  Dispatched when a tiemout occurs during item loading process.
	 *  
	 *  @eventType net.pixlib.load.collection.PXLoaderCollectionEvent.onItemLoadTimeOutEVENT
	 */
	[Event(name="onItemLoadTimeOut", type="net.pixlib.load.collection.PXLoaderCollectionEvent")]
	/**
	 *  Dispatched when an error occurs during item loading process.
	 *  
	 *  @eventType net.pixlib.load.collection.PXLoaderCollectionEvent.onItemLoadErrorEVENT
	 */
	[Event(name="onItemLoadError", type="net.pixlib.load.collection.PXLoaderCollectionEvent")]
	/**
	 *  Dispatched when an item of collection is loaded.
	 *  
	 *  @eventType net.pixlib.load.collection.PXLoaderCollectionEvent.onItemLoadInitEVENT
	 */
	[Event(name="onItemLoadInit", type="net.pixlib.load.collection.PXLoaderCollectionEvent")]
	/**
	 * Abstract implementation for PXLoaderCollection object.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Michael Barbero
	 */
	public class PXAbstractLoaderCollection extends PXAbstractLoader implements PXLoaderCollection
	{
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		
		/** Current loader index. */
		protected var nIndex : int;
		
		/** Current target loader. */
		protected var oCurrentLoader : PXLoader;
		
		/** Amount of successfully loader loaded. */
		protected var nSuccess : uint;
		
		/**
		 *  Stores the bypass error behaviour.
		 *  
		 *  @see CollectionLoader#bypassError
		 */
		protected var bByPassError : Boolean;
		
		/** private */
		protected var bProcessing : Boolean;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		final public function get bypassError() : Boolean
		{
			return bByPassError;
		}

		/** @private */
		final public function set bypassError(value : Boolean) : void
		{
			if ( !running )
			{
				bByPassError = value;
			}
			else
			{
				PXDebug.WARN("bypassError can't be set when loader is running.", this);
			}
		}

		/**
		 * @inheritDoc
		 */
		final public function get loadedLoaders() : uint
		{
			return nSuccess;
		}

		/**
		 * @inheritDoc
		 */
		final public function get totalLoaders() : uint
		{
			return length;
		}

		/**
		 * @inheritDoc
		 */
		final override public function get percentLoaded() : Number
		{
			if (loaded)
			{
				return 100;
			}
			else
			{
				var num : Number = Math.min(100, Math.ceil(nIndex / ( length / 100 )));
				return ( isNaN(num) ) ? 0 : num;
			}
		}

		/**
		 * @private
		 */
		final override public function get strategy() : PXLoadStrategy
		{
			throw new PXUnsupportedOperationException(".strategy is not supported.", this);
			return null;
		}

		/**
		 * @private
		 */
		final override public function set context(context : LoaderContext) : void
		{
			throw new PXUnsupportedOperationException(".context is not supported.", this);
		}

		/**
		 * @private
		 */
		final override public function get context() : LoaderContext
		{
			throw new PXUnsupportedOperationException(".context is not supported.", this);
			return null;
		}

		/**
		 * @private
		 */
		final override public function get bytesLoaded() : uint
		{
			throw new PXUnsupportedOperationException(".bytesLoaded is not supported.", this);
			return 0;
		}

		/**
		 * @private
		 */
		final override public function get bytesTotal() : uint
		{
			throw new PXUnsupportedOperationException(".bytesTotal is not supported.", this);
			return 0;
		}

		/**
		 * @private
		 */
		final override public function get request() : URLRequest
		{
			throw new PXUnsupportedOperationException(".request is not supported.", this);
			return null;
		}

		/**
		 * @private
		 */
		final override public function set request(value : URLRequest) : void
		{
			throw new PXUnsupportedOperationException(".request is not supported.", this);
		}

		/**
		 * @private
		 */
		final override public function get content() : Object
		{
			throw new PXUnsupportedOperationException(".content is not supported.", this);

			return null;
		}

		/**
		 * @private
		 */
		final override public function set content(value : Object) : void
		{
			throw new PXUnsupportedOperationException(".content is not supported.", this);
		}

		/**
		 * @inheritDoc
		 */
		final public function get currentLoader() : PXLoader
		{
			return oCurrentLoader;
		}

		/**
		 * @inheritDoc
		 */
		public function get length() : uint
		{
			throw new PXUnimplementedMethodException(".length must be implemented in concrete class.", this);

			return 0;
		}

		/**
		 * @inheritDoc
		 */
		final public function get empty() : Boolean
		{
			return length == 0;
		}

		/**
		 * @inheritDoc
		 */
		final override public function get loaded() : Boolean
		{
			return nSuccess == length;
		}

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**
		 * @private
		 */
		function PXAbstractLoaderCollection()
		{
			super();

			bByPassError = true;

			clear();
		}

		/**
		 * @inheritDoc
		 */
		public function add(loader : PXLoader, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : Boolean
		{
			throw new PXUnimplementedMethodException(".add(" + loader + ") must be implemented in concrete class.", this);

			return false;
		}

		/**
		 * @inheritDoc
		 */
		final public function contains(loader : PXLoader) : Boolean
		{
			for ( var i : uint = 0;i < length;i++ )
			{
				if ( getLoaderAt(i) == loader ) return true;
			}

			return false;
		}

		/**
		 * @inheritDoc
		 */
		final public function isRegistered(key : String) : Boolean
		{
			for ( var i : uint = 0;i < length;i++ )
			{
				if ( getLoaderAt(i).name === key ) return true;
			}

			return false;
		}

		/**
		 * @inheritDoc
		 */
		final public function getLoader(key : String) : PXLoader
		{
			for ( var i : uint = 0;i < length;i++ )
			{
				if ( getLoaderAt(i).name === key ) return getLoaderAt(i) ;
			}

			return null;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(loader : PXLoader) : Boolean
		{
			throw new PXUnimplementedMethodException(".remove(" + loader + ") must be implemented in concrete class.", this);

			return false;
		}

		/**
		 * @inheritDoc
		 */
		final override public function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			if ((loadingRequest != null) || (loadingContext != null))
			{
				PXDebug.WARN(".load() arguments are not used in this implementation", this);
			}

			execute();
		}

		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			clearCollection();

			nIndex = -1;

			super.release();
		}

		/**
		 * @inheritDoc
		 */
		final public function clear() : void
		{
			if ( !running )
			{
				clearCollection();

				nIndex = -1;
				nSuccess = 0;
				oCurrentLoader = null;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function addCollectionListener(listener : PXLoaderCollectionListener) : void
		{
			addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeCollectionListener(listener : PXLoaderCollectionListener) : void
		{
			removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		override public function toString() : String
		{
			return super.toString() + " [" + length + "]";
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**
		 * @inheritDoc
		 */
		final override protected function onExecute(e : Event = null) : void
		{
			startProcess();

			if ( !empty )
			{
				checkNextLoader();
			}
			else fireOnLoadInitEvent();
		}

		/**
		 * Adds passed-in loader at index position in collection.
		 * 
		 * @param	index		Index for insertion (must be valid)
		 * @param	loader		PXLoader to add
		 * 
		 * @return	<code>true</code> if <code>command</code> was successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function addAt(index : uint, loader : PXLoader, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : Boolean
		{
			if ( !running )
			{
				if ( loader == null ) return false;

				loader.name = key != null ? key : loader.name != null ? loader.name : PXHashCode.getKey(loader);

				if ( loadingRequest )
				{
					loader.request = loadingRequest;
					if ( loadingContext && loader is PXGraphicLoader ) ( loader as PXGraphicLoader ).context = loadingContext;
				}
				else if ( !loader.request.url )
				{
					PXDebug.WARN(".addAt() failed, you passed Loader argument without any url property.", this);
					return false;
				}

				pushLoader(loader, index);

				return true;
			}
			else
			{
				PXDebug.WARN(".addAt() failed, loader can't be added when collection is running.", this);
			}

			return false;
		}

		/**
		 * Inserts passed-in PXLoader in collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function pushLoader(loader : PXLoader, index : int) : void
		{
			throw new PXUnimplementedMethodException(".pushLoader(" + loader + "," + index + ") must be implemented in concrete class.", this);
		}

		/**
		 * Returns PXLoader at passed-in <code>index</code> in collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getLoaderAt(index : uint) : PXLoader
		{
			throw new PXUnimplementedMethodException(".getLoaderAt(" + index + ") must be implemented in concrete class.", this);

			return null;
		}

		/**
		 * Returns passed-in <code>loader</code> index in collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getLoaderIndex(loader : PXLoader) : int
		{
			for ( var i : uint = 0;i < length ;i++ )
			{
				if ( getLoaderAt(i) == loader ) return i;
			}

			return -1;
		}

		/**
		 * Fires collection event.
		 * 
		 * @param	type 			Event type to disptach
		 * @param	loader			Event target loader
		 * @param 	errorMessage	Error message if exist
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function fireCollectionEventType(type : String, loader : PXLoader = null, errorMessage : String = "") : void
		{
			fireEvent(getLoaderCollectionEvent(type, loader, errorMessage));
		}

		/**
		 * Returns <code>PXLoaderCollectionEvent</code> instance usgin passed-in parameters.
		 * 
		 * @param	type 			Event type to disptach
		 * @param	loader			Event target loader
		 * @param 	errorMessage	Error message if exist
		 * 
		 * @return <code>PXLoaderCollectionEvent</code> instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function getLoaderCollectionEvent(type : String, loader : PXLoader = null, errorMessage : String = "") : PXLoaderEvent
		{
			return new PXLoaderCollectionEvent(type, this, loader, errorMessage);
		}

		/**
		 * Adds listeners to passed-in Loader.
		 * 
		 * @param	loader	Loader objet to listen
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function addLoaderListeners(loader : PXLoader) : void
		{
			if ( loader != null )
			{
				loader.addEventListener(PXLoaderEvent.onLoadStartEVENT, onLoaderLoadStart);
				loader.addEventListener(PXLoaderEvent.onLoadProgressEVENT, onLoaderLoadProgress);
				loader.addEventListener(PXLoaderEvent.onLoadInitEVENT, onLoaderLoadInit);
				loader.addEventListener(PXLoaderEvent.onLoadTimeOutEVENT, onLoaderLoadTimeOut);
				loader.addEventListener(PXLoaderEvent.onLoadErrorEVENT, onLoaderLoadError);
			}
		}

		/**
		 * Removes listeners from passed-in Loader.
		 * 
		 * @param	loader	Loader objet to forget
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function removeLoaderListeners(loader : PXLoader) : void
		{
			if ( loader != null )
			{
				loader.removeEventListener(PXLoaderEvent.onLoadStartEVENT, onLoaderLoadStart);
				loader.removeEventListener(PXLoaderEvent.onLoadProgressEVENT, onLoaderLoadProgress);
				loader.removeEventListener(PXLoaderEvent.onLoadInitEVENT, onLoaderLoadInit);
				loader.removeEventListener(PXLoaderEvent.onLoadTimeOutEVENT, onLoaderLoadTimeOut);
				loader.removeEventListener(PXLoaderEvent.onLoadErrorEVENT, onLoaderLoadError);
			}
		}

		/**
		 * @private
		 */
		protected function onLoaderLoadStart(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadStartEVENT, oCurrentLoader);
		}

		/**
		 * @private
		 */
		protected function onLoaderLoadProgress(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadProgressEVENT, oCurrentLoader);
		}

		/**
		 * @private
		 */
		protected function onLoaderLoadInit(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadInitEVENT, oCurrentLoader);
			
			nSuccess++;

			checkNextLoader();
		}

		/**
		 * @private
		 */
		protected function onLoaderLoadTimeOut(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR(".onLoaderLoadTimeOut() for " + event.loader.request.url, this);

			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadTimeOutEVENT, oCurrentLoader);

			if ( bypassError )
			{
				checkNextLoader();
			}
			else
			{
				removeLoaderListeners(event.loader);
				fireOnLoadTimeOut();
			}
		}

		/**
		 * @private
		 */
		protected function onLoaderLoadError(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR(".onLoaderLoadError() for " + event.loader.request.url + "[" + event.errorMessage + "]", this);

			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadErrorEVENT, oCurrentLoader);

			if ( bypassError )
			{
				checkNextLoader();
			}
			else
			{
				removeLoaderListeners(event.loader);
				fireOnLoadErrorEvent();
			}
		}

		/**
		 * Clears collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function clearCollection() : void
		{
			throw new PXUnimplementedMethodException(".clearCollection() must be implemented in concrete class.", this);
		}

		/**
		 * @private
		 */
		protected function startProcess() : void
		{
			fireOnLoadStartEvent();
		}

		/**
		 * Checks if a next loader is available.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function checkNextLoader() : void
		{
			removeLoaderListeners(oCurrentLoader);

			if ( nIndex + 1 < length )
			{
				nIndex++;

				startNextLoader();
			}
			else
			{
				fireOnLoadProgressEvent();
				fireOnLoadInitEvent();
			}
		}

		/**
		 * Executes next loader, if available.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function startNextLoader() : void
		{
			oCurrentLoader = getLoaderAt(nIndex);
			
			if ( !oCurrentLoader.request )
			{
				var msg : String = " encounters PXLoader instance without url property, load fails : " + oCurrentLoader.name;
				PXDebug.ERROR(msg, this);

				if (bypassError)
				{
					checkNextLoader();
				}
				else
				{
					fireOnLoadErrorEvent("PXLoader '" + oCurrentLoader.name + "' has no url property");
					return;
				}
			}
			if ( anticache ) oCurrentLoader.anticache = true;
			if ( sPrefixURL ) oCurrentLoader.prefix = sPrefixURL;

			fireOnLoadProgressEvent();

			addLoaderListeners(oCurrentLoader);
			oCurrentLoader.execute();
		}

		/**
		 * @inheritDoc
		 */
		override protected function getLoaderEvent(type : String, errorMessage : String = "") : PXLoaderEvent
		{
			return new PXLoaderCollectionEvent(type, this, null, errorMessage);
		}

		/**
		 * @inheritDoc
		 */
		override protected function onInitialize() : void
		{
			if ( !empty && (oCurrentLoader != null) ) fireEventType(PXLoaderEvent.onLoadProgressEVENT);
			fireEventType(PXLoaderEvent.onLoadInitEVENT);
		}
	}
}