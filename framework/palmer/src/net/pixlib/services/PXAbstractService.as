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
	import net.pixlib.collections.PXCollection;
	import net.pixlib.commands.PXAbstractCommand;
	import net.pixlib.core.PXValueObject;
	import net.pixlib.encoding.PXDeserializer;
	import net.pixlib.exceptions.PXUnsupportedOperationException;
	import net.pixlib.log.PXDebug;

	import flash.events.Event;
	import flash.utils.Dictionary;

	/**
	 * The PXAbstractService class is an abstract implementation to offer 
	 * default PXService implementation.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXAbstractService extends PXAbstractCommand implements PXService
	{
		/**
		 * @private
		 */
		static private var _POOL : Dictionary = new Dictionary();
		
		/**
		 * @private
		 */
		static protected function isRegistered( service : PXAbstractService ) : Boolean
		{
			return PXAbstractService._POOL[ service ];
		}
		
		/**
		 * @private
		 */
		static protected function register( service : PXAbstractService ) : void
		{
			if ( PXAbstractService._POOL[ service ] == null )
			{
				PXAbstractService._POOL[ service ] = true;
			} 
			else
			{
				PXDebug.WARN(service + " is already registered", PXAbstractService);
			}
		}
		
		/**
		 * @private
		 */
		static protected function unregister( service : PXAbstractService ) : void
		{
			if( PXAbstractService._POOL[ service ] != null )
			{
				delete PXAbstractService._POOL[ service ];
			} 
			else
			{
				PXDebug.WARN(service + " cannot be unregistered", PXAbstractService);
			}
		}

		/**
		 * @private
		 */
		private var _result : Object;
		
		/**
		 * @private
		 */
		private var _rawResult : Object;
		
		/**
		 * @private
		 */
		private var _args : Array;
		
		/**
		 * @private
		 */
		protected var oDeserializer : PXDeserializer;

		
		/**
		 * @inheritDoc
		 */
		public function get result() : Object
		{
			return _result;
		}
		/**
		 * @inheritDoc
		 */
		public function set result( response : Object ) : void
		{
			_rawResult = response;
			_result = oDeserializer ? oDeserializer.deserialize(_rawResult, this) : _rawResult;
		}

		/**
		 * @inheritDoc
		 */
		public function get rawResult() : Object
		{
			return _rawResult;
		}

		/**
		 * @inheritDoc
		 */
		public function addListener( listener : PXServiceListener ) : Boolean
		{
			return oEB.addListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeListener( listener : PXServiceListener ) : Boolean
		{
			return oEB.removeListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function get listeners() : PXCollection
		{
			return oEB.getListenerCollection();
		}
		
		/**
		 * Adds passed-in arguments chain as service call argument.
		 * 
		 * @param rest	List or arguments to use for the service call
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addArguments( ...rest ) : void
		{
			if(!_args) _args = [];
			if(rest.length > 0 ) _args = _args.concat(rest.concat());
		}
		
		/**
		 * @inheritDoc
		 */
		public function setArguments( ...rest ) : void
		{
			if(rest.length > 0) _args = rest.concat();
		}

		/**
		 * @inheritDoc
		 */
		public function getArguments() : Object
		{
			return _args;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onExecute( event : Event = null ) : void
		{
			PXAbstractService.register(this);
		}

		/**
		 * @inheritDoc
		 */
		override protected function onCancel() : void
		{
			release();
		}

		/**
		 * @inheritDoc
		 */
		public function fireResult() : void
		{
			oEB.broadcastEvent(new PXServiceEvent(PXServiceEvent.onDataResultEVENT, this));
		}

		/**
		 * @inheritDoc
		 */
		public function fireError() : void
		{
			oEB.broadcastEvent(new PXServiceEvent(PXServiceEvent.onDataErrorEVENT, this));
		}

		/**
		 * @inheritDoc
		 */
		public function release() : void
		{
			oEB.removeAllListeners();
			_args = null;
			_result = null;
			oDeserializer = null;
		}

		/**
		 * @inheritDoc
		 */
		public function setDeserializer( deserializer : PXDeserializer, target : Object = null ) : void
		{
			oDeserializer = deserializer;
			_result = target;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function set helper( value : PXValueObject) : void
		{
			throw new PXUnsupportedOperationException(".setExecutionHelper(" + value + ") is unsupported.", this);	
		}

		/**
		 * Returns Remoting call arguments.
		 * 
		 * @return remoting call arguments
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function getRemoteArguments() : Array
		{
			throw new PXUnsupportedOperationException(".getRemoteArguments() is unsupported.", this);	
		}

		/**
		 * Triggered when result is received.
		 * 
		 * @param response Raw service result.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function onResultHandler( response : Object ) : void
		{
			if ( isRegistered(this) )
			{
				PXAbstractService.unregister(this);
				result = response;
				fireResult();
				fireCommandEndEvent();
			}
		}
		
		/**
		 * Triggered when an error occured.
		 * 
		 * @param response Raw service result.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final protected function onFaultHandler( response : Object ) : void
		{
			if ( isRegistered(this) )
			{
				PXAbstractService.unregister(this);
				result = response;
				fireError();
				fireCommandEndEvent();
			}
		}
	}
}
