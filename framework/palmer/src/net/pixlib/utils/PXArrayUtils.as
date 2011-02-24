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
	import net.pixlib.log.PXDebug;

	/**
	 * The PXArrayUtils utility class is an all-static class with methods for 
	 * working with Array objects.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXArrayUtils
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Indicates if <code>source</code> array collection contains 
		 * passed-in <code>element</code>.
		 * 
		 * @param	element	element to search
		 * @param	source	array collection to search in
		 * @return	<code>true</code> if passed-in <code>o</code> is in array.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function contains(element : Object, source : Array) : Boolean
		{
			return getIndexOf(element, source) > -1;
		}

		/**
		 * Returns index of <code>element</code> in <code>source</code> array.
		 * 
		 * @param element	Element to search
		 * @param source	Array collection
		 * 
		 * @return element index of -1 if not found.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function getIndexOf(element : Object, source : Array, startIndex : uint = 0) : int
		{
			if (source == null || element == null) return -1;

			var length : int = source.length;

			if ( startIndex >= length ) return -1;

			for (var i : int = startIndex;i < length;i++)
			{
				if (source[i] === element) return i;
			}

			return -1;
		}

		/**
		 * Returns passed-in <code>source</code> Array content at random 
		 * index.
		 * 
		 * @param source Array source
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function getRandomElement(source : Array) : *
		{
			if ( !source || source.length < 1 ) return null;

			var index : Number = PXRandom.nextInt(source.length);

			try
			{
				return source[ index ];
			}
			catch( e : Error )
			{
				PXDebug.ERROR("Index out of bounds = " + index);
			}

			return null;
		}

		/**
		 * Remove passed-in <code>element</code> value from passed-in 
		 * <code>source</code> array collection.
		 * 
		 * <p>All occurances are removed.</p>
		 * 
		 * @param	element	element to remove
		 * @param	source	array collection to search in
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		static public function remove(element : Object, source : Array) : void
		{
			if (element == null || source == null) return;

			var length : uint = source.length;

			for ( var i : Number = length;i > -1;i -= 1 )
			{
				if ( source[i] === element ) source.splice(i, 1);
			}
		}

		/**
		 * Removes element at <code>i</code> index from passed-in
		 * <code>source</code> array collection.
		 * 
		 * @param	i			index to remove
		 * @param	source		array collection to search in
		 * @param	flag		( optional ) <code>true</code> to return 
		 * 						removed element, <code>false</code> to return 
		 * 						source array.
		 * 						
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function removeAt(i : Number, source : Array, flag : Boolean) : *
		{
			var obj : * = source.splice(i, 1);
			return ( flag ) ? obj : source;
		}

		/**
		 * Removes the first occurance of the given <code>element</code> out 
		 * of the passed-in <code>source</code> array collection.
		 * 
		 * @param	element		element to remove
		 * @param	source		array collection to search in
		 * @param	flag		( optional ) <code>true</code> to return removed 
		 * 						element, <code>false</code> to return source array.
		 * 						
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function removeFirst(element : Object, source : Array, flag : Boolean) : *
		{
			var length : int = source.length;
			var index : Number = -1;

			for ( var i : int = 0;i < length;i += 1 )
			{
				if ( source[i] === element )
				{
					source.splice(i, 1);
					index = i;
					break;
				}
			}

			return ( flag ) ? index : source;
		}

		/**
		 * Removes the last occurance of the given <code>element</code> out of the 
		 * passed-in <code>source</code> array collection.
		 * 
		 * @param	element		element to remove
		 * @param	source			array collection to search in
		 * @param	flag		( optional ) <code>true</code> to return removed 
		 * 					element, <code>false</code> to return source array.
		 * 					
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function removeLast(element : Object, source : Array, flag : Boolean) : *
		{
			var length : int = source.length;
			var index : Number = -1;

			while ( --length > -1 )
			{
				if ( source[length] === element )
				{
					source.splice(length, 1);
					index = length;
					break;
				}
			}

			return ( flag ) ? index : source;
		}

		/**
		 * Shuffles the passed-in <code>source</code> array collection.
		 * 
		 * @param	array	array collection to shuffle
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function shuffle(source : Array) : Array
		{
			var length : int = source.length;
			var index : int;
			var temp : *;

			for ( var i : int = length - 1;i >= 0;i -= 1 )
			{
				index = Math.floor(Math.random() * length);
				temp = source[i];
				source[i] = source[index];
				source[ index ] = temp;
			}

			return source;
		}

		/**
		 * Swaps value at index <code>i</code> with value at 
		 * index <code>j</code> in the passed-in <code>a</code> array.
		 * 
		 * @param	srcIndex		index of the first value
		 * @param	destIndex		index of the second value
		 * @param	source			array instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function swap(srcIndex : int, destIndex : int, source : Array) : Array
		{
			if ( !source || source.length < 2 ) return source;

			var length : int = source.length;

			if ( srcIndex > -1 && srcIndex < length && destIndex > -1 && destIndex < length )
			{
				var tmp : * = source[ srcIndex ];
				source[ srcIndex ] = source[ destIndex ];
				source[ destIndex ] = tmp;
			}

			return source;
		}

		/**
		 * Indicates if the 2 passed arrays are equal or not.
		 * 
		 * @param	sourceA	first Array collection
		 * @param	sourceB	second Array collection
		 * 
		 * @return	<code>true</code> if 2 arrays are equals, 
		 * 			otherwise <code>false</code>
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function areEqual(sourceA : Array, sourceB : Array) : Boolean
		{
			if (sourceA == null || sourceB == null ) return false;

			if ( sourceA.length != sourceB.length ) return false;

			var length : int = sourceA.length;
			for ( var i : int = 0;i < length;i += 1 )
			{
				if ( sourceA[i] !== sourceB[i] ) return false;
			}
			return true;
		}

		/**
		 * Makes all array elements unique and returns array.
		 * 
		 * <p>Original array is modified.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function unique(source : Array) : Array
		{
			var length : int = source.length;

			for ( var i : int = 0;i < length;i += 1)
			{
				for ( var j : int = ( i + 1 );j < length;j += 1 )
				{
					if ( source[i] === source[j] ) source.splice(j, 1);
				}
			}

			return source;
		}

		/**
		 * 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function createUniqueCopy(source : Array) : Array
		{
			var result : Array = [];
			var length : uint = source.length;
			var element : Object;

			for (var i : uint = 0;i < length;++i)
			{
				element = source[i];

				if (contains(element, result)) continue;

				result.push(element);
			}

			return result;
		}

		/**
		 * Fills passed-in array with value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function fill(source : Array, value : * = null) : Array
		{
			var len : int = source.length;

			while ( --len > -1 ) source[len] = value;

			return source;
		}


		// --------------------------------------------------------------------
		// Private methods
		// --------------------------------------------------------------------

		/** @private */
		function PXArrayUtils()
		{
		}
	}
}