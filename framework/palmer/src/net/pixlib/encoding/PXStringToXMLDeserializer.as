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
package net.pixlib.encoding
{

	/**
	 * The PXStringToXMLDeserializer class deserialize string content to build 
	 * XML instance.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXStringToXMLDeserializer implements PXDeserializer
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Creates instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public function PXStringToXMLDeserializer()
		{
		}

		/**
		 * Deserializes passed-in serializedContent and returns a XML instance 
		 * using deserialization result.
		 * 
		 * @param serializedContent Content to deserialize (String source)
		 * @param target			(optional) Object to store deserialization 
		 * 							result.
		 * @param key				(optional) Registration identifier
		 * 
		 * @return serializedContent as a XML instance if deserialization 
		 * process is success.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function deserialize( serializedContent : Object, target : Object = null, key : String = null ) : Object
		{
			return new XML(String(serializedContent));
		}
	}
}