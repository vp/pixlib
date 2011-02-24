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
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.log.PXStringifier;

	/**
	 * A collection designed for holding elements prior to processing.
	 * Besides basic <code>PXCollection</code> operations,
	 * queues provide additional insertion, extraction, and inspection
	 * operations.
	 * <p>
	 * The <code>PXQueue</code> class allow as many occurrences as you
	 * want. In a same way, <code>null</code> values are allowed in
	 * the queue.
	 * </p><p>
	 * Elements in a <code>PXQueue</code> are orderered according
	 * to a FIFO (first-in-first-out) order.
	 * </p>
	 * 
	 * @example Using an untyped PXQueue
	 * <listing>
	 * 
	 * var queue : PXQueue = new PXQueue ();
	 * queue.add( 20 )
	 * queue.add( "20" );
	 * queue.add( 80 );
	 * 
	 * trace ( queue.size() ); // 3 
	 * trace ( queue.poll() ); // 80
	 * 
	 * trace ( queue.peek() ); // "20"
	 * trace ( queue.size() ); // 2 
	 * </listing>
	 * 
	 * @example Using a typed PXQueue
	 * <listing>
	 * 
	 * var queue : PXQueue = new PXQueue (Number);
	 * queue.add( 20 )
	 * try
	 * {
	 * 	queue.add( "20" ); // throws an error because "20" is not a Number
	 * 	queue.add( 80 );
	 * }
	 * catch ( e : Error ) {}
	 * 
	 * trace ( queue.size() ); // 2
	 * trace ( queue.poll() ); // 80
	 * 
	 * trace ( queue.peek() ); // 20
	 * trace ( queue.size() ); // 1 
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Romain Flacher
	 * @author 	Cédric Néhémie
	 */
	public class PXQueue implements PXCollection, PXTypedContainer
	{

		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------

		[ArrayElementType("Object")] 
		/** 
		 * Elements array.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var aQueue : Array;

		/** 
		 * Queue type.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oType : Class;
		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * The class type of elements in this queue object.
		 * <p>
		 * An untyped queue returns <code>null</code>, as the
		 * wildcard type (<code>~~</code>) is not a <code>Class</code>
		 * and <code>Object</code> class doesn't fit for primitive types.
		 * </p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get type() : Class
		{
			return oType;
		} 
		
		/**
		 * Returns <code>true</code> if this queue perform a verification
		 * of the type of elements.
		 * 
		 * @return  <code>true</code> if this queue perform a verification
		 * 			of the type of elements.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get typed() : Boolean
		{
			return oType != null;
		}
		
		/**
		 * Returns <code>true</code> if this queue contains no elements.
		 *
		 * @return <code>true</code> if this queue contains no elements.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get empty() : Boolean
		{
			return aQueue.length == 0;
		}
		
		/**
		 * Returns the number of elements in this queue (its cardinality).
		 *
		 * @return <code>Number</code> of elements in this queue (its cardinality).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get length() : uint
		{
			return aQueue.length;
		}
		
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Create an empty <code>PXQueue</code> object. 
		 * 
		 * @param	type (optional) Queue type
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXQueue( type : Class = null )
		{
			aQueue = new Array();
			oType = type;
		}

		/**
		 * Adds the specified element to this queue. 
		 * The object is added as the top of the queue.
		 * <p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added in this queue, the function throws
		 * an <code>PXIllegalArgumentException</code>.
		 * </p>
		 * 
		 * @param	element Element to be added to this queue.
		 * @return 	<code>true</code> if this queue have changed at
		 * 			the end of the call
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the object's
		 * 			type prevents it to be added into this queue
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add( element : Object ) : Boolean
		{
			if( isValidType(element) )
			{
				aQueue.push(element);
				return true;
			}

			return false;
		}

		/**
		 * Removes a single instance of the specified element from this
		 * queue, if this queue contains one or more such elements.
		 * Returns <code>true</code> if this queue contained the specified
		 * element (or equivalently, if this collection changed as a result
		 * of the call).
		 * <p>
		 * In order to remove all occurences of an element you have to call
		 * the <code>remove</code> method as long as the queue contains an
		 * occurrence of the passed-in element. Typically, the construct to
		 * remove all occurrences of an element should look like that :
		 * <listing>
		 * while( queue.contains( element ) ) queue.remove( element );
		 * </listing>
		 * </p><p>
		 * If the current queue object is typed and if the passed-in object's  
		 * type prevents it to be added (and then removed) in this queue,
		 * the function throws a <code>PXIllegalArgumentException</code>.
		 * </p> 
		 * @param	element <code>object</code> to be removed from this queue,
		 * 			  if present.
		 * @return 	<code>true</code> if the queue contained the 
		 * 			specified element.
		 * @throws	net.pixlib.exceptions.PXIllegalArgumentException If the object's type
		 * 			prevents it to be added into this queue
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function remove( element : Object ) : Boolean
		{
			if( isValidType(element) && contains(element) )
			{
				aQueue.splice(aQueue.indexOf(element), 1);
				return true;
			}

			return false;
		}

		/**
		 * Returns <code>true</code> if this queue contains at least
		 * one occurence of the specified element. Moreformally,
		 * returns <code>true</code> if and only if this queue contains
		 * at least an element <code>e</code> such that <code>o === e</code>.
		 *
		 * @param	element	<code>Object</code> whose presence in this queue
		 * 			  	is to be tested.
		 * @return 	<code>true</code> if this queue contains the specified
		 * 			element.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the object's type
		 * 			prevents it to be added into this queue
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function contains( element : Object ) : Boolean
		{
			isValidType(element);
			return aQueue.indexOf(element) != -1;
		}

		/**
		 * Removes all of the elements from this queue
		 * (optional operation). This queue will be empty
		 * after this call returns (unless it throws an exception).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			aQueue = new Array();
		}

		/**
		 * Returns an iterator over the elements in this queue. 
		 * The elements are returned according to the FIFO
		 * (first-in-first-out) order. 
		 *
		 * @return an iterator over the elements in this queue.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function iterator() : PXIterator
		{
			return new QueueIterator(this);
		}

		/**
		 * Adds all of the elements in the specified <code>PXCollection</code> 
		 * to this queue. The behavior of this operation is
		 * unspecified if the specified collection is modified while the
		 * operation is in progress.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>PXCollection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>addAll</code> method.
		 * </p>
		 * @param	collection 	<code>PXCollection</code> whose elements are to be added to this queue.
		 * @return 	<code>true</code> if this queue changed as a result of the call.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in collection
		 * 			type is not the same that the current one.	
		 * @see 	#add() add()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * 			
		 * @example	How the <code>Queue.addAll</code> method works with types 
		 * <p>
		 * Let say that you have two typed queues <code>typedQueue1</code>
		 * and <code>typedQueue2</code> such :
		 * </p> 
		 * <listing>
		 * 
		 * var typedQueue1 : PXQueue = new PXQueue( String );
		 * var typedQueue2 : PXQueue = new PXQueue( String );
		 * 
		 * typedQueue1.add( "foo1" );
		 * typedQueue1.add( "foo2" );
		 * typedQueue1.add( "foo3" );
		 * typedQueue1.add( "foo4" );
		 * 
		 * typedQueue2.add( "foo3" );
		 * typedQueue2.add( "foo4" );
		 * typedQueue2.add( "foo5" );
		 * typedQueue2.add( "foo6" );
		 * </listing>
		 * 
		 * And two untyped queues <code>untypedQueue1</code>
		 * and <code>untypedQueue2</code> such : 
		 * 
		 * <listing>
		 * 
		 * var untypedQueue1 : PXQueue = new PXQueue();
		 * var untypedQueue2 : PXQueue = new PXQueue();
		 * 
		 * untypedQueue1.add( 1 );
		 * untypedQueue1.add( 2 );
		 * untypedQueue1.add( 3 );
		 * untypedQueue1.add( "foo1" );
		 * 
		 * untypedQueue2.add( 3 );
		 * untypedQueue2.add( 4 );
		 * untypedQueue2.add( 5 );
		 * untypedQueue2.add( "foo1" );
		 * </listing>
		 * 
		 * The two operations below will work as expected, 
		 * realizing the union of the queues objects.
		 * 
		 * <listing>
		 * 
		 * typedQueue1.addAll ( typedQueue2 );
		 * // will produce a queue containing : 
		 * // 'foo1'
		 * // 'foo2'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * 
		 * untypedQueue1.addAll ( untypedQueue2 );
		 * // will produce a queue containing : 
		 * // 1
		 * // 2
		 * // 3
		 * // 'foo1'
		 * // 3
		 * // 4
		 * // 5
		 * // 'foo1'
		 * </listing>
		 * 
		 * As an untyped queue can contain any types of objects at the
		 * same time, the code below is always valid.
		 * 
		 * <listing>
		 * untypedQueue1.addAll( typedQueue2 );
		 * // will produce a queue containing : 
		 * // 1
		 * // 2
		 * // 3
		 * // 'foo1'
		 * // 3
		 * // 4
		 * // 5
		 * // 'foo1'
		 * // 'foo3'
		 * // 'foo4'
		 * // 'foo5'
		 * // 'foo6'
		 * </listing>
		 * 
		 * But if you try to add an untyped collection to a typed one
		 * the call will fail with an exception.
		 * 
		 * <listing>
		 * try
		 * {
		 * 	typedQueue2.addAll( untypedQueue2 );
		 * }
		 * catch( e : PXIllegalArgumentException )
		 * {
		 * 	trace( e ); 
		 * 	// The passed-in collection with type 'null' has not the same type 
		 * 	// than net.pixlib.collections::PXQueue&lt;String&gt;
		 * }
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addAll( collection : PXCollection ) : Boolean
		{
			if( isValidCollection(collection) )
			{
				var iter : PXIterator = collection.iterator();
				var modified : Boolean = false;
				
				while( iter.hasNext() )
				{
					var element : * = iter.next();
					if( isValidType(element) )
					{
						aQueue.push(element);
						modified = true;
					}
				}

				return modified;
			}

			return false;
		}

		/**
		 * Removes from this queue all of its elements that are contained
		 * in the specified collection (optional operation). At the end
		 * of the call there's no occurences of any elements contained
		 * in the passed-in collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>PXCollection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>removeAll</code> method.
		 * </p>
		 * @param	collection 	<code>PXCollection</code> that defines which elements will be
		 * 			  	removed from this queue.
		 * @return 	<code>true</code> if this queue changed as a result
		 * 			of the call.
		 * @throws 	net.pixlib.exceptions.PXNullPointerException If the specified collection is
		 *          <code>null</code>.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in collection
		 * 			type is not the same that the current one.    
		 * @see    	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * 			
		 * @example Using the <code>PXQueue.removeAll()</code> with untyped queues
		 * <listing>
		 * 
		 * var queue1 : PXQueue = new PXQueue();
		 * var queue2 : PXQueue = new PXQueue();
		 * 
		 * queue1.add( 1 );
		 * queue1.add( 2 );
		 * queue1.add( 3 );
		 * queue1.add( 4 );
		 * queue1.add( "foo1" );
		 * queue1.add( "foo2" );
		 * queue1.add( "foo3" );
		 * queue1.add( "foo4" );
		 * 
		 * queue2.add( 1 );
		 * queue2.add( 3 );
		 * queue2.add( "foo1" );
		 * queue2.add( "foo3" );
		 * 
		 * trace ( queue1.removeAll ( queue2 ) ) ;// true
		 * // queue1 now contains :
		 * // 2, 4, 'foo2', 'foo4' 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAll( collection : PXCollection ) : Boolean
		{
			if( isValidCollection(collection) )
			{	
				var iter : PXIterator = collection.iterator();
				var find : Boolean = false;
				
				while( iter.hasNext() )
				{
					var element : * = iter.next();
					while( this.contains(element) ) find = this.remove(element) || find;
				}
		
				return find;
			}

			return false;
		}

		/**
		 * Returns <code>true</code> if this queue contains
		 * all of the elements of the specified collection. If the specified
		 * collection is also a <code>PXSet</code>, this method returns <code>true</code>
		 * if it is a <i>subliset</i> of this queue.
		 * <p>
		 * If the passed-in <code>PXCollection</code> is null the method throw a
		 * <code>PXNullPointerException</code> error.
		 * </p><p>
		 * If the passed-in <code>PXCollection</code> type is different than the current
		 * one the function will throw an <code>PXIllegalArgumentException</code>.
		 * However, if the type of this queue is <code>null</code>, 
		 * the passed-in <code>PXCollection</code> can have any type. 
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped <code>PXCollection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>containsAll</code> method.
		 * </p>
		 * @param	collection	<code>PXCollection</code>
		 * @return 	<code>true</code> if this queue contains all of the elements of the
		 * 	       	specified collection.
		 * 	       	
		 * @throws 	net.pixlib.exceptions.PXNullPointerException If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in collection
		 * 			type is not the same that the current one.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function containsAll( collection : PXCollection ) : Boolean
		{
			if ( isValidCollection(collection) )
			{
				var iter : PXIterator = collection.iterator();
				
				while( iter.hasNext() ) if( !contains(iter.next()) ) return false;
				return true;
			}

			return false;
		}

		/**
		 * Retains only the elements in this queue that are contained
		 * in the specified collection (optional operation). In other words,
		 * removes from this queue all of its elements that are not
		 * contained in the specified collection.
		 * <p>
		 * The rules which govern collaboration between typed and untyped <code>PXCollection</code>
		 * are described in the <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
		 * @param	collection 	<code>PXCollection</code> that defines which elements this
		 * 			  	queue will retain.
		 * @return 	<code>true</code> if this collection changed as a result of the
		 *         	call.
		 * @throws 	net.pixlib.exceptions.PXNullPointerException If the specified collection is
		 *          <code>null</code>.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in collection
		 * 			type is not the same that the current one.
		 * @see 	#remove() remove()
		 * @see		#isValidCollection() See isValidCollection for description of the rules for 
		 * 			collaboration between typed and untyped collections.
		 * 			
		 * @example Using the <code>PXQueue.retainAll()</code> with untyped queues
		 * <listing>
		 * 
		 * var queue1 : PXQueue = new PXQueue();
		 * var queue2 : PXQueue = new PXQueue();
		 * 
		 * queue1.add( 1 );
		 * queue1.add( 2 );
		 * queue1.add( 3 );
		 * queue1.add( 4 );
		 * queue1.add( "foo1" );
		 * queue1.add( "foo2" );
		 * queue1.add( "foo3" );
		 * queue1.add( "foo4" );
		 * 
		 * queue2.add( 1 );
		 * queue2.add( 3 );
		 * queue2.add( "foo1" );
		 * queue2.add( "foo3" );
		 * 
		 * trace ( queue1.retainAll ( queue2 ) ) ;// true
		 * // queue1 now contains :
		 * // 1, 3, 'foo1', 'foo3' 
		 * </listing>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function retainAll( collection : PXCollection ) : Boolean
		{
			if ( isValidCollection(collection) )
			{
				var modified : Boolean = false;
				var fin : int = aQueue.length;
				var index : int = 0;

				while( index < fin )
				{
					var obj : * = aQueue[ index ];
					if( !collection.contains(obj) )
					{
						var fromIndex : int = 0;
						while( true )
						{
							fromIndex = aQueue.indexOf(obj, fromIndex);
							if ( fromIndex == -1 ) break;
							modified = true;
							aQueue.splice(fromIndex, 1);
							--fin;
						}
					} 
					else
					{
						++index;
					}
				}

				return modified;
			}

			return false;
		}

		/**
		 * Retrieves, but does not remove, the head of this queue,
		 * or returns <code>null</code> if this queue is empty.
		 *
		 * @return 	the head of this queue, or <code>null</code>
		 * 			if this queue is empty
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function peek() : Object
		{
			return aQueue[ 0 ];
		}

		/**
		 * Retrieves and removes the head of this queue,
		 * or returns <code>null</code> if this queue is empty.
		 *
		 * @return 	the head of this queue, or <code>null</code>
		 * 		   	if this queue is empty
		 * 		   	
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function poll() : Object
		{
			return aQueue.shift();
		}

		/**
		 * Verify that the passed-in object type match the current 
		 * queue element's type. 
		 * 
		 * @return  <code>true</code> if the object is elligible for this
		 * 			queue object, either <code>false</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function matchType( element : * ) : Boolean
		{
			return element is oType;
		}

		/**
		 * Verify that the passed-in <code>PXCollection</code> is a valid
		 * collection for use with the <code>addAll</code>, <code>removeAll</code>,
		 * <code>retainAll</code> and <code>containsAll</code> methods.
		 * <p>
		 * When dealing with typed and untyped collection, the following rules apply : 
		 * <ul>
		 * <li>Two typed collection, which have the same type, can collaborate each other.</li>
		 * <li>Two untyped collection can collaborate each other.</li>
		 * <li>An untyped collection can add, remove, retain or contains any typed collection
		 * of any type without throwing errors.</li>
		 * <li>A typed collection will always fail when attempting to add, remove, retain
		 * or contains an untyped collection.</li>
		 * </ul></p><p>
		 * If the passed-in <code>PXCollection</code> is null the method throw a
		 * <code>PXNullPointerException</code> error.
		 * </p>
		 * 
		 * @param	collection <code>PXCollection</code> to verify
		 * @return 	boolean <code>true</code> if the collection is valid, 
		 * 			either <code>false</code> 			
		 * @throws 	net.pixlib.exceptions.PXNullPointerException If the passed-in collection
		 * 			is <code>null</code>
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the passed-in collection
		 * 			type is not the same that the current one.
		 * 			
		 * @see		#addAll() addAll()
		 * @see		#removeAll() removeAll()
		 * @see		#retainAll() retainAll()
		 * @see		#containsAll() containsAll()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isValidCollection( collection : PXCollection ) : Boolean
		{
			if ( collection == null ) 
			{
				throw new PXNullPointerException(" The passed-in collection is null in " + this, this);
			} 
			else if ( type != null )
			{
				if ( collection is PXTypedContainer && ( collection as PXTypedContainer ).type != type )
				{
					throw new PXIllegalArgumentException(" The passed-in collection is not of the same type than " + this, this);
				} 
				else
				{
					return true;
				}
			} 
			else
			{
				return true;
			}
		}

		/**
		 * Verify that the passed-in object type match the current 
		 * <code>PXQueue</code> element's type. 
		 * <p>
		 * In the case that the queue is untyped the function
		 * will always returns <code>true</code>.
		 * </p><p>
		 * In the case that the object's type prevents it to be added
		 * as element for this queue the method will throw
		 * a <code>PXIllegalArgumentException</code>.
		 * </p> 
		 * @param	element <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			queue object, either <code>false</code>.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the object's type
		 * 			prevents it to be added into this queue
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isValidType( element : Object ) : Boolean
		{
			if ( type != null)
			{
				if ( matchType(element) )
				{
					return true;
				} 
				else
				{
					throw new PXIllegalArgumentException(element + " has a wrong type for " + this, this) ;
				}
			} 
			else
			{
				return true;
			}
		}

		/**
		 * Returns an array containing all the elements in this queue.
		 * Obeys the general contract of the <code>PXCollection.toArray</code>
		 * method.
		 *
		 * @return  <code>Array</code> containing all of the elements
		 * 			in this queue.
		 * @see		PXCollection#toArray() Collection.toArray()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toArray() : Array
		{
			return aQueue.concat();
		}

		/**
		 * Returns the <code>String</code> representation of
		 * this object. 
		 * <p>
		 * The function return a string like
		 * <code>net.pixlib.collection::PXQueue&lt;String&gt;</code>
		 * for a typed collection. The string between the &lt;
		 * and &gt; is the name of the type of the collection's
		 * elements. If the collection is an untyped collection
		 * the function will simply return the result of the
		 * <code>PXStringifier.process</code> call.
		 * </p>
		 * @return <code>String</code> representation of
		 * 		   this object.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			var hasType : Boolean = type != null;
			var parameter : String = "";
			
			if ( hasType )
			{
				parameter = type.toString();
				parameter = "<" + parameter.substr(7, parameter.length - 8) + ">";
			}
			
			return PXStringifier.process(this) + parameter;
		}   
	}
}

import net.pixlib.collections.PXIterator;
import net.pixlib.collections.PXQueue;
import net.pixlib.exceptions.PXIllegalStateException;
import net.pixlib.exceptions.PXNoSuchElementException;

internal class QueueIterator implements PXIterator
{
	private var _queue : PXQueue;
	private var _nIndex : int;
	private var _nLastIndex : int;

	[ArrayElementType("Object")] 
	private var _array : Array;
	private var _bRemoved : Boolean;

	
	public function QueueIterator( c : PXQueue )
	{
		_queue = c;
		_nIndex = -1;
		_array = _queue.toArray();
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

		_bRemoved = true;
		return _array[ ++_nIndex ];
	}

	public function remove() : void
	{
		if( !_bRemoved )
		{
			_queue.remove(_array[ _nIndex]);
			_array = _queue.toArray();
			_nLastIndex--;
			_bRemoved = true;
		} 
		else
		{
			throw new PXIllegalStateException(".remove() have been already called for this iteration", this);
		}
	}
}