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
	import net.pixlib.events.PXApplicationBroadcaster;
	import net.pixlib.events.PXEventChannel;
	import net.pixlib.log.PXStringifier;

	import flash.utils.Dictionary;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Romain Flacher
	 */
	final public class PXChannelExpert
	{
		static private var _oI : PXChannelExpert;
		static private var _nN : uint = 0;

		private var _mMap : PXHashMap;
		private var _oRegistered : Dictionary;

		
		/**
		 * @return singleton instance of PXChannelExpert
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXChannelExpert 
		{
			if ( !( PXChannelExpert._oI is PXChannelExpert ) ) 
				PXChannelExpert._oI = new PXChannelExpert();
			return PXChannelExpert._oI;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function release() : void
		{
			if ( PXChannelExpert._oI is PXChannelExpert ) 
			{
				PXChannelExpert._oI = null;
				PXChannelExpert._nN = 0;
			}
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXChannelExpert()
		{
			_mMap = new PXHashMap();
			_oRegistered = new Dictionary(true);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getChannel( plugin : PXPlugin ) : PXEventChannel
		{
			if( _oRegistered[plugin] == null )
			{
				if ( _mMap.containsKey(PXChannelExpert._nN) )
				{
					var channel : PXEventChannel = _mMap.get(PXChannelExpert._nN) as PXEventChannel;
					_oRegistered[plugin] = channel;
					++PXChannelExpert._nN;
					return channel;
				} 
				else
				{
					PXPluginDebug.getInstance().debug(this + ".getChannel() failed on " + plugin, PXChannelExpert);
					_oRegistered[plugin] = PXApplicationBroadcaster.getInstance().NO_CHANNEL;
					return PXApplicationBroadcaster.getInstance().NO_CHANNEL;
				}
			}
			else
			{
				return _oRegistered[plugin] as PXEventChannel;
			}
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function releaseChannel( plugin : PXPlugin ) : Boolean
		{
			if( _oRegistered[plugin] )
			{
				if ( _mMap.containsKey(plugin.channel) ) _mMap.remove(plugin.channel);
				_oRegistered[plugin] = null;

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
		public function registerChannel( channel : PXEventChannel ) : void
		{
			_mMap.put(PXChannelExpert._nN, channel);
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