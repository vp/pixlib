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
 
package net.pixlib.model 
{
	import net.pixlib.events.PXStringEvent;

	/**
	 * An event object which carry a <code>Model</code> value.
	 * 
	 * @see Model
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXModelEvent extends PXStringEvent 
	{
		//--------------------------------------------------------------------
		// Events
		//--------------------------------------------------------------------
				
		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onInitModel</code> event.
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
		 *     	<td><code>getModel()</code>
		 *     	</td><td>The model object</td>
		 *     </tr>
		 *     <tr>
		 *     	<td><code>getModelID()</code>
		 *     	</td><td>The model identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onInitModel
		 */
		public static const onInitModelEVENT : String = "onInitModel";

		/**
		 * Defines the value of the <code>type</code> property of the event 
		 * object for a <code>onReleaseModel</code> event.
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
		 *     	<td><code>getModel()</code>
		 *     	</td><td>The model object</td>
		 *     </tr>
		 *      <tr>
		 *     	<td><code>getModelID()</code>
		 *     	</td><td>The model identifier</td>
		 *     </tr>
		 * </table>
		 * 
		 * @eventType onReleaseModel
		 */	
		public static const onReleaseModelEVENT : String = "onReleaseModel";

		
		//--------------------------------------------------------------------
		// Public Properties
		//--------------------------------------------------------------------
		
		/**
		 * The model object carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get model() : PXModel
		{
			return super.target as PXModel;
		}

		/**
		 * The model name carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get modelID(  ) : String
		{
			return value;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new <code>PXModelEvent</code> object.
		 * 
		 * @param	eventType		Name of the event type
		 * @param	view			Model object carried by this event
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXModelEvent(eventType : String, model : PXModel = null, name : String = null )
		{
			super(eventType, model, name);
		}
	}
}
