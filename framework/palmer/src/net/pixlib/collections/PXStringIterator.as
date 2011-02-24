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
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXIllegalStateException;
	import net.pixlib.exceptions.PXIndexOutOfBoundsException;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.exceptions.PXNullPointerException;

	/**
	 * The <code>PXStringIterator</code> class provides a convenient way
	 * to iterate through each character of a string as you could do with 
	 * a <code>List</code> instance.
	 * <p>
	 * Iterations are performed from <code>0</code> to the <code>length</code> 
	 * of the passed-in string.
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Cédric Néhémie
	 * @see		PXListIterator
	 */
	final public class PXStringIterator implements PXListIterator 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		protected var sString : String;
		protected var nSize : Number;
		protected var nIndex : Number;
		protected var bRemoved : Boolean;
		protected var bAdded : Boolean;
		protected var nGap : Number;
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new string iterator to iterate through
		 * each character of the passed-in string.
		 * 
		 * @param	s	<code>String</code> iterator's target
		 * @param 	gap	
		 * @param	i	iterator's start index
		 * @throws 	<code>PXNullPointerException</code> — if the string's target is null
		 * @throws 	<code>PXIndexOutOfBoundsException</code> — if the index is out of range
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXStringIterator( source : String, gap : Number = 1, i : uint = 0 ) 
		{
			if ( source == null )
			{
				throw new PXNullPointerException("String target of " + this + "can't be null.", this);
			}

			if ( i > source.length )
			{
				throw new PXIndexOutOfBoundsException("'" + i + "' is not a valid index for a string with '" + source.length + "' length.", this);
			}
			
			if ( gap < 1 || gap > source.length ||  source.length % gap != 0 )
			{
				throw new PXIndexOutOfBoundsException("'" + gap + "' is not a valid gap for a string with '" + source.length + "' length.", this);
			}

			sString = source;
			nSize = sString.length / gap;
			nIndex = i - 1;
			bRemoved = false;
			bAdded = false;
			nGap = gap;
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
			if ( !hasNext() )
			{
				throw new PXNoSuchElementException("has no more element at '" + ( nIndex + 1 ) + "' index.", this);
			}

			bAdded = false;
			bRemoved = false;
			return sString.substr(++nIndex * nGap, nGap);
		}

		/**
		 * @inheritDoc
		 */
		public function remove() : void
		{
			if( !bRemoved )
			{
				sString.slice(nIndex--, 1);
				nSize--;
				bRemoved = true;
			} 
			else
			{
				throw new PXIllegalStateException(".remove() has been already called in this iteration.", this);
			}
		}

		/**
		 * @inheritDoc
		 * 
		 * @throws 	<code>PXIllegalArgumentException</code> — The passed-in string couldn't be added due to its length$
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add(element : Object) : void
		{
			if ( !bAdded )
			{
				if ( ( element as String ).length != 1 )
				{
					throw new PXIllegalArgumentException(".add() failed, expected length '1', get '" + (element as String).length + "' length.", this);
				}

				sString = sString.substr(0, nIndex + 1) + element + sString.substring(nIndex + 1);
				nSize++;
				bAdded = true;
			} 
			else
			{
				throw new PXIllegalStateException(".add() has been already called in this iteration", this);
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
			if ( !hasPrevious() )
			{
				throw new PXNoSuchElementException(" has no more element at '" + ( nIndex ) + "' index.", this);
			}

			bAdded = false;
			bRemoved = false;
			return sString.substr(nIndex-- * nGap, nGap);
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
		 * 
		 * @throws 	<code>PXIllegalStateException</code> — The passed-in string couldn't be set due to its length
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function set( element : Object ) : void
		{
			if ( !bRemoved && !bAdded )
			{
				if ( ( element as String ).length != 1 )
				{
					throw new PXIllegalArgumentException(".add() failed, expected length 1, get '" + (element as String).length + "' length.", this);
				}

				sString = sString.substr(0, nIndex) + element + sString.substr(nIndex + 1);
			} 
			else
			{
				throw new PXIllegalStateException(".add() or " + this + ".remove() have been " + "already called in this iteration, the set() operation cannot be done", this);
			}
		}
	}
}
