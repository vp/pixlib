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
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;	

	/**
	 * The PXRecordSet class map SQL Result into AS3 structure.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public class PXRecordSet implements PXIterable
	{
		//--------------------------------------------------------------------
		// Protected properties
		//--------------------------------------------------------------------
		
		[ArrayElementType("String")]		protected var aColumNames : Array;

		[ArrayElementType("Object")]
		protected var aItems : Array;

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Creates new instance using passed-ni raw data content.
		 * 
		 * @param rawData Raw SQL result data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXRecordSet( rawData : *  )
		{
			parseRawData(rawData);
		}

		/**
		 * clears Recordset.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clear() : void
		{
			aColumNames = new Array();
			aItems = new Array();
		}

		/**
		 * Parses passed-in raw data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function parseRawData( rawData : *  ) : void
		{
			clear();
			
			aColumNames = rawData.serverInfo.columnNames;
	
			var items : Array = rawData.serverInfo.initialData;
			var itemIter : PXIterator = new PXArrayIterator(items);
			while( itemIter.hasNext()) 
			{
				var item : Object = new Object();
				var properties : Array = itemIter.next();
				
				var propertyIter : PXIterator = new PXArrayIterator(properties);
				var propertyIndex : int = 0 ;
				while( propertyIter.hasNext()) 
				{
					var propertyValue : * = propertyIter.next();
					var propertyName : String = aColumNames[ propertyIndex++ ];
					
					item[ propertyName ] = propertyValue;
				}
				
				items.push(item);
			}
		}

		/**
		 * Returns colum names.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getColumnNames() : Array 
		{
			return aColumNames;
		}

		/**
		 * Returns items list.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getItems() : Array
		{
			return aItems;
		}

		/**
		 * Returns recordset item at passed-in index poistion.
		 * 
		 * @param index	Index
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getItemAt( index : Number ) : Object
		{
			if ( isEmpty() )
			{
				PXDebug.WARN(".getItemAt(" + index + ") can't retrieve data, collection is empty.", this);
				return null;
			} 
			else if ( index < 0 || index >= getLength() ) 
			{
				throw new PXIllegalArgumentException(".getItemAt() was used with invalid value :'" + index + "', " + this + ".getLength() equals '" + getLength() + "'", this);
				
				return null;
			} 
			else
			{
				return aItems[ index ];
			}
		}

		/**
		 * Returns <code>true</code> if there is no data in current recordset.
		 * 
		 * @return <code>true</code> if there is no data in current recordset.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isEmpty() : Boolean
		{
			return aItems.length == 0;
		}

		/**
		 * Returns an PXIterator throw colmun names.
		 * 
		 * @return an PXIterator throw colmun names.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function columnIterator( ) : PXIterator 
		{
			return new PXArrayIterator(getColumnNames());
		}

		/**
		 * Returns an PXIterator throw recordset items.
		 * 
		 * @return an PXIterator throw recordset items.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function iterator() : PXIterator
		{
			return new PXArrayIterator(getItems());
		}

		/**
		 * Returns amount of item in current recorset.
		 * 
		 * @return amount of item in current recorset.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getLength() : Number
		{
			return aItems.length;
		}

		/**
		 * Returns the string representation of this instance.
		 * 
		 * @return the string representation of this instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this) + "column[" + getColumnNames() + "] values[" + getItems() + "]" ; 
		}
	}
}