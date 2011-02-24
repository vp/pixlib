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
package net.pixlib.log
{

	/**
	 * PXStringifierStrategy allow string representation of an object.
	 * 
	 * <p>PXStringifier interface must be implemented by all stringifier 
	 * implementations.</p>
	 * 
	 * @see PXBasicStringifier	 * @see PXStringifier
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public interface PXStringifierStrategy
	{
		/**
		 * Returns string representation of passed-in target object.
		 * 
		 * @return String representation of passed-in target object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function stringify( target : * ) : String;
	}
}