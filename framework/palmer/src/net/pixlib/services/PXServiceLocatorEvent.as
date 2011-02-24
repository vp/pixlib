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
	import net.pixlib.events.PXBasicEvent;

	/**
	 * @author Francis Bourre
	 */
	final public class PXServiceLocatorEvent 
		extends PXBasicEvent
	{
		static public const onRegisterServiceEVENT 		: String = "onRegisterService";		static public const onUnregisterServiceEVENT 	: String = "onUnregisterService";

		protected var sKey : String;
		protected var oService : PXService;		protected var oServiceClass : Class;
		protected var oServiceLocator : PXServiceLocator;
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXServiceLocatorEvent( eventType : String, key : String, serviceLocator : PXServiceLocator ) 
		{
			super( eventType );
			
			sKey = key;
			oServiceLocator = serviceLocator;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getKey() : String
		{
			return sKey;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getService() : PXService
		{
			return oService is Class ? null : oService as PXService;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setService( service : PXService ) : void
		{
			oService = service;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getServiceClass() : Class
		{
			return oService is Class ? oService as Class : null;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setServiceClass( serviceClass : Class ) : void
		{
			oServiceClass = serviceClass;
		}
		
		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getServiceLocator() : PXServiceLocator
		{
			return oServiceLocator as PXServiceLocator;
		}	}}