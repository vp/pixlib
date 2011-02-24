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
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * The PXURLLoaderStrategy class define a loading strategy using 
	 * URLLoader loader.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	final public class PXURLLoaderStrategy implements PXLoadStrategy
	{
		/**
		 * Specifies that downloaded data is received as raw binary data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public const BINARY : String = URLLoaderDataFormat.BINARY;
		
		/**
		 * Specifies that downloaded data is received as text.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public const TEXT : String = URLLoaderDataFormat.TEXT;
		
		/**
		 * Specifies that downloaded data is received as URL-encoded variables.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public const VARIABLES : String = URLLoaderDataFormat.VARIABLES;

		/**
		 * Strategy's owner.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oOwner : PXLoader;

		/**
		 * The URLLoader manager.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oLoader : URLLoader;

		/**
		 * Count of loaded bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nBytesLoaded : uint;

		/**
		 * Count of total bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nBytesTotal : uint;

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sDataFormat : String;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * Count of loaded bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get bytesLoaded() : uint
		{
			return nBytesLoaded;
		}

		/**
		 * Count of total bytes.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get bytesTotal() : uint
		{
			return nBytesTotal;
		}

		/**
		 * The PXLoader strategy owner.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set owner(value : PXLoader) : void
		{
			oOwner = value;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates new instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXURLLoaderStrategy(format : String = null)
		{
			nBytesLoaded = 0;
			nBytesTotal = 0;
			dataFormat = format;
		}

		/**
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set dataFormat(value : String) : void
		{
			sDataFormat = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function load(loadingRequest : URLRequest = null, loadingContext : LoaderContext = null) : void
		{
			oLoader = new URLLoader();
			oLoader.dataFormat = PXURLLoaderStrategy.isValidDataFormat(sDataFormat) ? sDataFormat : PXURLLoaderStrategy.TEXT;

			oLoader.addEventListener(ProgressEvent.PROGRESS, _onProgress);
			oLoader.addEventListener(Event.COMPLETE, _onComplete);
			oLoader.addEventListener(Event.OPEN, _onOpen);
			oLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, _onSecurityError);
			oLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, _onHttpStatus);
			oLoader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			oLoader.load(loadingRequest);
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
				}
				catch( error : Error )
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

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onProgress(event : ProgressEvent) : void
		{
			nBytesLoaded = event.bytesLoaded;
			nBytesTotal = event.bytesTotal;
			if ( oOwner ) oOwner.fireOnLoadProgressEvent();
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onComplete(event : Event) : void
		{
			if ( oOwner )
			{
				oOwner.content = oLoader.data;
				oOwner.fireOnLoadInitEvent();
			}
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onOpen(event : Event) : void
		{
			if ( oOwner ) oOwner.fireOnLoadStartEvent();
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onSecurityError(event : SecurityErrorEvent) : void
		{
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onHttpStatus(event : HTTPStatusEvent) : void
		{
			//
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _onIOError(event : IOErrorEvent) : void
		{
			if ( oOwner ) oOwner.fireOnLoadErrorEvent(event.text);
		}
		
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static private function isValidDataFormat(dataFormat : String) : Boolean
		{
			return (dataFormat == PXURLLoaderStrategy.TEXT || dataFormat == PXURLLoaderStrategy.BINARY || dataFormat == PXURLLoaderStrategy.VARIABLES);
		}
	}
}
