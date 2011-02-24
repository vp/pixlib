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
 
package net.pixlib.core 
{
	import net.pixlib.events.PXBasicEvent;
	import net.pixlib.log.PXStringifier;

	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * The PXLocatorEvent class represents an event object passed 
	 * to the event listener for <code>PXLocator</code> events.
	 * 
	 * @see PXLocator
	 * @see PXLocatorListener
	 * 	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXLocatorEvent extends PXBasicEvent 
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onRegisterObject</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getLocator()</code>
		 *     	</td><td>The Locator owner</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getID()</code>
		 *     	</td><td>The object identifier in use</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getObject()</code>
		 *     	</td><td>The object registered in locator</td>
		 *     </tr>
		 * </table>
		 *  
		 * @eventType onRegisterObject
		 */			
		public static const onRegisterObjectEVENT : String = "onRegisterObject";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onUnregisterObject</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getLocator()</code>
		 *     	</td><td>The Locator owner</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getID()</code>
		 *     	</td><td>The object identifier in use</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getObject()</code>
		 *     	</td><td>Not available in this case</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onUnregisterObject
		 */	
		public static const onUnregisterObjectEVENT : String = "onUnregisterObject";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * The identifier carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var id : String;
		
		/**
		 * The object carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		public var value : Object;

		/**
		 * The PXLocator object carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get locator(  ) : PXLocator
		{
			return target as PXLocator;	
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>PXLocatorEvent</code> object.
		 * 
		 * @param	type				Name of the event type
		 * @param	locatorTarget		PXLocator owner
		 * @param	id					Registration ID
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXLocatorEvent( type : String, locatorTarget : PXLocator, key : String, o : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(type, locatorTarget, bubbles, cancelable);
			
			id = key;
			value = o;
		}

		/**
		 * Clone the event.
		 * 
		 * @return	A cloned event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function clone() : Event
		{
			return new PXLocatorEvent(type, locator, id, value);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString() : String
		{
			return PXStringifier.process(this) + "<" + getQualifiedClassName(locator) + ">." + type + "(" + id + ")";
		}
	}
}
