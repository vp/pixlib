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
	import flash.events.Event;

	/**
	 * An event object which carry any object.
	 * 
	 * @author	Axel Aigret
	 * @author 	Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	final public class PXObjectEvent extends PXBasicEvent
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Object value carried with this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var value : Object;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new instance.
		 * 
		 * @param	type		name of the event type
		 * @param	target		target of this event
		 * @param	o			object carried by this event
		 * @param 	bubbles		Determines whether the Event object participates 
		 * 						in the bubbling stage of the event flow
		 * @param 	cancelable	Determines whether the Event object can be canceled
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXObjectEvent( eventType : String, oTarget : Object = null, o : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(eventType, oTarget, bubbles, cancelable);
			value = o;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			return new PXObjectEvent(type, target, value, bubbles, cancelable);
		}
	}
}