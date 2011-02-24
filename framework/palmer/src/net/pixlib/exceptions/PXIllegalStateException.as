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
package net.pixlib.exceptions
{

	/**
	 * The PXIllegalStateException exception is thrown when an invalid state in 
	 * some implementation is not valid when calling some method or processing 
	 * some stuff.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXIllegalStateException extends PXException
	{		
		/**
		 * @inheritDoc
		 */
		public function PXIllegalStateException( message : String = "", target : Object = null )
		{
			super(message, target);
		}
	}
}