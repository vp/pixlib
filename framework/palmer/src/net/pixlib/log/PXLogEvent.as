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
	import flash.events.Event;	

	/**
	 * The PXLogEvent class represents the event object passed 
	 * to the event listener for PXLogManager events.
	 * 
	 * @see PXLogManager
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXLogEvent extends Event
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onLog</code> event.
		 * 
		 * @eventType onLog
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static const onLogEVENT : String = "onLog";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onClear</code> event.
		 * 
		 * @eventType onClear
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static const onClearEvent : String = "onClear";

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Log level for current logging message.
		 * @default null
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public var level : PXLogLevel;

		/**
		 * Message
		 * 
		 * @default *
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public var message : *;

		/**
		 * Debug Target
		 * 
		 * @default null
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var logTarget : Object;

		/**
		 * Name of the used channel by this 
		 * logging event.
		 * 
		 * @default null
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var channel : String;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	level	LogLevel status
		 * @param	message	Message to send
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXLogEvent( level : PXLogLevel, message : * = undefined, target : Object = null )
		{
			super(PXLogEvent.onLogEVENT, false, false);

			this.level = level;
			this.message = message;
			this.logTarget = target;
		}

		/**
		 * Duplicates an instance of an Event subclass. 
		 * 
		 * <p>The new Event object includes all the properties of the 
		 * original.</p>
		 * 
		 * @return	A new Event object that is identical to the original.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function clone() : Event 
		{
			return new PXLogEvent(level, message, logTarget);
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return The string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public override function toString() : String 
		{
			return PXStringifier.process(this);
		}
	}
}