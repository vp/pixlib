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
package net.pixlib.model
{
	import net.pixlib.collections.PXArrayIterator;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.collections.PXIterator;
	import net.pixlib.core.PXAbstractLocator;
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.plugin.PXPlugin;
	import net.pixlib.plugin.PXPluginDebug;

	/**
	 * The PXModelLocator class is a locator for 
	 * <code>PXModel</code> object.
	 * 
	 * <p>A locator is unique for a <code>PXPlugin</code> instance.</p>
	 * 
	 * @see PXModel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Francis Bourre
	 */
	final public class PXModelLocator extends PXAbstractLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		static private const _M : PXHashMap = new PXHashMap();

		private var _owner : PXPlugin;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The plugin owner of this locator.
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
		 * Returns the unique <code>PXModelLocator</code> instance for 
		 * passed-in <code>Plugin</code>.
		 * 
		 * @return The unique <code>PXModelLocator</code> instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance( plugin : PXPlugin = null ) : PXModelLocator
		{
			if ( plugin == null ) plugin = PXBasePlugin.getInstance();

			if ( !(_M.containsKey(plugin)) ) 
				_M.put(plugin, new PXModelLocator(plugin));

			return _M.get(plugin);
		}

		/**
		 * Returns <code>PXModel</code> registered with passed-in 
		 * key identifier.
		 * 
		 * @param	key	PXModel registration ID
		 * 
		 * @throws 	<code>PXNoSuchElementException</code> — There is no model
		 * 			associated with the passed-in key
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getModel( key : String ) : PXModel
		{
			return locate(key) as PXModel;
		}

		/**
		 * @inheritDoc
		 */
		override public function release() : void
		{
			var iter : PXIterator = new PXArrayIterator(mMap.values);
			while( iter.hasNext() ) iter.next().release();
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
		 * 
		 */
		override public function toString() : String 
		{
			return super.toString() + (_owner ? ", owner: " + _owner : "No owner.");
		}
		

		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PXModelLocator(plugin : PXPlugin = null ) 
		{
			_owner = plugin;
			super(PXModel, null, PXPluginDebug.getInstance(_owner));
		}
	}
}