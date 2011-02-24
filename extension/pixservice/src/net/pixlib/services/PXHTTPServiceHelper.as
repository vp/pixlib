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
	 * Service helper to store <strong>HTTP</strong> connection properties
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public class PXHTTPServiceHelper implements PXValueObject
	{
		/**
		 * URL service call.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var url : String;
		
		/**
		 * POST or GET value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var method : String;
		
		/**
		 * Call return type (text or binary)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var dataFormat : String;
		
		/**
		 * Timout before firing onTimeout event.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var timeout : uint;

		
		/**
		 * @param	url		
		 * @param	method		
		 * @param	dataFormat		
		 * @param	timeout		
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXHTTPServiceHelper( url : String, method : String = "POST", dataFormat : String = "text", timeout : uint = 3000 )
		{
			this.url = url;			this.method = method;			this.dataFormat = dataFormat;			this.timeout = timeout;
		}
	}
}
