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
	import flash.utils.getQualifiedClassName;		

	/**
	 * The PXBasicStringifierStrategy class allow to get full classpath class of an object 
	 * as his string representation.
	 *
	 * @example
	 * <listing>
	 * 
	 * PXStringifier.strategy = new PXBasicStringifierStrategy();
	 * PXStringifier.process( myInstance );
	 * </listing>
	 * 
	 * @see Stringifier
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	final public class PXBasicStringifierStrategy implements PXStringifierStrategy
	{
		/**
		 * @inheritDoc
		 */
		public function stringify( target : * ) : String 
		{
			return getQualifiedClassName(target);
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return The string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this);
		}
	}
}