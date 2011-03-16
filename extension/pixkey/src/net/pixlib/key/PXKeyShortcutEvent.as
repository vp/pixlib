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

package net.pixlib.key
{

	import net.pixlib.events.PXBasicEvent;
	import net.pixlib.log.PXStringifier;

	/**
	 * The PXKeyShortcutEvent class represents the event object passed to the event 
	 * listener for <strong>PXKeyShortcut</strong> events.
	 * 
	 * <p>The properties of the event object have the following values:</p>
	 * <table class="innertable">
	 *     <tr><th>Property</th><th>Value</th></tr>
	 *     <tr>
	 *     	<td><code>target</code></td>
	 *     	<td>The Object that defines the event listener that handles the event</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>type</code></td>
	 *     	<td>Dispatched event type</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>charCode</code></td>
	 *     	<td>The character code value of the key pressed or released.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>keyCode</code></td>
	 *     	<td>The key code value of the key pressed or released.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>altKey</code></td>
	 *     	<td><code>true</code> if the Alt key is active.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>ctrlKey</code></td>
	 *     	<td><code>true</code> if the Control key is active.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>shiftKey</code></td>
	 *     	<td><code>true</code> if the Shitf key is active.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>keyLocation</code></td>
	 *     	<td>The location of the key on the keyboard.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>shortcut</code></td>
	 *     	<td>Activated key shortcut.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>bundle</code></td>
	 *     	<td>Shortcut bundke which contains activated key shortcut.</td>
	 *     </tr>
	 *     <tr>
	 *     	<td><code>target</code>
	 *     	</td><td>The Object that defines the
	 *       event listener that handles the event</td></tr>
	 *     <tr>
	 *     	<td><code>type</code></td>
	 *     	<td>Dispatched event type</td>
	 *     </tr>
	 * </table>
	 * 
	 * @see PXKeyShortcut
	 * @see PXKeyBundle
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXKeyShortcutEvent extends PXBasicEvent
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _key : PXKeyShortcut;

		/**
		 * @private
		 */
		private var _map : PXKeyBundle;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var charCode : uint;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var keyCode : uint;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var altKey : Boolean;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var ctrlKey : Boolean;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var shiftKey : Boolean;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var keyLocation : uint;


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Constructor.
		 *
		 * @param key : PXKeyShortcut object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXKeyShortcutEvent(key : PXKeyShortcut, bundle : PXKeyBundle)
		{
			super(key.combo);

			_key = key;
			_map = bundle;
		}

		/**
		 * The activated PXKeyShortcut instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get shortcut() : PXKeyShortcut
		{
			return _key;
		}

		/**
		 * The key bundle which contains activated 
		 * key shortcut.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get bundle() : PXKeyBundle
		{
			return _map;
		}

		/**
		 * Returns string representation.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function toString() : String
		{
			return PXStringifier.process(this) + "[" + _key.name + "]";
		}
	}
}
