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
package net.pixlib.log 
{
	import flash.events.Event;

	/**
	 * The PXLogListener must be implemented by all objects which want to listen 
	 * to Logging API events, like logging console.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public interface PXLogListener 
	{
		/**
		 * Triggered when a Log event is broadcasted by the Logging API.
		 * 
		 * @param	event	LogEvent event
		 * 
		 * @see	PXLogManager	
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLog( event : PXLogEvent ) : void;

		/**
		 * Triggered when a clear event is broadcasted by the Logging API.
		 * 
		 * @param	event	Event event
		 * 
		 * @see	PXLogManager	
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onClear( event : Event = null ) : void;
	}
}