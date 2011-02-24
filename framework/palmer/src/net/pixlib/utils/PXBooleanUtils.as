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
package net.pixlib.utils
{
	/**
	 * The PXBooleanUtils utility class is an all-static class with methods for 
	 * working with Boolean objects.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXBooleanUtils
	{
		/**
		 * Casts and returns passed-in Boolean value into int value.
		 * 
		 * @param value Boolean value to cast
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		static public function toInt(value : Boolean) : int
		{
			return value ? 1 : 0;
		}
		
		/**
		 * Casts and returns passed-in Boolean value into String value.
		 * 
		 * @param value Boolean value to cast 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		static public function toString(value : Boolean) : String
		{
			return value ? "true" : "false";
		}
		
		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
       
		/** @private */
		function PXBooleanUtils()
		{
		}       
	}
}