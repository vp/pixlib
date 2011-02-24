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
	import net.pixlib.events.PXEventChannel;	

	/**
	 * Pixlib Logging interface.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre	 */
	public interface PXLog 
	{
		/**
		 * Returns event channel used for communication.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get channel() : PXEventChannel;

		/**
		 * Returns <code>true</code> if logging tunnel is opened.
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get activated() : Boolean;
		
		/**
		 * Logs passed-in message with a log level defined  
		 * at 'debug' mode.
		 * 
		 * @param	o		Message to log
		 * @param	target	(optional) The target from where the log 
		 * 					is called
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function debug( o : *, target : Object = null ) : void;

		/**
		 * Logs passed-in message with a log level defined  
		 * at 'info' mode..
		 * 
		 * @param	o		Message to log
		 * @param	target	(optional) The target from where the log 
		 * 					is called 
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		function info( o : *, target : Object = null ) : void;

		/**
		 * Logs passed-in message with a log level defined  
		 * at 'warn' mode..
		 * 
		 * @param	o		Message to log
		 * @param	target	(optional) The target from where the log 
		 * 					is called 
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		function warn( o : *, target : Object = null ) : void;

		/**
		 * Logs passed-in message with a log level defined  
		 * at 'error' mode..
		 * 
		 * @param	o		Message to log
		 * @param	target	(optional) The target from where the log 
		 * 					is called 
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		function error( o : *, target : Object = null ) : void;

		/**
		 * Logs passed-in message with a log level defined  
		 * at 'fatal' mode..
		 * 
		 * @param	o		Message to log
		 * @param	target	(optional) The target from where the log 
		 * 					is called 
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		function fatal( o : *, target : Object = null ) : void;

		/**
		 * Clears Logging layout registered for this event channel.
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function clear( ) : void;

		/**
		 * Opens the logging tunnel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function activate() : void;

		/**
		 * Closes the logging tunnel.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function desactivate() : void;
	}}