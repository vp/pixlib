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
package net.pixlib.prefs.strategy 
{
	import net.pixlib.prefs.PXPreferences;

	/**
	 * The PXPreferencesStrategy interface defines behaviour a class must be 
	 * implementes to be a PXPreference strategy compliant.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXPreferencesStrategy 
	{
		/**
		 * Indicates the method to call when data are loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function set onLoadHandler(func : Function) : void;
				
		/**
		 * Indicates the method to call when data are saved.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function set onSaveHandler(func : Function) : void;
		
		/**
		 * Loads preferences data.
		 * 
		 * @param preferences	PXPreferences object to store data
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function load(preferences : PXPreferences) : void;
		
		/**
		 * Saves preferences data.
		 * 
		 * @param preferences	PXPreferences object
		 * @param data			Data to save
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function save(preferences : PXPreferences, data : Object) : void;
		
		/**
		 * Releases instance.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function release( ) : void;
	}
}
