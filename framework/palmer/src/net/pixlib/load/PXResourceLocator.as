/* * Copyright the original author or authors. *  * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License"); * you may not use this file except in compliance with the License. * You may obtain a copy of the License at *  *      http://www.mozilla.org/MPL/MPL-1.1.html *  * Unless required by applicable law or agreed to in writing, software * distributed under the License is distributed on an "AS IS" BASIS, * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. * See the License for the specific language governing permissions and * limitations under the License. */
package net.pixlib.load{	import net.pixlib.collections.PXHashMap;	import net.pixlib.core.PXCoreFactory;	import net.pixlib.core.PXLocator;	import net.pixlib.core.pixlib_internal;	import net.pixlib.display.css.PXCSS;	import net.pixlib.exceptions.PXNoSuchElementException;	import net.pixlib.log.PXDebug;	import net.pixlib.log.PXStringifier;	import flash.display.DisplayObject;	import flash.display.Shader;	import flash.utils.Dictionary;	
	/**	 * The PXResourceLocator locator class.	 * 	 * @langversion 3.0	 * @playerversion Flash 10	 * 	 * @author Romain Ecarnot	 */
	final public class PXResourceLocator implements PXLocator
	{
		// --------------------------------------------------------------------
		// Private properties
		// --------------------------------------------------------------------		
		/** @private */
		private static const DEFAULT_NAME : String = "DefaultResourceLocator";

		/** @private */
		private static const _M : PXHashMap = new PXHashMap();

		/** @private */
		private var _sName : String;

		/** @private */
		private var _keyList : Array;				
		// --------------------------------------------------------------------
		// Public properties
		// --------------------------------------------------------------------		
		/**		 * Returns locator identifier.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function get name() : String
		{
			return _sName;
		}
				/**		 * @inheritDoc		 */		public function get keys() : Array		{			return _keyList;		}		/**		 * @inheritDoc		 */		public function get values() : Array		{			var values : Array = [];			var len : uint = _keyList.length;			for (var i : uint = 0;i < len;i++)			{				if (PXCoreFactory.getInstance().isRegistered(_keyList[i]))				{					values.push(PXCoreFactory.getInstance().locate(_keyList[i]));				}			}			return values;		}		
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------
		/**		 * Returns instance of <code>PXResourceLocator</code> object using 		 * name reference.		 * 		 * <p>If name is <code>null</code>, returns default PXResourceLocator instance.</p>		 * 		 * @param name PXResourceLocator identifier		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function getInstance(key : String = null) : PXResourceLocator
		{
			if ( key == null || key.length < 1 ) key = DEFAULT_NAME;
			if (!_M.containsKey(key)) _M.put(key, new PXResourceLocator(key));
			return _M.get(key);
		}

		/**		 * Releases instance.		 * 		 * @param name Identifier of PXResourceLocator to release.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public static function release(key : String = null) : Boolean
		{
			if ( key == null || key.length < 1 ) key = DEFAULT_NAME;
			if (_M.containsKey(key))
			{
				getInstance(key).clear();
				_M.remove(key);
				return true;
			}
			return false;
		}

		/**		 * Registers passed-in element into locator using key parameter.		 * 		 * @param key		Element's identifier for registration in locator		 * @param element	Element to register in locator		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function register(key : String, element : Object) : Boolean
		{
			var keyName : String = pixlib_internal::buildResourceID(name, key);
			if (!PXCoreFactory.getInstance().isRegistered(keyName))
			{
				if (PXCoreFactory.getInstance().register(keyName, element))
				{
					_keyList.push(keyName);
					return true;
				}
			}
			else
			{
				PXDebug.ERROR(" element is already registered with '" + key + "' name in " + this, this);
			}
			return false;
		}

		/**		 * Unregisters element registered using passed-in key identifier		 * 		 * @param key	Element's identifier to remove from locator		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function unregister(key : String) : Boolean
		{
			var keyName : String = pixlib_internal::buildResourceID(name, key);
			if (PXCoreFactory.getInstance().unregister(keyName))			{				pixlib_internal::remove(keyName, _keyList);
				return true;
			}
			return false;
		}
		
		/**		 * Returns registered element in locator using key identifier.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function locate(key : String) : Object
		{
			var keyName : String = pixlib_internal::buildResourceID(name, key);
			if ( PXCoreFactory.getInstance().isRegistered(keyName) )
			{
				return PXCoreFactory.getInstance().locate(keyName);
			}
			else
			{
				throw new PXNoSuchElementException("Can't find item with '" + key + "' name in '" + name + "' ResourceLocator.", this);
			}
		}

		/**		 * Returns the PXCSS associated with the passed-in <code>key</code>.		 * 		 * <p>If there is no ressource identified by the passed-in key, the		 * function will return <code>null</code>.</p>		 * 		 * @param	key	identifier of the ressource to access		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function locateCSS(key : String) : PXCSS
		{
			try
			{
				return locate(key) as PXCSS;
			}
			catch(e : Error)
			{
				PXDebug.ERROR(this + ".locateCSS(" + key + ") failed." + e.message, this);
			}
			return null;
		}

		/**		 * Returns the Shader associated with the passed-in <code>key</code>.		 * 		 * <p>If there is no ressource identified by the passed-in key, the		 * function will return <code>null</code>.</p>		 * 		 * @param	key	identifier of the ressource to access		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function locateShader(key : String) : Shader
		{
			try
			{
				return locate(key) as Shader;
			}
			catch(e : Error)
			{
				PXDebug.ERROR(".locateShader(" + key + ") failed." + e.message, this);
			}
			return null;
		}

		/**		 * Returns the XML associated with the passed-in <code>key</code>.		 * 		 * <p>If there is no ressource identified by the passed-in key, the		 * function will return <code>null</code>.</p>		 * 		 * @param	key	identifier of the ressource to access		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function locateXML(key : String) : XML
		{
			try
			{
				return locate(key) as XML;
			}
			catch(e : Error)
			{
				PXDebug.ERROR(".locateXML(" + key + ") failed." + e.message, this);
			}
			return null;
		}

		/**		 * Returns the DisplayObject associated with the passed-in <code>key</code>.		 * 		 * <p>If there is no ressource identified by the passed-in key, the		 * function will return <code>null</code>.</p>		 * 		 * @param	key	identifier of the ressource to access		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function locateDisplayObject(key : String) : DisplayObject
		{
			try
			{
				return locate(key) as DisplayObject;
			}
			catch(e : Error)
			{
				PXDebug.ERROR(".locateDisplayObject(" + key + ") failed." + e.message, this);
			}
			return null;
		}

		/**		 * @inheritDoc		 */
		public function isRegistered(key : String) : Boolean
		{
			return PXCoreFactory.getInstance().isRegistered(pixlib_internal::buildResourceID(name, key));
		}

		/**		 * @inheritDoc		 */
		public function add(dico : Dictionary) : void
		{
			PXDebug.ERROR(".add() is not available in this implementation.", this);
		}

		/**		 * Clear locator references.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function clear() : void
		{
			var len : uint = _keyList.length;
			for (var i : uint = 0;i < len;i++) PXCoreFactory.getInstance().unregister(_keyList[i]);
			_keyList = [];
		}

		/**		 * Returns <code>true</code> if locator is empty.		 * 		 * @return <code>true</code> if locator is empty. 		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function isEmpty() : Boolean
		{
			return _keyList.length == 0;
		}

		/**		 * Returns locator references count.		 * 		 * @return locator references count.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function size() : uint
		{
			return _keyList.length;
		}		
		/**		 * Returns string representation of instance.		 * 		 * @return string representation of instance.		 * 		 * @langversion 3.0		 * @playerversion Flash 10		 */
		public function toString() : String
		{
			return PXStringifier.process(this) + "[" + name + "]";
		}

		// --------------------------------------------------------------------
		// Private implementation
		// --------------------------------------------------------------------		
		/**		 * @private		 */
		function PXResourceLocator(name : String)
		{
			super();
			_sName = name;
			_keyList = [];
		}

		/**		 * @private		 */
		pixlib_internal static function buildResourceID(locatorName : String, resourceID : String) : String
		{			if (locatorName != null && locatorName.length > 0 && locatorName != DEFAULT_NAME)
			{
				return "ResourceLocator(" + locatorName + "," + resourceID + ")";
			}
			return resourceID;
		}				/**		 * @private		 */		pixlib_internal static function remove( element : Object, source : Array ) : void		{			if(element == null || source == null) return;						var length : uint = source.length;						for( var i : Number = length;i > -1;i -= 1 )			{				if( source[i] === element ) source.splice(i, 1);			}		}
	}
}