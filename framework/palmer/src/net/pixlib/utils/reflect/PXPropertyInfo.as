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
	 * Properties class informations.
	 * 
	 * @see PXClassInfo
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXPropertyInfo extends PXElementInfo
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _bConst : Boolean;

		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/** Returns <code>true</code> if property is a <code>constant</code>. */
		public function get constantFlag( ) : Boolean 
		{	
			return _bConst; 
		}

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param	eDesc		XML Node description
		 * @param	eStatic		Property is static		 * @param	eConstant	Property is a constant
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public function PXPropertyInfo( eDesc : XML, eStatic : Boolean = false, eConstant : Boolean = false )
		{
			super(eDesc, eDesc.@name, eDesc.@type, eStatic);
			
			_bConst = eConstant;
		}

		/** 
		 * @inheritDoc
		 */
		override public function toString( ) : String
		{
			return ( ( staticFlag ) ? "static " : "" ) + ( ( _bConst ) ? "const " : "var " ) + name + " : " + type;
		}
	}
}
