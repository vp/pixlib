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
	import net.pixlib.core.PXValueObject;
	import net.pixlib.exceptions.PXNullPointerException;

	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.Responder;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * Command implementation to call a <strong>AMF</strong> service.
	 * 
	 * @example
	 * <listing>
	 * 
	 * public function test( ) : void
	 * {
	 * 	var service : PXAMFService = new PXAMFService( "gateway.php", "UserService", "login" );
	 * 	service.setArguments( "myLogin", "myPassword" );
	 * 	service.addlistener( this );
	 * 	service.execute();
	 * }
	 * 
	 * public function onDataResult ( event : PXServiceEvent ) : void
	 * {
	 * 	var result : Object = event.service.result;
	 * }
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/services/PXService.html net.pixlib.service.PXService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 * @author Francis Bourre
	 */
	public class PXAMFService extends PXAbstractService
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * Stores NetConnection instance
		 */
		private var _connection : NetConnection;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * AMF Connection helper.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var amfhelper : PXAMFServiceHelper;
		
		
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
				
		/** 
		 * @private
		 * 
		 * timeout handler.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nTimeoutHandler : uint;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns gateway url.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get gateway( ) : String
		{
			return amfhelper.gateway;		
		}
		
		/**
		 * Returns service to use.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get service() : String
		{
			return amfhelper.service;
		}

		/**
		 * Returns remote method name to call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get method(  ) : String
		{
			return amfhelper.method;
		}
		/** @private */
		public function set method(value : String) : void
		{
			amfhelper.method = value;
		}
		
		/**
		 * Returns remoting encoding used.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get encoding(  ) : uint
		{
			return amfhelper.encoding;
		}

		/**
		 * Returns timeout delay.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get timeout(  ) : uint
		{
			return amfhelper.timeout;
		}
		
		/**
		 * Service call result.
		 * 
		 * <p>If a data deserializer is defined, the result is the result 
		 * of deserialization process.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function set result( response : Object ) : void
		{
			clearInterval(nTimeoutHandler);
			super.result = response;
		}
		

		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param gateway	AMF Gateway's adress
		 * @param service	AMF service's name
		 * @param method	AMF method's name
		 * @param timeout	(optional) Default timeout value
		 * @param encoding	AMF encoding value
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXAMFService(  gateway : String, service : String,  method : String = "", timeout : uint = 3000, encoding : uint = 3 )
		{
			super();
			
			helper = new PXAMFServiceHelper(gateway, service, method, timeout, encoding);
		}
		
		/**
		 * @private
		 */
		override protected function onExecute( event : Event = null ) : void
		{
			super.onExecute(event);
			
			if(amfhelper is PXAMFServiceHelper)
			{
				try
				{
					nTimeoutHandler = setInterval(onTimeoutHandler, timeout);
					getConnection().call.apply(null, getRemoteArguments());
				} 
				catch( e : Error )
				{
					logger.error("Call failed !. " + e.message + "\n" + e.getStackTrace(), this);
					clearInterval(nTimeoutHandler);
					onFaultHandler(e);
				}
			} 
			else
			{
				throw new PXNullPointerException("execute() failed. Can't retrieve valid execution helper.", this);
			}
		}
		
		/**
		 * Releases service.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function release() : void
		{
			disposeNetConnection();
			super.release();
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * Sets the service helper to use by this servce.
		 * 
		 * @param helper A PXAMFServiceHelper instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function set helper(value : PXValueObject) : void
		{
			amfhelper = value as PXAMFServiceHelper;
			
			disposeNetConnection(),
			connect();
		}

		/**
		 * Returns Remoting call arguments.
		 * 
		 * @return remoting call arguments
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function getRemoteArguments() : Array
		{
			return ( getArguments() != null && getArguments().length > 0 ) ? [getServiceMethod(), getResponder()].concat(getArguments()) : [getServiceMethod(), getResponder()];
		}
		
		/**
		 * Returns AMF Service method.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getServiceMethod() : String
		{
			return service + "." + method;
		}
		
		/**
		 * Returns remoting responder.
		 * 
		 * @return remoting responder.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getResponder() : Responder
		{
			return new Responder(onResultHandler, onFaultHandler);
		}

		/**
		 * Disposes NetConnection instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function disposeNetConnection() : void
		{
			if( _connection )
			{
				_connection.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
				_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
				_connection.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_connection.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
				_connection.close();
			}
		}

		/**
		 * Inits connection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function connect() : void
		{
			_connection = new NetConnection();
			
			_connection.objectEncoding = encoding;
			_connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
			_connection.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onErrorHandler);
			
			try
			{
				_connection.connect(gateway);
			} 
			catch ( e : Error )
			{
				logger.error("Connection failed !. " + e.message, this);
			}
		}

		/**
		 * Triggered when remoting process is timeout.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onTimeoutHandler( ) : void
		{
			clearInterval(nTimeoutHandler);
			logger.error("Call failed !. Timeout !", this);
			onFaultHandler(null);
		}

		/**
		 * Returns NetConnection instance.
		 * 
		 * @return NetConnection instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getConnection() : NetConnection
		{
			return _connection;
		}
		
		/**
		 * Triggered when NetStatus event are received from Netconnection status.
		 * 
		 * @param event	NetStatusEvent instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onNetStatusHandler( event : NetStatusEvent ) : void
		{
			logger.debug(event.info.code, this);
			
			if(event.info.code == "NetConnection.Call.BadVersion")
			{
				clearInterval(nTimeoutHandler);
				onFaultHandler(event);
			}
		}
		
		/**
		 * Triggered when an error occured in connection or in the call.
		 * 
		 * @param event	Event instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onErrorHandler(event : Event) : void 
		{
			logger.error(event, this);			onFaultHandler(event);
		}
	}
}