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
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;

	/**
	 * The <code>PXObjectIterator</code> class provides a convenient way
	 * to iterate through each property of an <code>Object</code> instance 
	 * as you could do with a <code>PXCollection</code> instance.
	 * <p>
	 * Order of returned elements are not guaranteed, the order is the
	 * same as the <code>for...in</code> one.
	 * </p><p>
	 * The object iterator can only iterate thorugh public properties
	 * of an object, as the <code>for...in</code> loop does.
	 * </p> 
	 * 
	 * @example
	 * <listing>
	 * 
	 * var obj : {};
	 * obj.name = "Pixlib";
	 * obj.age = 2;
	 * obj.type = "AS3 Framework for FP10";
	 * 
	 * var it : Iterator = new PXObjectIterator(obj);
	 * while(it.hasNext())
	 * {
	 * 	trace(it.next());
	 * }
	 * //output 2, "Pixlib", "AS3 Framework for FP10"
	 * </listing>
	 * 
	 * @see	PXIterator PXIterator interface
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author 	Cédric Néhémie
	 */
	final public class PXObjectIterator implements PXIterator 
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		/**
		 * Object to iterate throw his properties.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oObject : Object;

		/**
		 * Object properties name.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var vKeys : Vector.<String>;
		
		/**
		 * Number of properties to iterate throw.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nSize : Number;

		/**
		 * Current property index value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var nIndex : Number;

		/**
		 * Indicates if property was removed.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var bRemoved : Boolean;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates a new iterator to iterate through
		 * each property of the passed-in object.
		 * 
		 * @param	object	<code>Object</code> iterator's target
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXObjectIterator( object : Object )
		{
			oObject = object;
			vKeys = new Vector.<String>();
			nIndex = -1;
			bRemoved = false;
			
			init();
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
				var msg : String = " has no more element at '" + ( nIndex + 1 ) + "' index.";
				throw new PXNoSuchElementException(msg, this);
			}
				
			bRemoved = false;
			return oObject[ vKeys[ ++nIndex ] ];
		}

		/**
		 * @inheritDoc
		 */		
		public function remove() : void
		{
			var msg : String;
			if( !bRemoved )
			{
				if( delete oObject[ vKeys[ nIndex ] ] )
				{
					nIndex--;
					bRemoved = true;
				} 
				else
				{
					msg = ".remove() can't delete " + oObject + "." + vKeys[ nIndex ];
					throw new PXUnsupportedOperationException(msg, this);
				}
			} 
			else
			{
				msg = ".remove() has been already called in this iteration.";
				throw new PXIllegalStateException(msg, this);
			}
		}

		/**
		 * Inits object iterator.
		 */
		protected function init() : void
		{
			for( var k : String in oObject ) 
			{ 
				vKeys.push(k); 
			}
			
			nSize = vKeys.length;	
		}
	}
}
