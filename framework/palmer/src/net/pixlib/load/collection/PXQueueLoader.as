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
	import net.pixlib.log.PXDebug;

	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	/**
	 * PXQueueLoader allow to define multiple Loader using Queue collection 
	 * data as loader storage.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 	 * @author Romain Ecarnot
	 */
	public class PXQueueLoader extends PXAbstractLoaderCollection 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Stores loaders. */
		protected var aList : Vector.<PXLoader>;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new PXQueueLoader instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10		 */
		public function PXQueueLoader()
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function add( loader : PXLoader, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null ) : Boolean
		{
			return addAt(length, loader, key, loadingRequest, loadingContext);
		}

		/**
		 * @inheritDoc
		 */
		override public function remove( loader : PXLoader ) : Boolean
		{
			if( !running )
			{
				var index : int = getLoaderIndex(loader);
				if( index > -1 )
				{
					aList.splice(index, 1);
					return true;	
				}
				
				return false;
			}
			else
			{
				PXDebug.WARN(" removing loader is not allow when sequencer is running.", this);	
			}
			
			return false;
		}

		/**
		 * @inheritDoc
		 */
		override public function get length() : uint
		{
			return aList.length;
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function pushLoader(loader : PXLoader, index : int) : void
		{
			aList.push(loader);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getLoaderAt( index : uint ) : PXLoader
		{
			return aList[index];
		}

		/**
		 * @inheritDoc
		 */
		override protected function clearCollection(  ) : void
		{
			aList = new Vector.<PXLoader>();
		}
	}
}