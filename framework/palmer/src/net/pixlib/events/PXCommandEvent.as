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
	import net.pixlib.commands.PXCommand;

	import flash.events.Event;

	/**
	 * An event broadcasted by a Command object.
	 * 
	 * @author 	Francis Bourre
	 * @author	Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXCommandEvent extends PXBasicEvent
	{
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onCommandStart</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>command</code>
		 *     	</td><td>The PXCommand target instance</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onCommandStart
		 */
		static public const onCommandStartEVENT : String = "onCommandStart";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onCommandEnd</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>command</code>
		 *     	</td><td>The PXCommand target instance</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onCommandEnd
		 */
		static public const onCommandEndEVENT : String = "onCommandEnd";
		
		/**
		 * Returns the <code>PXCommand</code> target.
		 * 
		 * @return	the command which broadcasted this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get command() : PXCommand
		{
			return target as PXCommand;
		}
		
		/**
		 * Creates a new instance.
		 * 
		 * @param	type	name of the event type
		 * @param	target	target of this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCommandEvent( eventType : String, target : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super(eventType, target, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone() : Event
		{
			return new PXCommandEvent(type, target, bubbles, cancelable);
		}
	}
}
