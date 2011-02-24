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
	import net.pixlib.log.PXStringifier;

	import flash.geom.Point;

	/**
	 * The PXDimension class encapsulates the width and height
	 * of an object (in double precision) in a single object.
	 * <p>
	 * Normally the values of width and height are non-negative
	 * integers. The constructors that allow you to create
	 * a dimension do not prevent you from setting a negative
	 * value for these properties. If the value of width or height
	 * is negative, the behavior of some methods defined by other
	 * objects is undefined. 
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Cédric Néhémie
	 */
	public class PXDimension 
	{
		/**
		 * The width dimension, negative values can be used.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var width : Number;

		/**
		 * The height dimension, negative values can be used.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public var height : Number;

		
		/**
		 * Creates new instance. 
		 * 
		 * @param	width	specified width
		 * @param	height	specified height
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXDimension( width : Number = 0, height : Number = 0 )
		{
			this.width = width;
			this.height = height;
		}

		/**
		 * Checks whether two dimension objects have equal values.
		 * 
		 * @param	dimension	the reference object with which to compare.
		 * 
		 * @return	<code>true</code> if this object is the same as the obj
		 * 			argument, <code>false</code> otherwise.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function equals( dimension : PXDimension ) : Boolean
		{
			return (width == dimension.width && height == dimension.height );
		}

		/**
		 * Sets the size of this PXDimension object to the specified size.
		 * 
		 * @param	dimension	the new size for this PXDimension object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setSize( dimension : PXDimension ) : void
		{
			if(dimension != null)
			{
				width = dimension.width;
				height = dimension.height;
			}
		}

		/**
		 * Sets the size of this PXDimension object to the specified 
		 * width and height.
		 * 
		 * @param	width	the new width for this PXDimension object
		 * @param	height	the new height for this PXDimension object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function setSizeWH( width : Number, height : Number ) : void
		{
			if(!isNaN(width)) this.width = width;
			if(!isNaN(height)) this.height = height;
		}

		/**
		 * Returns a copy of this PXDimension object.
		 * 
		 * @return	a copy of this PXDimension object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function clone() : PXDimension
		{
			return new PXDimension(width, height);
		}

		/**
		 * Scales dimension using passed-in <code>n</code> factor and returns 
		 * new PXDimension instance.
		 * 
		 * @param	factor	Scale factor
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function scale( factor : Number ) : PXDimension
		{
			if(!isNaN(factor))
			{
				return new PXDimension(width * factor, height * factor);
			}
			else return clone();
		}

		/**
		 * Substracts passed-in <code>size</code> dimension from 
		 * current instance size and return new PXDimension instance.
		 * 
		 * @param	size	PXDimension to substract
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function substract( dimension : PXDimension ) : PXDimension
		{
			if(dimension != null)
			{
				return new PXDimension(width - dimension.width, height - dimension.height);
			}
			else return clone();
		}

		/**
		 * Adds passed-in <code>size</code> dimension to 
		 * current instance size and returns new PXDimension instance.
		 * 
		 * @param	size	PXDimension to add
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function add( dimension : PXDimension ) : PXDimension
		{
			if(dimension != null)
			{
				return new PXDimension(width + dimension.width, height + dimension.height);
			}
			else return clone();
		}

		/**
		 * Returns a Point object with its x and y sets
		 * respectively on width and height of this 
		 * Dimension.
		 * 
		 * @return	a Point object which contains values
		 * 			of this PXDimension
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toPoint() : Point
		{
			return new Point(width, height);
		}
		
		/**
		 * Returns the String representation of this object.
		 * 
		 * @return	the String representation of this object
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String 
		{
			return PXStringifier.process(this) + "[" + width + ", " + height + "]";
		}	
	}
}
