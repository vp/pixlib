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
package net.pixlib.core 
{
	import net.pixlib.exceptions.PXIllegalArgumentException;
	import net.pixlib.utils.PXClassUtils;

	/**
	 * The PXTypedFactoryLocator implements Locator features using strong 
	 * type checking for ressources registered/unregistred from this locator.
	 * 
	 * <p>Only Class object can be registered in this locator.</p>
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	final public class PXTypedFactoryLocator extends PXAbstractLocator
	{
		/**
		 * Creates instance.
		 * 
		 * @param type	Allowed ressource class type
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXTypedFactoryLocator( type : Class )
		{
			super(type);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function register( key : String, element : Object ) : Boolean
		{
			if ( !( element is Class ) )
			{
				throw new PXIllegalArgumentException("register(" + key + ") fails, '" + element + "' value isn't a Class.", this);
			}
			
			var clazz : Class = element as Class;

			if ( !( isRegistered(key) ) )
			{
				if ( PXClassUtils.inherit(clazz, type))
				{
					mMap.put(key, clazz);
					return true;
				} 
				else
				{
					throw new PXIllegalArgumentException("register(" + key + ") fails, '" + clazz + "' class doesn't extend '" + type + "' class.", this);
					return false ;
				}
			} 
			else
			{
				throw new PXIllegalArgumentException("register(" + key + ") fails, key is already registered.", this);
				return false ;
			}
		}
		
		/**
		 * Builds and returns new instance of Class registered with passed-in 
		 * key identifier.
		 * 
		 * @param key	Class identifier
		 * 
		 * @return 	A new instance of Class registered with passed-in 
		 * 			key identifier.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function build( key : String ) : Object
		{
			var clazz : Class = locate(key) as Class;
			return new clazz();
		}
	}
}
