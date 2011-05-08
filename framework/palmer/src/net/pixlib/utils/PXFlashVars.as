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
	import net.pixlib.core.PXCoreFactory;
	import net.pixlib.core.PXLocator;
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.log.PXStringifier;

	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	import flash.utils.getDefinitionByName;
	
	/**
	 * The PXFlashVars class stores flashvars in basic Dictionary structure.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	final dynamic public class PXFlashVars extends Proxy implements PXLocator
	{
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		private static  var _oI : PXFlashVars ;
		
		private var _keys : Vector.<String>;		
		
		
		//--------------------------------------------------------------------
		// Public Properties
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function get keys() : Array
		{
			var keys : Array = new Array();
			
			for each (var key : String in _keys) 
			{
				if( PXCoreFactory.getInstance().isRegistered(key))
				{
					keys.push(key);
				}
			}
			
			return keys;
		}

		/**
		 * @inheritDoc
		 */
		public function get values() : Array
		{
			var values : Array = new Array();
			
			for each (var key : String in _keys) 
			{
				if( PXCoreFactory.getInstance().isRegistered(key))
				{
					values.push(PXCoreFactory.getInstance().locate(key));
				}
			}
			
			return values;
		}
		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
		
		/**
		 * Returns singleton instance of <code>PXFlashVars</code> class.
		 * 
		 * @return The singleton instance of <code>PXFlashVars</code> class.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */	
		public static function getInstance() : PXFlashVars
		{
			if ( !(PXFlashVars._oI is PXFlashVars) ) 
				PXFlashVars._oI = new PXFlashVars();
				
			return PXFlashVars._oI;
		}

		/**
		 * Releases singleton instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function release() : void
		{
			if ( PXFlashVars._oI is PXFlashVars ) PXFlashVars._oI = null;
		}

		/**
		 * Returns <code>true</code> is there is a ressource associated
		 * with the passed-in <code>key</code> in this config. <br />
		 * To avoid errors when retreiving ressources from a locator 
		 * you should systematically use the <code>isRegistered</code> 
		 * function to check if the ressource you would access is 
		 * already accessible before any call to the <code>locate</code> 
		 * function.
		 * 
		 * @return 	<code>true</code> is there is a ressource associated
		 * 			with the passed-in <code>key</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function isRegistered( key : String ) : Boolean
		{
			return PXCoreFactory.getInstance().isRegistered(key);
		}

		/**
		 * Registers passed-in value with key identifier.
		 * 
		 * @param key	Identifier
		 * @param value	Value to register
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function register( key : String, value : * ) : void
		{
			if( PXCoreFactory.getInstance().isRegistered(key) )
			{
				PXCoreFactory.getInstance().unregister(key);
			}
			
			PXCoreFactory.getInstance().register(key, value);
		}

		/**
		 * Returns the ressource associated with the passed-in <code>key</code>.
		 * If there is no ressource identified by the passed-in key, the
		 * function will return <code>null</code>.
		 * 
		 * @param	key	identifier of the ressource to access
		 * @return	the ressource associated with the passed-in <code>key</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function locate( key : String ) : Object
		{
			if( isRegistered(key) )
			{
				return PXCoreFactory.getInstance().locate(key);	
			}
			else return null;
		}

		/**
		 * @inheritDoc
		 */
		public function add(dico : Dictionary) : void
		{
			for ( var key : * in dico ) 
			{
				try
				{
					register(key, dico[ key ]);
				} 
				catch ( e : PXIllegalArgumentException )
				{
					throw new PXIllegalArgumentException(".add() fails. " + e.message, this);
				}
			}
		}

		/**
		 * Returns Flashvar value registred with passed-in 
		 * <code>key</code> identifier as <strong>Boolean</strong>.
		 * 
		 * @param key Flashvar key to search
		 * @param defaultValue Value to return if Flashvar is not defined
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getBoolean( key : String, defaultValue : Boolean = false ) : Boolean
		{
			var obj : * = locate(key);
			
			if( obj != null )
			{
				if( obj is Boolean ) return obj as Boolean;
				else return new Boolean(obj == "true" || !isNaN(Number(obj)) && Number(obj) != 0);
			}
			else return defaultValue;
		}

		/**
		 * Returns resource value registred with passed-in 
		 * <code>key</code> identifier as <strong>Number</strong>.
		 * 
		 * @param key Flashvar key to search
		 * @param defaultValue Value to return if Flashvar is not defined
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getNumber( key : String, defaultValue : Number = NaN ) : Number
		{
			var obj : * = locate(key);
			
			if( obj != null )
			{
				if( obj is Number ) return obj as Number;
				else return Number(obj);
			}
			else return defaultValue;
		}

		/**
		 * Returns Flashvar value registred with passed-in 
		 * <code>key</code> identifier as <strong>String</strong>.
		 * 
		 * @param key Flashvar key to search
		 * @param defaultValue Value to return if Flashvar is not defined
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getString( key : String, defaultValue : String = null ) : String
		{
			var obj : * = locate(key);
			
			if( obj != null ) return obj.toString();
			else return defaultValue;
		}

		/**
		 * Returns Flashvar value registred with passed-in 
		 * <code>key</code> identifier as <strong>Array</strong>.
		 * 
		 * @param key Flashvar key to search
		 * @param defaultValue Value to return if Flashvar is not defined
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getArray( key : String, defaultValue : Array = null ) : Array
		{
			var obj : * = locate(key);
			
			if( obj != null )
			{
				var arr : Array = obj is Array ? obj as Array : new Array(obj);
				return arr;	
			}
			else return defaultValue;
		}

		/**
		 * Returns Flashvar value registred with passed-in 
		 * <code>key</code> identifier as <strong>Class</strong>.
		 * 
		 * @param key Flashvar key to search
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function getClass( key : String ) : Class
		{
			var obj : * = locate(key);
			
			if( obj != null ) return getDefinitionByName(obj.toString()) as Class;
			else return null;
		}

		/**
		 * Returns string representation of instance.
		 * 
		 * @return The string representation of instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function toString() : String
		{
			return PXStringifier.process(this);
		}

		
		//--------------------------------------------------------------------
		// Protected methods
		//--------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override flash_proxy function getProperty( name : * ) : * 
		{
			return locate(name);
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function setProperty(name : *, value : *) : void 
		{
			register(name, value);
		}	

		/**
		 * @inheritDoc
		 */
		override flash_proxy function hasProperty(name : *) : Boolean
		{
			return isRegistered(name);
		}

		/**
		 * @inheritDoc
		 */
		override flash_proxy function deleteProperty(name : *) : Boolean
		{
			return PXCoreFactory.getInstance().unregister(name);
		}

		
		//--------------------------------------------------------------------
		// Private implementation
		//--------------------------------------------------------------------
			
		/**
		 * @private
		 */
		function PXFlashVars()
		{
			_keys = new Vector.<String>();
		}
	}
}