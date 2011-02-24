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
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.log.PXStringifier;

	import flash.utils.Dictionary;

	/**
	 * A weak collection stores element using weak references instead
	 * of the classical hard references. That mean that the integrity
	 * of the collection is never guarantee. An element which is in the
	 * weak collection could be removed as soon as the Garbage Collector
	 * has defined that this element is no longer used in the program.
	 * <p>
	 * Weak reference internally use a <code>Dictionnary</code> object
	 * instead of an <code>Array</code>. Elements are stored as keys in
	 * the dictionnary, resulting that there can be only one occurrence
	 * of an element in the collection.
	 * </p><p>
	 * In current state of the art the weak collection allow any types
	 * for its elements. 
	 * </p>  
	 * 
	 * @author 	Francis Bourre
	 * @see		PXCollection
	 *
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXWeakCollection implements PXCollection
	{
		protected var oDico : Dictionary;

		
		/**
		 * Returns the number of elements in this collection (its cardinality). 
		 * 
		 * @return <code>Number</code> of elements in this collection (its cardinality).
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get length() : uint
		{
			return Math.max(toArray().length, 0);
		}
		
		/**
		 * Returns <code>true</code> if this collection contains no elements.
		 *
		 * @return <code>true</code> if this collection contains no elements
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get empty() : Boolean
		{
			return length == 0;
		}
		
		/**
		 * Creates a new weak collection, which initially contains
		 * the data from the passed-in array (optional operation).
		 * 
		 * @param	content	<code>Array</code> initializer for the collection 
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXWeakCollection( content : Array = null )
		{
			clear();

			if ( content != null )
			{
				init(content);
			}
		}

		/**
		 *
		 */
		protected function init(content : Array = null) : void
		{
			var len : int = content.length;
			if ( len > 0 ) while( --len > -1 ) add(content[ len ]);
		}

		/**
		 * Adds the passed-in object into this collection.
		 * Returns <code>true</code> if this collection changed
		 * as a result of the call. Returns <code>false</code>
		 * if this collection does not permit duplicates and already
		 * contains the specified element.
		 * 
		 * @param	o	element to add to this collection
		 * @return	<code>true</code> if the collection changed
		 * 			as a result of the call
		 * @example How to use the <code>PXWeakCollection.add</code> method
		 * <listing>
		 * var col : PXWeakCollection = new PXWeakCollection();
		 * 
		 * col.add( "foo" );
		 * 
		 * col.add( "foo" ); // return false, as 'foo' already exist in this set
		 * </listing>
		 * 
		 * In comparison with Java, where object which have all of their properties
		 * equals are considered as equals, AS3 doesn't allow that, except if objects
		 * provides an <code>equals</code> method which is used instead of the 
		 * <code>==</code> or <code>===</code> operators. Nevertheless, the 
		 * <code>PXWeakCollection</code> class use the native operator to perform
		 * comparison, thus two objects with equals properties are considered
		 * as differents.
		 * 
		 * <listing>
		 * var col : PXWeakCollection = new PXWeakCollection();
		 * var o : Object = { x : 50, y : 100 };
		 * 
		 * col.add( o ); 
		 * col.add( o ); // return false, as o' already exist in this set
		 * 
		 * col.add( { x : 50, y : 100 } ); // return true, as the argument is not
		 * 								   // the same object than o, even if all
		 * 								   // their properties are equals
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add( element : Object ) : Boolean
		{
			if ( !contains(element) )
			{
				return oDico[ element ] = true;
			} 
			else 
			{
				return false;
			}
		}

		/**
		 * Adds all of the elements in the specified collection to this collection.
		 * If the specified collection is also a weak collection, the <code>addAll</code>
		 * operation effectively modifies this set so that its value is the 
		 * <i>union</i> of the two sets. The behavior of this operation is
		 * unspecified if the specified collection is modified while the
		 * operation is in progress.
		 * 
		 * @param 	c 	elements to be inserted into this collection.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call
		 * @see 	#add() add()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addAll( collection : PXCollection ) : Boolean
		{
			var success : Boolean = false;
			var iter : PXIterator = collection.iterator();
			while( iter.hasNext() ) success = add(iter.next()) || success;
			return success;
		}

		/**
		 * Removes all of the elements from this collection.
		 * This collection will be empty after this method returns unless it
		 * throws an exception.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			oDico = new Dictionary(true);
		}

		/**
		 * Returns <code>true</code> if this collection contains the
		 * specified element. More formally, returns <code>true</code> if
		 * and only if this collection contains an element <code>e</code>
		 * such that <code>o === e</code>.
		 *
		 * @param	o	<code>Object</code> whose presence in this set
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this set contains the specified
		 * 			element.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function contains( element : Object ) : Boolean
		{
			return oDico[ element ];
		}

		/**
		 * Returns <code>true</code> if this collection contains
		 * all of the elements of the specified collection. If the specified
		 * collection is also a <code>PXWeakCollection</code>, this method returns 
		 * <code>true</code> if it is a <i>subset</i> of this collection.

		 * @param	c	<code>PXCollection</code> to be checked for containment
		 * 				in this collection.
		 * @return 	<code>true</code> if this collection contains all of the
		 * 			elements of the	specified collection.
		 * @throws 	<code>PXNullPointerException</code> — if the specified collection is
		 *         	<code>null</code>.
		 * @see    	#contains() contains()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function containsAll( collection : PXCollection ) : Boolean
		{
			if( collection == null ) 
			{
				throw new PXNullPointerException("The passed-in collection is null", this);
			}

			var iter : PXIterator = collection.iterator();
			while( iter.hasNext() ) if ( oDico[ iter.next() ] != true ) return false;
			return true;
		}

		/**
		 * Returns an iterator over the elements in this collection. 
		 * The elements are returned in no particular order.
		 *
		 * @return an iterator over the elements in this set.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function iterator() : PXIterator
		{
			return new ConcretIterator(this);
		}

		/**
		 * Removes the specified element from this collection
		 * if it is present. More formally,
		 * removes an element <code>e</code> such that
		 * <code>o === e</code>, if the collection contains
		 * such an element. Returns <code>true</code> if the collection
		 * contained the specified element (or equivalently, if the
		 * collection changed as a result of the call). 
		 * (The collection will not contain the specified element
		 * once the call returns.)
		 *
		 * @param	o 	<code>object</code> to be removed from this collection,
		 * 				if present.
		 * @return 	<code>true</code> if the collection contained the specified element.
		 * @example	Using the <code>PXWeakCollection.remove()</code> method : 
		 * <listing>
		 * var set : PXSet = new PXSet();
		 * set.add ( "foo" );
		 * 
		 * trace( set.size() ); // 1
		 * trace( set.remove( "foo" ) ); // true, the passed-in value have been removed
		 * 
		 * trace( set.size() ); // 0
		 * trace( set.remove( "foo" ) ); // false, the passed-in value is no longer stored in this set
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove( element : Object ) : Boolean
		{
			if ( oDico[ element ] ) 
			{
				oDico[ element ] = null;
				delete oDico[ element ];
				return true;
			} 
			else
			{
				return false;
			}
		}

		/**
		 * Removes from this collection all of its elements that are contained
		 * in the specified collection. If the specified <code>Collection</code>
		 * is also a <code>PXWeakCollection</code>, this operation effectively
		 * modifies this collection so that its value is the <i>asymmetric
		 * difference</i> of the two collections.
		 * 
		 * @param	c 	<code>PXCollection</code> that defines which elements will be
		 * 			  	removed from this collection.
		 * @return 	<code>true</code> if this collection changed as a result
		 * 			of the call.
		 * @throws 	<code>PXNullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @see    	#remove() remove()
		 * @example Using the <code>PXWeakCollection.removeAll()</code> method
		 * <listing>
		 * var col1 : PXWeakCollection = new PXWeakCollection();
		 * var col2 : PXWeakCollection = new PXWeakCollection();
		 * 
		 * col1.add( 1 );
		 * col1.add( 2 );
		 * col1.add( 3 );
		 * col1.add( 4 );
		 * col1.add( "foo1" );
		 * col1.add( "foo2" );
		 * col1.add( "foo3" );
		 * col1.add( "foo4" );
		 * 
		 * col2.add( 1 );
		 * col2.add( 3 );
		 * col2.add( "foo1" );
		 * col2.add( "foo3" );
		 * 
		 * trace ( col1.removeAll ( col2 ) ) ;// true
		 * // col1 now contains :
		 * // 2, 4, 'foo2', 'foo4' 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAll( collection : PXCollection ) : Boolean
		{
			if ( collection == null ) 
			{
				throw new PXNullPointerException("The passed-in collection is null", this);
			}
			
			var success : Boolean = false;
			var iter : PXIterator = collection.iterator();
			while( iter.hasNext() ) success = remove(iter.next()) || success;
			return success;
		}

		/**
		 * Retains only the elements in this collection that are contained
		 * in the specified collection. In other words, removes from this
		 * collection all of its elements that are not contained in the specified
		 * collection. If the specified collection is also a <code>PXWeakCollection</code>,
		 * this operation effectively modifies this set so that its value is the
		 * <i>intersection</i> of the two sets.

		 * @param	c 	<code>PXCollection</code> that defines which elements this
		 * 			  	collection will retain.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	<code>PXNullPointerException</code> — if the specified collection is
		 *          <code>null</code>.
		 * @see 	#remove() remove()
		 * @example Using the <code>PXWeakCollection.retainAll()</code> method
		 * <listing>
		 * var col1 : PXWeakCollection = new PXWeakCollection();
		 * var col2 : PXWeakCollection = new PXWeakCollection();
		 * 
		 * col1.add( 1 );
		 * col1.add( 2 );
		 * col1.add( 3 );
		 * col1.add( 4 );
		 * col1.add( "foo1" );
		 * col1.add( "foo2" );
		 * col1.add( "foo3" );
		 * col1.add( "foo4" );
		 * 
		 * col2.add( 1 );
		 * col2.add( 3 );
		 * col2.add( "foo1" );
		 * col2.add( "foo3" );
		 * 
		 * trace ( col1.retainAll ( col2 ) ) ;// true
		 * // col1 now contains :
		 * // 1, 3, 'foo1', 'foo3' 
		 * </listing>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function retainAll( collection : PXCollection ) : Boolean
		{
			if ( collection == null ) 
			{
				throw new PXNullPointerException("The passed-in collection is null", this);
			}
			
			var success : Boolean = false;
			var iter : PXIterator = iterator();
			
			while( iter.hasNext() )
			{
				var element : Object = iter.next();
				if ( !(collection.contains(element)) ) success = remove(element) || success;
			}
			
			return success;
		}

		/**
		 * Returns an array containing all the elements in this set.
		 * Obeys the general contract of the <code>PXCollection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements in this set.
		 * @see		PXCollection#toArray() PXCollection.toArray()
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toArray() : Array
		{
			var array : Array = new Array();
			for ( var k : Object in oDico ) if ( oDico[k] ) array.push(k);
			return array;
		}

		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * 
		 * @return <code>String</code> representation of
		 * 		   this object.
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
import net.pixlib.collections.PXIterator;
import net.pixlib.collections.PXWeakCollection;
import net.pixlib.exceptions.PXIllegalStateException;
import net.pixlib.exceptions.PXNoSuchElementException;

internal class ConcretIterator 
	implements PXIterator
{
	private var _col : PXWeakCollection;
	private var _nIndex : int;
	private var _nLastIndex : int;
	private var _array : Array;
	private var _bRemoved : Boolean;

	
	public function ConcretIterator( c : PXWeakCollection )
	{
		_col = c;
		_nIndex = -1;
		_array = _col.toArray();
		_nLastIndex = _array.length - 1;
		_bRemoved = false;
	}

	public function hasNext() : Boolean
	{
		return _nLastIndex > _nIndex;
	}

	public function next() : *
	{
		if( !hasNext() )
		{
			throw new PXNoSuchElementException(" has no more elements at " + ( _nIndex ), this);
		}
			
		_bRemoved = false;
		return _array[ ++_nIndex ];
	}

	public function remove() : void
	{
		if ( !_bRemoved )
		{
			_col.remove(_array[ _nIndex ]);
			_array = _col.toArray();
			_nLastIndex--;
			_bRemoved = true;
		} 
		else
		{
			throw new PXIllegalStateException(".remove() have been already called for this iteration", this);
		}
	}
}