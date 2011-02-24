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
	import flash.net.registerClassAlias;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * The PXClassUtils utility class is an all-static class with methods for 
	 * working with Class objects.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Cedric Nehemie
	 * @author Francis Bourre
	 * @author Romain Ecarnot
	 */
	final public class PXClassUtils
	{		
		//--------------------------------------------------------------------
		// Private properties
		//--------------------------------------------------------------------
		
		/** @private */
		static private var _aliasCache : Dictionary = new Dictionary();

		
		//--------------------------------------------------------------------
		// Public API
		//--------------------------------------------------------------------
				
		/**
		 * Verify that the passed-in <code>clazz</code> class is a descendant of the 
		 * specified <code>parent</code> class.
		 * 
		 * @param clazz	class to check inheritance with the ascendant class
		 * @param parent	class which is the ascendant
		 * 
		 * @return <code>true</code> if passed-in <code>clazz</code> class is a 
		 * descendant of the specified <code>parent</code>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		static public function inherit( clazz : Class, parent : Class) : Boolean 
		{
			var xml : XML = describeType(clazz);
			var parentName : String = getQualifiedClassName(parent);
			return 	(xml.factory.extendsClass.@type).contains(parentName) || (xml.factory.implementsInterface.@type).contains(parentName);
		}	

		/**
		 * Preserves the class (type) of an object when the object is encoded in 
		 * Action Message Format (AMF). When you encode an object into AMF, 
		 * this function saves the alias for its class, so that you can recover 
		 * the class when decoding the object.
		 * 
		 * @param The class to register
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function registerAMFMappingClass( mappingClass : Class ) : void
		{
			var className : String = getQualifiedClassName(mappingClass).replace("::", ".");
			
			if( _aliasCache[ className ] == null )
			{
				registerClassAlias(className, mappingClass);
				
				_aliasCache[ className ] = true;
			}
		}
		
		/**
		 * Returns simple class name of passed-in value without package 
		 * informations.
		 * 
		 * @return class name of passed-in value.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * 
		 */
		public static function getClassName(value : *) : String
		{
			return getQualifiedClassName(value).split("::").pop();
		}
		
		/**
		 * @private
		 */		
		function PXClassUtils() 
		{
		}
	}
}