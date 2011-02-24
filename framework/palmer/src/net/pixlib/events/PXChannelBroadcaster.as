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
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.utils.PXClassUtils;

	import flash.events.Event;

	/**
	 * The <code>PXChannelBroadcaster</code> is a macro broadcaster
	 * which offers to dispatch events through communication channels.
	 * <p>
	 * The main idea is the following, developers can create specific
	 * channels for communication, onto which event will be broadcasted.
	 * To take a metaphor, this works like a CB radio, you can select a 
	 * frequency and then listen and talk to people which are connected to
	 * that frequency, and only that one. To achieve this process, the
	 * channel broadcaster agregates <code>PXBroadcaster</code> implementation
	 * and maps it with <code>PXEventChannel</code> object. In that principle
	 * the channel broadcaster is no more than a CB base station. With
	 * a big difference anyway, the broadcaster channel offers an access
	 * to a frequency, it doesn't broadcast messages itself.
	 * </p><p>
	 * To initiate the dispatching on a specific channel, developers
	 * only need to call the redefined functions of the class as they
	 * can do with a <code>PXBroadcaster</code> implementation with a proper
	 * event channel, the channel broadcaster will check for the presence
	 * of a broadcaster instance for this channel, and if there's no
	 * corresponding broadcaster it will creates one.
	 * </p><p>
	 * The channel broadcaster redefines many functions of the 
	 * <code>PXBroadcaster</code> interface in order to add channel
	 * parameter. See below the list of redefined methods : 
	 * <ul>
	 * <li><code>isRegistered</code></li>	 * <li><code>broadcastEvent</code></li>	 * <li><code>addListener</code></li>	 * <li><code>addEventListener</code></li>	 * <li><code>removeListener</code></li>	 * <li><code>removeEventListener</code></li>	 * <li><code>hasChannelListener</code>, which correspond 
	 * to the <code>hasListenerCollection</code> method of the 
	 * <code>PXEventBroadcaster</code> class</li>.
	 * </ul></p>
	 * 
	 * @author 	Francis Bourre
	 * @see		PXBroadcaster
	 * @see		PXEventChannel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXChannelBroadcaster
	{
		/**
		 * @private
		 */
		protected var _oDefaultChannel : PXEventChannel;
		
		/**
		 * @private
		 */
		protected var _mChannel : PXHashMap;
		
		/**
		 * @private
		 */
		protected var _broadcasterClass : Class;

		
		/**
		 * Creates a new <code>PXChannelBroadcaster</code> with the passed-in
		 * <code>PXBroadcaster</code> class to build broadcaster instances and
		 * an event channel as default channel. The default channel is used
		 * when a call to function is done without specifying any channel. If 
		 * the channel argument is omitted, the default channel is set to the
		 * internal <code>DefaultChannel.CHANNEL</code> constant.
		 * 
		 * @param	broadcasterClass broadcaster class wrapped by this channel
		 * 							 broadcaster.
		 * 							 
		 * @param	channel			 default channel for this broadcaster.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — If the passed-in
		 * 			class doesn't implement <code>PXBroadcaster</code> interface
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXChannelBroadcaster( broadcasterClass : Class = null, channel : PXEventChannel = null )
		{
			if ( broadcasterClass != null )
			{
				if ( !PXClassUtils.inherit(broadcasterClass, PXBroadcaster) )
				{
					var msg : String = "The class '" + broadcasterClass + "' doesn't implement Broadcaster interface in " + this;
					PXDebug.FATAL(msg);
					throw new PXIllegalArgumentException(msg);
				} 
				else
				{
					_broadcasterClass = broadcasterClass;
				}
			} 
			else
			{
				_broadcasterClass = PXEventBroadcaster;
			}

			clean();
			setDefaultChannel(channel);
		}

		/**
		 * Returns the <code>PXBroadcaster</code> implementation associated
		 * with the default channel of this channel broadcaster.
		 * 
		 * @return	the <code>PXBroadcaster</code> implementatation associated
		 * 			with the default channel of this channel broadcaster.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getDefaultDispatcher() : PXBroadcaster
		{
			return _mChannel.get(_oDefaultChannel);
		}

		/**
		 * Returns a reference to the default channel of this
		 * channel broadcaster. This function never returns
		 * <code>null</code>.
		 * 
		 * @return	a reference to the default channel of this
		 * 			channel broadcaster
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getDefaultChannel() : PXEventChannel
		{
			return _oDefaultChannel;
		}

		/**
		 * Defines which channel is used as default channel for this
		 * channel broadcaster. If the passed-in channel is <code>null</code>
		 * the internal <code>DefaultChannel.CHANNEL</code> constant is used
		 * as default channel.
		 * 
		 * @param	channel	the new default channel for this channel broadcaster
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setDefaultChannel( channel : PXEventChannel = null ) : void
		{
			_oDefaultChannel = (channel == null) ? DefaultChannel.CHANNEL : channel;
			getChannelDispatcher(getDefaultChannel());
		}

		/**
		 * Clean the current channel broacaster by removing all 
		 * <code>PXBroadcaster</code> instances previously created
		 * and then rebuild the default <code>PXEventBroadcaster</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clean() : void
		{
			_mChannel = new PXHashMap();
			
			var channel : PXEventChannel = getDefaultChannel();
			if ( channel != null ) getChannelDispatcher(channel);
		}
		
		/**
		 * Returns <code>true</code> if the passed-in <code>listener</code>
		 * is registered as listener for the passed-in event <code>type</code>
		 * in the passed-in <code>channel</code>.
		 * 
		 * @param	listener	object to look for registration
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * 
		 * @return	<code>true</code> if the passed-in <code>listener</code>
		 * 			is registered as listener for the passed-in event
		 * 			<code>type</code> in the passed-in <code>channel</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRegistered( listener : Object, type : String, channel : PXEventChannel ) : Boolean
		{
			if( hasChannelDispatcher(channel) )
				return getChannelDispatcher(channel).isRegistered(listener, type);
			else 
				return false;
		}

		/**
		 * Returns <code>true</code> if there is a <code>PXBroadcaster</code>
		 * instance registered for the passed-in channel.
		 * 
		 * @param	channel	channel onto which look at.
		 * 
		 * @return	<code>true</code> if there is a <code>PXBroadcaster</code>
		 * 			instance registered for the passed-in channel.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasChannelDispatcher( channel : PXEventChannel ) : Boolean
		{
			return channel == null ? _mChannel.containsKey(_oDefaultChannel) : _mChannel.containsKey(channel);
		}

		/**
		 * Returns <code>true</code> if there is a <code>PXBroadcaster</code> instance
		 * registered for the passed-in channel, and if this broadcaster has registered
		 * listeners.
		 * 
		 * @param	type		event type to look at.
		 * @param	channel		channel onto which look at.
		 * 
		 * @return	<code>true</code> if there is a <code>Broadcaster</code>
		 * 			instance registered for the passed-in channel, and if this
		 * 			broadcaster has registered listeners.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasChannelListener( type : String, channel : PXEventChannel = null ) : Boolean
		{
			if ( hasChannelDispatcher(channel) )
				return getChannelDispatcher(channel).hasListenerCollection(type);
			else
				return false;
		}

		/**
		 * Returns the <code>PXBroadcaster</code> instance associated with the
		 * passed-in <code>channel</code>. The <code>owner</code> is an optionnal
		 * parameter which is used to initialize the newly created <code>PXBroadcaster</code>
		 * when there is no broadcaster for this channel.
		 * 
		 * @param	channel	the channel for which get the associated broadcaster.
		 * @param	owner	an optional object which will used as source if there
		 * 					is no broadcaster associated to the channel.
		 * 					
		 * @return	the <code>Broadcaster</code> instance associated with
		 * 			the passed-in <code>channel</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getChannelDispatcher( channel : PXEventChannel = null, owner : Object = null ) : PXBroadcaster
		{
			if ( hasChannelDispatcher(channel) )
				return channel == null ? _mChannel.get(_oDefaultChannel) : _mChannel.get(channel);
			else
			{
				var eb : PXBroadcaster = new (_broadcasterClass as Class)(owner);
				_mChannel.put(channel, eb);
				return eb;
			}
		}

		/**
		 * Removes the <code>PXBroadcaster</code> instance associated with
		 * the passed-in <code>channel</code>, and return <code>true</code>
		 * if there is a broadcaster and if it have been successfully removed.
		 * 
		 * @param	channel	channel for which remove the associated broadcaster.
		 * 
		 * @return	<code>true</code> if there is a broadcaster and if it have
		 * 			been successfully removed.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function releaseChannelDispatcher( channel : PXEventChannel ) : Boolean
		{
			if ( hasChannelDispatcher(channel) )
			{
				var eb : PXBroadcaster = _mChannel.get(channel) as PXBroadcaster;
				eb.removeAllListeners();
				_mChannel.remove(channel);

				return true;
			} 
			else return false;
		}

		/**
		 * Adds the passed-in listener as listener for all events 
		 * dispatched by this event channel broadcaster. The function
		 * returns <code>true</code> if the listener have been added
		 * at the end of the call. If the listener is already registered
		 * in this event channel broadcaster the function returns
		 * <code>false</code>.
		 * <p>
		 * Note : The <code>addListener</code> function doesn't accept
		 * functions as listener, functions could only register for
		 * a single event.
		 * </p>
		 * 
		 * @param 	listener	the listener object to add as channel listener.
		 * @param	channel		the channel for which the object listen.
		 * 
		 * @return	<code>true</code> if the listener have been added during this call.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			listener doesn't match the listener type supported by this
		 * 			broadcaster instance
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addListener( listener : Object, channel : PXEventChannel = null ) : Boolean
		{
			return getChannelDispatcher(channel).addListener(listener);
		}

		/**
		 * Removes the passed-in listener object from this event
		 * channel broadcaster. The object is removed as listener
		 * for all events the broadcaster may dispatch on this
		 * channel.
		 * 
		 * @param	listener	the listener object to remove from
		 * 						this event broadcaster object.
		 * @param	channel		the channel for which the object will be removed.
		 * 			
		 * @return	<code>true</code> if the object have been successfully
		 * 			removed from this broadcaster instance.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in listener
		 * 			is a function.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeListener( listener : Object, channel : PXEventChannel = null ) : Boolean
		{
			return getChannelDispatcher(channel).removeListener(listener);
		}

		/**
		 * Adds an event listener for the specified event type of the
		 * specified channel. There is two behaviors for the 
		 * <code>addEventListener</code> function : 
		 * <ol>
		 * <li>The passed-in listener is an object : 
		 * The object is added as listener only for the specified event, the object
		 * must have a function with the same name than <code>type</code> or at least
		 * a <code>handleEvent</code> function.</li>
		 * <li>The passed-in listener is a function : 
		 * A <code>Delegate</code> object is created and then
		 * added as listener for the event type . There is no restriction on the name
		 * of the function.</li>
		 * </ol>
		 * 
		 * @param 	type		name of the event for which register the listener
		 * @param 	listener	object or function which will receive this event
		 * @param	channel		event channel for which the listener listen
		 * 
		 * @return	<code>true</code> if the function have been succesfully added as
		 * 			listener fot the passed-in event
		 * 			
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addEventListener( type : String, listener : Object, channel : PXEventChannel = null ) : Boolean
		{
			return getChannelDispatcher(channel).addEventListener(type, listener);
		}

		/**
		 * Removes the passed-in listener for listening the specified event of
		 * the specified channel. The listener could be either an object or a function.
		 * 
		 * @param 	type		name of the event for which unregister the listener
		 * @param 	listener	object or function to be unregistered
		 * @param	channel		event channel on which unregister the listener
		 * 
		 * @return	<code>true</code> if the listener have been successfully removed
		 * 			as listener for the passed-in event
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeEventListener( type : String, listener : Object, channel : PXEventChannel = null ) : Boolean
		{
			return getChannelDispatcher(channel).removeEventListener(type, listener);
		}

		/**
		 * Broadcast the passed-in event object to listeners
		 * according to the event's type and <code>channel</code>
		 * argument. The event is broadcasted to both listeners
		 * registered specifically for this event type and global
		 * listeners in the broadcaster.
		 * <p>
		 * If the <code>target</code> property of the passed-in event
		 * is <code>null</code>, it will be set using the value of the
		 * source property of this event broadcaster.
		 * </p>
		 * 
		 * @param	e		event object to broadcast
		 * @param 	channel event channel onto which broadcast event
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If one listener is an object
		 * 			which have neither a function with the same name than the event type nor
		 * 			a function called <code>handleEvent</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function broadcastEvent( e : Event, channel : PXEventChannel = null ) : void
		{
			getChannelDispatcher(channel).broadcastEvent(e);
			if ( channel ) getChannelDispatcher().broadcastEvent(e);
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

import net.pixlib.events.PXEventChannel;

internal class DefaultChannel extends PXEventChannel
{
	static public const CHANNEL : DefaultChannel = new DefaultChannel();
}