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
package net.pixlib.commands
{
	import net.pixlib.events.PXCommandEvent;

	/**
	 * Interface for objects which want to be notified of execution end
	 * of a command.
	 * 
	 * @author Francis Bourre
	 * 			
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public interface PXCommandListener
	{
		/**
		 * Called when the command process is beginning.
		 * 
		 * @param	event	event dispatched by the command
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onCommandStart ( event : PXCommandEvent ) : void;

		/**
		 * Called when the command process is over.
		 * 
		 * @param	event	event dispatched by the command
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onCommandEnd ( event : PXCommandEvent ) : void;
	}
}