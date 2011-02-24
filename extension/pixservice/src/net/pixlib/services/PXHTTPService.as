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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXNullPointerException;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLVariables;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;


	/**
	 * Command implementation to call a <strong>HTTP</strong> service.
	 * 
	 * @example
	 * <listing>
	 * 
	 * public function test( ) : void
	 * {
	 * 	var service : PXHTTPService = new PXHTTPService( "getSession.php" );
	 * 	service.addVariable( "name", "myName" );
	 * 	service.addVariable( "pwd", "myPass" );
	 * 	service.addListener( this );
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
	public class PXHTTPService extends PXAbstractService
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------

		/**
		 * @private
		 * Stores connection helper.
		 */
		private var _helper : PXHTTPServiceHelper;

		/**
		 * @private
		 * Stores URLLoader instance
		 */
		private var _oLoader : URLLoader;

		/**
		 * @private
		 * Stores URLRequest instance
		 */
		private var _request : URLRequest;


		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------

		/** 
		 * @private
		 * 
		 * timeout handler.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nTimeoutHandler : uint;


		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * Returns url.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get url() : String
		{
			return _helper.url;
		}

		/**
		 * Returns remote method name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get method() : String
		{
			return _helper.method;
		}

		/**
		 * Returns remoting encoding use.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get dataFormat() : String
		{
			return _helper.dataFormat;
		}

		/**
		 * Returns timeout delay.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get timeout() : uint
		{
			return _helper.timeout;
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
		override public function set result(response : Object) : void
		{
			clearInterval(nTimeoutHandler);
			super.result = response;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Creates instance.
		 * 
		 * @param	url			URL to call
		 * @param	method		URL call type ("POST" or "GET")
		 * @param	dataFormat	Return type
		 * @param	timeout		Call timeout
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXHTTPService(url : String = "", method : String = "POST", dataFormat : String = "text", timeout : uint = 3000)
		{
			super();
			helper = new PXHTTPServiceHelper(url, method, dataFormat, timeout);
		}

		/**
		 * @private
		 */
		override protected function onExecute(event : Event = null) : void
		{
			super.onExecute(event);

			if ( _helper is PXHTTPServiceHelper )
			{
				try
				{
					_oLoader = new URLLoader();
					_oLoader.dataFormat = dataFormat;
					_oLoader.addEventListener(Event.COMPLETE, onCompleteHandler);
					_oLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
					_oLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
					_oLoader.load(getRemoteArguments()[0] as URLRequest);

					nTimeoutHandler = setInterval(onTimeoutHandler, timeout);
				}
				catch( e : Error )
				{
					logger.error(this + " call failed !. " + e.message + "\n" + e.getStackTrace(), this);
					onFaultHandler(null);
				}
			}
			else
			{
				throw new PXNullPointerException(".execute() failed. Can't retrieve valid execution helper.", this);
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
			disposeURLLoader();
			super.release();
		}

		/**
		 * Returns arguments passed to service call.
		 * 
		 * @return arguments passed to service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function getArguments() : Object
		{
			return _request.data;
		}
		
		/**
		 * Adds passed-in arguments chain as service call argument.
		 * 
		 * @param rest	List or arguments to use for the service call
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function addArguments(...rest) : void
		{
			if (rest.length % 2 == 0)
			{
				var len : uint = rest.length;
				for (var i : int = 0;i < len;i++)
				{
					addVariable(rest[i], rest[i + 1]);
					i++;
				}
			}
			else
			{
				throw new PXIllegalArgumentException("arguments must be defined in pairs 'name / value'", this);
			}
		}

		/**
		 * Adds arguments to service call.
		 * 
		 * @param rest	List of argument to pass to service call
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function setArguments(...rest) : void
		{
			if (rest.length % 2 == 0)
			{
				var vars : URLVariables = new URLVariables();

				var len : uint = rest.length;
				for (var i : int = 0;i < len;i++)
				{
					vars[rest[i]] = rest[i + 1];
					i++;
				}

				setVariables(vars);
			}
			else
			{
				throw new PXIllegalArgumentException("arguments must be defined in pairs 'name / value'", this);
			}
		}

		/**
		 * Sets URL variables to pass to service call.
		 * 
		 * @param variables URLVariables instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setVariables(variables : URLVariables) : void
		{
			_request.data = variables;
		}

		/**
		 * Returns variables using by service call.
		 * 
		 * @return variables using by service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getVariables() : URLVariables
		{
			return _request.data as URLVariables;
		}

		/**
		 * Adds passed-in variable to service call.
		 * 
		 * @param name	Variable's name
		 * @param value	Variable's value
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addVariable(name : String, value : *) : void
		{
			_request.data[name] = value;
		}

		/**
		 * Adds header definition for this HTTP call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function addHeader(name : String, value : String) : void
		{
			_request.requestHeaders.push(new URLRequestHeader(name, value));
		}


		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * Sets the service helper to use by this servce.
		 * 
		 * @param helper A PXHTTPServiceHelper instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function set helper(value : PXValueObject) : void
		{
			_helper = value as PXHTTPServiceHelper;
			_request = new URLRequest(url);
			_request.method = method;
			setVariables(new URLVariables());
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
			return [_request];
		}

		/**
		 * Dispose internal URLLoader process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function disposeURLLoader() : void
		{
			if ( _oLoader )
			{
				_oLoader.removeEventListener(Event.COMPLETE, onCompleteHandler);
				_oLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorHandler);
				_oLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
				_oLoader.close();
			}
		}

		/**
		 * Triggered when service call is received.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onCompleteHandler(event : Event) : void
		{
			onResultHandler((event.target as URLLoader).data);
		}

		/**
		 * Triggered when remoting process is timeout.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onTimeoutHandler() : void
		{
			clearInterval(nTimeoutHandler);
			logger.error("Call failed !. Timeout !");
			onFaultHandler(null);
		}

		/**
		 * Triggered when an error occured in connection or in the call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onErrorHandler(event : Event) : void
		{
			clearInterval(nTimeoutHandler);
			logger.error(event);

			onFaultHandler(event);
		}
	}
}