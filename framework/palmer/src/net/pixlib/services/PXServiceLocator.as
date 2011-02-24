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
	import net.pixlib.core.PXAbstractLocator;
	import net.pixlib.core.PXLocatorListener;

	/**
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Francis Bourre
	 */
	final public class PXServiceLocator extends PXAbstractLocator
	{
		/**
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXServiceLocator() 
		{
			super(null, PXLocatorListener, null);
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onRegister( key : String = null, service : Object = null ) : void
		{
			var evt : PXServiceLocatorEvent = new PXServiceLocatorEvent(PXServiceLocatorEvent.onRegisterServiceEVENT, key, this);
			if ( service is Class ) 
			{
				evt.setServiceClass(service as Class);
			} 
			else 
			{
				evt.setService(service as PXService);
			}
			broadcastEvent(evt);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override protected function onUnregister( key : String = null ) : void
		{
			broadcastEvent(new PXServiceLocatorEvent(PXServiceLocatorEvent.onUnregisterServiceEVENT, key, this));
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function registerService( key : String, service : PXService ) : Boolean
		{
			return register(key, service);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function registerServiceClass( key : String, serviceClass : Class ) : Boolean
		{
			return register(key, serviceClass);
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function locate( key : String ) : Object
		{
			try
			{
				var obj : Object = super.locate(key);
				return ( obj is Class ) ? new ( obj as Class )() : obj;
			} 
			catch ( e : Error )
			{
				logger.fatal(e.message, this);
				throw e;
			}
			
			return null;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getService( key : String ) : PXService
		{
			try
			{
				var service : PXService = locate(key) as PXService;
				return service;
			} 
			catch ( e : Error )
			{
				logger.fatal(e.message, this);
				throw( e );
			}

			return null;
		}
	}}