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
	import flash.utils.getQualifiedClassName;
	import net.pixlib.collections.PXHashMap;

	/**
	 * The PXTraceLayout class provides a convenient way
	 * to output messages through the Adobe Flash IDE output panel.
	 * 
	 * @see net.pixlib.log.LogManager
	 * @see net.pixlib.log.LogListener
	 * @see net.pixlib.log.LogLevel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Romain Ecarnot
	 */
	final public class PXTraceLayout implements PXLogListener
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public static const DEBUG_PREFIX : String = "[debug]";
		
		/**
		 * @private
		 */
		public static const INFO_PREFIX : String = "[info]";
		
		/**
		 * @private
		 */
		public static const WARN_PREFIX : String = "[warn]";
		
		/**
		 * @private
		 */
		public static const ERROR_PREFIX : String = "[error]";
		
		/**
		 * @private
		 */
		public static const FATAL_PREFIX : String = "[fatal]";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		private static var _oI : PXTraceLayout = null;
		
		/**
		 * @private 
		 */
		private var _mFormat : PXHashMap;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Retreives <code>PXTraceLayout</code> unique instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance() : PXTraceLayout
		{
			if(!_oI) _oI = new PXTraceLayout();
			return _oI;
		}

		/**
		 * Triggered when a log message is sent by the <code>PXLogManager</code>.
		 * 
		 * @param	e	<code>PXLogEvent</code> event containing information about 
		 * 				the message to log.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onLog( event : PXLogEvent ) : void
		{
			var prefix : String = _mFormat.get(event.level);
			var target : String = (event.logTarget != null) ? "[" + getQualifiedClassName(event.logTarget) + "] " : " ";
			
			trace(prefix + target + event.message);
		}

		/**
		 * Clears console messages.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear( event : Event = null ) : void
		{
			
		}

		
		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------		
		
		/** @private */
		function PXTraceLayout()
		{
			_initPrefixMap();
		}
		
		/**
		 * @private
		 */
		private function _initPrefixMap( ) : void
		{
			_mFormat = new PXHashMap();
			_mFormat.put(PXLogLevel.DEBUG, DEBUG_PREFIX);
			_mFormat.put(PXLogLevel.INFO, INFO_PREFIX);
			_mFormat.put(PXLogLevel.WARN, WARN_PREFIX);
			_mFormat.put(PXLogLevel.ERROR, ERROR_PREFIX);
			_mFormat.put(PXLogLevel.FATAL, FATAL_PREFIX);
		}
	}
}