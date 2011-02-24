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
package net.pixlib.events {
	import flash.events.Event;

	/**
	 * The <code>PXDynamicEvent</code> class extends the 
	 * <code>PXBasicEvent</code> class and make it dynamic.
	 * <p>
	 * The <code>PXDynamicEvent</code> class is used by 
	 * the <code>PXEventBroadcaster.dispatchEvent</code>
	 * function, which dispatch event using anonymous object,
	 * the event object is then decorated with the object
	 * properties and finally broadcasted as any other event
	 * object. 
	 * </p>
	 * 
	 * @author 	Francis Bourre
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public dynamic class PXDynamicEvent extends PXBasicEvent
	{
		/**
		 * Creates a new instance.
		 * 
		 * @param	type		<code>String</code> name of the event
		 * @param	target		an object considered as source for this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXDynamicEvent( eventType : String, target : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(eventType, target, bubbles, cancelable);
		}

		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			var event : PXDynamicEvent = new PXDynamicEvent(type, bubbles, cancelable);
			
			for (var p:String in this) event[p] = this[p];

			return event;
		}
	}
}