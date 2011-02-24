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
	import flash.net.XMLSocket;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * The PXSosMaxLayout class provides a convenient way
	 * to output messages through <strong>SOS</strong> Max console.
	 * 
	 * @example
	 * <listing>
	 * 
	 * PXLogManager.getInstance().addLogListener(PXSosMaxLayout.getInstance());
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel
	 * @see http://solutions.powerflasher.com/products/sosmax PowerFlasher SosMax
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	final public class PXSosMaxLayout implements PXLogListener
	{
		/**
		 * @private
		 */
		protected var _oXMLSocket : XMLSocket;
		
		/**
		 * @private
		 */
		protected var _aBuffer : Array;
		
		/**
		 * SOS connection address.
		 * 
		 * @default "localhost"
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public var IP : String = "localhost";
		
		/**
		 * SOS connection port
		 * 
		 * @default 4444
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public var PORT : Number = 4444;
		
		/**
		 * @private
		 */
		static private var _oI : PXSosMaxLayout = null;

		/**
		 * Returns unique instance of PXSosMaxLayout class.
		 * 
		 * @return unique instance of PXSosMaxLayout class.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function getInstance() : PXSosMaxLayout
		{
			if (!_oI) _oI = new PXSosMaxLayout();
			return _oI;
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function output( message : String ) : void
		{
			if ( _oXMLSocket.connected )
			{
				_oXMLSocket.send(message);
			} 
			else
			{	
				_aBuffer.push(message);
			}
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function formatMessage( e : PXLogEvent ) : String
		{
			var message : String = String(e.message);

			var lines : Array = message.split("\n");
			var xmlMessage : XML = new XML("<" + (lines.length == 1 ? "showMessage" : "showFoldMessage") + " key='" + e.level.name + "' />");

			if ( lines.length > 1 )
			{
				var target : String = (e.logTarget != null) ? "[" + getQualifiedClassName(e.logTarget) + "] " : "";
				
				xmlMessage.title = target + lines[0];
				xmlMessage.message = message.substr(message.indexOf("\n") + 1, message.length);
			} 
			else
			{
				xmlMessage.appendChild(message);
			}

			return '!SOS' + xmlMessage.toXMLString() + '\n';
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clearOutput() : void
		{
			output("!SOS<clear/>\n");
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
			output(formatMessage(event));
		}

		/**
		 * Clears console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear( e : Event = null ) : void
		{
			clearOutput();
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
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _emptyBuffer( event : Event ) : void
		{
			var l : Number = _aBuffer.length;
			for (var i : Number = 0;i < l;i++) _oXMLSocket.send(_aBuffer[i]);
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function _tryToReconnect( event : Event ) : void 
		{
            
		}
		
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXSosMaxLayout()
		{
			_aBuffer = new Array();
			_oXMLSocket = new XMLSocket();
			_oXMLSocket.addEventListener(Event.CONNECT, _emptyBuffer);
			_oXMLSocket.addEventListener(Event.CLOSE, _tryToReconnect);
			_oXMLSocket.connect(PXSosMaxLayout.IP, PXSosMaxLayout.PORT);
		}
	}
}