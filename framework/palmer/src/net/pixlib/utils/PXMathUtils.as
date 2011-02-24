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
	import net.pixlib.structures.PXRange;

	/**
	 * The PXMathUtils utility class is an all-static class with methods for 
	 * working with number.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXMathUtils 
	{
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------		
		
		/**
		 * Converts passed-in degree <code>angle</code> in radian.
		 * 
		 * @param	angle	angle in degree 
		 * @return	radian convertion
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */ 
		public static function toRadian(angle : Number) : Number
		{
			return ( angle * Math.PI ) / 180;
		}

		/**
		 * Converts passed-in radian <code>angle</code> in degree.
		 * 
		 * @param	angle	angle in radian
		 * @return	radian convertion
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */ 
		public static function toDegre(angle : Number) : Number
		{
			return ( angle * 180 ) / Math.PI;
		}

		/**
		 * Rounds passed-in <code>value</code> with <code>digits</code> 
		 * precision.
		 * 
		 * @param	value	value to round
		 * @param	digits	round precision 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function round(value : Number, digits : uint = 0) : Number
		{
			return Math.round(value * Math.pow(10, digits)) / Math.pow(10, digits);
		}

		/**
		 * Returns random number between <code>v1</code> and <code>v2</code> 
		 * value.
		 * 
		 * <p>Arguments are automaticcaly re-order.</p>
		 * 
		 * @param	min		first interval limit
		 * @param	max		second interval limit 
		 * @param	rounded	<code>true</code> to round the result
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function random(min : Number, max : Number, rounded : Boolean = false) : Number
		{ 
			var nMax : Number = Math.max(min, max);
			var nMin : Number = Math.min(min, max);
			var result : Number = ( Math.random() * ( nMax - nMin ) + nMin );
			
			return ( rounded ) ? Math.round(result) : result;
		}

		/**
		 * Returns square value of passed-in <code>value</code> value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function square(value : Number) : Number
		{
			return ( value * value );
		}

		/**
		 * Returns inverse of passed-in <code>value</code> value
		 * 
		 * @param	value	number to inverse 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function inverse(value : Number) : Number
		{
			var num : Number = value >> 0;
			return (!num) ? 0 : ( 1 / num );
		}

		/**
		 * Returns sum of elements passed in <code>array</code> collection.
		 * 
		 * @param	array	values array
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function sum(array : Array) : Number
		{
			var length : Number = array.length;
			var result : Number = 0;
			
			while(--length > -1) result += array[length];
			
			return result;
		}

		/**
		 * Returns mean of elements passed in <code>array</code> collection.
		 * 
		 * @param	array	values array 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function mean(array : Array) : Number
		{
			return (sum(array) / array.length);
		}

		/**
		 * Returns the factorial of <code>n</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function factorial(n : uint) : uint
		{
			if (n != 0) return n * factorial(n - 1);
	        else return 1;
		}

		/**
		 * Returns percent value from passed-in <code>value</code> according 
		 * <code>total</code> one.
		 * 
		 * <p>If result is not a number or is is infinite, 
		 * returns <code>null</code>.</p>
		 * 
		 * @param	value	number to check
		 * @param	total	reference number.
		 * @param	rounded	<code>true</code> to round the percent result
		 * 
		 * @return	percent value or <code>null</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function percent(value : Number, total : Number, rounded : Boolean = false) : Number
		{
			var num : Number = (value / total) * 100;
			return (isNaN(num) || !isFinite(num)) ? 0 : (rounded) ? Math.round(num) : num ;
		}

		/**
		 * Returns <code>true</code> if the passed-in 
		 * integer <code>n</code> is impair.
		 * 
		 * @param	n	the integer to check
		 * 
		 * @return	<code>true</code> if <code>n</code> is 
		 * 			odd else <code>false</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function isOdd(n : int) : Boolean
		{
			return Boolean(n % 2);
		}

		/**
		 * Returns <code>true</code> if the passed-in 
		 * integer <code>n</code> is pair.
		 * 
		 * @param	n	the integer to check
		 * 
		 * @return	<code>true</code> if <code>n</code> is 
		 * 			even else <code>false</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function isEven(n : int) : Boolean
		{
			return (n % 2 == 0);
		}

		/**
		 * Returns <code>true</code> if passed-in number 
		 * <code>n</code> is a prime.
		 * 
		 * <p>A prime number is a positive integer that has no positive 
		 * integer divisors other than 1 and itself.</p>
		 * 
		 * @param	n	the number to check
		 * @return	<code>true</code> if <code>n</code> is a prime, 
		 * 			else <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static function isPrime(n : int) : Boolean
		{
			if (n == 1) return false;
			if (n == 2) return true;
			if (n % 2 == 0) return false;
			
			for(var i : Number = 3, e : Number = Math.sqrt(n);i <= e ;i += 2)
			{
				if (n % i == 0) return false;
			}
			return true;
		}

		/**
		 * Clamps passed-in <code>value</code> in <code>min</code> 
		 * and <code>max</code> range.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function clamp(value : Number, min : Number, max : Number) : Number
		{
			if(value > max) value = max;
			if(value < min) value = min;
			return value;
		}    

		/**
		 * Clamps passed-in <code>value</code> in <code>range</code> range.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function clampRange(value : Number, range : PXRange) : Number
		{
			if(value > range.max) value = range.max;
			if(value < range.min) value = range.min;
            
			return value;
		}    

		
		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------
		
		/** @private */
		function PXMathUtils() 
		{
		}
	}
}