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
package net.pixlib.prefs.event 
{

	/**
	 * PXPreferencesListener interface defines default behaviour for object which 
	 * can be a PXPreference listener.
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public interface PXPreferencesListener 
	{
		/**
		 * Triggers when a preference value is edited (or created).
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onPreferenceEdit(event : PXPreferencesEvent) : void;

		/**
		 * Triggers when a preference is deleted.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onPreferenceDelete(event : PXPreferencesEvent) : void;

		/**
		 * Triggers when preferences are loaded.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onPreferencesLoad(event : PXPreferencesEvent) : void;

		/**
		 * Triggers when preferences are saved.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onPreferencesSave(event : PXPreferencesEvent) : void;
	}
}
