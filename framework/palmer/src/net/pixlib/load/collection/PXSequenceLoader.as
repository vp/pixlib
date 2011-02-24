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
	 * PXSequenceLoader allow to define multiple loading process.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXSequenceLoader extends PXAbstractLoaderCollection
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/** Stores loader list. */
		protected var aLoaders : Vector.<PXLoader>;

		
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
		 * Creates a new instance PXSequenceLoader.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXSequenceLoader( )
		{
			super();
		}

		/**
		 * @inheritDoc
		 */
		override public function add( loader : PXLoader, key : String = null, loadingRequest : URLRequest = null, loadingContext : LoaderContext = null ) : Boolean
		{
			return addAt(aLoaders.length, loader, key, loadingRequest, loadingContext);
		}

		/**
		 * Adds passed-in <code>loader</code> before passed-in <code>searchLoader</code>.
		 * 
		 * <p><code>searchLoader</code> must be registered in sequencer to find 
		 * his position.<br />
		 * The <code>loader</code> is inserted before <code>searchLoader</code> loader.</p>
		 * 
		 * @param	searchLoader	PXLoader to search
		 * @param	loader			Loader to add before <code>searchLoader</code> 
		 * 							loader.
		 * 							
		 * @return	<code>true</code> if <code>loader</code> is successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function addBefore( searchLoader : PXLoader, loader : PXLoader, name : String = null, request : URLRequest = null, context : LoaderContext = null ) : Boolean
		{
			var index : int = aLoaders.indexOf(searchLoader) ;
			if( loader == null && index != -1) return false;
			
			return addAt(index, loader, name, request, context) ;
		}

		/**
		 * Adds passed-in <code>loader</code> after passed-in 
		 * <code>searchLoader</code>. 
		 * 
		 * <p><code>searchLoader</code> must be registered in sequencer to find 
		 * his position.<br />
		 * The <code>loader</code> command is added after 
		 * <code>searchLoader</code> loader.</p>
		 * 
		 * @param	searchLoader	PXLoader to search
		 * @param	loader			PXLoader to add after <code>searchLoader</code> 
		 * 							loader.
		 * 					
		 * @return	<code>true</code> if <code>loader</code> is successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addAfter( searchLoader : PXLoader, loader : PXLoader, name : String = null, request : URLRequest = null, context : LoaderContext = null ) : Boolean
		{
			var index : int = aLoaders.indexOf(searchLoader) ;
			if( loader == null && index != -1) return false;
			
			return addAt(index + 1, loader, name, request, context) ;
		}

		/**
		 * Adds passed-in loader in first position in sequencer.
		 * 
		 * @param	loader	PXLoader to add
		 * 
		 * @return	<code>true</code> if <code>loader</code> is successfully inserted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addBegin( loader : PXLoader, name : String = null, request : URLRequest = null, context : LoaderContext = null ) : Boolean
		{
			return addAt(0, loader, name, request, context) ;
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
				PXDebug.WARN(this + " removing loader is not allow when sequencer is running.", this);	
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
			aLoaders.splice(index, 0, loader);
		}

		/**
		 * @inheritDoc
		 */
		override protected function getLoaderAt( index : uint ) : PXLoader
		{
			return aLoaders[index];
		}

		/**
		 * @inheritDoc
		 */
		override protected function clearCollection(  ) : void
		{
			aLoaders = new Vector.<PXLoader>();
		}
	}
}