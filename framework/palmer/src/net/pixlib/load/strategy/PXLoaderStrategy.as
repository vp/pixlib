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
	import net.pixlib.log.PXStringifier;

	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * @author Francis Bourre
	 */
	final public class PXLoaderStrategy implements PXLoadStrategy
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var oOwner : PXLoader;

		/** @private */	
		protected var oLoader : Loader;

		/** @private */	
		protected var nBytesLoaded : uint;

		/** @private */	
		protected var nBytesTotal : uint;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get bytesLoaded() : uint
		{
			return nBytesLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get bytesTotal() : uint
		{
			return nBytesTotal;
		}

		/**
		 * @inheritDoc
		 */
		public function set owner(value : PXLoader) : void
		{
			oOwner = value;
		}
		
		/**
		 * Returns informations about loaded content.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get contentLoaderInfo() : LoaderInfo
		{
			return oLoader.contentLoaderInfo;
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
		public function PXLoaderStrategy()
		{
			nBytesLoaded = 0;
			nBytesTotal = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			initLoaderStrategy();
			
			oLoader.load(loadingRequest, loadingContext);
		}

		/**
		 * Loads from binary data stored in a ByteArray object. 
		 * 
		 * @param	bytes	A ByteArray object.
		 * @param	context	A LoaderContext object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function loadBytes(bytes : ByteArray, loadingContext : LoaderContext = null) : void
		{
			initLoaderStrategy();
			
			oLoader.loadBytes(bytes, loadingContext);
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			if ( oLoader ) 
			{
				oLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				oLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCompleteHandler);
				oLoader.contentLoaderInfo.removeEventListener(Event.OPEN, onOpenHandler);
				oLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				oLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
				oLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				oLoader.contentLoaderInfo.removeEventListener(Event.UNLOAD, onUnLoadHandler);

				try 
				{
					oLoader.unloadAndStop();
					oLoader.close();
				} catch( error : Error ) 
				{
				}
			}
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initLoaderStrategy() : void
		{
			oLoader = new Loader();
			oLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			oLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			oLoader.contentLoaderInfo.addEventListener(Event.OPEN, onOpenHandler);
			oLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			oLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatusHandler);
			oLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
			oLoader.contentLoaderInfo.addEventListener(Event.UNLOAD, onUnLoadHandler);
		}

		/**
		 * Triggered during loading progression.
		 * 
		 * @param event The ProgressEvent dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onProgressHandler( event : ProgressEvent ) : void
		{
			nBytesLoaded = event.bytesLoaded;
			nBytesTotal = event.bytesTotal;

			if ( oOwner ) oOwner.fireOnLoadProgressEvent();
		}

		/**
		 * Triggered when loading is complete.
		 * 
		 * @param event The Event dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onCompleteHandler( event : Event ) : void 
		{
			if (oOwner) 
			{
				oOwner.content = oLoader.content;
				oOwner.fireOnLoadInitEvent();
			}
		}

		/**
		 * Triggered when loading starts
		 * 
		 * @param event The Event dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onOpenHandler( event : Event ) : void
		{
			if ( oOwner ) oOwner.fireOnLoadStartEvent();
		}

		/**
		 * Triggered when a Security error occured.
		 * 
		 * @param event The SecurityErrorEvent dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onSecurityErrorHandler( event : SecurityErrorEvent ) : void 
		{
			release();
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onHttpStatusHandler( event : HTTPStatusEvent ) : void 
		{
	    	
		}

		/**
		 * Triggered when a IO error occured.
		 * 
		 * @param event The IOErrorEvent dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onIOErrorHandler( event : IOErrorEvent ) : void 
		{
			release();
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}

		/**
		 * Triggered when a loaded content is unloaded.
		 * 
		 * @param event The Event dispatched by event broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onUnLoadHandler( event : Event ) : void 
		{
			
		}
	}
}