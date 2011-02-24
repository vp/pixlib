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
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;

	import flash.utils.getQualifiedClassName;

	/**
	 * The <code>PXXMLListIterator</code> class provides a convenient way
	 * to iterate through each entry of an <code>XMLList</code> instance.
	 * <p>
	 * Iterations are performed from <code>0</code> to <code>length</code> 
	 * of the passed-in XMLList instance.
	 * </p> 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Cedric Nehemie
	 * @see		PXListIterator
	 */
	final public class PXXMLListIterator implements PXIterator 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		protected var xmlList : XMLList;
		protected var nSize : Number;
		protected var nIndex : Number;


		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new iterator for the passed-in XMLList instance.
		 * 
		 * @param	list	<code>XMLList</code> iterator's target
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXXMLListIterator( list : XMLList )
		{
			this.xmlList = list;
			this.nSize = list.length();
			nIndex = -1;
		}

		/**
		 * @inheritDoc
		 */
		public function hasNext() : Boolean
		{
			return nIndex + 1 < nSize;
		}

		/**
		 * @inheritDoc
		 */
		public function next() : *
		{
			if( !hasNext() )
			{
				throw new PXNoSuchElementException(" has no more element at '" + ( nIndex + 1 ) + "' index.", this);
			}
			
			return xmlList[ ++nIndex ];
		}

		/**
		 * @inheritDoc
		 */
		public function remove() : void
		{
			throw new PXUnsupportedOperationException("remove() is currently not supported in " + getQualifiedClassName(this), this);
		}
	}
}
