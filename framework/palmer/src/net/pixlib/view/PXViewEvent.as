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

package net.pixlib.view
{
	import net.pixlib.events.PXStringEvent;


	/**
	 * An event object which carry a <code>PXView</code> value.
	 * 
	 * @see PXView
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXViewEvent extends PXStringEvent
	{
		// --------------------------------------------------------------------
		// Events
		// --------------------------------------------------------------------

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onInitView</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>view</code></td>
		 *     	<td>The view</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>viewID</code></td>
		 *     	<td>The view's identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onInitView
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const onInitViewEVENT : String = "onInitView";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onReleaseView</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>view</code></td>
		 *     	<td>The view</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>viewID</code></td>
		 *     	<td>The view's identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onReleaseView
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static const onReleaseViewEVENT : String = "onReleaseView";


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * The view carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get view() : PXView
		{
			return target as PXView;
		}
		

		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates new instance.
		 * 
		 * @param	type	Name of the event type
		 * @param	view	View object carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXViewEvent(eventType : String, view : PXView = null, name : String = null)
		{
			super(eventType, view, name);
		}
	}
}
