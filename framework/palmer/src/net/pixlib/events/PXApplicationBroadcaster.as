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
package net.pixlib.events
{
	import net.pixlib.plugin.PXPluginBroadcaster;

	/**
	 * The <code>PXApplicationBroadcaster</code> class is a singleton
	 * implementation of the <code>PXChannelBroadcaster</code> class, 
	 * used for <i>Inversion of Controls</i> purpose. More formally
	 * the application broadcaster is dedicated to plugin to plugin
	 * communication. When defining a plugin with a specific channel, 
	 * and then listeners of this plugin, a channel instance is created
	 * in the <code>PXChannelExpert</code> and then this channel is used
	 * in order to create the whole dispatching stuff between these 
	 * plugins.
	 * <p>
	 * The class defines two constant channels dedicated to an IoC usage.
	 * These channel represents particular behaviors of the application
	 * broadcaster. Such : 
	 * <ul>
	 * <li><code>NO_CHANNEL</code> : That constant, when used as argument of
	 * the <code>getChannelDispatcher</code> method, force the application
	 * broadcaster to ignore the call. No broadcaster will be created and
	 * then returned by the function.</li>
	 * <li><code>SYSTEM_CHANNEL</code> : Defines the default channel of the
	 * application broadcaster singleton. All objects which add themselves
	 * as listener without specifying any channel are considered as system
	 * listeners.</li>
	 * </ul>
	 * </p>
	 * 
	 * @see		PXChannelBroadcaster
	 * 
	 * @author 	Francis Bourre
	 * @author 	Romain Flacher
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXApplicationBroadcaster extends PXChannelBroadcaster
	{
		/**
		 * @private
		 */
		static private var _oI : PXApplicationBroadcaster;
		
		/**
		 * Inhibit the behavior of the <code>getChannelDispatcher</code>
		 * which will return nothing if this channel is passed as argument.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public const NO_CHANNEL : PXEventChannel = new NoChannel();

		/**
		 * Default channel for the application broadcaster, all listeners
		 * which not define any channel are considered as system listeners.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public const SYSTEM_CHANNEL : PXEventChannel = new SystemChannel();

		
		/**
		 * Returns the singleton instance of the <code>PXApplicationBroadcaster</code>
		 * class. The class instance is created using the lazy initialisation concept.
		 * 
		 * @return	singleton instance of <code>PXApplicationBroadcaster</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXApplicationBroadcaster 
		{
			if ( !(PXApplicationBroadcaster._oI is PXApplicationBroadcaster) ) PXApplicationBroadcaster._oI = new PXApplicationBroadcaster();
			return PXApplicationBroadcaster._oI;
		}
		
		/**
		 * @private
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXApplicationBroadcaster()
		{
			super(PXPluginBroadcaster, SYSTEM_CHANNEL);
		}

		/**
		 * Returns the <code>PXEventBroadcaster</code> object associated with
		 * the passed-in <code>channel</code>. The <code>owner</code> is an optionnal
		 * parameter which is used to initialize the newly created <code>PXEventBroadcaster</code>
		 * when there is no broadcaster for this channel.
		 * <p>
		 * There's a particular case defined by this class, when passing the <code>NO_CHANNEL</code>
		 * channel in this function, the function will return <code>null</code> instead of a broadcaster.
		 * </p>
		 * 
		 * @param	channel	the channel for which get the associated broadcaster
		 * @param	owner	an optional object which will used as source if there
		 * 					is no broadcaster associated to the channel.
		 * 					
		 * @return	the <code>PXEventBroadcaster</code> object associated with
		 * 			the passed-in <code>channel</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function getChannelDispatcher( channel : PXEventChannel = null, owner : Object = null ) : PXBroadcaster
		{
			return ( channel != NO_CHANNEL ) ? super.getChannelDispatcher(channel, owner) : null;
		}
	}
}

import net.pixlib.events.PXEventChannel;

internal class NoChannel extends PXEventChannel
{
}

internal class SystemChannel extends PXEventChannel
{
}
