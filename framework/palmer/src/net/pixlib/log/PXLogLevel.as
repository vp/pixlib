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

	/**
	 * The PXLogLevel class allow to filter log messages with logging level.
	 * 
	 * @example
	 * <listing>
	 * 
	 * //filter level
	 * PXLogManager.getInstance().setLevel( PXLogLevel.INFO );
	 * 
	 * PXLogManager.INFO( "this is a information message" ); //sent to all listeners
	 * PXLogManager.DEBUG( "this is a debug message" ); //Not sent cause of level filter
	 * </listing>
	 * 
	 * @see	PXLogListener
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXLogLevel
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------

		public static const ALL : PXLogLevel = new PXLogLevel(uint.MIN_VALUE, "ALL");
		public static const DEBUG : PXLogLevel = new PXLogLevel(10000, "DEBUG");
		public static const INFO : PXLogLevel = new PXLogLevel(20000, "INFO");
		public static const WARN : PXLogLevel = new PXLogLevel(30000, "WARN");
		public static const ERROR : PXLogLevel = new PXLogLevel(40000, "ERROR");
		public static const FATAL : PXLogLevel = new PXLogLevel(50000, "FATAL");
		public static const OFF : PXLogLevel = new PXLogLevel(uint.MAX_VALUE, "OFF");

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _sName : String;
		
		/**
		 * @private
		 */
		private var _nLevel : Number;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The name of current level filter.
		 * 
		 * @return The name of current level filter.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get name() : String
		{
			return _sName;
		}

		/**
		 * The level filter value.
		 * 
		 * @return The level filter value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get level() : uint
		{
			return _nLevel;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates instance.
		 * 
		 * @param	level	Minimum level the log message has to be, to 
		 * 			be compliant with this current LogLevel filter.
		 * 	@param	Name 	identifier for this level.
		 * 	
		 * 	@langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXLogLevel( level : uint = uint.MIN_VALUE, name : String = "" )
		{
			_sName = name;
			_nLevel = level;
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return The string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}
	}
}
