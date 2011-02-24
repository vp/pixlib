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
package net.pixlib.utils.reflect 
{
	/**
	 * Accessor ( getter / setter ) class informations.
	 * 
	 * @see ClassInfo
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXAccessorInfo extends PXElementInfo
	{
		//--------------------------------------------------------------------
		// Constants
		//--------------------------------------------------------------------
		
		/** Read only accessor. */
		public static const READONLY : String = "readonly";	

		/** Read / Write accessor. */
		public static const READWRITE : String = "readwrite";	

		/** Write only accessor. */
		public static const WRITEONLY : String = "writeonly";

		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------

		private var _access : String;
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns accessor access type.
		 * 
		 * <p>Access can be :
		 * <ul>
		 *   <li>Read only</li>
		 *   <li>Read and write</li>		 *   <li>Write only</li>
		 * </ul></p>
		 * 
		 * @see #READONLY		 * @see #READWRITE		 * @see #WRITEONLY
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function get access( ) : String 
		{ 
			return _access; 
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param	eDesc	XML Node description
		 * @param	eStatic	Accessor is static
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function PXAccessorInfo( description : XML, staticFlag : Boolean = false )
		{
			super(description, description.@name, description.@type, staticFlag, description.@declaredBy);
			
			_access = description.@access;
		}

		/**
		 * Returns string representation.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		override public function toString( ) : String
		{
			var result : String = "";
			
			if( _access != WRITEONLY )
				result += ( ( staticFlag ) ? "static get " : "get " ) + name + "( ) : " + type + PXClassInfo.LINEBREAK + PXClassInfo.TAB; 
			
			if( !_access != READONLY )
				result += ( ( staticFlag ) ? "static set " : "set " ) + name + "( arg : " + type + " ) : void"; 
			
			return result;
		}
	}
}
