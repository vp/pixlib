/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */
package net.pixlib.log.layout
{
	import net.pixlib.log.PXStringifier;
	import net.pixlib.collections.PXHashMap;
	import net.pixlib.log.PXLogEvent;
	import net.pixlib.log.PXLogLevel;
	import net.pixlib.log.PXLogListener;

	import flash.events.Event;

	/**	 * The PXDeMonsterDebuggerLayout class provides a convenient way	 * to output messages through <strong>De MonsterDebugger</strong> AIR application.	 * 	 * @example Basic example	 * <listing>	 * 	 * PXDeMonsterDebuggerLayout.CLIENT = MonsterDebugger;	 * PXLogManager.getInstance().addLogListener(PXDeMonsterDebuggerLayout.getInstance());	 * </listing>	 * 	 * @example Customize De MonsterDebugger client class	 * <listing>	 * 	 * PXDeMonsterDebuggerLayout.CLIENT = MyDeMonsterClient;	 * PXDeMonsterDebuggerLayout.AUTO_CLEAR = false;	 * 	 * PXLogManager.getInstance().addLogListener(PXDeMonsterDebuggerLayout.getInstance());	 * </listing>	 * 	 * @see #CLIENT Customize De MonsterDebugger client class	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel	 * @see http://www.demonsterdebugger.com De MonsterDebugger site	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 * 	 * @author Romain Ecarnot	 */
	final public class PXDeMonsterDebuggerLayout implements PXLogListener
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------
		/**		 * @private		 */
		private static  var _oI : PXDeMonsterDebuggerLayout ;

		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------
		/** 		 * @private 		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		protected var mColorLevel : PXHashMap;

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------
		/**		 * The De MonsterDebugger client class to user.		 * 		 * @default net.pixlib.log.layout.MonsterDebugger class		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var CLIENT : Class = MonsterDebugger;
		
		/**		 * Default De MonsterDebugger client root target.		 * 		 * @default null Use the PXbApplication.getInstance().root if 		 * defined.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var ROOT : Object = null;

		/**		 * Indicates if console must be cleared on connection.		 * 		 * @default true		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var AUTO_CLEAR : Boolean = true;

		/**		 * Method name in DeMonsterDebugger to trace ouput message.		 * 		 * @default "trace"		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEBUG_METHOD : String = "trace";

		/**		 * Method name in DeMonsterDebugger to clear ouput messages.		 * 		 * @default "clearTraces"		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var CLEAR_METHOD : String = "clearTraces";

		/**		 * The depth of the trace.		 * 		 * @default 4		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var DEPTH : uint = 4;

		/**		 * Display the public methods of a Class in the output panel.		 * 		 * @default false		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static var FUNCTIONS : Boolean = false;				
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Returns uniqe instance of PXDeMonsterDebuggerLayout class.		 * 		 * @return Unique instance of PXDeMonsterDebuggerLayout class.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function getInstance() : PXDeMonsterDebuggerLayout
		{
			if (!_oI) _oI = new PXDeMonsterDebuggerLayout();
			return _oI;
		}

		/**		 * Releases instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function release() : void
		{
			if ( PXDeMonsterDebuggerLayout._oI is PXDeMonsterDebuggerLayout ) 				PXDeMonsterDebuggerLayout._oI = null;
		}

		/**		 * Triggered when a log message has to be sent.(from the PXLogManager)		 * 		 * @param event	The vent containing information about the message 		 * 					to log. 		 * 						 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function onLog(event : PXLogEvent) : void
		{
			if ( CLIENT.hasOwnProperty(DEBUG_METHOD) )
			{
				CLIENT[ DEBUG_METHOD ](event.logTarget, event.message, mColorLevel.get(event.level), FUNCTIONS, DEPTH);
			}
		}

		/**		 * Clears console.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function onClear(event : Event = null) : void
		{
			if ( CLIENT.hasOwnProperty(CLEAR_METHOD) )
			{
				CLIENT[ CLEAR_METHOD ]();
			}
		}

		/**		 * Returns string representation of instance.		 * 		 * @return The string representation of instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------
		/**		 * @private		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		protected function initColorMap() : void
		{
			mColorLevel = new PXHashMap();
			mColorLevel.put(PXLogLevel.ALL, 0x666666);
			mColorLevel.put(PXLogLevel.DEBUG, 0x0086B3);
			mColorLevel.put(PXLogLevel.INFO, 0x00B32D);
			mColorLevel.put(PXLogLevel.WARN, 0xB38600);
			mColorLevel.put(PXLogLevel.ERROR, 0xB32D00);
			mColorLevel.put(PXLogLevel.FATAL, 0xB3002D);
		}

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------
		/**		 * @private		 */
		function PXDeMonsterDebuggerLayout()
		{
			new CLIENT(ROOT);
			initColorMap();
			if (AUTO_CLEAR) onClear();
		}
	}
}