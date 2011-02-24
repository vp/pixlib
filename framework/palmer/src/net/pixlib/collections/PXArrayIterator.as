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
package net.pixlib.collections 
{
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.exceptions.PXIndexOutOfBoundsException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.log.PXStringifier;

	/**
	 * The PXArrayIterator class provides a convenient way
	 * to iterate through each entry of an <code>Array</code> instance 
	 * as you could do with a <code>PXList</code> instance.
	 * 
	 * <p>
	 * Iterations are performed from <code>0</code> to <code>length</code> 
	 * of the passed-in array.
	 * </p> 
	 * 
	 * @example
	 * <listing>
	 * 
	 * package 
	 * {
	 * 	public class PXArrayIteratorExample 
	 * 	{
	 * 		public function PXArrayIteratorExample()
	 * 		{
	 * 			var content : Array = [23, "Pixlib"];
	 * 
	 * 			var iterator : Iterator = new PXArrayIterator(content);
	 * 		
	 * 			while(iterator.hasNext())
	 * 			{
	 * 				trace(iterator.next());
	 * 			}
	 * 			//output 23
	 * 			//output Pixlib
	 * 		}
	 * 		
	 * 	}
	 * }
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Cedric Nehemie
	 * @author 	Romain Ecarnot
	 */
	final public class PXArrayIterator implements PXListIterator 
	{
		/**
		 * Stores the object collection data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		[ArrayElementType("Object")]
		protected var aArray : Array;

		/**
		 * Sizes of the collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nSize : Number;

		/**
		 * Current index in iteration process.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nIndex : Number;

		/**
		 * Flag indicates if an item wad removed from collection. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bRemoved : Boolean;

		/**
		 * Flag indicates if an item wad added to collection.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */		protected var bAdded : Boolean;

		
		/**
		 * Creates a new iterator for the passed-in array.
		 * 
		 * @param	content		Array iterator's target
		 * @param	startIndex	Iterator's start index
		 * 
		 * @throws	net.pixlib.exceptions.PXNullPointerException If the array's 
		 * 			target is null
		 * @throws	net.pixlib.exceptions.PXIndexOutOfBoundsException If the index 
		 * 			is out of range
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXArrayIterator( content : Array, startIndex : uint = 0 )
		{
			var msg : String;
			
			if ( content == null )
			{
				msg = "Array target of " + this + "can't be null.";
				throw new PXNullPointerException(msg, this);
			}
			
			if ( startIndex > content.length )
			{
				msg = "'" + startIndex + "' is not a valid index for an array with '" + content.length + "' length.";
				throw new PXIndexOutOfBoundsException(msg, this);
			}
		
			aArray = content;
			nSize = content.length;
			nIndex = startIndex - 1;
			bRemoved = false;
			bAdded = false;
		}

		/**
		 * @inheritDoc
		 */
		public function hasNext() : Boolean
		{
			return ( nIndex + 1 < nSize );
		}

		/**
		 * @inheritDoc
		 */
		public function next() : *
		{
			if( !hasNext() )
			{
				var msg : String = " has no more element at '" + ( nIndex + 1 ) + "' index.";
				throw new PXNoSuchElementException(msg, this);
			}
			
			bRemoved = false;
			bAdded = false;
			return aArray[ ++nIndex ];
		}

		/**
		 * @inheritDoc
		 */
		public function remove() : void
		{
			if( bRemoved )
			{
				aArray.splice(nIndex--, 1);
				nSize--;
				bRemoved = true;
			} 
			else
			{
				var msg : String = ".remove() has been already called in this iteration.";
				throw new PXIllegalStateException(msg, this);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function add( element : Object ) : void
		{
			if( !bAdded )
			{
				aArray.splice(nIndex + 1, 0, element);
				nSize++;
				bAdded = true;
			} 
			else
			{
				var msg : String = ".add() has been already called in this iteration.";
				throw new PXIllegalStateException(msg);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function hasPrevious() : Boolean
		{
			return nIndex >= 0;
		}

		/**
		 * @inheritDoc
		 */
		public function nextIndex() : uint
		{
			return nIndex + 1;
		}

		/**
		 * @inheritDoc
		 */
		public function previous() : *
		{
			if( !hasPrevious() )
			{
				var msg : String = " has no more element at '" + ( nIndex ) + "' index.";
				throw new PXNoSuchElementException(msg, this);
			}
			
			bRemoved = false;
			bAdded = false;
			
			return aArray[ nIndex-- ];
		}

		/**
		 * @inheritDoc
		 */
		public function previousIndex() : uint
		{
			return nIndex;
		}

		/**
		 * @inheritDoc
		 */
		public function set( element : Object ) : void
		{
			if( !bRemoved && !bAdded )
			{
				aArray[ nIndex ] = element;
			} 
			else
			{
				var msg : String = ".add() or " + this + ".remove() have been " + "already called in this iteration, the set() operation cannot be done";
				throw new PXIllegalStateException(msg, this);
			}
		}

		/**
		 * Returns string representation of instance.
		 * 
		 * @return The string represenation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String	
		{
			return PXStringifier.process(this) + "[" + nSize + "]";
		}
	}
}
