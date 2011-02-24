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
package net.pixlib.view
{
	import net.pixlib.collections.PXArrayIterator;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.collections.PXIterator;
	import net.pixlib.core.PXAbstractLocator;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;

	/**
	 * The PXViewLocator class is a locator for <code>PXViewLocator</code> object.
	 * 
	 * <p>Locator is unique for a <code>PXPlugin</code> instance.</p>
	 * 
	 * @see PXView
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXViewLocator extends PXAbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _M : PXHashMap = new PXHashMap();
		
		/**
		 * @private
		 */
		private var _owner : PXPlugin;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The plugin's owner of this locator.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get owner() : PXPlugin
		{
			return _owner;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns the unique <code>PXViewLocator</code> instance for 
		 * passed-in <code>PXPlugin</code>.
		 * 
		 * @return The unique <code>PXViewLocator</code> instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance( plugin : PXPlugin = null ) : PXViewLocator
		{
			if ( plugin == null ) plugin = PXBasePlugin.getInstance();
			
			if (!_M.containsKey(plugin)) 
				_M.put(plugin, new PXViewLocator(plugin));

			return _M.get(plugin);
		}

		/**
		 * Returns <code>PXView</code> registered with passed-in 
		 * key identifier.
		 * 
		 * @param	key	View registration ID
		 * 
		 * @throws 	net.pixlib.exceptions.PXNoSuchElementException There is no view
		 * 			associated with the passed-in key
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getView( key : String ) : PXView
		{
			return locate(key) as PXView;
		}

		/**
		 * @inheritDoc
		 */
		override public function register( key : String, o : Object ) : Boolean
		{
			if( key == null ) 
				throw new PXNullPointerException("Cannot register a view with a null name", this);

			if( o == null ) 
				throw new PXNullPointerException("Cannot register a null view", this);

			return super.register(key, o);
		}

		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			var iter : PXIterator = new PXArrayIterator(mMap.values);
			while ( iter.hasNext() ) iter.next().release();
			super.release();
			_owner = null ;
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function toString() : String 
		{
			return super.toString() + (_owner ? ", owner: " + _owner : "No owner.");
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PXViewLocator(plugin : PXPlugin = null ) 
		{
			_owner = plugin;
			
			super(PXView, null, PXPluginDebug.getInstance(_owner));
		}		
	}
}