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
	import net.pixlib.commands.PXDelegate;
	import net.pixlib.exceptions.PXNullPointerException;

	import flash.events.Event;
	import flash.net.Responder;
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * The PXAMFMultiServices class allow <strong>multiple AMF</strong> calls in a single 
	 * AMF connection call.
	 * 
	 * @example
	 * <listing>
	 * 
	 * var service : PXAMFMultiServices = new PXAMFMultiServices("http://os.localhost/RD_ZendAMF/webtest/gateway.php");
	 * 
	 * service.addService("HelloWorld", "getAge");
	 * 
	 * var hello : PXService = service.addService("HelloWorld", "getHelloWorld");
	 * hello.addEventListener(ServiceEvent.onDataResultEVENT, onHello);
	 * 	
	 * var setName : PXService = service.addService("HelloWorld", "setName");
	 * setName.setArguments("Romain");
	 * 	
	 * service.addService("HelloWorld2", "getUser");
	 * 			
	 * service.addEventListener(PXServiceEvent.onDataErrorEVENT, onError);
	 * service.addEventListener(PXServiceEvent.onDataResultEVENT, onResult);
	 * service.execute();
	 * </listing>
	 * 
	 * @see PIXLIB_DOC/net/pixlib/services/PXService.html net.pixlib.service.PXService
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAMFMultiServices extends PXAMFService
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * Stores PXAMFService instances.
		 */
		private var _collection : Vector.<PXAMFService>; 

		/**
		 * @private
		 * Stores HashMap between PXAMFService instance and identifier
		 */
		private var _dico : Dictionary; 
		
		/**
		 * @private
		 * Stores the count of AMF responses received
		 */
		private var _responseCount : uint;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Not available for this instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function get service(  ) : String
		{
			return null;
		}

		/**
		 * Not available for this instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function get method(  ) : String
		{
			return null;
		}

		/** @private */
		override public function set method(value : String) : void
		{
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance.
		 * 
		 * @param gateway	AMF Gateway's adress
		 * @param timeout	(optional) Default timeout value
		 * @param encoding	AMF encoding value
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function PXAMFMultiServices(  gateway : String, timeout : uint = 3000, encoding : uint = 3 )
		{
			super(gateway, null, null, timeout, encoding);
			
			_collection = new Vector.<PXAMFService>();
			_dico = new Dictionary();
		}

		/**
		 * Adds AMF remoting call.
		 * 
		 * @param service AMF Service's name
		 * @param service AMF Method to call on passed-in service
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addService(service : String, method : String) : PXAMFService	
		{
			var sub : PXAMFService = new PXAMFService(gateway, service, method, timeout, encoding);
			
			var index : uint = _collection.push(sub);
			_dico[service + "." + method] = index;
			
			return sub;
		}
		
		/**
		 * Returns AMF Service call using passed-in service and method name.
		 * 
		 * @return AMF Service call using passed-in service and method name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getService(service : String, method : String) : PXAMFService
		{
			return _collection[_dico[service + "." + method]];
		}
		
		/**
		 * Clears services list.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void	
		{
			for each (var service : PXService in _collection) 
			{
				service.release();
				service = null;
			}
			
			_collection = new Vector.<PXAMFService>();
			_dico = new Dictionary();
		}
		
		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override protected function onExecute( event : Event = null ) : void
		{
			PXAbstractService.register(this);
			
			if(amfhelper is PXAMFServiceHelper)
			{
				try
				{
					_responseCount = 0;
					
					nTimeoutHandler = setInterval(onTimeoutHandler, timeout);
					
					var amf : PXAMFService;
					var responder : Responder;
					var len : uint = _collection.length;
					for(var i : uint = 0;i < len;i++)
					{
						amf = _collection[i];
						responder = new Responder(PXDelegate.create(onRequestResultHandler, i), PXDelegate.create(onRequestFaultHandler, i));
						
						PXAbstractService.register(amf);
						
						getConnection().call.apply(getConnection(), [amf.service + "." + amf.method, responder].concat(amf.getArguments()));
					}
				} 
				catch( e : Error )
				{
					clearInterval(nTimeoutHandler);
					logger.error("Call failed !. " + e.message + "\n" + e.getStackTrace(), this);
					onFaultHandler(e);
				}
			} 
			else
			{
				throw new PXNullPointerException("execute() failed. Can't retrieve valid execution helper.", this);
			}
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------

		/**
		 * Not available for this instance.
		 * 
		 * @return null
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function getRemoteArguments() : Array
		{
			return null;
		}

		/**
		 * Not available for this instance.
		 * 
		 * @return null
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function getServiceMethod() : String
		{
			return null;
		}

		/**
		 * Triggered when an AMF Service response was received.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onRequestResultHandler(response : Object, requestIndex : uint) : void
		{
			var amf : PXAMFService = _collection[requestIndex];
			amf.result = response;
			amf.fireResult();
			PXAbstractService.unregister(amf);
			
			_responseCount++;
			
			if(_responseCount == _collection.length)
			{
				if(isRegistered(this))
				{
					PXAbstractService.unregister(this);
					result = _collection;
					fireResult();
					fireCommandEndEvent();
				}
			}
		}

		/**
		 * Triggered when an AMF Service error was received.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onRequestFaultHandler(response : Object, requestIndex : uint) : void
		{
			var amf : PXAMFService = _collection[requestIndex];
			amf.result = response;
			amf.fireError();
			PXAbstractService.unregister(amf);
			
			_responseCount++;
			
			if(_responseCount == _collection.length)
			{
				if(isRegistered(this))
				{
					PXAbstractService.unregister(this);
					result = _collection;
					fireError();
					fireCommandEndEvent();
				}
			}
		}
	}
}