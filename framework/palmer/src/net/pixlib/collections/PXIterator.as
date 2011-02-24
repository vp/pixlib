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
	 * An iterator over a collection.
	 * 
	 * @see		PXIterable
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Francis Bourre
	 */
	public interface PXIterator
	{
		/**
		 * Returns true if the iteration has more elements.
		 * (In other words, returns true if next would return
		 * an element rather than throwing an exception.)
		 * 
		 * @return <code>true</code> if the iterator has more elements.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function hasNext() : Boolean;

		/**
		 * Returns the next element in the iteration. Calling this method
		 * repeatedly until the hasNext() method returns false will return
		 * each element in the underlying collection exactly once.
		 * 
		 * @return	the next element in the iteration.
		 * @throws 	net.pixlib.exceptions.PXNoSuchElementException  iteration has 
		 * 			no more elements.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function next() : *;

		/**
		 * Removes from the underlying collection the last element returned
		 * by the iterator (optional operation). This method can be called
		 * only once per call to next. The behavior of an iterator is unspecified
		 * if the underlying collection is modified while the iteration is in
		 * progress in any way other than by calling this method.
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException if the 
		 * 			remove  operation is not supported by this Iterator.
		 * @throws 	net.pixlib.exceptions.PXIllegalStateException if the next 
		 * 			method has not yet been called, or the remove method has 
		 * 			already been called after the last call to the next  method.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function remove() : void;
	}
}