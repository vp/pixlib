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
package net.pixlib.log 
{
	import net.pixlib.events.PXChannelBroadcaster;
	import net.pixlib.events.PXEventChannel;

	import flash.events.Event;

	/**
	 *  Dispatched when a log message is sent.
	 *  
	 *  @eventType net.pixlib.log.PXLogEvent.onLogEVENT
	 */
	[Event(name="onLog", type="net.pixlib.log.PXLogEvent")]

	/**
	 *  Dispatched when a clears message is sent.
	 *  
	 *  @eventType net.pixlib.log.PXLogEvent.onClearEVENT
	 */
	[Event(name="onClear", type="net.pixlib.log.PXLogEvent")]

	/**
	 * The PXLogManager class allow to dispatch log message tl all registered 
	 * Log listeners, in dedicated, or all logging channel.
	 * 
	 * <p>Log level can be also apply to filter logging message.</p>
	 * 
	 * @see	PXLogListener
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXLogManager
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _oI : PXLogManager = null;
		
		/**
		 * @private
		 */
		private var _oCB : PXChannelBroadcaster;
		
		/**
		 * @private
		 */
		private var _oLevel : PXLogLevel;
		
		/**
		 * Logging level.
		 * 
		 * @example
		 * <listing>
		 * 
		 * PXLogManager.getInstance().setLevel( PXLogLevel.INFO );
		 * </listing>
		 * 
		 * @param	level	LogLevel filter to apply.<br />
		 * 					Possible values are :
		 * 					<ul>
		 * 						<li>PXLogLevel.ALL</li>
		 * 						<li>PXLogLevel.DEBUG</li>
		 * 						<li>PXLogLevel.WARN</li>
		 * 						<li>PXLogLevel.ERROR</li>
		 * 						<li>PXLogLevel.FATAL</li>
		 * 						<li>PXLogLevel.OFF</li>
		 * 					</ul>
		 * 					
		 * 	@see	PXLogLevel
		 * 	
		 * 	@langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get level() : PXLogLevel
		{
			return _oLevel;
		}
		
		/**
		 * @private
		 */
		public function set level( level : PXLogLevel ) : void
		{
			_oLevel = level;
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique PXLogManager instance.
		 * 
		 * @return Unique PXLogManager instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static function getInstance() : PXLogManager
		{
			if ( !(_oI is PXLogManager) ) _oI = new PXLogManager();
			return _oI;
		}
		
		/**
		 * Braodcasts passed-in <code>e</code> PXLogEvent in 
		 * <code>oChannel</code> channel.
		 * 
		 * @example
		 * <listing>
		 * 
		 * var evt : PXLogEvent = new PXLogEvent( PXLogLevel.INFO, "my message" );
		 * 
		 * PXLogManager.getInstance().log( evt, PXDebug.CHANNEL );
		 * </listing>
		 * 
		 * @param	e			LogEvent instance with logging message information.
		 * @param	channel		(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all PXLogManager listeners.
		 * 	
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function log( e : PXLogEvent, channel : PXEventChannel = null ) : Boolean
		{	
			if ( e.level.level >= _oLevel.level ) 
			{
				if( channel != null ) e.channel = channel.toString();
				
				_oCB.broadcastEvent(e, channel);
				return true;
			} 
			else
			{
				return false;
			}
		}

		/**
		 * Broadcasts <code>onClear</code> event in 
		 * <code>oChannel</code> channel.
		 * 
		 * @param	channel		(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all LogManager listeners.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear( channel : PXEventChannel = null ) : void
		{
			_oCB.broadcastEvent(new Event(PXLogEvent.onClearEvent), channel);
		}

		/**
		 * Adds a new PXLogListener instance as new Logging API layout.
		 * 
		 * @param 	listener	PXLogListener instance
		 * @param	channel		event channel for which the listener listen
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addLogListener( listener : PXLogListener, channel : PXEventChannel = null ) : void
		{
			_oCB.addEventListener(PXLogEvent.onLogEVENT, listener, channel);
			_oCB.addEventListener(PXLogEvent.onClearEvent, listener, channel);
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
		 * 	@see	PXBroadcaster#removeEventListener()
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeLogListener( listener : PXLogListener, channel : PXEventChannel = null ) : void
		{
			_oCB.removeEventListener(PXLogEvent.onLogEVENT, listener, channel);
			_oCB.removeEventListener(PXLogEvent.onClearEvent, listener, channel);
		}

		/**
		 * Returns <code>true</code> if the passed-in <code>listener</code>
		 * is registered as listener for the passed-in event <code>type</code>
		 * in the passed-in <code>channel</code>.
		 * 
		 * @param	listener	PXLogListener to look for registration
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * 
		 * @return	<code>true</code> if the passed-in <code>listener</code>
		 * 			is registered as listener for the passed-in event
		 * 			<code>type</code> in the passed-in <code>channel</code>
		 * 			
		 * @see		PXBroadcaster#isRegistered()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRegistered( listener : PXLogListener, channel : PXEventChannel ) : Boolean
		{
			return _oCB.isRegistered(listener, PXLogEvent.onLogEVENT, channel);
		}

		/**
		 * Returns <code>true</code> if there is a <code>PXBroadcaster</code> instance
		 * registered for the passed-in channel, and if this broadcaster has registered
		 * listeners.
		 * 
		 * @param	type		event type to look at
		 * @param	channel		channel onto which look at
		 * @return	<code>true</code> if there is a <code>PXBroadcaster</code>
		 * 			instance registered for the passed-in channel, and if this
		 * 			broadcaster has registered listeners
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function hasListener( channel : PXEventChannel = null ) : Boolean
		{
			return _oCB.hasChannelListener(PXLogEvent.onLogEVENT, channel);
		}

		/**
		 * Removes all listeners object from this event
		 * channel broadcaster. The object is removed as listener
		 * for all events the broadcaster may dispatch on this
		 * channel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */ 
		public function removeAllListeners() : void
		{
			_oCB.clean();
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

		/**
		 * @see #log()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function LOG( o : *, level : PXLogLevel, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.getInstance().log(new PXLogEvent(level, o, target), channel);
		}

		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>PXLogLevel.DEBUG</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all PXLogManager listeners.
		 * @param	target		(optional) The target from where the log 
		 * 						is called	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function DEBUG( o : *, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.LOG(o, PXLogLevel.DEBUG, channel, target);
		}

		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>PXLogLevel.INFO</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all LogManager listeners.
		 * @param	target		(optional) The target from where the log 
		 * 						is called	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function INFO( o : *, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.LOG(o, PXLogLevel.INFO, channel, target);
		}

		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>PXLogLevel.WARN</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all LogManager listeners.
		 * @param	target		(optional) The target from where the log 
		 * 						is called	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function WARN( o : *, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.LOG(o, PXLogLevel.WARN, channel, target);
		}

		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>PXLogLevel.ERROR</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all LogManager listeners.
		 * @param	target		(optional) The target from where the log 
		 * 						is called	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function ERROR( o : *, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.LOG(o, PXLogLevel.ERROR, channel, target);
		}

		/**
		 * Logs passed-in <code>o</code> message into <code>oChannel</code> logging 
		 * channel using <code>PXLogLevel.FATAL</code> level filter.
		 * 
		 * @param	o			Message to log
		 * @param	oChannel	(optional) Event channel to use.<br />
		 * 						If not defined or <code>null</code>, event is 
		 * 						dispatched to all LogManager listeners.
		 * @param	target		(optional) The target from where the log 
		 * 						is called	
		 * 						
		 * 	@return	<code>true</code> if success. ( Log level compliant )
		 * 	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function FATAL( o : *, channel : PXEventChannel = null, target : Object = null ) : Boolean
		{
			return PXLogManager.LOG(o, PXLogLevel.FATAL, channel, target);
		}

		/**
		 * Clears all Logging layout console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function CLEAR( channel : PXEventChannel = null ) : void
		{
			PXLogManager.getInstance().clear(channel);
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
		
		/** @private */
		function PXLogManager()
		{
			level = PXLogLevel.ALL;
			_oCB = new PXChannelBroadcaster();
		}		
	}
}