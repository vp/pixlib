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
	import net.pixlib.log.PXLogEvent;
	import net.pixlib.log.PXLogListener;
	import net.pixlib.log.PXStringifier;

	import flash.events.Event;
	import flash.net.LocalConnection;

	/**
	 * The PXLuminicBoxLayout class provides a convenient way
	 * to output messages through <strong>Luminic Box</strong> console.
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXLogManager.getInstance().addLogListener(PXLuminicBoxLayout.getInstance());
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel
	 * @see	http://osflash.org/luminicbox.log LuminicBox on OsFlash
	 * 
	 * @author	Francis Bourre
	 */
	final public class PXLuminicBoxLayout implements PXLogListener
	{
		/** @private */
		static private var _oI : PXLuminicBoxLayout = null;
		
		/** @private */
		public const LOCALCONNECTION_ID : String = "_luminicbox_log_console";
		
		/** @private */
		protected const _lc : LocalConnection = new LocalConnection();
		
		/** @private */
		protected const _sID : String = String(( new Date()).getTime());
		
		/**
		 * Returns unique instance.
		 * 
		 * @return unique instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXLuminicBoxLayout
		{
			if (!_oI) _oI = new PXLuminicBoxLayout();
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
			_lc.send(LOCALCONNECTION_ID, "log", {LoggerId:_sID, levelName:event.level.name, time:new Date(), version:.15, argument:{type:"string", value:event.message.toString()}});
		}

		/**
		 * Clears console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear( e : Event = null ) : void
		{
			//Not available here
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}
		
		/**
		 * @private
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXLuminicBoxLayout()
		{
			
		}
	}
}