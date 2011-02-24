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
package net.pixlib.plugin
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.log.PXLog;
	import net.pixlib.log.PXLogManager;
	import net.pixlib.log.PXStringifier;	

	/**
	 * @author Francis Bourre
	 */
	final public class PXPluginDebug implements PXLog
	{
		static public var isOn : Boolean = true;
		static private const _M : PXHashMap = new PXHashMap();

		protected var oChannel : PXEventChannel;
		protected var oOwner : PXPlugin;
		protected var bIsOn : Boolean;
		
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXPluginDebug(owner : PXPlugin = null ) 
		{
			oOwner = owner;
			oChannel = owner.channel;
			activate();
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getOwner() : PXPlugin
		{
			return oOwner;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get activated() : Boolean
		{
			return bIsOn;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function activate() : void
		{
			bIsOn = true;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function desactivate() : void
		{
			bIsOn = false;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get channel() : PXEventChannel
		{
			return oChannel;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance( owner : PXPlugin = null ) : PXPluginDebug
		{
			if ( owner == null ) owner = PXBasePlugin.getInstance();
			if ( !(PXPluginDebug._M.containsKey(owner)) ) PXPluginDebug._M.put(owner, new PXPluginDebug(owner));
			return PXPluginDebug._M.get(owner);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release( owner : PXPlugin ) : Boolean
		{
			if ( PXPluginDebug._M.containsKey(owner) ) 
			{
				PXPluginDebug._M.remove(owner);
				return true;
			} 
			else
			{
				return false;
			}
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function debug( o : *, target : Object = null ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.DEBUG(o, oChannel, target);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function info( o : *, target : Object = null ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.INFO(o, oChannel, target);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function warn( o : *, target : Object = null ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.WARN(o, oChannel, target);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function error( o : *, target : Object = null ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.ERROR(o, oChannel, target);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function fatal( o : *, target : Object = null ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.FATAL(o, oChannel, target);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear( ) : void
		{
			if ( PXPluginDebug.isOn && bIsOn ) PXLogManager.CLEAR(oChannel);
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
	}
}