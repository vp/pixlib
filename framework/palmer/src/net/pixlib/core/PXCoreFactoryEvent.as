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

	/**
	 * An event object structure used by the PXCoreFactory implementation.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXCoreFactoryEvent extends PXBasicEvent
	{
		//--------------------------------------------------------------------
		// Event types
		//--------------------------------------------------------------------
		
		/**
		 *  The <code>CoreFactoryEvent.onRegisterBeanEVENT</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>onRegisterBean</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. </td></tr>
		 *  </table>
		 *
		 *  @eventType onRegisterBean
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 */
		public static const onRegisterBeanEVENT : String = "onRegisterBean";
		
		/**
		 *  The <code>PXCoreFactoryEvent.onUnregisterBeanEVENT</code> constant defines the value of the 
		 *  <code>type</code> property of the event object for a <code>onUnregisterBean</code> event.
		 * 
		 *  <p>The properties of the event object have the following values:</p>
		 *  <table class="innertable">
		 *     <tr><th>Property</th><th>Value</th></tr>
		 *     <tr><td><code>bubbles</code></td><td>false</td></tr>
		 *     <tr><td><code>cancelable</code></td><td>false</td></tr>
		 *     <tr><td><code>target</code></td><td>The Object that dispatched the event; 
		 *       it is not always the Object listening for the event. </td></tr>
		 *  </table>
		 *
		 *  @eventType onUnregisterBean
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 */
		public static const onUnregisterBeanEVENT : String = "onUnregisterBean";
				
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Bean identifier
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var id : String;
		
		/**
		 * Bean object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var bean : Object;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param type	Event type broadcasted
		 * @param id	Ressource identifier
		 * @param bean	Ressource object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXCoreFactoryEvent( type : String, id : String, bean : Object )
		{
			super(type, bean);
			
			this.id = id;
			this.bean = bean;
		}
	}
}