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
	 * The ExceptionOutput interface defines rules for implementations classes 
	 * which want to be Pixlib Exception output system compliant.
	 * 
	 * @see PixlibException#setOutput()
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXExceptionOutput 
	{	
		/**
		 * Outputs passed-in message (using optional target reference) using  
		 * concrete output system implementation.
		 * 
		 * @param error		Error thrown
		 * @param target	(optional) Error generator
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function output(error : Error, target : Object = null) : void;
	}
}
