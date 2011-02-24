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
package net.pixlib.load
{
	import net.pixlib.core.PXLocator;
	import net.pixlib.core.PXLocatorEvent;

	/**
	 * The PXLoaderLocatorEvent class represents the event object passed 
	 * to the event listener for <code>PXLoaderLocator</code> events.
	 * 
	 * @see PXLoaderLocator
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Romain Ecarnot
	 */
	final public class PXLoaderLocatorEvent extends PXLocatorEvent 
	{
		/**
		 * The loader object carried by this event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get loader() : PXLoader
		{
			return value as PXLoader;
		}
		
		/**
		 * Creates a new instance.
		 * 
		 * @param	type			Name of the event type
		 * @param	name			Registration key
		 * @param	gl				Loader object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXLoaderLocatorEvent( eventType : String, locatorTarget : PXLocator, name : String, loaderTarget : PXLoader, bubbles : Boolean = false, cancelable : Boolean = false ) 
		{
			super(eventType, locatorTarget, name, loaderTarget, bubbles, cancelable);
		}
	}
}