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
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXCSSPropertyChangeEvent extends PXBasicEvent 
	{
		//--------------------------------------------------------------------
		// Event types
		//--------------------------------------------------------------------
		
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onPropertyChanged</code> event.
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
		 *     	<td><code>newValue</code></td>
		 *     	<td>The new value applied in <code>stylename</code></td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>oldValue</code></td>
		 *     	<td>The old value before change</td>
		 *     </tr>
		 *     
		 *     <tr><th>Method</th><th>Value</th></tr>
		 *     <tr>
		 *     	<td><code>getCSS()</code>
		 *     	</td><td>The CSS target instance</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onPropertyChanged
		 */
		public static const onPropertyChangedEVENT : String = "onPropertyChanged";

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var styleName : String;

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var propertyName : String;

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var newValue : *;
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var oldValue : *;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		 		
		public function PXCSSPropertyChangeEvent(eventType : String, css : PXCSS, styleName : String, propertyName : String, newValue : *, oldValue : * = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(eventType, css, bubbles, cancelable);
			
			this.styleName = styleName;
			this.propertyName = propertyName;
			this.newValue = newValue;
			this.oldValue = oldValue;
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
