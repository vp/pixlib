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

package net.pixlib.log.layout 
{
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.log.PXLogEvent;
	import net.pixlib.log.PXLogLevel;
	import net.pixlib.log.PXLogListener;

	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.getQualifiedClassName;

	/**
	 * The PXFirebugLayout class provides a convenient way
	 * to output messages through <strong>Firebug</strong> console.
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXLogManager.getInstance().addLogListener(PXFirebugLayout.getInstance());
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel
	 * @see http://addons.mozilla.org/fr/firefox/addon/1843 Firebug extension
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Romain Ecarnot
	 */
	final public class PXFirebugLayout implements PXLogListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private const CONSOLE_DEBUG_METHOD : String = "console.debug";
		
		/**
		 * @private
		 */
		private const CONSOLE_INFO_METHOD : String = "console.info";
		
		/**
		 * @private
		 */
		private const CONSOLE_WARN_METHOD : String = "console.warn";
		
		/**
		 * @private
		 */
		private const CONSOLE_ERROR_METHOD : String = "console.error";
		
		/**
		 * @private
		 */
		private const CONSOLE_FATAL_METHOD : String = "console.error";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _oI : PXFirebugLayout = null;
		
		/**
		 * @private
		 */
		private var _mFormat : PXHashMap;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns unique instance of PXFirebugLayout class.
		 * 
		 * @return unique instance of PXFirebugLayout class.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance() : PXFirebugLayout
		{
			if(!_oI) _oI = new PXFirebugLayout();
						
			return _oI;
		}

		/**
		 * Triggered when a log message has to be sent.(from the PXLogManager)
		 * 
		 * @param event	The event containing information about the message 
		 * 					to log. 
		 * 				
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onLog( event : PXLogEvent ) : void
		{
			var methodName : String = _mFormat.get(event.level);
			var msg : * = event.message;
			
			if(msg is String)
			{
				var target : String = (event.logTarget != null) ? "[" + getQualifiedClassName(event.logTarget) + "] " : "";
				
				msg = target + event.message;
			}
			
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call(methodName, msg);
				}
			}
			catch( e : Error ) 
			{
			}
		}

		/**
		 * Clears console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear( event : Event = null ) : void
		{
			//Not available here
		}

		/**
		 * Writes the passed-in <code>caption</code> message to the console and opens 
		 * a nested block to indent all future messages sent to the console.
		 * 
		 * @param caption Group name
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function openGroup( caption : String ) : void
		{
			var title : String = ( caption ) ? caption : "new group";
			
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call("console.group", title);
				}
			}
			catch( e : Error ) 
			{ 
			}
		}

		/**
		 * Closes the most recently opened block created by a call to 
		 * <code>openGroup()</code> method.
		 * 
		 * @see #openGroup
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function closeGroup( ) : void
		{
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call("console.groupEnd");
				}
			}
			catch( e : Error ) 
			{
			}
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function trace( value : * ) : void
		{
			try
			{
				if( ExternalInterface.available )
				{
					ExternalInterface.call(CONSOLE_DEBUG_METHOD, value);
				}
			}
			catch( e : Error ) 
			{ 
			}
		}

		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------		
		
		/** @private */
		function PXFirebugLayout()
		{
			_initMethodMap();
		}
		
		/** @private */
		private function _initMethodMap( ) : void
		{
			_mFormat = new PXHashMap();
			_mFormat.put(PXLogLevel.DEBUG, CONSOLE_DEBUG_METHOD);
			_mFormat.put(PXLogLevel.INFO, CONSOLE_INFO_METHOD);
			_mFormat.put(PXLogLevel.WARN, CONSOLE_WARN_METHOD);
			_mFormat.put(PXLogLevel.ERROR, CONSOLE_ERROR_METHOD);
			_mFormat.put(PXLogLevel.FATAL, CONSOLE_FATAL_METHOD);
		}
	}
}