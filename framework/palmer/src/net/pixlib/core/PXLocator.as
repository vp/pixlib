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
	import flash.utils.Dictionary;		

	/**
	 * A PXLocator is an entity that points to specific kind
	 * of ressources within an application. All ressources stored by a
	 * locator is identified with a unique key.
	 * 
	 * <p>
	 * All concret locators implementations are associated with a specific
	 * types of ressources. For example, the <code>PXLoaderLocator</code>
	 * allow a single access point for all <code>PXLoader</code> instances 
	 * used in application. 
	 * </p>
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author	Francis Bourre
	 * @author	Romain Ecarnot
	 */
	public interface PXLocator
	{
		/**
		 * An <code>Array</code> view of the keys contained in locator.
		 *
		 * @return an array view of the keys contained in locator
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get keys() : Array
		
		/**
		 * An <code>Array</code> view of the values contained in locator.
		 *
		 * @return an array view of the values contained in locator
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get values() : Array
		
		/**
		 * Returns <code>true</code> is there is a ressource associated
		 * with the passed-in <code>key</code>. To avoid errors when
		 * retreiving ressources from a locator you should systematically
		 * use the <code>isRegistered</code> function to check if the
		 * ressource you would access is already accessible before any
		 * call to the <code>locate</code> function.
		 * 
		 * @param key	Ressource identifier
		 * 
		 * @return 	<code>true</code> is there is a ressource associated
		 * 			with the passed-in <code>key</code>.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function isRegistered( key : String ) : Boolean;

		/**
		 * Returns the ressource associated with the passed-in <code>key</code>.
		 * If there is no ressource identified by the passed-in key, the
		 * function will fail with an error. To avoid the throw of an exception
		 * when attempting to access to a ressource, take care to check the
		 * existence of the ressource before trying to access to it.
		 * 
		 * @param	key	identifier of the ressource to access
		 * @return	the ressource associated with the passed-in <code>key</code>
		 * @throws 	net.pixlib.exceptions.PXNoSuchElementException — There is no ressource
		 * 			associated with the passed-in key
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function locate( key : String ) : Object;

		/**
		 * Adds all ressources contained in the passed-in dictionnary
		 * into this locator instance. If there is keys used both in
		 * the locator and in the dictionnary an exception is thrown.
		 * 
		 * @param	dico	dictionnary instance which contains ressources
		 * 					to be added
		 * @throws 	net.pixlib.exceptions.PXIllegalArgumentException — One or more
		 * 			keys present in the dictionnary already exist in this
		 * 			locator instance.
		 * 			
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function add( dico : Dictionary ) : void;
	}
}