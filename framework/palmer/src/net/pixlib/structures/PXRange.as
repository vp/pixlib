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
package net.pixlib.structures
{
	import net.pixlib.log.PXStringifier;	

	/**
	 * A range represent a space of numeric values.
	 * 
	 * @example
	 * <listing>
	 *   var rangeA : PXRange = new PXRange(10, 100);
	 *   var rangeB : PXRange = new PXRange(5, 50);
	 *   var rangeC : PXRange = new PXRange(60, 600);
	 *   
	 *   rangeA.overlap(rangeB); //true
	 *   rangeB.overlap(r3); //false
	 *   rangeA.overlap(rangeC); //true
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 * @author Cédric Néhémie
	 */
	final public class PXRange
	{
		//-------------------------------------------------------------------------
		// Public Properties
		//-------------------------------------------------------------------------
		
		/**
		 * Lower limit of the range.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var min : Number;

		/**
		 * Upper limit of the range.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var max : Number;
		
		
		//-------------------------------------------------------------------------
		// Public API
		//-------------------------------------------------------------------------
		
		/**
		 * Constructs a new instance.
		 * 
		 * @param min minimum <code>Number</code> value
		 * @param max maximum <code>Number</code> value
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXRange( min : Number = Number.NEGATIVE_INFINITY, 
							   max : Number = Number.POSITIVE_INFINITY ) 
		{
			this.min = min;
			this.max = max;
		}

		/**
		 * Returns a copy of the current <code>PXRange</code> instance. 
		 * 
		 * @return A <code>PXRange</code> instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clone() : PXRange
		{
			return new PXRange(min, max);
		}

		/**
		 * Indicates if passed-in range overlap the current range.
		 * 
		 * @return 	<code>true</code> if passed-in <code>PXRange</code> overload this one, 
		 * 			either <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function overlap( range : PXRange ) : Boolean
		{
			return ( max > range.min && range.max > min );
		}

		/**
		 * Indicates if passed-in value <code>Number</code> is inside range values.
		 * 
		 * @return	 <code>true</code> if passed-in <code>Number</code> is inside range,
		 * 			either <code>false</code>
		 * @example
		 * <listing>
		 *   var range : PXRange = new PXRange(10, 100);
		 * 
		 *   range.surround(35); //true
		 *   range.surround(127); //false
		 *   range.surround(10); //true
		 *   range.surround(100); //true
		 *   range.surround(5); //false
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function surround( value : Number ) : Boolean
		{
			return ( max >= value && min <= value );
		}

		/**
		 * Indicates if passed-in <code>PXRange</code> instance contain the 
		 * current instance.
		 * 
		 * @return 	<code>true</code> if passed-in <code>PXRange</code> contain this one, 
		 * 			either <code>false</code>
		 * @example
		 * <listing>
		 *   var rangeA : PXRange = new PXRange(10, 100);
		 *   var rangeB : PXRange = new PXRange(5, 50);
		 *   var rangeC : PXRange = new PXRange(40, 80);
		 *   
		 *   rangeB.inside( rangeA ); //false
		 *   rangeC.inside( rangeA ); //true
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		
		public function inside( range : PXRange ) : Boolean
		{
			return ( max < range.max && min > range.min );
		}

		/**
		 * Compares the passed-in <code>PXRange</code> object with the current one.
		 * 
		 * @param	r 	A <code>Range</code> to compare.
		 * @return 	<code>true</code> if passed-in <code>PXRange</code> is equals to this one, 
		 * 			either <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function equals( range : PXRange ) : Boolean
		{
			return ( max == range.max && min == range.min ); 
		}

		/**
		 * Returns the size, or length, of the current range.
		 * 
		 * @return	 size, or length, of the current range.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function size() : Number
		{
			return max - min;
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return <code>String</code> representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this) + " : [" + min + ", " + max + "]";
		}
	}
}