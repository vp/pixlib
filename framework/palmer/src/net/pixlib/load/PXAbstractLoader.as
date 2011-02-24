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
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.events.PXCommandEvent;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.load.strategy.PXLoadStrategy;
	import net.pixlib.log.PXDebug;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;


	/**
	 * Dispatched when loader starts loading.
	 *  
	 * @eventType net.pixlib.load.PXLoaderEvent.onLoadStartEVENT
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onLoadStart", type="net.pixlib.load.PXLoaderEvent")]

	/**
	 * Dispatched when loading is finished.
	 *  
	 * @eventType net.pixlib.load.PXLoaderEvent.onLoadInitEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onLoadInit", type="net.pixlib.load.PXLoaderEvent")]

	/**
	 * Dispatched during loading progression.
	 *  
	 * @eventType net.pixlib.load.PXLoaderEvent.onLoadProgressEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onLoadProgress", type="net.pixlib.load.PXLoaderEvent")]

	/**
	 * Dispatched when a timeout occurs during loading.
	 *  
	 * @eventType net.pixlib.load.PXLoaderEvent.onLoadTimeOutEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onLoadTimeOut", type="net.pixlib.load.PXLoaderEvent")]

	/**
	 * Dispatched when an error occurs during loading.
	 *  
	 * @eventType net.pixlib.load.PXLoaderEvent.onLoadErrorEVENT
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	[Event(name="onLoadError", type="net.pixlib.load.PXLoaderEvent")]

	/**
	 * The PXAbstractLoader class offer basic implementation for Pixlib 
	 * Loading API.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	public class PXAbstractLoader extends PXAbstractCommand implements PXLoader
	{
		/**
		 * @private
		 * Stores Loader instance.
		 */
		static private var _oPool : Dictionary = new Dictionary();

		/**
		 * @private
		 * 
		 * Allow to avoid gc on local loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static protected function registerLoaderToPool(loader : PXLoader) : void
		{
			if ( _oPool[ loader ] == null )
			{
				_oPool[ loader ] = true;
			}
			else
			{
				PXDebug.WARN(loader + " is already registered in the loading pool", PXAbstractLoader);
			}
		}

		/**
		 * @private 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static protected function unregisterLoaderFromPool(loader : PXLoader) : void
		{
			if ( _oPool[ loader ] != null )
			{
				delete _oPool[ loader ];
			}
			else
			{
				PXDebug.WARN(loader + " is not registered in the loading pool", PXAbstractLoader);
			}
		}


		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------

		/**
		 * Loader identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sName : String;

		/**
		 * URLRequest of content to be loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oRequest : URLRequest;

		/**
		 * @private
		 * URL (string) of content to be loaded
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sURL : String;

		/**
		 * Stores anticache state.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bAntiCache : Boolean;

		/**
		 * Stores URL prefix pattern.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sPrefixURL : String;

		/**
		 * Stores concrete loading strategy to use for 
		 * current loading process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oLoadStrategy : PXLoadStrategy;

		/**
		 * Stores LoaderContext to use for loading process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oContext : LoaderContext;

		/**
		 * Stores loaded content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oContent : Object;

		/**
		 * Stores last value of loaded bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nLastBytesLoaded : Number;

		/**
		 * Indicates if loader instance must be registered into pool.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bMustUnregister : Boolean;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get strategy() : PXLoadStrategy
		{
			return oLoadStrategy;
		}

		/**
		 * @inheritDoc
		 */
		public function get context() : LoaderContext
		{
			return oContext;
		}

		/**
		 * @private
		 */
		public function set context(value : LoaderContext) : void
		{
			oContext = value;
		}

		/**
		 * @copy net.pixlib.load.strategy.PXLoadStrategy#bytesLoaded
		 */
		public function get bytesLoaded() : uint
		{
			return oLoadStrategy.bytesLoaded;
		}

		/**
		 * @copy net.pixlib.load.strategy.PXLoadStrategy#bytesTotal
		 */
		public function get bytesTotal() : uint
		{
			return oLoadStrategy.bytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function get percentLoaded() : Number
		{
			var num : Number = Math.min(100, Math.ceil(bytesLoaded / ( bytesTotal / 100 )));
			return ( isNaN(num) ) ? 0 : num;
		}

		/**
		 * @inheritDoc
		 */
		public function get request() : URLRequest
		{
			if (oRequest.data != null && oRequest.method == URLRequestMethod.GET)
			{
				if (bAntiCache) oRequest.data.nocache = _getStringTimeStamp();

				oRequest.url = sPrefixURL + sURL;
			}
			else
			{
				oRequest.url = bAntiCache ? sPrefixURL + sURL + "?nocache=" + _getStringTimeStamp() : sPrefixURL + sURL;
			}
			return oRequest;
		}

		/**
		 * @private
		 */
		public function set request(value : URLRequest) : void
		{
			oRequest = value;
			sURL = oRequest.url;
		}

		/**
		 * @inheritDoc
		 */
		public function get name() : String
		{
			return sName;
		}

		/**
		 * @private
		 */
		public function set name(value : String) : void
		{
			if(sName && PXLoaderLocator.getInstance().isRegistered(sName))
			{
				bMustUnregister = false;
				PXLoaderLocator.getInstance().unregister(sName);
			}
			
			sName = value;
			
			if (sName != null)
			{
				if ( !(PXLoaderLocator.getInstance().isRegistered(sName)) )
				{
					bMustUnregister = true;
					PXLoaderLocator.getInstance().register(sName, this);
				}
				else
				{
					bMustUnregister = false;
					var msg : String = "Can't be registered to " + PXLoaderLocator.getInstance() + " with '" + sName + "' name. This name already exists.";
					fireOnLoadErrorEvent(msg);
					throw new PXIllegalArgumentException(msg, this);
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get anticache() : Boolean
		{
			return bAntiCache;
		}

		/**
		 * @private
		 */
		public function set anticache(value : Boolean) : void
		{
			bAntiCache = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get prefix() : String
		{
			return sPrefixURL;
		}

		/**
		 * @private
		 */
		public function set prefix(value : String) : void
		{
			sPrefixURL = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get content() : Object
		{
			return oContent;
		}

		/**
		 * @private
		 */
		public function set content(value : Object) : void
		{
			oContent = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get loaded() : Boolean
		{
			return (bytesLoaded / bytesTotal) == 1 ;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * @private
		 * 
		 * @param	strategy	Loading strategy to use in this loader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXAbstractLoader(strategy : PXLoadStrategy = null)
		{
			super();

			oEB.setListenerType(PXLoaderListener);

			oLoadStrategy = (strategy != null) ? strategy : new NullLoadStrategy();
			oLoadStrategy.owner = this;

			bAntiCache = false;
			sPrefixURL = "";
			oContext = new LoaderContext(false, ApplicationDomain.currentDomain);
		}

		/**
		 * @inheritDoc
		 */
		public function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			if (loadingRequest) request = loadingRequest;
			if (loadingContext) context = loadingContext;

			execute();
		}

		/**
		 * @inheritDoc
		 */
		public function addListener(listener : PXLoaderListener) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener(listener : PXLoaderListener) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * Releases instance and all registered listeners.
		 * 
		 * <p>When loader is released, it's unregistered 
		 * from PXLoaderLocator too.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function release() : void
		{
			if ( bMustUnregister )
			{
				PXLoaderLocator.getInstance().unregister(name);
				bMustUnregister = false;
			}

			oLoadStrategy.release();
			oEB.removeAllListeners();
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadStartEvent() : void
		{
			fireEventType(PXLoaderEvent.onLoadStartEVENT);
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadProgressEvent() : void
		{
			fireEventType(PXLoaderEvent.onLoadProgressEVENT);
		}

		/**
		 * @inheritDoc
		 */
		final public function fireOnLoadInitEvent() : void
		{
			onInitialize();
			
			fireCommandEndEvent();
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadErrorEvent(message : String = "") : void
		{
			fireEventType(PXLoaderEvent.onLoadErrorEVENT, message);
			fireCommandEndEvent();
		}

		/**
		 * @inheritDoc
		 */
		public function fireOnLoadTimeOut() : void
		{
			fireEventType(PXLoaderEvent.onLoadTimeOutEVENT);
			fireCommandEndEvent();
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * Triggered when content is loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onInitialize() : void
		{
			fireEventType(PXLoaderEvent.onLoadProgressEVENT);
			fireEventType(PXLoaderEvent.onLoadInitEVENT);
		}

		/**
		 * @copy net.pixlib.events.PXEventBroadcaster#setListenerType()
		 */
		final protected function setListenerType(type : Class) : void
		{
			oEB.setListenerType(type);
		}

		/**
		 * Dispatches event using passed-in type and optional error message.
		 * 
		 * @param	type			Event type so dispatch
		 * @param	errorMessage	(optional) Error message to carry
		 * 
		 * @see #fireEvent()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireEventType(type : String, errorMessage : String = "") : void
		{
			fireEvent(getLoaderEvent(type, errorMessage));
		}

		/**
		 * Dispatched passed-in event to all registered listeners.
		 * 
		 * @param	e	Event to dispatch
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function fireEvent(e : Event) : void
		{
			oEB.broadcastEvent(e);
		}

		/**
		 * Returns a loader event for current loader instance.
		 * 
		 * @return A loader event for current loader instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getLoaderEvent(type : String, errorMessage : String = "") : PXLoaderEvent
		{
			return new PXLoaderEvent(type, this, errorMessage);
		}

		/**
		 * @copy #load()
		 */
		override protected function onExecute(event : Event = null) : void
		{
			if ( request.url.length > 0 )
			{
				nLastBytesLoaded = 0;
				oLoadStrategy.load(request, context);
			}
			else
			{
				throw new PXNullPointerException("load() can't retrieve file url.", this);
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCancel() : void
		{
			release();
		}

		/**
		 * @inheritDoc
		 */
		override protected function broadcastCommandStartEvent() : void
		{
			registerLoaderToPool(this);
			fireEventType(PXCommandEvent.onCommandStartEVENT);
		}

		/**
		 * @inheritDoc
		 */
		override protected function broadcastCommandEndEvent() : void
		{
			fireEventType(PXCommandEvent.onCommandEndEVENT);
			unregisterLoaderFromPool(this);
		}

		/**
		 * @private
		 */
		private function _getStringTimeStamp() : String
		{
			var date : Date = new Date();
			return String(date.getTime());
		}
	}
}

import net.pixlib.load.PXLoader;
import net.pixlib.load.strategy.PXLoadStrategy;

import flash.net.URLRequest;
import flash.system.LoaderContext;

internal class NullLoadStrategy implements PXLoadStrategy
{
	public function load(request : URLRequest = null, context : LoaderContext = null) : void
	{
	}

	public function get bytesLoaded() : uint
	{
		return 0;
	}

	public function get bytesTotal() : uint
	{
		return 0;
	}

	public function set owner(value : PXLoader) : void
	{
	}

	public function release() : void
	{
	}
}