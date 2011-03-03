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
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;

	/**
	 * The PXAirLoggerLayout class provides a convenient way
	 * to output messages through <strong>AirLogger</strong> console.
	 * 
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogManager.html net.pixlib.log.PXLogManager
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogListener net.pixlib.log.PXLogListener
	 * @see PIXLIB_DOC/net/pixlib/log/PXLogLevel net.pixlib.log.PXLogLevel
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Cédric Néhémie
	 */
	final public class PXAirLoggerLayout implements PXLogListener
	{
		/*---------------------------------------------------------------
		STATIC MEMBERS
		----------------------------------------------------------------*/
		
		/** @private */
		private static var _oI : PXAirLoggerLayout = null;

		/** @private */		
		protected static const LOCALCONNECTION_ID : String = "_AIRLOGGER_CONSOLE";
		
		/** @private */	
		protected static const OUT_SUFFIX : String = "_IN";
		
		/** @private */		
		protected static const IN_SUFFIX : String = "_OUT";

		/** @private */		
		static protected var ALTERNATE_ID_IN : String = "";
		
		
		/**
		 * Returns unique instance of PXAirLoggerLayout.
		 * 
		 * @return unique instance of PXAirLoggerLayout
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance() : PXAirLoggerLayout
		{
			if(!_oI) _oI = new PXAirLoggerLayout();
				
			return _oI;
		}

		/**
		 * Releases connection and singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function release() : void
		{
			_oI.close();
			_oI = null;
		}

		
		/*---------------------------------------------------------------
		INSTANCE MEMBERS
		----------------------------------------------------------------*/
		
		/** @private */		
		protected var _lcOut : LocalConnection;
		
		/** @private */		
		protected var _lcIn : LocalConnection;
		
		/** @private */		
		protected var _sID : String;

		/** @private */		
		protected var _bIdentified : Boolean;
		/** @private */		
		protected var _bRequesting : Boolean;

		/** @private */		
		protected var _aLogStack : Array;
		
		/** @private */		
		protected var _nPingRequest : Number;

		/** @private */		
		protected var _sName : String;

		
		/** @private */
		function PXAirLoggerLayout()
		{
			try
			{
				_lcOut = new LocalConnection();
				_lcOut.addEventListener(StatusEvent.STATUS, onStatus, false, 0, true);
				_lcOut.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError, false, 0, true);
	            
				_lcIn = new LocalConnection();
				_lcIn.client = this;
				_lcIn.allowDomain("*");
	            
				connect();
	            
				_aLogStack = new Array();
	            
				_bIdentified = false;
				_bRequesting = false;
			} catch ( e : Error )
			{
            	
			}
		}

		/**
		 * @private
		 * Connects to the AirLogger console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function connect() : void
		{
			var b : Boolean = true;
			
			while( b )
			{
				try
				{
					_lcIn.connect(_getInConnectionName(ALTERNATE_ID_IN));
		           
					b = false;
					break;
				}
				catch ( e : Error )
				{
					_lcOut.send(_getOutConnectionName(), "mainConnectionAlreadyUsed", ALTERNATE_ID_IN);
					
					ALTERNATE_ID_IN += "_";
				}
			}
		}

		/**
		 * @private
		 * Closes connection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function close() : void
		{
			_lcIn.close();
		}

		/**
		 * @private
		 * Gives focus to AirLogger console.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function focus() : void
		{
			_send(new AirLoggerEvent("focus"));
		}

		/**
		 * @private
		 * Clears AirLogger console messages.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			_send(new AirLoggerEvent("clear"));
		}

		/**
		 * @private
		 * Sets tab name for current connection in use.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setName( s : String ) : void
		{
			_sName = s;
			
			if( _bIdentified )
			{
				_lcOut.send(_getOutConnectionName(_sID), "setTabName", _sName);
			}
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setID( id : String ) : void
		{
			try
			{
				clearInterval(_nPingRequest);
				_sID = id;
				
				_lcIn.close();
				_lcIn.connect(_getInConnectionName(_sID));
				
				_lcOut.send(_getOutConnectionName(), "confirmID", id, _sName);
				
				_bIdentified = true;
				_bRequesting = false;
				
				var l : Number = _aLogStack.length;
				if( l != 0 )
				{
					for(var i : Number = 0;i < l;i++ )
					{
						_send(_aLogStack.shift() as AirLoggerEvent);
					}
				}
			}
			catch ( e : Error )
			{
				_lcIn.connect(_getInConnectionName(ALTERNATE_ID_IN));
				
				_lcOut.send(_getOutConnectionName(), "idAlreadyUsed", id);
			} 
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function pingRequest() : void
		{
			_lcOut.send(_getOutConnectionName(), "requestID", ALTERNATE_ID_IN);
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRequesting() : Boolean
		{
			return _bRequesting;
		}

		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isIdentified() : Boolean
		{
			return _bIdentified;
		}

		/** @private */		
		protected function _send( evt : AirLoggerEvent ) : void
		{
			if( _bIdentified )
			{
				_lcOut.send(_getOutConnectionName(_sID), evt.type, evt);
			}
			else
			{
				_aLogStack.push(evt);
				
				if( !_bRequesting )
				{					
					pingRequest();
					_nPingRequest = setInterval(pingRequest, 1000);
					_bRequesting = true;
				}
			}
		}		

		/** @private */		
		protected function _getInConnectionName( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + IN_SUFFIX;
		}

		/** @private */		
		protected function _getOutConnectionName( id : String = "" ) : String
		{
			return LOCALCONNECTION_ID + id + OUT_SUFFIX;
		}

		/*---------------------------------------------------------------
		EVENT HANDLING
		----------------------------------------------------------------*/
		
		/**
		 * Triggered when a log message has to be sent.(from the PXLogManager)
		 * 
		 * @param	event	The event containing information about 
		 * 				the message to log.
		 * 				
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onLog( event : PXLogEvent ) : void
		{
			if( !event ) return;
			
			var msg : * = event.message;
			
			if(msg is String)
			{
				msg = ((event.logTarget != null) ? "[" + getQualifiedClassName(event.logTarget) + "] " : "") + msg;
			}
			
			var evt : AirLoggerEvent = new AirLoggerEvent("log", msg, event.level.level, new Date(), getQualifiedClassName(event.message)); 
			
			_send(evt);
		}

		/**
		 * Clears console messages.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function onClear( e : Event = null ) : void
		{
			clear();
		}

		/**
		 * @private
		 */
		private function onStatus( event : StatusEvent ) : void 
		{
         	
		}
		
		/**
		 * @private
		 */
		private function onSecurityError( event : SecurityErrorEvent ) : void 
		{
           
		}
		
		/**
		 * @private
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

import net.pixlib.events.PXBasicEvent;

internal class AirLoggerEvent 
	extends PXBasicEvent
{
	public var message : *;
	public var level : uint;
	public var date : Date;
	public var messageType : String;

	
	public function AirLoggerEvent( sType : String, message : * = null, level : uint = 0, date : Date = null, messageType : String = null ) 
	{
		super(sType, null);
		
		this.message = message;
		this.level = level;
		this.date = date;
		this.messageType = messageType;
	}
}