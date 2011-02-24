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
	import net.pixlib.log.PXStringifier;

	import flash.events.Event;

	/**
	 * The <code>PXBasicEvent</code> class adds the ability for
	 * developpers to change the <code>type</code> and the 
	 * <code>target</code> of an event after its creation.
	 * 
	 * @author 	Francis Bourre	 * @author 	Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */	
	public class PXBasicEvent extends Event
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Event type.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var sType : String;
		
		/**
		 * Event target.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oTarget : Object;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The event type of this event.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function get type() : String
		{
			return sType;	
		}
		/** @private */
		public function set type(value : String) : void
		{
			sType = value;
		}
		
		/**
		 * The event type of this event.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function get target() : Object
		{
			return oTarget;	
		}
		/** @private */
		public function set target(value : Object) : void
		{
			oTarget = value;
		}
		

		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new PXBasicEvent event for the
		 * passed-in event type. The <code>target</code> is optional, 
		 * if the target is omitted and the event used in combination
		 * with the <code>PXEventBroadcaster</code> class, the event
		 * target will be set on the event broadcaster source.
		 * 
		 * @param	type		<code>String</code> name of the event
		 * @param	target		an object considered as source for this event
		 * @param 	bubbles		Determines whether the Event object participates 
		 * 						in the bubbling stage of the event flow
		 * @param 	cancelable	Determines whether the Event object can be canceled.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXBasicEvent( type : String, target : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(type, bubbles, cancelable);
			
			sType = type;
			this.target = target;
		}
		
		/**
		 * Clone the event.
		 * 
		 * @return	a clone of the event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function clone() : Event
		{
			return new PXBasicEvent(type, target, bubbles, cancelable);
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
			return PXStringifier.process(this);
		}
	}
}