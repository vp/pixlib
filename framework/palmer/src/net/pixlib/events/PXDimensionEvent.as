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
	import net.pixlib.structures.PXDimension;

	import flash.events.Event;

	/**
	 * An event object which carry a <code>PXDimension</code> value.
	 * 
	 * @author 	Aigret Axel
	 * @author 	Romain Ecarnot
	 * 
	 * @see net.pixlib.structures.PXDimension
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	final public class PXDimensionEvent extends PXBasicEvent 
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * PXDimension value carried with this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var value : PXDimension;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new instance.
		 * 
		 * @param	type		Name of the event type
		 * @param	target		Target of this event
		 * @param	dimension	PXDimension object carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXDimensionEvent(eventType : String, target : Object = null , dimension : PXDimension = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(eventType, target, bubbles, cancelable);
			
			value = dimension ;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			return new PXDimensionEvent(type, target, value, bubbles, cancelable);
		}
	}
}
