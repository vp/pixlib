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

	/**
	 * Service helper to store <strong>AMF</strong> connection properties
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	public class PXAMFServiceHelper implements PXValueObject 
	{
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * AMF gateway URL.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var gateway : String;

		/**
		 * AMF Service to user.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var service : String; 
		
		/**
		 * AMF Method name to call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var method : String;

		/**
		 * AMF timout before firing onTimeout event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var timeout : uint;

		/**
		 * AMF encoding version.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		public var encoding : uint;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * @param	gateway		
		 * @param	service				 * @param	method		
		 * @param	timeout		
		 * @param	encoding	
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXAMFServiceHelper( gateway : String, service : String, method : String, timeout : uint = 3000, encoding : uint = 3 ) 
		{
			this.gateway = gateway;
			this.service = service;			this.method = method;			this.timeout = timeout;
			this.encoding = encoding;
		}
	}
}
