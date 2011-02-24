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
package net.pixlib.services
{
	import net.pixlib.collections.PXCollection;
	import net.pixlib.commands.PXCommand;
	import net.pixlib.encoding.PXDeserializer;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public interface PXService extends PXCommand
	{
		/**
		 * Service call result.
		 * 
		 * <p>If a data deserializer is defined, the result is the result 
		 * of deserialization process.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get result() : Object;

		/**
		 * @private
		 */
		function set result(result : Object) : void;

		/**
		 * Service call raw result. (deserializer process is not applied).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get rawResult() : Object;
		
		function get listeners() : PXCollection;
		
		/**
		 * @copy net.pixlib.event.PXEventBroadcaster#addListener
		 */
		function addListener(listener : PXServiceListener) : Boolean;
		
		/**
		 * @copy net.pixlib.event.PXEventBroadcaster#removeListener
		 */
		function removeListener(listener : PXServiceListener) : Boolean;
		
		/**
		 * @copy net.pixlib.event.PXEventBroadcaster#addEventListener
		 */
		function addEventListener(type : String, listener : Object, ... rest) : Boolean;
		
		/**
		 * @copy net.pixlib.event.PXEventBroadcaster#removeEventListener
		 */
		function removeEventListener(type : String, listener : Object) : Boolean;
		
		/**
		 * Adds arguments to service call.
		 * 
		 * @param rest	List of argument to pass to service call
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function setArguments(... rest) : void;
		
		/**
		 * Returns arguments passed to service call.
		 * 
		 * @return arguments passed to service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function getArguments() : Object;
		
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function setDeserializer(deserializer : PXDeserializer, target : Object = null) : void;
		
		/**
		 * Fires PXServiceEvent.onDataResultEVENT when result is received by 
		 * Service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireResult() : void;
		
		/**
		 * Fires PXServiceEvent.onDataErrorEVENT when error is received by 
		 * Service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function fireError() : void;
		
		/**
		 * Releases service.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release() : void;
	}
}