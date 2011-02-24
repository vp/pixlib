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

package net.pixlib.utils 
{
	import net.pixlib.collections.PXIterator;
	import net.pixlib.collections.PXSet;
	import net.pixlib.exceptions.PXNoSuchElementException;
	import net.pixlib.log.PXDebug;

	import flash.utils.getQualifiedClassName;

	/**
	 * Overloads a method.
	 * 
	 * <p>With overloading you have typically two or more methods with the 
	 * same name but with different arguments signatures.<br />
	 * ActionScript 3.0 does not support overloading, that's why 
	 * <code>PXOverloader</code> class provides system to simulate overloading 
	 * process easily.</p>
	 * 
	 * @example
	 * <listing>
	 * 
	 * public function testMe( ...rest ) : void
	 * {
	 * 	var obj : PXOverloader = new PXOverloader();
	 * 	obj.addOverloading( [ String, int ], _doByStringAndNumber );
	 * 	obj.addOverloading( [ String, String ], _doByStringAndString );
	 * 	obj.overload(rest);
	 * }
	 * </listing>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXOverloader 
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 * 
		 */
		private var _oSet : PXSet;
		
		/**
		 * @private
		 * 
		 */
		private var _oDefaultHandler : Function;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Specifies default overloading method to use if 
		 * arguments sequence overloading is not find.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function get defaultOverloading( ) : Function
		{
			return _oDefaultHandler;		
		}

		/** @private */
		public function set defaultOverloading( value : Function ) : void
		{
			_oDefaultHandler = value;
		}

		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function PXOverloader()
		{
			_oSet = new PXSet(Overloading);
		}

		/**
		 * Adds overloading definition.
		 * 
		 * @example
		 * <listing>
		 * 
		 * var obj : PXOverloader = new PXOverloader();
		 * obj.addOverloading( [ String, int ], _doByStringAndNumber );
		 * obj.addOverloading( [ String, String ], _doByStringAndString );
		 * </listing>
		 * 
		 * @param	types		sequence types
		 * @param	handler		handler to trigger
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 		 */
		public function addOverloading( types : Array, handler : Function) : void
		{
			_oSet.add(new Overloading(types, handler));
		}

		/**
		 * Overloads method.
		 * 
		 * @example
		 * <listing>
		 * 
		 * var obj : PXOverloader = new PXOverloader();
		 * obj.addOverloading( [ String, int ], _doByStringAndNumber );
		 * obj.addOverloading( [ String, String ], _doByStringAndString );
		 * obj.overload(arguments);
		 * </listing>
		 * 
		 * @param	argSequence	arguments sequence to check
		 * 
		 * @return	overloaded method result
		 * 
		 * @throws	<code>NoSuchElementException</code> - No overloading 
		 * 			definition is found for passed-in arguments sequence
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function overload(arguments : Array) : *
		{
			var length : int = arguments.length;
			var iter : PXIterator = _oSet.iterator();
			
			while( iter.hasNext() )
			{
				var obj : Overloading = iter.next() as Overloading;
				
				if( obj.length == length )
				{
					if( obj.matches(arguments) )
					{
						return obj.handler.apply(null, arguments);
					}
				}
			}
			
			var arr : Array = new Array();
			for( var i : int = 0;i < length ;i++ ) arr.push(getQualifiedClassName(arguments[i]));	
			
			if( _oDefaultHandler != null )
			{
				PXDebug.DEBUG("Use default overloading for [" + arr + "]", this);
				
				return _oDefaultHandler.apply(null, arguments);
			}
			else
			{
				throw new PXNoSuchElementException("No overloading found for current arguments list [" + arr + "]", this);
			}
			
			return null;
		}
	}
}

import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

/**
 * @private
 * 
 * Overloading definition structure.
 * 
 * @author Romain Ecarnot
 */
internal class Overloading
{
	//--------------------------------------------------------------------
	// Private properties
	//--------------------------------------------------------------------

	private var _aTypes : Array;
	private var _nLength : int;	private var _fHandler : Function;
	
	//--------------------------------------------------------------------
	// Public properties
	//--------------------------------------------------------------------
	
	/** Type sequence length. */
	public function get length( ) : int 
	{ 
		return _nLength; 
	}

	/** Handler to trigger. */	public function get handler( ) : Function 
	{ 
		return _fHandler; 
	}

	
	//--------------------------------------------------------------------
	// Public API
	//--------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param	types	data types sequence
	 * @param	handler	handler to trigger when overloading 
	 * 					definition is found.
	 */	
	public function Overloading( types : Array, handler : Function )
	{
		_aTypes = types.slice(0);
		_nLength = _aTypes.length;
		_fHandler = handler;
	}

	/**
	 * Returns <code>true</code> if passed-in <code>argSequence</code> has 
	 * correct data type according type sequence defined in constructor.
	 * 
	 * @param	args	arguments collection
	 */
	public function matches( args : Array ) : Boolean
	{
		var length : int = args.length;
		
		for( var i : int = 0;i < length ;i++ )
		{
			var obj : * = args[ i ];
			
			if( obj != null )
			{
				var clazz : Class = _aTypes[ i ];
				
				if( 
					!_isImplementationOf(obj, clazz) && !_isSubclassOf(obj, clazz) && ( getQualifiedClassName(obj) != getQualifiedClassName(clazz) )
				) return false;
			}
		}
		
		return true;
	}

	
	//--------------------------------------------------------------------
	// Private implementation
	//--------------------------------------------------------------------

	private function _isImplementationOf( arg : *, type : Class ) : Boolean
	{
		return describeType(arg).implementsInterface.(@type == getQualifiedClassName(type) ).length() > 0;
	}

	private function _isSubclassOf( arg : *, type : Class ) : Boolean
	{
		return describeType(arg).extendsClass.(@type == getQualifiedClassName(type) ).length() > 0;
	}	
}
