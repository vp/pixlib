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
package net.pixlib.structures
{
	import net.pixlib.collections.PXCollection;
	import net.pixlib.collections.PXIterator;
	import net.pixlib.collections.PXTypedContainer;
	import net.pixlib.collections.PXWeakCollection;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.exceptions.PXIndexOutOfBoundsException;
	import net.pixlib.exceptions.PXNullPointerException;
	import net.pixlib.exceptions.PXUnsupportedOperationException;
	import net.pixlib.log.PXStringifier;

	import flash.geom.Point;

	/** 
	 * A <code>PXGrid</code> is basically a two dimensions data structure
	 * based on the <code>PXCollection</code> interface.
	 * <p>
	 * By default a <code>PXGrid</code> object is an untyped collection that
	 * allow duplicate and <code>null</code> elements. You can set your own
	 * default value instead of <code>null</code> by passing it to the grid
	 * constructor.
	 * </p><p>
	 * Its also possible to restrict the type of grid elements in the constructor
	 * as defined by the <code>PXTypedContainer</code> interface.
	 * </p><p>
	 * The <code>PXGrid</code> class don't support all the methods of the 
	 * <code>PXCollection</code> interface. Here the list of the 
	 * unsupported methods : 
	 * <ul>
	 * 	<li><code>add</code></li>
	 * 	<li><code>addAll</code></li>
	 * 	<li><code>empty</code></li>
	 * </ul>
	 * </p><p>
	 * Instead of using the methods above there are several specific methods 
	 * to insert data in the grid : 
	 * <ul>
	 * 	<li><code>setVal</code> : Use it to insert value in the grid at 
	 * 	specified coordinates</li>
	 * 	<li><code>setContent</code> : Use it to set the grid with the 
	 * 	passed-in array.</li>
	 * 	<li><code>fill</code> : Use it to fill the grid with the same value 
	 * 	in all cells.</li>
	 * </ul>
	 * </p> 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Cédric Néhémie
	 * 
	 * @see		net.pixlib.collection.PXCollection	 * @see		net.pixlib.collection.PXTypedContainer
	 */
	public class PXGrid implements PXCollection, PXTypedContainer
	{
		// --------------------------------------------------------------------
		// Protected properties
		// --------------------------------------------------------------------

		/**
		 * Size of the grid.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var vSize : PXDimension;

		/**
		 * Content of the grid in an Array structure.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var aContent : Array;

		/**
		 * Default value to use to fill grid cells.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var oDefaultValue : Object;

		/**
		 * Grid cells data type.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var cType : Class;
		

		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function get type() : Class
		{
			return cType;
		}

		/**
		 * @inheritDoc
		 */
		public function get typed() : Boolean
		{
			return cType != null;
		}

		/**
		 * @inheritDoc
		 */
		public function get empty() : Boolean
		{
			var result : Boolean = false;
			var iter : PXIterator = iterator();

			while ( iter.hasNext() )
			{
				result = ( iter.next() != oDefaultValue ) || result;
			}
			return !result;
		}

		/**
		 * @inheritDoc
		 */
		public function get length() : uint
		{
			return vSize.width * vSize.height;
		}


		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Create a new grid of passed-in <code>size</code>.
		 * <p>
		 * If <code>a</code> is set, and if it have the same size that the grid, 
		 * it's used to fill the collection at creation.
		 * </p><p>
		 * If <code>dV</code> is set, all <code>null</code> elements in the grid
		 * will be replaced by <code>dV</code> value.
		 * </p>
		 * 
		 * @param	size Size of the grid.
		 * @param	a	An array to fill the grid with.
		 * @param 	dV 	The default value for null elements.
		 * 
		 * @throws 	ArgumentError Invalid size passed in Grid constructor.
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the 
		 * 			passed-in array length
		 * 			doesn't match this grid size
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXGrid(size : PXDimension, a : Array = null, dV : Object = null, t : Class = null)
		{
			if ( size == null )
			{
				throw new ArgumentError("Invalid size in Grid constructor : " + size, this);
			}

			vSize = size;
			oDefaultValue = dV;
			cType = t;

			initContent();

			if ( a != null )
			{
				setContent(a);
			}
			else if ( oDefaultValue != null )
			{
				fill(oDefaultValue);
			}
		}

		/**
		 * Returns string representation of this object.
		 * 
		 * @return string representation of this object.
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

			return PXStringifier.process(this) + parameter + " [" + vSize.width + ", " + vSize.height + "]";
		}

		/**
		 * @inheritDoc
		 */
		public function contains(element : Object) : Boolean
		{
			isValidType(element);

			var iter : PXIterator = iterator();

			while ( iter.hasNext() )
			{
				if ( iter.next() === element )
					return true;
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function toArray() : Array
		{
			var arr : Array = [];
			var iter : PXIterator = iterator();

			while ( iter.hasNext() ) arr.push(iter.next());

			return arr;
		}

		/**
		 * @inheritDoc
		 */
		public function remove(element : Object) : Boolean
		{
			isValidType(element);

			if ( element === oDefaultValue )
				return false;

			var iter : PXIterator = iterator();

			while ( iter.hasNext() )
			{
				var obj : Object = iter.next();
				if ( obj === element )
				{
					iter.remove();
					return true;
				}
			}
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			fill(oDefaultValue);
		}

		/**
		 * @inheritDoc
		 */
		public function iterator() : PXIterator
		{
			return new GridIterator(this);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAll(collection : PXCollection) : Boolean
		{
			isValidCollection(collection);

			var result : Boolean = false;
			var iter : PXIterator = collection.iterator();
			while ( iter.hasNext() )
			{
				var obj : Object = iter.next();
				if ( obj != oDefaultValue )
					while ( contains(obj) ) result = remove(obj) || result;
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function containsAll(collection : PXCollection) : Boolean
		{
			isValidCollection(collection);

			var iter : PXIterator = collection.iterator();
			while ( iter.hasNext() ) if ( !contains(iter.next()) ) return false;
			return true;
		}

		/**
		 * The <code>addAll</code> method is unsupported by the 
		 * <code>PXGrid</code> class.
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException The 
		 * 			addAll method of the Collection interface is unsupported 
		 * 			by the Grid Class
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addAll(collection : PXCollection) : Boolean
		{
			throw new PXUnsupportedOperationException("The addAll method of " +
			"the Collection interface is unsupported by the Grid class", this);
			return false;
		}

		/**
		 * Copy the content of the passed-in grid at the specified coordinates.
		 * The passed-in grid is paste into this grid such the top-left 
		 * coordinates will start at the specified <code>Point</code> argument.
		 * 
		 * @param	p	coordinates at which copy the grid.
		 * @param	c	grid to copy in this grid object.
		 * 
		 * @return	<code>true</code> if the passed-in grid have been 
		 * 			successfully added at the specified coordinates in 
		 * 			this grid.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the 
		 * 			passed-in collection type is not the same that 
		 * 			the current one.	
		 * @throws 	net.pixlib.exceptions.IndexOutOfBoundsException If the 
		 * 			passed-in point is not valid coordinates for this grid.
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException If 
		 * 			the passed-in grid will overlap this grid when copying.
		 * 					
		 * @see		#isValidCollection() See isValidCollection for description 
		 * 			of the rules for collaboration between typed and untyped 
		 * 			collections.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function addAllAt(p : Point, grid : PXGrid) : Boolean
		{
			isValidCollection(grid);
			isGridCoords(p);
			isGridCoords(p.add(new Point(vSize.width - 1, vSize.height - 1)));

			var iter : GridIterator = grid.iterator() as GridIterator;

			while ( iter.hasNext() )
			{
				var val : * = iter.next();
				setVal(iter.add(p), val);
			}

			return true;
		}

		/**
		 * Removes the content of the passed-in grid at the specified 
		 * coordinates.
		 * The passed-in grid is removed from this grid such the top-left 
		 * coordinates will start at the specified <code>Point</code> argument.
		 * <p>
		 * The content of the passed-in grid is only removed in the bounds of 
		 * the grid in this grid space coordinates. Values which are also 
		 * stored in the passed-in grid but whose coordinates aren't in the 
		 * bounds of the operation aren't remove.
		 * </p>
		 * 
		 * @param	p	coordinates at which remove the grid.
		 * @param	c	grid to remove from this grid object.
		 * 
		 * @return	<code>true</code> if the passed-in grid have been 
		 * 			successfully removed at the specified coordinates in 
		 * 			this grid.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the 
		 * 			passed-in collection type is not the same that the 
		 * 			current one.	
		 * @throws	net.pixlib.exceptions.PXIndexOutOfBoundsException If the 
		 * 			passed-in point is not valid coordinates for this grid.
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException If the 
		 * 			passed-in grid will overlap this grid when removing.
		 * 					
		 * @see		#isValidCollection() See isValidCollection for description 
		 * 			of the rules for collaboration between typed and 
		 * 			untyped collections.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAllAt(p : Point, grid : PXGrid) : Boolean
		{
			isValidCollection(grid);
			isGridCoords(p);
			isGridCoords(p.add(new Point(vSize.width - 1, vSize.height - 1)));

			var result : Boolean = false;
			var iter : GridIterator = grid.iterator() as GridIterator;

			while ( iter.hasNext() )
			{
				iter.next();
				removeAt(iter.add(p));
			}
			return result;
		}

		/**
		 * Retains only the elements in this queue that are contained
		 * in the specified collection (optional operation). In other words,
		 * removes from this queue all of its elements that are not
		 * contained in the specified collection.
		 * <p>
		 * The only values which cannot be removed by a call to 
		 * <code>retainAll</code> is the default value for this grid. 
		 * It result that all cells which contained
		 * a value that are not contained in the passed-in collection are 
		 * filled with the grid's default value.
		 * </p><p>
		 * The rules which govern collaboration between typed and untyped 
		 * <code>PXCollection</code> are described in the 
		 * <code>isValidCollection</code> descrition, all rules described
		 * there are supported by the <code>retainAll</code> method.
		 * </p>
		 * 
		 * @param 	c 	elements to be retained in this collection.
		 * 
		 * @return 	<code>true</code> if this collection changed as a result 
		 * 			of the call.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException If the 
		 * 			passed-in collection type is not the same that the 
		 * 			current one.	
		 * @see		#isValidCollection() See isValidCollection for description 
		 * 			of the rules for collaboration between typed and untyped 
		 * 			collections.
		 * 
		 * @see 	#remove(Object)
		 * @see 	#contains(Object)
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function retainAll(collection : PXCollection) : Boolean
		{
			isValidCollection(collection);

			var result : Boolean = false;
			var iter : PXIterator = iterator();

			while ( iter.hasNext() )
			{
				var obj : Object = iter.next();
				if ( obj != oDefaultValue && !(collection.contains(obj)) ) result = remove(obj) || result;
			}
			return result;
		}

		/**
		 * The <code>add</code> method is unsupported by the <code>PXGrid</code> 
		 * class.
		 * 
		 * @throws 	net.pixlib.exceptions.PXUnsupportedOperationException The 
		 * 			add method of the PXCollection interface is unsupported by 
		 * 			the PXGrid Class
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add(element : Object) : Boolean
		{
			throw new PXUnsupportedOperationException("The add method of the Collection interface is unsupported by the Grid class", this);
			return false;
		}

		/**
		 * Verify if the passed-in object can be inserted in the
		 * current <code>Grid</code>.
		 * 
		 * @param	o	Object to verify
		 * @return 	<code>true</code> if the object can be inserted in
		 * the <code>PXGrid</code>, either <code>false</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function matchType(element : *) : Boolean
		{
			return ( element is cType || element == null );
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
		 * @param	c <code>PXCollection</code> to verify
		 * 
		 * @return 	boolean <code>true</code> if the collection is valid, 
		 * 			either <code>false</code>
		 * 			 			
		 * @throws	net.pixlib.exceptions.PXNullPointerException If the 
		 * 			passed-in collection
		 * 			is <code>null</code>
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — If the 
		 * 			passed-in collection type is not the same that the 
		 * 			current one
		 * 			
		 * @see		#addAll() addAll()
		 * @see		#removeAll() removeAll()
		 * @see		#retainAll() retainAll()
		 * @see		#containsAll() containsAll()
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isValidCollection(collection : PXCollection) : Boolean
		{
			if ( collection == null )
			{
				throw new PXNullPointerException("The passed-in collection is null in " + this, this);
			}
			else if ( type != null )
			{
				if ( collection is PXTypedContainer && ( collection as PXTypedContainer ).type != type )
				{
					throw new PXIllegalArgumentException("The passed-in collection is not of the same type than " + toString(), this);
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
		 * <code>PXGrid</code> element's type. 
		 * <p>
		 * In the case that the grid is untyped the function
		 * will always returns <code>true</code>.
		 * </p>
		 * 
		 * @param	o <code>Object</code> to verify
		 * @return  <code>true</code> if the object is elligible for this
		 * 			grid object, either <code>false</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isValidType(element : Object) : Boolean
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
				return true ;
		}

		/**
		 * Creates the internal two dimensional array used to store
		 * data of the grid.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function initContent() : void
		{
			aContent = new Array(vSize.width);
			for ( var x : Number = 0;x < vSize.width;x++ )
				aContent[ x ] = new Array(vSize.height);
		}

		/**
		 * Fill the current grid with the passed-in value.
		 * <p>
		 * If the passed-in value is a "real" object (not a primitive) then
		 * all cells contains a reference to the same object.
		 * </p>
		 * @param	o	Value used to fill the grid
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function fill(element : Object) : void
		{
			isValidType(element);

			var iter : PXIterator = iterator();

			while ( iter.hasNext() )
			{
				iter.next();

				setVal(iter as GridIterator, element);
			}
		}

		/**
		 * Removes the value located at the passed-in coordinate.
		 * <p>
		 * If the grid changed after the call the function returns
		 * <code>true</code>. If the passed-in <code>Point</code> isn't
		 * a valid coordinate for this grid the function failed and return
		 * <code>false</code>.
		 * </p><p>
		 * If a default value is set, the cell contains that value instead
		 * of <code>null</code> after the call.
		 * </p>
		 * @param	p	<code>Point</code> position of the value to remove
		 * 
		 * @return 	<code>true</code> if the grid changed as result of the call
		 * 
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException The 
		 * 			passed-in point is not a valid coordinates for this grid.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function removeAt(coords : Point) : Boolean
		{
			return setVal(coords, oDefaultValue);
		}

		/**
		 * Check if a <code>Point</code> object is a valid coordinate
		 * in the current grid.
		 * 
		 * @param	p	<code>Point</code> object to check.
		 * 
		 * @return 	<code>true</code> if passed-in <code>Point</code> is 
		 * 			a valid coordinate for the current grid.
		 * 			
		 * @throws 	<code>PXIndexOutOfBoundsException</code> — the passed-in 
		 * 			point is not a valid coordinates for this grid.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isGridCoords(coords : Point) : Boolean
		{
			if ( !( coords.x >= 0 && coords.x < vSize.width && coords.y >= 0 && coords.y < vSize.height ) )
				throw new PXIndexOutOfBoundsException(coords + " is not a valid grid coordinates for " + this, this);

			return true;
		}

		/**
		 * Returns the size of the grid as <code>PXDimension</code>.
		 * <p>
		 * The returned <code>Dimension</code> is a clone of the
		 * internal one.
		 * </p>
		 * @return 	the dimensions of the grid as <code>PXDimension</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getSize() : PXDimension
		{
			return vSize.clone();
		}

		/**
		 * Returns a <code>Point</code> witch is the corresponding
		 * position of the passed-in value.
		 * 
		 * @param 	id	<code>uint</code> to convert in a two 
		 * 				dimension location.
		 * 
		 * @return 	<code>Point</code> corresponding location.
		 * 
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException The 
		 * 			passed-in  index is not a valid coordinates for this grid.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getCoordinates(id : uint) : Point
		{
			var row : Number = id % vSize.width;
			var col : Number = (id - row) / vSize.width;
			var point : Point = new Point(row, col);

			isGridCoords(point);

			return point;
		}

		/**
		 * Returns the current default value of this grid used
		 * to replace value when removing an element.
		 * 
		 * @return	element used as default value for the grid's cells
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getDefaulValue() : Object
		{
			return oDefaultValue;
		}

		/**
		 * Defines the default value for this grid's cells content. 
		 * When changing the default value of a grid, the cells which
		 * previously contains the old default value will contains the
		 * new one at the end of the call.
		 * 
		 * @param	o	new default value for this grid's cells
		 * @return	<code>true</code> if the grid have change as result
		 * 			of the call
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setDefaultValue(value : Object) : Boolean
		{
			isValidType(value);

			var oldDV : Object = oDefaultValue;
			oDefaultValue = value;

			return removeAll(new PXWeakCollection([oldDV]));
		}

		/**
		 * Returns the element stored at the passed-in coordinate of the
		 * grid.
		 * 
		 * @param 	p	Coordinates <code>Point</code> in the grid.
		 * 
		 * @return  Value stored at the coorespoding location or <code>null</code>
		 * 			if the passed-in coordinates is not a valid coordinates
		 * 			for this grid.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException The 
		 * 			passed-in point is not a valid coordinates for this grid.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getVal(coords : Point) : Object
		{
			isGridCoords(coords);

			return aContent[ coords.x ][ coords.y ];
		}

		/**
		 * Defines value of grid cell defining by passed-in <code>Point</code> 
		 * coordinate.
		 * <p>
		 * The call return <code>true</code> only if the <code>PXGrid</code>
		 * changed as results of the call.
		 * </p> 
		 * 
		 * @param 	p	<code>Point</code> position of the cell.
		 * @param 	o	value to store in the grid.
		 * 
		 * @return  <code>true</code> if the <code>PXGrid</code> changed as 
		 * 			results of the call.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIndexOutOfBoundsException The 
		 * 			passed-in point is not a valid coordinates for this grid.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function setVal(coords : Point, o : Object) : Boolean
		{
			isValidType(o);
			isGridCoords(coords);

			if ( o === aContent[ coords.x ][ coords.y ])
			{
				return false;
			}

			if ( o == null && oDefaultValue != null )
				o = oDefaultValue;


			aContent[ coords.x ][ coords.y ] = o;
			return true;
		}

		/**
		 * Fill the content with an array of witch length is equal to
		 * the grid <code>size()</code>.
		 * <p>
		 * The call return <code>true</code> only if the <code>PXGrid</code>
		 * changed as results of the call.
		 * </p>
		 * 
		 * @param 	a	<code>Array</code> to fill the <code>PXGrid</code>.
		 * 
		 * @return 	<code>true</code> if the <code>PXGrid</code> changed as 
		 * 			results of the call.
		 * 			
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException  If the 
		 * 			passed-in array length doesn't match this grid size.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function setContent(content : Array) : Boolean
		{
			if ( content.length != length )
			{
				throw new PXIllegalArgumentException("Passed-in array of length " + content.length + " doesn't match " + this + ".size() : " + length, this);
				return false;
			}

			var len : Number = content.length;
			var result : Boolean = false;
			while (--len - (-1))
			{
				var point : Point = getCoordinates(len);
				result = setVal(point, content[ len ]) || result;
			}

			return true;
		}
	}
}

import net.pixlib.collections.PXIterator;
import net.pixlib.exceptions.PXIllegalStateException;
import net.pixlib.exceptions.PXNoSuchElementException;
import net.pixlib.structures.PXGrid;

import flash.geom.Point;

internal class GridIterator extends Point implements PXIterator
{

	private var _nIndex : Number;

	private var _nLength : Number;

	private var _oGrid : PXGrid;

	private var _bRemoved : Boolean;


	public function GridIterator(grid : PXGrid)
	{
		_oGrid = grid;
		_nIndex = -1;
		_nLength = _oGrid.length;
		_bRemoved = false;
	}

	public function hasNext() : Boolean
	{
		return ( _nIndex + 1 ) < _nLength;
	}

	public function next() : *
	{
		if ( !hasNext() )
			throw new PXNoSuchElementException(this + " has no more elements at " + ( _nIndex ), this);

		var point : Point = _oGrid.getCoordinates(++_nIndex);
		x = point.x;
		y = point.y;
		_bRemoved = false;
		return _oGrid.getVal(this);
	}

	public function remove() : void
	{
		if ( !_bRemoved )
		{
			_oGrid.removeAt(this);
			_bRemoved = true;
		}
		else
		{
			throw new PXIllegalStateException(this + ".remove() have been already called for this iteration", this);
		}
	}
}