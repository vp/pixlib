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
	/**
	 * An iterator for lists that allows the programmer
	 * to traverse the list in either direction, modify
	 * the list during iteration, and obtain the iterator's
	 * current position in the list. A <code>PXListIterator</code>
	 * has no current element; its cursor position always lies
	 * between the element that would be returned by a call
	 * to <code>previous()</code> and the element that would
	 * be returned by a call to <code>next()</code>. In a list
	 * of length <code>n</code>, there are <code>n+1</code> valid
	 * index values, from <code>0</code> to <code>n</code>, inclusive. 
	 * <p>
	 * Note that the <code>remove()</code> and <code>set(Object)</code>
	 * methods are not defined in terms of the cursor position; they
	 * are defined to operate on the last element returned by a call
	 * to <code>next()</code> or <code>previous()</code>.
	 * </p>
	 * 
	 * @see		PXIterator
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Cédric Néhémie
	 */
	public interface PXListIterator extends PXIterator
	{
		/**
		 * Inserts the specified element into the list (optional operation).
		 * The element is inserted immediately before the next element that
		 * would be returned by next, if any, and after the next element
		 * that would be returned by previous, if any. (If the list contains
		 * no elements, the new element becomes the sole element on the list.)
		 * The new element is inserted before the implicit cursor: a subsequent
		 * call to next would be unaffected, and a subsequent call to previous
		 * would return the new element. (This call increases by one the value
		 * that would be returned by a call to nextIndex  or previousIndex.)
		 * 
		 * @param	element	the element to insert.
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the 
		 * 			set operation is not supported by this list iterator.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If some aspect of the
		 * 			specified element prevents it from being added to this list.
		 * @throws 	net.pixlib.exceptions.PXIllegalStateException If neither next 
		 * 			nor previous have been called, or remove or add have been called after
		 * 			the last call to next or previous.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function add( element : Object ) : void;

		/**
		 * Returns true if this list iterator has more elements when
		 * traversing the list in the reverse direction. (In other words,
		 * returns <code>true</code> if previous would return an element
		 * rather than throwing an exception.)
		 * 
		 * @return 	<code>true</code> if the list iterator has more elements when
		 * 			traversing the list in the reverse direction.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function hasPrevious() : Boolean;

		/**
		 * Returns the index of the element that would be returned
		 * by a subsequent call to next. (Returns list size if the
		 * list iterator is at the end of the list.)
		 * 
		 * @return 	the index of the element that would be returned
		 * 			by a subsequent call to next, or list size if list
		 * 			iterator is at end of list. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function nextIndex() : uint;

		/**
		 * Returns the previous element in the list. This method
		 * may be called repeatedly to iterate through the list
		 * backwards, or intermixed with calls to next to go back
		 * and forth. (Note that alternating calls to next and
		 * previous will return the same element repeatedly.)
		 * 
		 * @return 	the previous element in the list.
		 * @throws 	net.pixlib.exceptions.PXNoSuchElementException If the iteration has 
		 * 			no previous element.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function previous() : *;

		/**
		 * Returns the index of the element that would be returned
		 * by a subsequent call to previous. (Returns <code>-1</code>
		 * if the list iterator is at the beginning of the list.)
		 * 
		 * @return	the index of the element that would be returned
		 * 			by a subsequent call to previous, or <code>-1</code>
		 * 			if list iterator is at beginning of list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function previousIndex() : uint;

		/**
		 * Replaces the last element returned by next or previous
		 * with the specified element (optional operation).
		 * This call can be made only if neither <code>PXListIterator.remove</code>
		 * nor <code>PXListIterator.add</code> have been called after the last 
		 * call to next or previous.
		 * 
		 * @param	element	The element with which to replace the last
		 * 					element returned by next or previous.
		 * 					
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException If the set operation
		 * 			is not supported by this list iterator.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If some aspect of the
		 * 			specified element prevents it from being added to this list.
		 * @throws 	net.pixlib.exceptions.PXIllegalStateException If neither next nor previous have
		 * 			been called, or remove or add have been called after
		 * 			the last call to next or previous.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function set( element : Object ) : void;
	}
}