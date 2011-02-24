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

package net.pixlib.display.css.event 
{
	import net.pixlib.display.css.PXCSS;
	import net.pixlib.events.PXBasicEvent;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXCSSStyleChangeEvent extends PXBasicEvent 
	{
		//--------------------------------------------------------------------
		// Event types
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onStyleChanged</code> event.
		 * 
		 * <p>The properties of the event object have the following values:</p>
		 * <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>type</code></td>
		 *     	<td>Dispatched event type</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>styleName</code></td>
		 *     	<td>The style name has changed</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>newStyle</code></td>
		 *     	<td>The new style applied for <code>stylename</code></td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>oldStyle</code></td>
		 *     	<td>The old style before change</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCSS()</code>
		 *     	</td><td>The CSS target instance</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onStyleChanged
		 */
		public static const onStyleChangedEVENT : String = "onStyleChanged";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		private var _oldStyle : Object; 

		/** @private */
		private var _newStyle : Object; 

		/** @private */
		private var _styleName : String;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get styleName() : String
		{
			return _styleName;		
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get newStyle() : Object
		{
			return _newStyle;		
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get oldStyle() : Object
		{
			return _oldStyle;		
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		 		
		public function PXCSSStyleChangeEvent(eventType : String, css : PXCSS, styleName : String, newStyle : Object, oldStyle : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(eventType, css, bubbles, cancelable);
			
			_styleName = styleName;
			_newStyle = newStyle;
			_oldStyle = oldStyle;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getCSS() : PXCSS
		{
			return target as PXCSS;
		}
	}
}
