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

	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.LoaderContext;

	/**
	 * The PXStreamLoaderStrategy class define a loading strategy using 
	 * URLStream loader.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Romain Ecarnot
	 */
	final public class PXStreamLoaderStrategy implements PXLoadStrategy
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** @private */		
		protected var oOwner : PXLoader;

		/** @private */	
		protected var oLoader : URLStream;

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
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXStreamLoaderStrategy( )
		{
			nBytesLoaded = 0;
			nBytesTotal = 0;
		}

		/**
		 * @inheritDoc
		 */
		public function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null ) : void
		{
			oLoader = new URLStream();
			oLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			oLoader.addEventListener(Event.COMPLETE, _onComplete);
			oLoader.addEventListener(Event.OPEN, _onOpen);
			oLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			oLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			oLoader.load(loadingRequest) ;
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			if ( oLoader ) 
			{
				oLoader.removeEventListener(ProgressEvent.PROGRESS, _onProgress);
				oLoader.removeEventListener(Event.COMPLETE, _onComplete);
				oLoader.removeEventListener(Event.OPEN, _onOpen);
				oLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
				oLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
				oLoader.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
				
				try 
				{
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
		 */
		protected function _onProgress( event : ProgressEvent ) : void
		{
			nBytesLoaded = event.bytesLoaded;
			nBytesTotal = event.bytesTotal;
			
			if ( oOwner ) oOwner.fireOnLoadProgressEvent();
		}
		
		/**
		 * @private
		 */
		protected function _onComplete( event : Event ) : void 
		{
			if ( oOwner ) 
			{
				oOwner.content = oLoader;
				oOwner.fireOnLoadInitEvent();
			}
		}
		
		/**
		 * @private
		 */
		protected function _onOpen( event : Event ) : void
		{
			if ( oOwner ) oOwner.fireOnLoadStartEvent();
		}
		
		/**
		 * @private
		 */
		protected function _onSecurityError( event : SecurityErrorEvent ) : void 
		{
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}
		
		/**
		 * @private
		 */
		protected function _onHttpStatus( event : HTTPStatusEvent ) : void 
		{
			//
		}
		
		/**
		 * @private
		 */
		protected function _onIOError( event : IOErrorEvent ) : void 
		{
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}
	}
}
