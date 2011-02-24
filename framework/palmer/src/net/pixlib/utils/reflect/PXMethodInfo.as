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
	 * Methods class informations.
	 * 
	 * @see PXClassInfo
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * 
	 * @author Romain Ecarnot
	 */
	final public class PXMethodInfo extends PXElementInfo
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private var _aParameterList : Array;		
		
		//--------------------------------------------------------------------
		// Public properties
		//--------------------------------------------------------------------
		
		/**
		 * Returns method parameters list.
		 * 
		 * @see fever.utils.reflect.ParameterInfo
		 * 
		 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
		 */
		public function get parameters( ) : Array { return _aParameterList; }
				
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Constructor.
		 * 
		 * @param	eDesc	XML Node description
		 * @param	eStatic	Method is static
		 * 
		 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
		 */
		public function PXMethodInfo( eDesc : XML, eStatic : Boolean = false )
		{
			super( eDesc, _getName( eDesc ), _getType( eDesc ), eStatic, eDesc.@declaredBy );
			
			_buildParameters();		}
		
		/** 
		 * @inheritDoc
		 */
		override public function toString() : String
		{
			return ( ( staticFlag ) ? "static " : "" ) + name + " ( " + _stringifyParamters() + " ) : " + type;
		}
		
		
		//--------------------------------------------------------------------
		// Private implementations
		//--------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function _getName( eDesc : XML ) : String
		{
			return ( eDesc.@name != undefined ) 
				? eDesc.@name 
				: "constructor";
		}
		
		/**
		 * @private
		 */
		private function _getType( eDesc : XML ) : String
		{
			return ( eDesc.@returnType != undefined ) 
				? eDesc.@returnType 
				: "";
		}
		
		/**
		 * @private
		 */
		private function _buildParameters() : void
		{
			var xmlList : XMLList = description.parameter;
			
			_aParameterList = new Array();
			
			if( xmlList.length() > 0 )
			{
				for each( var node : XML in xmlList )
				{
					_aParameterList.push( new PXParameterInfo( node ) );
				}
			}
		}
		
		/**
		 * @private
		 */
		private function _stringifyParamters() : String
		{
			var length : int = _aParameterList.length;
			var src : String = "";
			
			for( var i : int = 0; i < length; i ++ )
			{
				src += _aParameterList[ i ].toString();
				if( i + 1 < length ) src+= ", ";
			}
			
			return src;
		}
	}
}
