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
	import net.pixlib.log.PXDebug;

	/**
	 * The PXParallelLoader loads elements at same time.
	 * 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXParallelLoader extends PXQueueLoader
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Amount of errors during loading collection session. */
		protected var nError : uint;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new PXParallelLoader instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXParallelLoader()
		{
			super();
			
			nError = 0;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		final override protected function checkNextLoader(  ) : void
		{
			var l : uint = aList.length;
			for(var i : uint;i < l;i++)
			{
				var loader : PXLoader = getLoaderAt(i);
				addLoaderListeners(loader);
				loader.execute();
			}
		}

		/**
		 * @private
		 */
		override protected function onLoaderLoadStart(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadStartEVENT, event.loader);
		}

		/**
		 * @private
		 */
		override protected function onLoaderLoadProgress(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadProgressEVENT, event.loader);
		}

		/**
		 * @private
		 */
		override protected function onLoaderLoadInit(event : PXLoaderEvent) : void
		{
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadInitEVENT, event.loader);
			
			removeLoaderListeners(event.loader);
			
			nSuccess++;
			
			checkComplete();
		}

		/**
		 * @private
		 */
		override protected function onLoaderLoadTimeOut(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR(".onLoadTimeOut() for " + event.loader.request.url, this);
			
			nError++;
			
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadTimeOutEVENT, event.loader);
			
			removeLoaderListeners(event.loader);
			
			checkComplete();
		}

		/**
		 * @private
		 */
		override protected function onLoaderLoadError(event : PXLoaderEvent) : void
		{
			PXDebug.ERROR(this + ".onLoadError() for " + event.loader.request.url + "[" + event.errorMessage + "]", this);
			
			nError++;
			
			fireCollectionEventType(PXLoaderCollectionEvent.onItemLoadErrorEVENT, event.loader);
			
			removeLoaderListeners(event.loader);
			
			checkComplete();
		}

		/**
		 * Checks if all elements in collection are loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function checkComplete() : void
		{
			if( nSuccess + nError == length) fireOnLoadInitEvent();
		}
	}
}
