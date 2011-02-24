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
	 * The PXStringifier class allow to represents any object in string 
	 * representation.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXStringifier
	{
		static public var strategy : PXStringifierStrategy = new PXBasicStringifierStrategy();
		
		/**
		 * @private
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function PXStringifier()
		{
		}
		
		/**
		 * Returns passed-in <code>target</code> in string representation.
		 * 
		 * @return passed-in <code>target</code> in string representation.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		static public function process( target : * ) : String 
		{
			return strategy.stringify( target );
		}
	}
}