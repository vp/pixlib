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
	 * PXPriorityLoader allow to define multiple Loaders using 
	 * loading priority value.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXPriorityLoader extends PXAbstractLoaderCollection
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/** The lowest priority (last loaded). */
		public static const LOW_PRIORITY : int = -10000;

		/** The highest priority (first loaded) */
		public static const HIGH_PIORITY : int = 10000;

		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Stores loader list. */
		protected var aLoaders : Array;

		
		/**
		 * @inheritDoc
		 */
		override public function get length() : uint
		{
			return aLoaders.length;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new PXPriorityLoader instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXPriorityLoader( )
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
		 * Adds passed-in loader with <code>priority</code> value.
		 * 
		 * @param	loader		PXLoader to add
		 * @param	priority	Loading priority value
		 * @param	name		Loader name
		 * @param	request		Loading request
		 * @param	context		Loader context
		 * 
		 * @return	<code>true</code> if <code>loader</code> is successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addPriority( loader : PXLoader, priority : int = -10000, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null ) : Boolean
		{
			return addAt(priority + length, loader, key, loadingRequest, loadingContext);
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
					aLoaders.splice(index, 1);
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

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override protected function pushLoader( loader : PXLoader, index : int ) : void
		{
			aLoaders.push(new LoaderItem(loader, index));
		}

		/**
		 * @inheritDoc
		 */
		override protected function getLoaderAt( index : uint ) : PXLoader
		{
			return LoaderItem(aLoaders[index]).loader;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function clearCollection(  ) : void
		{
			aLoaders = new Array();
		}

		/**
		 * @inheritDoc
		 */
		override protected function startProcess(  ) : void
		{
			sortLoaders();
			
			super.startProcess();
		}

		/**
		 * Sorts loader by priority
		 */
		protected function sortLoaders(  ) : void
		{
			aLoaders = aLoaders.sort(_sortOnPriority);	
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/**
		 * Comparison functin for loader sorting.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		private function _sortOnPriority( a : LoaderItem, b : LoaderItem ) : Number
		{
			if( a.priority > b.priority ) return -1;
			if( a.priority < b.priority ) return 1;
			
			return 0;
		}
	}
}

import net.pixlib.load.PXLoader;

internal class LoaderItem
{
	private var _oLoader : PXLoader;
	private var _nPriority : int;

	
	public function get loader() : PXLoader 
	{ 
		return _oLoader; 
	}

	public function get priority() : int 
	{ 
		return _nPriority;
	}

	public function LoaderItem( loader : PXLoader, priority : int )
	{
		_oLoader = loader;
		_nPriority = priority;
	}
}
